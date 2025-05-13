GLOBAL_VAR_INIT (dwelling_number_major, 4)
GLOBAL_VAR_INIT (dwelling_number_moderate, 10)
GLOBAL_LIST_EMPTY (dwelling_list)
GLOBAL_LIST_EMPTY (dwelling_area_list)

/datum/proc/distribute_dwelling_loot() //Primary setup proc. Calling this setups the loot tables and dwellings.
	for(var/area/vtm/dwelling/dwelling_area in GLOB.dwelling_area_list)
		dwelling_area.setup_loot()

/datum/proc/adjust_dwelling_loot(type,value)
	if(!type || !value) return
	var/total_dwellings = GLOB.dwelling_area_list.len
	switch(type)
		if("major")
			GLOB.dwelling_number_major = value
		if("moderate")
			GLOB.dwelling_number_moderate = value
	if((GLOB.dwelling_number_major + GLOB.dwelling_number_moderate) > total_dwellings)
		switch(type)
			if("major")
				GLOB.dwelling_number_moderate = total_dwellings - GLOB.dwelling_number_major
			if("moderate")
				GLOB.dwelling_number_major = total_dwellings - GLOB.dwelling_number_moderate

/client/proc/cmd_admin_set_dwelling_ratios()
	set name = "Adjust Dwelling Loot Ratios"
	set category = "Admin"
	if (!check_rights(R_ADMIN))
		return

	if(SSticker.current_state > GAME_STATE_PREGAME)
		to_chat(usr, span_warning("The game has already started and loot distributions have been already rolled. This command can only be used before the round starts."))
		return

	if(GLOB.dwelling_area_list.len == 0)
		to_chat(usr, span_warning("Dwelling areas not initialized or no dwelling areas found. This will likely resolve itself before the round starts, please try again in a few seconds."))
		return

	var/total_dwellings = GLOB.dwelling_area_list.len
	var/current_major = GLOB.dwelling_number_major
	var/current_moderate = GLOB.dwelling_number_moderate
	var/msg

	switch(tgui_input_list(usr, "Total dwellings: [total_dwellings], Major: [current_major], Moderate: [current_moderate], Select a value to edit:","Edit dwellings",list("Major","Moderate"),timeout = 0))
		if("Major")
			var/new_number = tgui_input_number(usr, "Enter major dwellings number:","Dwellings Number",GLOB.dwelling_number_major, total_dwellings * 10, 0, timeout = 0)
			if(!new_number) return
			if(new_number > total_dwellings) new_number = total_dwellings
			adjust_dwelling_loot("major",new_number)
			msg = "Dwelling Loot Distribution type major adjusted to [new_number] by [key_name_admin(usr)] "
		if("Moderate")
			var/new_number = tgui_input_number(usr, "Enter moderate dwellings number:","Dwellings Number",GLOB.dwelling_number_moderate, total_dwellings * 10, 0, timeout = 0)
			if(!new_number) return
			if(new_number > total_dwellings) new_number = total_dwellings
			adjust_dwelling_loot("moderate",new_number)
			msg = "Dwelling Loot Distribution type moderate adjusted to [new_number] by [key_name_admin(usr)] "
	if(msg)
		log_admin(msg)
		message_admins(msg)
