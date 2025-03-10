/datum/discipline/necromancy
	name = "Necromancy"
	desc = "Offers control over another, undead reality."
	icon_state = "necromancy"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/necromancy

/datum/discipline/necromancy/post_gain()
	. = ..()
	owner.faction |= "Giovanni"

/datum/discipline_power/necromancy
	name = "Necromancy power name"
	desc = "Necromancy power description"

	activate_sound = 'code/modules/wod13/sounds/necromancy.ogg'

//SEAL OF ABAMIXTRA
/datum/discipline_power/necromancy/seal_of_abamixtra
	name = "Seal of Abamixtra"
	desc = "Raise your enemies as ghosts under your command."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB
	range = 2

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/seal_of_abamixtra,
		/datum/discipline_power/necromancy/shambling_hordes,
		/datum/discipline_power/necromancy/baleful_exorcism,
		/datum/discipline_power/necromancy/daemonic_possession
	)

/datum/discipline_power/necromancy/seal_of_abamixtra/activate(mob/living/target)
	. = ..()
	var/limit = 1 + owner.social + owner.more_companions - 1
	if(length(owner.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/beast = pick(owner.beastmaster)
		beast.death()

	if (target.stat == DEAD)
		if(!length(owner.beastmaster))
			var/datum/action/beastmaster_stay/stay_action = new()
			stay_action.Grant(owner)
			var/datum/action/beastmaster_deaggro/deaggro_action = new()
			deaggro_action.Grant(owner)

		var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/zombie = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level1(owner.loc)
		zombie.my_creator = owner
		owner.beastmaster |= zombie
		zombie.beastmaster = owner
		qdel(target)
	else
		target.apply_damage(5, BRUTE, owner.zone_selected)
		target.apply_damage(6, CLONE, owner.zone_selected)
		target.emote("scream")

//AWAKEN THE HOMUNCULAR SERVANT
/datum/discipline_power/necromancy/awaken_the_homuncular_servant
	name = "Awaken the Homuncular Servant"
	desc = "Raise your enemies as reinforced zombies under your command."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB
	range = 2

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/seal_of_abamixtra,
		/datum/discipline_power/necromancy/shambling_hordes,
		/datum/discipline_power/necromancy/baleful_exorcism,
		/datum/discipline_power/necromancy/daemonic_possession
	)

/datum/discipline_power/necromancy/awaken_the_homuncular_servant/activate(mob/living/target)
	. = ..()
	var/limit = 2 + owner.social + owner.more_companions - 1
	if(length(owner.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/beast = pick(owner.beastmaster)
		beast.death()

	if (target.stat == DEAD)
		if(!length(owner.beastmaster))
			var/datum/action/beastmaster_stay/stay_action = new()
			stay_action.Grant(owner)
			var/datum/action/beastmaster_deaggro/deaggro_action = new()
			deaggro_action.Grant(owner)

		var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/zombie = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level2(owner.loc)
		zombie.my_creator = owner
		owner.beastmaster |= zombie
		zombie.beastmaster = owner
		qdel(target)
	else
		target.apply_damage(10, BRUTE, owner.zone_selected)
		target.apply_damage(12, CLONE, owner.zone_selected)
		target.emote("scream")

/datum/discipline_power/necromancy/awaken_the_homuncular_servant/post_gain()
	. = ..()
	var/datum/action/ghost_hear/see_ghosts = new()
	see_ghosts.Grant(owner)

/datum/action/ghost_hear
	name = "See Ghosts"
	desc = "Allows you to see ghosts."
	button_icon_state = "ghost"
	check_flags = AB_CHECK_HANDS_BLOCKED | AB_CHECK_IMMOBILE | AB_CHECK_LYING | AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/datum/timedevent/loop_timer
	var/duration_length = 15 SECONDS

/datum/action/ghost_hear/Trigger()
	. = ..()
	if (loop_timer)
		deactivate()
	else
		activate()

/datum/action/ghost_hear/proc/activate()
	if(!isliving(owner))
		return
	var/mob/living/user = owner
	if (user.bloodpool < 1)
		to_chat(owner, span_warning("You don't have enough blood to peek into the Shadowlands!"))
		return
	user.bloodpool = max(user.bloodpool - 1, 0)

	loop_timer = addtimer(CALLBACK(src, PROC_REF(refresh)), duration_length, TIMER_STOPPABLE | TIMER_DELETE_ME)
	user.see_invisible = SEE_INVISIBLE_OBSERVER
	to_chat(owner, span_notice("You peek beyond the Shroud to see ghosts."))

/datum/action/ghost_hear/proc/deactivate()
	if(!isliving(owner))
		return
	var/mob/living/user = owner

	deltimer(loop_timer)
	loop_timer = null
	user.see_invisible = initial(owner.see_invisible)
	to_chat(owner, span_warning("Your vision returns to the mortal realm."))

/datum/action/ghost_hear/proc/refresh()
	if(!isliving(owner))
		return
	var/mob/living/user = owner

	if (user.bloodpool >= 1)
		user.bloodpool = max(user.bloodpool - 1, 0)
		to_chat(owner, span_warning("Your ghost sight consumes blood to stay active..."))
		loop_timer = addtimer(CALLBACK(src, PROC_REF(refresh)), duration_length, TIMER_STOPPABLE | TIMER_DELETE_ME)
	else
		deactivate()

//SHAMBLING HORDES
/datum/discipline_power/necromancy/shambling_hordes
	name = "Shambling Hordes"
	desc = "Raise your enemies as upgraded zombies under your command."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB
	range = 2

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/seal_of_abamixtra,
		/datum/discipline_power/necromancy/awaken_the_homuncular_servant,
		/datum/discipline_power/necromancy/baleful_exorcism,
		/datum/discipline_power/necromancy/daemonic_possession
	)

/datum/discipline_power/necromancy/shambling_hordes/activate(mob/living/target)
	. = ..()
	var/limit = 3 + owner.social + owner.more_companions - 1
	if(length(owner.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/beast = pick(owner.beastmaster)
		beast.death()

	if (target.stat == DEAD)
		if(!length(owner.beastmaster))
			var/datum/action/beastmaster_stay/stay_action = new()
			stay_action.Grant(owner)
			var/datum/action/beastmaster_deaggro/deaggro_action = new()
			deaggro_action.Grant(owner)

		var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/zombie = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level3(owner.loc)
		zombie.my_creator = owner
		owner.beastmaster |= zombie
		zombie.beastmaster = owner
		qdel(target)
	else
		target.apply_damage(15, BRUTE, owner.zone_selected)
		target.apply_damage(18, CLONE, owner.zone_selected)
		target.emote("scream")

//BALEFUL EXORCISM
/datum/discipline_power/necromancy/baleful_exorcism
	name = "Baleful Exorcism"
	desc = "Raise your enemies as skeletons under your command."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB
	range = 2

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/seal_of_abamixtra,
		/datum/discipline_power/necromancy/awaken_the_homuncular_servant,
		/datum/discipline_power/necromancy/shambling_hordes,
		/datum/discipline_power/necromancy/daemonic_possession
	)

/datum/discipline_power/necromancy/baleful_exorcism/activate(mob/living/target)
	. = ..()
	var/limit = 4 + owner.social + owner.more_companions - 1
	if(length(owner.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/beast = pick(owner.beastmaster)
		beast.death()

	if (target.stat == DEAD)
		if(!length(owner.beastmaster))
			var/datum/action/beastmaster_stay/stay_action = new()
			stay_action.Grant(owner)
			var/datum/action/beastmaster_deaggro/deaggro_action = new()
			deaggro_action.Grant(owner)

		var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/zombie = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level4(owner.loc)
		zombie.my_creator = owner
		owner.beastmaster |= zombie
		zombie.beastmaster = owner
		qdel(target)
	else
		target.apply_damage(20, BRUTE, owner.zone_selected)
		target.apply_damage(24, CLONE, owner.zone_selected)
		target.emote("scream")

//DAEMONIC POSSESSION
/datum/discipline_power/necromancy/daemonic_possession
	name = "Daemonic Possession"
	desc = "Raise your enemies as powerful zombies under your command."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB
	range = 2

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/seal_of_abamixtra,
		/datum/discipline_power/necromancy/awaken_the_homuncular_servant,
		/datum/discipline_power/necromancy/shambling_hordes,
		/datum/discipline_power/necromancy/baleful_exorcism
	)

/datum/discipline_power/necromancy/daemonic_possession/activate(mob/living/target)
	. = ..()
	var/limit = 5 + owner.social + owner.more_companions - 1
	if(length(owner.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/beast = pick(owner.beastmaster)
		beast.death()

	if (target.stat == DEAD)
		if(!length(owner.beastmaster))
			var/datum/action/beastmaster_stay/stay_action = new()
			stay_action.Grant(owner)
			var/datum/action/beastmaster_deaggro/deaggro_action = new()
			deaggro_action.Grant(owner)

		var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/zombie = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level5(owner.loc)
		zombie.my_creator = owner
		owner.beastmaster |= zombie
		zombie.beastmaster = owner
		qdel(target)
	else
		target.apply_damage(25, BRUTE, owner.zone_selected)
		target.apply_damage(30, CLONE, owner.zone_selected)
		target.emote("scream")
