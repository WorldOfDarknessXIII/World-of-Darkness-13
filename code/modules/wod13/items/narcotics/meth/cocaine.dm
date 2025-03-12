/obj/item/reagent_containers/food/drinks/meth/cocaine
	name = "white package"
	icon_state = "package_cocaine"
	list_reagents = list(/datum/reagent/drug/methamphetamine/cocaine = 30)

/obj/item/reagent_containers/food/drinks/meth/cocaine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 300, "cocaine", TRUE, -1, 5)
