// ==============================
// P25 Radio
// ==============================

/obj/item/p25radio
	name = "P25 radio"
	desc = "A rugged, high-performance two-way radio designed for secure, clear communication in demanding environments, featuring a durable shoulder microphone for hands-free operation. Use .r to transmit through the radio and alt-click to toggle radio receiving."
	icon = 'icons/obj/radio.dmi'
	icon_state = "p25"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_EARS
	worn_icon = "blank" // needed so that weird pink default thing doesn't show up
	worn_icon_state = "blank" // needed so that weird pink default thing doesn't show up
	var/obj/machinery/p25transceiver/linked_transceiver = null
	var/callsign = null
	var/regex/callsign_regex = null
	var/callsign_failure = "Invalid callsign."
	flags_1 = HEAR_1
	var/powered = TRUE  // New var to track power state

/obj/item/p25radio/Initialize(mapload)
	. = ..()

	return INITIALIZE_HINT_LATELOAD

/obj/item/p25radio/LateInitialize()
	. = ..()
	if(get(loc, /mob/living))
		SEND_GLOBAL_SIGNAL(COMSIG_P25_SPAWNED_ON_LIVING, src)
	if(callsign_regex)
		callsign_regex = regex(callsign_regex)

/obj/item/p25radio/Destroy()
	if(linked_transceiver)
		linked_transceiver.unregister_callsign(src)
	return ..()

/obj/item/p25radio/examine(mob/user)
	. = ..()
	if(linked_transceiver)
		. += "<span class='notice'>Linked to network [linked_transceiver.network_name].</span>"
	else
		. += "<span class='warning'>Not linked to a transceiver.</span>"
	. += "<span class='notice'>The radio is currently [powered ? "ON" : "OFF"].</span>"


// restricted areas, add more if you don't want the p25s to work in that area.
/obj/item/p25radio/proc/is_in_valid_area(atom/A)
	var/static/list/restricted_areas = list(
		/area/vtm/sewer,
		/area/vtm/sewer/nosferatu_town,
		/area/vtm/sewer/old_clan_sanctum
	)
	var/area/current_area = get_area(A)
	for(var/restricted_type in restricted_areas)
		if(istype(current_area, restricted_type))
			return FALSE
	return TRUE

/obj/item/p25radio/proc/get_prefix()
	if(!callsign)
		return null
	return linked_transceiver.net_prefix

/obj/item/p25radio/proc/format_message(message)
	if(!callsign)
		return "[icon2html(src, world)] \[UNREGISTERED\]: <span class='robot'>\"[message]\"</span>"
	var/prefix = get_prefix()
	return "[icon2html(src, world)] \[<b>[prefix]-[callsign]</b>\]: <span class='robot'>\"[message]\"</span>"

/obj/item/p25radio/proc/can_receive(atom/movable/speaker, message_mods)
	if(!powered)
		return FALSE
	if(!check_signal())
		return FALSE
	if(!linked_transceiver)
		return FALSE
	if(!message_mods || !message_mods[RADIO_EXTENSION])
		return FALSE
	if(!linked_transceiver?.active)
		return FALSE
	return TRUE

/obj/item/p25radio/proc/check_signal()
	var/currently_restricted = !is_in_valid_area(src)

	if(currently_restricted)
		return FALSE
	return TRUE

/obj/item/p25radio/proc/can_transmit(mob/speaker)
	if(!powered)
		to_chat(speaker, span_warning("The radio seems to be unpowered."))
		return FALSE
	if(!check_signal())
		to_chat(speaker, span_warning("The radio LED flashes the pattern for NO SIGNAL."))
		return FALSE
	if(!linked_transceiver)
		to_chat(speaker, span_warning("The radio is not linked to a transceiver."))
		return FALSE
	if(speaker.get_active_held_item() == src || speaker.get_inactive_held_item() == src || speaker.get_item_by_slot(ITEM_SLOT_BELT) == src || speaker.get_item_by_slot(ITEM_SLOT_EARS) == src)
		return TRUE
	else
		to_chat(speaker, span_warning("You must be holding or wearing the radio to transmit."))
	return FALSE

/obj/item/p25radio/proc/p25_talk_into(atom/movable/speaker, message, channel, list/spans, datum/language/language, list/message_mods = list())
	var/transmit_status = can_transmit(speaker)
	if(!transmit_status)
		return FALSE


	speaker.visible_message("<span class='notice'>[speaker] talks into the [src].</span>", "<span class='notice'>You talk into the [src].</span>")

	var/formatted = format_message(message)
	linked_transceiver.broadcast_message(formatted)
	playsound(src, 'sound/effects/radioclick.ogg', 30, FALSE)

	return ITALICS | REDUCE_RANGE

/obj/item/p25radio/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	powered = !powered
	to_chat(user, "<span class='notice'>You turn the radio [powered ? "ON" : "OFF"].</span>")
	playsound(src, 'sound/effects/radioonn.ogg', 100, FALSE)


// ==============================
//police radios, extra functionality cause they're cops
// ==============================

/obj/item/p25radio/police
	name = "P25 police radio"
	desc = "A police-issue high-performance two-way radio designed for secure, clear communication in demanding environments, featuring a durable shoulder microphone for hands-free operation. Use .r to transmit and alt-click to toggle receiving, dispatch monitoring, or press your panic button."
	var/dispatch_monitoring = TRUE
	callsign_regex = "^(1|2|3|4)\d\d)$"
	callsign_failure = "Patrol callsign must be between 100-499."

/obj/item/p25radio/police/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Dispatch monitoring is [dispatch_monitoring ? "enabled" : "disabled"]</span>"
	var/turf/T = get_turf(user)
	if(T)
		. += "<b>Location:</b> [T.x]:[T.y]"


/obj/item/p25radio/police/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE))
		return

	var/list/choices = list(
		"Toggle Radio Power" = "power",
		"Toggle Dispatch Monitoring" = "dispatch",
		"Press Panic Button" = "emergency"
	)

	var/choice = input(user, "Select an option:", "[src]") as null|anything in choices
	if(!choice || !user.canUseTopic(src, BE_CLOSE))
		return

	switch(choices[choice])
		if("power")
			powered = !powered
			to_chat(user, "<span class='notice'>You turn the radio [powered ? "ON" : "OFF"].</span>")
		if("dispatch")
			toggle_dispatch(user)
		if("emergency")
			trigger_emergency(user)

	playsound(src, 'sound/effects/radioonn.ogg', 100, FALSE)

/obj/item/p25radio/police/proc/toggle_dispatch(mob/user)
	dispatch_monitoring = !dispatch_monitoring
	to_chat(user, "<span class='notice'>You [dispatch_monitoring ? "enable" : "disable"] dispatch monitoring.</span>")

/obj/item/p25radio/police/proc/trigger_emergency(mob/user)
	if(!istype(linked_transceiver, /obj/machinery/p25transceiver/police))
		to_chat(user, "<span class='warning'>Emergency alert only works on police network!</span>")
		return

	if(!can_transmit(user))
		return FALSE

	var/obj/machinery/p25transceiver/police/police_transceiver = linked_transceiver
	if(!istype(police_transceiver))
		to_chat(user, "<span class='warning'>Emergency alert only works with police transceivers!</span>")
		return

	if(!police_transceiver.broadcast_emergency(src))
		return

// ==============================
// police radio subtypes, special callsigns
// ==============================

// police command radio
/obj/item/p25radio/police/command
	name = "P25 police command radio"
	callsign_regex = "^(1|2|3|4|5|6|7|8|9)$"
	callsign_failure ="Command callsign must be between 1-9."

// police supervisor radio
/obj/item/p25radio/police/supervisor
	name = "P25 police supervisor radio"
	callsign_regex = "^(1|2|3|4|5|6|7|8|9)\d$"
	callsign_failure = "Supervisor callsign must be between 10-99."


// police dispatch radio
/obj/item/p25radio/police/dispatch
	name = "P25 police dispatch radio"
	callsign_regex = "^5\d\d$"
	callsign_failure = "Dispatch callsign must be between 500-599."


/obj/item/p25radio/police/dispatch/get_prefix()
	return "DISPATCH"

// SWAT Radio
/obj/item/p25radio/police/tactical
	name = "P25 tactical radio"
	callsign_regex = "^(6|7|8|9)\d\d$"
	callsign_failure = "Tactical callsign must be between 600-699."


//national guard/FBI radio
/obj/item/p25radio/police/government
	name = "P25 government radio"
	callsign_regex = "^(7|8|9)\d\d$"
	callsign_failure = "Government callsign must be between 700-799."

/obj/item/p25radio/proc/register_callsign(input, mob/user)
	if(!callsign_regex.Find(input))
		to_chat(user, "<span class='warning'>[callsign_failure]</span>")
		return FALSE
	callsign = input
	to_chat(user, "<span class='notice'>Callsign registered as [callsign].</span>")
	return TRUE
