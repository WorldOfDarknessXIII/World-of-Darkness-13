SUBSYSTEM_DEF(frenzypool)
	name = "Frenzy Pool"
	flags = SS_POST_FIRE_TIMING|SS_NO_INIT|SS_BACKGROUND
	priority = FIRE_PRIORITY_NPC
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()

/datum/controller/subsystem/frenzypool/stat_entry(msg)
	var/list/activelist = GLOB.frenzy_list
	msg = "Frenzy:[length(activelist)]"
	return ..()

/datum/controller/subsystem/frenzypool/fire(resumed = FALSE)

	if (!resumed)
		var/list/activelist = GLOB.frenzy_list
		src.currentrun = activelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/mob/living/carbon/H = currentrun[currentrun.len]
		--currentrun.len

		if (QDELETED(H)) // Some issue causes nulls to get into this list some times. This keeps it running, but the bug is still there.
			GLOB.frenzy_list -= H
			log_world("Found a null in frenzy list!")
			continue

		if(H.in_frenzy)
			H.handle_automated_frenzy()
		else
			GLOB.frenzy_list -= H
		if (MC_TICK_CHECK)
			return