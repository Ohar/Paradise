
//////////////////////
//		Vendor		//
//////////////////////

/obj/item/reagent_containers/food/snacks/chips
	name = "чипсы"
	desc = "От-так-чипсы от капитана Райкера."
	icon_state = "chips"
	bitesize = 1
	trash = /obj/item/trash/chips
	gender = MALE
	filling_color = "#E8C31E"
	junkiness = 20
	list_reagents = list("nutriment" = 1, "sodiumchloride" = 1, "sugar" = 3)
	tastes = list("чипсов" = 1)

// Scaredy — «Трусишка». Не очень понятно, на что тут отсылка.
// Поменял на отсылку на известного персонажа SS220, вполне уместного для названия марки вяленой говядины
/obj/item/reagent_containers/food/snacks/sosjerky
	name = "Вяленая говядина из личных запасов Сардельки"
	icon_state = "sosjerky"
	desc = "Вяленая говядина из лучших космических коров."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"
	junkiness = 25
	list_reagents = list("protein" = 1, "sugar" = 3)
	tastes = list("жевательной говядины" = 1)

/obj/item/reagent_containers/food/snacks/pistachios
	name = "фисташки"
	icon_state = "pistachios"
	desc = "Вкусные солёные фисташки. Несомненно, лучший выбор."
	trash = /obj/item/trash/pistachios
	filling_color = "#BAD145"
	junkiness = 20
	gender = MALE
	list_reagents = list("plantmatter" = 2, "sodiumchloride" = 1, "sugar" = 4)
	tastes = list("фисташек" = 1)

// 4no Raisins — For no reason — отсылка к крику при суициде и к бану «Без причины»
/obj/item/reagent_containers/food/snacks/no_raisin
	name = "изюм «Прост»"
	icon_state = "4no_raisins"
	desc = "Просто лучший изюм в галактике. Почему — неизвестно."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"
	junkiness = 25
	list_reagents = list("plantmatter" = 2, "sugar" = 4)
	tastes = list("изюма " = 1)

/obj/item/reagent_containers/food/snacks/spacetwinkie
	name = "Космические бисквиты"
	icon_state = "space_twinkie"
	desc = "Их срок годности больше вашей продолжительности жизни."
	trash = /obj/item/trash/spacetwinkie
	filling_color = "#FFE591"
	junkiness = 25
	gender = MALE
	list_reagents = list("sugar" = 4)
	tastes = list("бисквитов" = 1)

/obj/item/reagent_containers/food/snacks/cheesiehonkers
	name = "«Сырные хонкеры»"
	icon_state = "cheesie_honkers"
	desc = "Сырные снеки размером ровно в один укус. Обхонкают вам весь рот."
	trash = /obj/item/trash/cheesie
	filling_color = "#FFA305"
	junkiness = 25
	gender = MALE
	list_reagents = list("nutriment" = 1, "fake_cheese" = 2, "sugar" = 3)
	tastes = list("сыра" = 1, "чипсов" = 2)

/obj/item/reagent_containers/food/snacks/syndicake
	name = "«Синдикексы»"
	icon_state = "syndi_cakes"
	desc = "Очень нежные кексы. Особенно хороши на вкус если их обжарить на атомном огне."
	filling_color = "#FF5D05"
	trash = /obj/item/trash/syndi_cakes
	bitesize = 3
	gender = MALE
	list_reagents = list("nutriment" = 4, "salglu_solution" = 5)
	tastes = list("сладости" = 3, "кекса" = 1)

/obj/item/reagent_containers/food/snacks/tastybread
	name = "багет"
	desc = "Багет в пакете. Хрустящий и удивительно вкусный."
	icon_state = "tastybread"
	trash = /obj/item/trash/tastybread
	filling_color = "#A66829"
	junkiness = 20
	gender = MALE
	list_reagents = list("nutriment" = 2, "sugar" = 4)
	tastes = list("хлеба" = 1)


//////////////////////
//		Homemade	//
//////////////////////

/obj/item/reagent_containers/food/snacks/sosjerky/healthy
	name = "сыровяленая говядина"
	desc = "сыровяленая говядина, из лучших космических коров."
	list_reagents = list("nutriment" = 3, "vitamin" = 1)
	junkiness = 0

/obj/item/reagent_containers/food/snacks/no_raisin/healthy
	name = "домашний виноград"
	name = "ето домашниевый виноград, лучший в усём космасе"
	gender = MALE
	list_reagents = list("nutriment" = 3, "vitamin" = 2)
	junkiness = 0
