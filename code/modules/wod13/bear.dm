/mob/living/simple_animal/hostile/bear/wod13
	name = "bear"
	desc = "IS THAT A FUCKING BEAR-"
	icon = 'code/modules/wod13/64x64.dmi'
	emote_hear = list("roars.")
	emote_see = list("shakes its head.", "stomps.")
	butcher_results = list(/obj/item/food/meat/slab = 7)
	response_help_continuous = "pokes"
	response_help_simple = "poke"
	response_disarm_continuous = "gently pushes"
	response_disarm_simple = "gently push"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"

	bloodpool = 1
	maxbloodpool = 1
	maxHealth = 850
	health = 850
	cached_multiplicative_slowdown = 2

	melee_damage_lower = 50
	melee_damage_upper = 60 //Good luck lol
