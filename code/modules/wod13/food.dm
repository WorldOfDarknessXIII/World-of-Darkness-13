/obj/item/food/vampire
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/biten = FALSE

/obj/item/food/vampire/proc/got_biten()
	if(biten == FALSE)
		biten = TRUE
		icon_state = "[icon_state]-biten"
//----------FAST FOOD--------///
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
	bite_consumption = 1
	tastes = list("chicken" = 1)
	foodtypes = MEAT
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 3)
	eat_time = 15

//--------PACKAGED SNACKS-----------//

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

//---------DRINKS---------//

/obj/item/reagent_containers/food/drinks/coffee/vampire
	name = "coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/consumable/coffee = 30)
	spillable = TRUE
	resistance_flags = FREEZE_PROOF

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
	custom_price = PAYCHECK_CREW

/obj/item/reagent_containers/food/drinks/beer/vampire/blue_stripe
	name = "blue stripe"
	desc = "Blue stripe beer, brought to you by King Breweries and Distilleries!"
	icon_state = "beer_blue"
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 40, /datum/reagent/toxin/amatoxin = 10)

/obj/item/reagent_containers/food/drinks/bottle/vampirecola
	name = "two liter cola bottle"
	desc = "Coca cola espuma..."
	icon_state = "colared"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/consumable/space_cola = 100)
	age_restricted = FALSE

/obj/item/reagent_containers/food/drinks/bottle/vampirecola/blue
	desc = "Pep Cola. Put some pep in your step"
	list_reagents = list(/datum/reagent/consumable/space_up = 100)
	icon_state = "colablue"

/obj/item/reagent_containers/food/drinks/bottle/vampirecola/summer_thaw
	name = "summer thaw"
	desc = "A refreshing drink. Brought to you by King Breweries and Distilleries!"
	icon_state = "soda"
	list_reagents = list(/datum/reagent/consumable/space_cola = 75, /datum/reagent/medicine/muscle_stimulant = 15, /datum/reagent/toxin/amatoxin = 10)

/obj/item/reagent_containers/food/drinks/bottle/vampirecola/thaw_club
	name = "thaw club soda"
	desc = "For your energy needs. Brought to you by King Breweries and Distilleries!"
	icon_state = "soda"
	list_reagents = list(/datum/reagent/consumable/monkey_energy = 50)

/obj/item/reagent_containers/food/drinks/bottle/vampirewater
	name = "water bottle"
	desc = "H2O."
	icon_state = "water1"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/water = 100)
	age_restricted = FALSE

/obj/item/reagent_containers/food/drinks/soda_cans/vampirecola
	name = "cola"
	desc = "Coca cola espuma..."
	icon_state = "colared2"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/consumable/space_cola = 50)

/obj/item/reagent_containers/food/drinks/soda_cans/vampirecola/blue
	desc = "Pep cola. Put some Pep in your step"
	icon_state = "colablue2"
	list_reagents = list(/datum/reagent/consumable/space_up = 50)

/obj/item/reagent_containers/food/drinks/soda_cans/vampiresoda
	name = "soda"
	desc = "More water..."
	icon_state = "soda"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/consumable/sodawater = 50)

/obj/item/reagent_containers/food/condiment/vampiremilk
	name = "milk"
	desc = "More milk..."
	icon_state = "milk"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/consumable/milk = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/food/condiment/vampiremilk/malk
	desc = "a carton of fish-brand milk, a subsidary of malk incorporated."

//--------VENDING MACHINES AND CLERKS--------//

/obj/machinery/computer/order_console/mining/fastfood
	name = "Clerk Catalogue"
	desc = "Order some fastfood here."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "menu"
	var/dispenses_dollars = TRUE
	order_categories = list(CATEGORY_FASTFOOD)

/obj/machinery/computer/order_console/mining/fastfood/sodavendor
	name = "Drink Vendor"
	desc = "Order drinks here."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "vend_r"
	anchored = TRUE
	density = TRUE

/obj/machinery/computer/order_console/mining/fastfood/sodavendor/blue
	icon_state = "vend_c"

/obj/machinery/computer/order_console/mining/fastfood/coffeevendor
	name = "Coffee Vendor"
	desc = "For those sleepy mornings."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "vend_g"
	anchored = TRUE
	density = TRUE

/obj/machinery/computer/order_console/mining/fastfood/snacks
	name = "Snack Vendor"
	desc = "That candy bar better not get stuck this time..."
	icon_state = "vend_b"
	anchored = TRUE
	density = TRUE


/obj/machinery/computer/order_console/mining/fastfood/bacotell

/obj/machinery/computer/order_console/mining/fastfood/bubway

/obj/machinery/computer/order_console/mining/fastfood/gummaguts

/obj/machinery/computer/order_console/mining/fastfood/products
	desc = "Purchase junkfood and crap."

/obj/machinery/computer/order_console/mining/fastfood/clothing
	desc = "Purchase all the finest outfits.. Or don't wagie.."
	order_categories = list(CATEGORY_CLOTHING)

/obj/machinery/computer/order_console/mining/fastfood/costumes
	desc = "Purchase a mask for that ugly mug."
	order_categories = list(CATEGORY_MASKS)


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

/obj/machinery/computer/order_console/mining/fastfood/america	//PSEUDO_M make this restricted or remove it completely
	desc = "Boom! Booom!! BOOOOOOM!!!!"
	order_categories = list(CATEGORY_FASTFOOD)

/obj/machinery/computer/order_console/mining/illegal	// PSEUDO_M make this restricted and only available for triads
	order_categories = list(CATEGORY_ILLEGAL)

/obj/machinery/computer/order_console/mining/pharmacy
	order_categories = list(CATEGORY_MEDICAL)

/obj/machinery/computer/order_console/mining/smoking
	order_categories = list(CATEGORY_SMOKING)

/obj/machinery/computer/order_console/mining/gas
	order_categories = list(CATEGORY_GAS)

/obj/machinery/computer/order_console/mining/library
	order_categories = list(CATEGORY_LIBRARY)

/obj/machinery/computer/order_console/mining/police
	order_categories = list(CATEGORY_POLICE)
