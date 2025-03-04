/datum/map_template/ruin/proc/try_to_place(z, list/allowed_areas_typecache, turf/forced_turf, clear_below)
	var/sanity = forced_turf ? 1 : PLACEMENT_TRIES
	if(SSmapping.level_trait(z,ZTRAIT_ISOLATED_RUINS))
		return place_on_isolated_level(z)
	while(sanity > 0)
		sanity--
		var/width_border = TRANSITIONEDGE + SPACERUIN_MAP_EDGE_PAD + round(width / 2)
		var/height_border = TRANSITIONEDGE + SPACERUIN_MAP_EDGE_PAD + round(height / 2)
		var/turf/central_turf = forced_turf ? forced_turf : locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), z)
		var/valid = TRUE
		var/list/affected_turfs = get_affected_turfs(central_turf,1)
		var/list/affected_areas = list()

		for(var/turf/check in affected_turfs)
			// Use assoc lists to move this out, it's easier that way
			if(check.turf_flags & NO_RUINS)
				valid = FALSE // set to false before we check
				break
			var/area/new_area = get_area(check)
			affected_areas[new_area] = TRUE

		// This is faster yes. Only BARELY but it is faster
		for(var/area/affct_area as anything in affected_areas)
			if(!allowed_areas_typecache[affct_area.type])
				valid = FALSE
				break

		if(!valid)
			continue

		testing("Ruin \"[name]\" placed at ([central_turf.x], [central_turf.y], [central_turf.z])")

		if(clear_below)
			var/static/list/clear_below_typecache = typecacheof(list(
				/obj/structure/spawner,
				/mob/living/simple_animal,
				/obj/structure/flora
			))
			for(var/turf/T as anything in affected_turfs)
				for(var/atom/thing as anything in T)
					if(clear_below_typecache[thing.type])
						qdel(thing)

		load(central_turf,centered = TRUE)
		loaded++

		for(var/turf/T in affected_turfs)
			T.turf_flags |= NO_RUINS

		new /obj/effect/landmark/ruin(central_turf, src)
		return central_turf

/datum/map_template/ruin/proc/place_on_isolated_level(z)
	var/datum/turf_reservation/reservation = SSmapping.request_turf_block_reservation(width, height, 1, z) //Make the new level creation work with different traits.
	if(!reservation)
		return
	var/turf/placement = reservation.bottom_left_turfs[1]
	load(placement)
	loaded++
	for(var/turf/T in get_affected_turfs(placement))
		T.turf_flags |= NO_RUINS
	var/turf/center = locate(placement.x + round(width/2),placement.y + round(height/2),placement.z)
	new /obj/effect/landmark/ruin(center, src)
	return center
