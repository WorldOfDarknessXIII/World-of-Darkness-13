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
		var/mob/living/carbon/living_target = target
		if(Adjacent(living_target) && living_target.canBeHandcuffed() && !living_target.handcuffed)
			cuff(living_target)
			return
		if(time_created+600 < world.time)
			leave()
		if(living_target)
			if(living_target.stat == UNCONSCIOUS || living_target.stat == DEAD || (world.time - last_seen_time > 20 SECONDS))
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
	V.Retaliate()
	for(var/mob/living/carbon/human/H in oviewers(9, src))
		if(H)
			if(H.warrant)
				V.GiveTarget(H)
	..()

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/proc/Retaliate()
	for(var/mob/living/carbon/human/H in oviewers(9, src))
		if(H)
			if(H.warrant)
				target = H
				last_seen_time = world.time
	for(var/mob/living/simple_animal/hostile/T in oviewers(9, src))
		if(T)
			if(!istype(T, /mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire))
				target = T

/obj/effect/temp_visual/desant_back
	name = "helicopter rope"
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "swat_back"
	duration = 7

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	if(iscarbon(attack_target))
		var/mob/living/carbon/C = attack_target
		if(C.canBeHandcuffed() && !C.handcuffed)
			cuff(C)
			return
		else
			..()
	else
		..()

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/proc/cuff(mob/living/carbon/C)
	playsound(src, 'sound/items/weapons/cablecuff.ogg', 30, TRUE, -2)
	C.visible_message("<span class='danger'>[src] is trying to put zipties on [C]!</span>",\
						"<span class='userdanger'>[src] is trying to put zipties on you!</span>")
	addtimer(CALLBACK(src, PROC_REF(attempt_handcuff), C), 4 SECONDS)

/mob/living/simple_animal/hostile/retaliate/nanotrasenpeace/vampire/proc/attempt_handcuff(mob/living/carbon/C)
	if(!Adjacent(C) || !isturf(C.loc) ) //if he's in a closet or not adjacent, we cancel cuffing.
		return
	if(!C.handcuffed)
		C.set_handcuffed(new /obj/item/restraints/handcuffs/cable/zipties/used(C))
		C.update_handcuffed()
