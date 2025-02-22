/mob/living/simple_animal/hostile/retaliate/spaceman
	name = "Spaceman"
	desc = "What in the actual hell..?"
	icon_state = "old"
	icon_living = "old"
	icon_dead = "old_dead"
	icon_gib = "clown_gib"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	gender = MALE
	turns_per_move = 5
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"
	a_intent = INTENT_HARM
	maxHealth = 100
	health = 100
	speed = 0
	harm_intent_damage = 8
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_continuous = "hits"
	attack_verb_simple = "hit"
	attack_sound = 'sound/weapons/punch1.ogg'
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	del_on_death = 0
	footstep_type = FOOTSTEP_MOB_SHOE

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace //this should be in a different file
	name = "\improper Nanotrasen Private Security Officer"
	desc = "An officer part of Nanotrasen's private security force."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "nanotrasen"
	icon_living = "nanotrasen"
	icon_dead = null
	icon_gib = "syndicate_gib"
	turns_per_move = 5
	speed = 0
	stat_attack = HARD_CRIT
	robust_searching = 1
	vision_range = 3
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	faction = list("nanotrasenprivate")
	a_intent = INTENT_HARM
	loot = list(/obj/effect/mob_spawn/human/corpse/nanotrasensoldier)
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 15
	status_flags = CANPUSH
	search_objects = 1

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/Aggro()
	..()
	summon_backup(15)
	say("411 in progress, requesting backup!")

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/ranged
	icon_state = "nanotrasenrangedsmg"
	icon_living = "nanotrasenrangedsmg"
	vision_range = 9
	rapid = 3
	ranged = 1
	retreat_distance = 3
	minimum_distance = 5
	casingtype = /obj/item/ammo_casing/c46x30mm
	projectilesound = 'sound/weapons/gun/smg/shot.ogg'
	loot = list(/obj/item/gun/ballistic/automatic/wt550,
				/obj/effect/mob_spawn/human/corpse/nanotrasensoldier)

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire
	name = "SWAT Soldier"
	desc = "An officer part of SFPD's private security force."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "swat"
	icon_living = "swat"
	icon_dead = "swat_dead"
	del_on_death = 1
	footstep_type = FOOTSTEP_MOB_SHOE
	vision_range = 9
	rapid = 3
	ranged = TRUE
	maxHealth = 500
	health = 500
	retreat_distance = 3
	minimum_distance = 5
	casingtype = /obj/item/ammo_casing/vampire/c556mm
	projectilesound = 'code/modules/wod13/sounds/rifle.ogg'
	loot = list()
	faction = list("Police")
	var/time_created = 0
	var/last_seen_time = 0

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/Initialize()
	. = ..()
	time_created = world.time
	if(prob(10))
		ranged = FALSE
		name = "SWAT Brute"
		desc = "He can handcuff you."
		icon_state = "swat_melee"
		icon_living = "swat_melee"
		maxHealth = 600
		health = 600
		retreat_distance = 0
		minimum_distance = 0

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/Life()
	if(stat != DEAD)
		for(var/mob/living/carbon/human/E in enemies)
			if(Adjacent(E) && E.canBeHandcuffed() && !E.handcuffed)
				cuff(E)
				return
		if(time_created+600 < world.time)
			leave()
		if(enemies.len)
			for(var/mob/living/carbon/human/E in enemies)
				if(E.stat == UNCONSCIOUS || E.stat == DEAD || (world.time - last_seen_time > 20 SECONDS))
					leave()
	..()

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/Destroy()
	new /obj/effect/temp_visual/desant_back(loc)
	..()

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/proc/leave()
	new /obj/effect/temp_visual/desant_back(loc)
	playsound(loc, 'code/modules/wod13/sounds/helicopter.ogg', 50, TRUE)
	qdel(src)
	return

/obj/effect/temp_visual/desant
	name = "helicopter rope"
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "swat"
	duration = 7

/obj/effect/temp_visual/desant/Destroy()
	var/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/V = new(loc)
//	V.enemies |= GLOB.fuckers
	V.Retaliate()
	for(var/mob/living/carbon/human/H in oviewers(9, src))
		if(H)
			if(H.warrant)
				V.GiveTarget(H)
	..()

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/Retaliate()
	for(var/mob/living/carbon/human/H in oviewers(9, src))
		if(H)
			if(H.warrant)
				enemies |= H
				last_seen_time = world.time
	for(var/mob/living/simple_animal/hostile/T in oviewers(9, src))
		if(T)
			if(!istype(T, /mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire))
				enemies |= T

/obj/effect/temp_visual/desant_back
	name = "helicopter rope"
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "swat_back"
	duration = 7

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/UnarmedAttack(atom/A)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		if(C.canBeHandcuffed() && !C.handcuffed)
			cuff(A)
			return
		else
			..()
	else
		..()

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/proc/cuff(mob/living/carbon/C)
	playsound(src, 'sound/weapons/cablecuff.ogg', 30, TRUE, -2)
	C.visible_message("<span class='danger'>[src] is trying to put zipties on [C]!</span>",\
						"<span class='userdanger'>[src] is trying to put zipties on you!</span>")
	addtimer(CALLBACK(src, PROC_REF(attempt_handcuff), C), 4 SECONDS)

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/proc/attempt_handcuff(mob/living/carbon/C)
	if( !Adjacent(C) || !isturf(C.loc) ) //if he's in a closet or not adjacent, we cancel cuffing.
		return
	if(!C.handcuffed)
		C.set_handcuffed(new /obj/item/restraints/handcuffs/cable/zipties/used(C))
		C.update_handcuffed()


/mob/living/simple_animal/hostile/retaliate/dementia
	name = "Literally Me"
	desc = "Literally me..."
	turns_per_move = 5
	speed = 0
	stat_attack = HARD_CRIT
	robust_searching = 1
	vision_range = 3
	maxHealth = 1
	health = 1
	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	faction = list("Malkavian")
	a_intent = INTENT_HARM
	loot = list()
	del_on_death = 1
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 15
	status_flags = CANPUSH
	search_objects = 1

/mob/living/simple_animal/hostile/retaliate/dementia/Retaliate()
	for(var/mob/living/carbon/human/H in oviewers(9, src))
		if(H)
			if(H.dementia)
				var/image/I = image(icon = 'icons/mob/simple_human.dmi', icon_state = "skeleton", layer = ABOVE_MOB_LAYER, loc = src)
				I.override = 1
				I.appearance = H.appearance
				H.client.images += I
				enemies |= H
				spawn(20)
					H.client.images -= I
					qdel(src)
