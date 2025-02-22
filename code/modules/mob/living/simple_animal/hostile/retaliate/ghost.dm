/mob/living/simple_animal/hostile/ghost
	name = "ghost"
	desc = "A soul of the dead, spooky."
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	icon_living = "ghost"
	mob_biotypes = MOB_SPIRIT
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "passes through"
	response_help_simple = "pass through"
	a_intent = INTENT_HARM
	healable = 0
	speed = 0
	maxHealth = 40
	health = 40
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 15
	del_on_death = 1
	emote_see = list("weeps silently", "groans", "mumbles")
	attack_verb_continuous = "grips"
	attack_verb_simple = "grip"
	attack_sound = 'sound/hallucinations/growl1.ogg'
	speak_emote = list("weeps")
	deathmessage = "wails, disintegrating into a pile of ectoplasm!"
	loot = list(/obj/item/ectoplasm)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	is_flying_animal = TRUE
	pressure_resistance = 300
	gold_core_spawnable = NO_SPAWN //too spooky for science
	light_system = MOVABLE_LIGHT
	light_range = 1 // same glowing as visible player ghosts
	light_power = 2
	faction = list("Giovanni")
	bloodpool = 0
	maxbloodpool = 0

/mob/living/simple_animal/hostile/ghost/hostile
	faction = list("hostile")

/mob/living/simple_animal/hostile/ghost/Initialize()
	. = ..()
	switch(rand(0,1))
		if(0)
			name = "ghost of [pick(GLOB.first_names_male)] [pick(GLOB.last_names)]"
		if(1)
			name = "ghost of [pick(GLOB.first_names_female)] [pick(GLOB.last_names)]"
