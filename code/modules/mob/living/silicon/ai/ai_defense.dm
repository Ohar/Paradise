/mob/living/silicon/ai/attack_alien(mob/living/carbon/alien/humanoid/M)
	if(!SSticker)
		to_chat(M, "Вы не можете атаковать людей до начала игры.")
		return
	..()

/mob/living/silicon/ai/attack_slime(mob/living/simple_animal/slime/user)
	return //immune to slimes
