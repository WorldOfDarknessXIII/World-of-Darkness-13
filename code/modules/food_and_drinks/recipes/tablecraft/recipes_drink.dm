
// This is the home of drink related tablecrafting recipes, I have opted to only let players bottle fancy boozes to reduce the number of entries.

///////////////// Booze & Bottles ///////////////////

/datum/crafting_recipe/lizardwine
	name = "Lizard Wine"
	time = 40
	reqs = list(
		/obj/item/organ/tail/lizard = 1,
		/datum/reagent/consumable/ethanol = 100
	)
	result = /obj/item/reagent_containers/food/drinks/bottle/lizardwine
	category = CAT_DRINK

/datum/crafting_recipe/champagnebottle
	name = "Champagne Bottle"
	time = 30
	reqs = list(
		/obj/item/reagent_containers/food/drinks/bottle = 1,
		/datum/reagent/consumable/ethanol/champagne = 100
	)
	result = /obj/item/reagent_containers/food/drinks/bottle/champagne
	category = CAT_DRINK

////////////////////// Non-alcoholic recipes ///////////////////

/datum/crafting_recipe/holybottle
	name = "Holy Water Flask"
	time = 30
	reqs = list(
		/obj/item/reagent_containers/food/drinks/bottle = 1,
		/datum/reagent/water/holywater = 100
	)
	result = /obj/item/reagent_containers/food/drinks/bottle/holywater
	category = CAT_DRINK

//flask of unholy water is a beaker for some reason, I will try making it a bottle and add it here once the antag freeze is over. t. kryson

/datum/crafting_recipe/nothingbottle
	name = "Nothing Bottle"
	time = 30
	reqs = list(
		/obj/item/reagent_containers/food/drinks/bottle = 1,
		/datum/reagent/consumable/nothing = 100
	)
	result = /obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
	category = CAT_DRINK

/datum/crafting_recipe/smallcarton
	name = "Small Carton"
	result = /obj/item/reagent_containers/food/drinks/sillycup/smallcarton
	time = 10
	reqs = list(/obj/item/stack/sheet/cardboard = 1)
	category = CAT_DRINK

/datum/crafting_recipe/candycornliquor
	name = "candy corn liquor"
	result = /obj/item/reagent_containers/food/drinks/bottle/candycornliquor
	time = 30
	reqs = list(/datum/reagent/consumable/ethanol/whiskey = 100,
				/obj/item/food/candy_corn = 1,
				/obj/item/reagent_containers/food/drinks/bottle = 1)
	category = CAT_DRINK

/datum/crafting_recipe/kong
	name = "Kong"
	result = /obj/item/reagent_containers/food/drinks/bottle/kong
	time = 30
	reqs = list(/datum/reagent/consumable/ethanol/whiskey = 100,
				/obj/item/food/monkeycube = 1,
				/obj/item/reagent_containers/food/drinks/bottle = 1)
	category = CAT_DRINK

/datum/crafting_recipe/pruno
	name = "pruno mix"
	result = /obj/item/reagent_containers/food/drinks/bottle/pruno
	time = 30
	reqs = list(/obj/item/storage/bag/trash = 1,
	            /obj/item/food/breadslice/moldy = 1,
	            /obj/item/food/grown = 4,
	            /obj/item/food/candy_corn = 2,
	            /datum/reagent/water = 15)
	category = CAT_DRINK

/datum/crafting_recipe/lean
	name = "lean"
	result = /obj/item/reagent_containers/food/drinks/colocup/lean
	time = 30
	reqs = list(/obj/item/reagent_containers/food/drinks/colocup = 1,
				/obj/item/food/chewable/gumball = 2,
				/datum/reagent/medicine/morphine = 5,
				/datum/reagent/consumable/space_up = 15)
	category = CAT_DRINK
