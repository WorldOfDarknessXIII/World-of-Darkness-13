/area/vtm/interior/delivery/
	name = "Delivery office"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "shop"
	var/delivery_employer_tag = "default"

/area/vtm/interior/delivery_garage
	name = "Delivery garage"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "strip"
	var/delivery_employer_tag = "default"

/area/vtm/interior/delivery_garage/Initialize(mapload)
	GLOB.delivery_garage_areas.Add(src)
	. = ..()

/area/vtm/interior/delivery_garage/Destroy()
	GLOB.delivery_garage_areas.Remove(src)
	. = ..()
