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

/datum/delivery_datum/proc/track_stats(grade)
	if(!grade) return
	if(GLOB.delivery_stats.Find(delivery_employer_tag) == 0)
		var/list/list_to_add = list("[delivery_employer_tag]" = list(
				"grade" = grade,
				"completed" = 1,
				"completed_recievers" = delivery_score["completed_recievers"],
				"delivered" = delivery_score["delivered_crates"]
				)
			)
		GLOB.delivery_stats.Add(list_to_add)
		return
	if(GLOB.delivery_stats.Find(delivery_employer_tag) != 0)
		GLOB.delivery_stats[delivery_employer_tag]["grade"] += grade
		GLOB.delivery_stats[delivery_employer_tag]["completed"] += 1
		GLOB.delivery_stats[delivery_employer_tag]["completed_recievers"] += delivery_score["completed_recievers"]
		GLOB.delivery_stats[delivery_employer_tag]["delivered_crates"] += delivery_score["delivered_crates"]
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
	var/final_grade = 7
	if(world.time > delivery_score["timeout_timestamp"])
		final_grade -= 3
	if(delivery_score["trucks_used"] > 1)
		final_grade -= 1
	if(delivery_score["trucks_returned"] == 0)
		final_grade -= 1
	if(delivery_score["dispensed_crates"] > delivery_score["delivered_crates"])
		final_grade -= 1
	if(delivery_score["misdelivered_crates"] > 0)
		final_grade -= 1
	if(delivery_score["manifest_refresh"] > 3)
		final_grade -= 1
	if(final_grade < 1) final_grade = 1
	broadcast_to_holders("Delivery Grade: <b>[parse_grade(final_grade)]</b>")
	track_stats(final_grade)
	process_payouts(final_grade)
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
			picked_dispenser.color = "#7c1313"
		if("blue")
			picked_dispenser.color = "#202bca"
		if("yellow")
			picked_dispenser.color = "#b8ac3f"
		if("green")
			picked_dispenser.color = "#165f29"
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
			delivery_set_timer(15 MINUTES)
		if(2)
			assign_recievers(5)
			assign_crates(7,10)
			delivery_set_timer(25 MINUTES)
		if(3)
			assign_recievers(7)
			assign_crates(9,15)
			delivery_set_timer(40 MINUTES)
	return 1

/datum/delivery_datum/New(mob/user,obj/board_ref,difficulty)
	original_owner = user
	add_owner(user)
	board = board_ref
	delivery_employer_tag = board.delivery_employer_tag
	contract_difficulty = difficulty

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

/datum/delivery_storage/proc/calculate_ret_time(tag)
	var/crate_position = storage.Find(tag)
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
			var/ret_delay = 2 SECONDS + calculate_ret_time(chosen_tag)
			if(do_after(user, ret_delay, owner))
				playsound(,'sound/effects/pressureplate.ogg',50, 10)
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
	saved_recievers = delivery.delivery_recievers.Copy()
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
	switch(tag)
		if("red")
			return "#7c1313"
		if("blue")
			return "#202bca"
		if("yellow")
			return "#b8ac3f"
		if("green")
			return "#165f29"
		else
			return "#000000"


/datum/delivery_manifest/proc/read_data(mob/user)
	if(!user) return
	var/turf/user_turf = get_turf(user)
	var/html
	html += "<p><b>Current coordinates:</b> X:[user_turf.x] Y:[user_turf.y] Z: [user_turf.z]<br></p>"
	if(saved_recievers.len == 0)
		html += "<p><b>o recievers found. Return the truck to the garage and any outstanding crates to their dispensers, then return the contract to the board.</b></p>"
	else
		for(var/obj/structure/delivery_reciever/reciever in saved_recievers)
			var/turf/reciever_turf = get_turf(reciever)
			html += "<p><b>Reciever [reciever.chute_name] - X:[reciever_turf.x] Y:[reciever_turf.y] Z:[reciever_turf.z]</b><br>"
			if(reciever.delivery_status["red"] > 0)
				var/html_color = get_cargo_color_value("red")
				html += {"<span style="color: [html_color];">RED</span> crates remaining: [reciever.delivery_status["red"]]<br>"}
			if(reciever.delivery_status["blue"] > 0)
				var/html_color = get_cargo_color_value("blue")
				html += {"<span style="color: [html_color];">BLUE</span> crates remaining: [reciever.delivery_status["blue"]]<br>"}
			if(reciever.delivery_status["yellow"] > 0)
				var/html_color = get_cargo_color_value("yellow")
				html += {"<span style="color: [html_color];">YELLOW</span> crates remaining: [reciever.delivery_status["yellow"]]<br>"}
			if(reciever.delivery_status["green"] > 0)
				var/html_color = get_cargo_color_value("green")
				html += {"<span style="color: [html_color];">GREEN</span> crates remaining: [reciever.delivery_status["green"]]<br>"}
			html += "</p>"
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
			html += "<p><b>Active Crates:</b>"
			for(var/turf/picked_turf in turf_list)
				html += "X:[picked_turf.x] Y:[picked_turf.y] Z:[picked_turf.z]<br>"
				html += "</p>"
	else
		html += "<b><p>No active crates.</b></p>"
	if(delivery.delivery_dispensers.len != 0)
		for(var/obj/structure/delivery_dispenser/dispenser in delivery.delivery_dispensers)
			var/turf/dispenser_turf = get_turf(dispenser)
			var/html_color = get_cargo_color_value(dispenser.crate_type)
			html += {"<p><b>Dispenser [dispenser.chute_name]</b> for <b>crate type <span style="color: [html_color];">[capitalize(dispenser.crate_type)]</span></b> available at X:[dispenser_turf.x] Y:[dispenser_turf.y] Z:[dispenser_turf.z]</p>"}
	else
		html += "<p><b>Dispensers not found.</p></b>"
	to_chat(user, html)

/datum/controller/subsystem/ticker/proc/transportation_report()
	var/list/parts = list()
	parts += "<p>"

	if(GLOB.delivery_stats.len == 0)
		parts += "No deliveries were made this round!</p>"
		return parts.Join()

	var/current_position = 1

	while(current_position <= GLOB.delivery_stats.len)
		switch(GLOB.delivery_stats[current_position])
			if("oops")
				parts += "<b>OOPS Delivery Service:</b><br>"
			if("millenium_delivery")
				parts += "<b>Millenium Tower Delivery Service:</b><br>"
			if("bar_delivery")
				parts += "<b>Bar Delivery Service:</b><br>"

		var/grade_average = round((GLOB.delivery_stats[current_position]["grade"] / GLOB.delivery_stats[current_position]["completed"]),0.1)

		parts += "Grade Average: <b>[grade_average]</b><br>"
		parts += "Orders Complete: <b>[GLOB.delivery_stats[current_position]["completed"]]"
		parts += "Crates Delivered: <b>[GLOB.delivery_stats[current_position]["delivered_crates"]]</b>"

	parts += "</p>"

	return parts.Join()
