/datum/sprite_accessory/body_markings/none
	name = "Нет"
	species_allowed = list("Человек", "Унати", "Диона", "Серый", "КПБ", "Таяран", "Вульпканин", "Скрелл", "Слаймомен", "Скелет", "Вокс", "Кидан")
	icon_state = "none"

/datum/sprite_accessory/body_markings/tiger
	name = "Тело тигра"
	species_allowed = list("Унати", "Таяран", "Вульпканин")
	icon_state = "tiger"

/datum/sprite_accessory/body_markings/tattoo // Tattoos applied post-round startup with tattoo guns in item_defines.dm
	species_allowed = list("Человек", "Унати", "Вульпканин", "Таяран", "Скрелл")
	icon_state = "none"

/datum/sprite_accessory/body_markings/tattoo/elliot
	name = "Тату «Схема Эллиота»"
	icon_state = "campbell"
	species_allowed = null

/datum/sprite_accessory/body_markings/tattoo/tiger_body // Yep, this is repeated. To be fixed later
	name = "Тату «Тигровые полосы»"
	species_allowed = list("Человек", "Унати", "Вульпканин", "Таяран", "Скрелл")
	icon_state = "tiger"

/datum/sprite_accessory/body_markings/tattoo/heart
	name = "Тату «Сердце»"
	icon_state = "heart"

/datum/sprite_accessory/body_markings/tattoo/hive
	name = "Тату «Улей»"
	icon_state = "hive"

/datum/sprite_accessory/body_markings/tattoo/nightling
	name = "Тату «Соловей»"
	icon_state = "nightling"
