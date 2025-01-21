/*

Difficulty: Hard

*/

/mob/living/simple_animal/hostile/megafauna/wendigo
	name = "Unknown Antediluvian"
	desc = "A mythological legendary kindred, you probably aren't going to survive this."
	health = 9999
	maxHealth = 9999
	icon_state = "eva"
	icon_living = "eva"
	icon_dead = "eva_dead"
	icon = 'icons/mob/32x64.dmi'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/magic/demon_attack1.ogg'
	weather_immunities = list("snow")
	speak_emote = list("roars")
	armour_penetration = 100
	melee_damage_lower = 40
	melee_damage_upper = 40
	vision_range = 9
	aggro_vision_range = 18 // man-eating for a reason
	speed = 8
	move_to_delay = 8
	rapid_melee = 16 // every 1/8 second
	melee_queue_distance = 20 // as far as possible really, need this because of charging and teleports
	ranged = TRUE
	pixel_x = -16
	base_pixel_x = -16
	loot = list()
	butcher_results = list()
	guaranteed_butcher_results = list()
	crusher_loot = list()
	wander = FALSE
	del_on_death = FALSE
	blood_volume = BLOOD_VOLUME_NORMAL
	achievement_type = /datum/award/achievement/boss/wendigo_kill
	crusher_achievement_type = /datum/award/achievement/boss/wendigo_crusher
	score_achievement_type = /datum/award/score/wendigo_score
	deathmessage = "falls, shaking the ground around it"
	deathsound = 'sound/effects/gravhit.ogg'
	footstep_type = FOOTSTEP_MOB_HEAVY
	attack_action_types = list(/datum/action/innate/megafauna_attack/heavy_stomp,
								/datum/action/innate/megafauna_attack/teleport,
								/datum/action/innate/megafauna_attack/disorienting_scream,
								)
	/// Saves the turf the megafauna was created at (spawns exit portal here)
	var/turf/starting
	/// Range for wendigo stomping when it moves
	var/stomp_range = 1
	/// Stores directions the mob is moving, then calls that a move has fully ended when these directions are removed in moved
	var/stored_move_dirs = 0
	/// If the wendigo is allowed to move
	var/can_move = TRUE
	/// Stores the last scream time so it doesn't spam it
	var/last_scream = 0
	var/burst_range = 3 //range on burst aoe
	var/beam_range = 5 //range on cross blast beams
	var/chaser_speed = 3 //how fast chasers are currently
	var/chaser_cooldown = 101 //base cooldown/cooldown var between spawning chasers
	var/major_attack_cooldown = 60 //base cooldown for major attacks
	var/arena_cooldown = 200 //base cooldown/cooldown var for creating an arena
	var/blinking = FALSE //if we're doing something that requires us to stand still and not attac
	var/dashing = FALSE
	var/dash_cooldown = 15

/datum/action/innate/megafauna_attack/heavy_stomp
	name = "Heavy Stomp"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	chosen_message = "<span class='colossus'>You are now stomping the ground around you.</span>"
	chosen_attack_num = 1

/datum/action/innate/megafauna_attack/teleport
	name = "Teleport"
	icon_icon = 'icons/effects/bubblegum.dmi'
	button_icon_state = "smack ya one"
	chosen_message = "<span class='colossus'>You are now teleporting at the target you click on.</span>"
	chosen_attack_num = 2

/datum/action/innate/megafauna_attack/disorienting_scream
	name = "Disorienting Scream"
	icon_icon = 'icons/turf/walls/wall.dmi'
	button_icon_state = "wall-0"
	chosen_message = "<span class='colossus'>You are now screeching, disorienting targets around you.</span>"
	chosen_attack_num = 3

/mob/living/simple_animal/hostile/megafauna/wendigo/Initialize()
	. = ..()
	starting = get_turf(src)
	attributes.stamina = 10

/mob/living/simple_animal/hostile/megafauna/wendigo/OpenFire()
	SetRecoveryTime(0, 100)
	if(health <= maxHealth*0.5)
		stomp_range = 2
		speed = 6
		move_to_delay = 6
	else
		stomp_range = initial(stomp_range)
		speed = initial(speed)
		move_to_delay = initial(move_to_delay)

	var/blink_counter = 1 + round(anger_modifier * 0.08)
	var/cross_counter = 1 + round(anger_modifier * 0.12)

	var/target_slowness = 0
	var/mob/living/L
	if(isliving(target))
		L = target
		target_slowness += L.cached_multiplicative_slowdown
	if(client)
		target_slowness += 1

	target_slowness = max(target_slowness, 1)
	chaser_speed = max(1, (3 - anger_modifier * 0.04) + ((target_slowness - 1) * 0.5))

	if(client)
		switch(chosen_attack)
			if(1)
				heavy_stomp()
			if(2)
				teleport()
			if(3)
				disorienting_scream()
			if(4)
				dash(target)
			if(5)
				fire_rain()
			if(6)
				chaser_swarm(blink_counter, target_slowness, cross_counter)
			if(7)
				alternating_dir_shots()
		return

	chosen_attack = rand(1, 7)
	switch(chosen_attack)
		if(1)
			heavy_stomp()
		if(2)
			teleport()
		if(3)
			disorienting_scream()
		if(4)
			dash(target)
		if(5)
			fire_rain()
		if(6)
			chaser_swarm(blink_counter, target_slowness, cross_counter)
		if(7)
			alternating_dir_shots()

/mob/living/simple_animal/hostile/megafauna/wendigo/proc/alternating_dir_shots()
	ranged_cooldown = world.time + 40
	dir_shots(GLOB.diagonals)
	SLEEP_CHECK_DEATH(10)
	dir_shots(GLOB.cardinals)
	SLEEP_CHECK_DEATH(10)
	dir_shots(GLOB.diagonals)
	SLEEP_CHECK_DEATH(10)
	dir_shots(GLOB.cardinals)

/mob/living/simple_animal/hostile/megafauna/wendigo/proc/shoot_projectile(turf/marker, set_angle)
	if(!isnum(set_angle) && (!marker || marker == loc))
		return
	var/turf/startloc = get_turf(src)
	var/obj/projectile/P = new /obj/projectile/colossus(startloc)
	P.preparePixelProjectile(marker, startloc)
	P.firer = src
	if(target)
		P.original = target
	P.fire(set_angle)

/mob/living/simple_animal/hostile/megafauna/wendigo/proc/dir_shots(list/dirs)
	if(!islist(dirs))
		dirs = GLOB.alldirs.Copy()
//	playsound(src, 'sound/magic/clockwork/invoke_general.ogg', 200, TRUE, 2)
	for(var/d in dirs)
		var/turf/E = get_step(src, d)
		shoot_projectile(E)

/mob/living/simple_animal/hostile/megafauna/wendigo/proc/dash_attack()
	INVOKE_ASYNC(src, PROC_REF(dash), target)
	shoot_ka()

/mob/living/simple_animal/hostile/megafauna/wendigo/proc/shoot_ka()
	if(ranged_cooldown <= world.time && get_dist(src, target) <= 4 && !Adjacent(target))
		ranged_cooldown = world.time + ranged_cooldown_time
		visible_message("<span class='danger'>[src] fires the proto-kinetic accelerator!</span>")
		face_atom(target)
		new /obj/effect/temp_visual/dir_setting/firing_effect(loc, dir)
		Shoot(target)
		changeNext_move(CLICK_CD_RANGE)

/mob/living/simple_animal/hostile/megafauna/wendigo/proc/fire_rain()
	if(!target)
		return
	target.visible_message("<span class='boldwarning'>Fire rains from the sky!</span>")
	for(var/turf/turf in range(9,get_turf(target)))
		if(prob(11))
			new /obj/effect/temp_visual/target(turf)

/mob/living/simple_animal/hostile/megafauna/wendigo/proc/chaser_swarm(blink_counter, target_slowness, cross_counter)
	ranged_cooldown = world.time + max(5, major_attack_cooldown - anger_modifier * 0.75)
	visible_message("<span class='hierophant'>\"Mx gerrsx lmhi.\"</span>")
	blinking = TRUE
	var/oldcolor = color
	animate(src, color = "#660099", time = 6)
	SLEEP_CHECK_DEATH(6)
	var/list/targets = ListTargets()
	var/list/cardinal_copy = GLOB.cardinals.Copy()
	while(targets.len && cardinal_copy.len)
		var/mob/living/pickedtarget = pick(targets)
		if(targets.len >= cardinal_copy.len)
			pickedtarget = pick_n_take(targets)
		if(!istype(pickedtarget) || pickedtarget.stat == DEAD)
			pickedtarget = target
			if(QDELETED(pickedtarget) || (istype(pickedtarget) && pickedtarget.stat == DEAD))
				break //main target is dead and we're out of living targets, cancel out
		var/obj/effect/temp_visual/hierophant/chaser/C = new(loc, src, pickedtarget, chaser_speed, FALSE)
		C.moving = 3
		C.moving_dir = pick_n_take(cardinal_copy)
		SLEEP_CHECK_DEATH(8 + target_slowness)
	chaser_cooldown = world.time + initial(chaser_cooldown)
	animate(src, color = oldcolor, time = 8)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 8)
	SLEEP_CHECK_DEATH(8)
	blinking = FALSE

/mob/living/simple_animal/hostile/megafauna/wendigo/proc/dash(atom/dash_target)
	if(world.time < dash_cooldown)
		return
	var/list/accessable_turfs = list()
	var/self_dist_to_target = 0
	var/turf/own_turf = get_turf(src)
	if(!QDELETED(dash_target))
		self_dist_to_target += get_dist(dash_target, own_turf)
	for(var/turf/open/O in RANGE_TURFS(4, own_turf))
		var/turf_dist_to_target = 0
		if(!QDELETED(dash_target))
			turf_dist_to_target += get_dist(dash_target, O)
		if(get_dist(src, O) >= 4 && turf_dist_to_target <= self_dist_to_target && !islava(O) && !ischasm(O))
			var/valid = TRUE
			for(var/turf/T in getline(own_turf, O))
				if(T.is_blocked_turf(TRUE))
					valid = FALSE
					continue
			if(valid)
				accessable_turfs[O] = turf_dist_to_target
	var/turf/target_turf
	if(!QDELETED(dash_target))
		var/closest_dist = 4
		for(var/t in accessable_turfs)
			if(accessable_turfs[t] < closest_dist)
				closest_dist = accessable_turfs[t]
		for(var/t in accessable_turfs)
			if(accessable_turfs[t] != closest_dist)
				accessable_turfs -= t
	if(!LAZYLEN(accessable_turfs))
		return
	dash_cooldown = world.time + dash_cooldown
	target_turf = pick(accessable_turfs)
	var/turf/step_back_turf = get_step(target_turf, get_cardinal_dir(target_turf, own_turf))
	var/turf/step_forward_turf = get_step(own_turf, get_cardinal_dir(own_turf, target_turf))
	new /obj/effect/temp_visual/small_smoke/halfsecond(step_back_turf)
	new /obj/effect/temp_visual/small_smoke/halfsecond(step_forward_turf)
	var/obj/effect/temp_visual/decoy/fading/halfsecond/D = new (own_turf, src)
	forceMove(step_back_turf)
	playsound(own_turf, 'sound/weapons/punchmiss.ogg', 40, TRUE, -1)
	dashing = TRUE
	alpha = 0
	animate(src, alpha = 255, time = 5)
	SLEEP_CHECK_DEATH(2)
	D.forceMove(step_forward_turf)
	forceMove(target_turf)
	playsound(target_turf, 'sound/weapons/punchmiss.ogg', 40, TRUE, -1)
	SLEEP_CHECK_DEATH(1)
	dashing = FALSE
	return TRUE

/mob/living/simple_animal/hostile/megafauna/wendigo/Life()
	. = ..()
	if(!.)
		return
	if(target || get_dist(src, starting) < 12)
		return
	do_teleport(src, starting, 0,  channel=TELEPORT_CHANNEL_BLUESPACE, forced = TRUE)

/mob/living/simple_animal/hostile/megafauna/wendigo/Move(atom/newloc, direct)
	if(!can_move)
		return
	stored_move_dirs |= direct
	return ..()

/mob/living/simple_animal/hostile/megafauna/wendigo/Moved(atom/oldloc, direct)
	. = ..()
	stored_move_dirs &= ~direct
	if(!stored_move_dirs)
		INVOKE_ASYNC(src, PROC_REF(ground_slam), stomp_range, 1)

/// Slams the ground around the wendigo throwing back enemies caught nearby
/mob/living/simple_animal/hostile/megafauna/wendigo/proc/ground_slam(range, delay)
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(range, orgin)
	for(var/i = 0 to range)
		for(var/turf/T in all_turfs)
			if(get_dist(orgin, T) > i)
				continue
			playsound(T,'sound/effects/bamf.ogg', 600, TRUE, 10)
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)
			for(var/mob/living/L in T)
				if(L == src || L.throwing)
					continue
				to_chat(L, "<span class='userdanger'>[src]'s ground slam shockwave sends you flying!</span>")
				var/turf/thrownat = get_ranged_target_turf_direct(src, L, 8, rand(-10, 10))
				L.throw_at(thrownat, 8, 2, src, TRUE, force = MOVE_FORCE_OVERPOWERING, gentle = TRUE)
				L.apply_damage(20, BRUTE, wound_bonus=CANT_WOUND)
				shake_camera(L, 2, 1)
			all_turfs -= T
		sleep(delay)

/// Larger but slower ground stomp
/mob/living/simple_animal/hostile/megafauna/wendigo/proc/heavy_stomp()
	can_move = FALSE
	ground_slam(5, 2)
	SetRecoveryTime(0, 0)
	can_move = TRUE

/// Teleports to a location 4 turfs away from the enemy in view
/mob/living/simple_animal/hostile/megafauna/wendigo/proc/teleport()
	var/list/possible_ends = list()
	for(var/turf/T in view(4, target.loc) - view(3, target.loc))
		if(isclosedturf(T))
			continue
		possible_ends |= T
	if (LAZYLEN(possible_ends))
		var/turf/end = pick(possible_ends)
		do_teleport(src, end, 0,  channel=TELEPORT_CHANNEL_BLUESPACE, forced = TRUE)
		SetRecoveryTime(20, 0)

/// Applies dizziness to all nearby enemies that can hear the scream and animates the wendigo shaking up and down
/mob/living/simple_animal/hostile/megafauna/wendigo/proc/disorienting_scream()
	can_move = FALSE
	last_scream = world.time
	playsound(src, pick('code/modules/wod13/sounds/mp_judgement.ogg', 'code/modules/wod13/sounds/mp_die.ogg', 'code/modules/wod13/sounds/mp_end.ogg'), 600, FALSE, 10)
	animate(src, pixel_z = rand(5, dash_cooldown), time = 1, loop = 6)
	animate(pixel_z = 0, time = 1)
	for(var/mob/living/L in get_hearers_in_view(7, src) - src)
		L.Dizzy(6)
		to_chat(L, "<span class='danger'>[src] screams loudly!</span>")
	SetRecoveryTime(30, 0)
	SLEEP_CHECK_DEATH(12)
	can_move = TRUE
	teleport()

/mob/living/simple_animal/hostile/megafauna/wendigo/death(gibbed, list/force_grant)
	if(health > 0)
		return
//	var/obj/effect/portal/permanent/one_way/exit = new /obj/effect/portal/permanent/one_way(starting)
//	exit.id = "wendigo arena exit"
//	exit.add_atom_colour(COLOR_RED_LIGHT, ADMIN_COLOUR_PRIORITY)
//	exit.set_light(20, 1, COLOR_SOFT_RED)
	return ..()

/obj/item/wendigo_blood
	name = "bottle of wendigo blood"
	desc = "You're not actually going to drink this, are you?"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "vial"

/obj/item/wendigo_blood/attack_self(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		return
	to_chat(H, "<span class='danger'>Power courses through you! You can now shift your form at will.</span>")
	var/obj/effect/proc_holder/spell/targeted/shapeshift/polar_bear/P = new
	H.mind.AddSpell(P)
	playsound(H.loc,'sound/items/drink.ogg', rand(10,50), TRUE)
	qdel(src)

/obj/effect/proc_holder/spell/targeted/shapeshift/polar_bear
	name = "Polar Bear Form"
	desc = "Take on the shape of a polar bear."
	invocation = "RAAAAAAAAWR!"
	convert_damage = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/asteroid/polarbear/lesser
