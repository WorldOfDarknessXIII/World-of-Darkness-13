/obj/item/phone_book
	name = "phone book"
	desc = "See the actual numbers in the city."
	icon_state = "phonebook"
	icon = 'icons/wod13/items.dmi'
	onflooricon = 'icons/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/phone_book/attack_self(mob/user)
	. = ..()
	for(var/i in GLOB.phone_numbers_list)
		to_chat(user, "- [i]")