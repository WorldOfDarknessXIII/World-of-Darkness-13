/datum/outfit/job/noddist
	name = "Noddist"
	uniform = /obj/item/clothing/under/vampire/emo
	suit = /obj/item/clothing/suit/vampire/noddist
	mask = /obj/item/clothing/head/vampire/noddist_mask
	backpack_contents = list(/obj/item/vampirebook/noddist=1, /obj/item/vampire_stake=3)

/datum/outfit/job/noddist/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/vampire
	else
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/outfit/job/noddist/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/noddist)

	GLOB.noddists += H
	H.vampire_faction = "Cult of Nod"

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

/obj/effect/landmark/start/noddist
	name = "Noddist"
	delete_after_roundstart = FALSE

/datum/antagonist/noddist
	name = "Noddist"
	roundend_category = "noddists"
	antagpanel_category = "Noddist"
	job_rank = ROLE_TRAITOR
	antag_moodlet = /datum/mood_event/focused
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "cult"

/datum/antagonist/noddist/on_gain()
	owner.special_role = src
	var/datum/objective/steal_skull/steal1 = new
	steal1.owner = owner
	objectives += steal1
	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/evil_start.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	return ..()

/datum/antagonist/noddist/on_removal()
	..()
	to_chat(owner.current,"<span class='userdanger'>You are no longer the Noddist!</span>")
	owner.special_role = null

/datum/antagonist/noddist/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You are the Noddist.</span>")
	owner.announce_objectives()
