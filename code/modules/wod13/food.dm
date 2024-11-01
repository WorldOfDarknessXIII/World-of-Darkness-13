/obj/item/food/vampire
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	eatsound = 'code/modules/wod13/sounds/eat.ogg'
	var/biten = FALSE

/obj/item/food/vampire/proc/got_biten()
	if(biten == FALSE)
		biten = TRUE
		icon_state = "[icon_state]-biten"

/obj/item/food/vampire/burger
	name = "burger"
	desc = "The cornerstone of every american trucker's breakfast."
	icon_state = "burger"
	bite_consumption = 3
	tastes = list("bun" = 2, "beef patty" = 4)
	foodtypes = GRAIN | MEAT
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 1)
	eat_time = 15

/obj/item/food/vampire/donut
	name = "donut"
	desc = "Goes great with robust coffee."
	icon_state = "donut1"
	bite_consumption = 5
	tastes = list("donut" = 1)
	foodtypes = JUNKFOOD | GRAIN | FRIED | SUGAR | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/sugar = 3)

/obj/item/food/vampire/donut/Initialize()
	. = ..()
	icon_state = "donut[rand(1, 3)]"

/obj/item/food/vampire/pizza
	name = "square pizza slice"
	desc = "A nutritious slice of pizza."
	icon_state = "pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("crust" = 1, "tomato" = 1, "cheese" = 1, "meat" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | MEAT

/obj/item/food/vampire/taco
	name = "taco"
	desc = "A traditional cornshell taco with meat, cheese, and lettuce."
	icon_state = "taco"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("taco" = 4, "meat" = 2, "cheese" = 2, "lettuce" = 1)
	foodtypes = MEAT | DAIRY | GRAIN | VEGETABLES

/obj/item/trash/vampirebar
	name = "chocolate bar wrapper"
	icon_state = "bar0"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'

/obj/item/food/vampire/bar
	name = "chocolate bar"
	desc = "A fast way to reduce hunger."
	icon_state = "bar2"
	food_reagents = list(/datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/nutriment = 1)
	junkiness = 5
	trash_type = /obj/item/trash/vampirebar
	tastes = list("chocolate" = 1)
	food_flags = FOOD_IN_CONTAINER
	foodtypes = JUNKFOOD | SUGAR

/obj/item/food/vampire/bar/proc/open_bar(mob/user)
	to_chat(user, "<span class='notice'>You pull back the wrapper of \the [src].</span>")
	playsound(user.loc, 'sound/items/foodcanopen.ogg', 50)
	icon_state = "bar1"
	reagents.flags |= OPENCONTAINER

/obj/item/food/vampire/bar/attack_self(mob/user)
	if(!is_drainable())
		open_bar(user)
	return ..()

/obj/item/food/vampire/bar/attack(mob/living/M, mob/user, def_zone)
	if (!is_drainable())
		to_chat(user, "<span class='warning'>[src]'s wrapper hasn't been opened!</span>")
		return FALSE
	return ..()

/obj/item/trash/vampirenugget
	name = "chicken wing bone"
	icon_state = "nugget0"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'

/obj/item/food/vampire/nugget
	name = "chicken wing"
	desc = "Big Wing for a big man."
	icon_state = "nugget1"
	trash_type = /obj/item/trash/vampirenugget
	bite_consumption = 3
	tastes = list("chicken" = 1)
	foodtypes = MEAT
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 3)
	eat_time = 15

/obj/item/trash/vampirecrisps
	name = "chips wrapper"
	icon_state = "crisps0"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'

/obj/item/food/vampire/crisps
	name = "chips"
	desc = "\"Days\" chips... Crispy!"
	icon_state = "crisps2"
	trash_type = /obj/item/trash/vampirecrisps
	bite_consumption = 1
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/salt = 1)
	junkiness = 10
	tastes = list("salt" = 1, "crisps" = 1)
	food_flags = FOOD_IN_CONTAINER
	foodtypes = JUNKFOOD | FRIED
	eatsound = 'code/modules/wod13/sounds/crisp.ogg'

/obj/item/food/vampire/crisps/proc/open_crisps(mob/user)
	to_chat(user, "<span class='notice'>You pull back the wrapper of \the [src].</span>")
	playsound(user.loc, 'sound/items/foodcanopen.ogg', 50)
	icon_state = "crisps1"
	reagents.flags |= OPENCONTAINER

/obj/item/food/vampire/crisps/attack_self(mob/user)
	if(!is_drainable())
		open_crisps(user)
	return ..()

/obj/item/food/vampire/crisps/attack(mob/living/M, mob/user, def_zone)
	if (!is_drainable())
		to_chat(user, "<span class='warning'>[src]'s wrapper hasn't been opened!</span>")
		return FALSE
	return ..()

/obj/item/food/vampire/icecream
	name = "ice cream"
	desc = "Taste the childhood."
	icon_state = "icecream2"
	food_reagents = list(/datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 1, /datum/reagent/consumable/sugar = 4)
	tastes = list("vanilla" = 2, "ice cream" = 2)
	foodtypes = FRUIT | DAIRY | SUGAR

/obj/item/food/vampire/icecream/chocolate
	icon_state = "icecream1"
	tastes = list("chocolate" = 2, "ice cream" = 2)
	food_reagents = list(/datum/reagent/consumable/hot_coco = 4, /datum/reagent/consumable/salt = 1,  /datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 1, /datum/reagent/consumable/sugar = 4)

/obj/item/food/vampire/icecream/berry
	icon_state = "icecream3"
	tastes = list("berry" = 2, "ice cream" = 2)
	food_reagents = list(/datum/reagent/consumable/berryjuice = 4, /datum/reagent/consumable/salt = 1,  /datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 1, /datum/reagent/consumable/sugar = 4)

/obj/item/reagent_containers/food/drinks/coffee/vampire
	name = "coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/consumable/coffee = 30)
	spillable = TRUE
	resistance_flags = FREEZE_PROOF
	isGlass = FALSE
	foodtype = BREAKFAST

/obj/item/reagent_containers/food/drinks/coffee/vampire/robust
	name = "robust coffee"
	icon_state = "coffee-alt"

/obj/item/reagent_containers/food/drinks/beer/vampire
	name = "beer"
	desc = "Beer."
	icon_state = "beer"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 30)
	foodtype = GRAIN | ALCOHOL
	custom_price = PAYCHECK_EASY

/obj/item/reagent_containers/food/drinks/bottle/vampirecola
	name = "two liter cola bottle"
	desc = "Coca cola espuma..."
	icon_state = "cola1"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/space_cola = 100)
	foodtype = SUGAR
	age_restricted = FALSE

/obj/item/reagent_containers/food/drinks/bottle/vampirewater
	name = "water bottle"
	desc = "H2O."
	icon_state = "water1"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/water = 100)
	age_restricted = FALSE

/obj/item/reagent_containers/food/drinks/soda_cans/vampirecola
	name = "cola"
	desc = "Coca cola espuma..."
	icon_state = "cola2"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/consumable/space_cola = 50)
	foodtype = SUGAR

/obj/item/reagent_containers/food/drinks/soda_cans/vampiresoda
	name = "soda"
	desc = "More water..."
	icon_state = "soda"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/consumable/sodawater = 50)
	foodtype = SUGAR

/obj/item/reagent_containers/food/condiment/vampiremilk
	name = "milk"
	desc = "More milk..."
	icon_state = "milk"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/consumable/milk = 50)
	fill_icon_thresholds = null

/obj/machinery/mineral/equipment_vendor/fastfood
	name = "Clerk Catalogue"
	desc = "Order some fastfood here."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "menu"
	icon_deny = "menu"
	prize_list = list()

/obj/machinery/mineral/equipment_vendor/fastfood/AltClick(mob/user)
	. = ..()
	if(points)
		for(var/i in 1 to points)
			new /obj/item/stack/dollar(loc)
		points = 0

/obj/machinery/mineral/equipment_vendor/fastfood/bacotell
	prize_list = list(new /datum/data/mining_equipment("square pizza",	/obj/item/food/vampire/pizza,	15),
		new /datum/data/mining_equipment("taco",	/obj/item/food/vampire/taco,	10),
		new /datum/data/mining_equipment("burger",	/obj/item/food/vampire/burger,	20),
		new /datum/data/mining_equipment("two liter cola bottle",	/obj/item/reagent_containers/food/drinks/bottle/vampirecola,	10),
		new /datum/data/mining_equipment("cola can",	/obj/item/reagent_containers/food/drinks/soda_cans/vampirecola,	5)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/bubway
	prize_list = list(new /datum/data/mining_equipment("donut",	/obj/item/food/vampire/donut,	5),
		new /datum/data/mining_equipment("burger",	/obj/item/food/vampire/burger,	10),
		new /datum/data/mining_equipment("coffee",	/obj/item/reagent_containers/food/drinks/coffee/vampire,	5),
		new /datum/data/mining_equipment("robust coffee",	/obj/item/reagent_containers/food/drinks/coffee/vampire/robust,	10)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/gummaguts
	prize_list = list(new /datum/data/mining_equipment("chicken wing",	/obj/item/food/vampire/nugget,	5),
		new /datum/data/mining_equipment("burger",	/obj/item/food/vampire/burger,	15),
		new /datum/data/mining_equipment("square pizza",	/obj/item/food/vampire/pizza,	10),
		new /datum/data/mining_equipment("two liter cola bottle",	/obj/item/reagent_containers/food/drinks/bottle/vampirecola,	10),
		new /datum/data/mining_equipment("cola can",	/obj/item/reagent_containers/food/drinks/soda_cans/vampirecola,	5)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/products
	desc = "Purchase junkfood and crap."
	prize_list = list(new /datum/data/mining_equipment("chocolate bar",	/obj/item/food/vampire/bar,	3),
		new /datum/data/mining_equipment("chips",	/obj/item/food/vampire/crisps,	5),
		new /datum/data/mining_equipment("water bottle",	/obj/item/reagent_containers/food/drinks/bottle/vampirewater,	5),
		new /datum/data/mining_equipment("soda can",	/obj/item/reagent_containers/food/drinks/soda_cans/vampiresoda,	3),
		new /datum/data/mining_equipment("two liter cola bottle",	/obj/item/reagent_containers/food/drinks/bottle/vampirecola,	7),
		new /datum/data/mining_equipment("cola can",	/obj/item/reagent_containers/food/drinks/soda_cans/vampirecola,	5),
		new /datum/data/mining_equipment("milk",	/obj/item/reagent_containers/food/condiment/vampiremilk,	5),
		new /datum/data/mining_equipment("beer bottle",	/obj/item/reagent_containers/food/drinks/beer/vampire,	10)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/clothing
	desc = "Purchase all the finest outfits.. Or don't wagie.."
	prize_list = list(new /datum/data/mining_equipment("yellow sleeveless shirt",	/obj/item/clothing/under/vampire/larry,	15),
		new /datum/data/mining_equipment("white sleeveless shirt",	/obj/item/clothing/under/vampire/bandit,	15),
		new /datum/data/mining_equipment("biker outfit",	/obj/item/clothing/under/vampire/biker,	15),
		new /datum/data/mining_equipment("mechanic outfit",	/obj/item/clothing/under/vampire/mechanic,	20),
		new /datum/data/mining_equipment("sport clothes",	/obj/item/clothing/under/vampire/sport,	20),
		new /datum/data/mining_equipment("white buisness suit",	/obj/item/clothing/under/vampire/office,	20),
		new /datum/data/mining_equipment("punk outfit",	/obj/item/clothing/under/vampire/emo,	20),
		new /datum/data/mining_equipment("black grunge outfit",	/obj/item/clothing/under/vampire/black,	20),
		new /datum/data/mining_equipment("red hipster outfit",	/obj/item/clothing/under/vampire/red,	20),
		new /datum/data/mining_equipment("gothic clothes",	/obj/item/clothing/under/vampire/gothic,	20),
		new /datum/data/mining_equipment("purple and black outfit",	/obj/item/clothing/under/vampire/sexy,	25),
		new /datum/data/mining_equipment("cargo jacket",	/obj/item/clothing/under/vampire/pimp,	25),
		new /datum/data/mining_equipment("black overcoat",	/obj/item/clothing/under/vampire/rich,	25),
		new /datum/data/mining_equipment("black dress",	/obj/item/clothing/under/vampire/business,	25),
		new /datum/data/mining_equipment("black shoes",	/obj/item/clothing/shoes/vampire,	10),
		new /datum/data/mining_equipment("brown shoes",	/obj/item/clothing/shoes/vampire/brown,	10),
		new /datum/data/mining_equipment("white shoes",	/obj/item/clothing/shoes/vampire/white,	10),
		new /datum/data/mining_equipment("black boots",	/obj/item/clothing/shoes/vampire/jackboots,	10),
		new /datum/data/mining_equipment("work boots",	/obj/item/clothing/shoes/vampire/jackboots/work,	10),
		new /datum/data/mining_equipment("sneakers",	/obj/item/clothing/shoes/vampire/sneakers,	10),
		new /datum/data/mining_equipment("red sneakers",	/obj/item/clothing/shoes/vampire/sneakers/red,	10),
		new /datum/data/mining_equipment("high heels",	/obj/item/clothing/shoes/vampire/heels,	10),
		new /datum/data/mining_equipment("red high heels",	/obj/item/clothing/shoes/vampire/heels/red,	10),
		new /datum/data/mining_equipment("brown coat",	/obj/item/clothing/suit/vampire/coat,	15),
		new /datum/data/mining_equipment("green coat",	/obj/item/clothing/suit/vampire/coat/alt,	15),
		new /datum/data/mining_equipment("jacket",	/obj/item/clothing/suit/vampire/jacket,	15),
		new /datum/data/mining_equipment("black trenchcoat",	/obj/item/clothing/suit/vampire/trench,	15),
		new /datum/data/mining_equipment("brown trenchcoat",	/obj/item/clothing/suit/vampire/trench/alt,	15),
		new /datum/data/mining_equipment("labcoat",	/obj/item/clothing/suit/vampire/labcoat,	15),
		new /datum/data/mining_equipment("yellow aviators",	/obj/item/clothing/glasses/vampire/yellow,	20),
		new /datum/data/mining_equipment("red aviators",	/obj/item/clothing/glasses/vampire/red,	20),
		new /datum/data/mining_equipment("sunglasses",	/obj/item/clothing/glasses/vampire/sun,	20),
		new /datum/data/mining_equipment("prescription glasses",	/obj/item/clothing/glasses/vampire/perception,	20),
		new /datum/data/mining_equipment("leather gloves", /obj/item/clothing/gloves/vampire/leather,	25),
		new /datum/data/mining_equipment("rubber gloves", /obj/item/clothing/gloves/vampire/cleaning,	15),
		new /datum/data/mining_equipment("latex gloves", /obj/item/clothing/gloves/vampire/latex,	5),
		new /datum/data/mining_equipment("black work gloves", /obj/item/clothing/gloves/vampire/work,	45),
		new /datum/data/mining_equipment("bandana",	/obj/item/clothing/head/vampire/bandana,	10),
		new /datum/data/mining_equipment("red bandana",	/obj/item/clothing/head/vampire/bandana/red,	10),
		new /datum/data/mining_equipment("black bandana",	/obj/item/clothing/head/vampire/bandana/black,	10),
		new /datum/data/mining_equipment("beanie",	/obj/item/clothing/head/vampire/beanie,	10),
		new /datum/data/mining_equipment("black beanie",	/obj/item/clothing/head/vampire/beanie/black,	10),
		new /datum/data/mining_equipment("rough beanie",	/obj/item/clothing/head/vampire/beanie/homeless,	10),
		new /datum/data/mining_equipment("scarf",	/obj/item/clothing/neck/vampire/scarf,	10),
		new /datum/data/mining_equipment("red scarf",	/obj/item/clothing/neck/vampire/scarf/red,	10),
		new /datum/data/mining_equipment("blue scarf",	/obj/item/clothing/neck/vampire/scarf/blue,	10),
		new /datum/data/mining_equipment("green scarf",	/obj/item/clothing/neck/vampire/scarf/green,	10),
		new /datum/data/mining_equipment("white scarf",	/obj/item/clothing/neck/vampire/scarf/white,	10)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/costumes
	desc = "Purchase a mask for that ugly mug."
	prize_list = list(new /datum/data/mining_equipment("bear mask",	 /obj/item/clothing/mask/animal/rat/bear,	13),
		new /datum/data/mining_equipment("rat mask",	/obj/item/clothing/mask/animal/rat,	10),
		new /datum/data/mining_equipment("bee mask",	/obj/item/clothing/mask/animal/rat/bee,	12),
		new /datum/data/mining_equipment("fox mask",	/obj/item/clothing/mask/animal/rat/fox,	10),
		new /datum/data/mining_equipment("bat mask",	/obj/item/clothing/mask/animal/rat/bat,	15),
		new /datum/data/mining_equipment("raven mask",	/obj/item/clothing/mask/animal/rat/raven,	20),
		new /datum/data/mining_equipment("jackal mask",	 /obj/item/clothing/mask/animal/rat/jackal,	20),
		new /datum/data/mining_equipment("medical mask",	/obj/item/clothing/mask/surgical,	10),
		new /datum/data/mining_equipment("mummy mask",	/obj/item/clothing/mask/mummy,	15),
		new /datum/data/mining_equipment("scarecrow mask",	/obj/item/clothing/mask/scarecrow,	10)
	)

/obj/food_cart
	name = "food cart"
	desc = "Ding-aling ding dong. Get your cholesterine!"
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "vat1"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER

/obj/food_cart/Initialize()
	. = ..()
	icon_state = "vat[rand(1, 3)]"

/obj/machinery/mineral/equipment_vendor/fastfood/america
	desc = "Boom! Booom!! BOOOOOOM!!!!"
	prize_list = list(new /datum/data/mining_equipment("revolver",	/obj/item/gun/ballistic/vampire/revolver,	200),
		new /datum/data/mining_equipment("Colt M1911",	/obj/item/gun/ballistic/automatic/vampire/m1911,	250),
		new /datum/data/mining_equipment("Glock19",	/obj/item/gun/ballistic/automatic/vampire/glock19,	500),
		new /datum/data/mining_equipment("desert eagle",	/obj/item/gun/ballistic/automatic/vampire/deagle,	600),
		new /datum/data/mining_equipment("mini uzi",	/obj/item/gun/ballistic/automatic/vampire/uzi,	1000),
		new /datum/data/mining_equipment("HK MP5",	/obj/item/gun/ballistic/automatic/vampire/mp5,	1100),
		new /datum/data/mining_equipment("AR-15 rifle",		/obj/item/gun/ballistic/automatic/vampire/ar15,	2000),
		new /datum/data/mining_equipment("Thompson submachine gun",		/obj/item/gun/ballistic/automatic/vampire/thompson,	1500),
		new /datum/data/mining_equipment("AK-74",		/obj/item/gun/ballistic/automatic/vampire/ak74,	1800),
		new /datum/data/mining_equipment("sniper rifle",		/obj/item/gun/ballistic/automatic/vampire/sniper,	2000),
		new /datum/data/mining_equipment("AUG carbine",		/obj/item/gun/ballistic/automatic/vampire/aug,	3000),
		new /datum/data/mining_equipment("fishing rod",		/obj/item/fishing_rod,	200),
		new	/datum/data/mining_equipment("5.45 ammo",	/obj/item/ammo_box/vampire/c545,	300),
		new	/datum/data/mining_equipment(".45 ACP ammo",	/obj/item/ammo_box/vampire/c45acp,	500),
		new /datum/data/mining_equipment("9mm ammo",	/obj/item/ammo_box/vampire/c9mm,	600),
		new /datum/data/mining_equipment(".44 ammo",	/obj/item/ammo_box/vampire/c44,	800),
		new /datum/data/mining_equipment("5.56 ammo",	/obj/item/ammo_box/vampire/c556,	1200),
		new /datum/data/mining_equipment("mini uzi magazine",	/obj/item/ammo_box/magazine/vamp9mm,	200),
		new /datum/data/mining_equipment("desert eagle magazine",	/obj/item/ammo_box/magazine/m44,	100),
		new /datum/data/mining_equipment("AR-15 rifle magazine",	/obj/item/ammo_box/magazine/vamp556,	200),
		new /datum/data/mining_equipment("AUG carbine magazine",	/obj/item/ammo_box/magazine/vampaug,	300),
		new /datum/data/mining_equipment("Thompson magazine",		/obj/item/ammo_box/magazine/vampthompson,	300),
		new /datum/data/mining_equipment("AK74 magazine",		/obj/item/ammo_box/magazine/vamp545,	100),
		new /datum/data/mining_equipment("HK MP5 magazine",		/obj/item/ammo_box/magazine/vamp9mp5,	150),
		new /datum/data/mining_equipment("Glock19 magazine",		/obj/item/ammo_box/magazine/glock9mm,	100),
		new /datum/data/mining_equipment("Colt M1911 magazine",		/obj/item/ammo_box/magazine/vamp45acp,	50),
		new /datum/data/mining_equipment("knife",	/obj/item/melee/vampirearms/knife,	100),
		new /datum/data/mining_equipment("baseball bat",	/obj/item/melee/vampirearms/baseball,	200),
		new /datum/data/mining_equipment("real katana",	/obj/item/melee/vampirearms/katana,	1500),
		new /datum/data/mining_equipment("donut",	/obj/item/food/vampire/donut,	10)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/illegal
	prize_list = list(new /datum/data/mining_equipment("morphine syringe",	/obj/item/reagent_containers/syringe/contraband/morphine,	100),
		new	/datum/data/mining_equipment("meth package",	/obj/item/reagent_containers/food/drinks/meth,	300),
		new	/datum/data/mining_equipment("cocaine package",	/obj/item/reagent_containers/food/drinks/meth/cocaine,	700),
		new /datum/data/mining_equipment("LSD pill bottle",		/obj/item/storage/pill_bottle/lsd,	50),
		new /datum/data/mining_equipment("LSD pill",		/obj/item/reagent_containers/pill/lsd,	10),
		new /datum/data/mining_equipment("cannabis puff",		/obj/item/clothing/mask/cigarette/rollie/cannabis,	40),
		new /datum/data/mining_equipment("cannabis package",		/obj/item/weedpack,	30),
		new /datum/data/mining_equipment("cannabis leaf",	/obj/item/food/vampire/weed,	25),
		new /datum/data/mining_equipment("cannabis seed",	/obj/item/weedseed,		10),
		new /datum/data/mining_equipment("bong",	/obj/item/bong,		50),
		new /datum/data/mining_equipment("bailer",	/obj/item/bailer,		20),
		new /datum/data/mining_equipment("incendiary 5.56 ammo",	/obj/item/ammo_box/vampire/c556/incendiary,	3000),
		new /datum/data/mining_equipment("silver 9mm ammo",	/obj/item/ammo_box/vampire/c9mm/silver,	1000),
		new /datum/data/mining_equipment("silver .45 ACP ammo",	/obj/item/ammo_box/vampire/c45acp/silver,	1000),
		new /datum/data/mining_equipment("silver .44 ammo",	/obj/item/ammo_box/vampire/c44/silver,	1000),
		new /datum/data/mining_equipment("silver 5.56 ammo",	/obj/item/ammo_box/vampire/c556/silver,	1000),
		new /datum/data/mining_equipment("stake",	/obj/item/vampire_stake,	100),
		new /datum/data/mining_equipment("lockpick",	/obj/item/vamp/keys/hack, 50)
		)

/obj/machinery/mineral/equipment_vendor/fastfood/pharmacy
	prize_list = list(
		new /datum/data/mining_equipment("ephedrine pill bottle", /obj/item/storage/pill_bottle/ephedrine, 200),
		new /datum/data/mining_equipment("iron pill bottle", /obj/item/storage/pill_bottle/iron, 150),
		new /datum/data/mining_equipment("potassium iodide pill bottle", /obj/item/storage/pill_bottle/potassiodide, 100),
		new /datum/data/mining_equipment("bruise pack", /obj/item/stack/medical/bruise_pack, 100),
		new /datum/data/mining_equipment("burn ointment", /obj/item/stack/medical/ointment, 100)
		)

/obj/machinery/mineral/equipment_vendor/fastfood/smoking
	prize_list = list(new /datum/data/mining_equipment("malboro",	/obj/item/storage/fancy/cigarettes/cigpack_robust,	50),
		new /datum/data/mining_equipment("newport",		/obj/item/storage/fancy/cigarettes/cigpack_xeno,	30),
		new /datum/data/mining_equipment("camel",	/obj/item/storage/fancy/cigarettes/dromedaryco,	30),
		new /datum/data/mining_equipment("zippo lighter",	/obj/item/lighter,	20),
		new /datum/data/mining_equipment("lighter",		/obj/item/lighter/greyscale,	10)
		)

/obj/machinery/mineral/equipment_vendor/fastfood/gas
	prize_list = list(new /datum/data/mining_equipment("full gas can",	/obj/item/gas_can/full,	250),
		new /datum/data/mining_equipment("tire iron",		/obj/item/melee/vampirearms/tire,	50)
		)
