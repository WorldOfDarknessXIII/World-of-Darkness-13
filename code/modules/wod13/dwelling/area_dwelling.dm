/area/vtm/dwelling
	name = "NPC Dwelling Master Definition"
	icon_state = "interior"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	wall_rating = 3
	var/area_heat = 0
	var/loot_spawned = 0
	var/list/loot_containers = list()
	var/list/loot_list = list("minor" = 0,
		"moderate" = 0,
		"major" = 0,
		)

/area/vtm/dwelling/proc/add_heat(ammount = 0)
	area_heat += ammount

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

/area/vtm/dwelling/proc/setup_loot_containers()
	var/loot_sum = loot_list["minor"] + loot_list["moderate"] + loot_list["major"]
	while(loot_sum > 0)
		var/obj/structure/vtm/dwelling_container/picked_container = pick(loot_containers)
		if(!picked_container)
			return "Error: No containers to pick"
		picked_container.search_tries += 2
		picked_container.search_hits_left += 1
		loot_sum -= 1

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
