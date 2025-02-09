/proc/create_unique_pincode()
	var/pincode = ""
	for(var/i in 1 to 5)
		pincode += "[rand(0, 9)]" //Generates a random digit and adds it to the pincode
	return pincode

/obj/keypad
	name = "keypad"
	desc = "Requires a password to open."
	icon = 'icons/obj/terminals_vtm.dmi'
	icon_state = "keypad"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	var/obj/machinery/door/poddoor/shutters/connected_shutter
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/x_pos = 0
	var/y_pos = 0
	var/pincode
	var/id = 0
/obj/keypad/proc/connect_to_shutter()
	for(var/obj/machinery/door/poddoor/shutters/S in world)
		if(S.id == id)
			connected_shutter = S
			break

/obj/machinery/door/poddoor/shutters/armory/New()
	id = 10
	..()

/obj/machinery/door/poddoor/shutters/bankvault/New()
	id = 11
	..()

/proc/find_keypad(keypad_type)
    for(var/obj/keypad/K in world)
        if(istype(K, keypad_type))
            return K
    return null

/obj/keypad/New()
	..()
	pincode = create_unique_pincode()
	spawn(1)
	connect_to_shutter()



/obj/keypad/attack_hand(mob/user as mob)
	var/choice = input(user, "Please choose an action.", "Keypad") as null|anything in list("Enter Pincode", "Close Shutter")
	switch(choice)
		if("Enter Pincode")
			var/input_pincode = input(user, "Please enter the pincode.", "Keypad") as null|text
			if(input_pincode && "[input_pincode]" == pincode)
				to_chat(user, "<span class='notice'>Access Granted.</span>")
				if(connected_shutter.density)
					connected_shutter.open()
			else
				to_chat(user, "<span class ='notice'>Access Denied.</span>")
		if("Close Shutter")
			if(connected_shutter && !connected_shutter.density)
				connected_shutter.close()
/obj/keypad/armory
	name = "keypad"
	desc = "Requires a password to open."
	icon = 'icons/obj/terminals_vtm.dmi'
	icon_state = "keypad"
	id = 10

/obj/keypad/bankvault
	name = "keypad"
	desc = "Requires a password to open."
	icon = 'icons/obj/terminals_vtm.dmi'
	icon_state = "keypad"
	id = 11

/obj/keypad/panic_room
	id = 12
