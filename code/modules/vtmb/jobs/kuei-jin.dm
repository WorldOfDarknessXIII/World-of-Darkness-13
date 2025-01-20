/datum/outfit/job/kuei_jin
	name = "Kuei-Jin Spy"
	uniform = /obj/item/clothing/under/vampire/emo
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	id = /obj/item/cockclock
	backpack_contents = list(/obj/item/passport=1, /obj/item/vampire_stake=1, /obj/item/vamp/keys/hack=1)

/datum/outfit/job/kuei_jin/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/vampire
	else
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/outfit/job/kuei_jin/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/kuei_jin)

	var/list/landmarkslist = list()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(S.name == "Caitiff")
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

/obj/effect/landmark/start/kuei_jin
	name = "Kuei-Jin Spy"
	delete_after_roundstart = FALSE

/datum/antagonist/kuei_jin
	name = "Kuei-Jin Spy"
	roundend_category = "kuei_jin"
	antagpanel_category = "Kuei-Jin"
	job_rank = ROLE_TRAITOR
	antag_moodlet = /datum/mood_event/focused
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "brother"

/datum/antagonist/kuei_jin/on_gain()
	owner.special_role = src
	var/datum/objective/steal_skull/steal1 = new
	var/datum/objective/steal_keys/steal2 = new
	steal1.owner = owner
	objectives += steal1
	steal2.owner = owner
	objectives += steal2
	var/datum/objective/survive/survive = new
	survive.owner = owner
	objectives += survive
	var/datum/objective/assassinate/kill_objective = new
	kill_objective.owner = owner
	kill_objective.find_target()
	objectives += kill_objective
	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/sad_start.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	return ..()

/datum/antagonist/kuei_jin/on_removal()
	..()
	to_chat(owner.current,"<span class='userdanger'>You are no longer the Kuei-Jin Spy!</span>")
	owner.special_role = null

/datum/antagonist/kuei_jin/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You are the Kuei-Jin Spy.</span>")
	owner.announce_objectives()
