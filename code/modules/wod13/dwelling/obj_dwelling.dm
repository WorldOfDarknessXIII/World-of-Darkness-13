//All objects def for dwelling stuff

//Loot items

/obj/item/vtm/dwelling_loot
	name = "Dwelling Loot Master Item"
	desc = "If you can see this with the base description, someone did a funny. Please report this as a bug."
	icon = 'icons/obj/clothing/accessories.dmi'
	icon_state = "bronze"
	layer = OBJ_LAYER
	w_class = WEIGHT_CLASS_NORMAL
	var/loot_value = 0 // From 1 to 3 assings value and changes description. This should be replaced by a full proc at some point, but will do for a first implementation.

/obj/item/vtm/dwelling_loot/Initialize()
	. = ..()
	switch(loot_value)
		if(1)
			AddComponent(/datum/component/selling, 50, "loot_small", TRUE, -1, 5)
		if(2)
			AddComponent(/datum/component/selling, 150, "loot_medium", TRUE, -1, 5)
		if(3)
			AddComponent(/datum/component/selling, 350, "loot_large", TRUE, -1, 5)

/obj/item/vtm/dwelling_loot/minor
	name = "minor valuable"
	desc = "A small trinket of low value. Can be fenced for some money."
	icon_state = "bronze"
	loot_value = 1
	grid_width = 1 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/vtm/dwelling_loot/moderate
	name = "moderate valuable"
	desc = "A small trinket of decent value. Can be fenced for money."
	icon_state = "silver"
	loot_value = 2
	grid_width = 2 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/vtm/dwelling_loot/major
	name = "major valuable"
	desc = "A small trinket of excellent value. Can be fenced for good money."
	icon_state = "gold"
	loot_value = 3
	grid_width = 2 GRID_BOXES
	grid_height = 2 GRID_BOXES

// Loot Containers

/obj/structure/vtm/dwelling_container
	name = "Personal storage"
	desc = "A container full of personal items. Can be serched to reveal the items within."
	icon = 'icons/obj/crates.dmi'
	icon_state = "crate"
	layer = BELOW_OBJ_LAYER
	color = "#A17037"
	density = 1
	anchored = 1
	var/area/vtm/dwelling/area_reference
	var/search_tries = 0
	var/search_hits_left = 0 // These should be automated by the system, btu tries typically are double the hits.
	var/currently_searched = 0 // Terminator for when in use

/obj/structure/vtm/dwelling_container/Initialize()
	var/area/vtm/dwelling/current_area = get_area(src)
	if(current_area)
		current_area.loot_containers.Add(src)
		area_reference = current_area
	. = ..()

/obj/structure/vtm/dwelling_container/proc/roll_for_loot() // This assumes that there are still tries left and outputs loot value to be turned into loot. Also does some self-repairing should it detect an impossible value.
	if(search_hits_left > search_tries) // Self-maitnenance. Ammount of tries can't be lower than ammount of assigned sucesses, so they are equalized in case this state is detected. This should not happen unless vars where changed by hand.
		search_tries = search_hits_left
	if(search_hits_left == 0)
		search_tries = 0
		return 0
	if(search_hits_left == search_tries)
		search_tries -= 1
		search_hits_left -= 1
		return(area_reference.return_loot_value())
	if(search_hits_left < search_tries)
		if(rand(1,2) == 1)
			search_tries -= 1
			return "fail"
		else
			search_tries -= 1
			search_hits_left -= 1
			return(area_reference.return_loot_value())

/obj/structure/vtm/dwelling_container/proc/dispense_loot(loot_type) // This proc creates the actual loot item. Pulling it out like this allows to individualize loot tables per specific item.
	var/container_turf = get_turf(src)
	switch(loot_type)
		if(null)
			return
		if("minor")
			new /obj/item/vtm/dwelling_loot/minor(container_turf)
		if("moderate")
			new /obj/item/vtm/dwelling_loot/moderate(container_turf)
		if("major")
			new /obj/item/vtm/dwelling_loot/major(container_turf)


/obj/structure/vtm/dwelling_container/attack_hand(mob/living/user)
	add_fingerprint(user) // For frorencics, adds user fingerprints
	if(!area_reference) // Terminators
		to_chat(user, span_warning("Error: No area reference detected. This is a bug."))
		return
	if(search_tries == 0)
		to_chat(user, span_warning("This container does not seem to have anything of note inside."))
		return
	if(currently_searched == 1)
		to_chat(user, span_warning("Someone is currently using this object."))
		return
	currently_searched = 1 // Starts searching
	while(search_tries > 0)
		area_reference.add_heat(5)
		var/search_time = search_tries * 30
		if(do_mob(user, src, search_time))
			var/loot_roll = roll_for_loot()
			switch(loot_roll)
				if(0)
					search_hits_left = 0
					to_chat(user, span_warning("You search through the container, but don't find anything of value. You doubt you will be able to find much else here."))
				if("fail")
					to_chat(user, span_warning("You search through the container, but don't find anything of value."))
				if("minor","moderate","major")
					to_chat(user, span_notice("You find an item of [loot_roll] value!"))
					dispense_loot(loot_roll)
		else break
	if(search_tries == 0)
		icon_state = "crateopen"
		update_icon()
	currently_searched = 0

/obj/structure/vtm/dwelling_container/Destroy()
	. = ..()
	area_reference.loot_containers.Remove(src)
	area_reference = null

// Doors

/obj/structure/vampdoor/dwelling

	baseicon = "wood"
	icon_state = "wood-1"
	var/area/vtm/dwelling/area_reference
	locked = 1

/obj/structure/vampdoor/dwelling/proc/set_security(sec_type)
	switch(sec_type)
		if("minor")
			lockpick_difficulty = LOCKDIFFICULTY_3
			lockpick_timer = LOCKTIMER_3
		if("moderate")
			lockpick_difficulty = LOCKDIFFICULTY_5
			lockpick_timer = LOCKTIMER_5
		if("major")
			lockpick_difficulty = LOCKDIFFICULTY_7
			lockpick_timer = LOCKTIMER_7
	lock_id = area_reference.area_tag

/obj/structure/vampdoor/dwelling/proc/start_casing(mob/user) //Returns casing and lockpick infromation after a while.
	if(area_reference.alarm_trigerred == 1) //Eliminator if the alarm was already trigerred
		to_chat(user, span_warning("This house has already been breached and the alarm triggered. Casing is no longer possible."))
		return
	to_chat(user, span_notice("You begin casing the house..."))
	if(do_mob(user, src, 30 SECONDS))
		switch(area_reference.loot_list["type"])
			if("major")
				to_chat(user, span_notice("Both the door and the security system are top notch. Robbing this house is risky but should carry a decent reward. If triggered, the security system will need to be reset every thirty seconds."))
			if("moderate")
				to_chat(user, span_notice("The door and security system seem average for San Francisco. Robbing this house carries a moderate risk and moderate rewards. If triggered, the security system will need to be reset every two minutes. "))
			if("minor")
				to_chat(user, span_notice("The door and security system seem to be of poor quality. Robbing this house should provide minor rewards, but the security system can be disabled completely."))
		area_reference.cased_by.Add(user)
		return

/obj/structure/vampdoor/dwelling/proc_unlock(severity)
	if(!area_reference) return
	area_reference.add_heat(severity)

/obj/structure/vampdoor/dwelling/examine(mob/user, door = src)
	. = ..()
	if(area_reference.cased_by.Find(user) == 0)
		start_casing(user)

/obj/structure/vampdoor/dwelling/Initialize()
	var/area/vtm/dwelling/current_area = get_area(src)
	if(current_area)
		current_area.dwelling_doors.Add(src)
		area_reference = current_area
	. = ..()

/obj/structure/vampdoor/dwelling/Destroy()
	. = ..()
	area_reference.dwelling_doors.Remove(src)
	area_reference = null

/obj/structure/window/fulltile/dwelling
	var/area/vtm/dwelling/area_reference
	var/obj/structure/curtain/dwelling/curtain_reference

/obj/structure/window/fulltile/dwelling/process_break_in(severity)
	if(!area_reference) return
	area_reference.add_heat(severity)

/obj/structure/window/fulltile/dwelling/Initialize(mapload, direct)
	. = ..()
	var/area/vtm/dwelling/current_area = get_area(src)
	if(current_area)
		area_reference = current_area
		area_reference.dwelling_windows.Add(src)
	var/obj/structure/curtain/dwelling/curtain = new(get_turf(src))
	curtain_reference = curtain

/obj/structure/window/fulltile/dwelling/Destroy()
	if(area_reference)
		area_reference.dwelling_windows.Remove(src)
		area_reference = null
	if(curtain_reference)
		curtain_reference.check_area = FALSE
		curtain_reference = null
	. = ..()


/turf/closed/wall/vampwall/city/low/window/dwelling
	window = /obj/structure/window/fulltile/dwelling

/obj/structure/curtain/dwelling
	name = "plain curtains"
	icon_type = "bounty"
	icon_state = "bounty-closed"
	open = FALSE
	opacity = TRUE
	density = FALSE
	opaque_closed = TRUE
	color = null
	alpha = 255
	base_pixel_y = 12
	pixel_y = 12
	check_area = TRUE


/obj/item/vtm/dwelling_alarm_card
	name = "alarm disabler card"
	desc = "A small card with a magnetic strip. Can be used to disable triggered security systems. Does not work on systems that have not sent an alarm signal yet."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "card3"
	inhand_icon_state = "card3"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	item_flags = NOBLUDGEON
	flags_1 = HEAR_1
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	onflooricon = 'code/modules/wod13/onfloor.dmi'

/obj/structure/vtm/dwelling_alarm
	name = "A home alarm console"
	desc = "A small console with a display and small keyboard. A small hole to the side of the panel looks like it would just fit a lockpick."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl"
	density = 0
	anchored = 1
	pixel_y = 32
	var/area/vtm/dwelling/area_reference
	var/alarm_timer = 0
	var/alarm_active = 0
	var/alarm_safety = 0

/obj/structure/vtm/dwelling_alarm/Initialize()
	var/area/vtm/dwelling/current_area = get_area(src)
	if(current_area)
		current_area.alarm_panel = src
		area_reference = current_area
	. = ..()

/obj/structure/vtm/dwelling_alarm/proc/contact_cops() //Contains the actual act of yelling at cops
	var/randomized_response_time = rand(1 SECONDS, 30 SECONDS)
	sleep(randomized_response_time)
	for(var/obj/item/police_radio/radio in GLOB.police_radios)
		radio.announce_crime("burglary", get_turf(src))
	for(var/obj/machinery/p25transceiver/police/transciever in GLOB.p25_tranceivers)
		if(transciever.p25_network == "police")
			transciever.announce_crime("burglary", get_turf(src))
			break

/obj/structure/vtm/dwelling_alarm/proc/alarm_trigger() //Starts the alarm for the house, calls cops
	area_reference.alarm_trigerred = 1
	icon_state = "doorctrl-denied"
	update_icon()
	set_light(4,2,"#FF0000",1)
	say("Intrusion detected! Contacting local PD!")
	playsound(src, 'sound/effects/alert.ogg', 50)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/vtm/dwelling_alarm/, contact_cops))

/obj/structure/vtm/dwelling_alarm/proc/alarm_loop() //Alarm loop
	while(alarm_timer > world.time)
		if(area_reference.alarm_disabled == 1 || alarm_timer == 0) return
		stoplag(1)
	if(area_reference.alarm_trigerred == 0)
		if(area_reference.alarm_disabled == 1 || alarm_timer == 0) return
		alarm_trigger()
		return

/obj/structure/vtm/dwelling_alarm/proc/minigame_loop() // Second alarm loop.
	var/light_time = rand(3 SECONDS, 6 SECONDS)
	var/blink_time
	switch(area_reference.loot_list["type"])
		if("minor")
			blink_time = 20
		if("moderate")
			blink_time = 15
		if("major")
			blink_time = 10
	while(alarm_timer > world.time)
		if(area_reference.alarm_trigerred == 1 || alarm_timer == 0) return
		icon_state = "doorctrl1"
		alarm_safety = 0
		update_icon()
		sleep(light_time)
		if(area_reference.alarm_trigerred == 1 || alarm_timer == 0) return
		icon_state = "doorctrl-p"
		update_icon()
		alarm_safety = 1
		sleep(blink_time)


/obj/structure/vtm/dwelling_alarm/proc/restart_alarm() //Delays triggering on an activated alarm
	var/alarm_delay
	switch(area_reference.loot_list["type"])
		if("minor","moderate")
			alarm_delay = 60 SECONDS
		if("major")
			alarm_delay = 30 SECONDS
	alarm_timer = world.time + alarm_delay
	return

/obj/structure/vtm/dwelling_alarm/proc/alarm_arm() //Arms itself and starts the alarm/minigame loops
	desc = "A small console with a display and small keyboard. It seems to be running a security check.  A small hole to the side of the panel looks like it would just fit a lockpick."
	say("Intrusion detected. Performing detailed scan.")
	playsound(src, 'sound/ambience/signal.ogg', 25)
	restart_alarm()
	alarm_active = 1
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/vtm/dwelling_alarm/, alarm_loop))
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/vtm/dwelling_alarm/, minigame_loop))

/obj/structure/vtm/dwelling_alarm/proc/alarm_disarm() //Shuts the alarm down
	say("Alarm disarmed. Have a nice day.")
	desc = initial(desc)
	icon_state = "doorctrl-p"
	update_icon()
	area_reference.alarm_disabled = 1
	alarm_active = 0
	alarm_timer = 0
	return

/obj/structure/vtm/dwelling_alarm/proc/alarm_reset() // Decides what to do during sucessful reset.
	switch(area_reference.loot_list["type"])
		if("minor")
			alarm_disarm()
		if("moderate","major")
			say("Error. Fluctuation in power supply. Restarting security scan...")
			restart_alarm()

/obj/structure/vtm/dwelling_alarm/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/vamp/keys/hack))
		if(area_reference.alarm_disabled == 1)
			to_chat(user, span_warning("The alarm is disabled and nothing seems to be able to change that."))
			return
		if(alarm_active == 0)
			to_chat(user, span_warning("You start to wiggle the lockpick in the opening. This will likely turn the alarm on if you do not stop!"))
			if(do_mob(user, src, 10 SECONDS))
				alarm_arm()
				return
		if(alarm_active == 1)
			if(area_reference.alarm_trigerred == 1)
				to_chat(user, span_warning("The alarm has already been set off, there is no point in messing with it now."))
				return
			if(alarm_safety == 0)
				to_chat(user, span_warning("You feel a button depress at the end of the opening. The alarm seems to activate!"))
				alarm_trigger()
				return
			if(alarm_safety == 1)
				to_chat(user, span_notice("You feel a button depress at the end of the opening. The display on the alarm flickers briefly!"))
				alarm_reset()
				return
	if(istype(I, /obj/item/vtm/dwelling_alarm_card))
		if(area_reference.alarm_trigerred == 0)
			to_chat(user, span_notice("You slide the card into a slot on the side of the alarm box. There is no visible reaction. "))
			return
		if(area_reference.alarm_trigerred == 1)
			to_chat(user, span_notice("You slide the card into a slot on the side of the alarm box. The alarm seems to start a disarming sequence."))
			alarm_disarm()
			return

/obj/structure/vtm/dwelling_alarm/Destroy()
	. = ..()
	area_reference = null
