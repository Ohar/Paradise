// Pumpkin
/obj/item/seeds/pumpkin
	name = "пачка тыквенных семян" // pack of pumpkin seeds
	desc = "Из этих семян вырастает тыквенная лоза."
	icon_state = "seed-pumpkin"
	species = "pumpkin"
	plantname = "Тыквенная лоза"
	product = /obj/item/reagent_containers/food/snacks/grown/pumpkin
	lifespan = 50
	endurance = 40
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "pumpkin-grow"
	icon_dead = "pumpkin-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/pumpkin/blumpkin)
	reagents_add = list("vitamin" = 0.04, "plantmatter" = 0.2)

/obj/item/reagent_containers/food/snacks/grown/pumpkin
	seed = /obj/item/seeds/pumpkin
	name = "тыква" // pumpkin
	desc = "Большая и страшная."
	icon_state = "pumpkin"
	filling_color = "#FFA500"
	bitesize_mod = 2
	tastes = list("pumpkin" = 1)
	wine_power = 0.2

/obj/item/reagent_containers/food/snacks/grown/pumpkin/attackby(obj/item/W as obj, mob/user as mob, params)
	if(is_sharp(W))
		user.show_message("<span class='notice'>Вы вырезаете лицо на [src]!</span>", 1)
		new /obj/item/clothing/head/hardhat/pumpkinhead(user.loc)
		qdel(src)
		return
	else
		return ..()

// Blumpkin
/obj/item/seeds/pumpkin/blumpkin
	name = "пачка синячьих семян" // pack of blumpkin seeds
	desc = "Из этих семян вырастает синячья лоза."
	icon_state = "seed-blumpkin"
	species = "blumpkin"
	plantname = "Синячья лоза"
	product = /obj/item/reagent_containers/food/snacks/grown/blumpkin
	mutatelist = list()
	reagents_add = list("ammonia" = 0.2, "chlorine" = 0.1, "plasma" = 0.1, "plantmatter" = 0.2)
	rarity = 20

/obj/item/reagent_containers/food/snacks/grown/blumpkin
	seed = /obj/item/seeds/pumpkin/blumpkin
	name = "синяк" // blumpkin
	desc = "Ядовитый брат тыквы."
	icon_state = "blumpkin"
	filling_color = "#87CEFA"
	bitesize_mod = 2
	tastes = list("blumpkin" = 1)
	wine_power = 0.5
