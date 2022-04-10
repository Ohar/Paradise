/*
//////////////////////////////////////
Alopecia

	Noticable.
	Decreases resistance slightly.
	Reduces stage speed slightly.
	Transmittable.
	Intense Level.

BONUS
	Makes the mob lose hair.

//////////////////////////////////////
*/

/datum/symptom/shedding

	name = "Облысение"
	stealth = -1
	resistance = -1
	stage_speed = -1
	transmittable = 2
	level = 4
	severity = 1

/datum/symptom/shedding/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		to_chat(M, "<span class='warning'>[pick("У вас чешется кожа головы.", "Ваша кожа начинает шелушиться.")]</span>")
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/head/head_organ = H.get_organ("head")
			switch(A.stage)
				if(3, 4)
					if(!(head_organ.h_style == "Лысина") && !(head_organ.h_style == "Залысина"))
						to_chat(H, "<span class='warning'>Ваши волосы начинают выпадать клочьями…</span>")
						spawn(50)
							head_organ.h_style = "Залысина"
							H.update_hair()
				if(5)
					if(!(head_organ.f_style == "Выбритость") || !(head_organ.h_style == "Лысина"))
						to_chat(H, "<span class='warning'>Ваши волосы начинают выпадать клочьями…</span>")
						spawn(50)
							head_organ.f_style = "Выбритость"
							head_organ.h_style = "Лысина"
							H.update_hair()
							H.update_fhair()
	return
