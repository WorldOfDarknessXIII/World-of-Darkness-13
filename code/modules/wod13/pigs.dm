/obj/item/toy/rubberpig
	name = "rubberpig"
	desc = "Klim Sanych, zdravstvuite."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "rubberpig"
	inhand_icon_state = "rubberpig"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
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
