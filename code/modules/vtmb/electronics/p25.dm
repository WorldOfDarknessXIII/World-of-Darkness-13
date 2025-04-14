// P25 Radio System

GLOBAL_LIST_EMPTY(p25_radios)
GLOBAL_LIST_EMPTY(p25_tranceivers)

/obj/machinery/p25transceiver
	name = "P25 transceiver"
	desc = "A stationary P25 radio transceiver that handles radio connections."
	icon = 'icons/obj/radio.dmi'
	icon_state = "walkietalkie"
	anchored = TRUE
	density = TRUE
	var/active = TRUE
	var/list/connected_radios = list()
	var/p25_network = "default"
	var/list/registered_callsigns = list()

/obj/machinery/p25transceiver/Initialize()
	. = ..()
	GLOB.p25_tranceivers += src

/obj/machinery/p25transceiver/ui_interact(mob/user)
	. = ..()
	var/list/dat = list()
	dat += "<div class='statusDisplay'>"
	dat += "Status: [active ? "<span class='good'>ONLINE</span>" : "<span class='bad'>OFFLINE</span>"]<BR>"
	dat += "<A href='byond:?src=[REF(src)];toggle=1'>[active ? "Turn Off" : "Turn On"]</A><BR><BR>"
	dat += "<A href='byond:?src=[REF(src)];view_callsigns=1'>View Registered Callsigns</A>"
	dat += "</div>"

	var/datum/browser/popup = new(user, "p25_transceiver", "[src.name]", 300, 220)
	popup.set_content(dat.Join())
	popup.open()

/obj/machinery/p25transceiver/ui_data(mob/user)
	var/list/data = list()
	data["active"] = active
	data["registered_callsigns"] = list()

	var/list/sorted_callsigns = list()
	for(var/callsign in registered_callsigns)
		sorted_callsigns += callsign
	sortTim(sorted_callsigns, /proc/cmp_numeric_asc)

	for(var/callsign in sorted_callsigns)
		data["registered_callsigns"] += list(list(
			"callsign" = callsign,
			"name" = registered_callsigns[callsign]
		))

	return data

/obj/machinery/p25transceiver/Topic(href, href_list)
	if(..())
		return
	if(!Adjacent(usr))
		return

	if(href_list["toggle"])
		if(active)
			active = FALSE
			to_chat(usr, "<span class='notice'>You deactivate [src].</span>")
			for(var/obj/item/p25radio/R in connected_radios)
				if(R.linked_network == p25_network)
					playsound(R, 'sound/effects/radiodestatic.ogg', 50, FALSE)
					for(var/mob/M in get_hearers_in_view(1, get_turf(R)))
						to_chat(M, "<span class='warning'>The [R] emits a burst of static as it loses connection to the transceiver.</span>")
		else
			active = TRUE
			to_chat(usr, "<span class='notice'>You activate [src].</span>")
			for(var/obj/item/p25radio/R in connected_radios)
				if(R.linked_network == p25_network)
					playsound(R, 'sound/effects/radioonn.ogg', 50, FALSE)
					for(var/mob/M in get_hearers_in_view(1, get_turf(R)))
						to_chat(M, "<span class='notice'>The [R] chirps as it establishes connection to the transceiver.</span>")
		update_icon()

	if(href_list["view_callsigns"])
		var/dat = "<div class='statusDisplay'>"
		dat += "<B>Registered Callsigns:</B><BR>"
		if(length(registered_callsigns))
			var/list/sorted_callsigns = list()
			for(var/callsign in registered_callsigns)
				var/num = text2num(callsign)
				if(num)
					sorted_callsigns += num
			sortTim(sorted_callsigns, /proc/cmp_numeric_asc)
			for(var/num in sorted_callsigns)
				dat += "[num] - [registered_callsigns["[num]"]]<BR>"
		else
			dat += "No callsigns registered.<BR>"
		dat += "</div>"

		var/datum/browser/popup = new(usr, "callsigns", "Registered Callsigns", 300, 300)
		popup.set_content(dat)
		popup.open()

	updateDialog()

/obj/machinery/p25transceiver/proc/register_callsign(obj/item/p25radio/radio, callsign, mob/user)
	if(!callsign || !istext(callsign))
		return "Invalid callsign format"

	var/validation_result = radio.register_callsign(callsign)
	if(validation_result != TRUE)
		return validation_result

	if(callsign in registered_callsigns)
		return "Callsign [callsign] is already registered"

	registered_callsigns[callsign] = user.real_name
	radio.callsign = callsign

	if(istype(src, /obj/machinery/p25transceiver/police))
		var/obj/machinery/p25transceiver/police/P = src
		P.announce_status(radio, user, TRUE)

	return "Successfully registered callsign [callsign]"

/obj/machinery/p25transceiver/proc/unregister_callsign(obj/item/p25radio/radio)
	if(radio.callsign)
		if(istype(src, /obj/machinery/p25transceiver/police))
			var/obj/machinery/p25transceiver/police/P = src
			var/mob/user = null
			for(var/mob/M in get_hearers_in_view(1, get_turf(radio)))
				if(M.real_name == registered_callsigns[radio.callsign])
					user = M
					break
			if(user)
				P.announce_status(radio, user, FALSE)
		registered_callsigns -= radio.callsign
		radio.callsign = null

/obj/machinery/p25transceiver/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/p25transceiver/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/p25radio))
		if(!active)
			to_chat(user, "<span class='warning'>[src] needs to be powered on first!</span>")
			return
		var/obj/item/p25radio/radio = W
		if(radio.linked_network == p25_network)
			unregister_callsign(radio)
			radio.linked_network = null
			radio.linked_transceiver = null
			connected_radios -= radio
			to_chat(user, "<span class='notice'>You unlink [W] from [src].</span>")
			return

		var/new_callsign = input(user, "Enter a callsign for this radio:", "Register Callsign") as text|null
		if(!new_callsign)
			return
		var/registration_result = register_callsign(radio, new_callsign, user)
		if(registration_result != "Successfully registered callsign [new_callsign]")
			to_chat(user, "<span class='warning'>[registration_result]</span>")
			return

		radio.linked_network = p25_network
		radio.linked_transceiver = src
		connected_radios |= radio
		to_chat(user, "<span class='notice'>You link [W] to [src] with callsign [new_callsign].</span>")
		playsound(src, 'sound/effects/radioonn.ogg', 25, FALSE)
	else
		return ..()

/obj/machinery/p25transceiver/proc/broadcast_message(message)
	message = replacetext(message, "\[.*?]", "")
	message = replacetext(message, "\\icon.*?\\]", "")

	message = replacetext(message, "\[<b>", "\[<b>TRANSCEIVER</b>\] \[<b>")

	for(var/mob/listener in get_hearers_in_view(7, get_turf(src)))
		to_chat(listener, message)

/obj/machinery/p25transceiver/proc/broadcast_to_network(message, network = src.p25_network, play_sound = 'sound/effects/radioclick.ogg', sound_volume = 30, check_dispatch = FALSE)
	if(!active)
		return FALSE

	broadcast_message(message)

	for(var/obj/item/p25radio/R in GLOB.p25_radios)
		if(R.linked_network != network)
			continue
		if(!R.check_signal())
			continue
		if(!R.receiving)
			continue
		if(check_dispatch && istype(R, /obj/item/p25radio/police))
			var/obj/item/p25radio/police/P = R
			if(!P.dispatch_monitoring)
				continue

		for(var/mob/listener in get_hearers_in_view(1, get_turf(R)))
			to_chat(listener, message)
			if(play_sound)
				playsound(R, play_sound, sound_volume, FALSE)
	return TRUE

// ==============================
// Clinic/Tower Transceivers
// ==============================

/obj/machinery/p25transceiver/clinic
	name = "clinic P25 transceiver"
	desc = "A P25 radio transceiver configured for clinic communications."
	p25_network = "clinic"

/obj/machinery/p25transceiver/tower
	name = "tower P25 transceiver"
	desc = "A P25 radio transceiver configured for general communications."
	p25_network = "tower"

// ==============================
// Police Transceiver
// ==============================

/obj/machinery/p25policeportal
	name = "police P25 linker"
	desc = "A stationary P25 radio transceiver that handles radio connections."
	icon = 'icons/obj/radio.dmi'
	icon_state = "walkietalkie"
	anchored = TRUE
	density = TRUE
	var/obj/machinery/p25transceiver/police/transceiver

/obj/machinery/p25policeportal/LateInitialize()
	. = ..()
	for(var/obj/machinery/p25transceiver/P in GLOB.p25_tranceivers)
		if(P.p25_network == "police")
			transceiver = P
			break

/obj/machinery/p25policeportal/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/p25radio))
		var/obj/item/p25radio/radio = W
		if(radio.linked_network == transceiver.p25_network)
			transceiver.unregister_callsign(radio)
			radio.linked_network = null
			radio.linked_transceiver = null
			transceiver.connected_radios -= radio
			to_chat(user, "<span class='notice'>You unlink [W] from [src].</span>")
			return

		var/new_callsign = input(user, "Enter a callsign for this radio:", "Register Callsign") as text|null
		if(!new_callsign)
			return
		var/registration_result = transceiver.register_callsign(radio, new_callsign, user)
		if(registration_result != "Successfully registered callsign [new_callsign]")
			to_chat(user, "<span class='warning'>[registration_result]</span>")
			return

		radio.linked_network = transceiver.p25_network
		radio.linked_transceiver = transceiver
		transceiver.connected_radios |= radio
		to_chat(user, "<span class='notice'>You link [W] to [transceiver] with callsign [new_callsign].</span>")
		playsound(src, 'sound/effects/radioonn.ogg', 25, FALSE)
	else
		return ..()

/obj/machinery/p25transceiver/police
	name = "police P25 transceiver"
	desc = "A P25 radio transceiver configured for police communications."
	p25_network = "police"
	var/last_emergency = 0
	var/emergency_cooldown = 600
	var/last_shooting = 0
	var/last_shooting_victims = 0
	var/last_status_change = 0
	var/status_cooldown = 100
	var/list/radio_emergency_cooldowns = list()

/obj/machinery/p25transceiver/police/Topic(href, href_list)
	if(..())
		return
	if(!Adjacent(usr))
		return

	if(href_list["view_callsigns"])
		var/dat = "<div class='statusDisplay'>"
		dat += "<B>Registered Callsigns:</B><BR><BR>"

		var/list/command_signs = list()
		var/list/supervisor_signs = list()
		var/list/patrol_signs = list()
		var/list/dispatch_signs = list()
		var/list/tactical_signs = list()
		var/list/government_signs = list()

		for(var/callsign in registered_callsigns)
			var/num = text2num(callsign)
			if(!num)
				continue

			if(num >= 1 && num <= 9)
				command_signs += num
			else if(num >= 10 && num <= 99)
				supervisor_signs += num
			else if(num >= 100 && num <= 499)
				patrol_signs += num
			else if(num >= 500 && num <= 599)
				dispatch_signs += num
			else if(num >= 600 && num <= 699)
				tactical_signs += num
			else if(num >= 700 && num <= 799)
				government_signs += num

		if(length(command_signs))
			dat += "<B>Command (1-9):</B><BR>"
			sortTim(command_signs, /proc/cmp_numeric_asc)
			for(var/num in command_signs)
				dat += "[num] - [registered_callsigns["[num]"]]<BR>"
			dat += "<BR>"

		if(length(supervisor_signs))
			dat += "<B>Supervisors (10-99):</B><BR>"
			sortTim(supervisor_signs, /proc/cmp_numeric_asc)
			for(var/num in supervisor_signs)
				dat += "[num] - [registered_callsigns["[num]"]]<BR>"
			dat += "<BR>"

		if(length(patrol_signs))
			dat += "<B>Patrol (100-499):</B><BR>"
			sortTim(patrol_signs, /proc/cmp_numeric_asc)
			for(var/num in patrol_signs)
				dat += "[num] - [registered_callsigns["[num]"]]<BR>"
			dat += "<BR>"

		if(length(dispatch_signs))
			dat += "<B>Dispatch (500-599):</B><BR>"
			sortTim(dispatch_signs, /proc/cmp_numeric_asc)
			for(var/num in dispatch_signs)
				dat += "[num] - [registered_callsigns["[num]"]]<BR>"
			dat += "<BR>"

		if(length(tactical_signs))
			dat += "<B>Tactical (600-699):</B><BR>"
			sortTim(tactical_signs, /proc/cmp_numeric_asc)
			for(var/num in tactical_signs)
				dat += "[num] - [registered_callsigns["[num]"]]<BR>"
			dat += "<BR>"

		if(length(government_signs))
			dat += "<B>Government (700-799):</B><BR>"
			sortTim(government_signs, /proc/cmp_numeric_asc)
			for(var/num in government_signs)
				dat += "[num] - [registered_callsigns["[num]"]]<BR>"
			dat += "<BR>"

		if(!length(registered_callsigns))
			dat += "No callsigns registered.<BR>"
		dat += "</div>"

		var/datum/browser/popup = new(usr, "callsigns", "Registered Callsigns", 400, 600)
		popup.set_content(dat)
		popup.open()

	updateDialog()

/obj/machinery/p25transceiver/police/proc/broadcast_emergency(obj/item/p25radio/police/source)
	if(!active || !source)
		return FALSE

	var/current_time = world.time
	if(radio_emergency_cooldowns[source] && current_time < radio_emergency_cooldowns[source])
		var/remaining = max(0, round((radio_emergency_cooldowns[source] - current_time)/10, 0.1))
		to_chat(usr, "<span class='warning'>The transceiver is still reconfiguring from the previous emergency alert! It will be available again in [remaining] seconds.</span>")
		return FALSE

	radio_emergency_cooldowns[source] = current_time + emergency_cooldown

	var/turf/T = get_turf(source)
	var/area/A = get_area(source)
	var/coords = "[T.x], [T.y]"
	var/prefix = source.get_prefix()
	var/emergency_msg = "\[<b><span class='red'>[prefix]-[source.callsign]</span></b>\]: <span class='robot'><b><span class='red'>11-99 OFFICER NEEDS ASSISTANCE AT: [A.name] ([coords])</span></b></span>"
	var/formatted = "[icon2html(source, world)] [emergency_msg]"

	return broadcast_to_network(formatted, "police", 'sound/effects/radioalert.ogg', 100)

/obj/machinery/p25transceiver/police/proc/announce_crime(crime, atom/location)
	if(!active || !location)
		return

	var/area/A = get_area(location)
	if(!A)
		return

	var/coords = "[location.x]:[location.y]"
	var/message = ""
	var/should_announce = FALSE

	switch(crime)
		if("shooting")
			if(last_shooting + 50 < world.time)
				last_shooting = world.time
				message = "Gun shots at [A.name], [coords]"
				should_announce = TRUE
		if("victim")
			if(last_shooting_victims + 50 < world.time)
				last_shooting_victims = world.time
				message = "Engaged combat at [A.name], wounded civillian, [coords]"
				should_announce = TRUE
		if("murder")
			message = "Murder at [A.name], [coords]"
			should_announce = TRUE
		if("burglary")
			message = "Burglary at [A.name], [coords]"

	if(should_announce)
		var/formatted = "[icon2html(src, world)]\[<b>DISPATCH</b>\]: <span class='robot'>[message]</span>"
		broadcast_to_network(formatted, "police", 'sound/effects/radioclick.ogg', 10, TRUE)

/obj/machinery/p25transceiver/police/proc/announce_status(obj/item/p25radio/radio, mob/user, connecting)
	if(!active || !radio.callsign)
		return

	if(istype(radio, /obj/item/p25radio/police))
		var/obj/item/p25radio/police/police_radio = radio
		var/last_status_change = police_radio.last_status_change
		if(world.time < last_status_change + police_radio.status_cooldown)
			return
		police_radio.last_status_change = world.time
	else
		return

	var/status_message = "[icon2html(src, world)]\[<b>DISPATCH</b>\]: <span class='robot'>[radio.callsign], [user.real_name], is [connecting ? "10-8" : "10-7"].</span>"
	broadcast_to_network(status_message, "police")

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
	var/linked_network = null
	var/obj/machinery/p25transceiver/linked_transceiver = null
	var/callsign = null
	flags_1 = HEAR_1
	var/receiving = TRUE
	var/in_restricted_area = FALSE
	var/powered = TRUE  // New var to track power state

/obj/item/p25radio/Initialize()
	. = ..()
	GLOB.p25_radios += src

/obj/item/p25radio/Destroy()
	GLOB.p25_radios -= src
	return ..()

/obj/item/p25radio/examine(mob/user)
	. = ..()
	if(linked_network)
		. += "<span class='notice'>This radio is linked to the [linked_network] network.</span>"
	else
		. += "<span class='notice'>This radio is not linked to any network. Click on a transceiver with it to link it.</span>"
	. += "<span class='notice'>The radio is currently [powered ? "ON" : "OFF"].</span>"

/obj/item/p25radio/proc/register_callsign(callsign)
	if(!callsign || !istext(callsign))
		return "Invalid callsign format"
	var/num = text2num(callsign)
	if(!num)
		return "Callsign must be a number"
	if(length(callsign) != 3)
		return "Callsign must be 3 digits"
	return TRUE

/obj/item/p25radio/proc/get_network_display_name()
	switch(linked_network)
		if("police")
			return "Police Radio Transceiver"
		if("clinic")
			return "Clinic Radio Transceiver"
		if("tower")
			return "Tower Radio Transceiver"
		else
			return "Radio Transceiver"

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
	switch(linked_network)
		if("police")
			return "PRT"
		if("clinic")
			return "CRT"
		if("tower")
			return "TRT"
		else
			return "RT"

/obj/item/p25radio/proc/format_message(message)
	if(!callsign)
		return "[icon2html(src, world)] \[UNREGISTERED\]: <span class='robot'>\"[message]\"</span>"
	var/prefix = get_prefix()
	return "[icon2html(src, world)] \[<b>[prefix]-[callsign]</b>\]: <span class='robot'>\"[message]\"</span>"

/obj/item/p25radio/proc/can_receive(atom/movable/speaker, message_mods)
	if(!powered)
		return FALSE
	if(!linked_network)
		return FALSE
	if(!message_mods || !message_mods[RADIO_EXTENSION])
		return FALSE
	if(!linked_transceiver?.active)
		return FALSE
	return TRUE

/obj/item/p25radio/proc/check_signal()
	var/currently_restricted = !is_in_valid_area(src)

	if(currently_restricted && !in_restricted_area)
		for(var/mob/M in get_hearers_in_view(1, get_turf(src)))
			to_chat(M, "<span class='warning'>The [src] emits a burst of static as it loses connection to the transceiver.</span>")
		playsound(src, 'sound/effects/radiodestatic.ogg', 50, FALSE)
		in_restricted_area = TRUE
		return FALSE
	else if(!currently_restricted && in_restricted_area)
		for(var/mob/M in get_hearers_in_view(1, get_turf(src)))
			to_chat(M, "<span class='notice'>The [src] chirps as it establishes connection to the transceiver.</span>")
		playsound(src, 'sound/effects/radioonn.ogg', 50, FALSE)
		in_restricted_area = FALSE

	if(currently_restricted || (linked_transceiver && !linked_transceiver.active))
		return FALSE
	return TRUE

/obj/item/p25radio/proc/can_transmit(mob/speaker)
	if(!powered)
		return FALSE
	if(!speaker)
		return FALSE
	if(speaker.get_active_held_item() == src || speaker.get_inactive_held_item() == src || speaker.get_item_by_slot(ITEM_SLOT_BELT) == src || speaker.get_item_by_slot(ITEM_SLOT_EARS) == src)
		return TRUE
	return FALSE

/obj/item/p25radio/proc/p25_talk_into(atom/movable/speaker, message, channel, list/spans, datum/language/language, list/message_mods = list())
	if(!linked_network)
		if(ismob(speaker))
			to_chat(speaker, "<span class='warning'>The radio fails to transmit because it is not linked to a transceiver.</span>")
		return NONE

	if(!ismob(speaker))
		return NONE

	var/mob/living/L = speaker
	if(istype(L))
		if(L.stat > CONSCIOUS)
			return NONE

	if(!can_transmit(speaker))
		return NONE

	if(!check_signal())
		if(!is_in_valid_area(src))
			to_chat(speaker, "<span class='warning'>The radio fails to transmit from this location!</span>")
		else if(linked_transceiver && !linked_transceiver.active)
			to_chat(speaker, "<span class='warning'>The radio fails to transmit because the transceiver has been disabled.</span>")
		return ITALICS | REDUCE_RANGE

	if(isliving(speaker))
		if(L.get_item_by_slot(ITEM_SLOT_BELT) == src || L.get_item_by_slot(ITEM_SLOT_EARS) == src || L.get_active_held_item() == src || L.get_inactive_held_item() == src)
			L.visible_message("<span class='notice'>[L] talks into the [src].</span>", "<span class='notice'>You talk into the [src].</span>")
		else
			return FALSE

	playsound(src, 'sound/effects/radioclick.ogg', 30, FALSE)

	var/formatted = format_message(message)
	if(check_signal())
		for(var/obj/item/p25radio/R in GLOB.p25_radios)
			if(R.linked_network != linked_network)
				continue
			if(!R.check_signal())
				continue
			if(!R.receiving)
				continue

			for(var/mob/listener in get_hearers_in_view(1, get_turf(R)))
				to_chat(listener, formatted)

		if(linked_transceiver)
			linked_transceiver.broadcast_message(formatted)

		playsound(src, 'sound/effects/radioclick.ogg', 30, FALSE)

	return ITALICS | REDUCE_RANGE

/obj/item/p25radio/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	. = ..()
	if(!can_receive(speaker, message_mods))
		return

	var/mob/living/speaker_mob = speaker
	if(!istype(speaker_mob) || (speaker_mob.get_item_by_slot(ITEM_SLOT_BELT) != src && speaker_mob.get_item_by_slot(ITEM_SLOT_EARS) != src))
		return

	if(!check_signal())
		return

	var/formatted = format_message(raw_message)
	for(var/mob/M in get_hearers_in_view(1, get_turf(src)))
		to_chat(M, formatted)
	playsound(src, 'sound/effects/radioclick.ogg', 30, FALSE)

/obj/item/p25radio/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	powered = !powered
	to_chat(user, "<span class='notice'>You turn the radio [powered ? "ON" : "OFF"].</span>")
	playsound(src, 'sound/effects/radioonn.ogg', 100, FALSE)

/obj/item/p25radio/Moved()
	. = ..()
	check_signal()

/mob/living/Moved()
	. = ..()
	var/obj/item/p25radio/belt_radio = get_item_by_slot(ITEM_SLOT_BELT)
	if(istype(belt_radio))
		belt_radio.check_signal()
	var/obj/item/p25radio/ear_radio = get_item_by_slot(ITEM_SLOT_EARS)
	if(istype(ear_radio))
		ear_radio.check_signal()

// ==============================
//police radios, extra functionality cause they're cops
// ==============================

/obj/item/p25radio/police
	name = "P25 police radio"
	desc = "A police-issue high-performance two-way radio designed for secure, clear communication in demanding environments, featuring a durable shoulder microphone for hands-free operation. Use .r to transmit and alt-click to toggle receiving, dispatch monitoring, or press your panic button."
	var/dispatch_monitoring = TRUE
	var/last_status_change = 0
	var/status_cooldown = 100

/obj/item/p25radio/police/Initialize()
	. = ..()
	GLOB.police_radios += src

/obj/item/p25radio/police/Destroy()
	GLOB.police_radios -= src
	return ..()

/obj/item/p25radio/police/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Radio receiving is [receiving ? "enabled" : "disabled"]</span>"
	. += "<span class='notice'>Dispatch monitoring is [dispatch_monitoring ? "enabled" : "disabled"]</span>"
	var/turf/T = get_turf(user)
	if(T)
		. += "<b>Location:</b> [T.x]:[T.y]"

/obj/item/p25radio/police/register_callsign(callsign)
	if(!callsign || !istext(callsign))
		return "Invalid callsign format"
	var/num = text2num(callsign)
	if(!num)
		return "Callsign must be a number"
	if(num < 100 || num > 499)
		return "Patrol callsign must be between 100 - 499"
	return TRUE

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

/obj/item/p25radio/police/proc/toggle_receiving(mob/user)
	receiving = !receiving
	to_chat(user, "<span class='notice'>You [receiving ? "enable" : "disable"] radio receiving.</span>")

/obj/item/p25radio/police/proc/toggle_dispatch(mob/user)
	dispatch_monitoring = !dispatch_monitoring
	to_chat(user, "<span class='notice'>You [dispatch_monitoring ? "enable" : "disable"] dispatch monitoring.</span>")

/obj/item/p25radio/police/proc/trigger_emergency(mob/user)
	if(!linked_network || linked_network != "police")
		to_chat(user, "<span class='warning'>Emergency alert only works on police network!</span>")
		return

	if(!check_signal())
		if(!is_in_valid_area(src))
			to_chat(user, "<span class='warning'>The radio fails to transmit from this location!</span>")
		else if(linked_transceiver && !linked_transceiver.active)
			to_chat(user, "<span class='warning'>The radio crackles with static as it loses connection to the [get_network_display_name()].</span>")
		return

	var/obj/machinery/p25transceiver/police/police_transceiver = linked_transceiver
	if(!istype(police_transceiver))
		to_chat(user, "<span class='warning'>Emergency alert only works with police transceivers!</span>")
		return

	if(!police_transceiver.broadcast_emergency(src))
		return

/obj/item/p25radio/police/proc/announce_crime(crime, atom/location)
	if(!linked_transceiver || !istype(linked_transceiver, /obj/machinery/p25transceiver/police))
		return
	var/obj/machinery/p25transceiver/police/police_transceiver = linked_transceiver
	police_transceiver.announce_crime(crime, location)

// ==============================
// police radio subtypes, special callsigns
// ==============================

// police command radio
/obj/item/p25radio/police/command
	name = "P25 police command radio"

/obj/item/p25radio/police/command/register_callsign(callsign)
	if(!callsign || !istext(callsign))
		return "Invalid callsign format"
	var/num = text2num(callsign)
	if(!num)
		return "Callsign must be a number"
	if(num < 1 || num > 9)
		return "Command callsign must be between 1-9"
	callsign = "[num]"
	return TRUE

// police supervisor radio
/obj/item/p25radio/police/supervisor
	name = "P25 police supervisor radio"

/obj/item/p25radio/police/supervisor/register_callsign(callsign)
	if(!callsign || !istext(callsign))
		return "Invalid callsign format"
	var/num = text2num(callsign)
	if(!num)
		return "Callsign must be a number"
	if(num < 10 || num > 99)
		return "Supervisor callsign must be between 10-99"
	callsign = "[num]"
	return TRUE

// police dispatch radio
/obj/item/p25radio/police/dispatch
	name = "P25 police dispatch radio"

/obj/item/p25radio/police/dispatch/register_callsign(callsign)
	if(!callsign || !istext(callsign))
		return "Invalid callsign format"
	var/num = text2num(callsign)
	if(!num)
		return "Callsign must be a number"
	if(num < 500 || num > 599)
		return "Dispatch callsign must be between 500-599"
	return TRUE

/obj/item/p25radio/police/dispatch/get_prefix()
	return "DISPATCH"

// SWAT Radio
/obj/item/p25radio/police/tactical
	name = "P25 tactical radio"
/obj/item/p25radio/police/tactical/register_callsign(callsign)
	if(!callsign || !istext(callsign))
		return "Invalid callsign format"
	var/num = text2num(callsign)
	if(!num)
		return "Callsign must be a number"
	if(num < 600 || num > 699)
		return "Tactical callsign must be between 600-699"
	callsign = "[num]"
	return TRUE

//national guard/FBI radio
/obj/item/p25radio/police/government
	name = "P25 government radio"
/obj/item/p25radio/police/government/register_callsign(callsign)
	if(!callsign || !istext(callsign))
		return "Invalid callsign format"
	var/num = text2num(callsign)
	if(!num)
		return "Callsign must be a number"
	if(num < 700 || num > 799)
		return "Government callsign must be between 700-799"
	callsign = "[num]"
	return TRUE

