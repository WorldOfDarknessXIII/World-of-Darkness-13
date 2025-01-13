//This is the lowest supported version, anything below this is completely obsolete and the entire savefile will be wiped.
#define SAVEFILE_VERSION_MIN	32

//This is the current version, anything below this will attempt to update (if it's not obsolete)
//	You do not need to raise this if you are adding new values that have sane defaults.
//	Only raise this value when changing the meaning/format/name/layout of an existing value
//	where you would want the updater procs below to run
#define SAVEFILE_VERSION_MAX	38

/*
SAVEFILE UPDATING/VERSIONING - 'Simplified', or rather, more coder-friendly ~Carn
	This proc checks if the current directory of the savefile S needs updating
	It is to be used by the load_character and load_preferences procs.
	(S.cd=="/" is preferences, S.cd=="/character[integer]" is a character slot, etc)

	if the current directory's version is below SAVEFILE_VERSION_MIN it will simply wipe everything in that directory
	(if we're at root "/" then it'll just wipe the entire savefile, for instance.)

	if its version is below SAVEFILE_VERSION_MAX but above the minimum, it will load data but later call the
	respective update_preferences() or update_character() proc.
	Those procs allow coders to specify format changes so users do not lose their setups and have to redo them again.

	Failing all that, the standard sanity checks are performed. They simply check the data is suitable, reverting to
	initial() values if necessary.
*/
/datum/preferences/proc/savefile_needs_update(savefile/S)
	var/savefile_version
	READ_FILE(S["version"], savefile_version)

	if(savefile_version < SAVEFILE_VERSION_MIN)
		S.dir.Cut()
		return -2
	if(savefile_version < SAVEFILE_VERSION_MAX)
		return savefile_version
	return -1

//should these procs get fairly long
//just increase SAVEFILE_VERSION_MIN so it's not as far behind
//SAVEFILE_VERSION_MAX and then delete any obsolete if clauses
//from these procs.
//This only really meant to avoid annoying frequent players
//if your savefile is 3 months out of date, then 'tough shit'.

/datum/preferences/proc/update_preferences(current_version, savefile/S)
	if(current_version < 33)
		toggles |= SOUND_ENDOFROUND

	if(current_version < 34)
		auto_fit_viewport = TRUE

	if(current_version < 35) //makes old keybinds compatible with #52040, sets the new default
		var/newkey = FALSE
		for(var/list/key in key_bindings)
			for(var/bind in key)
				if(bind == "quick_equipbelt")
					key -= "quick_equipbelt"
					key |= "quick_equip_belt"

				if(bind == "bag_equip")
					key -= "bag_equip"
					key |= "quick_equip_bag"

				if(bind == "quick_equip_suit_storage")
					newkey = TRUE
		if(!newkey && !key_bindings["ShiftQ"])
			key_bindings["ShiftQ"] = list("quick_equip_suit_storage")

	if(current_version < 36)
		if(key_bindings["ShiftQ"] == "quick_equip_suit_storage")
			key_bindings["ShiftQ"] = list("quick_equip_suit_storage")

	if(current_version < 37)
		if(clientfps == 0)
			clientfps = -1

	if (current_version < 38)
		var/found_block_movement = FALSE

		for (var/list/key in key_bindings)
			for (var/bind in key)
				if (bind == "block_movement")
					found_block_movement = TRUE
					break
			if (found_block_movement)
				break

		if (!found_block_movement)
			LAZYADD(key_bindings["Ctrl"], "block_movement")

/datum/preferences/proc/update_character(current_version, savefile/S)
	return

/// checks through keybindings for outdated unbound keys and updates them
/datum/preferences/proc/check_keybindings()
	if(!parent)
		return
	var/list/user_binds = list()
	for (var/key in key_bindings)
		for(var/kb_name in key_bindings[key])
			user_binds[kb_name] += list(key)
	var/list/notadded = list()
	for (var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		if(length(user_binds[kb.name]))
			continue // key is unbound and or bound to something
		var/addedbind = FALSE
		if(hotkeys)
			for(var/hotkeytobind in kb.classic_keys)
				if(!length(key_bindings[hotkeytobind]))
					LAZYADD(key_bindings[hotkeytobind], kb.name)
					addedbind = TRUE
		else
			for(var/classickeytobind in kb.classic_keys)
				if(!length(key_bindings[classickeytobind]))
					LAZYADD(key_bindings[classickeytobind], kb.name)
					addedbind = TRUE
		if(!addedbind)
			notadded += kb
	if(length(notadded))
		addtimer(CALLBACK(src, PROC_REF(announce_conflict), notadded), 5 SECONDS)

/datum/preferences/proc/announce_conflict(list/notadded)
	to_chat(parent, "<span class='userdanger'>KEYBINDING CONFLICT!!!\n\
	There are new keybindings that have defaults bound to keys you already set, They will default to Unbound. You can bind them in Setup Character or Game Preferences\n\
	<a href='?_src_=prefs;preference=tab;tab=3'>Or you can click here to go straight to the keybindings page</a></span>")
	for(var/item in notadded)
		var/datum/keybinding/conflicted = item
		to_chat(parent, "<span class='userdanger'>[conflicted.category]: [conflicted.full_name] needs updating")
		LAZYADD(key_bindings["Unbound"], conflicted.name) // set it to unbound to prevent this from opening up again in the future



/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)
		return
	path = "data/player_saves/[ckey[1]]/[ckey]/[filename]"

/datum/preferences/proc/load_preferences()
	if(!path)
		return FALSE
	if(!fexists(path))
		return FALSE

	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"

	var/needs_update = savefile_needs_update(S)
	if(needs_update == -2)		//fatal, can't load any data
		var/bacpath = "[path].updatebac" //todo: if the savefile version is higher then the server, check the backup, and give the player a prompt to load the backup
		if (fexists(bacpath))
			fdel(bacpath) //only keep 1 version of backup
		fcopy(S, bacpath) //byond helpfully lets you use a savefile for the first arg.
		return FALSE

	//general preferences
	READ_FILE(S["asaycolor"], asaycolor)
	READ_FILE(S["ooccolor"], ooccolor)
	READ_FILE(S["lastchangelog"], lastchangelog)
	READ_FILE(S["UI_style"], UI_style)
	READ_FILE(S["hotkeys"], hotkeys)
	READ_FILE(S["chat_on_map"], chat_on_map)
	READ_FILE(S["max_chat_length"], max_chat_length)
	READ_FILE(S["see_chat_non_mob"] , see_chat_non_mob)
	READ_FILE(S["see_rc_emotes"] , see_rc_emotes)
	READ_FILE(S["broadcast_login_logout"] , broadcast_login_logout)

	READ_FILE(S["tgui_fancy"], tgui_fancy)
	READ_FILE(S["tgui_lock"], tgui_lock)
	READ_FILE(S["buttons_locked"], buttons_locked)
	READ_FILE(S["windowflash"], windowflashing)
	READ_FILE(S["be_special"] , be_special)


	READ_FILE(S["default_slot"], default_slot)
	READ_FILE(S["chat_toggles"], chat_toggles)
	READ_FILE(S["toggles"], toggles)
	READ_FILE(S["ghost_form"], ghost_form)
	READ_FILE(S["ghost_orbit"], ghost_orbit)
	READ_FILE(S["ghost_accs"], ghost_accs)
	READ_FILE(S["ghost_others"], ghost_others)
	READ_FILE(S["preferred_map"], preferred_map)
	READ_FILE(S["ignoring"], ignoring)
	READ_FILE(S["ghost_hud"], ghost_hud)
	READ_FILE(S["inquisitive_ghost"], inquisitive_ghost)
	READ_FILE(S["uses_glasses_colour"], uses_glasses_colour)
	READ_FILE(S["clientfps"], clientfps)
	READ_FILE(S["parallax"], parallax)
	READ_FILE(S["ambientocclusion"], ambientocclusion)
	READ_FILE(S["auto_fit_viewport"], auto_fit_viewport)
	READ_FILE(S["old_discipline"], old_discipline)
	READ_FILE(S["widescreenpref"], widescreenpref)
	READ_FILE(S["pixel_size"], pixel_size)
	READ_FILE(S["scaling_method"], scaling_method)
	READ_FILE(S["menuoptions"], menuoptions)
	READ_FILE(S["enable_tips"], enable_tips)
	READ_FILE(S["tip_delay"], tip_delay)
	READ_FILE(S["pda_style"], pda_style)
	READ_FILE(S["pda_color"], pda_color)

	// Custom hotkeys
	READ_FILE(S["key_bindings"], key_bindings)
	check_keybindings()
	// hearted
	READ_FILE(S["hearted_until"], hearted_until)
	if(hearted_until > world.realtime)
		hearted = TRUE

	//try to fix any outdated data if necessary
	if(needs_update >= 0)
		var/bacpath = "[path].updatebac" //todo: if the savefile version is higher then the server, check the backup, and give the player a prompt to load the backup
		if (fexists(bacpath))
			fdel(bacpath) //only keep 1 version of backup
		fcopy(S, bacpath) //byond helpfully lets you use a savefile for the first arg.
		update_preferences(needs_update, S)		//needs_update = savefile_version if we need an update (positive integer)



	//Sanitize
	asaycolor		= sanitize_ooccolor(sanitize_hexcolor(asaycolor, 6, 1, initial(asaycolor)))
	ooccolor		= sanitize_ooccolor(sanitize_hexcolor(ooccolor, 6, 1, initial(ooccolor)))
	lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
	UI_style		= sanitize_inlist(UI_style, GLOB.available_ui_styles, GLOB.available_ui_styles[1])
	hotkeys			= sanitize_integer(hotkeys, FALSE, TRUE, initial(hotkeys))
	chat_on_map		= sanitize_integer(chat_on_map, FALSE, TRUE, initial(chat_on_map))
	max_chat_length = sanitize_integer(max_chat_length, 1, CHAT_MESSAGE_MAX_LENGTH, initial(max_chat_length))
	see_chat_non_mob	= sanitize_integer(see_chat_non_mob, FALSE, TRUE, initial(see_chat_non_mob))
	see_rc_emotes	= sanitize_integer(see_rc_emotes, FALSE, TRUE, initial(see_rc_emotes))
	broadcast_login_logout = sanitize_integer(broadcast_login_logout, FALSE, TRUE, initial(broadcast_login_logout))
	tgui_fancy		= sanitize_integer(tgui_fancy, FALSE, TRUE, initial(tgui_fancy))
	tgui_lock		= sanitize_integer(tgui_lock, FALSE, TRUE, initial(tgui_lock))
	buttons_locked	= sanitize_integer(buttons_locked, FALSE, TRUE, initial(buttons_locked))
	windowflashing	= sanitize_integer(windowflashing, FALSE, TRUE, initial(windowflashing))
	default_slot	= sanitize_integer(default_slot, 1, max_save_slots, initial(default_slot))
	toggles			= sanitize_integer(toggles, 0, (2**24)-1, initial(toggles))
	clientfps		= sanitize_integer(clientfps, -1, 1000, 0)
	parallax		= sanitize_integer(parallax, PARALLAX_INSANE, PARALLAX_DISABLE, null)
	ambientocclusion	= sanitize_integer(ambientocclusion, FALSE, TRUE, initial(ambientocclusion))
	auto_fit_viewport	= sanitize_integer(auto_fit_viewport, FALSE, TRUE, initial(auto_fit_viewport))
	old_discipline	= sanitize_integer(old_discipline, FALSE, TRUE, initial(old_discipline))
	widescreenpref  = sanitize_integer(widescreenpref, FALSE, TRUE, initial(widescreenpref))
	pixel_size		= sanitize_float(pixel_size, PIXEL_SCALING_AUTO, PIXEL_SCALING_3X, 0.5, initial(pixel_size))
	scaling_method  = sanitize_text(scaling_method, initial(scaling_method))
	ghost_form		= sanitize_inlist(ghost_form, GLOB.ghost_forms, initial(ghost_form))
	ghost_orbit 	= sanitize_inlist(ghost_orbit, GLOB.ghost_orbits, initial(ghost_orbit))
	ghost_accs		= sanitize_inlist(ghost_accs, GLOB.ghost_accs_options, GHOST_ACCS_DEFAULT_OPTION)
	ghost_others	= sanitize_inlist(ghost_others, GLOB.ghost_others_options, GHOST_OTHERS_DEFAULT_OPTION)
	menuoptions		= SANITIZE_LIST(menuoptions)
	be_special		= SANITIZE_LIST(be_special)
	pda_style		= sanitize_inlist(pda_style, GLOB.pda_styles, initial(pda_style))
	pda_color		= sanitize_hexcolor(pda_color, 6, 1, initial(pda_color))
	key_bindings 	= sanitize_keybindings(key_bindings)

	if(needs_update >= 0) //save the updated version
		var/old_default_slot = default_slot
		var/old_max_save_slots = max_save_slots

		for (var/slot in S.dir) //but first, update all current character slots.
			if (copytext(slot, 1, 10) != "character")
				continue
			var/slotnum = text2num(copytext(slot, 10))
			if (!slotnum)
				continue
			max_save_slots = max(max_save_slots, slotnum) //so we can still update byond member slots after they lose memeber status
			default_slot = slotnum
			if (load_character())
				save_character()
		default_slot = old_default_slot
		max_save_slots = old_max_save_slots
		save_preferences()

	return TRUE

/datum/preferences/proc/save_preferences()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"

	WRITE_FILE(S["version"] , SAVEFILE_VERSION_MAX)		//updates (or failing that the sanity checks) will ensure data is not invalid at load. Assume up-to-date

	//general preferences
	WRITE_FILE(S["asaycolor"], asaycolor)
	WRITE_FILE(S["ooccolor"], ooccolor)
	WRITE_FILE(S["lastchangelog"], lastchangelog)
	WRITE_FILE(S["UI_style"], UI_style)
	WRITE_FILE(S["hotkeys"], hotkeys)
	WRITE_FILE(S["chat_on_map"], chat_on_map)
	WRITE_FILE(S["max_chat_length"], max_chat_length)
	WRITE_FILE(S["see_chat_non_mob"], see_chat_non_mob)
	WRITE_FILE(S["see_rc_emotes"], see_rc_emotes)
	WRITE_FILE(S["broadcast_login_logout"], broadcast_login_logout)
	WRITE_FILE(S["tgui_fancy"], tgui_fancy)
	WRITE_FILE(S["tgui_lock"], tgui_lock)
	WRITE_FILE(S["buttons_locked"], buttons_locked)
	WRITE_FILE(S["windowflash"], windowflashing)
	WRITE_FILE(S["be_special"], be_special)
	WRITE_FILE(S["default_slot"], default_slot)
	WRITE_FILE(S["toggles"], toggles)
	WRITE_FILE(S["chat_toggles"], chat_toggles)
	WRITE_FILE(S["ghost_form"], ghost_form)
	WRITE_FILE(S["ghost_orbit"], ghost_orbit)
	WRITE_FILE(S["ghost_accs"], ghost_accs)
	WRITE_FILE(S["ghost_others"], ghost_others)
	WRITE_FILE(S["preferred_map"], preferred_map)
	WRITE_FILE(S["ignoring"], ignoring)
	WRITE_FILE(S["ghost_hud"], ghost_hud)
	WRITE_FILE(S["inquisitive_ghost"], inquisitive_ghost)
	WRITE_FILE(S["uses_glasses_colour"], uses_glasses_colour)
	WRITE_FILE(S["clientfps"], clientfps)
	WRITE_FILE(S["parallax"], parallax)
	WRITE_FILE(S["ambientocclusion"], ambientocclusion)
	WRITE_FILE(S["auto_fit_viewport"], auto_fit_viewport)
	WRITE_FILE(S["old_discipline"], old_discipline)
	WRITE_FILE(S["widescreenpref"], widescreenpref)
	WRITE_FILE(S["pixel_size"], pixel_size)
	WRITE_FILE(S["scaling_method"], scaling_method)
	WRITE_FILE(S["menuoptions"], menuoptions)
	WRITE_FILE(S["enable_tips"], enable_tips)
	WRITE_FILE(S["tip_delay"], tip_delay)
	WRITE_FILE(S["pda_style"], pda_style)
	WRITE_FILE(S["pda_color"], pda_color)
	WRITE_FILE(S["key_bindings"], key_bindings)
	WRITE_FILE(S["hearted_until"], (hearted_until > world.realtime ? hearted_until : null))
	return TRUE

/datum/preferences/proc/load_character(slot)
	if(!path)
		return FALSE
	if(!fexists(path))
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"
	if(!slot)
		slot = default_slot
	slot = sanitize_integer(slot, 1, max_save_slots, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		WRITE_FILE(S["default_slot"] , slot)

	S.cd = "/character[slot]"
	var/needs_update = savefile_needs_update(S)
	if(needs_update == -2)		//fatal, can't load any data
		return FALSE

	//Species
	var/species_id
	READ_FILE(S["species"], species_id)
	if(species_id)
		var/newtype = GLOB.species_list[species_id]
		if(newtype)
			pref_species = new newtype


	var/clane_id
	READ_FILE(S["clane"], clane_id)
	if(clane_id)
		var/newtype = GLOB.clanes_list[clane_id]
		if(newtype)
			clane = new newtype

	var/auspice_id
	READ_FILE(S["auspice"], auspice_id)
	if(auspice_id)
		var/newtype = GLOB.auspices_list[auspice_id]
		if(newtype)
			auspice = new newtype

	READ_FILE(S["breed"], breed)
	READ_FILE(S["tribe"], tribe)
	READ_FILE(S["werewolf_color"], werewolf_color)
	READ_FILE(S["werewolf_scar"], werewolf_scar)
	READ_FILE(S["werewolf_hair"], werewolf_hair)
	READ_FILE(S["werewolf_hair_color"], werewolf_hair_color)
	READ_FILE(S["werewolf_eye_color"], werewolf_eye_color)

	//Character
	READ_FILE(S["slotlocked"], slotlocked)
	READ_FILE(S["diablerist"], diablerist)
	READ_FILE(S["auspice_level"], auspice_level)
	READ_FILE(S["humanity"], humanity)
	READ_FILE(S["enlightement"], enlightenment)
	READ_FILE(S["exper"], exper)
	READ_FILE(S["exper_plus"], exper_plus)
	READ_FILE(S["true_experience"], true_experience)
	READ_FILE(S["physique"], physique)
	READ_FILE(S["dexterity"], dexterity)
	READ_FILE(S["social"], social)
	READ_FILE(S["mentality"], mentality)
	READ_FILE(S["lockpicking"], lockpicking)
	READ_FILE(S["athletics"], athletics)
	READ_FILE(S["blood"], blood)
	READ_FILE(S["archetype"], archetype)
	READ_FILE(S["discipline1level"], discipline1level)
	READ_FILE(S["discipline2level"], discipline2level)
	READ_FILE(S["discipline3level"], discipline3level)
	READ_FILE(S["discipline4level"], discipline4level)
	READ_FILE(S["discipline1type"], discipline1type)
	READ_FILE(S["discipline2type"], discipline2type)
	READ_FILE(S["discipline3type"], discipline3type)
	READ_FILE(S["discipline4type"], discipline4type)
	READ_FILE(S["discipline_types"], discipline_types)
	READ_FILE(S["discipline_levels"], discipline_levels)
	READ_FILE(S["info_known"], info_known)
	READ_FILE(S["friend"], friend)
	READ_FILE(S["enemy"], enemy)
	READ_FILE(S["lover"], lover)
	READ_FILE(S["ambitious"], ambitious)
	READ_FILE(S["flavor_text"], flavor_text)
	READ_FILE(S["friend_text"], friend_text)
	READ_FILE(S["enemy_text"], enemy_text)
	READ_FILE(S["lover_text"], lover_text)
	READ_FILE(S["reason_of_death"], reason_of_death)
	READ_FILE(S["generation"], generation)
	READ_FILE(S["generation_bonus"], generation_bonus)
	READ_FILE(S["masquerade"], masquerade)
	READ_FILE(S["real_name"], real_name)
	READ_FILE(S["werewolf_name"], werewolf_name)
	READ_FILE(S["gender"], gender)
	READ_FILE(S["body_type"], body_type)
	READ_FILE(S["body_model"], body_model)
	READ_FILE(S["age"], age)
	READ_FILE(S["torpor_count"], torpor_count)
	READ_FILE(S["total_age"], total_age)
	READ_FILE(S["hair_color"], hair_color)
	READ_FILE(S["facial_hair_color"], facial_hair_color)
	READ_FILE(S["eye_color"], eye_color)
	READ_FILE(S["skin_tone"], skin_tone)
	READ_FILE(S["hairstyle_name"], hairstyle)
	READ_FILE(S["facial_style_name"], facial_hairstyle)
	READ_FILE(S["underwear"], underwear)
	READ_FILE(S["underwear_color"], underwear_color)
	READ_FILE(S["undershirt"], undershirt)
	READ_FILE(S["socks"], socks)
	READ_FILE(S["backpack"], backpack)
	READ_FILE(S["jumpsuit_style"], jumpsuit_style)
	READ_FILE(S["uplink_loc"], uplink_spawn_loc)
	READ_FILE(S["clane_accessory"], clane_accessory)
	READ_FILE(S["playtime_reward_cloak"], playtime_reward_cloak)
	READ_FILE(S["phobia"], phobia)
	READ_FILE(S["randomise"],  randomise)
	READ_FILE(S["feature_mcolor"], features["mcolor"])
	READ_FILE(S["feature_ethcolor"], features["ethcolor"])
	READ_FILE(S["feature_lizard_tail"], features["tail_lizard"])
	READ_FILE(S["feature_lizard_snout"], features["snout"])
	READ_FILE(S["feature_lizard_horns"], features["horns"])
	READ_FILE(S["feature_lizard_frills"], features["frills"])
	READ_FILE(S["feature_lizard_spines"], features["spines"])
	READ_FILE(S["feature_lizard_body_markings"], features["body_markings"])
	READ_FILE(S["feature_lizard_legs"], features["legs"])
	READ_FILE(S["feature_moth_wings"], features["moth_wings"])
	READ_FILE(S["feature_moth_antennae"], features["moth_antennae"])
	READ_FILE(S["feature_moth_markings"], features["moth_markings"])
	READ_FILE(S["persistent_scars"] , persistent_scars)
	READ_FILE(S["dharma_type"], dharma_type)
	READ_FILE(S["dharma_level"], dharma_level)
	READ_FILE(S["po_type"], po_type)
	READ_FILE(S["po"], po)
	READ_FILE(S["hun"], hun)
	READ_FILE(S["yang"], yang)
	READ_FILE(S["yin"], yin)
	READ_FILE(S["chi_types"], chi_types)
	READ_FILE(S["chi_levels"], chi_levels)
	if(!CONFIG_GET(flag/join_with_mutant_humans))
		features["tail_human"] = "none"
		features["ears"] = "none"
	else
		READ_FILE(S["feature_human_tail"], features["tail_human"])
		READ_FILE(S["feature_human_ears"], features["ears"])

	//Custom names
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/savefile_slot_name = custom_name_id + "_name" //TODO remove this
		READ_FILE(S[savefile_slot_name], custom_names[custom_name_id])

	READ_FILE(S["preferred_ai_core_display"], preferred_ai_core_display)
	READ_FILE(S["prefered_security_department"], prefered_security_department)

	//Jobs
	READ_FILE(S["joblessrole"], joblessrole)
	//Load prefs
	READ_FILE(S["job_preferences"], job_preferences)

	//Quirks
	READ_FILE(S["all_quirks"], all_quirks)

	//try to fix any outdated data if necessary
	//preference updating will handle saving the updated data for us.
	if(needs_update >= 0)
		update_character(needs_update, S)		//needs_update == savefile_version if we need an update (positive integer)

	//Sanitize
	real_name = reject_bad_name(real_name)
	werewolf_name = reject_bad_name(werewolf_name)
	gender = sanitize_gender(gender)
	body_type = sanitize_gender(body_type, FALSE, FALSE, gender)
	body_model = sanitize_integer(body_model, 1, 3, initial(body_model))
	if(!real_name)
		real_name = random_unique_name(gender)
//	if(!clane)
//		var/newtype = GLOB.clanes_list["Brujah"]
//		clane = new newtype()

	//Prevent Wighting upon joining a round
	if(humanity <= 0)
		humanity = 1

	if(dharma_level <= 0)
		dharma_level = 1

	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/namedata = GLOB.preferences_custom_names[custom_name_id]
		custom_names[custom_name_id] = reject_bad_name(custom_names[custom_name_id],namedata["allow_numbers"])
		if(!custom_names[custom_name_id])
			custom_names[custom_name_id] = get_default_name(custom_name_id)

	if(!features["mcolor"] || features["mcolor"] == "#000")
		features["mcolor"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")

	if(!features["ethcolor"] || features["ethcolor"] == "#000")
		features["ethcolor"] = GLOB.color_list_ethereal[pick(GLOB.color_list_ethereal)]

	randomise = SANITIZE_LIST(randomise)

	if(gender == MALE)
		hairstyle			= sanitize_inlist(hairstyle, GLOB.hairstyles_male_list)
		facial_hairstyle			= sanitize_inlist(facial_hairstyle, GLOB.facial_hairstyles_male_list)
		underwear		= sanitize_inlist(underwear, GLOB.underwear_m)
		undershirt 		= sanitize_inlist(undershirt, GLOB.undershirt_m)
	else if(gender == FEMALE)
		hairstyle			= sanitize_inlist(hairstyle, GLOB.hairstyles_female_list)
		facial_hairstyle			= sanitize_inlist(facial_hairstyle, GLOB.facial_hairstyles_female_list)
		underwear		= sanitize_inlist(underwear, GLOB.underwear_f)
		undershirt		= sanitize_inlist(undershirt, GLOB.undershirt_f)
	else
		hairstyle			= sanitize_inlist(hairstyle, GLOB.hairstyles_list)
		facial_hairstyle			= sanitize_inlist(facial_hairstyle, GLOB.facial_hairstyles_list)
		underwear		= sanitize_inlist(underwear, GLOB.underwear_list)
		undershirt 		= sanitize_inlist(undershirt, GLOB.undershirt_list)

	archetype 		= sanitize_inlist(archetype, subtypesof(/datum/archetype))

	breed			= sanitize_inlist(breed, list("Homid", "Lupus", "Metis"))
	tribe			= sanitize_inlist(tribe, list("Wendigo", "Glasswalkers", "Black Spiral Dancers"))
	werewolf_color	= sanitize_inlist(werewolf_color, list("black", "gray", "red", "white", "ginger", "brown"))
	werewolf_scar	= sanitize_integer(werewolf_scar, 0, 7, initial(werewolf_scar))
	werewolf_hair	= sanitize_integer(werewolf_hair, 0, 4, initial(werewolf_hair))
	werewolf_hair_color		= sanitize_ooccolor(werewolf_hair_color, 3, 0)
	werewolf_eye_color		= sanitize_ooccolor(werewolf_eye_color, 3, 0)
	flavor_text		= sanitize_text(flavor_text)
	socks			= sanitize_inlist(socks, GLOB.socks_list)
	age				= sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	diablerist				= sanitize_integer(diablerist, 0, 1, initial(diablerist))
	friend_text		= sanitize_text(friend_text)
	enemy_text		= sanitize_text(enemy_text)
	lover_text		= sanitize_text(lover_text)
	reason_of_death	= sanitize_text(reason_of_death)
	torpor_count				= sanitize_integer(torpor_count, 0, 6, initial(torpor_count))
	total_age		= sanitize_integer(total_age, 18, 1120, initial(total_age))
	slotlocked			= sanitize_integer(slotlocked, 0, 1, initial(slotlocked))
	humanity				= sanitize_integer(humanity, 0, 10, initial(humanity))
	enlightenment				= sanitize_integer(enlightenment, 0, 1, initial(enlightenment))
	exper				= sanitize_integer(exper, 0, 99999999, initial(exper))
	exper_plus				= sanitize_integer(exper_plus, 0, 99999999, initial(exper_plus))
	true_experience				= sanitize_integer(true_experience, 0, 99999999, initial(true_experience))
	physique				= sanitize_integer(physique, 1, 10, initial(physique))
	dexterity				= sanitize_integer(dexterity, 1, 10, initial(dexterity))
	social					= sanitize_integer(social, 1, 10, initial(social))
	mentality				= sanitize_integer(mentality, 1, 10, initial(mentality))
	lockpicking				= sanitize_integer(lockpicking, 1, 10, initial(lockpicking))
	athletics				= sanitize_integer(athletics, 1, 10, initial(athletics))
	blood					= sanitize_integer(blood, 1, 10, initial(blood))
	auspice_level			= sanitize_integer(auspice_level, 1, 5, initial(auspice_level))
	discipline1level				= sanitize_integer(discipline1level, 1, 5, initial(discipline1level))
	discipline2level				= sanitize_integer(discipline2level, 1, 5, initial(discipline2level))
	discipline3level				= sanitize_integer(discipline3level, 1, 5, initial(discipline3level))
	discipline4level				= sanitize_integer(discipline4level, 1, 5, initial(discipline4level))
	discipline1type				= sanitize_discipline(discipline1type, subtypesof(/datum/discipline))
	discipline2type				= sanitize_discipline(discipline2type, subtypesof(/datum/discipline))
	discipline3type				= sanitize_discipline(discipline3type, subtypesof(/datum/discipline))
	if(discipline4type)
		discipline4type				= sanitize_discipline(discipline4type, subtypesof(/datum/discipline))
	discipline_types = sanitize_islist(discipline_types, list())
	discipline_levels = sanitize_islist(discipline_levels, list())
	dharma_level = sanitize_integer(dharma_level, 0, 6, initial(dharma_level))
	dharma_type = sanitize_inlist(dharma_type, subtypesof(/datum/dharma))
	po_type = sanitize_inlist(po_type, list("Rebel", "Legalist", "Demon", "Monkey", "Fool"))
	po = sanitize_integer(po, 1, 12, initial(po))
	hun = sanitize_integer(hun, 1, 12, initial(hun))
	yang = sanitize_integer(yang, 1, 12, initial(yang))
	yin = sanitize_integer(yin, 1, 12, initial(yin))
	chi_types = sanitize_islist(chi_types, list())
	chi_levels = sanitize_islist(chi_levels, list())
	//TODO: custom sanitization for discipline_types and discipline_levels
	friend				= sanitize_integer(friend, 0, 1, initial(friend))
	enemy				= sanitize_integer(enemy, 0, 1, initial(enemy))
	lover				= sanitize_integer(lover, 0, 1, initial(lover))
	ambitious				= sanitize_integer(ambitious, 0, 1, initial(ambitious))
	masquerade				= sanitize_integer(masquerade, 0, 5, initial(masquerade))
	generation				= sanitize_integer(generation, 3, 13, initial(generation))
	generation_bonus				= sanitize_integer(generation_bonus, 0, 6, initial(generation_bonus))
	hair_color			= sanitize_hexcolor(hair_color, 3, 0)
	facial_hair_color			= sanitize_hexcolor(facial_hair_color, 3, 0)
	underwear_color			= sanitize_hexcolor(underwear_color, 3, 0)
	eye_color		= sanitize_hexcolor(eye_color, 3, 0)
	skin_tone		= sanitize_inlist(skin_tone, GLOB.skin_tones)
	backpack			= sanitize_inlist(backpack, GLOB.backpacklist, initial(backpack))
	jumpsuit_style	= sanitize_inlist(jumpsuit_style, GLOB.jumpsuitlist, initial(jumpsuit_style))
	uplink_spawn_loc = sanitize_inlist(uplink_spawn_loc, GLOB.uplink_spawn_loc_list, initial(uplink_spawn_loc))
	clane_accessory = sanitize_inlist(clane_accessory, clane.accessories, null)
	playtime_reward_cloak = sanitize_integer(playtime_reward_cloak)
	features["mcolor"]	= sanitize_hexcolor(features["mcolor"], 3, 0)
	features["ethcolor"]	= copytext_char(features["ethcolor"], 1, 7)
	features["tail_lizard"]	= sanitize_inlist(features["tail_lizard"], GLOB.tails_list_lizard)
	features["tail_human"] 	= sanitize_inlist(features["tail_human"], GLOB.tails_list_human, "None")
	features["snout"]	= sanitize_inlist(features["snout"], GLOB.snouts_list)
	features["horns"] 	= sanitize_inlist(features["horns"], GLOB.horns_list)
	features["ears"]	= sanitize_inlist(features["ears"], GLOB.ears_list, "None")
	features["frills"] 	= sanitize_inlist(features["frills"], GLOB.frills_list)
	features["spines"] 	= sanitize_inlist(features["spines"], GLOB.spines_list)
	features["body_markings"] 	= sanitize_inlist(features["body_markings"], GLOB.body_markings_list)
	features["feature_lizard_legs"]	= sanitize_inlist(features["legs"], GLOB.legs_list, "Normal Legs")
	features["moth_wings"] 	= sanitize_inlist(features["moth_wings"], GLOB.moth_wings_list, "Plain")
	features["moth_antennae"] 	= sanitize_inlist(features["moth_antennae"], GLOB.moth_antennae_list, "Plain")
	features["moth_markings"] 	= sanitize_inlist(features["moth_markings"], GLOB.moth_markings_list, "None")

	persistent_scars = sanitize_integer(persistent_scars)

	joblessrole	= sanitize_integer(joblessrole, 1, 3, initial(joblessrole))
	//Validate job prefs
	for(var/j in job_preferences)
		if(job_preferences[j] != JP_LOW && job_preferences[j] != JP_MEDIUM && job_preferences[j] != JP_HIGH)
			job_preferences -= j

	all_quirks = SANITIZE_LIST(all_quirks)
	validate_quirks()

	//Convert jank old Discipline system to new Discipline system
	if ((istype(pref_species, /datum/species/kindred) || istype(pref_species, /datum/species/ghoul)) && !discipline_types.len)
		if (discipline1type && discipline1level)
			discipline_types += discipline1type
			discipline_levels += discipline1level
			discipline1type = null
			discipline1level = null
		if (discipline2type && discipline2level)
			discipline_types += discipline2type
			discipline_levels += discipline2level
			discipline2type = null
			discipline2level = null
		if (discipline3type && discipline3level)
			discipline_types += discipline3type
			discipline_levels += discipline3level
			discipline3type = null
			discipline3level = null
		if (discipline4type && discipline4level)
			discipline_types += discipline4type
			discipline_levels += discipline4level
			discipline4type = null
			discipline4level = null

	//repair some damage done by an exploit by resetting
	if ((true_experience > 1000) && !check_rights_for(parent, R_ADMIN))
		message_admins("[ADMIN_LOOKUPFLW(parent)] loaded a character slot with [true_experience] experience. The slot has been reset.")
		log_game("[key_name(parent)] loaded a character slot with [true_experience] experience. The slot has been reset.")
		to_chat(parent, "<span class='userdanger'>You tried to load a character slot with [true_experience] experience. It has been reset.</span>")
		reset_character()

	return TRUE

/datum/preferences/proc/save_character()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/character[default_slot]"

	WRITE_FILE(S["version"]			, SAVEFILE_VERSION_MAX)	//load_character will sanitize any bad data, so assume up-to-date.)

	WRITE_FILE(S["breed"], breed)
	WRITE_FILE(S["tribe"], tribe)
	WRITE_FILE(S["werewolf_color"], werewolf_color)
	WRITE_FILE(S["werewolf_scar"], werewolf_scar)
	WRITE_FILE(S["werewolf_hair"], werewolf_hair)
	WRITE_FILE(S["werewolf_hair_color"], werewolf_hair_color)
	WRITE_FILE(S["werewolf_eye_color"], werewolf_eye_color)
	WRITE_FILE(S["auspice"]			, auspice.name)

	//Character
	WRITE_FILE(S["slotlocked"]			, slotlocked)
	WRITE_FILE(S["diablerist"]			, diablerist)
	WRITE_FILE(S["humanity"]			, humanity)
	WRITE_FILE(S["enlightement"]			, enlightenment)
	WRITE_FILE(S["exper"]			, exper)
	WRITE_FILE(S["exper_plus"]			, exper_plus)
	WRITE_FILE(S["true_experience"]			, true_experience)
	WRITE_FILE(S["auspice_level"]			, auspice_level)
	WRITE_FILE(S["physique"]		, physique)
	WRITE_FILE(S["dexterity"]		, dexterity)
	WRITE_FILE(S["social"]			, social)
	WRITE_FILE(S["mentality"]		, mentality)
	WRITE_FILE(S["lockpicking"]		, lockpicking)
	WRITE_FILE(S["athletics"]		, athletics)
	WRITE_FILE(S["blood"]			, blood)
	WRITE_FILE(S["archetype"]			, archetype)
	WRITE_FILE(S["discipline1level"]			, discipline1level)
	WRITE_FILE(S["discipline2level"]			, discipline2level)
	WRITE_FILE(S["discipline3level"]			, discipline3level)
	WRITE_FILE(S["discipline4level"]			, discipline4level)
	WRITE_FILE(S["discipline1type"]			, discipline1type)
	WRITE_FILE(S["discipline2type"]			, discipline2type)
	WRITE_FILE(S["discipline3type"]			, discipline3type)
	WRITE_FILE(S["discipline4type"]			, discipline4type)
	WRITE_FILE(S["discipline_types"], discipline_types)
	WRITE_FILE(S["discipline_levels"], discipline_levels)
	WRITE_FILE(S["info_known"]		, info_known)
	WRITE_FILE(S["friend"]			, friend)
	WRITE_FILE(S["enemy"]			, enemy)
	WRITE_FILE(S["lover"]			, lover)
	WRITE_FILE(S["ambitious"]			, ambitious)
	WRITE_FILE(S["flavor_text"]			, flavor_text)
	WRITE_FILE(S["friend_text"]			, friend_text)
	WRITE_FILE(S["enemy_text"]			, enemy_text)
	WRITE_FILE(S["lover_text"]			, lover_text)
	WRITE_FILE(S["reason_of_death"]			, reason_of_death)
	WRITE_FILE(S["clane"]			, clane.name)
	WRITE_FILE(S["generation"]			, generation)
	WRITE_FILE(S["generation_bonus"]			, generation_bonus)
	WRITE_FILE(S["masquerade"]			, masquerade)
	WRITE_FILE(S["real_name"]			, real_name)
	WRITE_FILE(S["werewolf_name"]			, werewolf_name)
	WRITE_FILE(S["gender"]			, gender)
	WRITE_FILE(S["body_type"]		, body_type)
	WRITE_FILE(S["body_model"]		, body_model)
	WRITE_FILE(S["age"]			, age)
	WRITE_FILE(S["torpor_count"]			, torpor_count)
	WRITE_FILE(S["total_age"]	, total_age)
	WRITE_FILE(S["hair_color"]			, hair_color)
	WRITE_FILE(S["facial_hair_color"]			, facial_hair_color)
	WRITE_FILE(S["eye_color"]			, eye_color)
	WRITE_FILE(S["skin_tone"]			, skin_tone)
	WRITE_FILE(S["hairstyle_name"]			, hairstyle)
	WRITE_FILE(S["facial_style_name"]			, facial_hairstyle)
	WRITE_FILE(S["underwear"]			, underwear)
	WRITE_FILE(S["underwear_color"]			, underwear_color)
	WRITE_FILE(S["undershirt"]			, undershirt)
	WRITE_FILE(S["socks"]			, socks)
	WRITE_FILE(S["backpack"]			, backpack)
	WRITE_FILE(S["jumpsuit_style"]			, jumpsuit_style)
	WRITE_FILE(S["uplink_loc"]			, uplink_spawn_loc)
	WRITE_FILE(S["clane_accessory"]			, clane_accessory)
	WRITE_FILE(S["playtime_reward_cloak"]			, playtime_reward_cloak)
	WRITE_FILE(S["randomise"]		, randomise)
	WRITE_FILE(S["species"]			, pref_species.id)
	WRITE_FILE(S["phobia"], phobia)
	WRITE_FILE(S["feature_mcolor"]					, features["mcolor"])
	WRITE_FILE(S["feature_ethcolor"]					, features["ethcolor"])
	WRITE_FILE(S["feature_lizard_tail"]			, features["tail_lizard"])
	WRITE_FILE(S["feature_human_tail"]				, features["tail_human"])
	WRITE_FILE(S["feature_lizard_snout"]			, features["snout"])
	WRITE_FILE(S["feature_lizard_horns"]			, features["horns"])
	WRITE_FILE(S["feature_human_ears"]				, features["ears"])
	WRITE_FILE(S["feature_lizard_frills"]			, features["frills"])
	WRITE_FILE(S["feature_lizard_spines"]			, features["spines"])
	WRITE_FILE(S["feature_lizard_body_markings"]	, features["body_markings"])
	WRITE_FILE(S["feature_lizard_legs"]			, features["legs"])
	WRITE_FILE(S["feature_moth_wings"]			, features["moth_wings"])
	WRITE_FILE(S["feature_moth_antennae"]			, features["moth_antennae"])
	WRITE_FILE(S["feature_moth_markings"]		, features["moth_markings"])
	WRITE_FILE(S["persistent_scars"]			, persistent_scars)
	WRITE_FILE(S["dharma_type"], dharma_type)
	WRITE_FILE(S["dharma_level"], dharma_level)
	WRITE_FILE(S["po_type"], po_type)
	WRITE_FILE(S["po"], po)
	WRITE_FILE(S["hun"], hun)
	WRITE_FILE(S["yang"], yang)
	WRITE_FILE(S["yin"], yin)
	WRITE_FILE(S["chi_types"], chi_types)
	WRITE_FILE(S["chi_levels"], chi_levels)

	//Custom names
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/savefile_slot_name = custom_name_id + "_name" //TODO remove this
		WRITE_FILE(S[savefile_slot_name],custom_names[custom_name_id])

	WRITE_FILE(S["preferred_ai_core_display"] ,  preferred_ai_core_display)
	WRITE_FILE(S["prefered_security_department"] , prefered_security_department)

	//Jobs
	WRITE_FILE(S["joblessrole"]		, joblessrole)
	//Write prefs
	WRITE_FILE(S["job_preferences"] , job_preferences)

	//Quirks
	WRITE_FILE(S["all_quirks"]			, all_quirks)

	return TRUE


/proc/sanitize_keybindings(value)
	var/list/base_bindings = sanitize_islist(value,list())
	for(var/key in base_bindings)
		base_bindings[key] = base_bindings[key] & GLOB.keybindings_by_name
		if(!length(base_bindings[key]))
			base_bindings -= key
	return base_bindings

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN

#ifdef TESTING
//DEBUG
//Some crude tools for testing savefiles
//path is the savefile path
/client/verb/savefile_export(path as text)
	var/savefile/S = new /savefile(path)
	S.ExportText("/",file("[path].txt"))
//path is the savefile path
/client/verb/savefile_import(path as text)
	var/savefile/S = new /savefile(path)
	S.ImportText("/",file("[path].txt"))

#endif
