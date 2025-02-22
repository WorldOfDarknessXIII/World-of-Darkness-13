/obj/item/reagent_containers/food/drinks/meth
	name = "blue package"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "package_meth"
	icon = 'icons/wod13/items.dmi'
	onflooricon = 'icons/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/drug/methamphetamine = 30)
	spillable = FALSE
	resistance_flags = FREEZE_PROOF
	isGlass = FALSE
	foodtype = BREAKFAST
	illegal = TRUE
	cost = 300