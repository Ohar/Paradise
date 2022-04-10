GLOBAL_LIST_EMPTY(ai_list)
GLOBAL_LIST_INIT(ai_verbs_default, list(
	/mob/living/silicon/ai/proc/announcement,
	/mob/living/silicon/ai/proc/ai_announcement_text,
	/mob/living/silicon/ai/proc/ai_call_shuttle,
	/mob/living/silicon/ai/proc/ai_camera_track,
	/mob/living/silicon/ai/proc/ai_camera_list,
	/mob/living/silicon/ai/proc/ai_goto_location,
	/mob/living/silicon/ai/proc/ai_remove_location,
	/mob/living/silicon/ai/proc/ai_hologram_change,
	/mob/living/silicon/ai/proc/ai_network_change,
	/mob/living/silicon/ai/proc/ai_roster,
	/mob/living/silicon/ai/proc/ai_statuschange,
	/mob/living/silicon/ai/proc/ai_store_location,
	/mob/living/silicon/ai/proc/control_integrated_radio,
	/mob/living/silicon/ai/proc/core,
	/mob/living/silicon/ai/proc/pick_icon,
	/mob/living/silicon/ai/proc/sensor_mode,
	/mob/living/silicon/ai/proc/show_laws_verb,
	/mob/living/silicon/ai/proc/toggle_acceleration,
	/mob/living/silicon/ai/proc/toggle_camera_light,
	/mob/living/silicon/ai/proc/botcall,
	/mob/living/silicon/ai/proc/change_arrival_message,
	/mob/living/silicon/ai/proc/arrivals_announcement
))

//Not sure why this is necessary...
/proc/AutoUpdateAI(obj/subject)
	var/is_in_use = 0
	if(subject!=null)
		for(var/A in GLOB.ai_list)
			var/mob/living/silicon/ai/M = A
			if((M.client && M.machine == subject))
				is_in_use = 1
				subject.attack_ai(M)
	return is_in_use

/mob/living/silicon/ai
	name = "AI"
	icon = 'icons/mob/ai.dmi'//
	icon_state = "ai"
	move_resist = MOVE_FORCE_NORMAL
	density = 1
	status_flags = CANSTUN|CANPARALYSE|CANPUSH
	mob_size = MOB_SIZE_LARGE
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS
	see_in_dark = 8
	can_strip = 0
	var/list/network = list("SS13","Telecomms","Research Outpost","Mining Outpost")
	var/obj/machinery/camera/current = null
	var/list/connected_robots = list()
	var/aiRestorePowerRoutine = 0
	//var/list/laws = list()
	alarms_listend_for = list("Motion", "Fire", "Atmosphere", "Power", "Camera", "Burglar")
	var/viewalerts = 0
	var/icon/holo_icon//Default is assigned when AI is created.
	var/obj/mecha/controlled_mech //For controlled_mech a mech, to determine whether to relaymove or use the AI eye.
	var/obj/item/pda/silicon/ai/aiPDA = null
	var/obj/item/multitool/aiMulti = null
	var/custom_sprite = 0 //For our custom sprites
	var/custom_hologram = 0 //For our custom holograms
	var/on_the_card = FALSE //If our ai is on the Intelicard, or not

	var/obj/item/radio/headset/heads/ai_integrated/aiRadio = null

	//MALFUNCTION
	var/datum/module_picker/malf_picker
	var/datum/action/innate/ai/choose_modules/modules_action
	var/list/datum/AI_Module/current_modules = list()
	var/can_dominate_mechs = 0
	var/shunted = 0 //1 if the AI is currently shunted. Used to differentiate between shunted and ghosted/braindead

	var/control_disabled = 0 // Set to 1 to stop AI from interacting via Click() -- TLE
	var/malfhacking = 0 // More or less a copy of the above var, so that malf AIs can hack and still get new cyborgs -- NeoFite
	var/malf_cooldown = 0 //Cooldown var for malf modules, stores a worldtime + cooldown

	var/obj/machinery/power/apc/malfhack = null
	var/explosive = 0 //does the AI explode when it dies?

	var/mob/living/silicon/ai/parent = null
	var/camera_light_on = 0
	var/list/obj/machinery/camera/lit_cameras = list()

	var/datum/trackable/track = new()

	var/last_paper_seen = null
	var/can_shunt = 1
	var/last_announcement = ""
	var/datum/announcement/priority/announcement
	var/mob/living/simple_animal/bot/Bot
	var/turf/waypoint //Holds the turf of the currently selected waypoint.
	var/waypoint_mode = 0 //Waypoint mode is for selecting a turf via clicking.
	var/apc_override = FALSE	//hack for letting the AI use its APC even when visionless
	var/nuking = 0
	var/obj/machinery/doomsday_device/doomsday_device

	var/obj/machinery/hologram/holopad/holo = null
	var/mob/camera/aiEye/eyeobj
	var/sprint = 10
	var/cooldown = 0
	var/acceleration = 1
	var/tracking = 0 //this is 1 if the AI is currently tracking somebody, but the track has not yet been completed.

	var/obj/machinery/camera/portable/builtInCamera

	var/obj/structure/AIcore/deactivated/linked_core //For exosuit control

	/// If our AI doesn't want to be the arrivals announcer, this gets set to FALSE.
	var/announce_arrivals = TRUE
	var/arrivalmsg = "$name, $rank, прибывает на станцию."

	var/list/all_eyes = list()

/mob/living/silicon/ai/proc/add_ai_verbs()
	verbs |= GLOB.ai_verbs_default
	verbs |= silicon_subsystems

/mob/living/silicon/ai/proc/remove_ai_verbs()
	verbs -= GLOB.ai_verbs_default
	verbs -= silicon_subsystems

/mob/living/silicon/ai/New(loc, var/datum/ai_laws/L, var/obj/item/mmi/B, var/safety = 0)
	announcement = new()
	announcement.title = "Объявление ИИ"
	announcement.announcement_type = "Объявление ИИ"
	announcement.announcer = name
	announcement.newscast = 0

	var/list/possibleNames = GLOB.ai_names

	var/pickedName = null
	while(!pickedName)
		pickedName = pick(GLOB.ai_names)
		for(var/mob/living/silicon/ai/A in GLOB.mob_list)
			if(A.real_name == pickedName && possibleNames.len > 1) //fixing the theoretically possible infinite loop
				possibleNames -= pickedName
				pickedName = null

	aiPDA = new/obj/item/pda/silicon/ai(src)
	rename_character(null, pickedName)
	anchored = 1
	canmove = 0
	density = 1
	loc = loc

	holo_icon = getHologramIcon(icon('icons/mob/ai.dmi',"holo1"))

	proc_holder_list = new()

	if(L)
		if(istype(L, /datum/ai_laws))
			laws = L
	else
		make_laws()

	verbs += /mob/living/silicon/ai/proc/show_laws_verb

	aiMulti = new(src)
	aiRadio = new(src)
	common_radio = aiRadio
	aiRadio.myAi = src
	additional_law_channels["Бинарный"] = ":b "
	additional_law_channels["Голопад"] = ":h"

	aiCamera = new/obj/item/camera/siliconcam/ai_camera(src)

	if(isturf(loc))
		add_ai_verbs(src)

	//Languages
	add_language("Robot Talk", 1)
	add_language("Galactic Common", 1)
	add_language("Sol Common", 1)
	add_language("Tradeband", 1)
	add_language("Neo-Russkiya", 1)
	add_language("Gutter", 1)
	add_language("Sinta'unathi", 1)
	add_language("Siik'tajr", 1)
	add_language("Canilunzt", 1)
	add_language("Skrellian", 1)
	add_language("Vox-pidgin", 1)
	add_language("Orluum", 1)
	add_language("Rootspeak", 1)
	add_language("Trinary", 1)
	add_language("Chittin", 1)
	add_language("Bubblish", 1)
	add_language("Clownish", 1)

	if(!safety)//Only used by AIize() to successfully spawn an AI.
		if(!B)//If there is no player/brain inside.
			new/obj/structure/AIcore/deactivated(loc)//New empty terminal.
			qdel(src)//Delete AI.
			return
		else
			if(B.brainmob.mind)
				B.brainmob.mind.transfer_to(src)

			on_mob_init()

	spawn(5)
		new /obj/machinery/ai_powersupply(src)

	create_eye()

	builtInCamera = new /obj/machinery/camera/portable(src)
	builtInCamera.c_tag = name
	builtInCamera.network = list("SS13")

	GLOB.ai_list += src
	GLOB.shuttle_caller_list += src
	..()

/mob/living/silicon/ai/proc/on_mob_init()
	to_chat(src, "<B>Вы играете за ИИ станции. ИИ не может передвигаться, но может взаимодействовать с объектами, которые видит (в том числе через камеры).</B>")
	to_chat(src, "<B>Чтобы посмотреть на другие части станции, вы можете выбрать камеру из меню. Для этого кликните по себе.</B>")
	to_chat(src, "<B>Глядя через камеры, вы можете использовать большинство подключенных к сети устройств, таких как компьютеры, ЛКП, интеркомы, двери и т. д.</B>")
	to_chat(src, "Чтобы что-то использовать, просто кликните по нему.")
	to_chat(src, "Используйте <code>:b</code> для общения с другими синтетиками по бинарному каналу связи. Чтобы говорить от имени своей активной голопроекции, используйте <code>:h</code>.")
	to_chat(src, "Для доступа к радиоканалам отделов, используйте следующие команды:")

	var/radio_text = ""
	for(var/i = 1 to common_radio.channels.len)
		var/channel = common_radio.channels[i]
		var/key = get_radio_key_from_channel(channel)
		radio_text += "<code>[key]</code> — [channel]"
		if(i != common_radio.channels.len)
			radio_text += ", "

	to_chat(src, radio_text)

	show_laws()
	to_chat(src, "<b>Другие игроки могут менять эти законы. Будучи сбойным ИИ, вы тоже сможете…</b>")

	job = "AI"

/mob/living/silicon/ai/Stat()
	..()
	if(statpanel("Status"))
		if(stat)
			stat(null, text("Система нефункциональна"))
			return
		show_borg_info()

/mob/living/silicon/ai/proc/ai_alerts()
	var/list/dat = list("<HEAD><TITLE>Активные тревоги на станции</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n")
	dat += "<A HREF='?src=[UID()];mach_close=aialerts'>Закрыть</A><BR><BR>"
	var/list/list/temp_alarm_list = SSalarm.alarms.Copy()
	for(var/cat in temp_alarm_list)
		if(!(cat in alarms_listend_for))
			continue
		dat += text("<B>[]</B><BR>\n", cat)
		var/list/list/L = temp_alarm_list[cat].Copy()
		for(var/alarm in L)
			var/list/list/alm = L[alarm].Copy()
			var/area_name = alm[1]
			var/C = alm[2]
			var/list/list/sources = alm[3].Copy()
			for(var/thing in sources)
				var/atom/A = locateUID(thing)
				if(A && A.z != z)
					L -= alarm
					continue
				dat += "<NOBR>"
				if(C && islist(C))
					var/dat2 = ""
					for(var/cam in C)
						var/obj/machinery/camera/I = locateUID(cam)
						if(!QDELETED(I))
							dat2 += text("[]<A HREF=?src=[UID()];switchcamera=[cam]>[]</A>", (dat2 == "") ? "" : " | ", I.c_tag)
					dat += text("-- [] ([])", area_name, (dat2 != "") ? dat2 : "Нет камеры")
				else
					dat += text("-- [] (Нет камеры)", area_name)
				if(sources.len > 1)
					dat += text("- [] sources", sources.len)
				dat += "</NOBR><BR>\n"
		if(!L.len)
			dat += "-- Все системы исправны<BR>\n"
		dat += "<BR>\n"

	viewalerts = TRUE
	var/dat_text = dat.Join("")
	src << browse(dat_text, "window=aialerts&can_close=0")

/mob/living/silicon/ai/proc/show_borg_info()
	stat(null, text("Подключённые киборги: [connected_robots.len]"))
	for(var/thing in connected_robots)
		var/mob/living/silicon/robot/R = thing
		var/robot_status = "Исправен"
		if(R.stat || !R.client)
			robot_status = "НЕ ОТВЕЧАЕТ"
		else if(!R.cell || R.cell.charge <= 0)
			robot_status = "НЕТ ПИТАНИЯ"
		// Name, Health, Battery, Module, Area, and Status! Everything an AI wants to know about its borgies!
		var/area/A = get_area(R)
		var/area_name = A ? sanitize(A.name) : "Неизвестно"
		stat(null, text("[R.name] | Состояние: [R.health]% | Батарея: [R.cell ? "[R.cell.charge] / [R.cell.maxcharge]" : "Empty"] | \
		Module: [R.designation] | Loc: [area_name] | Status: [robot_status]"))

/mob/living/silicon/ai/rename_character(oldname, newname)
	if(!..(oldname, newname))
		return FALSE

	if(oldname != real_name)
		announcement.announcer = name

		if(eyeobj)
			eyeobj.name = "[newname] (Око ИИ)"

		// Set ai pda name
		if(aiPDA)
			aiPDA.set_name_and_job(newname, "AI")

	return TRUE

/mob/living/silicon/ai/Destroy()
	GLOB.ai_list -= src
	GLOB.shuttle_caller_list -= src
	SSshuttle.autoEvac()
	QDEL_NULL(eyeobj) // No AI, no Eye
	if(malfhacking)
		deltimer(malfhacking)
		malfhacking = null
	malfhack = null
	return ..()


/*
	The AI Power supply is a dummy object used for powering the AI since only machinery should be using power.
	The alternative was to rewrite a bunch of AI code instead here we are.
*/
/obj/machinery/ai_powersupply
	name="\improper AI power supply"
	active_power_usage=1000
	use_power = ACTIVE_POWER_USE
	power_channel = EQUIP
	var/mob/living/silicon/ai/powered_ai = null
	invisibility = 100

/obj/machinery/ai_powersupply/New(mob/living/silicon/ai/ai=null)
	powered_ai = ai
	if(isnull(powered_ai))
		qdel(src)
		return

	loc = powered_ai.loc
	use_power(1) // Just incase we need to wake up the power system.

	..()

/obj/machinery/ai_powersupply/process()
	if(!powered_ai || powered_ai.stat & DEAD)
		qdel(src)
		return
	if(!powered_ai.anchored)
		loc = powered_ai.loc
		use_power = NO_POWER_USE
	if(powered_ai.anchored)
		use_power = ACTIVE_POWER_USE

/mob/living/silicon/ai/proc/pick_icon()
	set category = "Команды ИИ"
	set name = "Задать дисплей ядра ИИ"
	if(stat || aiRestorePowerRoutine)
		return
	if(!custom_sprite) //Check to see if custom sprite time, checking the appopriate file to change a var
		var/file = file2text("config/custom_sprites.txt")
		var/lines = splittext(file, "\n")

		for(var/line in lines)
		// split & clean up
			var/list/Entry = splittext(line, ":")
			for(var/i = 1 to Entry.len)
				Entry[i] = trim(Entry[i])

			if(Entry.len < 2 || Entry[1] != "ai")			//ignore incorrectly formatted entries or entries that aren't marked for AI
				continue

			if(Entry[2] == ckey)	//They're in the list? Custom sprite time, var and icon change required
				custom_sprite = 1

	var/display_choices = list(
		"Аид",
		"Ангел",
		"АНИМА",
		"База данных",
		"Болван",
		"Гелиос",
		"Дварф",
		"Дом",
		"Зелёный",
		"Инверсия",
		"Искры",
		"Клоун",
		"Красный октябрь",
		"Красный",
		"Матрица",
		"Монохром",
		"Муррика",
		"Нега",
		"НТ 2",
		"НТ",
		"Помехи",
		"Помехи",
		"Президент",
		"Радуга",
		"Сбоймэн",
		"Сбойный триумвират",
		"Сердитый",
		"Сердцебиение",
		"Синдикот Мяу",
		"Синий",
		"Слишком глубоко",
		"Текст",
		"Триумвират",
		"Улыбан",
		"Файрвол",
		"Чужой"
		)
	if(custom_sprite)
		display_choices += "Custom"

		//if(icon_state == initial(icon_state))
	var/icontype = ""
	icontype = input("Выберите значок!", "ИИ", null, null) in display_choices
	icon = 'icons/mob/ai.dmi'	//reset this in case we were on a custom sprite and want to change to a standard one
	switch(icontype)
		if("Custom")
			icon = 'icons/mob/custom_synthetic/custom-synthetic.dmi'	//set this here so we can use the custom_sprite
			icon_state = "[ckey]-ai"
		if("Клоун")
			icon_state = "ai-clown"
		if("Монохром")
			icon_state = "ai-mono"
		if("Инверсия")
			icon_state = "ai-u"
		if("Файрвол")
			icon_state = "ai-magma"
		if("Зелёный")
			icon_state = "ai-weird"
		if("Красный")
			icon_state = "ai-red"
		if("Помехи")
			icon_state = "ai-static"
		if("Текст")
			icon_state = "ai-text"
		if("Улыбан")
			icon_state = "ai-smiley"
		if("Матрица")
			icon_state = "ai-matrix"
		if("Сердитый")
			icon_state = "ai-angryface"
		if("Дварф")
			icon_state = "ai-dorf"
		if("Нега")
			icon_state = "ai-bliss"
		if("Триумвират")
			icon_state = "ai-triumvirate"
		if("Сбойный триумвират")
			icon_state = "ai-triumvirate-malf"
		if("Красный октябрь")
			icon_state = "ai-redoctober"
		if("Искры")
			icon_state = "ai-sparkles"
		if("АНИМА")
			icon_state = "ai-anima"
		if("Президент")
			icon_state = "ai-president"
		if("НТ")
			icon_state = "ai-nt"
		if("НТ 2")
			icon_state = "ai-nanotrasen"
		if("Радуга")
			icon_state = "ai-rainbow"
		if("Ангел")
			icon_state = "ai-angel"
		if("Сердцебиение")
			icon_state = "ai-heartline"
		if("Аид")
			icon_state = "ai-hades"
		if("Гелиос")
			icon_state = "ai-helios"
		if("Синдикот Мяу")
			icon_state = "ai-syndicatmeow"
		if("Слишком глубоко")
			icon_state = "ai-toodeep"
		if("Болван")
			icon_state = "ai-goon"
		if("Муррика")
			icon_state = "ai-murica"
		if("Помехи")
			icon_state = "ai-fuzz"
		if("Сбоймэн")
			icon_state = "ai-glitchman"
		if("Дом")
			icon_state = "ai-house"
		if("База данных")
			icon_state = "ai-database"
		if("Чужой")
			icon_state = "ai-alien"
		else
			icon_state = "ai"
	//else
//			to_chat(usr, "You can only change your display once!")
			//return

// this verb lets the ai see the stations manifest
/mob/living/silicon/ai/proc/ai_roster()
	set name = "Показать список экипажа"
	set category = "Команды ИИ"
	show_station_manifest()

/mob/living/silicon/ai/var/message_cooldown = 0
/mob/living/silicon/ai/proc/ai_announcement_text()
	set category = "Команды ИИ"
	set name = "Сделать объявление"

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	if(message_cooldown)
		to_chat(src, "<span class='warning'>Пожалуйста, подождите одну минуту между объявлениями.</span>")
		return

	var/input = input(usr, "Напишите сообщение, которое нужно объявить всему экипажу станции.", "Объявление ИИ") as message|null
	if(!input)
		return

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	announcement.Announce(input)
	message_cooldown = 1
	spawn(600)//One minute cooldown
		message_cooldown = 0

/mob/living/silicon/ai/proc/ai_call_shuttle()
	set name = "Вызвать экстренный шаттл"
	set category = "Команды ИИ"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/input = clean_input("Пожалуйста, укажите причину вызова шаттла.", "Причина вызова шаттла.","")
	if(!input || stat)
		return

	if(check_unable(AI_CHECK_WIRELESS))
		return

	call_shuttle_proc(src, input)

	return

/mob/living/silicon/ai/proc/ai_cancel_call()
	set name = "Отозвать экстренный шаттл"
	set category = "Команды ИИ"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Вы точно хотите отозвать шаттл?", "Подтвердите отзыв шаттла", "Да, отозвать", "Нет, не отзывать")

	if(check_unable(AI_CHECK_WIRELESS))
		return

	if(confirm == "Yes")
		cancel_call_proc(src)

/mob/living/silicon/ai/cancel_camera()
	view_core()

/mob/living/silicon/ai/verb/toggle_anchor()
	set category = "Команды ИИ"
	set name = "Переключить крепление к полу"

	if(!isturf(loc)) // if their location isn't a turf
		return // stop

	if(anchored)
		anchored = FALSE
	else
		anchored = TRUE

	to_chat(src, "[anchored ? "<b>Вы прикрепились к полу.</b>" : "<b>Вы открепились от пола.</b>"]")

/mob/living/silicon/ai/update_canmove()
	return FALSE

/mob/living/silicon/ai/proc/announcement()
	set name = "Объявление"
	set desc = "Создайте голосовое объявление, комбинируя предложения из допустимых слов (English only)."
	set category = "Команды ИИ"

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	ai_announcement()

/mob/living/silicon/ai/check_eye(mob/user)
	if(!current)
		return null
	user.reset_perspective(current)
	return TRUE

/mob/living/silicon/ai/blob_act(obj/structure/blob/B)
	if(stat != DEAD)
		adjustBruteLoss(60)
		updatehealth()
		return 1
	return 0

/mob/living/silicon/ai/restrained()
	return FALSE

/mob/living/silicon/ai/emp_act(severity)
	..()
	if(prob(30))
		switch(pick(1,2))
			if(1)
				view_core()
			if(2)
				ai_call_shuttle()

/mob/living/silicon/ai/ex_act(severity)
	..()

	switch(severity)
		if(1.0)
			gib()
		if(2.0)
			if(stat != 2)
				adjustBruteLoss(60)
				adjustFireLoss(60)
		if(3.0)
			if(stat != 2)
				adjustBruteLoss(30)

	return


/mob/living/silicon/ai/Topic(href, href_list)
	if(usr != src)
		return
	..()
	if(href_list["mach_close"])
		if(href_list["mach_close"] == "aialerts")
			viewalerts = 0
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)
	if(href_list["switchcamera"])
		switchCamera(locate(href_list["switchcamera"])) in GLOB.cameranet.cameras
	if(href_list["showalerts"])
		ai_alerts()
	if(href_list["show_paper"])
		if(last_paper_seen)
			src << browse(last_paper_seen, "window=show_paper")
	//Carn: holopad requests
	if(href_list["jumptoholopad"])
		var/obj/machinery/hologram/holopad/H = locate(href_list["jumptoholopad"])
		if(stat == CONSCIOUS)
			if(H)
				H.attack_ai(src) //may as well recycle
			else
				to_chat(src, "<span class='notice'>Не удалось найти голопад.</span>")

	if(href_list["say_word"])
		play_vox_word(href_list["say_word"], null, src)
		return

	if(href_list["track"])
		var/mob/living/target = locate(href_list["track"]) in GLOB.mob_list
		if(target && target.can_track())
			ai_actual_track(target)
		else
			to_chat(src, "<span class='warning'>Цель вне области видимости активных камер станции.</span>")
		return

	if(href_list["trackbot"])
		var/mob/living/simple_animal/bot/target = locate(href_list["trackbot"]) in GLOB.bots_list
		if(target)
			ai_actual_track(target)
		else
			to_chat(src, "<span class='warning'>Цель вне области видимости активных камер станции.</span>")
		return

	if(href_list["callbot"]) //Command a bot to move to a selected location.
		Bot = locate(href_list["callbot"]) in GLOB.bots_list
		if(!Bot || Bot.remote_disabled || control_disabled)
			return //True if there is no bot found, the bot is manually emagged, or the AI is carded with wireless off.
		waypoint_mode = 1
		to_chat(src, "<span class='notice'>Установите точку назначения, кликнув по месту без препятствий.</span>")
		return

	if(href_list["interface"]) //Remotely connect to a bot!
		Bot = locate(href_list["interface"]) in GLOB.bots_list
		if(!Bot || Bot.remote_disabled || control_disabled)
			return
		Bot.attack_ai(src)

	if(href_list["botrefresh"]) //Refreshes the bot control panel.
		botcall()
		return

	if(href_list["ai_take_control"]) //Mech domination

		var/obj/mecha/M = locate(href_list["ai_take_control"])

		if(!M)
			return

		var/mech_has_controlbeacon = FALSE
		for(var/obj/item/mecha_parts/mecha_tracking/ai_control/A in M.trackers)
			mech_has_controlbeacon = TRUE
			break
		if(!can_dominate_mechs && !mech_has_controlbeacon)
			message_admins("Warning: possible href exploit by [key_name(usr)] - attempted control of a mecha without can_dominate_mechs or a control beacon in the mech.")
			log_debug("Warning: possible href exploit by [key_name(usr)] - attempted control of a mecha without can_dominate_mechs or a control beacon in the mech.")
			return

		if(controlled_mech)
			to_chat(src, "<span class='warning'>Вы уже загружены в бортовой компьютер!</span>")
			return
		if(!GLOB.cameranet.checkCameraVis(M))
			to_chat(src, "<span class='warning'>Экзокостюм находится вне области видимости активных камер.</span>")
			return
		if(lacks_power())
			to_chat(src, "<span class='warning'>Ваше питание отключено!</span>")
			return
		if(!isturf(loc))
			to_chat(src, "<span class='warning'>Вы вне своего ядра!</span>")
			return
		if(M)
			M.transfer_ai(AI_MECH_HACK, src, usr) //Called om the mech itself.

	else if(href_list["faketrack"])
		var/mob/target = locate(href_list["track"]) in GLOB.mob_list
		var/mob/living/silicon/ai/A = locate(href_list["track2"]) in GLOB.mob_list
		if(A && target)

			A.cameraFollow = target
			to_chat(A, "Начато отслеживание [target.name] по камерам.")
			if(usr.machine == null)
				usr.machine = usr

			while(cameraFollow == target)
				to_chat(usr, "Цель вне области видимости активных камер станции. We'll check again in 5 seconds (unless you use the cancel-camera verb).")
				sleep(40)
				continue

	else if(href_list["open"])
		var/mob/target = locate(href_list["open"]) in GLOB.mob_list
		if(target)
			open_nearest_door(target)

/mob/living/silicon/ai/bullet_act(var/obj/item/projectile/Proj)
	..(Proj)
	return 2

/mob/living/silicon/ai/reset_perspective(atom/A)
	if(camera_light_on)
		light_cameras()
	if(istype(A, /obj/machinery/camera))
		current = A

	. = ..()
	if(.)
		if(!A && isturf(loc) && eyeobj)
			client.eye = eyeobj
			client.perspective = MOB_PERSPECTIVE
			eyeobj.get_remote_view_fullscreens(src)

/mob/living/silicon/ai/proc/botcall()
	set category = "Команды ИИ"
	set name = "Управление роботами"
	set desc = "Беспроводное управление различными автоматическими роботами."
	if(stat == 2)
		to_chat(src, "<span class='danger'>Критическая ошибка. Система отключена..</span>")
		return

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	var/d
	var/area/bot_area
	d += "<A HREF=?src=[UID()];botrefresh=\ref[Bot]>Обновить подключение</A><br>"
	d += "<table width='100%'><tr><td width='40%'><h3>Название</h3></td><td width='20%'><h3>Статус</h3></td><td width='30%'><h3>Местоположение</h3></td><td width='10%'><h3>Управление</h3></td></tr>"

	for(var/mob/living/simple_animal/bot/Bot in GLOB.bots_list)
		if(is_ai_allowed(Bot.z) && !Bot.remote_disabled) //Only non-emagged bots on the allowed Z-level are detected!
			bot_area = get_area(Bot)
			d += "<tr><td width='30%'>[Bot.hacked ? "<span class='bad'>(!) </span>[Bot.name]" : Bot.name] ([Bot.model])</td>"
			//If the bot is on, it will display the bot's current mode status. If the bot is not mode, it will just report "Idle". "Inactive if it is not on at all.
			d += "<td width='20%'>[Bot.on ? "[Bot.mode ? "<span class='average'>[ Bot.mode_name[Bot.mode] ]</span>": "<span class='good'>Простаивает</span>"]" : "<span class='bad'>Неактивен</span>"]</td>"
			d += "<td width='30%'>[bot_area.name]</td>"
			d += "<td width='10%'><A HREF=?src=[UID()];interface=\ref[Bot]>Интерфейс</A></td>"
			d += "<td width='10%'><A HREF=?src=[UID()];callbot=\ref[Bot]>Вызвать</A></td>"
			d += "</tr>"
			d = format_text(d)

	var/datum/browser/popup = new(src, "botcall", "Удалённое управление роботами", 700, 400)
	popup.set_content(d)
	popup.open()

/mob/living/silicon/ai/proc/set_waypoint(atom/A)
	var/turf/turf_check = get_turf(A)
		//The target must be in view of a camera or near the core.
	if(turf_check in range(get_turf(src)))
		call_bot(turf_check)
	else if(GLOB.cameranet && GLOB.cameranet.checkTurfVis(turf_check))
		call_bot(turf_check)
	else
		to_chat(src, "<span class='danger'>Выбранное местоположение больше не видимо.</span>")

/mob/living/silicon/ai/proc/call_bot(turf/waypoint)

	if(!Bot)
		return

	if(Bot.calling_ai && Bot.calling_ai != src) //Prevents an override if another AI is controlling this bot.
		to_chat(src, "<span class='danger'>Ошибка интерфейса. Юнит уже используется.</span>")
		return

	Bot.call_bot(src, waypoint)

/mob/living/silicon/ai/alarm_triggered(src, class, area/A, list/O, obj/alarmsource)
	if(!(class in alarms_listend_for))
		return
	if(alarmsource.z != z)
		return
	if(stat == DEAD)
		return TRUE
	if(O)
		var/obj/machinery/camera/C = locateUID(O[1])
		if(O.len == 1 && !QDELETED(C) && C.can_use())
			queueAlarm("--- [class] тревога обнаружена в [A.name]! (<A HREF=?src=[UID()];switchcamera=[O[1]]>[C.c_tag]</A>)", class)
		else if(O && O.len)
			var/foo = 0
			var/dat2 = ""
			for(var/thing in O)
				var/obj/machinery/camera/I = locateUID(thing)
				if(!QDELETED(I))
					dat2 += text("[]<A HREF=?src=[UID()];switchcamera=[thing]>[]</A>", (!foo) ? "" : " | ", I.c_tag)	//I'm not fixing this shit...
					foo = 1
			queueAlarm(text ("--- [] тревога обнаружена в []! ([])", class, A.name, dat2), class)
		else
			queueAlarm(text("--- [] тревога обнаружена в []! (Нет камеры)", class, A.name), class)
	else
		queueAlarm(text("--- [] тревога обнаружена в []! (Нет камеры)", class, A.name), class)
	if(viewalerts)
		ai_alerts()

/mob/living/silicon/ai/alarm_cancelled(src, class, area/A, obj/origin, cleared)
	if(cleared)
		if(!(class in alarms_listend_for))
			return
		if(origin.z != z)
			return
		queueAlarm("--- [class] тревога в [A.name] снята.", class, 0)
		if(viewalerts)
			ai_alerts()

/mob/living/silicon/ai/proc/switchCamera(obj/machinery/camera/C)

	if(!tracking)
		cameraFollow = null

	if(QDELETED(C) || stat == DEAD) //C.can_use())
		return FALSE

	if(!eyeobj)
		view_core()
		return
	// ok, we're alive, camera is good and in our network...
	eyeobj.setLoc(get_turf(C))
	//machine = src

	return TRUE

//Replaces /mob/living/silicon/ai/verb/change_network() in ai.dm & camera.dm
//Adds in /mob/living/silicon/ai/proc/ai_network_change() instead
//Addition by Mord_Sith to define AI's network change ability
/mob/living/silicon/ai/proc/ai_network_change()
	set category = "Команды ИИ"
	set name = "Переключить сеть камер"
	unset_machine()
	var/cameralist[0]

	if(check_unable())
		return

	if(usr.stat == 2)
		to_chat(usr, "Вы не можете изменить текущую сеть камер, ввиду своей смерти!")
		return

	var/mob/living/silicon/ai/U = usr

	for(var/obj/machinery/camera/C in GLOB.cameranet.cameras)
		if(!C.can_use())
			continue

		var/list/tempnetwork = difflist(C.network,GLOB.restricted_camera_networks,1)
		if(tempnetwork.len)
			for(var/i in tempnetwork)
				cameralist[i] = i
	var/old_network = network
	network = input(U, "Which network would you like to view?") as null|anything in cameralist
	network = input(U, "На какую сеть вы хотите переключиться?") as null|anything in cameralist

	if(check_unable())
		return

	if(!U.eyeobj)
		U.view_core()
		return

	if(isnull(network))
		network = old_network // If nothing is selected
	else
		for(var/obj/machinery/camera/C in GLOB.cameranet.cameras)
			if(!C.can_use())
				continue
			if(network in C.network)
				U.eyeobj.setLoc(get_turf(C))
				break
	to_chat(src, "<span class='notice'>Переключение на сеть камер «[network]».</span>")
//End of code by Mord_Sith

/mob/living/silicon/ai/proc/ai_statuschange()
	set category = "Команды ИИ"
	set name = "Статус ИИ"

	if(usr.stat == 2)
		to_chat(usr, "Вы не можете изменить текущую эмоциональный статус, ввиду своей смерти!")
		return

	if(check_unable())
		return

	var/list/ai_emotions = list("Очень счастливый", "Счастливый", "Нейтральный", "Неуверенный", "Смущённый", "Грустный", "Удивлённый", "BSOD", "Пустой", "Проблемы?", "Клёвый", "Урист", "Рукалицо", "Большой брат", "Пиво", "Дварф", "Аквариум", "Шляпка", "Трибунал")
	var/emote = input("Выберите статус!", "Статус ИИ", null, null) in ai_emotions

	if(check_unable())
		return

	for(var/obj/machinery/M in GLOB.machines) //change status
		if(istype(M, /obj/machinery/ai_status_display))
			var/obj/machinery/ai_status_display/AISD = M
			AISD.emotion = emote
		//if Friend Computer, change ALL displays
		else if(istype(M, /obj/machinery/status_display))

			var/obj/machinery/status_display/SD = M
			if(emote=="Friend Computer")
				SD.friendc = 1
			else
				SD.friendc = 0
	return

//I am the icon meister. Bow fefore me.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set name = "Сменить голограмму"
	set desc = "Смена голограммы ИИ по-умолчанию на какую-то другую."
	set category = "Команды ИИ"

	if(check_unable())
		return
	if(!custom_hologram) //Check to see if custom sprite time, checking the appopriate file to change a var
		var/file = file2text("config/custom_sprites.txt")
		var/lines = splittext(file, "\n")

		for(var/line in lines)
		// split & clean up
			var/list/Entry = splittext(line, ":")
			for(var/i = 1 to Entry.len)
				Entry[i] = trim(Entry[i])

			if(Entry.len < 2 || Entry[1] != "hologram")
				continue

			if (Entry[2] == ckey) //Custom holograms
				custom_hologram = 1  // option is given in hologram menu

	var/input
	switch(alert("Вы хотите выбрать голограмму в виде члена экипажа, животного или уникальный аватар?",,"Член экипажа","Уникальная","Животное"))
		if("Член экипажа")
			var/personnel_list[] = list()

			for(var/datum/data/record/t in GLOB.data_core.locked)//Look in data core locked.
				personnel_list["[t.fields["name"]]: [t.fields["rank"]]"] = t.fields["image"]//Pull names, rank, and image.

			if(personnel_list.len)
				input = input("Выберите члена экипажа:") as null|anything in personnel_list
				var/icon/character_icon = personnel_list[input]
				if(character_icon)
					qdel(holo_icon)//Clear old icon so we're not storing it in memory.
					holo_icon = getHologramIcon(icon(character_icon))
			else
				alert("Подходящих записей не обнаружено. Отмена.")

		if("Животное")
			var/icon_list[] = list(
			"Гусь",
			"Индейка",
			"Карп",
			"Коза",
			"Корги",
			"Корова",
			"Котёнок",
			"Котёнок №2",
			"Краб",
			"Курица",
			"Лиса",
			"Медведь",
            "Мопс",
			"Морской котик",
			"Олень",
			"Паук",
			"Попугай",
			"Свинья"
			)

			input = input("Выберите голограмму:") as null|anything in icon_list
			if(input)
				qdel(holo_icon)
				switch(input)
					if("Медведь")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"bear"))
					if("Карп")
						holo_icon = getHologramIcon(icon('icons/mob/carp.dmi',"carp"))
					if("Курица")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"chicken_brown"))
					if("Корги")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"corgi"))
					if("Корова")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"cow"))
					if("Краб")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"crab"))
					if("Олень")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"deer"))
					if("Лиса")
						holo_icon = getHologramIcon(icon('icons/mob/pets.dmi',"fox"))
					if("Коза")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"goat"))
					if("Goose")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"goose"))
					if("Котёнок")
						holo_icon = getHologramIcon(icon('icons/mob/pets.dmi',"cat"))
					if("Котёнок №2")
						holo_icon = getHologramIcon(icon('icons/mob/pets.dmi',"cat2"))
					if("Свинья")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"pig"))
					if("Попугай")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"parrot_fly"))
					if("Мопс")
						holo_icon = getHologramIcon(icon('icons/mob/pets.dmi',"pug"))
					if("Морской котик")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"seal"))
					if("Паук")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"guard"))
					if("Индейка")
						holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"turkey"))

		else
			var/icon_list[] = list(
			"По-умолчанию",
			"Жнец",
			"Королева ксеноморфов",
			"Летающее лицо",
			"Потусторонний"
			)
			if(custom_hologram) //insert custom hologram
				icon_list.Add("Настраиваемая")

			input = input("Выберите голограмму:") as null|anything in icon_list
			if(input)
				qdel(holo_icon)
				switch(input)
					if("По-умолчанию")
						holo_icon = getHologramIcon(icon('icons/mob/ai.dmi',"holo1"))
					if("Летающее лицо")
						holo_icon = getHologramIcon(icon('icons/mob/ai.dmi',"holo2"))
					if("Королева ксеноморфов")
						holo_icon = getHologramIcon(icon('icons/mob/ai.dmi',"holo3"))
					if("Потусторонний")
						holo_icon = getHologramIcon(icon('icons/mob/ai.dmi',"holo4"))
					if("Жнец")
						holo_icon = getHologramIcon(icon('icons/mob/ancient_machine.dmi', "ancient_machine"))
					if("Настраиваемая")
						if("[ckey]-ai-holo" in icon_states('icons/mob/custom_synthetic/custom-synthetic.dmi'))
							holo_icon = getHologramIcon(icon('icons/mob/custom_synthetic/custom-synthetic.dmi', "[ckey]-ai-holo"))
						else if("[ckey]-ai-holo" in icon_states('icons/mob/custom_synthetic/custom-synthetic64.dmi'))
							holo_icon = getHologramIcon(icon('icons/mob/custom_synthetic/custom-synthetic64.dmi', "[ckey]-ai-holo"))
						else
							holo_icon = getHologramIcon(icon('icons/mob/ai.dmi',"holo1"))

	return


//Toggles the luminosity and applies it by re-entereing the camera.
/mob/living/silicon/ai/proc/toggle_camera_light()
	set name = "Переключить подсветку камер"
	set desc = "Переключает подсветку на камерах по всей станции."
	set category = "Команды ИИ"

	if(stat != CONSCIOUS)
		return

	camera_light_on = !camera_light_on

	if(!camera_light_on)
		to_chat(src, "Подсветка камер отключена.")

		for(var/obj/machinery/camera/C in lit_cameras)
			C.set_light(0)
			lit_cameras = list()

		return

	light_cameras()

	to_chat(src, "Подсветка камер включена.")

/mob/living/silicon/ai/proc/set_syndie_radio()
	if(aiRadio)
		aiRadio.make_syndie()

/mob/living/silicon/ai/proc/sensor_mode()
	set name = "Задать тип сенсоров"
	set desc = "Обогатить поток визуальной информации дополнительными слоями данных."
	set category = "Команды ИИ"
	toggle_sensor_mode()

/mob/living/silicon/ai/proc/arrivals_announcement()
	set name = "Вкл/Выкл оповещения о прибытии"
	set desc = "Включает или отключает оповещения о прибытии новых членов экипажа и киборгов."
	set category = "Команды ИИ"
	announce_arrivals = !announce_arrivals
	to_chat(usr, "Система оповещений о прибытии [announce_arrivals ? "включена" : "отключена"]")

/mob/living/silicon/ai/proc/change_arrival_message()
	set name = "Задать оповещение о прибытии"
	set desc = "Изменить шаблон оповещения о прибытии на станцию нового члена экипажа."
	set category = "Команды ИИ"

	var/newmsg = clean_input("Каким вы хотите оповещение о прибытии? Список доступных параметров: $name, $rank, $species, $gender, $age", "Изменить оповещение о прибытии", arrivalmsg)
	if(newmsg != arrivalmsg)
		arrivalmsg = newmsg
		to_chat(usr, "Шаблон оповещения о прибытии был успешно изменён.")

// Handled camera lighting, when toggled.
// It will get the nearest camera from the eyeobj, lighting it.

/mob/living/silicon/ai/proc/light_cameras()
	var/list/obj/machinery/camera/add = list()
	var/list/obj/machinery/camera/remove = list()
	var/list/obj/machinery/camera/visible = list()
	for(var/datum/camerachunk/CC in eyeobj.visibleCameraChunks)
		for(var/obj/machinery/camera/C in CC.cameras)
			if(!C.can_use() || get_dist(C, eyeobj) > 7)
				continue
			visible |= C

	add = visible - lit_cameras
	remove = lit_cameras - visible

	for(var/obj/machinery/camera/C in remove)
		lit_cameras -= C //Removed from list before turning off the light so that it doesn't check the AI looking away.
		C.Togglelight(0)
	for(var/obj/machinery/camera/C in add)
		C.Togglelight(1)
		lit_cameras |= C


/mob/living/silicon/ai/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/wrench))
		if(anchored)
			user.visible_message("<span class='notice'>[user] начинает откручивать [src] от пола…</span>")
			if(!do_after(user, 40 * W.toolspeed, target = src))
				user.visible_message("<span class='notice'>[user] решает не откручивать [src].</span>")
				return
			user.visible_message("<span class='notice'>[user] заканчивает откручивать [src] от пола!</span>")
			anchored = FALSE
			return
		else
			user.visible_message("<span class='notice'>[user] начинает прикручивать [src] к полу…</span>")
			if(!do_after(user, 40 * W.toolspeed, target = src))
				user.visible_message("<span class='notice'>[user] решает не прикручивать [src].</span>")
				return
			user.visible_message("<span class='notice'>[user] заканчивает прикручивать [src] к полу!</span>")
			anchored = TRUE
			return
	else
		return ..()

/mob/living/silicon/ai/welder_act()
	return

/mob/living/silicon/ai/proc/control_integrated_radio()
	set name = "Настройки радио"
	set desc = "Позволяет изменять настройки вашего радио."
	set category = "Команды ИИ"

	if(check_unable(AI_CHECK_RADIO))
		return

	to_chat(src, "Доступ к управлению подпространственным приёмопередатчиком…")
	if(aiRadio)
		aiRadio.interact(src)


/mob/living/silicon/ai/proc/check_unable(flags = 0)
	if(stat == DEAD)
		to_chat(src, "<span class='warning'>Вы мертвы!</span>")
		return TRUE

	if(lacks_power())
		to_chat(src, "<span class='warning'>Сбой системы питания!</span>")
		return TRUE

	if((flags & AI_CHECK_WIRELESS) && control_disabled)
		to_chat(src, "<span class='warning'>Беспроводное управление отключено!</span>")
		return TRUE
	if((flags & AI_CHECK_RADIO) && aiRadio.disabledAi)
		to_chat(src, "<span class='warning'>Системная ошибка — приёмопередатчик отключён!</span>")
		return TRUE
	return FALSE

/mob/living/silicon/ai/proc/is_in_chassis()
	return isturf(loc)

/mob/living/silicon/ai/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	if(!..())
		return
	if(interaction == AI_TRANS_TO_CARD)//The only possible interaction. Upload AI mob to a card.
		if(!mind)
			to_chat(user, "<span class='warning'>Признаки интеллекта не обнаружены.</span>")//No more magical carding of empty cores, AI RETURN TO BODY!!!11
			return
		new /obj/structure/AIcore/deactivated(loc)//Spawns a deactivated terminal at AI location.
		on_the_card = TRUE
		aiRestorePowerRoutine = 0//So the AI initially has power.
		update_blind_effects()
		control_disabled = 1//Can't control things remotely if you're stuck in a card!
		aiRadio.disabledAi = 1 	//No talking on the built-in radio for you either!
		forceMove(card) //Throw AI into the card.
		to_chat(src, "Вы были загружены на мобильное запоминающее устройство. Соединение с удалёнными устройствами разорвано.")
		to_chat(user, "<span class='boldnotice'>Перенос успешен</span>: ИИ [name] ([rand(1000,9999)].exe) удалён из серверного терминала и сохранён в на переносном устройстве.")

/mob/living/silicon/ai/can_buckle()
	return FALSE

/mob/living/silicon/ai/switch_to_camera(obj/machinery/camera/C)
	if(!C.can_use() || !is_in_chassis())
		return FALSE

	eyeobj.setLoc(get_turf(C))
	client.eye = eyeobj
	return TRUE


/mob/living/silicon/ai/proc/can_see(atom/A)
	if(isturf(loc)) //AI in core, check if on cameras
		//get_turf_pixel() is because APCs in maint aren't actually in view of the inner camera
		//apc_override is needed here because AIs use their own APC when depowered
		var/turf/T = isturf(A) ? A : get_turf_pixel(A)
		return (GLOB.cameranet && GLOB.cameranet.checkTurfVis(T)) || apc_override
	//AI is carded/shunted
	//view(src) returns nothing for carded/shunted AIs and they have x-ray vision so just use get_dist
	var/list/viewscale = getviewsize(client.view)
	return get_dist(src, A) <= max(viewscale[1]*0.5,viewscale[2]*0.5)

/mob/living/silicon/ai/proc/relay_speech(mob/living/M, list/message_pieces, verb)
	var/message = combine_message(message_pieces, verb, M)
	var/name_used = M.GetVoice()
	//This communication is imperfect because the holopad "filters" voices and is only designed to connect to the master only.
	var/rendered = "<i><span class='game say'>Ретранслированная речь: <span class='name'>[name_used]</span> [message]</span></i>"
	if(client?.prefs.toggles2 & PREFTOGGLE_2_RUNECHAT)
		var/message_clean = combine_message(message_pieces, null, M)
		create_chat_message(M.runechat_msg_location, message_clean,TRUE, FALSE)
	show_message(rendered, 2)

/mob/living/silicon/ai/proc/malfhacked(obj/machinery/power/apc/apc)
	malfhack = null
	malfhacking = 0
	clear_alert("hackingapc")

	if(!istype(apc) || QDELETED(apc) || apc.stat & BROKEN)
		to_chat(src, "<span class='danger'>Взлом отменён. Выбранный ЛКП больше не присутствует в энергосети.</span>")
		playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 50, 1)
	else if(apc.aidisabled)
		to_chat(src, "<span class='danger'>Взлом отменён. Связь наших систем с [apc] прервана.</span>")
		playsound(get_turf(src), 'sound/machines/buzz-sigh.ogg', 50, 1)
	else
		malf_picker.processing_time += 10

		apc.malfai = parent || src
		apc.malfhack = TRUE
		apc.locked = TRUE

		playsound(get_turf(src), 'sound/machines/ding.ogg', 50, 1)
		to_chat(src, "Взлом завершён. [apc] теперь исключительно под вашим контролем.")
		apc.update_icon()

/mob/living/silicon/ai/proc/add_malf_picker()
	to_chat(src, "В правом верхнем углу экрана вы найдете вкладку «Сбой», где вы можете приобрести различные способности, от улучшенного наблюдения до уничтожающего станцию устройства судного дня.")
	to_chat(src, "Вы также можете взламывать ЛКП, получая дополнительные очки, для приобретения сбойных способностей. Но учтите, что взломанный ЛКП выдаст вас, если его заметит экипаж. Взлом одного ЛКП занимает 60 секунд.")
	view_core() //A BYOND bug requires you to be viewing your core before your verbs update
	malf_picker = new /datum/module_picker
	modules_action = new(malf_picker)
	modules_action.Grant(src)

///Removes all malfunction-related /datum/action's from the target AI.
/mob/living/silicon/ai/proc/remove_malf_abilities()
	QDEL_NULL(modules_action)
	for(var/datum/AI_Module/AM in current_modules)
		for(var/datum/action/A in actions)
			if(istype(A, initial(AM.power_type)))
				qdel(A)

/mob/living/silicon/ai/proc/open_nearest_door(mob/living/target)
	if(!istype(target))
		return

	if(target && target.can_track())
		var/obj/machinery/door/airlock/A = null

		var/dist = -1
		for(var/obj/machinery/door/airlock/D in range(3, target))
			if(!D.density)
				continue

			var/curr_dist = get_dist(D, target)

			if(dist < 0)
				dist = curr_dist
				A = D
			else if(dist > curr_dist)
				dist = curr_dist
				A = D

		if(istype(A))
			switch(alert(src, "Вы хотите открыть шлюз [A] для [target]?", "ДвернаяРучка_v2a.exe", "Да", "Нет"))
				if("Да")
					if(!A.density)
						to_chat(src, "<span class='notice'>Шлюз [A] уже открыт.</span>")
					else if(A.open_close(src))
						to_chat(src, "<span class='notice'>Вы открываете шлюз [A] для [target].</span>")
				else
					to_chat(src, "<span class='warning'>Вы отклоняете запрос.</span>")
		else
			to_chat(src, "<span class='warning'>Шлюзы рядом c [target] не обнаружены.</span>")

	else
		to_chat(src, "<span class='warning'>Цель вне области видимости активных камер станции.</span>")

/mob/living/silicon/ai/proc/camera_visibility(mob/camera/aiEye/moved_eye)
	GLOB.cameranet.visibility(moved_eye, client, all_eyes)

/mob/living/silicon/ai/handle_fire()
	return

/mob/living/silicon/ai/update_fire()
	return

/mob/living/silicon/ai/IgniteMob()
	return FALSE

/mob/living/silicon/ai/ExtinguishMob()
	return


/mob/living/silicon/ai/update_sight()
	if(!client)
		return

	if(stat == DEAD)
		grant_death_vision()
		return

	see_invisible = initial(see_invisible)
	see_in_dark = initial(see_in_dark)
	sight = initial(sight)
	lighting_alpha = initial(lighting_alpha)

	if(aiRestorePowerRoutine)
		sight = sight &~ SEE_TURFS
		sight = sight &~ SEE_MOBS
		sight = sight &~ SEE_OBJS
		see_in_dark = 0

	SEND_SIGNAL(src, COMSIG_MOB_UPDATE_SIGHT)
	sync_lighting_plane_alpha()


/mob/living/silicon/ai/update_runechat_msg_location()
	if(istype(loc, /obj/item/aicard) || ismecha(loc))
		runechat_msg_location = loc
	else
		runechat_msg_location = src
