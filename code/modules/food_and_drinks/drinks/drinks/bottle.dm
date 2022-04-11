

///////////////////////////////////////////////Alchohol bottles! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now weaken and break when smashed on people's heads. - Giacom

/obj/item/reagent_containers/food/drinks/bottle
	amount_per_transfer_from_this = 10
	volume = 100
	throwforce = 15
	item_state = "broken_beer" //Generic held-item sprite until unique ones are made.
	var/const/duration = 13 //Directly relates to the 'weaken' duration. Lowered by armor (i.e. helmets)
	var/isGlass = 1 //Whether the 'bottle' is made of glass or not so that milk cartons dont shatter when someone gets hit by it

/obj/item/reagent_containers/food/drinks/bottle/proc/smash(mob/living/target, mob/living/user, ranged = 0)

	//Creates a shattering noise and replaces the bottle with a broken_bottle
	var/new_location = get_turf(loc)
	var/obj/item/broken_bottle/B = new /obj/item/broken_bottle(new_location)
	if(ranged)
		B.loc = new_location
	else
		user.drop_item()
		user.put_in_active_hand(B)
	B.icon_state = icon_state

	var/icon/I = new('icons/obj/drinks.dmi', icon_state)
	I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	B.icon = I

	if(isGlass)
		if(prob(33))
			new/obj/item/shard(new_location)
		playsound(src, "shatter", 70, 1)
	else
		B.name = "broken carton"
		B.force = 0
		B.throwforce = 0
		B.desc = "A carton with the bottom half burst open. Might give you a papercut."
	transfer_fingerprints_to(B)

	qdel(src)

/obj/item/reagent_containers/food/drinks/bottle/attack(mob/living/target, mob/living/user)

	if(!target)
		return

	if(user.a_intent != INTENT_HARM || !isGlass)
		return ..()

	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, "<span class='warning'>Вы не хотите навредить [target]!</span>")
		return

	force = 15 //Smashing bottles over someoen's head hurts.

	var/obj/item/organ/external/affecting = user.zone_selected //Find what the player is aiming at

	var/armor_block = 0 //Get the target's armor values for normal attack damage.
	var/armor_duration = 0 //The more force the bottle has, the longer the duration.

	//Calculating duration and calculating damage.
	if(ishuman(target))

		var/mob/living/carbon/human/H = target
		var/headarmor = 0 // Target's head armor
		armor_block = H.run_armor_check(affecting, "melee","","",armour_penetration) // For normal attack damage

		//If they have a hat/helmet and the user is targeting their head.
		if(istype(H.head, /obj/item/clothing/head) && affecting == "head")

			// If their head has an armor value, assign headarmor to it, else give it 0.
			if(H.head.armor.getRating("melee"))
				headarmor = H.head.armor.getRating("melee")
			else
				headarmor = 0
		else
			headarmor = 0

		//Calculate the weakening duration for the target.
		armor_duration = (duration - headarmor) + force

	else
		//Only humans can have armor, right?
		armor_block = target.run_armor_check(affecting, "melee")
		if(affecting == "head")
			armor_duration = duration + force
	armor_duration /= 10

	//Apply the damage!
	armor_block = min(90, armor_block)
	target.apply_damage(force, BRUTE, affecting, armor_block)

	// You are going to knock someone out for longer if they are not wearing a helmet.
	var/head_attack_message = ""
	if(affecting == "head" && iscarbon(target))
		head_attack_message = " on the head"
		//Weaken the target for the duration that we calculated and divide it by 5.
		if(armor_duration)
			target.apply_effect(min(armor_duration, 10) , WEAKEN) // Never weaken more than a flash!

	//Display an attack message.
	if(target != user)
		target.visible_message("<span class='danger'>[user] has hit [target][head_attack_message] with a bottle of [name]!</span>", \
				"<span class='userdanger'>[user] has hit [target][head_attack_message] with a bottle of [name]!</span>")
	else
		user.visible_message("<span class='danger'>[target] hits [target.p_them()]self with a bottle of [name][head_attack_message]!</span>", \
				"<span class='userdanger'>[target] hits [target.p_them()]self with a bottle of [name][head_attack_message]!</span>")

	//Attack logs
	add_attack_logs(user, target, "Hit with [src]")

	//The reagents in the bottle splash all over the target, thanks for the idea Nodrak
	SplashReagents(target)

	//Finally, smash the bottle. This kills (qdel) the bottle.
	smash(target, user)

/obj/item/reagent_containers/food/drinks/bottle/proc/SplashReagents(mob/M)
	if(reagents && reagents.total_volume)
		M.visible_message("<span class='danger'>Содержимое [src] выплёскивается на [M]!</span>")
		reagents.reaction(M, REAGENT_TOUCH)
		reagents.clear_reagents()

/obj/item/reagent_containers/food/drinks/bottle/decompile_act(obj/item/matter_decompiler/C, mob/user)
	if(!reagents.total_volume)
		C.stored_comms["glass"] += 3
		qdel(src)
		return TRUE
	return ..()

//Keeping this here for now, I'll ask if I should keep it here.
/obj/item/broken_bottle
	name = "Разбитая бутылка"
	desc = "Бутылка с разбитым острой розочкой донышком."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	force = 9
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY
	item_state = "beer"
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("stabbed", "slashed", "attacked")
	var/icon/broken_outline = icon('icons/obj/drinks.dmi', "broken")
	sharp = 1
	embed_chance = 10
	embedded_ignore_throwspeed_threshold = TRUE

/obj/item/broken_bottle/decompile_act(obj/item/matter_decompiler/C, mob/user)
	C.stored_comms["glass"] += 3
	qdel(src)
	return TRUE

/obj/item/reagent_containers/food/drinks/bottle/gin
	name = "Гриффитский джин"
	desc = "Бутылка высококачественного джина, произведенного на космической станции «Нью-Лондон»."
	icon_state = "ginbottle"
	list_reagents = list("gin" = 100)

/obj/item/reagent_containers/food/drinks/bottle/whiskey
	name = "Особый запас дядюшки Гита"
	desc = "Односолодовый виски премиум-класса, бережно выдержанный в туннелях ядерного убежища. ТУННЕЛЬНЫЕ ВИСКИ РУЛЯТ."
	icon_state = "whiskeybottle"
	list_reagents = list("whiskey" = 100)

/obj/item/reagent_containers/food/drinks/bottle/vodka
	name = "«Тунгуска» тройной очистки"
	desc = "Ах, водка. Выбирается как напиток и как топливо русскими во всём мире."
	icon_state = "vodkabottle"
	list_reagents = list("vodka" = 100)

/obj/item/reagent_containers/food/drinks/bottle/vodka/badminka
	name = "Водка «Бадминка»"
	desc = "Этикетка написана кириллицей. Всё, что вы можете разобрать, это название и слово, отдаленно напоминающее «водка»."
	icon_state = "badminka"
	list_reagents = list("vodka" = 100)

/obj/item/reagent_containers/food/drinks/bottle/tequila
	name = "Caccavo Guaranteed Quality Tequila"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	icon_state = "tequilabottle"
	list_reagents = list("tequila" = 100)

/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
	name = "Бутылка ничего"
	desc = "Бутылка, заполненная ничем."
	icon_state = "bottleofnothing"
	list_reagents = list("nothing" = 100)

/obj/item/reagent_containers/food/drinks/bottle/bottleofbanana
	name = "Jolly Jug"
	desc = "A jug filled with banana juice."
	icon_state = "bottleofjolly"
	list_reagents = list("banana" = 100)

/obj/item/reagent_containers/food/drinks/bottle/patron
	name = "Wrapp Artiste Patron"
	desc = "Silver laced tequila, served in space night clubs across the galaxy."
	icon_state = "patronbottle"
	list_reagents = list("patron" = 100)

/obj/item/reagent_containers/food/drinks/bottle/rum
	name = "Кубинский пряный ром капитана Пита"
	desc = "Это не просто ром, о нет. Это практически ГРИФ в бутылке."
	icon_state = "rumbottle"
	list_reagents = list("rum" = 100)

/obj/item/reagent_containers/food/drinks/bottle/holywater
	name = "фляга святой воды"
	desc = "Фляга святой воды священника."
	icon_state = "holyflask"
	list_reagents = list("holywater" = 100)

/obj/item/reagent_containers/food/drinks/bottle/holywater/hell
	desc = "Фляга святой воды… Хотя она некоторые время пробыла в Некрополе."
	list_reagents = list("hell_water" = 100)

/obj/item/reagent_containers/food/drinks/bottle/vermouth
	name = "Златоглазый вермут"
	desc = "Сладкая, сладкая сухость~"
	icon_state = "vermouthbottle"
	list_reagents = list("vermouth" = 100)

/obj/item/reagent_containers/food/drinks/bottle/kahlua
	name = "Robert Robust's Coffee Liqueur"
	desc = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936, HONK."
	icon_state = "kahluabottle"
	list_reagents = list("kahlua" = 100)

/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	name = "Гольдшлагер старшеклассниц"
	desc = "Потому что они — единственные, кто будет пить 100 % шнапс с корицей."
	icon_state = "goldschlagerbottle"
	list_reagents = list("goldschlager" = 100)

/obj/item/reagent_containers/food/drinks/bottle/cognac
	name = "Премиальный Коньяк «Шато де Батон»"
	desc = "Сладкий и крепкий алкогольный напиток, приготовленный после многочисленных дистилляций и многолетней выдержки. Теперь можно даже не кричать «ЩИТКУРЫ»."
	icon_state = "cognacbottle"
	list_reagents = list("cognac" = 100)

/obj/item/reagent_containers/food/drinks/bottle/wine
	name = "Особое двубородое бородатое вино"
	desc = "Слабая аура досады и попоболи окружает эту бутылку."
	icon_state = "winebottle"
	list_reagents = list("wine" = 100)

/obj/item/reagent_containers/food/drinks/bottle/absinthe
	name = "Абсент «Жёлтый шатёр»"
	desc = "Крепкий алкогольный напиток, сваренный и распространяемый Жёлтым шатром."
	icon_state = "absinthebottle"
	list_reagents = list("absinthe" = 100)

/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium
	name = "Gwyn's Premium Absinthe"
	desc = "A potent alcoholic beverage, almost makes you forget the ash in your lungs."
	icon_state = "absinthepremium"

/obj/item/reagent_containers/food/drinks/bottle/hcider
	name = "Jian Hard Cider"
	desc = "Apple juice for adults."
	icon_state = "hcider"
	volume = 50
	list_reagents = list("suicider" = 50)

/obj/item/reagent_containers/food/drinks/bottle/fernet
	name = "Фернет-бранка"
	desc = "Бутылка чистого люкёра «Фернет-бранка», изготовленного на космической станции Кордоба."
	icon_state = "fernetbottle"
	list_reagents = list("fernet" = 100)

//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/reagent_containers/food/drinks/bottle/orangejuice
	name = "orange juice"
	desc = "Full of vitamins and deliciousness!"
	icon_state = "orangejuice"
	item_state = "carton"
	throwforce = 0
	isGlass = 0
	list_reagents = list("orangejuice" = 100)

/obj/item/reagent_containers/food/drinks/bottle/cream
	name = "milk cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"
	item_state = "carton"
	throwforce = 0
	isGlass = 0
	list_reagents = list("cream" = 100)

/obj/item/reagent_containers/food/drinks/bottle/tomatojuice
	name = "tomato juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"
	item_state = "carton"
	throwforce = 0
	isGlass = 0
	list_reagents = list("tomatojuice" = 100)

/obj/item/reagent_containers/food/drinks/bottle/limejuice
	name = "lime juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"
	item_state = "carton"
	throwforce = 0
	isGlass = 0
	list_reagents = list("limejuice" = 100)

/obj/item/reagent_containers/food/drinks/bottle/milk
	name = "milk"
	desc = "Soothing milk."
	icon_state = "milk"
	item_state = "carton"
	throwforce = 0
	isGlass = 0
	list_reagents = list("milk" = 100)

////////////////////////// MOLOTOV ///////////////////////
/obj/item/reagent_containers/food/drinks/bottle/molotov
	name = "molotov cocktail"
	desc = "A throwing weapon used to ignite things, typically filled with an accelerant. Recommended highly by rioters and revolutionaries. Light and toss."
	icon_state = "vodkabottle"
	list_reagents = list()
	var/list/accelerants = list(/datum/reagent/consumable/ethanol,/datum/reagent/fuel,/datum/reagent/clf3,/datum/reagent/phlogiston,
							/datum/reagent/napalm,/datum/reagent/hellwater,/datum/reagent/plasma,/datum/reagent/plasma_dust)
	var/active = 0

/obj/item/reagent_containers/food/drinks/bottle/molotov/CheckParts(list/parts_list)
	..()
	var/obj/item/reagent_containers/food/drinks/bottle/B = locate() in contents
	if(B)
		icon_state = B.icon_state
		B.reagents.copy_to(src, 100)
		if(!B.isGlass)
			desc += " You're not sure if making this out of a carton was the brightest idea."
			isGlass = 0

/obj/item/reagent_containers/food/drinks/bottle/molotov/throw_impact(atom/target,mob/thrower)
	var/firestarter = 0
	for(var/datum/reagent/R in reagents.reagent_list)
		for(var/A in accelerants)
			if(istype(R, A))
				firestarter = 1
				break
	SplashReagents(target)
	if(firestarter && active)
		target.fire_act()
		new /obj/effect/hotspot(get_turf(target))
	..()

/obj/item/reagent_containers/food/drinks/bottle/molotov/attackby(obj/item/I, mob/user, params)
	if(is_hot(I) && !active)
		active = 1
		var/turf/bombturf = get_turf(src)
		var/area/bombarea = get_area(bombturf)
		message_admins("[key_name(user)][ADMIN_QUE(user,"?")] has primed a [name] for detonation at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[bombarea] (JMP)</a>.")
		log_game("[key_name(user)] has primed a [name] for detonation at [bombarea] ([bombturf.x],[bombturf.y],[bombturf.z]).")

		to_chat(user, "<span class='info'>You light [src] on fire.</span>")
		overlays += GLOB.fire_overlay
		if(!isGlass)
			spawn(50)
				if(active)
					var/counter
					var/target = loc
					for(counter = 0, counter < 2, counter++)
						if(istype(target, /obj/item/storage))
							var/obj/item/storage/S = target
							target = S.loc
					if(istype(target, /atom))
						var/atom/A = target
						SplashReagents(A)
						A.fire_act()
					qdel(src)

/obj/item/reagent_containers/food/drinks/bottle/molotov/attack_self(mob/user)
	if(active)
		if(!isGlass)
			to_chat(user, "<span class='danger'>The flame's spread too far on it!</span>")
			return
		to_chat(user, "<span class='info'>You snuff out the flame on \the [src].</span>")
		overlays -= GLOB.fire_overlay
		active = 0
