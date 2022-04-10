/*
//////////////////////////////////////
Facial Hypertrichosis

	Very very Noticable.
	Decreases resistance slightly.
	Decreases stage speed.
	Reduced transmittability
	Intense Level.

BONUS
	Makes the mob grow a massive beard, regardless of gender.

//////////////////////////////////////
*/

/datum/symptom/beard

	name = "Лицевой гипертрихоз"
	stealth = -3
	resistance = -1
	stage_speed = -3
	transmittable = -1
	level = 4
	severity = 1

/datum/symptom/beard/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/head/head_organ = H.get_organ("head")
			switch(A.stage)
				if(1, 2)
					to_chat(H, "<span class='warning'>У вас начинается чесаться подбородок.</span>")
					if(head_organ.f_style == "Выбритость")
						head_organ.f_style = "Jensen Beard"
						H.update_fhair()
				if(3, 4)
					to_chat(H, "<span class='warning'>Вы чувствуете себя на 20% круче.</span>")
					if(!(head_organ.f_style == "Дварфийская борода") && !(head_organ.f_style == "Очень длинная борода") && !(head_organ.f_style == "Большая борода"))
						head_organ.f_style = "Большая борода"
						H.update_fhair()
				else
					to_chat(H, "<span class='warning'>Вы чувствуете прилив мужественности!</span>")
					if(!(head_organ.f_style == "Дварфийская борода") && !(head_organ.f_style == "Очень длинная борода"))
						head_organ.f_style = pick("Дварфийская борода", "Очень длинная борода")
						H.update_fhair()
	return
