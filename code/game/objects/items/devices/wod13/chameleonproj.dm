/obj/item/chameleon
	name = "Appearance Projector"
	desc = "Use on others to save their appearance, and use on yourself to copy it."
	icon = 'icons/wod13/icons.dmi'
	icon_state = "vicissitude"
	flags_1 = CONDUCT_1
	item_flags = ABSTRACT | NOBLUDGEON | DROPDEL
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	var/can_use = 1
	var/obj/effect/dummy/chameleon/active_dummy = null
	var/saved_appearance = null
	var/generated = FALSE

/obj/item/chameleon/Initialize()
	. = ..()

/obj/item/chameleon/dropped()
	..()
	disrupt()

/obj/item/chameleon/equipped()
	..()
	disrupt()

/obj/item/chameleon/attack_self(mob/user)
	if(!generated)
		saved_appearance = user.appearance
		generated = TRUE
	if (isturf(user.loc) || active_dummy)
		toggle(user)
	else
		to_chat(user, "<span class='warning'>You can't use [src] while inside something!</span>")

/obj/item/chameleon/afterattack(atom/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(active_dummy)//I now present you the blackli(f)st
		return
	if(!isliving(target))
		return
	if(target.alpha != 255)
		return
	if(target.invisibility != 0)
		return
	playsound(get_turf(src), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)
	to_chat(user, "<span class='notice'>Scanned [target].</span>")
	saved_appearance = target.appearance

/obj/item/chameleon/proc/toggle(mob/user)
	if(!can_use || !saved_appearance)
		return
	if(active_dummy)
		eject_all()
		playsound(get_turf(src), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)
		qdel(active_dummy)
		active_dummy = null
		to_chat(user, "<span class='notice'>You deactivate \the [src].</span>")
	else
		playsound(get_turf(src), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)
		var/obj/effect/dummy/chameleon/C = new/obj/effect/dummy/chameleon(user.drop_location())
		C.activate(user, saved_appearance, src)
		to_chat(user, "<span class='notice'>You activate \the [src].</span>")
	user.cancel_camera()

/obj/item/chameleon/proc/disrupt(delete_dummy = 1)
	if(active_dummy)
		for(var/mob/M in active_dummy)
			to_chat(M, "<span class='danger'>Your Appearance Projector deactivates.</span>")
		eject_all()
		if(delete_dummy)
			qdel(active_dummy)
		active_dummy = null
		can_use = FALSE
		addtimer(VARSET_CALLBACK(src, can_use, TRUE), 5 SECONDS)

/obj/item/chameleon/proc/eject_all()
	for(var/atom/movable/A in active_dummy)
		A.forceMove(active_dummy.loc)
		if(ismob(A))
			var/mob/M = A
			M.reset_perspective(null)

/obj/effect/dummy/chameleon
	name = ""
	desc = ""
	density = TRUE
	var/can_move = 0
	var/obj/item/chameleon/master = null

/obj/effect/dummy/chameleon/proc/activate(mob/M, saved_appearance, obj/item/chameleon/C)
	appearance = saved_appearance
	if(istype(M.buckled, /obj/vehicle))
		var/obj/vehicle/V = M.buckled
		V.unbuckle_mob(M, force = TRUE)
	M.forceMove(src)
	master = C
	master.active_dummy = src

/obj/effect/dummy/chameleon/attackby()
	master.disrupt()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/effect/dummy/chameleon/attack_hand()
	master.disrupt()

/obj/effect/dummy/chameleon/attack_animal()
	master.disrupt()

/obj/effect/dummy/chameleon/attack_slime()
	master.disrupt()

/obj/effect/dummy/chameleon/attack_alien()
	master.disrupt()

/obj/effect/dummy/chameleon/ex_act(S, T)
	contents_explosion(S, T)
	master.disrupt()

/obj/effect/dummy/chameleon/bullet_act()
	. = ..()
	master.disrupt()

/obj/effect/dummy/chameleon/relaymove(mob/living/user, direction)
	if(isspaceturf(loc) || !direction)
		return //No magical space movement!

	if(can_move < world.time)
		can_move = world.time + 10
		step(src, direction)
	return

/obj/effect/dummy/chameleon/Destroy()
	master.disrupt(0)
	return ..()
