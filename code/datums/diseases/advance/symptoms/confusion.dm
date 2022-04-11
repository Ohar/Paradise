/*
//////////////////////////////////////

Confusion

	Little bit hidden.
	Lowers resistance.
	Decreases stage speed.
	Not very transmittable.
	Intense Level.

Bonus
	Makes the affected mob be confused for short periods of time.

//////////////////////////////////////
*/

/datum/symptom/confusion

	name = "Замешательство"
	stealth = 1
	resistance = -1
	stage_speed = -3
	transmittable = 0
	level = 4
	severity = 2


/datum/symptom/confusion/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/carbon/M = A.affected_mob
		switch(A.stage)
			if(1, 2, 3, 4)
				to_chat(M, "<span class='warning'>[pick("У вас болит голова.", "Вы на мгновение теряете сознание.")]</span>")
			else
				to_chat(M, "<span class='userdanger'>Ваши мысли бесконтрольно разбегаются…</span>")
				M.AdjustConfused(8, bound_lower = 0, bound_upper = 100)

	return
