/obj/item/delivery_contract
	name = "delivery contract"
	desc = "A delivery contract issued by the OOPS delivery company. Use it in your hand to scan it for details. If your name is on the contract, use it on someone else to add them to it."
	icon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "masquerade"
	color = "#bbb95c"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'

	var/datum/delivery_datum/delivery
	var/datum/delivery_manifest/manifest

/obj/item/delivery_contract/New(loc, datum/del_datum)
	if(del_datum)
		delivery = del_datum
		delivery.contract = src
		manifest.save_data(init = 1)
	. = ..()

/obj/item/delivery_contract/attack_hand(mob/user)
	if(!delivery) return "no_datum"
	if(!manifest) return "no_manifest"
	if(delivery.check_owner(user) == 0)
		to_chat(user, span_warning("You are not listed on this manifest. Before you can use it, one of its owners needs to add you to the crew handling it by using the manifest on you."))
		return
	else
		manifest.read_data(user)

/obj/item/delivery_contract/attack(mob/living/M, mob/living/user)
	if(!delivery)
		to_chat(user,span_notice("Error: No delivery datum attached. This is most likely a bug."))
		return
	if(M.client == null)
		to_chat(user,span_notice("Error: Target mob has no client. This is not a player mob."))
		return
	if(delivery.check_owner(user) == 0)
		to_chat(user,span_warning("You are not listed on this manifest. Before you can use it, one of its owners needs to add you to the crew handling it by using the manifest on you."))
		return
	if(delivery.check_owner(user) == 1)
		if(delivery.check_owner(M) == 0)
			if(tgui_alert(user,"Do you want to add [M] to the delivery contract?","Contract add confirmation",list("Yes","No"),timeout = 10 SECONDS) == "Yes")
				delivery.add_owner(M)
				to_chat(user, span_notice("Success! User [M] added."))
			return
		if(delivery.check_owner(M) == 1)
			if(delivery.original_owner == M) return
			if(delivery.original_owner != user)
				to_chat(user,span_notice("Only the original owner of the contract, [delivery.original_owner] can remove people from the contract."))
				return
			else
				if(tgui_alert(user,"Do you want to remove [M] from the delivery contract?","Contract remove confirmation",list("Yes","No"),timeout = 10 SECONDS) == "Yes")
					delivery.contract_takers.Remove(M)
					to_chat(user, span_notice("Success! User [M] removed."))
				return

	. = ..()

/obj/item/delivery_contract/Destroy()
	if(delivery)
		delivery.contract = null
		delivery = null
	qdel(manifest)
	. = ..()


/obj/structure/delivery_board
	name = "delivery assignment board"
	desc = "A board made out of cork where delivery contracts are pinned. Use it with an emtpy hand to see if any are available."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nboard02"
	anchored = 1
	density = 0
	var/datum/delivery_datum/delivery
	var/delivery_employer_tag = "default"
	var/next_delivery_timestamp

/obj/structure/delivery_board/proc/delivery_icon()
	icon_state = "nboard02"
	update_icon()

/obj/structure/delivery_board/proc/delivery_cooldown(timer)
	var/time_to_wait = 5 MINUTES
	if(timer) time_to_wait = timer
	addtimer(CALLBACK(src,TYPE_PROC_REF(/obj/structure/delivery_board,delivery_icon)),time_to_wait)

/obj/structure/delivery_board/attack_hand(mob/living/user)
	. = ..()
	if(!delivery)
		if(world.time > next_delivery_timestamp)
			if(tgui_alert(user,"A new contract is available. Do you wish to start a delivery?","Delivery available",list("Yes","No"),timeout = 10 SECONDS) == "Yes")
				var/picked_difficulty
				switch(tgui_input_list(user,"Select a contract length, details will be outlined before accepting.","Contract Selection",list("Short","Medium","Long"),timeout = 10 SECONDS))
					if("Short")
						picked_difficulty = 1
						to_chat(user,span_notice("A short contract involves 3 locations with up to 6 crates each, meaning the entire delivery can be completed with one truck. The time limit is 15 minutes."))
					if("Medium")
						picked_difficulty = 2
						to_chat(user,span_notice("A medium contract involves 5 locations with up to 10 crates each, the entire delivery should be completed in 3 runs. The time limit is 20 minutes. "))
					if("Long")
						picked_difficulty = 3
						to_chat(user,span_notice("A long contract involves 7 locations with up to 15 crates each, meaning that without partial loads each delivery will require a restock. The timie limit is 30 minutes."))
				if(tgui_alert(user,"Do you want to start the contract?","Confirm Contract",list("Yes","No"),timeout = 10 SECONDS) == "Yes")
					delivery = new(user,src,picked_difficulty)
					if(!delivery) return
					var/obj/item/delivery_contract/contract = new(get_turf(user),delivery)
					user.put_in_hands(contract)
					icon_state = "nboard00"
					update_icon()
		else
			(to_chat(user,span_notice("A contract was just concluded. There are [time2text((next_delivery_timestamp - world.time),"mm:ss")] left until the next contract can be picked.")))
	else
		to_chat(user,span_notice("There are no contracts available."))

/obj/structure/delivery_board/attackby(obj/item/I, mob/living/user, params)
	if(istype(I,/obj/item/delivery_contract/))
		var/obj/item/delivery_contract/contract_item = I
		if(contract_item == delivery.contract)
			if(delivery.check_owner(user) == 1)
				if(tgui_alert(user,"Do you wish to update the information on the contract?","Contract Update",list("Yes","No"),timeout = 10 SECONDS) == "Yes")
					contract_item.manifest.save_data()
				if(delivery.delivery_recievers.len == 0)
					to_chat(user,span_notice("The contract is concluded. You may safely finialize it."))
				else
					to_chat(user,span_notice("This contract is not complete. You may wrap it early if you wish."))
				if(get_area(delivery.active_truck) != delivery.garage_area)
					to_chat(user,span_warning("Warning: Truck outside of garage area."))
				if(tgui_alert(user,"Do you wish to finalize the contract?","Finalize Confirm",list("Yes","No"),timeout = 10 SECONDS) == "Yes")
					delivery.delivery_finish()
		else
			to_chat(user,span_warning("This contract does not seem to be from this board."))
			return
	. = ..()


/obj/structure/delivery_reciever

	name = "delivery chute"
	desc = "A chute used to handle bulk deliveries. A standard shipping crate should slide right in."
	anchored = 1
	density = 0
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "box_put"
	var/chute_name = "default"
	var/datum/delivery_datum/delivery
	var/list/delivery_status = list(
		"red" = 0,
		"blue" = 0,
		"yellow" = 0,
		"green" = 0,
		)

/obj/structure/delivery_reciever/proc/reset_reciever()
	delivery.delivery_recievers.Remove(src)
	delivery = null
	delivery_status = list(
		"red" = 0,
		"blue" = 0,
		"yellow" = 0,
		"green" = 0,
		)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/delivery_reciever,display_reciever))

/obj/structure/delivery_reciever/proc/check_deliveries()
	if(delivery_status["red"] != 0 || delivery_status["blue"] != 0 || delivery_status["yellow"] != 0 || delivery_status["green"] != 0) return
	delivery.delivery_score["completed_recievers"] += 1
	if(delivery.check_complete() == 1)
		delivery.broadcast_to_holders("All deliveries have been complete. Please return the truck and any outstanding cargo back to the office to finalize the contract!")
	else
		delivery.broadcast_to_holders("Delivery to [chute_name] complete. [num2text(delivery.delivery_recievers.len)] chutes remain.")
	reset_reciever()

/obj/structure/delivery_reciever/Initialize()
	. = ..()
	alpha = 0
	GLOB.delivery_available_recievers.Add(src)

/obj/structure/delivery_reciever/Destroy()
	. = ..()
	GLOB.delivery_available_recievers.Remove(src)
	if(delivery)
		delivery.delivery_recievers.Remove(src)
		delivery = null

/obj/structure/delivery_reciever/attack_hand(mob/living/user)
	. = ..()
	if(user.pulling)
		if(!delivery) return
		var/obj/structure/delivery_crate/pulled_crate = user.pulling
		if(pulled_crate)
			if(do_after(user, 5 SECONDS, src))
				if(delivery_status[pulled_crate.crate_type] > 0)
					delivery_status[pulled_crate.crate_type] =- 1
					delivery.delivery_score["delivered_crates"] += 1
					check_deliveries()
				else
					delivery.delivery_score["misdelivered_crates"] += 1
				qdel(pulled_crate)

/obj/structure/delivery_reciever/proc/check_for_clients()
	var/client_detected = 0
	for(var/mob/living/carbon/human/human_in_range in viewers(src))
		if(!human_in_range) break
		if(human_in_range.client != null)
			client_detected = 1
			break
		else
			continue
	return client_detected

/obj/structure/delivery_reciever/proc/display_reciever()
	var/check_result = check_for_clients()
	while(check_result == 1)
		stoplag(10 SECONDS)
		check_result = check_for_clients()
	if (alpha == 0)
		alpha = 255
	else
		alpha = 0

/obj/structure/delivery_dispenser

	name = "delivery dispenser"
	desc = "A chute used to handle bulk deliveries. A small button can be used to dispense a crate."
	anchored = 1
	density = 0
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "box_take"
	var/delivery_employer_tag = "default"
	var/datum/delivery_datum/delivery
	var/crate_type

/obj/structure/delivery_dispenser/Initialize()
	. = ..()
	GLOB.delivery_available_dispensers.Add(src)

/obj/structure/delivery_dispenser/Destroy()
	. = ..()
	GLOB.delivery_available_dispensers.Remove(src)
	if(delivery)
		delivery = null

/obj/structure/delivery_dispenser/proc/reset_dispenser()
	if(delivery)
		delivery.delivery_dispensers.Remove(src)
		delivery = null
	crate_type = null

/obj/structure/delivery_dispenser/proc/dispense_cargo()
	var/target_turf = get_turf(src)
	switch(crate_type)
		if("red")
			var/obj/structure/delivery_crate/red/dispensed_crate = new(target_turf)
			dispensed_crate.delivery = delivery
			delivery.active_crates.Add(dispensed_crate)
		if("blue")
			var/obj/structure/delivery_crate/blue/dispensed_crate = new(target_turf)
			dispensed_crate.delivery = delivery
			delivery.active_crates.Add(dispensed_crate)
		if("yellow")
			var/obj/structure/delivery_crate/yellow/dispensed_crate = new(target_turf)
			dispensed_crate.delivery = delivery
			delivery.active_crates.Add(dispensed_crate)
		if("green")
			var/obj/structure/delivery_crate/green/dispensed_crate = new(target_turf)
			dispensed_crate.delivery = delivery
			delivery.active_crates.Add(dispensed_crate)
	delivery.delivery_score["dispensed_crates"] += 1

/obj/structure/delivery_dispenser/attack_hand(mob/living/user)
	. = ..()
	if(!delivery)
		to_chat(user, span_notice("The device seems to be offline."))
		return
	if(delivery.check_owner(user) == 0)
		to_chat(user, span_notice("The device is active, but nothing happens when you try to use it."))
		return
	if(delivery.check_owner(user) == 1)
		if(user.pulling == null)
			if(do_after(user, 5 SECONDS, src))
				dispense_cargo(crate_type)
		else
			var/obj/structure/delivery_crate/pulled_crate = user.pulling
			if(pulled_crate)
				if(pulled_crate.crate_type == crate_type)
					qdel(pulled_crate)
					delivery.delivery_score["dispensed_crates"] -= 1

/obj/structure/delivery_crate

	name = "delivery crate"
	desc = "A sealed crate, ready for transport and delivery."
	anchored = 0
	density = 1
	icon = 'icons/obj/crates.dmi'
	icon_state = "crate"
	var/datum/delivery_datum/delivery
	var/crate_type

/obj/structure/delivery_crate/Initialize()
	if(crate_type) name = initial(name) + " - [crate_type]"
	AddElement(/datum/element/climbable)
	. = ..()

/obj/structure/delivery_crate/Destroy()
	if(delivery)
		delivery.active_crates.Remove(src)
		delivery = null
	. = ..()


/obj/vampire_car/delivery_truck
	name = "delivery truck"
	desc = "A truck with specially prepared racks in the back allowing for easy storage and retrieval of delivery packages."
	component_type = null
	baggage_limit = null
	baggage_max = null
	var/delivery_capacity = 20
	var/datum/delivery_datum/delivery
	var/datum/delivery_storage/delivery_trunk

/obj/vampire_car/delivery_truck/Destroy()
	if(delivery)
		delivery.active_truck = null
		delivery = null
	qdel(delivery_trunk)
	. = ..()


/obj/vampire_car/delivery_truck/Initialize()
	. = ..()
	delivery_trunk = new(src,delivery_capacity)

/obj/vampire_car/delivery_truck/Destroy()
	. = ..()
	if(delivery)
		if(delivery.active_truck == src)
			if(get_area(src) == delivery.garage_area)
				delivery.delivery_score["trucks_used"] -= 1
			delivery.active_truck = null
		delivery = null

/obj/vampire_car/delivery_truck/ComponentInitialize()
	return

/obj/vampire_car/delivery_truck/attack_hand(mob/user)
	. = ..()
	if(locked == FALSE)
		if(user.pulling == null)
			if(delivery_trunk.storage.len == 0)
				to_chat(user, span_notice("There is nothing in the back of the truck."))
			else
				delivery_trunk.retrieval_menu(user)
		else
			var/obj/structure/delivery_crate/pulled_crate = user.pulling
			if(!pulled_crate)
				to_chat(user, span_warning("The special compartments in the back dont really fit anything other than delivery crates. Use a nomral truck for other cargo."))
				return
			else
				if(do_after(user, 5 SECONDS, pulled_crate)) delivery_trunk.add_to_storage(user,pulled_crate)

/obj/effect/landmark/delivery_truck_beacon
	name = "delivery truck spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	invisibility = 101
	density = 0
	var/delivery_employer_tag = "default"

/obj/effect/landmark/delivery_truck_beacon/proc/spawn_truck(datum/linked_datum)
	if(!linked_datum) return
	var/turf/local_turf = get_turf(src)
	var/obj/vampire_car/delivery_truck/spawned_truck = new(local_turf)
	spawned_truck.delivery = linked_datum
	spawned_truck.locked = TRUE
	spawned_truck.access = spawned_truck.delivery.delivery_employer_tag
	var/obj/item/vamp/keys/spawned_keys = new(local_turf)
	spawned_keys.accesslocks = list(spawned_truck.delivery.delivery_employer_tag)
	spawned_truck.delivery.original_owner.put_in_hands(spawned_keys)
