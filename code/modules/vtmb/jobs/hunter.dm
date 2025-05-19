/datum/outfit/job/hunter
	name = "Hunter"
	uniform = /obj/item/clothing/under/vampire/graveyard
	r_pocket = /obj/item/flashlight
	id = /obj/item/card/id/hunter
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/vamp/keys/church
	backpack_contents = list(
		/obj/item/storage/book/bible = 1,
		/obj/item/vampire_stake = 3,
		/obj/item/molotov = 1,
		/obj/item/gas_can/full = 1,
		/obj/item/vamp/keys/hack=1
		)

/datum/outfit/job/hunter/post_equip(mob/living/carbon/human/H)
	..()
	if(H.clan)
		qdel(H.clan)
	H.set_species(/datum/species/human)
	H.generation = 13
	H.maxHealth = round((initial(H.maxHealth)-initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*(H.physique+13-H.generation))
	H.health = round((initial(H.health)-initial(H.health)/4)+(initial(H.health)/4)*(H.physique+13-H.generation))
	var/my_name = "Tyler"
	if(H.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	H.fully_replace_character_name(null,"[my_name] [my_surname]")
//	for(var/atom/movable/screen/blood/B in H.hud_used.infodisplay)
//		B.icon_state = null
//	for(var/atom/movable/screen/healths/HE in H.hud_used.infodisplay)
//		HE.icon = 'code/modules/wod13/ghoul_health.dmi'
//	for(var/atom/movable/screen/drinkblood/DB in H.hud_used.static_inventory)
//		DB.icon_state = null
//	for(var/atom/movable/screen/bloodheal/BH in H.hud_used.static_inventory)
//		BH.icon_state = null
//	for(var/atom/movable/screen/bloodpower/BP in H.hud_used.static_inventory)
//		BP.icon_state = null
//	for(var/atom/movable/screen/disciplines/DI in H.hud_used.static_inventory)
//		DI.icon_state = null
	for(var/datum/action/A in H.actions)
		if(A.vampiric)
			A.Remove(H)
	H.thaumaturgy_knowledge = FALSE
	QDEL_NULL(H.clan)
	var/obj/item/organ/eyes/NV = new()
	NV.Insert(H, TRUE, FALSE)
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/hunter)

	var/list/landmarkslist = list()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(S.name == name)
			landmarkslist += S
	var/obj/effect/landmark/start/D = pick(landmarkslist)
	H.forceMove(D.loc)

	var/list/loadouts = list("Fire Fighter", "EOD Suit", "Holy Presence")
	spawn()
		var/loadout_type = input(H, "Choose the Lord's gift for you:", "Loadout") as anything in loadouts
		switch(loadout_type)
			if("Fire Master")
				H.equip_to_slot_or_del(new /obj/item/clothing/head/vampire/helmet(H), ITEM_SLOT_HEAD)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/vampire/vest(H), ITEM_SLOT_OCLOTHING)
				H.put_in_r_hand(new /obj/item/vampire_flamethrower(H))
				H.put_in_l_hand(new /obj/item/melee/vampirearms/fireaxe(H))
			if("EOD Suit")
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/vampire/eod(H), ITEM_SLOT_OCLOTHING)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/vampire/eod(H), ITEM_SLOT_HEAD)
				H.put_in_r_hand(new /obj/item/gun/ballistic/shotgun/vampire(H))
				H.put_in_l_hand(new /obj/item/ammo_box/vampire/c12g(H))
			if("Holy Presence")
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/vampire/vest/army(H), ITEM_SLOT_OCLOTHING)
				H.put_in_r_hand(new /obj/item/melee/vampirearms/chainsaw(H))
				H.resistant_to_disciplines = TRUE
				to_chat(H, "<b>You are no longer vulnerable to vampire blood powers...</b>")

/obj/effect/landmark/start/hunter
	name = "Hunter"
	delete_after_roundstart = FALSE

/datum/antagonist/hunter
	name = "Hunter"
	roundend_category = "hunters"
	antagpanel_category = "Hunter"
	job_rank = ROLE_OPERATIVE
	antag_hud_type = ANTAG_HUD_OPS
	antag_hud_name = "synd"
	antag_moodlet = /datum/mood_event/focused
	show_to_ghosts = TRUE

/datum/antagonist/hunter/on_gain()
	owner.holy_role = HOLY_ROLE_PRIEST
	add_antag_hud(ANTAG_HUD_OPS, "synd", owner.current)
	owner.special_role = src
	var/datum/objective/custom/custom_objective = new
	custom_objective.owner = owner
	custom_objective.explanation_text = "Exterminate all evil spirits in the city. Let the Hunt begin!"
	objectives += custom_objective
	var/datum/objective/martyr/die_objective = new
	die_objective.owner = owner
	objectives += die_objective
	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/orthodox_start.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	return ..()

/datum/antagonist/hunter/on_removal()
	..()
	to_chat(owner.current,"<span class='userdanger'>You are no longer the Hunter!</span>")
	owner.special_role = null

/datum/antagonist/hunter/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You are the Hunter.</span>")
	owner.announce_objectives()
