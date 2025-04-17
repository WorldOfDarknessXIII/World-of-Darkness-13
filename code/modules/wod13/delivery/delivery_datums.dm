/datum/delivery_datum/
	var/delivery_employer_tag
	var/obj/structure/delivery_board/board
	var/obj/item/delivery_contract/contract
	var/mob/original_owner
	var/list/contract_takers = list()
	var/area/vtm/interior/delivery_garage/garage_area
	var/obj/effect/landmark/delivery_truck_beacon/truck_spawner
	var/obj/vampire_car/delivery_truck/active_truck
	var/list/delivery_dispensers = list()
	var/list/delivery_recievers = list()
	var/list/active_crates = list()
	var/list/delivery_score = list(
		"trucks_used" = 0,
		"dispensed_crates" = 0,
		"delivered_crates" = 0,
		"misdelivered_crates" = 0,
		"completed_recievers" = 0,
		"manifest_refresh" = 0,
		"timeout_timestamp" = 0,
		)

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
	broadcast_to_holders("Delivery Complete. [final_payout] paid to the accounts of all participants.")
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
	if(delivery_score["trucks_used"] > 0)
		final_grade -= 2
	if(delivery_score["dispensed_crates"] > delivery_score["delivered_crates"])
		final_grade -= 1
	if(delivery_score["misdelivered_crates"] > 0)
		final_grade -= 1
	if(delivery_score["manifest_refresh"] > 3)
		final_grade -= 1
	if(final_grade < 1) final_grade = 1
	broadcast_to_holders("Delivery Grade: [parse_grade(final_grade)]")
	process_payouts()
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
		to_chat(mob, span_notice(message))

/datum/delivery_datum/proc/assign_dispenser(tag)
	for(var/obj/structure/delivery_dispenser/dispenser in GLOB.delivery_available_dispensers)
		if(dispenser.delivery == null)
			dispenser.delivery = src
			dispenser.crate_type = tag
			switch(tag)
				if("red")
					dispenser.color = "#7c1313"
				if("blue")
					dispenser.color = "#202bca"
				if("yellow")
					dispenser.color = "#b8ac3f"
				if("green")
					dispenser.color = "#165f29"
			delivery_dispensers.Add(dispenser)
			return 1
	return 0

/datum/delivery_datum/proc/assign_recievers(ammount)
	var/recievers_to_assign
	var/list/reciever_list = list()
	reciever_list = GLOB.delivery_available_recievers.Copy()
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
		reciever.delivery = src
		var/crate_number = rand(ammount_min,ammount_max)
		while(crate_number > 0)
			var/picked_type = pick("red","green","yellow","blue")
			reciever.delivery_status[picked_type] += 1
			crate_number -= 1
		INVOKE_ASYNC(reciever, TYPE_PROC_REF(/obj/structure/delivery_reciever/,display_reciever))

/datum/delivery_datum/proc/assign_garage(id)
	if(!id) return
	for(var/area/vtm/interior/delivery_garage/potential_garage_area in GLOB.delivery_garage_areas)
		if(potential_garage_area.delivery_employer_tag == id)
			garage_area = potential_garage_area
			break
	for(var/obj/effect/landmark/delivery_truck_beacon/potential_truck_spawner in GLOB.delivery_available_veh_spawners)
		if(potential_truck_spawner.delivery_employer_tag == id)
			truck_spawner = potential_truck_spawner
			break

/datum/delivery_datum/proc/spawn_truck()
	if(active_truck) return 0
	if(!truck_spawner) return "err"
	truck_spawner.spawn_truck(src)

/datum/delivery_datum/proc/delivery_timeout()
	broadcast_to_holders("Delivery timer expired. Deactivating any outstanding recievers. You have five minutes to return the truck and any outstanding cargo.")
	if(delivery_recievers.len != 0)
		for(var/obj/structure/delivery_reciever/reciever in delivery_recievers)
			reciever.reset_reciever()
	addtimer(CALLBACK(src,PROC_REF(delivery_finish)),5 MINUTES)

/datum/delivery_datum/proc/delivery_set_timer(delay)
	if(!delay) return
	var/timer_value = world.time + delay
	delivery_score["timeout_timestamp"] = timer_value
	addtimer(CALLBACK(src,PROC_REF(delivery_timeout)),delay + 10)

/datum/delivery_datum/proc/check_conditions(difficulty)
	if(!difficulty) return
	var/receiver_number
	switch(difficulty)
		if(1)
			receiver_number = 3
		if(2)
			receiver_number = 5
		if(3)
			receiver_number = 7
	var/list/reciever_list = list()
	reciever_list = GLOB.delivery_available_recievers.Copy()
	for(var/obj/structure/delivery_reciever/potential_reciever in reciever_list)
		if(potential_reciever.delivery != null) reciever_list.Remove(potential_reciever)
	if(reciever_list.len < receiver_number)
		broadcast_to_holders("Error: Not enough delivery recievers. Too many deliveries in progress. Contract aborted.")
		return 0
	return 1

/datum/delivery_datum/New(mob/user,obj/board_ref,difficulty = 2)
	original_owner = user
	add_owner(user)
	if(check_conditions(difficulty) == 0)
		qdel(src)
		return
	board = board_ref
	delivery_employer_tag = board.delivery_employer_tag
	assign_garage(delivery_employer_tag)
	assign_dispenser("red")
	assign_dispenser("blue")
	assign_dispenser("yellow")
	assign_dispenser("green")
	spawn_truck()
	switch(difficulty)
		if(1)
			assign_recievers(3)
			assign_crates(3,6)
			delivery_set_timer(15 MINUTES)
		if(2)
			assign_recievers(5)
			assign_crates(7,10)
			delivery_set_timer(20 MINUTES)
		if(3)
			assign_recievers(7)
			assign_crates(9,15)
			delivery_set_timer(30 MINUTES)

/datum/delivery_datum/Destroy(force, ...)

	board.delivery = null
	board.delivery_cooldown(5 MINUTES)
	board = null
	if(contract)
		qdel(contract)
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

/datum/delivery_storage/proc/rem_from_storage(obj/crate)
	storage.Remove(crate)
	var/turf/owner_turf = get_turf(owner)
	var/turf/destination_turf
	switch(owner.dir)
		if(NORTHEAST,NORTH,NORTHWEST)
			destination_turf = locate(owner_turf.x, owner_turf.y - 1, owner_turf.z)
		if(EAST)
			destination_turf = locate(owner_turf.x + 3, owner_turf.y, owner_turf.z)
		if(WEST)
			destination_turf = locate(owner_turf.x - 1, owner_turf.y, owner_turf.z)
		if(SOUTHEAST,SOUTH,SOUTHWEST)
			destination_turf = locate(owner_turf.x, owner_turf.y + 3, owner_turf.z)
	crate.forceMove(destination_turf)

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
			var/picked_crate
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
				chosen_tag = tgui_input_list(user, "The following crate types are available:","Crate choice",available_tags,timeout = 20 SECONDS)
			if(!chosen_tag)
				check_use(2,user)
				return
			for(var/obj/structure/delivery_crate/crate_to_ret in storage)
				if(crate_to_ret.crate_type == chosen_tag)
					picked_crate = crate_to_ret
					break
			var/ret_delay = 4 SECONDS + calculate_ret_time(chosen_tag)
			if(do_after(user, ret_delay, owner))
				rem_from_storage(picked_crate)
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

/datum/delivery_manifest/proc/read_data(mob/user)
	if(!user) return
	var/turf/user_turf = get_turf(user)
	to_chat(user,span_notice("Current coordinates: X:[user_turf.x] Y:[user_turf.y] Z: [user_turf.z]<br><hr>"))
	if(saved_recievers.len == 0)
		to_chat(user, span_notice("No recievers found. Return the truck to the garage and any outstanding crates to their dispensers, then return the contract to the board.<br><hr>"))
	else
		for(var/obj/structure/delivery_reciever/reciever in saved_recievers)
			var/turf/reciever_turf = get_turf(reciever)
			to_chat(user,span_notice("Reciever [reciever.chute_name] - X:[reciever_turf.x] Y:[reciever_turf.y] Z:[reciever_turf.z]"))
			if(reciever.delivery_status["red"] >= 0) to_chat(user,span_notice({"<span style="color: #7c1313;">RED</span> crates remaining: [reciever.delivery_status["red"]]"}))
			if(reciever.delivery_status["blue"] >= 0) to_chat(user,span_notice({"<span style="color: #202bca;">BLUE</span> crates remaining: [reciever.delivery_status["red"]]"}))
			if(reciever.delivery_status["yellow"] >= 0) to_chat(user,span_notice({"<span style="color: #b8ac3f;">YELLOW</span> crates remaining: [reciever.delivery_status["red"]]"}))
			if(reciever.delivery_status["green"] >= 0) to_chat(user,span_notice({"<span style="color: #165f29;">GREEN</span> crates remaining: [reciever.delivery_status["red"]]"}))
			to_chat(user, "<br><hr>")
	if(delivery.active_truck)
		var/turf/truck_turf = get_turf(delivery.active_truck)
		to_chat(user,span_notice("Truck Active - X:[truck_turf.x] Y:[truck_turf.y] Z:[truck_turf.z]"))
	else
		to_chat(user,span_notice("No truck found."))
	to_chat(user,"<br><hr>")
	if(delivery.active_crates.len != 0)
		var/list/turf_list = list()
		for(var/obj/structure/delivery_crate/crate in delivery.active_crates)
			if(crate.loc)
				var/turf/tested_turf = get_turf(crate)
				if(turf_list.Find(tested_turf) == 0)
					turf_list.Add(tested_turf)
		if(turf_list.len != 0)
			to_chat(user,span_notice("Active Crates:"))
			for(var/turf/picked_turf in turf_list)
				to_chat(user,span_notice("X:[picked_turf.x] Y:[picked_turf.y] Z:[picked_turf.z]"))
	else
		to_chat(user, span_notice("No active crates."))
	to_chat(user, "<br><hr>")
	if(delivery.delivery_dispensers.len != 0)
		for(var/obj/structure/delivery_dispenser/dispenser in delivery.delivery_dispensers)
			var/turf/dispenser_turf = get_turf(dispenser)
			to_chat(user, span_notice("Dispenser for crate type [capitalize(dispenser.crate_type)] available at X:[dispenser_turf.x] Y:[dispenser_turf.y] Z:[dispenser_turf.z]"))
	else
		to_chat(user,span_notice("Dispensers not found."))
	to_chat(user, "<br><hr>")
