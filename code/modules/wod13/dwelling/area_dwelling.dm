/area/vtm/dwelling
	name = "NPC Dwelling Master Definition"
	icon_state = "interior"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	wall_rating = 1
	var/area_tag = "default"
	var/area_heat = 0
	var/area_heat_max
	var/alarm_trigerred = 0
	var/alarm_disabled = 0
	var/list/cased_by = list()
	var/loot_spawned = 0
	var/obj/structure/vtm/dwelling_alarm/alarm_panel
	var/list/dwelling_doors = list()
	var/list/dwelling_windows = list()
	var/list/loot_containers = list()
	var/forced_loot
	var/list/loot_list = list("type" = "none",
		"minor" = 0,
		"moderate" = 0,
		"major" = 0,
		)

/area/vtm/dwelling/proc/add_heat(ammount = 0) //Adds heat to given area, then checks if alarm shoudl be trigerred
	if(alarm_disabled == 1) return
	if(alarm_trigerred == 1)
		INVOKE_ASYNC(alarm_panel, TYPE_PROC_REF(/obj/structure/vtm/dwelling_alarm/, contact_cops))
		return
	area_heat += ammount
	if(area_heat >= area_heat_max && alarm_panel.alarm_active == 0)
		alarm_panel.alarm_arm()
		return

/area/vtm/dwelling/proc/setup_loot_table(type) //Called during setup, this proc contains the look drop values
	switch(type)
		if("major")
			loot_list["type"] = "major"
			loot_list["minor"] = rand(1,2)
			loot_list["moderate"] = rand(4,6)
			loot_list["major"] = rand(3,6)
			area_heat_max = 20
		if("moderate")
			loot_list["type"] = "moderate"
			loot_list["minor"] = rand(4,6)
			loot_list["moderate"] = rand(3,6)
			loot_list["major"] = rand(1,2)
			area_heat_max = 50
		if("minor")
			loot_list["type"] = "minor"
			loot_list["minor"] = rand(4,6)
			loot_list["moderate"] = rand(1,2)
			loot_list["major"] = rand(0,1)
			area_heat_max = 50

/area/vtm/dwelling/proc/setup_loot_containers() // Called during setup
	var/loot_sum = loot_list["minor"] + loot_list["moderate"] + loot_list["major"]
	while(loot_sum > 0)
		var/obj/structure/vtm/dwelling_container/picked_container = pick(loot_containers)
		if(!picked_container)
			return "Error: No containers to pick"
		picked_container.search_tries += 2
		picked_container.search_hits_left += 1
		loot_sum -= 1
	for(var/obj/structure/vtm/dwelling_container/loot_container in loot_containers)
		if(loot_container.search_tries <= 4) loot_container.search_tries += 2
	return

/area/vtm/dwelling/proc/setup_loot() //Primary setup proc
	if(forced_loot)
		setup_loot_table(forced_loot)
	if(loot_list["type"] == "none")
		if(GLOB.dwelling_number_major > 0)
			GLOB.dwelling_number_major -= 1
			setup_loot_table("major")
	if(loot_list["type"] == "none")
		if(GLOB.dwelling_number_moderate > 0)
			GLOB.dwelling_number_moderate -= 1
			setup_loot_table("moderate")
	if(loot_list["type"] == "none")
		setup_loot_table("minor")
	for (var/obj/structure/vampdoor/dwelling/dwelling_door in dwelling_doors)
		dwelling_door.set_security(loot_list["type"])
	setup_loot_containers()
	loot_spawned = 1
	GLOB.dwelling_list.Add(src)
	return

/area/vtm/dwelling/proc/return_loot_value() //Used during seeding
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

/area/vtm/dwelling/Initialize(mapload)
	. = ..()
	GLOB.dwelling_area_list.Add(src)

/area/vtm/dwelling/Destroy()
	. = ..()
	GLOB.dwelling_area_list.Remove(src)
	if(GLOB.dwelling_list.Find(src) != 0) GLOB.dwelling_list.Remove(src)
	alarm_panel = null
	cased_by = null
	dwelling_doors = null
	loot_containers = null
	dwelling_windows = null
