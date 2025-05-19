/datum/outfit/job/sabbatist
	name = "Sabbatist"
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	suit = /obj/item/clothing/suit/vampire/trench
	id = /obj/item/cockclock
	backpack_contents = list(/obj/item/passport=1, /obj/item/vampire_stake=3, /obj/item/gun/ballistic/vampire/revolver=1, /obj/item/melee/vampirearms/knife=1, /obj/item/vamp/keys/hack=1, /obj/item/melee/vampirearms/katana/kosa=1)

/datum/outfit/job/sabbatist/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/vampire
		if(H.clan)
			if(H.clan.male_clothes)
				uniform = H.clan.male_clothes
	else
		shoes = /obj/item/clothing/shoes/vampire/heels
		if(H.clan)
			if(H.clan.female_clothes)
				uniform = H.clan.female_clothes

/datum/outfit/job/sabbatist/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/sabbatist)
	GLOB.sabbatites += H

	var/my_name = "Tyler"
	if(H.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	H.fully_replace_character_name(null,"[my_name] [my_surname]")

	var/list/landmarkslist = list()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(S.name == name)
			landmarkslist += S
	var/obj/effect/landmark/start/D = pick(landmarkslist)
	H.forceMove(D.loc)

/obj/effect/landmark/start/sabbatist
	name = "Sabbatist"
	delete_after_roundstart = FALSE

/datum/antagonist/sabbatist
	name = "Sabbatist"
	roundend_category = "sabbattites"
	antagpanel_category = FACTION_SABBAT
	job_rank = ROLE_REV
	antag_moodlet = /datum/mood_event/revolution
	antag_hud_type = ANTAG_HUD_REV
	antag_hud_name = "rev"

/datum/antagonist/sabbatist/on_gain()
	add_antag_hud(ANTAG_HUD_REV, "rev", owner.current)
	owner.special_role = src
	var/datum/objective/custom/custom_objective = new
	custom_objective.owner = owner
	custom_objective.explanation_text = "Sow chaos, maim, butcher and kill. When you're done The Ivory Tower should be but a distant memory."
	objectives += custom_objective
	var/datum/objective/survive/survive_objective = new
	survive_objective.owner = owner
	objectives += survive_objective
	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/evil_start.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	return ..()

/datum/antagonist/sabbatist/on_removal()
	..()
	to_chat(owner.current,"<span class='userdanger'>You are no longer the part of Sabbat!</span>")
	owner.special_role = null

/datum/antagonist/sabbatist/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You are the part of Sabbat.</span>")
	owner.announce_objectives()
