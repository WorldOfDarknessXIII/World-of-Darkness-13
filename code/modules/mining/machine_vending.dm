/**********************Mining Equipment Vendor**************************/

/obj/machinery/mineral/equipment_vendor
	name = "mining equipment vendor"
	desc = "An equipment vendor for miners, points collected at an ore redemption machine can be spent here."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "mining"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/mining_equipment_vendor
	var/icon_deny = "mining-deny"
	var/mob/living/carbon/human/npc/my_owner
	var/owner_needed = TRUE
	var/obj/item/card/id/inserted_id
	var/points = 0
	var/list/prize_list = list( //if you add something to this, please, for the love of god, sort it by price/type. use tabs and not spaces.
		new /datum/data/mining_equipment("1 Marker Beacon",				/obj/item/stack/marker_beacon,										10),
		new /datum/data/mining_equipment("10 Marker Beacons",			/obj/item/stack/marker_beacon/ten,									100),
		new /datum/data/mining_equipment("30 Marker Beacons",			/obj/item/stack/marker_beacon/thirty,								300),
		new /datum/data/mining_equipment("Skeleton Key",				/obj/item/skeleton_key,												777),
		new /datum/data/mining_equipment("Whiskey",						/obj/item/reagent_containers/food/drinks/bottle/whiskey,			100),
		new /datum/data/mining_equipment("Absinthe",					/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium,	100),
		new /datum/data/mining_equipment("Bubblegum Gum Packet",		/obj/item/storage/box/gum/bubblegum,								100),
		new /datum/data/mining_equipment("Cigar",						/obj/item/clothing/mask/cigarette/cigar/havana,						150),
		new /datum/data/mining_equipment("Soap",						/obj/item/soap/nanotrasen,											200),
		new /datum/data/mining_equipment("Laser Pointer",				/obj/item/laser_pointer,											300),
		new /datum/data/mining_equipment("Alien Toy",					/obj/item/clothing/mask/facehugger/toy,								300),
		new /datum/data/mining_equipment("Stabilizing Serum",			/obj/item/hivelordstabilizer,										400),
		new /datum/data/mining_equipment("Fulton Beacon",				/obj/item/fulton_core,												400),
		new /datum/data/mining_equipment("Shelter Capsule",				/obj/item/survivalcapsule,											400),
		new /datum/data/mining_equipment("GAR Meson Scanners",			/obj/item/clothing/glasses/meson/gar,								500),
		new /datum/data/mining_equipment("Explorer's Webbing",			/obj/item/storage/belt/mining,										500),
		new /datum/data/mining_equipment("Point Transfer Card",			/obj/item/card/mining_point_card,									500),
		new /datum/data/mining_equipment("Survival Medipen",			/obj/item/reagent_containers/hypospray/medipen/survival,			500),
		new /datum/data/mining_equipment("Brute First-Aid Kit",			/obj/item/storage/firstaid/brute,									600),
		new /datum/data/mining_equipment("Tracking Implant Kit", 		/obj/item/storage/box/minertracker,									600),
		new /datum/data/mining_equipment("Jaunter",						/obj/item/wormhole_jaunter,											750),
		new /datum/data/mining_equipment("Kinetic Crusher",				/obj/item/kinetic_crusher,											750),
		new /datum/data/mining_equipment("Kinetic Accelerator",			/obj/item/gun/energy/kinetic_accelerator,							750),
		new /datum/data/mining_equipment("Advanced Scanner",			/obj/item/t_scanner/adv_mining_scanner,								800),
		new /datum/data/mining_equipment("Resonator",					/obj/item/resonator,												800),
		new /datum/data/mining_equipment("Luxury Medipen",				/obj/item/reagent_containers/hypospray/medipen/survival/luxury,		1000),
		new /datum/data/mining_equipment("Fulton Pack",					/obj/item/extraction_pack,											1000),
		new /datum/data/mining_equipment("Lazarus Injector",			/obj/item/lazarus_injector,											1000),
		new /datum/data/mining_equipment("Silver Pickaxe",				/obj/item/pickaxe/silver,											1000),
		new /datum/data/mining_equipment("Mining Conscription Kit",		/obj/item/storage/backpack/duffelbag/mining_conscript,				1500),
		new /datum/data/mining_equipment("Jetpack Upgrade",				/obj/item/tank/jetpack/suit,										2000),
		new /datum/data/mining_equipment("Space Cash",					/obj/item/stack/spacecash/c1000,									2000),
		new /datum/data/mining_equipment("Mining Hardsuit",				/obj/item/clothing/suit/space/hardsuit/mining,						2000),
		new /datum/data/mining_equipment("Diamond Pickaxe",				/obj/item/pickaxe/diamond,											2000),
		new /datum/data/mining_equipment("Super Resonator",				/obj/item/resonator/upgraded,										2500),
		new /datum/data/mining_equipment("Jump Boots",					/obj/item/clothing/shoes/bhop,										2500),
		new /datum/data/mining_equipment("Luxury Shelter Capsule",		/obj/item/survivalcapsule/luxury,									3000),
		new /datum/data/mining_equipment("Luxury Bar Capsule",			/obj/item/survivalcapsule/luxuryelite,								10000),
		new /datum/data/mining_equipment("Nanotrasen Minebot",			/mob/living/simple_animal/hostile/mining_drone,						800),
		new /datum/data/mining_equipment("Minebot Melee Upgrade",		/obj/item/mine_bot_upgrade,											400),
		new /datum/data/mining_equipment("Minebot Armor Upgrade",		/obj/item/mine_bot_upgrade/health,									400),
		new /datum/data/mining_equipment("Minebot Cooldown Upgrade",	/obj/item/borg/upgrade/modkit/cooldown/minebot,						600),
		new /datum/data/mining_equipment("Minebot AI Upgrade",			/obj/item/slimepotion/slime/sentience/mining,						1000),
		new /datum/data/mining_equipment("KA Minebot Passthrough",		/obj/item/borg/upgrade/modkit/minebot_passthrough,					100),
		new /datum/data/mining_equipment("KA White Tracer Rounds",		/obj/item/borg/upgrade/modkit/tracer,								100),
		new /datum/data/mining_equipment("KA Adjustable Tracer Rounds",	/obj/item/borg/upgrade/modkit/tracer/adjustable,					150),
		new /datum/data/mining_equipment("KA Super Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod,							250),
		new /datum/data/mining_equipment("KA Hyper Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod/orange,					300),
		new /datum/data/mining_equipment("KA Range Increase",			/obj/item/borg/upgrade/modkit/range,								1000),
		new /datum/data/mining_equipment("KA Damage Increase",			/obj/item/borg/upgrade/modkit/damage,								1000),
		new /datum/data/mining_equipment("KA Cooldown Decrease",		/obj/item/borg/upgrade/modkit/cooldown,								1000),
		new /datum/data/mining_equipment("KA AoE Damage",				/obj/item/borg/upgrade/modkit/aoe/mobs,								2000)
	)

/datum/data/mining_equipment
	var/equipment_name = "generic"
	var/equipment_path = null
	var/cost = 0

/datum/data/mining_equipment/New(name, path, cost)
	src.equipment_name = name
	src.equipment_path = path
	src.cost = cost

/obj/machinery/mineral/equipment_vendor/Initialize()
	. = ..()
	if(owner_needed == TRUE)
		for(var/mob/living/carbon/human/npc/NPC in range(2, src))
			if(NPC)	//PSEUDO_M come back to fix this
				my_owner = NPC
	build_inventory()

/obj/machinery/mineral/equipment_vendor/proc/build_inventory()
	for(var/p in prize_list)
		var/datum/data/mining_equipment/M = p
		GLOB.vending_products[M.equipment_path] = 1

/obj/machinery/mineral/equipment_vendor/update_icon_state()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

/obj/machinery/mineral/equipment_vendor/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/vending),
	)

/obj/machinery/mineral/equipment_vendor/ui_interact(mob/user, datum/tgui/ui)
	if(owner_needed == TRUE)
		if(!my_owner)
			return
		if(get_dist(src, my_owner) > 4)
			return
		if(my_owner.stat >= HARD_CRIT)
			return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MiningVendor", name)
		ui.open()

/obj/machinery/mineral/equipment_vendor/ui_static_data(mob/user)
	. = list()
	.["product_records"] = list()
	for(var/datum/data/mining_equipment/prize in prize_list)
		var/list/product_data = list(
			path = replacetext(replacetext("[prize.equipment_path]", "/obj/item/", ""), "/", "-"),
			name = prize.equipment_name,
			price = prize.cost,
			ref = REF(prize)
		)
		.["product_records"] += list(product_data)

/obj/machinery/mineral/equipment_vendor/ui_data(mob/user)
	. = list()
	.["user"] = list()
	.["user"]["points"] = points
	.["user"]["name"] = "[user.name]"
	.["user"]["job"] = "[user.mind.assigned_role]"


/obj/machinery/mineral/equipment_vendor/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(owner_needed == TRUE)
		if(!my_owner)
			return
		if(get_dist(src, my_owner) > 4)
			return
		if(my_owner.stat >= HARD_CRIT)
			return

	switch(action)
		if("purchase")
//			var/obj/item/card/id/I
//			if(isliving(usr))
//				var/mob/living/L = usr
//				I = L.get_idcard(TRUE)
//			if(!istype(I))
//				to_chat(usr, "<span class='alert'>Error: An ID is required!</span>")
//				flick(icon_deny, src)
//				return
			var/datum/data/mining_equipment/prize = locate(params["ref"]) in prize_list
			if(!prize || !(prize in prize_list))
				to_chat(usr, "<span class='alert'>Error: Invalid choice!</span>")
				flick(icon_deny, src)
				return
			if(prize.cost > points)
				to_chat(usr, "<span class='alert'>Error: Insufficient points for [prize.equipment_name]!</span>")
				flick(icon_deny, src)
				return
			points -= prize.cost
			to_chat(usr, "<span class='notice'>[src] clanks to life briefly before vending [prize.equipment_name]!</span>")
			new prize.equipment_path(loc)
			SSblackbox.record_feedback("nested tally", "mining_equipment_bought", 1, list("[type]", "[prize.equipment_path]"))
			. = TRUE

/obj/machinery/mineral/equipment_vendor/fastfood/attackby(obj/item/I, mob/user, params)
	if(owner_needed == TRUE)
		if(!my_owner)
			return
		if(get_dist(src, my_owner) > 4)
			return	//PSEUDO_M come back and fix this shit...
		if(my_owner.stat >= HARD_CRIT)
			return
	if(istype(I, /obj/item/mining_voucher))
		RedeemVoucher(I, user)
		return
	if(istype(I, /obj/item/stack/dollar))
		var/obj/item/stack/dollar/D = I
		points = points+D.amount
		qdel(D)
		return
	if(default_deconstruction_screwdriver(user, "mining-open", "mining", I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/mineral/equipment_vendor/restricted
	name = "Requisitions"
	desc = "A requisitions form waiting for any of the employees here to fill out for frivolous and mismanaged goodies."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "menu"
	icon_deny = "menu"
	prize_list = list()
	//we only define this here for a possible case down the line of the requisition becoming unrestricted for whatever reason
	var/restricted = TRUE
	// Assoc list of people who made requisitions (a weakref, specifically, and an amount of points)
	var/list/requisitioners = list()
	// Assoc list of how many points a given job gets, being boss has its perks
	var/list/jobs_allowed = list()
	var/rejection_message = "The quartermaster doesn't seem to know you or want to speak with you."
	owner_needed = FALSE

/obj/machinery/mineral/equipment_vendor/restricted/interact(mob/user, special_state)
	if(isnull(user.mind))
		return
	var/user_job = user.mind.assigned_role
	if(restricted && !jobs_allowed.Find(user_job) && !isAdminObserver(user))
		to_chat(user, rejection_message)
		return
	if(!requisitioners.Find(user))
		var/initial_points
		initial_points = jobs_allowed.Find(user_job) ? jobs_allowed[user_job] : 100
		requisitioners[user] = isAdminObserver(user) ? 99999 : initial_points
	points = requisitioners[user]	//PSEUDO_M come back and redo this, too, but we have other dev priorities atm...
	return ..()

/obj/machinery/mineral/equipment_vendor/restricted/ui_data(mob/user)
	. = ..()
	requisitioners[user] = points	// make sure they actually spend their req points...

/obj/machinery/mineral/equipment_vendor/restricted/hospital
	jobs_allowed = list(
		"Doctor" = 150,
		"Clinic Director" = 750,
	)
	prize_list = list(
		new /datum/data/mining_equipment("iron pill bottle", /obj/item/storage/pill_bottle/iron, 5),
		new /datum/data/mining_equipment("surgical apron", /obj/item/clothing/suit/apron/surgical, 5),
		new /datum/data/mining_equipment("latex gloves", /obj/item/clothing/gloves/vampire/latex, 5),
		new /datum/data/mining_equipment("burn ointment", /obj/item/stack/medical/ointment, 5),
		new /datum/data/mining_equipment("saline solution", /obj/item/reagent_containers/glass/bottle/salglu_solution, 5),
		new /datum/data/mining_equipment("respiratory aid kit", /obj/item/storage/firstaid/o2, 10),
		new /datum/data/mining_equipment("defib batteries", /obj/item/stock_parts/cell, 10),
		new /datum/data/mining_equipment("ephedrine pill bottle", /obj/item/storage/pill_bottle/ephedrine, 10),
		new /datum/data/mining_equipment("Medicated Suture", /obj/item/stack/medical/suture/medicated, 10),
		new /datum/data/mining_equipment("Regenerative Mesh", /obj/item/stack/medical/mesh/advanced, 10),
		new /datum/data/mining_equipment("toxins first aid kit", /obj/item/storage/firstaid/toxin, 15),
		new /datum/data/mining_equipment("burns first aid kit", /obj/item/storage/firstaid/fire, 15),
		new /datum/data/mining_equipment("standard first aid kit", /obj/item/storage/firstaid/medical, 15),
		new /datum/data/mining_equipment("bruise pack", /obj/item/stack/medical/bruise_pack, 20),
		new /datum/data/mining_equipment("Compact Defibillator", /obj/item/defibrillator/compact, 25),
		new /datum/data/mining_equipment("surgery dufflebag", /obj/item/storage/backpack/duffelbag/med/surgery, 50),
		new /datum/data/mining_equipment("Hospital Radio", /obj/item/p25radio, 50)
	)

/obj/machinery/mineral/equipment_vendor/restricted/police
	jobs_allowed = list(
		"Police Officer" = 200,
		"Federal Investigator" = 400,
		"Police Sergeant" = 500,
		"Police Chief" = 15000,	// don't you love the militirization of the police?
	)
	prize_list = list(
		new /datum/data/mining_equipment("handcuffs", /obj/item/restraints/handcuffs, 1),
		new /datum/data/mining_equipment("police uniform", /obj/item/clothing/under/vampire/police, 1),
		new /datum/data/mining_equipment("police hat", /obj/item/clothing/head/vampire/police, 1),
		new /datum/data/mining_equipment("camera", /obj/item/camera, 1),
		new /datum/data/mining_equipment("tape recorder", /obj/item/taperecorder, 1),
		new /datum/data/mining_equipment("white crayon", /obj/item/toy/crayon/white, 1),
		new /datum/data/mining_equipment("evidence box", /obj/item/storage/box/evidence, 1),
		new /datum/data/mining_equipment("crime scene tape", /obj/item/barrier_tape/police, 1),
		new /datum/data/mining_equipment("flashlight", /obj/item/flashlight, 1),
		new /datum/data/mining_equipment("magnifier", /obj/item/detective_scanner, 2),
		new /datum/data/mining_equipment("body bags", /obj/item/storage/box/bodybags, 5),
		new /datum/data/mining_equipment("police vest", /obj/item/clothing/suit/vampire/vest/police, 5),
		new /datum/data/mining_equipment("Colt M1911 magazine",		/obj/item/ammo_box/magazine/vamp45acp,	10),
		new /datum/data/mining_equipment("AUG Magazines",			/obj/item/ammo_box/magazine/vampaug,	10),
		new /datum/data/mining_equipment("AR-15 Magazines",			/obj/item/ammo_box/magazine/vamp556,	10),
		new /datum/data/mining_equipment("desert eagle magazine",	/obj/item/ammo_box/magazine/m44,	10),
		new /datum/data/mining_equipment("Glock19 magazine",		/obj/item/ammo_box/magazine/glock9mm,	10),
		new /datum/data/mining_equipment("IFAK",					/obj/item/storage/firstaid,	15),
		new /datum/data/mining_equipment("12ga buckshot",			/obj/item/ammo_box/vampire/c12g/buck,	15),
		new /datum/data/mining_equipment("mp5 magazine",			/obj/item/ammo_box/magazine/vamp9mp5, 20),
		new /datum/data/mining_equipment("Glock19",					/obj/item/gun/ballistic/automatic/vampire/glock19,	25),
		new /datum/data/mining_equipment("Colt M1911",				/obj/item/gun/ballistic/automatic/vampire/m1911,	25),
		new /datum/data/mining_equipment("SPAS15 magazine",			/obj/item/ammo_box/magazine/vampautoshot,	30),
		new /datum/data/mining_equipment("12ga slug",				/obj/item/ammo_box/vampire/c12g,	35),
		new /datum/data/mining_equipment("PD Radio", 				/obj/item/p25radio/police, 50),
		new /datum/data/mining_equipment("shotgun",					/obj/item/gun/ballistic/shotgun/vampire, 50),
		new /datum/data/mining_equipment("submachine gun",			/obj/item/gun/ballistic/automatic/vampire/mp5, 100),
		new /datum/data/mining_equipment("assault rifle",			/obj/item/gun/ballistic/automatic/vampire/ar15, 125),
		new /datum/data/mining_equipment("SPAS15",					/obj/item/gun/ballistic/automatic/vampire/autoshotgun, 200),
		new /datum/data/mining_equipment("sniper rifle",			/obj/item/gun/ballistic/automatic/vampire/sniper, 300),
	)	//PSEUDO_M todo: add .50 ammo to this list

/obj/machinery/mineral/equipment_vendor/proc/RedeemVoucher(obj/item/mining_voucher/voucher, mob/redeemer)
	var/items = list("Survival Capsule and Explorer's Webbing", "Resonator Kit", "Minebot Kit", "Extraction and Rescue Kit", "Crusher Kit", "Mining Conscription Kit")

	var/selection = input(redeemer, "Pick your equipment", "Mining Voucher Redemption") as null|anything in sortList(items)
	if(!selection || !Adjacent(redeemer) || QDELETED(voucher) || voucher.loc != redeemer)
		return
	var/drop_location = drop_location()
	switch(selection)
		if("Survival Capsule and Explorer's Webbing")
			new /obj/item/storage/belt/mining/vendor(drop_location)
		if("Resonator Kit")
			new /obj/item/extinguisher/mini(drop_location)
			new /obj/item/resonator(drop_location)
		if("Minebot Kit")
			new /mob/living/simple_animal/hostile/mining_drone(drop_location)
			new /obj/item/weldingtool/hugetank(drop_location)
			new /obj/item/clothing/head/welding(drop_location)
			new /obj/item/borg/upgrade/modkit/minebot_passthrough(drop_location)
		if("Extraction and Rescue Kit")
			new /obj/item/extraction_pack(drop_location)
			new /obj/item/fulton_core(drop_location)
			new /obj/item/stack/marker_beacon/thirty(drop_location)
		if("Crusher Kit")
			new /obj/item/extinguisher/mini(drop_location)
			new /obj/item/kinetic_crusher(drop_location)
		if("Mining Conscription Kit")
			new /obj/item/storage/backpack/duffelbag/mining_conscript(drop_location)

	SSblackbox.record_feedback("tally", "mining_voucher_redeemed", 1, selection)
	qdel(voucher)

/obj/machinery/mineral/equipment_vendor/ex_act(severity, target)
	do_sparks(5, TRUE, src)
	if(prob(50 / severity) && severity < 3)
		qdel(src)

/****************Golem Point Vendor**************************/

/obj/machinery/mineral/equipment_vendor/golem
	name = "golem ship equipment vendor"
	circuit = /obj/item/circuitboard/machine/mining_equipment_vendor/golem

/obj/machinery/mineral/equipment_vendor/golem/Initialize()
	desc += "\nIt seems a few selections have been added."
	prize_list += list(
		new /datum/data/mining_equipment("Extra Id",       				/obj/item/card/id/mining, 				                   		250),
		new /datum/data/mining_equipment("Science Goggles",       		/obj/item/clothing/glasses/science,								250),
		new /datum/data/mining_equipment("Monkey Cube",					/obj/item/food/monkeycube,        	300),
		new /datum/data/mining_equipment("Toolbelt",					/obj/item/storage/belt/utility,	    							350),
		new /datum/data/mining_equipment("Royal Cape of the Liberator", /obj/item/bedsheet/rd/royal_cape, 								500),
		new /datum/data/mining_equipment("Grey Slime Extract",			/obj/item/slime_extract/grey,									1000),
		new /datum/data/mining_equipment("Modification Kit",    		/obj/item/borg/upgrade/modkit/trigger_guard,					1700),
		new /datum/data/mining_equipment("The Liberator's Legacy",  	/obj/item/storage/box/rndboards,								2000)
		)
	return ..()

/**********************Mining Equipment Vendor Items**************************/

/**********************Mining Equipment Voucher**********************/

/obj/item/mining_voucher
	name = "mining voucher"
	desc = "A token to redeem a piece of equipment. Use it on a mining equipment vendor."
	icon = 'icons/obj/mining.dmi'
	icon_state = "mining_voucher"
	w_class = WEIGHT_CLASS_TINY

/**********************Mining Point Card**********************/

/obj/item/card/mining_point_card
	name = "mining points card"
	desc = "A small card preloaded with mining points. Swipe your ID card over it to transfer the points, then discard."
	icon_state = "data_1"
	var/points = 500

/obj/item/card/mining_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		if(points)
			var/obj/item/card/id/C = I
			C.mining_points += points
			to_chat(user, "<span class='info'>You transfer [points] points to [C].</span>")
			points = 0
		else
			to_chat(user, "<span class='alert'>There's no points left on [src].</span>")
	..()

/obj/item/card/mining_point_card/examine(mob/user)
	..()
	to_chat(user, "<span class='alert'>There's [points] point\s on the card.</span>")

///Conscript kit
/obj/item/card/mining_access_card
	name = "mining access card"
	desc = "A small card, that when used on any ID, will add mining access."
	icon_state = "data_1"

/obj/item/card/mining_access_card/afterattack(atom/movable/AM, mob/user, proximity)
	. = ..()
	if(istype(AM, /obj/item/card/id) && proximity)
		var/obj/item/card/id/I = AM
		I.access |=	ACCESS_MINING
		I.access |= ACCESS_MINING_STATION
		I.access |= ACCESS_MECH_MINING
		I.access |= ACCESS_MINERAL_STOREROOM
		I.access |= ACCESS_CARGO
		to_chat(user, "<span class='notice'>You upgrade [I] with mining access.</span>")
		qdel(src)

/obj/item/storage/backpack/duffelbag/mining_conscript
	name = "mining conscription kit"
	desc = "A kit containing everything a crewmember needs to support a shaft miner in the field."
	icon_state = "duffel-explorer"
	inhand_icon_state = "duffel-explorer"

/obj/item/storage/backpack/duffelbag/mining_conscript/PopulateContents()
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/t_scanner/adv_mining_scanner/lesser(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/clothing/suit/hooded/explorer(src)
	new /obj/item/encryptionkey/headset_mining(src)
	new /obj/item/clothing/mask/gas/explorer(src)
	new /obj/item/card/mining_access_card(src)
	new /obj/item/gun/energy/kinetic_accelerator(src)
	new /obj/item/kitchen/knife/combat/survival(src)
	new /obj/item/flashlight/seclite(src)
