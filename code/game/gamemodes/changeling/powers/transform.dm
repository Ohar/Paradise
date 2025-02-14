/datum/action/changeling/transform
	name = "Transform"
	desc = "We take on the appearance and voice of one we have absorbed. Costs 5 chemicals."
	button_icon_state = "transform"
	chemical_cost = 5
	dna_cost = 0
	req_dna = 1
	req_human = 1
	max_genetic_damage = 3

//Change our DNA to that of somebody we've absorbed.
/datum/action/changeling/transform/sting_action(var/mob/living/carbon/human/user)
	if(!user)
		return 0

	var/datum/changeling/changeling = user.mind.changeling

	// DNA Selector.
	// DNA is referenced directly here (careful). Changing DNA stats here will change stored DNA as well.
	var/datum/dna/chosen_dna = changeling.select_dna("Select the target DNA: ", "Target DNA")

	if(!chosen_dna)
		return

	for(var/mob/living/M in GLOB.human_list)
		if(M.real_name == chosen_dna.real_name)
			user.tts_seed = M.tts_seed

	transform_dna(user,chosen_dna)

	user.changeling_update_languages(changeling.absorbed_languages)

	SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("[name]"))
	return 1

/datum/changeling/proc/select_dna(var/prompt, var/title)
	var/list/names = list()
	for(var/datum/dna/DNA in (absorbed_dna+protected_dna))
		names += "[DNA.real_name]"

	var/chosen_name = input(prompt, title, null) as null|anything in sortList(names)
	if(!chosen_name)
		return

	var/datum/dna/chosen_dna = GetDNA(chosen_name)
	return chosen_dna
