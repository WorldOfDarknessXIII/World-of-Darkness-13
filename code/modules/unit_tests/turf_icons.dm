/// Makes sure turf icons actually exist. :)
/datum/unit_test/turf_icons
	var/modular_mineral_turf_file //= 'icons/turf/mining.dmi' //MODULARITY SUPPORT - insert your snowflake MAP_SWITCH icon file here if you use that define.

/datum/unit_test/turf_icons/Run()
	for(var/turf/turf_path as anything in (subtypesof(/turf) - typesof(/turf/closed/mineral)))

		var/icon_state = initial(turf_path.icon_state)
		var/icon_file = initial(turf_path.icon)
		if(isnull(icon_state) || isnull(icon_file))
			continue
		if(!icon_exists(icon_file, icon_state))
			TEST_FAIL("[turf_path] using invalid icon_state - \"[icon_state]\" in icon file, '[icon_file]")

	for(var/turf/closed/mineral/turf_path as anything in typesof(/turf/closed/mineral)) //minerals use a special (read: snowflake) MAP_SWITCH definition that changes their icon based on if we're just compiling or if we're actually PLAYING the game.

		var/icon_state = initial(turf_path.icon_state)
		var/icon_file = initial(turf_path.icon)
		if(isnull(icon_state) || isnull(icon_file))
			continue
		if(!icon_exists(icon_file, icon_state))
			if(modular_mineral_turf_file && (icon_state in icon_states(modular_mineral_turf_file, 1)))
				continue
			if(!(icon_state in icon_states('icons/turf/mining.dmi', 1)))
				TEST_FAIL("[turf_path] using invalid icon_state - \"[icon_state]\" in icon file, '[icon_file]")

	var/turf/initial_turf_type = run_loc_floor_bottom_left.type

	run_loc_floor_bottom_left = run_loc_floor_bottom_left.ChangeTurf(initial_turf_type) //cleanup.
