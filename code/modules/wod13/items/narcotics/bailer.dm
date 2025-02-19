/obj/item/bailer
	name = "bailer"
	desc = "Best for flora!"
	icon_state = "bailer"
	icon = 'code/modules/wod13/items.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/amount_of_water = 10

/obj/item/bailer/examine(mob/user)
	. = ..()
	if(!amount_of_water)
		. += "<span class='warning'>[src] is empty!</span>"
	else
		. += "<span class='notice'>It has [amount_of_water]/10 unit[amount_of_water == 1 ? "" : "s"] of water left.</span>"
