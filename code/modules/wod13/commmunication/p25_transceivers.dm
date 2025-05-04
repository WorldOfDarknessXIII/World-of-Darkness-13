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


/obj/machinery/p25transceiver/Initialize(mapload)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_P25_SPAWNED_ON_LIVING, PROC_REF(register_callsign))
	RegisterSignal(src, COMSIG_REGISTER_P25, PROC_REF(register_callsign))

/obj/machinery/p25transceiver/Destroy()
	UnregisterSignal(SSdcs, COMSIG_P25_SPAWNED_ON_LIVING)
	. = ..()

/obj/machinery/p25transceiver/ui_interact(mob/user)
	. = ..()
	var/list/dat = list()
	dat += "<div class='statusDisplay'>"
	dat += "Status: [active ? "<span class='good'>ONLINE</span>" : "<span class='bad'>OFFLINE</span>"]<BR>"
	dat += "<A href='?src=[REF(src)];toggle=1'>[active ? "Turn Off" : "Turn On"]</A><BR><BR>"
	dat += "<A href='?src=[REF(src)];view_callsigns=1'>View Registered Callsigns</A>"
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
			for(var/obj/item/p25radio/radio as anything in connected_radios)
				if(!radio.can_receive())
					continue
				radio.audible_message("[radio] becomes completely silent.", null, /*distance =*/0)
		else
			active = TRUE
			to_chat(usr, "<span class='notice'>You activate [src].</span>")
			for(var/obj/item/p25radio/radio as anything in connected_radios)
				if(!radio.can_receive())
					continue
				radio.audible_message("[radio] begins to subtly hiss with reception static.", null, /*distance =*/0)
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


/obj/machinery/p25transceiver/attack_hand(mob/user)
	ui_interact(user)


/obj/machinery/p25transceiver/attackby(obj/item/p25radio/radio, mob/user, params)
	if(!istype(radio, /obj/item/p25radio))
		return ..()
	if(!active)
		to_chat(user, "<span class='warning'>[src] needs to be powered on first!</span>")
		return FALSE
	if(radio.linked_transceiver == src)
		unregister_callsign(radio)
		connected_radios -= radio
		to_chat(user, "<span class='notice'>You unlink [radio] from [src].</span>")
		return TRUE
	SEND_SIGNAL(src, COMSIG_REGISTER_P25, radio, user)


/obj/machinery/p25transceiver/proc/register_callsign(datum/source, obj/item/p25radio/radio, mob/user)
	SIGNAL_HANDLER

	var/proceed = FALSE
	var/new_callsign
	do
		new_callsign = input(user, "Enter a callsign for [src]:", "Register Callsign")
		if(!new_callsign || !istext(new_callsign))
			to_chat(user, span_notice("Callsign invalid, please try again."))
			continue
		if(!text2num(new_callsign))
			to_chat(user, span_notice("Callsign must be a number."))
			continue
		if(registered_callsigns.Find(new_callsign))
			to_chat(user, span_notice("Callsign [new_callsign] is already registered."))
			continue
		if(!radio.register_callsign(new_callsign, user))
			continue
		proceed = TRUE
	while(!proceed)
	registered_callsigns[new_callsign] = user.real_name
	radio.callsign = new_callsign
	radio.linked_transceiver = src
	connected_radios |= radio
	to_chat(user, "<span class='notice'>You link [W] to [src] with callsign [new_callsign].</span>")
	playsound(src, 'sound/effects/radioonn.ogg', 25, FALSE)
	announce_status(radio, user, TRUE)

	return "Successfully registered callsign [new_callsign]"


/obj/machinery/p25transceiver/proc/unregister_callsign(obj/item/p25radio/radio)
	var/callsign_removing = radio.callsign
	if(!callsign_removing)
		return FALSE
	announce_status(radio, user, FALSE)
	registered_callsigns -= callsign_removing
	radio.callsign = null

/obj/machinery/p25transceiver/proc/broadcast_message(message)
	message = replacetext(message, "\[.*?]", "")
	message = replacetext(message, "\\icon.*?\\]", "")

	message = replacetext(message, "\[<b>", "\[<b>TRANSCEIVER</b>\] \[<b>")

	audible_message(message)


/obj/machinery/p25transceiver/proc/broadcast_to_network(message, play_sound = 'sound/effects/radioclick.ogg', sound_volume = 30, check_dispatch = FALSE)
	if(!active)
		return FALSE

	broadcast_message(message)
	if(play_sound)
		playsound(src, play_sound, sound_volume, FALSE)

	SEND_SIGNAL(src, COMSIG_BROADCAST_NETWORK_MESSAGE, message)
	return TRUE


/obj/machinery/p25transceiver/clinic
	name = "clinic P25 transceiver"
	desc = "A P25 radio transceiver configured for clinic communications."
	p25_network = "clinic"


/obj/machinery/p25transceiver/tower
	name = "tower P25 transceiver"
	desc = "A P25 radio transceiver configured for general communications."
	p25_network = "tower"


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


/obj/machinery/p25transceiver/police/Initialize(mapload)
	. = ..()
	// Return a late initialization that way we don't try to initialize before the subsystems are ready
	return INITIALIZE_HINT_LATELOAD


/obj/machinery/p25transceiver/police/LateInitialize()
	. = ..()
	RegisterSignal(SShumannpcpool, COMSIG_ANNOUNCE_CRIME, PROC_REF(announce_crime))


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


/obj/machinery/p25transceiver/police/proc/announce_crime(datum/source, joined_message, announce_direction)
	if(!active)
		return

	broadcast_to_network(message, "police", 'sound/effects/radioclick.ogg', 10, TRUE)


/obj/machinery/p25transceiver/proc/announce_status(obj/item/p25radio/radio, mob/user, connecting)
	if(!active || !radio.callsign)
		return

	var/status_message = "[icon2html(src, world)]\[<b>DISPATCH</b>\]: <span class='robot'>[radio.callsign], [user.real_name], is [connecting ? "10-8" : "10-7"].</span>"
	broadcast_to_network(status_message)

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

