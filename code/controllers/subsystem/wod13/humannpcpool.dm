

GLOBAL_LIST_EMPTY(npc_spawn_points)
SUBSYSTEM_DEF(humannpcpool)
	name = "Human NPC Pool"
	flags = SS_POST_FIRE_TIMING|SS_NO_INIT|SS_BACKGROUND
	priority = FIRE_PRIORITY_VERYLOW
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 30

	var/list/currentrun = list()
	var/npc_max = 220
	// Uses the crime defines from code/modules/wod13/crime_defines.dm
	var/list/crime_report_message = list(
		"Officers requested",
		"Gunshots reported",
		"Possible homicide reported",
		"Assault reported",
		"Attempted kidnapping reported",
	)

/datum/controller/subsystem/humannpcpool/stat_entry(msg)
	var/list/activelist = GLOB.npc_list
	var/list/living_list = GLOB.alive_npc_list
	msg = "NPCS:[length(activelist)] Living: [length(living_list)]"
	return ..()

/datum/controller/subsystem/humannpcpool/fire(resumed = FALSE)

	if (!resumed)
		var/list/activelist = GLOB.npc_list
		src.currentrun = activelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/mob/living/carbon/human/npc/NPC = currentrun[currentrun.len]
		--currentrun.len

		if (QDELETED(NPC)) // Some issue causes nulls to get into this list some times. This keeps it running, but the bug is still there.
			GLOB.npc_list -= NPC		//HUH??? A BUG? NO WAY
			GLOB.alive_npc_list -= NPC
//			if(QDELETED(NPC))
			log_world("Found a null in npc list!")
//			else
//				log_world("Found a dead NPC in npc list!")
			continue

		//!NPC.route_optimisation()
		if(MC_TICK_CHECK)
			return
		NPC.handle_automated_movement()

/datum/controller/subsystem/humannpcpool/proc/npclost()
	while(length(GLOB.alive_npc_list) < npc_max)
		var/atom/kal = pick(GLOB.npc_spawn_points)
		var/NEPIS = pick(/mob/living/carbon/human/npc/police, /mob/living/carbon/human/npc/bandit, /mob/living/carbon/human/npc/hobo, /mob/living/carbon/human/npc/walkby, /mob/living/carbon/human/npc/business)
		new NEPIS(get_turf(kal))

/datum/controller/subsystem/humannpcpool/proc/report_crime(mob/living/perpetrator, crime_type, crime_location = null)
	// The defines also work as indexes for the crime_report_message list
	var/announce_direction = FALSE
	if(!isturf(crime_location))
		// Eventual support for crimes without locations being reported
		if(!istext(crime_location))
			crime_location = get_turf(perpetrator)
			announce_direction = TRUE

	var/crime_location_message = isturf(crime_location) ? "\
		Location: [crime_location.x]:[crime_location.y] in [get_area(crime_location)]" : "[crime_location]""

	var/crime_report_message = "\
		[src.crime_report_message[crime_type]] at "\

	var/joined_message = "[crime_report_message] [crime_location_message]"
	SEND_SIGNAL(src, COMSIG_ANNOUNCING_CRIME, joined_message, announce_direction)
