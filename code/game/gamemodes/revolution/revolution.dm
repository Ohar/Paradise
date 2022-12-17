// To add a rev to the list of revolutionaries, make sure it's rev (with if(ticker.mode.name == "revolution)),
// then call ticker.mode:add_revolutionary(_THE_PLAYERS_MIND_)
// nothing else needs to be done, as that proc will check if they are a valid target.
// Just make sure the converter is a head before you call it!
// To remove a rev (from brainwashing or w/e), call ticker.mode:remove_revolutionary(_THE_PLAYERS_MIND_),
// this will also check they're not a head, so it can just be called freely

/datum/game_mode
	var/list/datum/mind/head_revolutionaries = list()
	var/list/datum/mind/revolutionaries = list()

/datum/game_mode/revolution
	name = "revolution"
	config_tag = "revolution"
	restricted_jobs = list("Security Officer", "Warden", "Detective", "Internal Affairs Agent", "AI", "Cyborg","Captain", "Head of Personnel", "Head of Security", "Chief Engineer", "Research Director", "Chief Medical Officer", "Blueshield", "Nanotrasen Representative", "Security Pod Pilot", "Magistrate", "Brig Physician")
	required_players = 20
	required_enemies = 1
	recommended_enemies = 3

	var/check_counter = 0
	var/max_headrevs = 3
	var/list/datum/mind/heads_to_kill = list()
	var/list/possible_revolutionaries = list()

///////////////////////////
//Announces the game type//
///////////////////////////
/datum/game_mode/revolution/announce()
	to_chat(world, "<B>Текущий игровой режим — Революция!</B>")
	to_chat(world, "<B>Некоторые члены экипажа пытаются поднять революцию!<BR>\nРеволюционеры — убейте капитана, главу персонала, главу службы безопасности, главного инженера, главного врача и директора исследований. Вовлеките в революцию весь прочий экипаж (кроме командования и охраны). Защитите ваших вождей.<BR>\nЭкипаж — Защитите командование. Убейте вождей революции и промойте мозги революционерам (имплантированием им «щитов разума»).</B>")

///////////////////////////////////////////
//Магический спелл для приглашения в реву//
///////////////////////////////////////////

/datum/action/innate/revolution_recruitment
	name = "Рекрутинг"
	button_icon_state = "genetic_mindscan"
	background_icon_state = "bg_vampire"

/datum/action/innate/revolution_recruitment/IsAvailable()
	return ..()

/datum/action/innate/revolution_recruitment/proc/choose_targets(mob/user = usr)
	var/list/validtargets = list()
	for(var/mob/living/carbon/human/M in view(user.client.view, get_turf(user)))
		if(M && M.mind && M.stat == CONSCIOUS)
			if(M == user)
				continue
			if((M.mind.special_role == SPECIAL_ROLE_REV) || (M.mind.special_role == SPECIAL_ROLE_HEAD_REV))
				continue
			validtargets += M
	if(!validtargets.len)
		to_chat(usr, "<span class='warning'>Нет подходящих целей!</span>")
	var/mob/living/carbon/human/target = input("Выберите цель для рекрутирования.", "Выбор цели") as null|mob in validtargets
	return target

/datum/action/innate/revolution_recruitment/Activate()
	if(!(usr && usr.mind && usr.stat == CONSCIOUS))
		to_chat(usr, "<span class='danger'>Вы должны быть в сознании.")
		return
	if(world.time < usr.mind.rev_cooldown)
		to_chat(usr, "<span class='danger'>Вы должны подождать между попытками.")
		return
	usr.mind.rev_cooldown = world.time + 50
	var/mob/living/carbon/human/recruit = choose_targets()
	if(!recruit)
		return
	log_admin("[key_name(usr)] attempted recruitment [key_name(recruit)] into the revolution.", usr)
	to_chat(usr, "<span class='info'><b>Вы пытаетесь рекрутировать в революцию [recruit]: </b></span>")
	if(ismindshielded(recruit) || (recruit.mind in SSticker.mode.get_living_heads()))
		to_chat(recruit, "<span class='danger'><FONT size = 4>Вам предложили вступить в революцию, но, по неизвестным вам причинам, вы отказались.")
		to_chat(usr, "<span class='danger'>[recruit] отказывается поддержать революцию!")
		return
	var/choice = alert(recruit, "Хотите ли вы ступить в революцию?", "Вступить в революцию", "Да", "Нет")
	if(choice == "Да")
		if(!(recruit && recruit.mind && recruit.stat == CONSCIOUS))
			return
		if(usr.mind in SSticker.mode.head_revolutionaries)
			SSticker.mode.add_revolutionary(recruit.mind)
	if(choice == "Нет")
		to_chat(recruit, "<span class='danger'>You reject this traitorous cause!")
		to_chat(usr, "<span class='danger'>[recruit] не поддерживает революцию!")

///////////////////////////////////////////////////////////////////////////////
//Gets the round setup, cancelling if there's not enough players at the start//
///////////////////////////////////////////////////////////////////////////////
/datum/game_mode/revolution/pre_setup()
	possible_revolutionaries = get_players_for_role(ROLE_REV)

	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs


	for(var/i=1 to max_headrevs)
		if(possible_revolutionaries.len==0)
			break
		var/datum/mind/lenin = pick(possible_revolutionaries)
		possible_revolutionaries -= lenin
		head_revolutionaries += lenin
		lenin.restricted_roles = restricted_jobs
		lenin.special_role = SPECIAL_ROLE_REV

	if(head_revolutionaries.len < required_enemies)
		return FALSE

	return TRUE


/datum/game_mode/revolution/post_setup()
	var/list/heads = get_living_heads()
	var/list/sec = get_living_sec()
	var/weighted_score = min(max(round(heads.len - ((8 - sec.len) / 3)),1),max_headrevs)

	while(weighted_score < head_revolutionaries.len) //das vi danya
		var/datum/mind/trotsky = pick(head_revolutionaries)
		possible_revolutionaries += trotsky
		head_revolutionaries -= trotsky
		trotsky.special_role = null

	heads_to_kill += heads

	for(var/datum/mind/rev_mind in head_revolutionaries)
		add_game_logs("has been selected as a head rev", rev_mind.current)
		forge_revolutionary_objectives(rev_mind)

		addtimer(CALLBACK(src, .proc/equip_revolutionary, rev_mind.current), rand(10, 100))

	for(var/datum/mind/rev_mind in head_revolutionaries)
		greet_revolutionary(rev_mind)
	modePlayer += head_revolutionaries
	..()


/datum/game_mode/revolution/process()
	check_counter++
	if(check_counter >= 5)
		check_heads()
		check_counter = 0
	return FALSE


/datum/game_mode/revolution/proc/forge_revolutionary_objectives(datum/mind/rev_mind)
	for(var/datum/mind/head_mind in heads_to_kill)
		rev_objective(rev_mind, head_mind)

/datum/game_mode/proc/greet_revolutionary(datum/mind/rev_mind, you_are=1)
	var/obj_count = 1
	update_rev_icons_added(rev_mind)
	rev_mind.special_role = SPECIAL_ROLE_HEAD_REV
	var/datum/action/innate/revolution_recruitment/C = new()
	C.Grant(rev_mind.current)
	if(you_are)
		to_chat(rev_mind.current, "<span class='userdanger'>Вы — один из вождей революции!</span>")
	for(var/datum/objective/objective in rev_mind.objectives)
		to_chat(rev_mind.current, "<B>Задание №[obj_count]</B>: [objective.explanation_text]")
		obj_count++

/////////////////////////////////////////////////////////////////////////////////
//This are equips the rev heads with their gear, and makes the clown not clumsy//
/////////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/equip_revolutionary(mob/living/carbon/human/mob)
	if(!istype(mob))
		return

	if(mob.mind)
		if(mob.mind.assigned_role == "Clown")
			to_chat(mob, "Упорные тренировки позволили Вам преодолеть свою клоунскую природу. Теперь Вы можете пользоваться оружием, не боясь прострелить себе колено.")
			mob.mutations.Remove(CLUMSY)
			var/datum/action/innate/toggle_clumsy/A = new
			A.Grant(mob)

	var/obj/item/toy/crayon/spraycan/R = new(mob)
	var/obj/item/clothing/glasses/hud/security/chameleon/C = new(mob)

	var/list/slots = list (
		"сумке" = slot_in_backpack,
		"левом кармане" = slot_l_store,
		"правом кармане" = slot_r_store,
		"левой руке" = slot_l_hand,
		"правой руке" = slot_r_hand,
	)
	var/where2 = mob.equip_in_one_of_slots(C, slots)
	mob.equip_in_one_of_slots(R,slots)

	mob.update_icons()

	if(!where2)
		to_chat(mob, "К сожалению, Синдикат не смог снабдить Вас маскировочным ИЛС СБ.")
	else
		to_chat(mob, "Маскировочный ИЛС СБ (находится у Вас в [where2]) поможет увидеть носителей импланта «Щит разума», которых не выйдет рекрутировать в революцию.")
		return 1

/////////////////////////////////
//Gives head revs their targets//
/////////////////////////////////
/datum/game_mode/proc/rev_objective(datum/mind/rev_mind, datum/mind/head_mind)
	var/datum/objective/mutiny/rev_obj = new
	rev_obj.owner = rev_mind
	rev_obj.target = head_mind
	rev_obj.explanation_text = "Изгнать со станции или убить [head_mind.name], [head_mind.assigned_role]."
	rev_mind.objectives += rev_obj

////////////////////////////////////////////
//Checks if new heads have joined midround//
////////////////////////////////////////////
/datum/game_mode/revolution/proc/check_heads()
	var/list/heads = get_all_heads()
	var/list/sec = get_all_sec()
	if(heads_to_kill.len < heads.len)
		var/list/new_heads = heads - heads_to_kill
		for(var/datum/mind/head_mind in new_heads)
			for(var/datum/mind/rev_mind in head_revolutionaries)
				rev_objective(rev_mind, head_mind)
			heads_to_kill += head_mind

	if(head_revolutionaries.len < max_headrevs && head_revolutionaries.len < round(heads.len - ((8 - sec.len) / 3)))
		latejoin_headrev()

///////////////////////////////
//Adds a new headrev midround//
///////////////////////////////
/datum/game_mode/revolution/proc/latejoin_headrev()
	if(revolutionaries) //Head Revs are not in this list
		var/list/promotable_revs = list()
		for(var/datum/mind/khrushchev in revolutionaries)
			if(khrushchev.current && khrushchev.current.client && khrushchev.current.stat != DEAD)
				if(ROLE_REV in khrushchev.current.client.prefs.be_special)
					promotable_revs += khrushchev
		if(promotable_revs.len)
			var/datum/mind/stalin = pick(promotable_revs)
			revolutionaries -= stalin
			head_revolutionaries += stalin
			add_game_logs("has been promoted to a head rev", stalin.current)
			equip_revolutionary(stalin.current)
			forge_revolutionary_objectives(stalin)
			greet_revolutionary(stalin)

///////////////////////////////////////////////////
//Deals with converting players to the revolution//
///////////////////////////////////////////////////
/datum/game_mode/proc/add_revolutionary(datum/mind/rev_mind)
	if((rev_mind in revolutionaries) || (rev_mind in head_revolutionaries))
		return 0
	revolutionaries += rev_mind
	to_chat(rev_mind.current, "<span class='danger'><FONT size = 3>Теперь вы — революционер! Слушайтесь вождей революции. Не вредите борцам за свободу — вашим товарищам. Вы можете опознать своих товарищей по красным иконкам «R», а своих вождей — по синей иконке «R».</FONT></span>")
	add_conversion_logs(rev_mind.current, "recruited to the revolution")
	rev_mind.special_role = SPECIAL_ROLE_REV
	update_rev_icons_added(rev_mind)
	if(jobban_isbanned(rev_mind.current, ROLE_REV) || jobban_isbanned(rev_mind.current, ROLE_SYNDICATE))
		replace_jobbanned_player(rev_mind.current, ROLE_REV)
	return 1
//////////////////////////////////////////////////////////////////////////////
//Deals with players being converted from the revolution (Not a rev anymore)//  // Modified to handle borged MMIs.  Accepts another var if the target is being borged at the time  -- Polymorph.
//////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/remove_revolutionary(datum/mind/rev_mind, beingborged)
	var/remove_head = 0
	if(rev_mind in head_revolutionaries)
		head_revolutionaries -= rev_mind
		remove_head = 1

	if((rev_mind in revolutionaries) || remove_head)
		revolutionaries -= rev_mind
		rev_mind.special_role = null
		for(var/datum/action/innate/revolution_recruitment/C in rev_mind.current.actions)
			qdel(C)
		add_conversion_logs(rev_mind.current, "renounced the revolution")
		if(beingborged)
			to_chat(rev_mind.current, "<span class='danger'><FONT size = 3>Программные протоколы оболочки обнаружили и исправили Ваши перепрограммированные нейронные связи! Вы ничего не помните[remove_head ? "." : ", кроме имени того, кто Вас рекрутировал."]</FONT></span>")
			message_admins("[ADMIN_LOOKUPFLW(rev_mind.current)] has been borged while being a [remove_head ? "leader" : " member"] of the revolution.")
		else
			to_chat(rev_mind.current, "<span class='danger'><FONT size = 3>Вам промыли мозги! Вы больше не революционер!</FONT></span>")

		update_rev_icons_removed(rev_mind)

/////////////////////////////////////
//Adds the rev hud to a new convert//
/////////////////////////////////////
/datum/game_mode/proc/update_rev_icons_added(datum/mind/rev_mind)
	var/datum/atom_hud/antag/revhud = GLOB.huds[ANTAG_HUD_REV]
	revhud.join_hud(rev_mind.current)
	set_antag_hud(rev_mind.current, ((rev_mind in head_revolutionaries) ? "hudheadrevolutionary" : "hudrevolutionary"))

/////////////////////////////////////////
//Removes the hud from deconverted revs//
/////////////////////////////////////////
/datum/game_mode/proc/update_rev_icons_removed(datum/mind/rev_mind)
	var/datum/atom_hud/antag/revhud = GLOB.huds[ANTAG_HUD_REV]
	revhud.leave_hud(rev_mind.current)
	set_antag_hud(rev_mind.current, null)

//////////////////////////
//Checks for rev victory//
//////////////////////////
/datum/game_mode/revolution/proc/check_rev_victory()
	for(var/datum/mind/rev_mind in head_revolutionaries)
		for(var/datum/objective/mutiny/objective in rev_mind.objectives)
			if(!(objective.check_completion()))
				return FALSE

	return TRUE

//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relavent information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/revolution/declare_completion()
	if(check_rev_victory())
		SSticker.mode_result = "revolution win - heads killed"
		to_chat(world, "<span class='redtext'>Всё командование было изгнано или убито! Революция победила!</span>")
	else
		SSticker.mode_result = "revolution loss - rev heads killed"
		to_chat(world, "<span class='redtext'>Командование смогло остановить революцию!</span>")
	..()
	return TRUE

/datum/game_mode/proc/auto_declare_completion_revolution()
	var/list/targets = list()
	if(head_revolutionaries.len || GAMEMODE_IS_REVOLUTION)
		var/num_revs = 0
		var/num_survivors = 0
		for(var/mob/living/carbon/survivor in GLOB.alive_mob_list)
			if(survivor.ckey)
				num_survivors++
				if(survivor.mind)
					if((survivor.mind in head_revolutionaries) || (survivor.mind in revolutionaries))
						num_revs++
		if(num_survivors)
			to_chat(world, "[TAB]Уровень поддержки командования экипажем: <B>[100 - round((num_revs/num_survivors)*100, 0.1)]%</B>") // % of loyal crew
		var/text = "<br><font size=3><b>Вождями революции были:</b></font>"
		for(var/datum/mind/headrev in head_revolutionaries)
			text += printplayer(headrev, 1)
		text += "<br>"
		to_chat(world, text)

	if(revolutionaries.len || GAMEMODE_IS_REVOLUTION)
		var/text = "<br><font size=3><b>Революционерами были:</b></font>"
		for(var/datum/mind/rev in revolutionaries)
			text += printplayer(rev, 1)
		text += "<br>"
		to_chat(world, text)

	if( head_revolutionaries.len || revolutionaries.len || GAMEMODE_IS_REVOLUTION )
		var/text = "<br><font size=3><b>Членами командования были:</b></font>"
		var/list/heads = get_all_heads()
		for(var/datum/mind/head in heads)
			var/target = (head in targets)
			if(target)
				text += "<span class='boldannounce'>Цель</span>"
			text += printplayer(head, 1)
		text += "<br>"
		to_chat(world, text)

/datum/game_mode/revolution/set_scoreboard_gvars()
	var/foecount = 0
	for(var/datum/mind/M in SSticker.mode.head_revolutionaries)
		foecount++
		if(!M || !M.current)
			GLOB.score_opkilled++
			continue

		if(M.current.stat == DEAD)
			GLOB.score_opkilled++

		else if(M.current.restrained())
			GLOB.score_arrested++

	if(foecount == GLOB.score_arrested)
		GLOB.score_allarrested = 1

	for(var/thing in GLOB.human_list)
		var/mob/living/carbon/human/player = thing
		if(player.mind)
			var/role = player.mind.assigned_role
			if(role in list("Captain", "Head of Security", "Head of Personnel", "Chief Engineer", "Research Director", "Chief Medical Officer"))
				if(player.stat == DEAD)
					GLOB.score_deadcommand++


	var/arrestpoints = GLOB.score_arrested * 1000
	var/killpoints = GLOB.score_opkilled * 500
	var/comdeadpts = GLOB.score_deadcommand * 500
	if(GLOB.score_traitorswon)
		GLOB.score_crewscore -= 10000

	GLOB.score_crewscore += arrestpoints
	GLOB.score_crewscore += killpoints
	GLOB.score_crewscore -= comdeadpts


/datum/game_mode/revolution/get_scoreboard_stats()
	var/foecount = 0
	var/comcount = 0
	var/revcount = 0
	var/loycount = 0
	for(var/datum/mind/M in SSticker.mode:head_revolutionaries)
		if(M.current && M.current.stat != DEAD)
			foecount++
	for(var/datum/mind/M in SSticker.mode:revolutionaries)
		if(M.current && M.current.stat != DEAD)
			revcount++
	for(var/thing in GLOB.human_list)
		var/mob/living/carbon/human/player = thing
		if(player.mind)
			var/role = player.mind.assigned_role
			if(role in list("Captain", "Head of Security", "Head of Personnel", "Chief Engineer", "Research Director", "Chief Medical Officer"))
				if(player.stat != DEAD)
					comcount++
			else
				if(player.mind in SSticker.mode.revolutionaries) continue
				loycount++

	for(var/beepboop in GLOB.silicon_mob_list)
		var/mob/living/silicon/X = beepboop
		if(X.stat != DEAD)
			loycount++


	var/dat = ""

	dat += "<b><u>Статистика режима</u></b><br>"
	dat += "<b>Выжило вождей революции:</b> [foecount]<br>"
	dat += "<b>Выжило членов командования станции:</b> [comcount]<br>"
	dat += "<b>Выжило революционеров:</b> [revcount]<br>"
	dat += "<b>Выжило лояльного НаноТрейзен экипажа:</b> [loycount]<br>"

	dat += "<br>"
	dat += "<b>Вождей революции арестовано:</b> [GLOB.score_arrested] ([GLOB.score_arrested * 1000] очков)<br>"
	dat += "<b>Все вожди революции арестованы:</b> [GLOB.score_allarrested ? "Да" : "Нет"] (очки утраиваются)<br>"

	dat += "<b>Убито вождей революции:</b> [GLOB.score_opkilled] ([GLOB.score_opkilled * 500] очков)<br>"
	dat += "<b>Убито членов командования станции:</b> [GLOB.score_deadcommand] (-[GLOB.score_deadcommand * 500] очков)<br>"
	dat += "<b>Революция прошла успешно:</b> [GLOB.score_traitorswon ? "Да" : "Нет"] (-[GLOB.score_traitorswon * 10000] очков)<br>"
	dat += "<HR>"

	return dat
