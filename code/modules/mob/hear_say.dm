// At minimum every mob has a hear_say proc.

/mob/proc/combine_message(var/list/message_pieces, var/verb, var/mob/speaker, always_stars = FALSE)
	var/iteration_count = 0
	var/msg = "" // This is to make sure that the pieces have actually added something
	for(var/datum/multilingual_say_piece/SP in message_pieces)
		iteration_count++
		var/piece = SP.message
		if(piece == "")
			continue

		if(SP.speaking && SP.speaking.flags & INNATE) // Fucking snowflake noise lang
			return SP.speaking.format_message(piece)

		if(iteration_count == 1)
			piece = capitalize(piece)

		if(SP.speaking)
			if(!say_understands(speaker, SP.speaking))
				if(isanimal(speaker))
					var/mob/living/simple_animal/S = speaker
					if(LAZYLEN(S.speak))
						piece = pick(S.speak)
					else
						piece = stars(piece)
				else
					piece = SP.speaking.scramble(piece)
			if(always_stars)
				piece = stars(piece)
			piece = SP.speaking.format_message(piece)
		else
			if(!say_understands(speaker, null))
				piece = stars(piece)
				if(isanimal(speaker))
					var/mob/living/simple_animal/S = speaker
					if(LAZYLEN(S.speak))
						piece = pick(S.speak)
				if(always_stars)
					piece = stars(piece)
			piece = "<span class='message'><span class='body'>[piece]</span></span>"
		msg += (piece + " ")
	if(msg == "")
		// There is literally no content left in this message, we need to shut this shit down
		. = "" // hear_say will suppress it
	else
		if(verb)
			. = "[verb], \"[trim(msg)]\""
		else
			. = trim(msg)

/mob/proc/hear_say(list/message_pieces, verb = "says", italics = 0, mob/speaker = null, sound/speech_sound, sound_vol, sound_frequency, use_voice = TRUE)
	if(!client)
		return 0

	if(isobserver(src) && client.prefs.toggles & PREFTOGGLE_CHAT_GHOSTEARS)
		if(speaker && !speaker.client && !(speaker in view(src)))
			//Does the speaker have a client?  It's either random stuff that observers won't care about (Experiment 97B says, 'EHEHEHEHEHEHEHE')
			//Or someone snoring.  So we make it where they won't hear it.
			return 0

	//make sure the air can transmit speech - hearer's side
	var/turf/T = get_turf(src)
	if(T && !isobserver(src))
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = environment ? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE && get_dist(speaker, src) > 1)
			return FALSE

		if(pressure < ONE_ATMOSPHERE * 0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
			italics = TRUE
			sound_vol *= 0.5

	if(sleeping || stat == UNCONSCIOUS)
		hear_sleep(multilingual_to_message(message_pieces))
		return 0

	var/speaker_name = speaker.name
	if(use_voice && ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()

	var/message = combine_message(message_pieces, null, speaker)
	if(message == "")
		return

	var/message_clean = message
	if(italics)
		message = "<i>[message]</i>"

	var/track = null
	if(isobserver(src))
		if(speaker_name != speaker.real_name && speaker.real_name)
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "([ghost_follow_link(speaker, ghost=src)]) "
		if(client.prefs.toggles & PREFTOGGLE_CHAT_GHOSTEARS && (speaker in view(src)))
			message = "<b>[message]</b>"

	speaker_name = colorize_name(speaker, speaker_name)

	if(!can_hear())
		// INNATE is the flag for audible-emote-language, so we don't want to show an "x talks but you cannot hear them" message if it's set
		// if(!language || !(language.flags & INNATE))
		if(speaker == src)
			to_chat(src, "<span class='warning'>Вы не слышите собственных слов!</span>")
		else
			to_chat(src, "<span class='name'>[speaker.name]</span> говор[pluralize_ru(speaker.gender,"ит","ят")], но вы [genderize_ru(speaker.gender,"его","её","его","их")] не слышите.")
	else
		to_chat(src, "<span class='game say'><span class='name'>[speaker_name]</span>[speaker.GetAltName()] [track][verb], «[message]»</span>")

		// Create map text message
		if (client?.prefs.toggles2 & PREFTOGGLE_2_RUNECHAT) // can_hear is checked up there on L99
			create_chat_message(speaker.runechat_msg_location, message_clean,FALSE, italics)

		if(speech_sound && (get_dist(speaker, src) <= world.view && src.z == speaker.z))
			var/turf/source = speaker? get_turf(speaker) : get_turf(src)
			playsound_local(source, speech_sound, sound_vol, 1, sound_frequency)

/mob/proc/colorize_name(mob/speaker = null, speaker_name)
	if(!speaker.ckey)
		return speaker_name

	if (!speaker.chat_color || speaker.chat_color_name != speaker.name)

		var/step = round(length_char(speaker_name)/3)
		var/rgb[3]
		for(var/i = 1 to 3)
			rgb[i] = text2ascii_char(speaker_name, step*i)
			if(rgb[i] > 1071) rgb[i] -= 1072
			if(rgb[i] > 1039) rgb[i] -= 1040
			if(rgb[i] > 96) rgb[i] -= 97
			if(rgb[i] > 64) rgb[i] -= 65
			if(rgb[i] > 31) rgb[i] -= 32
			rgb[i] = rgb[i]*4 + 63 // base brightness

		speaker.chat_color = rgb(rgb[1],rgb[2],rgb[3])
		speaker.chat_color_darkened = rgb(rgb[1]-23,rgb[2]-23,rgb[3]-23)
		speaker.chat_color_name = speaker_name

		return "<font color=[rgb(rgb[1],rgb[2],rgb[3])]>[speaker_name]</font>"
	else
		return "<font color=[speaker.chat_color]>[speaker_name]</font>"

/mob/proc/hear_radio(list/message_pieces, verb = "says", part_a, part_b, mob/speaker = null, hard_to_hear = 0, vname = "", atom/follow_target, radio_freq)
	if(!client)
		return

	if(sleeping || stat == UNCONSCIOUS) //If unconscious or sleeping
		hear_sleep(multilingual_to_message(message_pieces))
		return

	var/message = combine_message(message_pieces, null, speaker, always_stars = hard_to_hear)
	if(message == "")
		return

	var/track = null
	if(!follow_target)
		follow_target = speaker

	var/speaker_name = handle_speaker_name(speaker, vname, hard_to_hear)
	speaker_name = colorize_name(speaker, speaker_name)
	track = handle_track(message, verb, speaker, speaker_name, follow_target, hard_to_hear)

	if(!can_hear())
		if(prob(20))
			to_chat(src, "<span class='warning'>Вы слышите как наушник вибрирует, но из него не слышно ни звука!</span>")
	else if(track)
		to_chat(src, "[part_a][track][part_b][verb], «[message]»</span></span>")
		if(client?.prefs.toggles2 & PREFTOGGLE_2_RUNECHAT)
			create_chat_message(speaker, message, TRUE, FALSE)
	else
		to_chat(src, "[part_a][speaker_name][part_b][verb], «[message]»</span></span>")
		if(client?.prefs.toggles2 & PREFTOGGLE_2_RUNECHAT)
			create_chat_message(speaker, message, TRUE, FALSE)

/mob/proc/handle_speaker_name(mob/speaker = null, vname, hard_to_hear)
	var/speaker_name = "неизвестный"
	if(speaker)
		speaker_name = speaker.name

	if(vname)
		speaker_name = vname

	if(hard_to_hear)
		speaker_name = "неизвестный"

	return speaker_name

/mob/proc/handle_track(message, verb = "says", mob/speaker = null, speaker_name, atom/follow_target, hard_to_hear)
	return

/mob/proc/hear_sleep(message)
	var/heard = ""
	if(prob(15))
		message = strip_html_properly(message)
		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = splittext(message, " ")
		if(messages.len > 0)
			var/R = rand(1, messages.len)
			var/heardword = messages[R]
			if(copytext(heardword,1, 1) in punctuation)
				heardword = copytext(heardword,2)
			if(copytext(heardword,-1) in punctuation)
				heardword = copytext(heardword,1,length(heardword))
			heard = "<span class='game say'>…<i>Вы слышите что-то о<i>… «[heardword]»…</span>"
		else
			heard = "<span class='game say'>…<i>Вы почти смогли что-то расслышать…</i>…</span>"
	else
		heard = "<span class='game say'>…<i>Вы почти смогли разобрать чьи-то слова</i>…</span>"

	to_chat(src, heard)

/mob/proc/hear_holopad_talk(list/message_pieces, verb = "says", mob/speaker = null, obj/effect/overlay/holo_pad_hologram/H)
	if(sleeping || stat == UNCONSCIOUS)
		hear_sleep(multilingual_to_message(message_pieces))
		return

	if(!can_hear())
		return

	var/message = combine_message(message_pieces, verb, speaker)
	var/message_unverbed = combine_message(message_pieces, null, speaker)

	var/name = speaker.name
	if(!say_understands(speaker))
		name = speaker.voice_name

	if((client?.prefs.toggles2 & PREFTOGGLE_2_RUNECHAT) && can_hear())
		create_chat_message(H, message_unverbed, TRUE, FALSE)

	var/rendered = "<span class='game say'><span class='name'>[name]</span> [message]</span>"
	to_chat(src, rendered)
