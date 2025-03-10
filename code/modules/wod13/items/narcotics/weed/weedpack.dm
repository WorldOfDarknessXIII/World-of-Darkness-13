/obj/item/weedpack
	name = "green package"
	desc = "Green and smelly..."
	icon_state = "package_weed"
	icon = 'code/modules/wod13/items.dmi'
	w_class = WEIGHT_CLASS_SMALL
	onflooricon = 'code/modules/wod13/onfloor.dmi'

/obj/item/weedpack/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 150, "weed_pack", TRUE, -1, 7)
