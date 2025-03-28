GLOBAL_VAR_INIT (dwelling_number_major, 1)
GLOBAL_VAR_INIT (dwelling_number_moderate, 1)
GLOBAL_LIST_EMPTY (dwelling_list)
GLOBAL_LIST_EMPTY (dwelling_area_list)

/datum/proc/distribute_dwelling_loot() //Primary setup proc. Calling this setups the loot tables and dwellings.
	for(var/area/vtm/dwelling/dwelling_area in GLOB.dwelling_area_list)
		dwelling_area.setup_loot()
