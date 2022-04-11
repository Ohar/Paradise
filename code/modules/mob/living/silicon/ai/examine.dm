/mob/living/silicon/ai/examine(mob/user)
	. = ..()
	var/msg = "<span class='info'>"
	if(src.stat == DEAD)
		msg += "<span class='deadsay'>Похоже, этот ИИ выключен.</span>\n"
	else
		msg += "<span class='warning'>"
		if(src.getBruteLoss())
			if(src.getBruteLoss() < 30)
				msg += "Выглядит слегка помято.\n"
			else
				msg += "<B>Выглядит очень помято!</B>\n"
		if(src.getFireLoss())
			if(src.getFireLoss() < 30)
				msg += "Выглядит слегка обгоревшим.\n"
			else
				msg += "<B>Оболочка расплавлена и деформирована от жара!</B>\n"
		if(src.stat == UNCONSCIOUS)
			msg += "Он не отвечает. На экране отображается текст: «ИСПОЛНЯЕМАЯ СРЕДА: сенсорная перегрузка, очередь 26/3».\n"
		if(!shunted && !client)
			msg += "[src]_Core.exe не отвечает! НТОС ищет решение проблемы…\n"
		msg += "</span>"
	msg += "*---------*</span>"

	. += msg
	user.showLaws(src)


/mob/proc/showLaws(var/mob/living/silicon/S)
	return

/mob/dead/observer/showLaws(var/mob/living/silicon/S)
	if(antagHUD || check_rights(R_ADMIN, 0, src))
		S.laws.show_laws(src)
