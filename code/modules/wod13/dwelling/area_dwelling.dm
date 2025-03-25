/area/vtm/dwelling
	name = "NPC Dwelling Master Definition"
	icon_state = "interior"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	wall_rating = 3
	var/loot_spawned = 0
	var/list/loot_list = list("minor" = 0,
		"moderate" = 0,
		"major" = 0,
		)

/area/vtm/dwelling/proc/setup_loot()
	if(GLOB.dwelling_number_rich > 0)
		GLOB.dwelling_number_rich -= 1
		loot_list["minor"] = rand(3,6)
		loot_list["moderate"] = rand(3,6)
		loot_list["major"] = rand(2,4)
		return
	else if(GLOB.dwelling_number_moderate > 0)
		GLOB.dwelling_number_moderate -= 1
		loot_list["minor"] = rand(2,4)
		loot_list["moderate"] = rand(2,3)
		loot_list["major"] = rand(1,2)
		return
	else
		loot_list["minor"] = rand(4,6)
		loot_list["moderate"] = rand(1,2)
		loot_list["major"] = rand(0,1)
	loot_spawned = 1
	GLOB.dwelling_list.Add(src)
	return

/area/vtm/dwelling/Initialize(mapload)
	. = ..()
	if(loot_spawned == 0)
		setup_loot()


/area/vtm/dwelling/proc/return_loot_value()
	var/list/pick_list = list()
	if(loot_list["minor"] > 0)
		pick_list.Add("minor")
	if(loot_list["moderate"] > 0)
		pick_list.Add("moderate")
	if(loot_list["major"] > 0)
		pick_list.Add("major")

	switch(pick_list.len)
		if(0)
			return 0
		else
			var/list_choice = pick(pick_list)
			loot_list[list_choice] -= 1
			return list_choice
