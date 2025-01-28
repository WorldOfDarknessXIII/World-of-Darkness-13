/mob/living/simple_animal/hostile/bear/wod13
	name = "bear"
	desc = "IS THAT A FUCKING BEAR-"
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "bear"
	icon_living = "bear"
	icon_dead = "bear_dead"
	emote_hear = list("roars.")
	emote_see = list("shakes its head.", "stomps.")
	speak_chance = 0
	turns_per_move = 5
	see_in_dark = 6
	del_on_death = 0
	butcher_results = list(/obj/item/food/meat/slab = 7)
	response_help_continuous = "pokes"
	response_help_simple = "poke"
	response_disarm_continuous = "gently pushes"
	response_disarm_simple = "gently push"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"
	can_be_held = FALSE
	density = FALSE
	anchored = FALSE
	footstep_type = FOOTSTEP_MOB_CLAW

	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 8
	maxbloodpool = 8
	del_on_death = 1
	maxHealth = 500
	health = 500
	cached_multiplicative_slowdown = 2

	melee_damage_lower = 50
	melee_damage_upper = 60 //Good luck lol
