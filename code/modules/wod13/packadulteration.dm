/datum/crafting_recipe/methpack
	name = "Make Meth Adulterated Bloodpack"
	time = 25
	reqs = list(/obj/item/reagent_containers/food/drinks/meth = 1, /obj/item/drinkable_bloodpack = 1)
	result = /obj/item/reagent_containers/drug/methpack
	always_available = TRUE
	category = CAT_DRUGS

/datum/crafting_recipe/morphpack
	name = "Make Morphine Adulterated Bloodpack"
	time = 25
	reqs = list(/obj/item/reagent_containers/syringe/contraband/morphine = 1, /obj/item/drinkable_bloodpack = 1)
	result = /obj/item/reagent_containers/drug/morphpack
	always_available = TRUE
	category = CAT_DRUGS

/datum/crafting_recipe/cokepack
	name = "Make Cocaine Adulterated Bloodpack"
	time = 25
	reqs = list(/obj/item/reagent_containers/food/drinks/meth/cocaine = 1, /obj/item/drinkable_bloodpack = 1)
	result = /obj/item/reagent_containers/drug/morphpack
	always_available = TRUE
	category = CAT_DRUGS
