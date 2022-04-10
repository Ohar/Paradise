/obj/item/clothing/mask/balaclava
	name = "balaclava"
	desc = "LOADSAMONEY"
	icon_state = "balaclava"
	item_state = "balaclava"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = WEIGHT_CLASS_SMALL
	actions_types = list(/datum/action/item_action/adjust)
	adjusted_flags = SLOT_HEAD

	sprite_sheets = list(
		"Вокс" = 'icons/mob/species/vox/mask.dmi',
		"Унати" = 'icons/mob/species/unathi/mask.dmi',
		"Таяран" = 'icons/mob/species/tajaran/mask.dmi',
		"Вульпканин" = 'icons/mob/species/vulpkanin/mask.dmi',
		"Серый" = 'icons/mob/species/grey/mask.dmi',
		"Драск" = 'icons/mob/species/drask/mask.dmi'
		)

/obj/item/clothing/mask/balaclava/attack_self(var/mob/user)
	adjustmask(user)

/obj/item/clothing/mask/luchador
	name = "Luchador Mask"
	desc = "Worn by robust fighters, flying high to defeat their foes!"
	icon_state = "luchag"
	item_state = "luchag"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = WEIGHT_CLASS_SMALL

	sprite_sheets = list(
		"Вокс" = 'icons/mob/species/vox/mask.dmi',
		"Унати" = 'icons/mob/species/unathi/mask.dmi',
		"Таяран" = 'icons/mob/species/tajaran/mask.dmi',
		"Вульпканин" = 'icons/mob/species/vulpkanin/mask.dmi',
		"Серый" = 'icons/mob/species/grey/mask.dmi',
		"Драск" = 'icons/mob/species/drask/mask.dmi'
		)

/obj/item/clothing/mask/luchador/tecnicos
	name = "Tecnicos Mask"
	desc = "Worn by robust fighters who uphold justice and fight honorably."
	icon_state = "luchador"
	item_state = "luchador"

/obj/item/clothing/mask/luchador/rudos
	name = "Rudos Mask"
	desc = "Worn by robust fighters who are willing to do anything to win."
	icon_state = "luchar"
	item_state = "luchar"
