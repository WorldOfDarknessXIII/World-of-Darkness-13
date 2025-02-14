//Command

/obj/item/circuitboard/machine/telecomms/broadcaster
	name = "Subspace Broadcaster (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/broadcaster
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/crystal = 1,
		/obj/item/stock_parts/micro_laser = 2)

/obj/item/circuitboard/machine/telecomms/bus
	name = "Bus Mainframe (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/bus
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 1)

/obj/item/circuitboard/machine/telecomms/hub
	name = "Hub Mainframe (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/hub
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/filter = 2)

/obj/item/circuitboard/machine/telecomms/message_server
	name = "Messaging Server (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/message_server
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 3)

/obj/item/circuitboard/machine/telecomms/processor
	name = "Processor Unit (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/processor
	req_components = list(
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/treatment = 2,
		/obj/item/stock_parts/subspace/analyzer = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/amplifier = 1)

/obj/item/circuitboard/machine/telecomms/receiver
	name = "Subspace Receiver (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/receiver
	req_components = list(
		/obj/item/stock_parts/subspace/ansible = 1,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 1)

/obj/item/circuitboard/machine/telecomms/relay
	name = "Relay Mainframe (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/relay
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/filter = 2)

/obj/item/circuitboard/machine/telecomms/server
	name = "Telecommunication Server (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/server
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 1)

/obj/item/circuitboard/machine/cell_charger
	name = "Cell Charger (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/cell_charger
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/circulator
	name = "Circulator/Heat Exchanger (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/atmospherics/components/binary/circulator
	req_components = list()

/obj/item/circuitboard/machine/generator
	name = "Thermo-Electric Generator (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/generator
	req_components = list()

/obj/item/circuitboard/machine/ntnet_relay
	name = "NTNet Relay (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/ntnet_relay
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/filter = 1)

/obj/item/circuitboard/machine/pacman
	name = "PACMAN-type Generator (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/port_gen/pacman
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/pacman/super
	name = "SUPERPACMAN-type Generator (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/port_gen/pacman/super

/obj/item/circuitboard/machine/scanner_gate
	name = "Scanner Gate (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/scanner_gate
	req_components = list(
		/obj/item/stock_parts/scanning_module = 3)

/obj/item/circuitboard/machine/smes
	name = "SMES (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/smes
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/cell = 5,
		/obj/item/stock_parts/capacitor = 1)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high/empty)

/obj/item/circuitboard/machine/paystand
	name = "Pay Stand (Machine Board)"
	icon_state = "generic"
	build_path = /obj/machinery/paystand
	req_components = list()

/obj/item/circuitboard/machine/reagentgrinder
	name = "Machine Design (All-In-One Grinder)"
	icon_state = "generic"
	build_path = /obj/machinery/reagentgrinder/constructed
	req_components = list(
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/smartfridge
	name = "Smartfridge (Machine Board)"
	build_path = /obj/machinery/smartfridge
	req_components = list(/obj/item/stock_parts/matter_bin = 1)
	var/static/list/fridges_name_paths = list(/obj/machinery/smartfridge = "plant produce",
		/obj/machinery/smartfridge/food = "food",
		/obj/machinery/smartfridge/drinks = "drinks",
		/obj/machinery/smartfridge/extract = "slimes",
		/obj/machinery/smartfridge/organ = "organs",
		/obj/machinery/smartfridge/chemistry = "chems",
		/obj/machinery/smartfridge/chemistry/virology = "viruses",
		/obj/machinery/smartfridge/disks = "disks")
	needs_anchored = FALSE
	var/is_special_type = FALSE

/obj/item/circuitboard/machine/smartfridge/apply_default_parts(obj/machinery/smartfridge/M)
	build_path = M.base_build_path
	if(!fridges_name_paths.Find(build_path, fridges_name_paths))
		name = "[initial(M.name)] (Machine Board)" //if it's a unique type, give it a unique name.
		is_special_type = TRUE
	return ..()

/obj/item/circuitboard/machine/smartfridge/attackby(obj/item/I, mob/user, params)
	if(!is_special_type && I.tool_behaviour == TOOL_SCREWDRIVER)
		var/position = fridges_name_paths.Find(build_path, fridges_name_paths)
		position = (position == fridges_name_paths.len) ? 1 : (position + 1)
		build_path = fridges_name_paths[position]
		to_chat(user, "<span class='notice'>You set the board to [fridges_name_paths[build_path]].</span>")
	else
		return ..()

/obj/item/circuitboard/machine/smartfridge/examine(mob/user)
	. = ..()
	if(is_special_type)
		return
	. += "<span class='info'>[src] is set to [fridges_name_paths[build_path]]. You can use a screwdriver to reconfigure it.</span>"


/obj/item/circuitboard/machine/vendor
	name = "Custom Vendor (Machine Board)"
	desc = "You can turn the \"brand selection\" dial using a screwdriver."
	custom_premium_price = PAYCHECK_ASSISTANT * 1.5
	build_path = /obj/machinery/vending/custom
	req_components = list(/obj/item/vending_refill/custom = 1)

	var/static/list/vending_names_paths = list(
		/obj/machinery/vending/boozeomat = "Booze-O-Mat",
		/obj/machinery/vending/coffee = "Solar's Best Hot Drinks",
		/obj/machinery/vending/snack = "Getmore Chocolate Corp",
		/obj/machinery/vending/cola = "Robust Softdrinks",
		/obj/machinery/vending/cigarette = "ShadyCigs Deluxe",
		/obj/machinery/vending/games = "\improper Good Clean Fun",
		/obj/machinery/vending/autodrobe = "AutoDrobe",
		/obj/machinery/vending/wardrobe/sec_wardrobe = "SecDrobe",
		/obj/machinery/vending/wardrobe/det_wardrobe = "DetDrobe",
		/obj/machinery/vending/wardrobe/medi_wardrobe = "MediDrobe",
		/obj/machinery/vending/wardrobe/engi_wardrobe = "EngiDrobe",
		/obj/machinery/vending/wardrobe/atmos_wardrobe = "AtmosDrobe",
		/obj/machinery/vending/wardrobe/cargo_wardrobe = "CargoDrobe",
		/obj/machinery/vending/wardrobe/robo_wardrobe = "RoboDrobe",
		/obj/machinery/vending/wardrobe/science_wardrobe = "SciDrobe",
		/obj/machinery/vending/wardrobe/hydro_wardrobe = "HyDrobe",
		/obj/machinery/vending/wardrobe/curator_wardrobe = "CuraDrobe",
		/obj/machinery/vending/wardrobe/bar_wardrobe = "BarDrobe",
		/obj/machinery/vending/wardrobe/chef_wardrobe = "ChefDrobe",
		/obj/machinery/vending/wardrobe/jani_wardrobe = "JaniDrobe",
		/obj/machinery/vending/wardrobe/law_wardrobe = "LawDrobe",
		/obj/machinery/vending/wardrobe/chap_wardrobe = "ChapDrobe",
		/obj/machinery/vending/wardrobe/chem_wardrobe = "ChemDrobe",
		/obj/machinery/vending/wardrobe/gene_wardrobe = "GeneDrobe",
		/obj/machinery/vending/wardrobe/viro_wardrobe = "ViroDrobe",
		/obj/machinery/vending/clothing = "ClothesMate",
		/obj/machinery/vending/medical = "NanoMed Plus",
		/obj/machinery/vending/drugs = "NanoDrug Plus",
		/obj/machinery/vending/wallmed = "NanoMed",
		/obj/machinery/vending/assist  = "Vendomat",
		/obj/machinery/vending/engivend = "Engi-Vend",
		/obj/machinery/vending/hydronutrients = "NutriMax",
		/obj/machinery/vending/hydroseeds = "MegaSeed Servitor",
		/obj/machinery/vending/sustenance = "Sustenance Vendor",
		/obj/machinery/vending/dinnerware = "Plasteel Chef's Dinnerware Vendor",
		/obj/machinery/vending/cart = "PTech",
		/obj/machinery/vending/robotics = "Robotech Deluxe",
		/obj/machinery/vending/engineering = "Robco Tool Maker",
		/obj/machinery/vending/sovietsoda = "BODA",
		/obj/machinery/vending/security = "SecTech",
		/obj/machinery/vending/modularpc = "Deluxe Silicate Selections",
		/obj/machinery/vending/custom = "Custom Vendor")

/obj/item/circuitboard/machine/vendor/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		var/static/list/display_vending_names_paths
		if(!display_vending_names_paths)
			display_vending_names_paths = list()
			for(var/path in vending_names_paths)
				display_vending_names_paths[vending_names_paths[path]] = path
		var/choice =  input(user,"Choose a new brand","Select an Item") as null|anything in sortList(display_vending_names_paths)
		set_type(display_vending_names_paths[choice])
	else
		return ..()

/obj/item/circuitboard/machine/vendor/proc/set_type(obj/machinery/vending/typepath)
	build_path = typepath
	name = "[vending_names_paths[build_path]] Vendor (Machine Board)"
	req_components = list(initial(typepath.refill_canister) = 1)

/obj/item/circuitboard/machine/vendor/apply_default_parts(obj/machinery/M)
	for(var/typepath in vending_names_paths)
		if(istype(M, typepath))
			set_type(typepath)
			break
	return ..()

/obj/item/circuitboard/machine/vending/donksofttoyvendor
	name = "Donksoft Toy Vendor (Machine Board)"
	build_path = /obj/machinery/vending/donksofttoyvendor
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/vending_refill/donksoft = 1)

/obj/item/circuitboard/machine/vending/syndicatedonksofttoyvendor
	name = "Syndicate Donksoft Toy Vendor (Machine Board)"
	build_path = /obj/machinery/vending/toyliberationstation
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/vending_refill/donksoft = 1)

/obj/item/circuitboard/machine/accounting
	name = "Account Registration Device (Machine Board)"
	icon_state = "command"
	build_path = /obj/machinery/accounting
	req_components = list(
		/obj/item/stock_parts/card_reader = 1,
		/obj/item/stock_parts/scanning_module = 1
	)

//Medical

/obj/item/circuitboard/machine/medical_kiosk
	name = "Medical Kiosk (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/medical_kiosk
	var/custom_cost = 10
	req_components = list(
		/obj/item/healthanalyzer = 1,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/circuitboard/machine/medical_kiosk/multitool_act(mob/living/user)
	. = ..()
	var/new_cost = input("Set a new cost for using this medical kiosk.","New cost", custom_cost) as num|null
	if(!new_cost || (loc != user))
		to_chat(user, "<span class='warning'>You must hold the circuitboard to change its cost!</span>")
		return
	custom_cost = clamp(round(new_cost, 1), 10, 1000)
	to_chat(user, "<span class='notice'>The cost is now set to [custom_cost].</span>")

/obj/item/circuitboard/machine/medical_kiosk/examine(mob/user)
	. = ..()
	. += "The cost to use this kiosk is set to [custom_cost]."

/obj/item/circuitboard/machine/smoke_machine
	name = "Smoke Machine (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/smoke_machine
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/medipen_refiller
	name = "Medipen Refiller (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/medipen_refiller
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1)

/obj/item/circuitboard/machine/recharger
	name = "Weapon Recharger (Machine Board)"
	icon_state = "security"
	build_path = /obj/machinery/recharger
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/deep_fryer
	name = "circuit board (Deep Fryer)"
	icon_state = "service"
	build_path = /obj/machinery/deepfryer
	req_components = list(/obj/item/stock_parts/micro_laser = 1)
	needs_anchored = FALSE
/obj/item/circuitboard/machine/griddle
	name = "circuit board (Griddle)"
	icon_state = "service"
	build_path = /obj/machinery/griddle
	req_components = list(/obj/item/stock_parts/micro_laser = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/dish_drive
	name = "Dish Drive (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/dish_drive
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/matter_bin = 2)
	var/suction = TRUE
	var/transmit = TRUE
	needs_anchored = FALSE

/obj/item/circuitboard/machine/dish_drive/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Its suction function is [suction ? "enabled" : "disabled"]. Use it in-hand to switch.</span>"
	. += "<span class='notice'>Its disposal auto-transmit function is [transmit ? "enabled" : "disabled"]. Alt-click it to switch.</span>"

/obj/item/circuitboard/machine/dish_drive/attack_self(mob/living/user)
	suction = !suction
	to_chat(user, "<span class='notice'>You [suction ? "enable" : "disable"] the board's suction function.</span>")

/obj/item/circuitboard/machine/dish_drive/AltClick(mob/living/user)
	if(!user.Adjacent(src))
		return
	transmit = !transmit
	to_chat(user, "<span class='notice'>You [transmit ? "enable" : "disable"] the board's automatic disposal transmission.</span>")

/obj/item/circuitboard/machine/gibber
	name = "Gibber (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/gibber
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/microwave
	name = "Microwave (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/microwave
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stack/sheet/glass = 2)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/processor
	name = "Food Processor (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/processor
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/processor/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(build_path == /obj/machinery/processor)
			name = "Slime Processor (Machine Board)"
			build_path = /obj/machinery/processor/slime
			to_chat(user, "<span class='notice'>Name protocols successfully updated.</span>")
		else
			name = "Food Processor (Machine Board)"
			build_path = /obj/machinery/processor
			to_chat(user, "<span class='notice'>Defaulting name protocols.</span>")
	else
		return ..()

/obj/item/circuitboard/machine/protolathe/department/service
	name = "Departmental Protolathe - Service (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/rnd/production/protolathe/department/service

/obj/item/circuitboard/machine/recycler
	name = "Recycler (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/recycler
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/vendatray
	name = "Vend-A-Tray (Machine Board)"
	icon_state = "service"
	build_path = /obj/structure/displaycase/forsale
	req_components = list(
		/obj/item/stock_parts/card_reader = 1)

//Supply

/obj/item/circuitboard/machine/mining_equipment_vendor
	name = "Mining Equipment Vendor (Machine Board)"
	icon_state = "supply"
	build_path = /obj/machinery/mineral/equipment_vendor
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/matter_bin = 3)

/obj/item/circuitboard/machine/mining_equipment_vendor/golem
	name = "Golem Ship Equipment Vendor (Machine Board)"
	build_path = /obj/machinery/mineral/equipment_vendor/golem


	name = "Skill Station (Machine Board)"
	build_path = /obj/machinery/skill_station
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/scanning_module = 2
	)

