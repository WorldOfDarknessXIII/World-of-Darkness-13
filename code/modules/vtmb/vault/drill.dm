/obj/item/vampire/drill
	name = "thermal drill"
	desc = "Guys! The thermal drill, go get it!"
	icon = 'code/modules/wod13/48x32weapons.dmi'
	icon_state = "vaultdrill"
	inhand_icon_state = "vaultdrill"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 8
	throwforce = 10
	throw_range = 3
	var/obj/structure/drill/origin_type = /obj/structure/drill


/obj/item/vampire/drill/proc/plant(mob/user)
	var/turf/T = get_turf(loc)
	if(!isfloorturf(T))
		to_chat(user, "<span class='warning'>You need ground to put this on!</span>")
		return

	user.visible_message("<span class='notice'>[user] places down \the [src.name].</span>")
	var/obj/structure/drill/placed_drill = new origin_type(get_turf(loc))
	TransferComponents(placed_drill)
	placed_drill.setDir(user.dir)
	qdel(src)

/obj/item/vampire/drill/attack_self(mob/user)
	plant(user)

/obj/structure/drill
	name = "thermal drill"
	desc = "Guys! The thermal drill, go get it!"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "vaultdrill"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	layer = GASFIRE_LAYER
	max_integrity = 3000
	var/item_drill = /obj/item/vampire/drill // if null it can't be picked up
	var/gas = 0
	var/max_gas = 300
	var/ready = FALSE
	var/active = FALSE
	var/attached_door = null

	var/drill_sound = 'code/modules/wod13/sounds/vault_drilling.ogg'

/obj/structure/drill/proc/health_status()
	if(obj_integrity < max_integrity)
		switch(obj_integrity)
			if(2500 to 3000)
				return "slightly damaged"
			if(2000 to 2500)
				return "moderately damaged"
			if(1000 to 2000)
				return "severely damaged"
			if(500 to 1000)
				return "barely functional"
			else
				return "about to break"

/obj/structure/drill/examine(mob/user)
	. = ..()
	var/health_status = health_status()
	. += "[src] has [gas] gas left."
	if(obj_integrity < max_integrity)
		. += "<span class='notice'>[src] is [health_status].</span>"

/obj/structure/drill/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr) && !active)
		if(do_after(usr, 5 SECONDS))
			if(!item_drill || src.flags_1 & NODECONSTRUCT_1)
				return
			if(!usr.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
				return
			usr.visible_message("<span class='notice'>[usr] lifts \the [src.name].</span>", "<span class='notice'>You grab \the [src.name].</span>")
			ready = FALSE
			attached_door = null
			var/obj/item/picked_drill = new item_drill(loc)
			TransferComponents(picked_drill)
			usr.put_in_hands(picked_drill)
			qdel(src)
	var/obj/structure/vaultdoor/target_door = over_object
	if((istype(over_object, /obj/structure/vaultdoor)) && Adjacent(usr) && !ISDIAGONALDIR(get_dir(src, over_object)) && !active && !target_door.is_broken)
		if(do_after(usr, 5 SECONDS))
			ready = TRUE
			attached_door = over_object
			var/direction = get_dir(src, over_object)
			switch(direction)
				if(WEST)
					dir = WEST
					pixel_x = -17
					pixel_y = 21
				if(EAST)
					dir = EAST
					pixel_x = 17
					pixel_y = 21
				if(NORTH)
					dir = NORTH
					pixel_y = 30
				if(SOUTH)
					dir = SOUTH
					pixel_y = -5

/obj/structure/drill/proc/update_effects()
	var/mutable_appearance/sparks = mutable_appearance('code/modules/wod13/particle_effects.dmi', "welding_sparks", ABOVE_ALL_MOB_LAYERS_LAYER, ABOVE_LIGHTING_PLANE)
	if(active)
		add_overlay(sparks)
	else
		cut_overlays()

/obj/structure/drill/proc/process_drill()
	while(active && ready && gas > 0)
		playsound(src, drill_sound, 100, TRUE, ignore_walls = TRUE)
		update_effects()

		if(!attached_door || !istype(attached_door, /obj/structure/vaultdoor))
			active = FALSE
			ready = FALSE

			return

		var/obj/structure/vaultdoor/vault_door = attached_door
		vault_door.door_health -= 1
		gas -= 5
		if(vault_door.door_health <= 0)
			vault_door.break_open()
			active = FALSE
			update_effects()

		sleep(3 SECONDS)

/obj/structure/drill/attackby(obj/item/used_item, mob/living/user, params)
	if(istype(used_item, /obj/item/gas_can/))
		var/gas_space = max_gas - gas
		var/obj/item/gas_can/can = used_item
		can.stored_gasoline -= gas_space
		gas += gas_space
		return

/obj/structure/drill/attack_hand(mob/user)
	. = ..()
	if(!ready)
		to_chat(user, "<span class='warning'>You need to place the drill on a vault door first!</span>")
		return
	if(gas <= 0)
		to_chat(user, "<span class='warning'>The drill is out of gas!</span>")
		return
	if(!active)
		if(do_after(user, 5 SECONDS))
			active = TRUE
			process_drill()
	else
		if(do_after(user, 2 SECONDS))
			active = FALSE
			update_effects()
			visible_message("<span class='warning'>[src] shuts off!</span>")

/obj/structure/drill/proc/handle_layer()
	if(dir == SOUTH)
		layer = ABOVE_MOB_LAYER
	else
		layer = ABOVE_ALL_MOB_LAYERS_LAYER
