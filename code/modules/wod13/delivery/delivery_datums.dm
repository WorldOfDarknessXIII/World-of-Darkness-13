/datum/delivery_datum/
	var/delivery_employer_tag
	var/contract_difficulty
	var/obj/structure/delivery_board/board
	var/obj/item/delivery_contract/contract
	var/mob/original_owner
	var/list/contract_takers = list()
	var/area/vtm/interior/delivery_garage/garage_area
	var/obj/effect/landmark/delivery_truck_beacon/truck_spawner
	var/obj/vampire_car/delivery_truck/active_truck
	var/list/spawned_keys = list()
	var/list/delivery_dispensers = list()
	var/list/delivery_recievers = list()
	var/list/crate_designations = list()
	var/list/active_crates = list()
	var/list/delivery_score = list(
		"trucks_used" = 0,
		"truck_returned" = 0,
		"dispensed_crates" = 0,
		"delivered_crates" = 0,
		"misdelivered_crates" = 0,
		"completed_recievers" = 0,
		"manifest_refresh" = 0,
		"timeout_timestamp" = 0,
		)

/datum/delivery_datum/proc/create_stats_table()
	GLOB.delivery_stats = list(
		"oops" = list(
			"income" = 0,
			"grade" = 0,
			"completed" = 0,
			"completed_recievers" = 0,
			"delivered_crates" = 0,
		),
		"millenium_delivery" = list(
			"income" = 0,
			"grade" = 0,
			"completed" = 0,
			"completed_recievers" = 0,
			"delivered_crates" = 0,
		),
		"bar_delivery" = list(
			"income" = 0,
			"grade" = 0,
			"completed" = 0,
			"completed_recievers" = 0,
			"delivered_crates" = 0,
		),
	)

/datum/delivery_datum/proc/track_stats(grade,income)
	if(GLOB.delivery_stats.len == 0) create_stats_table()
	GLOB.delivery_stats["[delivery_employer_tag]"]["income"] += income
	GLOB.delivery_stats["[delivery_employer_tag]"]["grade"] += grade
	GLOB.delivery_stats["[delivery_employer_tag]"]["completed"] += 1
	GLOB.delivery_stats["[delivery_employer_tag]"]["completed_recievers"] += delivery_score["completed_recievers"]
	GLOB.delivery_stats["[delivery_employer_tag]"]["delivered_crates"] += delivery_score["delivered_crates"]
	return

/datum/delivery_datum/proc/process_payouts(grade)
	var/payout_quota = 0
	payout_quota += delivery_score["delivered_crates"] * 100
	payout_quota += delivery_score["completed_recievers"] * 200
	var/payout_multiplier
	switch(grade)
		if(7)
			payout_multiplier = 1.5
		if(6)
			payout_multiplier = 1.3
		if(5)
			payout_multiplier = 1.1
		if(4)
			payout_multiplier = 1
		if(3)
			payout_multiplier = 0.9
		if(2)
			payout_multiplier = 0.7
		if(1)
			payout_multiplier = 0.5
	payout_quota *= payout_multiplier
	track_stats(grade,payout_quota)
	var/final_payout = round((payout_quota / contract_takers.len),1)
	broadcast_to_holders("<b>Delivery Complete.</b> <b>[final_payout]</b> paid to the accounts of all participants.")
	for(var/mob/living/carbon/human/payee in contract_takers)
		var/datum/vtm_bank_account/payee_account
		var/p_bank_id = payee.bank_id
		for(var/datum/vtm_bank_account/account in GLOB.bank_account_list)
			if(p_bank_id == account.bank_id)
				payee_account = account
				break
		payee_account.balance += final_payout


/datum/delivery_datum/proc/parse_grade(grade)
	if(!grade) return
	switch(grade)
		if(7)
			return "S"
		if(6)
			return "A"
		if(5)
			return "B"
		if(4)
			return "C"
		if(3)
			return "D"
		if(2)
			return "E"
		if(1)
			return "F"

/datum/delivery_datum/proc/delivery_finish()
	if(active_truck)
		var/area/truck_area = get_area(active_truck)
		if(truck_area == garage_area) delivery_score["truck_returned"] = 1
	var/final_grade = 7
	if(world.time > delivery_score["timeout_timestamp"])
		final_grade -= 3
	if(delivery_recievers.len > 0)
		final_grade -= 5
	if(delivery_score["trucks_used"] > 1)
		final_grade -= 1
	if(delivery_score["truck_returned"] == 0)
		final_grade -= 1
	if(delivery_score["dispensed_crates"] > delivery_score["delivered_crates"])
		final_grade -= 1
	if(delivery_score["misdelivered_crates"] > 0)
		final_grade -= 1
	if(delivery_score["manifest_refresh"] > 3)
		final_grade -= 1
	if(final_grade < 1) final_grade = 1
	broadcast_to_holders("Delivery Grade: <b>[parse_grade(final_grade)]</b>")
	process_payouts(final_grade)
	qdel(contract)
	qdel(src)


/datum/delivery_datum/proc/add_owner(mob/user)
	if(contract_takers.Find(user) == 0)
		contract_takers.Add(user)
		return 1
	else
		return 0

/datum/delivery_datum/proc/check_owner(mob/user)
	if(contract_takers.Find(user) == 0)
		return 0
	else
		return 1

/datum/delivery_datum/proc/check_complete()
	if(delivery_recievers.len == 0)
		return 1
	else
		return 0

/datum/delivery_datum/proc/broadcast_to_holders(message)
	if(!message) return
	for (var/mob/living/carbon/human/mob in contract_takers)
		to_chat(mob, "<p>[message]</p>")

/datum/delivery_datum/proc/reciever_complete(obj/reciever)
	var/obj/structure/delivery_reciever/target_reciever = reciever
	delivery_recievers.Remove(target_reciever)
	delivery_score["completed_recievers"] += 1
	if(check_complete() == 1)
		broadcast_to_holders("<b>All deliveries have been completed.</b> Please return the truck and any outstanding cargo back to the office to finalize the contract!")
	else
		broadcast_to_holders("<b>Delivery to [target_reciever.chute_name] complete.</b> [num2text(delivery_recievers.len)] chutes remain.")

/datum/delivery_datum/proc/assign_dispenser(tag)
	var/list/dispenser_candidates = list()
	for(var/obj/structure/delivery_dispenser/dispenser_candidate in GLOB.delivery_available_dispensers)
		if(dispenser_candidate.dispenser_active == 0 && dispenser_candidate.delivery_employer_tag == delivery_employer_tag)
			dispenser_candidates.Add(dispenser_candidate)
	if(dispenser_candidates.len == 0) return 0
	var/obj/structure/delivery_dispenser/picked_dispenser = pick(dispenser_candidates)
	picked_dispenser.dispenser_active = 1
	picked_dispenser.crate_type = tag
	switch(tag)
		if("red")
			picked_dispenser.light_color = "#e71a1a"
			picked_dispenser.set_light(1)
		if("blue")
			picked_dispenser.light_color = "#1725e9"
			picked_dispenser.set_light(1)
		if("yellow")
			picked_dispenser.light_color = "#f5df1e"
			picked_dispenser.set_light(1)
		if("green")
			picked_dispenser.light_color = "#25eb13"
			picked_dispenser.set_light(1)
	delivery_dispensers.Add(picked_dispenser)
	animate(picked_dispenser,alpha = 255,time = 5 SECONDS)
	picked_dispenser.mouse_opacity = 1
	return 1

/datum/delivery_datum/proc/assign_recievers(ammount)
	var/recievers_to_assign
	var/list/reciever_list = list()
	reciever_list = GLOB.delivery_available_recievers.Copy()
	for(var/obj/structure/delivery_reciever/reciever_candidate in reciever_list)
		if(reciever_candidate.delivery_in_use == 1)	reciever_list.Remove(reciever_candidate)
	if(!ammount)
		recievers_to_assign = 5
	else
		recievers_to_assign = ammount
	while(recievers_to_assign > 0)
		var/picked_reciever = pick(reciever_list)
		delivery_recievers.Add(picked_reciever)
		reciever_list.Remove(picked_reciever)
		recievers_to_assign -= 1

/datum/delivery_datum/proc/assign_crates(ammount_min,ammount_max)
	if(!ammount_min || !ammount_max) return
	if(delivery_recievers.len == 0) return
	for(var/obj/structure/delivery_reciever/reciever in delivery_recievers)
		reciever.delivery_in_use = 1
		var/crate_number = rand(ammount_min,ammount_max)
		while(crate_number > 0)
			var/picked_type = pick("red","green","yellow","blue")
			reciever.delivery_status[picked_type] += 1
			crate_number -= 1
		animate(reciever,alpha = 255, time = 5 SECONDS)
		reciever.set_light(2)
		reciever.mouse_opacity = 1

/datum/delivery_datum/proc/assign_garage()
	if(!delivery_employer_tag) return 0
	for(var/area/vtm/interior/delivery_garage/potential_garage_area in GLOB.delivery_garage_areas)
		if(potential_garage_area.delivery_employer_tag == delivery_employer_tag)
			garage_area = potential_garage_area
			break
	if(!garage_area) return 0
	for(var/obj/effect/landmark/delivery_truck_beacon/potential_truck_spawner in GLOB.delivery_available_veh_spawners)
		if(potential_truck_spawner.delivery_employer_tag == delivery_employer_tag)
			truck_spawner = potential_truck_spawner
			break
	if(!truck_spawner) return 0

/datum/delivery_datum/proc/spawn_truck()
	if(active_truck) return 0
	if(!truck_spawner) return "err"
	truck_spawner.spawn_truck(src)
	delivery_score["trucks_used"] += 1

/datum/delivery_datum/proc/delivery_timeout()
	broadcast_to_holders("<b>Delivery timer expired.</b> Deactivating any outstanding recievers. You have <b>five minutes</b> to return the truck and any outstanding cargo.")
	if(delivery_recievers.len != 0)
		for(var/obj/structure/delivery_reciever/reciever in delivery_recievers)
			reciever.reset_reciever()
	addtimer(CALLBACK(src,PROC_REF(delivery_finish)),5 MINUTES)

/datum/delivery_datum/proc/delivery_set_timer(delay)
	if(!delay) return
	var/timer_value = world.time + delay
	delivery_score["timeout_timestamp"] = timer_value
	addtimer(CALLBACK(src,PROC_REF(delivery_timeout)),delay + 10)

/datum/delivery_datum/proc/check_conditions()
	var/receiver_number
	switch(contract_difficulty)
		if(1)
			receiver_number = 3
		if(2)
			receiver_number = 5
		if(3)
			receiver_number = 7
	var/list/reciever_list = list()
	reciever_list = GLOB.delivery_available_recievers.Copy()
	for(var/obj/structure/delivery_reciever/potential_reciever in reciever_list)
		if(potential_reciever.delivery_in_use == 1) reciever_list.Remove(potential_reciever)
	if(reciever_list.len < receiver_number)
		broadcast_to_holders("Error: Not enough delivery recievers. Too many deliveries in progress. Contract aborted.")
		return 0
	return 1

/datum/delivery_datum/proc/start_contract()
	if(check_conditions(contract_difficulty) == 0) return "fail_reci"
	if(assign_garage() == 0) return "fail_garage"
	if(assign_dispenser("red") == 0) return "fail_disp"
	if(assign_dispenser("blue") == 0) return "fail_disp"
	if(assign_dispenser("yellow") == 0) return "fail_disp"
	if(assign_dispenser("green") == 0) return "fail_disp"
	if(spawn_truck() == 0) return "fail_truck"
	switch(contract_difficulty)
		if(1)
			assign_recievers(3)
			assign_crates(3,6)
			delivery_set_timer(20 MINUTES)
		if(2)
			assign_recievers(5)
			assign_crates(7,10)
			delivery_set_timer(45 MINUTES)
		if(3)
			assign_recievers(7)
			assign_crates(9,15)
			delivery_set_timer(90 MINUTES)
	return 1

/datum/delivery_datum/New(mob/user,obj/board_ref,difficulty)
	original_owner = user
	add_owner(user)
	board = board_ref
	delivery_employer_tag = board.delivery_employer_tag
	contract_difficulty = difficulty
	if(board.crate_types.len != 0)
		crate_designations = list()
		crate_designations = board.crate_types.Copy()

/datum/delivery_datum/Destroy(force, ...)
	if(board)
		if(board.delivery_started == 1) board.delivery_cooldown(5 MINUTES)
		board.delivery_started = 0
	board = null
	contract = null
	original_owner = null
	contract_takers = list()
	garage_area = null
	truck_spawner = null
	if(active_truck)
		qdel(active_truck)
	if(delivery_dispensers.len != 0)
		for(var/obj/structure/delivery_dispenser/dispenser in delivery_dispensers)
			dispenser.reset_dispenser()
	delivery_dispensers = list()
	if(delivery_recievers.len != 0)
		for(var/obj/structure/delivery_reciever/reciever in delivery_recievers)
			reciever.reset_reciever()
	delivery_recievers = list()
	if(active_crates.len != 0)
		for(var/obj/structure/delivery_crate/crate in active_crates)
			qdel(crate)
	active_crates = list()
	if(spawned_keys.len != 0)
		for(var/obj/item/vamp/keys/cargo_truck/truck_key in spawned_keys)
			qdel(truck_key)
	if(contract)
		qdel(contract)
	. = ..()


/datum/delivery_storage/
	var/obj/vampire_car/delivery_truck/owner
	var/capacity = 20
	var/search_delay = 1 SECONDS
	var/list/user_list = list()
	var/users_max = 3
	var/list/storage = list()

/datum/delivery_storage/Destroy(force, ...)
	user_list = list()
	if(storage.len != 0)
		for (var/obj/structure/delivery_crate/crate in storage)
			storage.Remove(crate)
			qdel(crate)
	. = ..()


/datum/delivery_storage/New(obj/truck,cap,delay,max_users)
	if(truck) owner = truck
	if(cap)
		capacity = cap
	if(delay)
		search_delay = delay
	if(max_users)
		users_max = max_users
	. = ..()

/datum/delivery_storage/proc/check_use(type,mob/user)
	switch(type)
		if(1)
			if(user_list.len >= users_max) return 2
			if(user_list.Find(user) == 0)
				user_list.Add(user)
				return 1
			else
				return 0
		if(2)
			user_list.Remove(user)
			return

/datum/delivery_storage/proc/add_to_storage(mob/user,obj/crate)
	if(storage.len >= capacity)
		to_chat(user, span_warning("The truck is full!"))
		return
	switch(check_use(1,user))
		if(2)
			to_chat(user, span_warning("Too many people are using the truck at once."))
		if(0)
			to_chat(user, span_warning("You are already using the truck."))
		if(1)
			storage.Add(crate)
			crate.forceMove(owner)
	check_use(2,user)

/datum/delivery_storage/proc/calculate_ret_time(obj/crate)
	var/crate_position = storage.Find(crate)
	var/timer_calc = crate_position * search_delay
	return timer_calc

/datum/delivery_storage/proc/retrieval_menu(mob/user)
	if(!user) return
	switch(check_use(1,user))
		if(2)
			to_chat(user, span_warning("Too many people are using the truck at once."))
			return
		if(0)
			to_chat(user, span_warning("You are already using the truck."))
		if(1)
			var/list/available_tags = list()
			var/obj/structure/delivery_crate/picked_crate
			var/chosen_tag
			for (var/obj/structure/delivery_crate/crate in storage)
				if(!crate)
					check_use(2,user)
					return
				if(available_tags.Find(crate.crate_type) == 0)
					available_tags.Add(crate.crate_type)
			if(available_tags.len == 0)
				check_use(2,user)
				return
			if(available_tags.len == 1)
				for(var/obj/structure/delivery_crate/crate_to_ret in storage)
					picked_crate = crate_to_ret
					chosen_tag = crate_to_ret.crate_type
			if(!picked_crate)
				chosen_tag = tgui_input_list(user, "Current load: [storage.len] / [capacity], Available Crates:","Crate choice",available_tags,timeout = 20 SECONDS)
			if(!chosen_tag)
				check_use(2,user)
				return
			for(var/obj/structure/delivery_crate/crate_to_ret in storage)
				if(crate_to_ret.crate_type == chosen_tag)
					picked_crate = crate_to_ret
					break
			playsound(owner,'sound/effects/cargocrate_move.ogg',50, 10)
			var/ret_delay = 1 SECONDS + calculate_ret_time(picked_crate)
			if(do_after(user, ret_delay, owner))
				playsound(owner,'sound/effects/cargocrate_unload.ogg',50, 10)
				var/turf/user_turf = get_turf(user)
				storage.Remove(picked_crate)
				picked_crate.forceMove(user_turf)
			check_use(2,user)


/datum/delivery_manifest/

	var/datum/delivery_datum/delivery
	var/list/saved_recievers = list()
	var/list/saved_data = list(
		"dispensed_crates" = 0,
		"delivered_crates" = 0,
		"manifest_refresh" = 0,
		"time_left" = "none",
		)

/datum/delivery_manifest/New(datum/delivery_datum)
	delivery = delivery_datum
	. = ..()

/datum/delivery_manifest/Destroy(force, ...)
	delivery = null
	saved_recievers = list()
	. = ..()


/datum/delivery_manifest/proc/save_data(init)
	if(!delivery) return
	saved_recievers = list()
	if(delivery.delivery_recievers.len > 0)
		var/current_position = 1
		while(current_position <= delivery.delivery_recievers.len)
			var/obj/structure/delivery_reciever/reciever_saved = delivery.delivery_recievers[current_position]
			var/turf/reciever_turf = get_turf(reciever_saved)

			var/list/list_saved = list("[current_position]" = list(
					"chute_name" = reciever_saved.chute_name,
					"red" = reciever_saved.delivery_status["red"],
					"blue" = reciever_saved.delivery_status["blue"],
					"yellow" = reciever_saved.delivery_status["yellow"],
					"green" = reciever_saved.delivery_status["green"],
					"x" = reciever_turf.x,
					"y" = reciever_turf.y,
					"z" = reciever_turf.z,
				)
			)
			saved_recievers.Add(list_saved)
			current_position += 1

	if(!init) delivery.delivery_score["manifest_refresh"] += 1
	saved_data["dispensed_crates"] = delivery.delivery_score["dispensed_crates"]
	saved_data["delivered_crates"] = delivery.delivery_score["delivered_crates"]
	saved_data["manifest_refresh"] = delivery.delivery_score["manifest_refresh"]
	var/time_left_raw = delivery.delivery_score["timeout_timestamp"] - world.time
	if(time_left_raw <= 0)
		saved_data["time_left"] = "TIMED OUT"
	else
		saved_data["time_left"] = time2text(time_left_raw,"mm:ss")

/datum/delivery_manifest/proc/get_cargo_color_value(tag)
	if(delivery.crate_designations.Find(tag) != 0)
		return delivery.crate_designations["[tag]"]["color"]
	return "#ffffff"

/datum/delivery_manifest/proc/get_cargo_name(tag)
	if(delivery.crate_designations.Find(tag) != 0)
		return delivery.crate_designations["[tag]"]["cargo_name"]
	return "#ffffff"


/datum/delivery_manifest/proc/read_data(mob/user)
	if(!user) return
	var/turf/user_turf = get_turf(user)
	var/html
	html += {"
	<!DOCTYPE html>
	<html>
	<head>
	<style>
	body {
	padding: 1em;
	background-color: #111111;
	font-family: Tahoma, sans-serif;
	color: #ffffff;
	}
	</style>
	</head>
	<body>
	"}
	html += "<p><b>Current coordinates:</b> X:[user_turf.x] Y:[user_turf.y] Z: [user_turf.z]<br></p>"
	if(saved_recievers.len == 0)
		html += "<p><b>No recievers found. Return the truck to the garage and any outstanding crates to their dispensers, then return the contract to the board.</b></p>"
	else
		html += "<p><b>OUTSDANDING DELIVERIES</b></p>"
		var/current_position = 1
		while(current_position <= saved_recievers.len)
			html += {"<p><b>[saved_recievers["[current_position]"]["chute_name"]]</b> - X:[saved_recievers["[current_position]"]["x"]] Y:[saved_recievers["[current_position]"]["y"]] Z:[saved_recievers["[current_position]"]["z"]]</p><p>"}
			if(saved_recievers["[current_position]"]["red"] > 0)
				var/cargo_name = get_cargo_name("red")
				var/html_color = get_cargo_color_value("red")
				html += {"<span style="color: [html_color];">[cargo_name]</span> - <b>[saved_recievers["[current_position]"]["red"]]</b> remaining.<br>"}
			if(saved_recievers["[current_position]"]["blue"] > 0)
				var/cargo_name = get_cargo_name("blue")
				var/html_color = get_cargo_color_value("blue")
				html += {"<span style="color: [html_color];">[cargo_name]</span> - <b>[saved_recievers["[current_position]"]["blue"]]</b> remaining.<br>"}
			if(saved_recievers["[current_position]"]["yellow"] > 0)
				var/cargo_name = get_cargo_name("yellow")
				var/html_color = get_cargo_color_value("yellow")
				html += {"<span style="color: [html_color];">[cargo_name]</span> - <b>[saved_recievers["[current_position]"]["yellow"]]</b> remaining.<br>"}
			if(saved_recievers["[current_position]"]["green"] > 0)
				var/cargo_name = get_cargo_name("green")
				var/html_color = get_cargo_color_value("green")
				html += {"<span style="color: [html_color];">[cargo_name]</span> - <b>[saved_recievers["[current_position]"]["green"]]</b> remaining.<br>"}
			html += "</p>"
			current_position += 1
	if(delivery.active_truck)
		var/turf/truck_turf = get_turf(delivery.active_truck)
		html += "<p><b>Truck Active</b> - X:[truck_turf.x] Y:[truck_turf.y] Z:[truck_turf.z]</p>"
	else
		html += "<p><b>No truck found.</b></p>"
	if(delivery.active_crates.len != 0)
		var/list/turf_list = list()
		for(var/obj/structure/delivery_crate/crate in delivery.active_crates)
			if(crate.loc)
				var/turf/tested_turf = get_turf(crate)
				if(turf_list.Find(tested_turf) == 0)
					turf_list.Add(tested_turf)
		if(turf_list.len != 0)
			html += "<p><b>Active Crates:</b></p><p>"
			for(var/turf/picked_turf in turf_list)
				html += "X:[picked_turf.x] Y:[picked_turf.y] Z:[picked_turf.z]<br>"
				html += "</p>"
	else
		html += "<b><p>No active crates.</b></p>"
	if(delivery.delivery_dispensers.len != 0)
		html += "<p><b>DISPENSERS:</b></p>"
		for(var/obj/structure/delivery_dispenser/dispenser in delivery.delivery_dispensers)
			var/turf/dispenser_turf = get_turf(dispenser)
			var/html_color = get_cargo_color_value(dispenser.crate_type)
			var/cargo_name = get_cargo_name(dispenser.crate_type)
			html += {"<p><b><span style="color: [html_color];">[cargo_name]</span></b> - [dispenser.chute_name] - X:[dispenser_turf.x] Y:[dispenser_turf.y] Z:[dispenser_turf.z]</p>"}
	else
		html += "<p><b>Dispensers not found.</p></b>"
	html += {"</p></body>"}
	user << browse(html, "window=name;size=800x800")

/datum/controller/subsystem/ticker/proc/calculate_transportation_winners()
	var/list/results_array = list(
		"income" = list(
			"oops" = GLOB.delivery_stats["oops"]["income"],
			"millenium_delivery" = GLOB.delivery_stats["millenium_delivery"]["income"],
			"bar_delivery" = GLOB.delivery_stats["bar_delivery"]["income"],
		),
		"averages" = list(
			"oops" = 0,
			"millenium_delivery" = 0,
			"bar_delivery" = 0,
		),
		"completed_recievers" = list(
			"oops" = GLOB.delivery_stats["oops"]["completed_recievers"],
			"millenium_delivery" = GLOB.delivery_stats["millenium_delivery"]["completed_recievers"],
			"bar_delivery" = GLOB.delivery_stats["bar_delivery"]["completed_recievers"],
		),
		"crates" = list(
			"oops" = GLOB.delivery_stats["oops"]["delivered_crates"],
			"millenium_delivery" = GLOB.delivery_stats["millenium_delivery"]["delivered_crates"],
			"bar_delivery" = GLOB.delivery_stats["bar_delivery"]["delivered_crates"],
		)
	)

	if(GLOB.delivery_stats["oops"]["completed"] > 0)
		results_array["averages"]["oops"] = round((GLOB.delivery_stats["oops"]["grade"] / GLOB.delivery_stats["oops"]["completed"]),0.1)
	if(GLOB.delivery_stats["millenium_delivery"]["completed"] > 0)
		results_array["averages"]["millenium_delivery"] = round((GLOB.delivery_stats["millenium_delivery"]["grade"] / GLOB.delivery_stats["millenium_delivery"]["completed"]),0.1)
	if(GLOB.delivery_stats["bar_delivery"]["completed"] > 0)
		results_array["averages"]["bar_delivery"] = round((GLOB.delivery_stats["millenium_delivery"]["grade"] / GLOB.delivery_stats["millenium_delivery"]["completed"]),0.1)

	var/list/winners = list(
		"income" = "none",
		"averages" = "none",
		"completed_recievers" = "none",
		"crates" = "none",
		)

	if(results_array["income"]["oops"] > results_array["income"]["millenium_delivery"] && results_array["income"]["oops"] > results_array["income"]["bar_delivery"])
		winners["income"] = "oops"
	if(results_array["averages"]["oops"] > results_array["averages"]["millenium_delivery"] && results_array["averages"]["oops"] > results_array["averages"]["bar_delivery"])
		winners["averages"] = "oops"
	if(results_array["completed_recievers"]["oops"] > results_array["completed_recievers"]["millenium_delivery"] && results_array["completed_recievers"]["oops"] > results_array["completed_recievers"]["bar_delivery"])
		winners["completed_recievers"] = "oops"
	if(results_array["crates"]["oops"] > results_array["crates"]["millenium_delivery"] && results_array["crates"]["oops"] > results_array["crates"]["bar_delivery"])
		winners["crates"] = "oops"

	if(results_array["income"]["millenium_delivery"] > results_array["income"]["oops"] && results_array["income"]["millenium_delivery"] > results_array["income"]["bar_delivery"])
		winners["income"] = "millenium_delivery"
	if(results_array["averages"]["millenium_delivery"] > results_array["averages"]["oops"] && results_array["averages"]["millenium_delivery"] > results_array["averages"]["bar_delivery"])
		winners["averages"] = "millenium_delivery"
	if(results_array["completed_recievers"]["millenium_delivery"] > results_array["completed_recievers"]["oops"] && results_array["completed_recievers"]["millenium_delivery"] > results_array["completed_recievers"]["bar_delivery"])
		winners["completed_recievers"] = "millenium_delivery"
	if(results_array["crates"]["millenium_delivery"] > results_array["crates"]["oops"] && results_array["crates"]["millenium_delivery"] > results_array["crates"]["bar_delivery"])
		winners["crates"] = "millenium_delivery"

	if(results_array["income"]["bar_delivery"] > results_array["income"]["millenium_delivery"] && results_array["income"]["bar_delivery"] > results_array["income"]["oops"])
		winners["income"] = "bar_delivery"
	if(results_array["averages"]["bar_delivery"] > results_array["averages"]["millenium_delivery"] && results_array["averages"]["bar_delivery"] > results_array["averages"]["oops"])
		winners["averages"] = "bar_delivery"
	if(results_array["completed_recievers"]["bar_delivery"] > results_array["completed_recievers"]["millenium_delivery"] && results_array["completed_recievers"]["bar_delivery"] > results_array["completed_recievers"]["oops"])
		winners["completed_recievers"] = "bar_delivery"
	if(results_array["crates"]["bar_delivery"] > results_array["crates"]["millenium_delivery"] && results_array["crates"]["bar_delivery"] > results_array["crates"]["oops"])
		winners["crates"] = "bar_delivery"

	return winners

/datum/controller/subsystem/ticker/proc/transportation_report()
	var/list/parts = list()
	parts += "<p><b>DELIVERY SERVICE REPORT</b></p><p>"

	if(GLOB.delivery_stats.len == 0)
		parts += "No deliveries were made this round!</p>"
		return parts.Join()

	var/list/winner_array = calculate_transportation_winners()

	if(GLOB.delivery_stats["oops"]["delivered_crates"] > 0)

		parts += "<b>OOPS Delivery Service</b><br>"
		var/text_color = "#ffffff"
		if(GLOB.delivery_stats["oops"]["completed"] > 0)
			if(winner_array["averages"] == "oops") text_color = "#fffb2b"
			parts += {"<span style="color: [text_color];">Grade Average: <b>[GLOB.delivery_stats["oops"]["grade"] / GLOB.delivery_stats["oops"]["completed"]]</span></b><br>"}
			text_color = "#ffffff"
		if(winner_array["completed_recievers"] == "oops") text_color = "#fffb2b"
		parts += {"<span style="color: [text_color];">Recievers Completed: <b>[GLOB.delivery_stats["oops"]["completed_recievers"]]</span></b><br>"}
		text_color = "#ffffff"
		if(winner_array["crates"] == "oops") text_color = "#fffb2b"
		parts += {"<span style="color: [text_color];">Crates Delivered: <b>[GLOB.delivery_stats["oops"]["delivered_crates"]]</span></b><br>"}
		text_color = "#ffffff"
		if(winner_array["income"] == "oops") text_color = "#fffb2b"
		parts += {"<br><b><span style="color: [text_color];">TOTAL INCOME: [GLOB.delivery_stats["oops"]["income"]]</span></b><br>"}

	parts += "</p><p>"

	if(GLOB.delivery_stats["millenium_delivery"]["delivered_crates"] > 0)

		parts += "<b>Millenium Tower Delivery Service</b><br>"

		var/text_color = "#ffffff"
		if(GLOB.delivery_stats["millenium_delivery"]["completed"] > 0)
			if(winner_array["averages"] == "millenium_delivery") text_color = "#fffb2b"
			parts += {"<span style="color: [text_color];">Grade Average: <b>[GLOB.delivery_stats["millenium_delivery"]["grade"] / GLOB.delivery_stats["millenium_delivery"]["completed"]]</span></b><br>"}
			text_color = "#ffffff"
		if(winner_array["completed_recievers"] == "millenium_delivery") text_color = "#fffb2b"
		parts += {"<span style="color: [text_color];">Recievers Completed: <b>[GLOB.delivery_stats["millenium_delivery"]["completed_recievers"]]</span></b><br>"}
		text_color = "#ffffff"
		if(winner_array["crates"] == "millenium_delivery") text_color = "#fffb2b"
		parts += {"<span style="color: [text_color];">Crates Delivered: <b>[GLOB.delivery_stats["millenium_delivery"]["delivered_crates"]]</span></b><br>"}
		text_color = "#ffffff"
		if(winner_array["income"] == "millenium_delivery") text_color = "#fffb2b"
		parts += {"<br><b><span style="color: [text_color];">TOTAL INCOME: [GLOB.delivery_stats["millenium_delivery"]["income"]]</span></b><br>"}

	parts += "</p><p>"

	if(GLOB.delivery_stats["bar_delivery"]["delivered_crates"] > 0)

		parts += "<b>Bar Delivery Service</b><br>"

		var/text_color = "#ffffff"
		if(GLOB.delivery_stats["bar_delivery"]["completed"] > 0)
			if(winner_array["averages"] == "bar_delivery") text_color = "#fffb2b"
			parts += {"<span style="color: [text_color];">Grade Average: <b>[GLOB.delivery_stats["bar_delivery"]["grade"] / GLOB.delivery_stats["bar_delivery"]["completed"]]</span></b><br>"}
			text_color = "#ffffff"
		if(winner_array["completed_recievers"] == "bar_delivery") text_color = "#fffb2b"
		parts += {"<span style="color: [text_color];">Recievers Completed: <b>[GLOB.delivery_stats["bar_delivery"]["completed_recievers"]]</span></b><br>"}
		text_color = "#ffffff"
		if(winner_array["crates"] == "bar_delivery") text_color = "#fffb2b"
		parts += {"<span style="color: [text_color];">Crates Delivered: <b>[GLOB.delivery_stats["bar_delivery"]["delivered_crates"]]</span></b><br>"}
		text_color = "#ffffff"
		if(winner_array["income"] == "bar_delivery") text_color = "#fffb2b"
		parts += {"<br><b><span style="color: [text_color];">TOTAL INCOME: [GLOB.delivery_stats["bar_delivery"]["income"]]</span></b><br>"}

	parts += "</p><p>"

	switch(winner_array["income"])
		if("none")
			parts += "No surplus profits were generated by the delivery network in the city. The businesses continue as they are, without any significant influence over them.<br>"
		if("oops")
			parts += "As the <b>OOPS Delivery Service</b> maintains its monopoly over the city's nightly delivery service market, surplus profits generated from the deliveries <b>head right to the unknown forces behind the entire operation</b>, benefiting mostly themselves and those who work for them."
		if("millenium_delivery")
			parts += "The <b>Millenium Tower Delivery Service</b> secures the biggest share of the city's delivery market and <b>secures the surplus profits from the night in the name of the Camarilla</b> who moves the funds support Camarilla-aligned interests outside of the city.<br>"
		if("bar_delivery")
			parts += "The <b>Bar Delivery Service</b> secures the majority of the night's delivery market share and receives the surplus profits from the market. The funds are handed out, according to need, <b>to interests aligned with the Anarch movement outside of the city.</b><br>"

	parts += "</p>"

	return parts.Join()
