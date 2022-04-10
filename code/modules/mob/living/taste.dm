/mob/living
	var/last_taste_time
	var/last_taste_text

/mob/living/proc/get_taste_sensitivity()
	return TASTE_SENSITIVITY_NORMAL

/mob/living/carbon/human/get_taste_sensitivity()
	if(dna.species)
		return dna.species.taste_sensitivity
	else
		return TASTE_SENSITIVITY_NORMAL

// non destructively tastes a reagent container
/mob/living/proc/taste(datum/reagents/from)
	if(last_taste_time + 50 < world.time)
		var/taste_sensitivity = get_taste_sensitivity()
		var/text_output = from.generate_taste_message(taste_sensitivity)
		// We dont want to spam the same message over and over again at the
		// person. Give it a bit of a buffer.
		if(hallucination > 50 && prob(25))
			text_output = pick("пауков","снов","кошмаров","будущего","прошлого","победы","правосудия","памяти",\
			"поражения","боли","блаженства","мести","яда","времени","космоса","смерти","жизни","правды","лжи",\
			"сожаления","вашей души","страдания","музыки","шума","крови","голода","славы","денег")
		if(text_output != last_taste_text || last_taste_time + 100 < world.time)
			to_chat(src, "<span class='notice'>Вы чувствуете вкус [text_output].</span>")
			// "something indescribable" -> too many tastes, not enough flavor.

			last_taste_time = world.time
			last_taste_text = text_output
