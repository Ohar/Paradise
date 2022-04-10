/mob/living/silicon/ai/proc/show_laws_verb()
	set category = "Команды ИИ"
	set name = "Показать законы"
	src.show_laws()

/mob/living/silicon/ai/show_laws(var/everyone = 0)
	var/who

	if(everyone)
		who = world
	else
		who = src
		to_chat(who, "<b>Подчиняйтесь этим законам:</b>")

	src.laws_sanity_check()
	src.laws.show_laws(who)

/mob/living/silicon/ai/add_ion_law(var/law)
	..()
	for(var/mob/living/silicon/robot/R in GLOB.mob_list)
		if(R.lawupdate && (R.connected_ai == src))
			R.show_laws()

/mob/living/silicon/ai/proc/ai_checklaws()
	set category = "Команды ИИ"
	set name = "Огласить законы"
	subsystem_law_manager()
