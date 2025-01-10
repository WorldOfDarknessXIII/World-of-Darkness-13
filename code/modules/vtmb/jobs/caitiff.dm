/datum/outfit/job/caitiff
	name = "Caitiff"
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	id = /obj/item/cockclock
	backpack_contents = list(/obj/item/passport=1, /obj/item/vampire_stake=1, /obj/item/vamp/keys/hack=1)

/datum/outfit/job/caitiff/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/vampire
		if(H.clane)
			if(H.clane.male_clothes)
				uniform = H.clane.male_clothes
	else
		shoes = /obj/item/clothing/shoes/vampire/heels
		if(H.clane)
			if(H.clane.female_clothes)
				uniform = H.clane.female_clothes

/datum/outfit/job/caitiff/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/caitiff)

	var/list/landmarkslist = list()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(S.name == name)
			landmarkslist += S
	var/obj/effect/landmark/start/D = pick(landmarkslist)
	H.forceMove(D.loc)

	var/my_name = "Tyler"
	if(H.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	H.fully_replace_character_name(null,"[my_name] [my_surname]")

/obj/effect/landmark/start/caitiff
	name = "Caitiff"
	delete_after_roundstart = FALSE

/datum/antagonist/caitiff
	name = "Caitiff"
	roundend_category = "caitiffs"
	antagpanel_category = "Caitiff"
	job_rank = ROLE_TRAITOR
	antag_moodlet = /datum/mood_event/focused
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "traitor"

/datum/antagonist/caitiff/on_gain()
	owner.special_role = src
	var/datum/objective/assassinate/kill_objective = new
	kill_objective.owner = owner
	kill_objective.find_target()
	objectives += kill_objective
	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/sad_start.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	return ..()

/datum/antagonist/caitiff/on_removal()
	..()
	to_chat(owner.current,"<span class='userdanger'>You are no longer the Caitiff!</span>")
	owner.special_role = null

/datum/antagonist/caitiff/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You are the Caitiff.</span>")
	owner.announce_objectives()
