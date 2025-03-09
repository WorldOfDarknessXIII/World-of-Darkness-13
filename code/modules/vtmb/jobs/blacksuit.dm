/datum/outfit/blacksuit
	name = "Blacksuit Agent"
	ears = /obj/item/radio/headset/syndicate
	uniform = /obj/item/clothing/under/vampire/suit
	r_pocket = /obj/item/flashlight
	l_pocket = /obj/item/vamp/keys/hack
	shoes = /obj/item/clothing/shoes/vampire/businessblack
	back = /obj/item/gun/energy/pulse/destroyer/vampire
	glasses = /obj/item/clothing/glasses/hud/vampire/blacksuit
	gloves = /obj/item/clothing/gloves/vampire/work
	
/datum/antagonist/blacksuit/proc/equip_blacksuit()
	var/mob/living/carbon/human/H = owner.current
	if(!ishuman(owner.current))
		return
	H.equipOutfit(blacksuit_outfit)
	if(H.clane)
		H.remove_overlay(H.clane.accessories_layers[H.clane.current_accessory])
		qdel(H.clane)
	H.set_species(/datum/species/cyborg)
	H.generation = 13
	H.lockpicking = 5
	H.physique = 10
	H.social = 4
	H.mentality = 8
	H.athletics = 10
	H.dexterity = 8
	H.ignores_warrant = TRUE
	H.maxHealth = round((initial(H.maxHealth)-initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*(H.physique))
	H.health = round((initial(H.health)-initial(H.health)/4)+(initial(H.health)/4)*(H.physique))
	for(var/datum/action/A in H.actions)
		if(A.vampiric)
			A.Remove(H)
	H.thaumaturgy_knowledge = FALSE
	H.spell_immunity = TRUE
	QDEL_NULL(H.clane)
	var/obj/item/organ/eyes/robotic/xray/NV = new()
	NV.Insert(H, TRUE, FALSE)

	var/list/landmarkslist = list()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(S.name == name)
			landmarkslist += S
	var/obj/effect/landmark/start/D = pick(landmarkslist)
	H.forceMove(D.loc)

/obj/effect/landmark/start/blacksuit
	name = "Blacksuit Agent"
	delete_after_roundstart = FALSE

/datum/antagonist/blacksuit
	name = "Blacksuit Agent"
	roundend_category = "Blacksuit"
	antagpanel_category = "Blacksuit"
	job_rank = ROLE_BLACKSUIT
	antag_hud_type = ANTAG_HUD_OPS
	antag_hud_name = "synd"
	antag_moodlet = /datum/mood_event/focused
	show_to_ghosts = TRUE
	var/always_new_team = FALSE
	var/datum/team/blacksuit/blacksuit_team
	var/blacksuit_outfit = /datum/outfit/blacksuit
	var/custom_objective

/datum/antagonist/blacksuit/team_leader
	name = "Blacksuit Supervisor"
	always_new_team = TRUE
	var/title

/datum/antagonist/blacksuit/on_gain()
	randomize_appearance()
	forge_objectives()
	add_antag_hud(ANTAG_HUD_OPS, "synd", owner.current)
	owner.special_role = src
	equip_blacksuit()
	give_alias()
	return ..()

/datum/antagonist/blacksuit/on_removal()
	..()
	to_chat(owner.current,"<span class='userdanger'>You are no longer in the Special Weapons and Tactics squad!</span>")
	owner.special_role = null

/datum/antagonist/blacksuit/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You're in the Special Weapons and Tactics squad.</span>")
	to_chat(owner, "<span class='notice'>You are a [blacksuit_team ? blacksuit_team.blacksuit_name : "swat"] officer!</span>")
	spawn(3 SECONDS)
	owner.announce_objectives()


/datum/antagonist/blacksuit/proc/give_alias()
	var/my_name = "Tyler"
	var/list/blacksuit_ranks = list("Agent", "Special Agent", "Junior Agent", "Senior Agent")
	var/selected_rank = pick(blacksuit_ranks)
	if(owner.current.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	owner.current.fully_replace_character_name(null,"[selected_rank] [my_name] [my_surname]")

/datum/antagonist/blacksuit/proc/forge_objectives()
	spawn(2 SECONDS)
	if(blacksuit_team)
		objectives |= blacksuit_team.objectives

/datum/antagonist/blacksuit/leader/give_alias()
	var/my_name = "Tyler"
	if(owner.current.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	owner.current.fully_replace_character_name(null,"Supervisor [my_name] [my_surname]")

/datum/team/blacksuit/antag_listing_name()
	if(blacksuit_name)
		return "[blacksuit_name] Officers"
	else
		return "Officers"


/datum/antagonist/blacksuit/leader/greet()
	to_chat(owner, "<B>You are the Supervisor in charge of this mission. You are responsible for guiding your team's operation.</B>")
	to_chat(owner, "<B>If you feel you are not up to this task, give your command to another Agent.</B>")
	spawn(3 SECONDS)
	owner.announce_objectives()

/datum/antagonist/blacksuit/create_team(datum/team/blacksuit/new_team)
	if(!new_team)
		if(!always_new_team)
			for(var/datum/antagonist/swat/N in GLOB.antagonists)
				if(!N.owner)
					stack_trace("Antagonist datum without owner in GLOB.antagonists: [N]")
					continue
		blacksuit_team = new /datum/team/blacksuit
		blacksuit_team.update_objectives()
		return
	if(!istype(blacksuit_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	blacksuit_team = new_team

/datum/antagonist/blacksuit/admin_add(datum/mind/new_owner,mob/admin)
	new_owner.assigned_role = ROLE_BLACKSUIT
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has MIB'd [key_name_admin(new_owner)].")
	log_admin("[key_name(admin)] has MIB'd [key_name(new_owner)].")

/datum/random_gen/blacksuit
	var/hair_colors = list("040404",	//Black
										"120b05",	//Dark Brown
										"342414",	//Brown
										"554433",	//Light Brown
										"695c3b",	//Dark Blond
										"ad924e",	//Blond
										"dac07f",	//Light Blond
										"802400",	//Ginger
										"a5380e",	//Ginger alt
										"ffeace",	//Albino
										"650b0b",	//Punk Red
										"14350e",	//Punk Green
										"080918")	//Punk Blue

	var/male_hair = list("Balding Hair",
										"Bedhead",
										"Bedhead 2",
										"Bedhead 3",
										"Boddicker",
										"Business Hair",
										"Business Hair 2",
										"Business Hair 3",
										"Business Hair 4",
										"Coffee House",
										"Combover",
										"Crewcut",
										"Father",
										"Flat Top",
										"Gelled Back",
										"Joestar",
										"Keanu Hair",
										"Oxton",
										"Volaju")

	var/male_facial = list("Beard (Abraham Lincoln)",
											"Beard (Chinstrap)",
											"Beard (Full)",
											"Beard (Cropped Fullbeard)",
											"Beard (Hipster)",
											"Beard (Neckbeard)",
											"Beard (Three o Clock Shadow)",
											"Beard (Five o Clock Shadow)",
											"Beard (Seven o Clock Shadow)",
											"Moustache (Hulk Hogan)",
											"Moustache (Watson)",
											"Sideburns (Elvis)",
											"Sideburns")

	var/female_hair = list("Ahoge",
										"Long Bedhead",
										"Beehive",
										"Beehive 2",
										"Bob Hair",
										"Bob Hair 2",
										"Bob Hair 3",
										"Bob Hair 4",
										"Bobcurl",
										"Braided",
										"Braided Front",
										"Braid (Short)",
										"Braid (Low)",
										"Bun Head",
										"Bun Head 2",
										"Bun Head 3",
										"Bun (Large)",
										"Bun (Tight)",
										"Double Bun",
										"Emo",
										"Emo Fringe",
										"Feather",
										"Gentle",
										"Long Hair 1",
										"Long Hair 2",
										"Long Hair 3",
										"Long Over Eye",
										"Long Emo",
										"Long Fringe",
										"Ponytail",
										"Ponytail 2",
										"Ponytail 3",
										"Ponytail 4",
										"Ponytail 5",
										"Ponytail 6",
										"Ponytail 7",
										"Ponytail (High)",
										"Ponytail (Short)",
										"Ponytail (Long)",
										"Ponytail (Country)",
										"Ponytail (Fringe)",
										"Poofy",
										"Short Hair Rosa",
										"Shoulder-length Hair",
										"Volaju")

/datum/antagonist/blacksuit/proc/randomize_appearance()
	var/datum/random_gen/blacksuit/h_gen = new
	var/mob/living/carbon/human/H = owner.current
	H.gender = pick(MALE, FEMALE)
	H.body_type = H.gender
	H.age = rand(18, 36)
//	if(age >= 55)
//		hair_color = "a2a2a2"
//		facial_hair_color = hair_color
//	else
	H.hair_color = pick(h_gen.hair_colors)
	H.facial_hair_color = H.hair_color
	if(H.gender == MALE)
		H.hairstyle = pick(h_gen.male_hair)
		if(prob(25) || H.age >= 25)
			H.facial_hairstyle = pick(h_gen.male_facial)
		else
			H.facial_hairstyle = "Shaved"
	else
		H.hairstyle = pick(h_gen.female_hair)
		H.facial_hairstyle = "Shaved"
	H.name = H.real_name
	H.dna.real_name = H.real_name
	var/obj/item/organ/eyes/organ_eyes = H.getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = random_eye_color()
	H.underwear = random_underwear(H.gender)
	if(prob(50))
		H.underwear_color = organ_eyes.eye_color
	if(prob(50) || H.gender == FEMALE)
		H.undershirt = random_undershirt(H.gender)
	if(prob(25))
		H.socks = random_socks()
	H.update_body()
	H.update_hair()
	H.update_body_parts()

/datum/team/blacksuit/proc/rename_team(new_name)
	blacksuit_name = new_name
	name = "[blacksuit_name] Team"

/datum/team/blacksuit
	var/blacksuit_name
	var/core_objective = /datum/objective/blacksuit
	member_name = "Technocracy Agent"
	var/memorized_code
	var/list/team_discounts
	var/obj/item/nuclear_challenge/war_button

/datum/team/blacksuit/New()
	..()
	blacksuit_name = swat_name()

/datum/team/blacksuit/proc/update_objectives()
	if(core_objective)
		var/datum/objective/O = new core_objective
		O.team = src
		objectives += O


/datum/team/blacksuit/roundend_report()
	var/list/parts = list()
	parts += "<span class='header'>[blacksuit_name] Operatives:</span>"

	var/text = "<br><span class='header'>The Men in Black were:</span>"
	text += printplayerlist(members)
	parts += text

	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"




//////////////////////////////////////////////
//                                          //
//       		SWAT (MIDROUND)			    //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_ghosts/blacksuit
	name = "Man in Black"
	antag_flag = ROLE_BLACKSUIT
	antag_datum = /datum/antagonist/blacksuit
	required_candidates = 1
	weight = 5
	cost = 35
	requirements = list(90,90,90,80,60,40,30,20,10,10)
	var/list/operative_cap = list(2,2,3,3,4,5,5,5,5,5)
	var/datum/team/swat/blacksuit_team
	flags = HIGHLANDER_RULESET

/datum/dynamic_ruleset/midround/from_ghosts/blacksuit/acceptable(population=0, threat=0)
	indice_pop = min(operative_cap.len, round(living_players.len/5)+1)
	required_candidates = max(5, operative_cap[indice_pop])
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/blacksuit/ready(forced = FALSE)
	if (required_candidates > (dead_players.len + list_observers.len))
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/blacksuit/finish_setup(mob/new_character, index)
	new_character.mind.special_role = "Blacksuit Agent"
	new_character.mind.assigned_role = "Blacksuit Agent"
	if (index == 1) // Our first guy is the leader
		var/datum/antagonist/blacksuit/leader/new_role = new
		blacksuit_team = new_role.blacksuit_team
		new_character.mind.add_antag_datum(new_role)
	else
		return ..()

