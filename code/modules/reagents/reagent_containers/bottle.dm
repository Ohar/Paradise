//Not to be confused with /obj/item/reagent_containers/food/drinks/bottle


/obj/item/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "round_bottle"
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30)
	container_type = OPENCONTAINER
	volume = 30

/obj/item/reagent_containers/glass/bottle/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/bottle/update_icon()
	overlays.Cut()
	underlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 24)
				filling.icon_state = "[icon_state]10"
			if(25 to 49)
				filling.icon_state = "[icon_state]25"
			if(50 to 74)
				filling.icon_state = "[icon_state]50"
			if(75 to 90)
				filling.icon_state = "[icon_state]75"
			if(91 to INFINITY)
				filling.icon_state = "[icon_state]100"

		filling.icon += mix_color_from_reagents(reagents.reagent_list)
		underlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "lid_bottle")
		overlays += lid

/obj/item/reagent_containers/glass/bottle/decompile_act(obj/item/matter_decompiler/C, mob/user)
	if(!reagents.total_volume)
		C.stored_comms["glass"] += 3
		qdel(src)
		return TRUE
	return ..()

/obj/item/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle containing toxic compounds."
	icon_state = "small_bottle"
	list_reagents = list("toxin" = 30)

/obj/item/reagent_containers/glass/bottle/atropine
	name = "atropine bottle"
	desc = "A small bottle containing atropine, used for cardiac emergencies."
	icon_state = "small_bottle"
	list_reagents = list("atropine" = 30)

/obj/item/reagent_containers/glass/bottle/saline
	name = "saline-glucose bottle"
	desc = "A small bottle containing saline-glucose solution."
	icon_state = "small_bottle"
	list_reagents = list("salglu_solution" = 30)

/obj/item/reagent_containers/glass/bottle/salicylic
	name = "salicylic acid bottle"
	desc = "A small bottle containing medicine for pain and fevers."
	icon_state = "small_bottle"
	list_reagents = list("sal_acid" = 30)

/obj/item/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon_state = "small_bottle"
	list_reagents = list("cyanide" = 30)

/obj/item/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	icon_state = "bottle"
	list_reagents = list("mutagen" = 30)

/obj/item/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon_state = "bottle"
	list_reagents = list("ammonia" = 30)

/obj/item/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon_state = "round_bottle"
	list_reagents = list("diethylamine" = 30)

/obj/item/reagent_containers/glass/bottle/facid
	name = "Fluorosulfuric Acid Bottle"
	desc = "Небольшая бутылочка. Содержит a small amount of Fluorosulfuric Acid"
	icon_state = "round_bottle"
	list_reagents = list("facid" = 30)

/obj/item/reagent_containers/glass/bottle/adminordrazine
	name = "Adminordrazine Bottle"
	desc = "Небольшая бутылочка. Содержит the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	list_reagents = list("adminordrazine" = 30)

/obj/item/reagent_containers/glass/bottle/capsaicin
	name = "Capsaicin Bottle"
	desc = "Небольшая бутылочка. Содержит hot sauce."
	icon_state = "round_bottle"
	list_reagents = list("capsaicin" = 30)

/obj/item/reagent_containers/glass/bottle/frostoil
	name = "Frost Oil Bottle"
	desc = "Небольшая бутылочка. Содержит cold sauce."
	icon_state = "round_bottle"
	list_reagents = list("frostoil" = 30)

/obj/item/reagent_containers/glass/bottle/morphine
	name = "Бутылочка морфина"
	desc = "Небольшая бутылочка морфина, мощного обезболивающего."
	icon_state = "bottle"
	list_reagents = list("morphine" = 30)

/obj/item/reagent_containers/glass/bottle/ether
	name = "Бутылочка эфира"
	desc = "A small bottle of an ether, a strong anesthetic and sedative."
	icon_state = "round_bottle"
	list_reagents = list("ether" = 30)

/obj/item/reagent_containers/glass/bottle/charcoal
	name = "Бутылочка активированного угля"
	desc = "Небольшая бутылочка. Содержит активированный уголь."
	icon_state = "wide_bottle"
	list_reagents = list("charcoal" = 30)

/obj/item/reagent_containers/glass/bottle/epinephrine
	name = "Бутылочка эпинефрина"
	desc = "Небольшая бутылочка. Содержит эпинефрин — средство стабилизации пациентов."
	icon_state = "round_bottle"
	list_reagents = list("epinephrine" = 30)

/obj/item/reagent_containers/glass/bottle/pancuronium
	name = "Pancuronium Bottle"
	desc = "A small bottle of pancuronium."
	icon_state = "round_bottle"
	list_reagents = list("pancuronium" = 30)

/obj/item/reagent_containers/glass/bottle/sulfonal
	name = "Sulfonal Bottle"
	desc = "A small bottle of Sulfonal."
	icon_state = "round_bottle"
	list_reagents = list("sulfonal" = 30)

//Reagent bottles

/obj/item/reagent_containers/glass/bottle/reagent
	name = "Reagent Bottle"
	desc = "A bottle for storing reagents"
	icon_state = "reagent_bottle"
	volume = 50

/obj/item/reagent_containers/glass/bottle/reagent/oil
	name = "Oil Bottle"
	desc = "Бутылка реагентов. Contains oil."
	list_reagents = list("oil" = 50)
	pixel_x = -4
	pixel_y = 6

/obj/item/reagent_containers/glass/bottle/reagent/phenol
	name = "Phenol Bottle"
	desc = "Бутылка реагентов. Contains phenol."
	list_reagents = list("phenol" = 50)
	pixel_x = 6
	pixel_y = 6

/obj/item/reagent_containers/glass/bottle/reagent/acetone
	name = "Acetone Bottle"
	desc = "Бутылка реагентов. Contains acetone."
	list_reagents = list("acetone" = 50)
	pixel_x = -4

/obj/item/reagent_containers/glass/bottle/reagent/ammonia
	name = "Ammonia Bottle"
	desc = "Бутылка реагентов. Contains ammonia."
	list_reagents = list("ammonia" = 50)
	pixel_x = 6

/obj/item/reagent_containers/glass/bottle/reagent/diethylamine
	name = "Diethylamine Bottle"
	desc = "Бутылка реагентов. Contains diethylamine."
	list_reagents = list("diethylamine" = 50)
	pixel_x = -4
	pixel_y = -6

/obj/item/reagent_containers/glass/bottle/reagent/acid
	name = "Acid Bottle"
	desc = "Бутылка реагентов. Contains sulfuric acid."
	list_reagents = list("sacid" = 50)
	pixel_x = 6
	pixel_y = -6

/obj/item/reagent_containers/glass/bottle/reagent/formaldehyde
	name = "Formaldehyde Bottle"
	desc = "Бутылка реагентов. Contains formaldehyde."
	list_reagents = list("formaldehyde" = 50)

/obj/item/reagent_containers/glass/bottle/reagent/synaptizine
	name = "Synaptizine Bottle"
	desc = "Бутылка реагентов. Contains synaptizine."
	list_reagents = list("synaptizine" = 50)

/obj/item/reagent_containers/glass/bottle/reagent/morphine
	name = "Бутылочка морфина"
	desc = "Бутылка реагентов. Содержит морфин."
	list_reagents = list("morphine" = 50)

/obj/item/reagent_containers/glass/bottle/reagent/insulin
	name = "Insulin Bottle"
	desc = "Бутылка реагентов. Contains insulin."
	list_reagents = list("insulin" = 50)

/obj/item/reagent_containers/glass/bottle/reagent/hairgrownium
	name = "Hair Grow Gel"
	desc = "A bottle full of a stimulative hair growth formula"
	list_reagents = list("hairgrownium" = 50)

/obj/item/reagent_containers/glass/bottle/reagent/hair_dye
	name = "Quantum Hair Dye Bottle"
	desc = "A bottle of the ever-changing quantum hair dye."
	list_reagents = list("hair_dye" = 50)

/obj/item/reagent_containers/glass/bottle/reagent/omnizine
	name = "Бутылка омнизина"
	desc = "Бутылка реагентов. Содержит омнизин."
	list_reagents = list("omnizine" = 50)

/obj/item/reagent_containers/glass/bottle/reagent/strange_reagent
	name = "Бутылка странного реагента"
	desc = "Бутылка светящейся жидкости."
	list_reagents = list("strange_reagent" = 30)

////////////////////Traitor Poison Bottle//////////////////////////////

/obj/item/reagent_containers/glass/bottle/traitor
	desc = "На ней изображён небольшой череп и кости. Ох-хо."
	possible_transfer_amounts = list(5,10,15,25,30,40)
	volume = 40

/obj/item/reagent_containers/glass/bottle/traitor/New()
	..()
	reagents.add_reagent(pick_list("chemistry_tools.json", "traitor_poison_bottle"), 40)

/obj/item/reagent_containers/glass/bottle/plasma
	name = "plasma dust bottle"
	desc = "A small bottle of plasma in dust form. Extremely toxic and reacts with micro-organisms inside blood."
	icon_state = "wide_bottle"
	list_reagents = list("plasma_dust" = 30)

/obj/item/reagent_containers/glass/bottle/diphenhydramine
	name = "diphenhydramine bottle"
	desc = "A small bottle of diphenhydramine."
	icon_state = "round_bottle"
	list_reagents = list("diphenhydramine" = 30)

/obj/item/reagent_containers/glass/bottle/oculine
	name = "oculine bottle"
	desc = "A small bottle of combined eye and ear medication."
	icon_state = "round_bottle"
	list_reagents = list("oculine" = 30)

/obj/item/reagent_containers/glass/bottle/potassium_iodide
	name = "potassium iodide bottle"
	desc = "A small bottle of potassium iodide."
	icon_state = "wide_bottle"
	list_reagents = list("potass_iodide" = 30)

/obj/item/reagent_containers/glass/bottle/flu_virion
	name = "Бутылочка с культурой вириона гриппа"
	desc = "Небольшая бутылочка. Содержит культуру вириона гриппа H13N1 в среде синтетической крови."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/advance/flu

/obj/item/reagent_containers/glass/bottle/epiglottis_virion
	name = "Бутылочка с культурой вириона «Надгортанника»"
	desc = "Небольшая бутылочка. Содержит культуру вириона «Надгортанника» в среде синтетической крови."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/advance/voice_change

/obj/item/reagent_containers/glass/bottle/liver_enhance_virion
	name = "Бутылочка с культурой вириона «Усилителя печени»"
	desc = "Небольшая бутылочка. Содержит культуру вириона «Усилителя печени» в среде синтетической крови."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/advance/heal

/obj/item/reagent_containers/glass/bottle/hullucigen_virion
	name = "Бутылочка с культурой вириона «Галлюцигена»"
	desc = "Небольшая бутылочка. Содержит культуру вириона «Галлюцигена» в среде синтетической крови."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/advance/hullucigen

/obj/item/reagent_containers/glass/bottle/pierrot_throat
	name = "Бутылочка с культурой «Горла Пьеро»"
	desc = "Небольшая бутылочка. Содержит культуру вириона Х0Н1<42 в среде синтетической крови."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/pierrot_throat

/obj/item/reagent_containers/glass/bottle/cold
	name = "Бутылочка с культурой риновируса"
	desc = "Небольшая бутылочка. Содержит культуру риновируса XY в среде синтетической крови."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/advance/cold

/obj/item/reagent_containers/glass/bottle/retrovirus
	name = "Бутылочка с культурой «Ретровируса»"
	desc = "Небольшая бутылочка. Содержит культуру ретровируса в среде синтетической крови."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/dna_retrovirus

/obj/item/reagent_containers/glass/bottle/gbs
	name = "Бутылочка с культурой «ГБС»"
	desc = "Небольшая бутылочка. Содержит культуру гравикинетического бипотенциального САДС+ в среде синтетической крови."//Or simply - General BullShit
	icon_state = "round_bottle"
	amount_per_transfer_from_this = 5
	spawned_disease = /datum/disease/gbs

/obj/item/reagent_containers/glass/bottle/fake_gbs
	name = "Бутылочка с культурой «ГБС»"
	desc = "Небольшая бутылочка. Содержит культуру гравикинетического бипотенциального САДС− в среде синтетической крови."//Or simply - General BullShit
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/fake_gbs

/obj/item/reagent_containers/glass/bottle/brainrot
	name = "Бутылочка с культурой «Мозговой гнили»"
	desc = "Небольшая бутылочка. Содержит культуру космического криптококка в среде синтетической крови."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/brainrot

/obj/item/reagent_containers/glass/bottle/magnitis
	name = "Бутылочка с культурой «Магнитиса»"
	desc = "Небольшая бутылочка. Содержит небольшую дозу «Фуккоса Миракоса»."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/magnitis

/obj/item/reagent_containers/glass/bottle/wizarditis
	name = "Бутылочка с культурой «Визардиса»"
	desc = "Небольшая бутылочка. Содержит образец «Ринсвиндия обыкновенного»."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/wizarditis

/obj/item/reagent_containers/glass/bottle/anxiety
	name = "Бутылочка с культурой «Сильного беспокойства»"
	desc = "Небольшая бутылочка. Содержит образец лепидоптицидов."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/anxiety

/obj/item/reagent_containers/glass/bottle/beesease
	name = "Бутылочка с культурой «Пчелоразы»"
	desc = "Небольшая бутылочка. Содержит образец агрессивных пчёл."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/beesease

/obj/item/reagent_containers/glass/bottle/fluspanish
	name = "Бутылочка с культурой «Испанского инквизиционного гриппа»"
	desc = "Небольшая бутылочка. Содержит образец вириона uHKBu3uLIu9I."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/fluspanish

/obj/item/reagent_containers/glass/bottle/tuberculosis
	name = "Бутылочка с культурой «Грибкового туберкулёза»"
	desc = "Небольшая бутылочка. Содержит образец грибковой туберкулезной бациллы."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/tuberculosis

/obj/item/reagent_containers/glass/bottle/regeneration
	name = "Бутылочка с культурой «Регенерации»"
	desc = "Небольшая бутылочка. Содержит образец вируса, исцеляющего урон от токсинов."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/advance/heal

/obj/item/reagent_containers/glass/bottle/sensory_restoration
	name = "Бутылочка с культурой «Сенсорного восстановления»"
	desc = "Небольшая бутылочка. Содержит образец вируса, исцеляющего повреждение органов чувств."
	icon_state = "round_bottle"
	spawned_disease = /datum/disease/advance/sensory_restoration

/obj/item/reagent_containers/glass/bottle/tuberculosiscure
	name = "BVAK bottle"
	desc = "A small bottle containing Bio Virus Antidote Kit."
	icon_state = "wide_bottle"
	list_reagents = list("atropine" = 5, "epinephrine" = 5, "salbutamol" = 10, "spaceacillin" = 10)
