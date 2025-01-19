/obj/item/ammo_casing/proc/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, atom/fired_from, successes)
	distro += variance
	var/targloc = get_turf(target)
	var/actual_spread = 0
	if(successes == 0)
		actual_spread = pick(-rand(45, 90), rand(45, 90))
	if(successes == 1)
		actual_spread = rand(-45, 45)
	if(successes == 2)
		actual_spread = rand(-23, 23)
	if(successes == 3)
		actual_spread = rand(-12, 12)

	ready_proj(target, user, quiet, zone_override, fired_from)
	if(pellets == 1)
		if(distro) //We have to spread a pixel-precision bullet. throw_proj was called before so angles should exist by now...
			if(randomspread)
				spread = round((rand() - 0.5) * distro)
			else //Smart spread
				spread = round(1 - 0.5) * distro
		if(successes > 4)
			spread = 0
		if(actual_spread != 0)
			if(!throw_proj(target, targloc, user, params, actual_spread))
				return FALSE
		else if(!throw_proj(target, targloc, user, params, spread))
			return FALSE

	else
		if(isnull(BB))
			return FALSE
		AddComponent(/datum/component/pellet_cloud, projectile_type, pellets)
		SEND_SIGNAL(src, COMSIG_PELLET_CLOUD_INIT, target, user, fired_from, randomspread, spread, zone_override, params, distro)

	if(click_cooldown_override)
		if(click_cooldown_override > CLICK_CD_RAPID)
			if(user.no_fire_delay)
				user.changeNext_move(max(CLICK_CD_RAPID, round(click_cooldown_override/2)))
			else
				user.changeNext_move(click_cooldown_override)
		else
			user.changeNext_move(click_cooldown_override)
	else
		user.changeNext_move(11-get_a_dexterity(user))
	user.newtonian_move(get_dir(target, user))
	update_icon()
	return TRUE

/obj/item/ammo_casing/proc/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	if (!BB)
		return
	BB.original = target
	BB.firer = user
	BB.fired_from = fired_from
	if (zone_override)
		BB.def_zone = zone_override
	else
		BB.def_zone = user.zone_selected
	BB.suppressed = quiet

	if(isgun(fired_from))
		var/obj/item/gun/G = fired_from
		BB.damage *= G.projectile_damage_multiplier

	if(reagents && BB.reagents)
		reagents.trans_to(BB, reagents.total_volume, transfered_by = user) //For chemical darts/bullets
		qdel(reagents)

/obj/item/ammo_casing/proc/throw_proj(atom/target, turf/targloc, mob/living/user, params, spread)
	var/turf/curloc = get_turf(user)
	if (!istype(targloc) || !istype(curloc) || !BB)
		return FALSE

	var/firing_dir
	if(BB.firer)
		firing_dir = BB.firer.dir
	if(!BB.suppressed && firing_effect_type)
		var/witness_count
		for(var/mob/living/carbon/human/npc/NEPIC in viewers(7, usr))
			if(NEPIC && NEPIC.stat != DEAD)
				witness_count++
			if(witness_count > 1)
				for(var/obj/item/police_radio/P in GLOB.police_radios)
					P.announce_crime("shooting", get_turf(user))
				for(var/obj/item/p25radio/police/P in GLOB.p25_radios)
					if(P.linked_network == "police")
						P.announce_crime("shooting", get_turf(user))
		var/atom/A = new firing_effect_type(get_turf(src), firing_dir)
		var/matrix/M = matrix()
		M.Turn(get_angle_raw(user.x, user.y, 0, 0, target.x, target.y, 0, 0))
		A.transform = M
		A.layer = ABOVE_LIGHTING_LAYER
		A.plane = ABOVE_LIGHTING_PLANE
//		var/atom/movable/shit = new(A.loc)
		var/atom/movable/firing_overlay = new (get_turf(user))
		firing_overlay.icon = 'icons/effects/light_overlays/firing_light.dmi'
		firing_overlay.icon_state = "light"
		firing_overlay.layer = O_LIGHTING_VISUAL_LAYER
		firing_overlay.plane = O_LIGHTING_VISUAL_PLANE
		firing_overlay.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
		firing_overlay.color = "#ffedbb"
		firing_overlay.pixel_x = -32
		firing_overlay.pixel_y = -32
//			shit.set_light(3, 2, "#ffedbb")
//			animate(firing_overlay, alpha = 0, time = 2)
		spawn(5)
			qdel(firing_overlay)
//				qdel(shit)

	var/direct_target
	if(targloc == curloc)
		if(target) //if the target is right on our location we'll skip the travelling code in the proj's fire()
			direct_target = target
	if(!direct_target)
		BB.preparePixelProjectile(target, user, params, spread)
	BB.fire(null, direct_target)
	BB = null
	return TRUE

/obj/item/ammo_casing/proc/spread(turf/target, turf/current, distro)
	var/dx = abs(target.x - current.x)
	var/dy = abs(target.y - current.y)
	return locate(target.x + round(gaussian(0, distro) * (dy+2)/8, 1), target.y + round(gaussian(0, distro) * (dx+2)/8, 1), target.z)
