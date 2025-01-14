/datum/outfit/job/sabbatist
	name = "Sabbatist"
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	suit = /obj/item/clothing/suit/vampire/trench
	id = /obj/item/cockclock
	backpack_contents = list(/obj/item/passport=1, /obj/item/vampire_stake=3, /obj/item/gun/ballistic/vampire/revolver=1, /obj/item/melee/vampirearms/knife=1, /obj/item/vamp/keys/hack=1, /obj/item/melee/vampirearms/katana/kosa=1)

/datum/outfit/job/sabbatist/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = FACTION_SABBAT
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
//Commented out code for future sabbat character setup
/*
	H.generation = 13
	H.clane = null

	H.maxHealth = round((initial(H.maxHealth)-initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*(H.physique+13-H.generation))
	H.health = round((initial(H.health)-initial(H.health)/4)+(initial(H.health)/4)*(H.physique+13-H.generation))
	H.thaumaturgy_knowledge = FALSE
	QDEL_NULL(H.clane)
	var/obj/item/organ/eyes/NV = new()
	NV.Insert(H, TRUE, FALSE)
	add_verb(H, /datum/job/sabbatist/verb/setup_character)
*/

	var/list/landmarkslist = list()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(S.name == name)
			landmarkslist += S
	var/obj/effect/landmark/start/D = pick(landmarkslist)
	H.forceMove(D.loc)

//Commented out code for future sabbat character setup
/*
/datum/job/sabbatist/verb/setup_character()
	set category = FACTION_SABBAT
	set name = "Set Up Character"
	set desc = "Prepare your character."
	var/list/clans = list("Tzimisce", "Lasombra", "Gangrel", "Brujah", "Toreador", "Ventrue")
	var/list/generations = list(8, 9, 10, 11, 12, 13)
	var/total_points = 10
	var/points_spent = 0

	var/clan_choice = input("Choose your clan:", "Clan Selection") in clans
	var/generation_choice = input("Choose your generation:", "Generation Selection") in generations

	var/discipline1
	var/discipline2
	var/discipline3
	switch(clan_choice)
		if("Tzimisce")
			discipline1 = "Animalism"
			discipline2 = "Auspex"
			discipline3 = "Vicissitude"
		if("Lasombra")
			discipline1 = "Dominate"
			discipline2 = "Obtenebration"
			discipline3 = "Potence"
		if("Gangrel")
			discipline1 = "Animalism"
			discipline2 = "Fortitude"
			discipline3 = "Protean"
		if("Brujah")
			discipline1 = "Celerity"
			discipline2 = "Potence"
			discipline3 = "Presence"
		if("Toreador")
			discipline1 = "Auspex"
			discipline2 = "Celerity"
			discipline3 = "Presence"
		if("Ventrue")
			discipline1 = "Dominate"
			discipline2 = "Fortitude"
			discipline3 = "Presence"
	var/discipline1_level = 0
	var/discipline2_level = 0
	var/discipline3_level = 0

	var/list/generation_costs = list(8 = 5, 9 = 4, 10 = 3, 11 = 2, 12 = 1, 13 = 0)
	generation_choice = 13

	while(points_spent < total_points)
		var/list/choices = list("Discipline 1: [discipline1] (Level: [discipline1_level])", "Discipline 2: [discipline2] (Level: [discipline2_level])", "Discipline 3: [discipline3] (Level: [discipline3_level])", "Finish")
		var/choice = input("Allocate your points. Points remaining: [total_points - points_spent]", "Discipline Allocation") in choices

		if(choice == "Finish")
			break

		if(choice == "Discipline 1: [discipline1] (Level: [discipline1_level])")
			if(points_spent < total_points)
				discipline1_level += 1
				points_spent += 1
		if(choice == "Discipline 2: [discipline2] (Level: [discipline2_level])")
			if(points_spent < total_points)
				discipline2_level += 1
				points_spent += 1
		if(choice == "Discipline 3: [discipline3] (Level: [discipline3_level])")
			if(points_spent < total_points)
				discipline3_level += 1
				points_spent += 1
		if(choice == "Choose Generation (Current: [generation_choice])")
			var/new_generation = input("Choose your generation:", "Generation Selection") in generation_costs
			var/cost = generation_costs[new_generation]
			if(points_spent + cost <= total_points)
				points_spent += cost
				generation_choice = new_generation

	H.skin_tone = get_vamp_skin_color(H.skin_tone)
	H.update_body()
	H.clane = new H.clane.type()
	H.clane.on_gain(H)
	if(H.clane.alt_sprite)
		H.skin_tone = "albino"
		H.update_body()
	H.create_disciplines(FALSE, discipline1, discipline2, discipline3)

//	H.discipline1 = discipline1_level
//	H.discipline2 = discipline2_level
//	H.discipline3 = discipline3_level

	H.generation = generation_choice
	H.maxbloodpool = 10+((13-min(13, H.generation))*3)
	H.clane.enlightenment = H.clane.enlightenment
	H.maxHealth = round((initial(H.maxHealth)-initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*(H.physique+13-H.generation))
	H.health = round((initial(H.maxHealth)-initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*(H.physique+13-H.generation))

	to_chat(H, "You have chosen [clan_choice] with generation [generation_choice]. Your disciplines are [discipline1] (Level: [discipline1_level]), [discipline2] (Level: [discipline2_level]) and [discipline3] (Level: [discipline3_level]).")
	remove_verb(H, /datum/job/sabbatist/verb/setup_character)

*/

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
