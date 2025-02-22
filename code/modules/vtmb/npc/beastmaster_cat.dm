/mob/living/simple_animal/hostile/beastmaster/cat
	name = "cat"
	desc = "Kitty!!"
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	speak = list("Meow!", "Esp!", "Purr!", "HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows.", "mews.")
	emote_see = list("shakes its head.", "shivers.")
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'code/modules/wod13/sounds/cat.ogg'
	speak_chance = 0
	turns_per_move = 3
	see_in_dark = 6
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 1
	animal_species = /mob/living/basic/pet/cat
	childtype = list(/mob/living/basic/pet/cat/kitten)
	butcher_results = list(/obj/item/food/meat/slab = 1, /obj/item/organ/ears/cat = 1, /obj/item/organ/tail/cat = 1, /obj/item/stack/sheet/animalhide/cat = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	///Limits how often cats can spam chasing mice.
	emote_cooldown = 0
	///Can this cat catch special mice?
	inept_hunter = FALSE
	gold_core_spawnable = FRIENDLY_SPAWN
	can_be_held = TRUE
	held_state = "cat2"

	footstep_type = FOOTSTEP_MOB_CLAW
	bloodpool = 1
	maxbloodpool = 1
	maxHealth = 30
	health = 30
	harm_intent_damage = 20
	melee_damage_lower = 15
	melee_damage_upper = 30
	speed = -0.1
	dodging = TRUE

/mob/living/simple_animal/hostile/beastmaster/cat/Initialize()
	. = ..()
	var/id = rand(1, 7)
	icon_state = "cat[id]"
	icon_living = "cat[id]"
	icon_dead = "cat[id]_dead"
