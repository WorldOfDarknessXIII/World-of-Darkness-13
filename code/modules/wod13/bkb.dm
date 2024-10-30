/mob/living
	var/spell_immunity = FALSE
/obj/item/black_king_bar
	name = "Black King Bar"
	desc = "A powerful staff imbued with the strength of Old Kindred"
	icon = 'code/modules/wod13/bkb.dmi'
	icon_state = "bkb"
	righthand_file = 'code/modules/wod13/bkb_r.dmi'
	lefthand_file = 'code/modules/wod13/bkb_l.dmi'
	var/bkb_timer = 9
	var/active = FALSE
	var/cd = 600
	var/last_activation_time
/obj/item/black_king_bar/examine(mob/user)
	. = ..()
	. += "It now has a duration for [bkb_timer] seconds"
/obj/item/black_king_bar/proc/remove_immunity(mob/living/carbon/human/H)
	H.spell_immunity = FALSE
	H.remove_filter("BKB_glow")
	active = FALSE
/obj/item/black_king_bar/attack_self(mob/living/carbon/human/user)
	. = ..()
	if(active)
		return
	if(world.time - last_activation_time < cd && last_activation_time)
		to_chat(user, "<b>Your BKB on cooldown</b>")
		return
	to_chat(user, "<b>You activated Black King Bar</b>")
	playsound(src, 'code/modules/wod13/bkb.ogg', 25, TRUE)
	last_activation_time = world.time
	active = TRUE
	addtimer(CALLBACK(src, PROC_REF(remove_immunity), user), bkb_timer SECONDS)
	user.spell_immunity = TRUE
	if(bkb_timer > 3)
		bkb_timer--
	user.add_filter("BKB_glow", 2, list("type" = "outline", "color" = "#c9d654ff", "size" = 2))
