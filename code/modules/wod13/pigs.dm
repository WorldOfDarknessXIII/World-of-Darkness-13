/obj/item/toy/rubberpig
	name = "rubberpig"
	desc = "Klim Sanych, zdravstvuite."
	icon = 'icons/wod13/icons.dmi'
	icon_state = "rubberpig"
	inhand_icon_state = "rubberpig"
	lefthand_file = 'icons/wod13/lefthand.dmi'
	righthand_file = 'icons/wod13/righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0

/obj/item/toy/rubberpig/attack_hand(mob/user)
	var/hryuk = pick('code/modules/wod13/sounds/pig1.ogg', 'code/modules/wod13/sounds/pig2.ogg', 'code/modules/wod13/sounds/pig3.ogg')
	playsound(src, hryuk, 70, TRUE)

/obj/item/toy/rubberpig/attack_self(mob/user)
	if(cooldown < world.time - 50)
		var/hryuk = pick('code/modules/wod13/sounds/pig1.ogg', 'code/modules/wod13/sounds/pig2.ogg', 'code/modules/wod13/sounds/pig3.ogg')
		playsound(src, hryuk, 70, TRUE)
		user.visible_message("<span class='notice'>[user] pushes the rubberpig.</span>", "<span class='notice'>You push the rubberpig.</span>")
		cooldown = world.time

/obj/item/toy/rubberpig/MouseDrop(atom/over_object)
	. = ..()
	var/mob/living/M = usr
	if(!istype(M) || !(M.mobility_flags & MOBILITY_PICKUP))
		return
	if(Adjacent(usr))
		if(over_object == M && loc != M)
			M.put_in_hands(src)
			to_chat(usr, "<span class='notice'>You pick up the rubberpig.</span>")
		else if(istype(over_object, /atom/movable/screen/inventory/hand))
			var/atom/movable/screen/inventory/hand/H = over_object
			if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
				to_chat(usr, "<span class='notice'>You pick up the rubberpig.</span>")
	else
		return
