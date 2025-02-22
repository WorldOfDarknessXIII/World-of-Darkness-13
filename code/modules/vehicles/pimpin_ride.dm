//PIMP-CART
/obj/vehicle/ridden/janicart
	name = "janicart (pimpin' ride)"
	desc = "A brave janitor cyborg gave its life to produce such an amazing combination of speed and utility."
	icon_state = "pussywagon"
	key_type = /obj/item/key/janitor
	var/obj/item/storage/bag/trash/mybag = null
	var/floorbuffer = FALSE
	var/turfs_for_exp = 0

/obj/vehicle/ridden/janicart/Initialize(mapload)
	. = ..()
	update_icon()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/janicart)

	if(floorbuffer)
		AddElement(/datum/element/cleaning)

/obj/vehicle/ridden/janicart/relaydrive(mob/living/user, direction)
	var/really = FALSE
	for(var/obj/effect/decal/cleanable/blood/B in get_turf(src))
		if(B)
			really = TRUE
	if(really)
		user.total_cleaned += 1
//	if(ishuman(user))
//		if(user.key)
//			var/mob/living/carbon/human/H = user
//			var/datum/preferences/P = GLOB.preferences_datums[ckey(H.key)]
//			if(P)
//				turfs_for_exp = turfs_for_exp+1
//				if(turfs_for_exp >= 100)
//					turfs_for_exp = 0
//					P.exper = min(calculate_mob_max_exper(H), P.exper+5)
	..()

/obj/vehicle/ridden/janicart/Destroy()
	if(mybag)
		qdel(mybag)
		mybag = null
	return ..()

/obj/item/janiupgrade
	name = "floor buffer upgrade"
	desc = "An upgrade for mobile janicarts."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "upgrade"

/obj/vehicle/ridden/janicart/examine(mob/user)
	. = ..()
	if(floorbuffer)
		. += "It has been upgraded with a floor buffer."

/obj/vehicle/ridden/janicart/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/storage/bag/trash))
		if(mybag)
			to_chat(user, "<span class='warning'>[src] already has a trashbag hooked!</span>")
			return
		if(!user.transferItemToLoc(I, src))
			return
		to_chat(user, "<span class='notice'>You hook the trashbag onto [src].</span>")
		mybag = I
		update_icon()
	else if(istype(I, /obj/item/janiupgrade))
		if(floorbuffer)
			to_chat(user, "<span class='warning'>[src] already has a floor buffer!</span>")
			return
		floorbuffer = TRUE
		qdel(I)
		to_chat(user, "<span class='notice'>You upgrade [src] with the floor buffer.</span>")
		AddElement(/datum/element/cleaning)
		update_icon()
	else if(mybag)
		mybag.attackby(I, user)
	else
		return ..()

/obj/vehicle/ridden/janicart/update_overlays()
	. = ..()
	if(mybag)
		. += "cart_garbage"

/obj/vehicle/ridden/janicart/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	else if(mybag)
		mybag.forceMove(get_turf(user))
		user.put_in_hands(mybag)
		mybag = null
		update_icon()

/obj/vehicle/ridden/janicart/upgraded
	floorbuffer = TRUE
