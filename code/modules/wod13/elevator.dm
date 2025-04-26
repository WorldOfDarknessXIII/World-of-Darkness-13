/obj/elevator_button_up
	name = "elevator panel"
	desc = "Call an elevator."
	icon_state = "control"
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	anchored = TRUE
	var/id = 1
	var/obj/elevator_button_down/D
	var/list/doors = list()
	var/here = FALSE
	var/riding = FALSE

/obj/elevator_button_up/Initialize()
	. = ..()
	for(var/obj/elevator_button_down/W in world)
		if(W)
			if(W.id == id)
				D = W
				W.U = src
	for(var/obj/elevator_door/E in range(3, src))
		doors += E
		if(!E.density)
			here = TRUE

/obj/elevator_button_up/attack_hand(mob/user)
	if(riding)
		return
	if(D.riding)
		return
	for(var/obj/elevator_door/E in doors)
		E.close()
	riding = TRUE
	D.riding = TRUE
	say("Moving...")
	spawn(50)
		for(var/mob/living/L in range(1, src))
			L.forceMove(D.loc)
		for(var/obj/item/B in range(1, src))
			B.forceMove(D.loc)
		for(var/obj/elevator_door/V in D.doors)
			V.open()
		D.say("Arrived.")
		riding = FALSE
		D.riding = FALSE
		here = FALSE
		D.here = TRUE
	..()

/obj/elevator_button_down
	name = "elevator panel"
	desc = "Call an elevator."
	icon_state = "control"
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	anchored = TRUE
	var/id = 1
	var/obj/elevator_button_up/U
	var/list/doors = list()
	var/here = FALSE
	var/riding = FALSE

/obj/elevator_button_down/Initialize()
	. = ..()
	for(var/obj/elevator_button_up/W in world)
		if(W)
			if(W.id == id)
				U = W
				W.D = src
	for(var/obj/elevator_door/E in range(src, 3))
		doors += E
		if(!E.density)
			here = TRUE

/obj/elevator_button_down/attack_hand(mob/user)
	if(riding)
		return
	if(U.riding)
		return
	for(var/obj/elevator_door/E in doors)
		E.close()
	riding = TRUE
	U.riding = TRUE
	say("Moving...")
	spawn(50)
		for(var/mob/living/L in range(1, src))
			L.forceMove(U.loc)
		for(var/obj/item/B in range(1, src))
			B.forceMove(U.loc)
		for(var/obj/elevator_door/V in U.doors)
			V.open()
		U.say("Arrived.")
		riding = FALSE
		U.riding = FALSE
		here = FALSE
		U.here = TRUE
	..()

/obj/elevator_button
	name = "elevator button"
	desc = "Call an elevator."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "control"
	var/id = 1
	var/obj/elevator_button_down/I = null
	var/obj/elevator_button_up/O = null

/obj/elevator_button/Initialize()
	. = ..()
	for(var/obj/elevator_button_up/W in range(3, src))
		if(W)
			if(W.id == id)
				O = W
	for(var/obj/elevator_button_down/D in range(3, src))
		if(D)
			if(D.id == id)
				I = D

/obj/elevator_button/attack_hand(mob/user)
	if(I)
		if(I.riding)
			return
		if(!I.here)
			say("Elevator is called, please wait...")
			for(var/obj/elevator_door/E in I.U.doors)
				E.close()
			I.riding = TRUE
			I.U.riding = TRUE
			spawn(50)
				for(var/mob/living/L in range(1, I.U))
					L.forceMove(I.loc)
				for(var/obj/item/B in range(1, I.U))
					B.forceMove(I.loc)
				for(var/obj/elevator_door/V in I.doors)
					V.open()
				I.riding = FALSE
				I.U.riding = FALSE
	if(O)
		if(O.riding)
			return
		if(!O.here)
			say("Elevator is called, please wait...")
			for(var/obj/elevator_door/E in O.D.doors)
				E.close()
			O.riding = TRUE
			O.D.riding = TRUE
			spawn(50)
				for(var/mob/living/L in range(1, O.D))
					L.forceMove(O.loc)
				for(var/obj/item/B in range(1, O.D))
					B.forceMove(O.loc)
				for(var/obj/elevator_door/V in O.doors)
					V.open()
				O.riding = FALSE
				O.D.riding = FALSE
	..()

/obj/elevator_door
	name = "elevator door"
	icon = 'code/modules/wod13/doors.dmi'
	icon_state = "elevator-0"
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	plane = GAME_PLANE
	layer = OPEN_DOOR_LAYER
	pixel_w = -16

/obj/elevator_door/proc/close()
	icon_state = "elevator-1"
	density = TRUE
	opacity = TRUE
	layer = ABOVE_ALL_MOB_LAYER

/obj/elevator_door/proc/open()
	icon_state = "elevator-0"
	density = FALSE
	opacity = FALSE
	layer = OPEN_DOOR_LAYER

/obj/elevator_door/start_closed
	name = "elevator door"
	icon = 'code/modules/wod13/doors.dmi'
	icon_state = "elevator-1"
	density = TRUE
	opacity = TRUE
	layer = ABOVE_ALL_MOB_LAYER
