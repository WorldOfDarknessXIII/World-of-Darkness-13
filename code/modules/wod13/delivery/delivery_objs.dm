/obj/item/delivery_contract
	name = "delivery contract"
	desc = "A delivery contract issued by a delivery company. Use it in your hand to scan it for details. If your name is on the contract, use it on someone else to add them to it."
	icon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "masquerade"
	color = "#bbb95c"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'

	var/datum/delivery_datum/delivery
	var/datum/delivery_manifest/manifest

/obj/item/delivery_contract/New(mob/user, obj/board,difficulty)
	delivery = new(user,board,difficulty)
	delivery.contract = src
	manifest = new(delivery)
	. = ..()

/obj/item/delivery_contract/attack(mob/living/M, mob/living/user)
	if(!delivery)
		to_chat(user,span_notice("Error: No delivery datum attached. This is most likely a bug."))
		return
	if(!manifest) return "no_manifest"
	if(M == user)
		if(delivery.check_owner(user) == 0)
			to_chat(user, span_warning("You are not listed on this manifest. Before you can use it, one of its owners needs to add you to the crew handling it by using the manifest on you."))
			return
		else
			manifest.read_data(user)
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
				var/obj/item/vamp/keys/cargo_truck/truck_keys = new(src)
				truck_keys.delivery = delivery
				truck_keys.owner = M
				M.put_in_hands(truck_keys)
				to_chat(user, span_notice("Success! User [M] added."))
			return
		if(delivery.check_owner(M) == 1)
			if(delivery.original_owner == M) return
			if(delivery.original_owner != user)
				to_chat(user,span_notice("Only the original owner of the contract, [delivery.original_owner] can remove people from the contract."))
				return
			else
				if(delivery.delivery_recievers.len == 0)
					to_chat(user,span_warning("This delivery is complete and should be handed in. Removing users is no longer possibe."))
					return
				if(tgui_alert(user,"Do you want to remove [M] from the delivery contract?","Contract remove confirmation",list("Yes","No"),timeout = 10 SECONDS) == "Yes")
					delivery.contract_takers.Remove(M)
					for(var/obj/item/vamp/keys/cargo_truck/truck_keys in delivery.spawned_keys)
						if(truck_keys.owner == M)
							qdel(truck_keys)
					to_chat(user, span_notice("Success! User [M] removed."))
				return

	. = ..()

/obj/item/delivery_contract/attack_self(mob/user)
	if(!delivery)
		to_chat(user,span_notice("Error: No delivery datum attached. This is most likely a bug."))
		return
	if(!manifest) return "no_manifest"

	if(delivery.check_owner(user) == 0)
		to_chat(user, span_warning("You are not listed on this manifest. Before you can use it, one of its owners needs to add you to the crew handling it by using the manifest on you."))
	else
		manifest.read_data(user)
	. = ..()


/obj/item/delivery_contract/Destroy()
	. = ..()
	if(delivery) qdel(delivery)
	if(manifest) qdel(manifest)


/obj/structure/delivery_board
	color = "#ffb171"
	name = "delivery assignment board"
	desc = "A board made out of cork where delivery contracts are pinned. Use it with an emtpy hand to see if any are available."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nboard02"
	anchored = 1
	density = 0
	var/delivery_started = 0
	var/delivery_employer_tag = "default"
	var/next_delivery_timestamp
	var/list/crate_types = list(
		"red" = list(
			"cargo_name" = "Cleaning Supplies",
			"color" = "#7c1313",
			"desc" = "Red tinted crates typically contain cleaning supplies, including cleaning chemicals, replacement mops, rags and personal safety equipment.",
			),
		"blue" = list(
			"cargo_name" = "Maintenance Supplies",
			"color" = "#202bca",
			"desc" = "Anything and everything related to maintaining electronics in a store or house - replacement batteries, light bulbs, electronic components as well as tools needed to replace and fix devices using them. ",
			),
		"yellow" = list(
			"cargo_name" = "Equipment and Electronics",
			"color" = "#b8ac3f",
			"desc" = "Large items like computers and other electronics, lightning and ventilation systems, AC units as well as shelving and furniture typically in separate elements and needing further assembly. Also, tools required for the assembly of the above.",
			),
		"green" = list(
			"cargo_name" = "Personal Items",
			"color" = "#165f29",
			"desc" = "Private correspondence and deliveries marked as private. It could be cargo belonging to other crates but earmarked for private delivery due to private reselling or personal use. Typically, just mail but shipped in bulk. ",
			),
		)

/obj/structure/delivery_board/proc/delivery_icon()
	icon_state = "nboard02"
	update_icon()

/obj/structure/delivery_board/proc/delivery_cooldown(timer)
	var/time_to_wait = 5 MINUTES
	if(timer) time_to_wait = timer
	addtimer(CALLBACK(src,TYPE_PROC_REF(/obj/structure/delivery_board,delivery_icon)),time_to_wait)

/obj/structure/delivery_board/attack_hand(mob/living/user)
	. = ..()
	if(!delivery_started)
		if(world.time > next_delivery_timestamp)
			if(tgui_alert(user,"A new contract is available. Do you wish to start a delivery?","Delivery available",list("Yes","No"),timeout = 10 SECONDS) == "Yes")
				var/picked_difficulty
				var/difficulty_text
				switch(tgui_input_list(user,"Select a contract length, details will be outlined before accepting.","Contract Selection",list("Short","Medium","Long"),timeout = 10 SECONDS))
					if("Short")
						picked_difficulty = 1
						difficulty_text = "A short contract involves 3 locations with up to 6 crates each, meaning the entire delivery can be completed with one truck. The time limit is 20 minutes."
					if("Medium")
						picked_difficulty = 2
						difficulty_text = "A medium contract involves 5 locations with up to 10 crates each, the entire delivery should be completed in 3 runs. The time limit is 45 minutes. "
					if("Long")
						picked_difficulty = 3
						difficulty_text = "A long contract involves 7 locations with up to 15 crates each, meaning that without partial loads each delivery will require a restock. The timie limit is 90 minutes."
				if(tgui_alert(user,difficulty_text,"Confirm Contract",list("Yes","No"),timeout = 10 SECONDS) == "Yes")
					var/obj/item/delivery_contract/contract = new(user,src,picked_difficulty)
					switch(contract.delivery.start_contract())
						if(1)
							user.put_in_hands(contract)
							icon_state = "nboard00"
							update_icon()
							to_chat(user,span_notice("Success! A new contract was created and aprorpiate items have been created and dispensed. Check the cotnract item for information about your delivery."))
							contract.manifest.save_data(init = TRUE)
							contract.manifest.read_data(contract.delivery.original_owner)
							delivery_started = 1
							return
						if("fail_reci")
							to_chat(user, span_warning("Not enough recievers avaialble in the game world. This is most likley because too many cotnracts are active at the same time, but is very likely a mapping bug."))
							qdel(contract)
						if("fail_garage")
							to_chat(user, span_warning("No garage area found. This is a mapping bug and should be reported."))
							qdel(contract)
						if("fail_disp")
							to_chat(user, span_warning("Not enough dispensers. This is a mapping bug and should be reported."))
							qdel(contract)
						if("fail_truck")
							to_chat(user, span_warning("Truck spawning failed. This is a mapping bug and should be reported."))
							qdel(contract)
					return
		else
			(to_chat(user,span_notice("A contract was just concluded. There are [time2text((next_delivery_timestamp - world.time),"mm:ss")] left until the next contract can be picked.")))
	else
		to_chat(user,span_notice("There are no contracts available."))

/obj/structure/delivery_board/attackby(obj/item/I, mob/living/user, params)
	if(istype(I,/obj/item/delivery_contract/))
		var/obj/item/delivery_contract/contract_item = I
		if(contract_item.delivery.delivery_employer_tag != delivery_employer_tag)
			to_chat(user,span_warning("This contract does not seem to be from this board."))
			return
		if(contract_item.delivery.check_owner(user) == 0)
			to_chat(user,span_warning("You don't seem to be on this contract. Only the person who signed the cotract can add you."))
			return
		if(contract_item.delivery.delivery_recievers.len == 0)
			if(get_area(contract_item.delivery.active_truck) != contract_item.delivery.garage_area)
				to_chat(user,span_warning("Warning: Truck outside of garage area."))
			if(tgui_alert(user,"Do you wish to finalize the contract?","Finalize Confirm",list("Yes","No"),timeout = 10 SECONDS) == "Yes")
				contract_item.delivery.delivery_finish()
				return
		if(tgui_alert(user,"Do you wish to update the information on the contract?","Contract Update",list("Yes","No"),timeout = 10 SECONDS) == "Yes")
			contract_item.manifest.save_data()
			return
		if(get_area(contract_item.delivery.active_truck) != contract_item.delivery.garage_area)
			to_chat(user,span_warning("Warning: Truck outside of garage area."))
		if(tgui_alert(user,"Do you wish to finalize the contract early?","Finalize Confirm",list("Yes","No"),timeout = 10 SECONDS) == "Yes")
			contract_item.delivery.delivery_finish()
			return

	if(istype(I,/obj/item/vamp/keys/cargo_truck))
		var/obj/item/vamp/keys/cargo_truck/truck_keys = I
		if(truck_keys.delivery.delivery_employer_tag != delivery_employer_tag)
			to_chat(user,span_warning("These keys dont's eem to be oes not seem to be from this board."))
			return
		if(tgui_alert(user,"Are you SURE you want to respawn the delivery truck? This will reduce your final grade.","Respawn Truck", list("Yes","No"), timeout = 10 SECONDS) == "Yes")
			var/obj/old_truck = truck_keys.delivery.active_truck
			var/obj/effect/landmark/delivery_truck_beacon/truck_beacon = truck_keys.delivery.truck_spawner
			qdel(old_truck)
			truck_beacon.spawn_truck(truck_keys.delivery)
	. = ..()


/obj/structure/delivery_reciever

	name = "delivery chute"
	desc = "A chute used to handle bulk deliveries. A standard shipping crate should slide right in."
	anchored = 1
	density = 0
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "box_put"
	var/chute_name = "default"
	var/delivery_in_use = 0
	var/reciever_in_use = 0
	var/list/delivery_status = list(
		"red" = 0,
		"blue" = 0,
		"yellow" = 0,
		"green" = 0,
		)
	light_color = "#ffffff"
	light_power = 2

/obj/structure/delivery_reciever/proc/reset_reciever()
	delivery_in_use = 0
	delivery_status = list(
		"red" = 0,
		"blue" = 0,
		"yellow" = 0,
		"green" = 0,
		)
	animate(src, alpha = 0, time = 5 SECONDS)
	mouse_opacity = 0
	set_light(0)

/obj/structure/delivery_reciever/proc/check_deliveries()
	if(delivery_status["red"] != 0 || delivery_status["blue"] != 0 || delivery_status["yellow"] != 0 || delivery_status["green"] != 0) return 0
	return 1

/obj/structure/delivery_reciever/Initialize()
	. = ..()
	alpha = 0
	mouse_opacity = 0
	GLOB.delivery_available_recievers.Add(src)
	name = "[initial(name)] - [capitalize(chute_name)]"

/obj/structure/delivery_reciever/Destroy()
	. = ..()
	GLOB.delivery_available_recievers.Remove(src)

/obj/structure/delivery_reciever/attack_hand(mob/living/user)
	. = ..()
	if(reciever_in_use == 1)
		to_chat(user, span_warning("Someone is already operating this reciever!"))
	if(user.pulling)
		if(delivery_in_use == 0) return
		if(istype(user.pulling,/obj/structure/delivery_crate/))
			var/obj/structure/delivery_crate/pulled_crate = user.pulling
			if(pulled_crate.delivery.check_owner(user) == 0)
				to_chat(user, span_warning("You aren't authorized to handle this delivery. For security reasons, the reciever denies the package."))
				return
			reciever_in_use = 1
			playsound(src,'sound/effects/cargocrate_move.ogg',50,10)
			if(do_after(user, 2 SECONDS, src))
				if(delivery_status[pulled_crate.crate_type] > 0)
					delivery_status[pulled_crate.crate_type] -= 1
					pulled_crate.delivery.delivery_score["delivered_crates"] += 1
					if(check_deliveries() == 1)
						pulled_crate.delivery.reciever_complete(src)
						reset_reciever()
				else
					pulled_crate.delivery.delivery_score["misdelivered_crates"] += 1
				playsound(src,'sound/effects/cargocrate_load.ogg',50,10)
				qdel(pulled_crate)
			reciever_in_use = 0

/obj/structure/delivery_dispenser

	name = "Cargo Dispenser"
	desc = "A chute used to handle bulk deliveries. There is a visible keyhole and a small button to push."
	anchored = 1
	density = 0
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "box_take"
	var/chute_name = "default"
	var/dispenser_active = 0
	var/dispenser_in_use
	var/delivery_employer_tag
	var/crate_type
	light_color = "#ffffff"
	light_power = 20

/obj/structure/delivery_dispenser/Initialize()
	. = ..()
	GLOB.delivery_available_dispensers.Add(src)
	alpha = 0
	mouse_opacity = 0
	name = "[initial(name)] - [capitalize(chute_name)]]"

/obj/structure/delivery_dispenser/Destroy()
	. = ..()
	GLOB.delivery_available_dispensers.Remove(src)

/obj/structure/delivery_dispenser/proc/reset_dispenser()
	dispenser_active = 0
	crate_type = null
	light_color = initial(light_color)
	set_light(0)
	animate(src,alpha = 0,5 SECONDS)
	mouse_opacity = 0

/obj/structure/delivery_dispenser/proc/dispense_cargo(obj/truck_key, turf/target_turf)
	if(!truck_key) return
	var/obj/item/vamp/keys/cargo_truck/key_item = truck_key
	var/obj/structure/delivery_crate/dispensed_crate = new(target_turf)
	dispensed_crate.crate_type = crate_type
	dispensed_crate.delivery = key_item.delivery
	dispensed_crate.name += " - [key_item.delivery.crate_designations["[crate_type]"]["cargo_name"]]"
	dispensed_crate.color = key_item.delivery.crate_designations["[crate_type]"]["color"]
	dispensed_crate.desc += " [key_item.delivery.crate_designations["[crate_type]"]["desc"]]"
	dispensed_crate.update_icon()
	playsound(src,'sound/effects/cargocrate_unload.ogg',50,10)
	key_item.delivery.delivery_score["dispensed_crates"] += 1

/obj/structure/delivery_dispenser/attack_hand(mob/living/user)
	. = ..()
	if(dispenser_active == 0)
		to_chat(user, span_notice("The device seems to be offline."))
		return
	if(dispenser_in_use == 1)
		to_chat(user, span_warning("Someone is already using this dispenser!"))
		return
	if(user.pulling == null)
		to_chat(user, span_notice("It appears that you need to use a key to operate this dispenser. If you are on a delivery, use the key you got when you signed up or were added to the contract."))
		return
	if(user.pulling != null)
		if(istype(user.pulling, /obj/structure/delivery_crate))
			var/obj/structure/delivery_crate/pulled_crate = user.pulling
			if(pulled_crate.source_dispenser == src)
				dispenser_in_use = 1
				playsound(src,'sound/effects/cargocrate_move.ogg',50,10)
				if(do_after(user, 2 SECONDS, src))
					pulled_crate.delivery.delivery_score["dispensed_crates"] -= 1
					playsound(src,'sound/effects/cargocrate_load.ogg',50,10)
					qdel(pulled_crate)
				dispenser_in_use = 0

/obj/structure/delivery_dispenser/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(dispenser_in_use == 1)
		to_chat(user, span_warning("Someone is already using this dispenser!"))
		return
	if(istype(I,/obj/item/vamp/keys/cargo_truck))
		var/obj/item/vamp/keys/cargo_truck/truck_key = I
		if(truck_key.delivery == null)
			to_chat(user,span_warning("Error, delivery data missing. This is a bug."))
			return
		if(truck_key.delivery.delivery_dispensers.Find(src) == 0)
			to_chat(user,span_notice("They key does not seem to work in this dispenser."))
			return
		var/turf/user_turf = get_turf(user)
		for(var/obj/structure/delivery_crate/potential_crate in user_turf.contents)
			if(potential_crate)
				to_chat(user, span_warning("There is already a crate on the ground here!"))
				return
		dispenser_in_use = 1
		playsound(src,'sound/effects/cargocrate_move.ogg',50,10)
		if(do_after(user, 2 SECONDS, src))
			dispense_cargo(truck_key,user_turf)
		dispenser_in_use = 0

/obj/structure/delivery_crate

	name = "delivery crate"
	desc = "A sealed crate, ready for transport and delivery."
	anchored = 0
	density = 1
	icon = 'icons/obj/crates.dmi'
	icon_state = "crate"
	var/datum/delivery_datum/delivery
	var/obj/structure/delivery_dispenser/source_dispenser
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
	icon_state = "track"
	max_passengers = 4
	component_type = null
	baggage_limit = 0
	baggage_max = null
	var/delivery_capacity = 20
	var/datum/delivery_datum/delivery
	var/datum/delivery_storage/delivery_trunk

/obj/vampire_car/delivery_truck/Destroy()
	if(delivery)
		if(delivery.active_truck == src) delivery.active_truck = null
		delivery = null
	qdel(delivery_trunk)
	. = ..()


/obj/vampire_car/delivery_truck/Initialize()
	. = ..()
	delivery_trunk = new(src,delivery_capacity)

/obj/vampire_car/delivery_truck/ComponentInitialize()
	return

/obj/vampire_car/delivery_truck/attack_hand(mob/user)
	. = ..()
	if(locked == TRUE)
		to_chat(user,span_warning("The truck is locked!"))
		return
	if(user.pulling == null)
		if(delivery_trunk.storage.len == 0)
			to_chat(user, span_notice("There is nothing in the back of the truck."))
			return
		var/turf/user_turf = get_turf(user)
		for(var/obj/structure/delivery_crate/potential_crate in user_turf.contents)
			if(potential_crate)
				to_chat(user, span_warning("There is already a crate on the ground here!"))
				return
		delivery_trunk.retrieval_menu(user)
	else
		var/obj/structure/delivery_crate/pulled_crate = user.pulling
		if(!pulled_crate)
			to_chat(user, span_warning("The special compartments in the back dont really fit anything other than delivery crates. Use a nomral truck for other cargo."))
			return
		else
			playsound(src,'sound/effects/cargocrate_move.ogg',50,10)
			if(do_after(user, 2 SECONDS, pulled_crate))
				playsound(src,'sound/effects/cargocrate_load.ogg',50,10)
				delivery_trunk.add_to_storage(user,pulled_crate)

/obj/effect/landmark/delivery_truck_beacon
	name = "delivery truck spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	invisibility = 101
	density = 0
	var/spawn_dir = NORTH
	var/delivery_employer_tag = "default"

/obj/effect/landmark/delivery_truck_beacon/proc/spawn_truck(datum/linked_datum)
	if(!linked_datum) return
	var/turf/local_turf = get_turf(src)
	var/obj/vampire_car/delivery_truck/spawned_truck = new(local_turf)
	spawned_truck.dir = spawn_dir
	switch(spawn_dir)
		if(NORTH)
			spawned_truck.movement_vector = 0
		if(SOUTH)
			spawned_truck.movement_vector = 180
		if(EAST)
			spawned_truck.movement_vector = 90
		if(WEST)
			spawned_truck.movement_vector = 270
	spawned_truck.delivery = linked_datum
	spawned_truck.delivery.active_truck = spawned_truck
	spawned_truck.locked = TRUE
	spawned_truck.access = spawned_truck.delivery.delivery_employer_tag
	var/obj/item/vamp/keys/cargo_truck/spawned_keys = new(local_turf)
	spawned_keys.delivery = linked_datum
	spawned_keys.owner = spawned_keys.delivery.original_owner
	spawned_keys.accesslocks = list(spawned_truck.delivery.delivery_employer_tag)
	spawned_truck.delivery.spawned_keys.Add(spawned_keys)
	spawned_truck.delivery.original_owner.put_in_hands(spawned_keys)

/obj/effect/landmark/delivery_truck_beacon/Initialize()
	GLOB.delivery_available_veh_spawners.Add(src)
	. = ..()

/obj/effect/landmark/delivery_truck_beacon/Destroy()
	GLOB.delivery_available_veh_spawners.Remove(src)
	. = ..()

/obj/item/vamp/keys/cargo_truck

	var/datum/delivery_datum/delivery
	var/mob/living/owner

/obj/item/vamp/keys/cargo_truck/Destroy()
	if(delivery)
		delivery.spawned_keys.Remove(src)
		delivery = null
	. = ..()
