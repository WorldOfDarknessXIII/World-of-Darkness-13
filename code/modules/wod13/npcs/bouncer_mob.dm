/mob/living/carbon/human/npc/bouncer

	//Assigns an ID to NPCs that guard certain doors, must match a barrier's ID
	var/protected_zone_id = "test"

	var/list/denial_phrases = list("I HAVE NO DENIAL PHRASE")
	var/list/entry_phrases = list("I HAVE NO ENTRY PHRASE")
	var/list/police_block_phrases = list("I HAVE NO POLICE BAN PHRASE")
	var/list/block_phrases = list("I HAVE NO BLOCK PHRASE")
	var/list/unmask_phrases = list("I HAVE NO UNMASK PHRASE")

	staying = TRUE

	var/left_home_at = 0
	var/walk_home_timer = 2 MINUTES
	var/warp_home_timer = 30 SECONDS


	var/datum/vip_barrier_perm/linked_perm = null

	var/message_cooldown = 0
	var/repeat_delay = 8 SECONDS
	var/resume_neutral_direction_delay = 4 SECONDS

	var/is_dominated = FALSE //Whether or not the man is dominated
	var/is_in_awe = FALSE //Whether or not the man is being hit by presence

	var/turf/start_turf = null //Where the creature spawns so it can return from whence it came
	var/our_role = /datum/socialrole/bouncer

	var/default_direction = 1 //Allows mappers to set the bouncer's regular orientation with dir.

	tolerates_ugly = TRUE

	var/is_guarding = TRUE

	my_weapon_type = /obj/item/gun/ballistic/shotgun/vampire
	my_backup_weapon_type = /obj/item/melee/classic_baton/vampire

	//Behavior settings
	fights_anyway=TRUE

/mob/living/carbon/human/npc/bouncer/Initialize()
	.=..()

	if(src.type == /mob/living/carbon/human/npc/bouncer)
		CRASH("Bouncer created using default type, please use a child of this type in mapping.")


	AssignSocialRole(our_role)

	start_turf = get_turf(src)

	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(yearn_for_home))
	RegisterSignal(src, COMSIG_MOB_STATCHANGE, PROC_REF(stat_change_process_is_guarding))

	if(SSbouncer_barriers.vip_barrier_perms?[protected_zone_id])
		linked_perm = SSbouncer_barriers.vip_barrier_perms[protected_zone_id]
		linked_perm.add_bouncer(src)
	else if(SSbouncer_barriers.initialized)
		CRASH("A Bouncer was created for vip_barrier_perms that were not loaded!")

/mob/living/carbon/human/npc/bouncer/LateInitialize()
	default_direction = dir

/mob/living/carbon/human/npc/bouncer/on_knockedout_trait_gain(datum/source)
	..()
	set_is_guarding_false()

/mob/living/carbon/human/npc/bouncer/on_immobilized_trait_gain(datum/source)
	..()
	set_is_guarding_false()

/mob/living/carbon/human/npc/bouncer/on_restrained_trait_gain(datum/source)
	..()
	set_is_guarding_false()

/mob/living/carbon/human/npc/bouncer/on_knockedout_trait_loss(datum/source)
	..()
	set_is_guarding_true()

/mob/living/carbon/human/npc/bouncer/on_immobilized_trait_loss(datum/source)
	..()
	set_is_guarding_true()

/mob/living/carbon/human/npc/bouncer/on_restrained_trait_loss(datum/source)
	..()
	set_is_guarding_true()


/mob/living/carbon/human/npc/bouncer/AssignSocialRole(datum/socialrole/bouncer/role, var/dont_random = FALSE)
	. = ..(role, dont_random)

	if(role && ispath(role, /datum/socialrole/bouncer))
		var/datum/socialrole/bouncer/social_role = new role()
		denial_phrases = social_role.denial_phrases
		entry_phrases = social_role.entry_phrases
		police_block_phrases = social_role.police_block_phrases
		block_phrases = social_role.block_phrases
		unmask_phrases = social_role.unmask_phrases
		my_weapon_type = social_role.bouncer_weapon_type
		my_backup_weapon_type = social_role.bouncer_backup_weapon_type

/mob/living/carbon/human/npc/bouncer/proc/stat_change_process_is_guarding(datum/source, statchange)
	if(statchange >= HARD_CRIT)
		is_guarding = FALSE
		if(statchange == DEAD)
			linked_perm.process_dead_bouncer(src)
	else if (!HAS_TRAIT(src, TRAIT_RESTRAINED) && !HAS_TRAIT(src, TRAIT_KNOCKEDOUT) && !HAS_TRAIT(src, TRAIT_IMMOBILIZED))
		is_guarding = TRUE
		go_home()
	else
		return
	linked_perm.check_barrier_guarded()

/mob/living/carbon/human/npc/bouncer/proc/set_is_guarding_true(datum/source)
	if(stat >= HARD_CRIT)
		return
	is_guarding = TRUE
	go_home()
	linked_perm.check_barrier_guarded()

/mob/living/carbon/human/npc/bouncer/proc/set_is_guarding_false(datum/source)
	is_guarding = FALSE
	linked_perm.check_barrier_guarded()


//when the bouncer moves, they try to return home after awhile
/mob/living/carbon/human/npc/bouncer/proc/yearn_for_home()
	SIGNAL_HANDLER
	if((get_turf(src) != start_turf) && !left_home_at)
		left_home_at = world.time
		addtimer(CALLBACK(src, PROC_REF(go_home)), walk_home_timer)
	else if((get_turf(src) == start_turf) && left_home_at)
		left_home_at = 0

//mob tries to return home if its timer is up.
/mob/living/carbon/human/npc/bouncer/proc/go_home()
	if(get_turf(src) == start_turf || !is_guarding)
		return

	if(left_home_at + walk_home_timer <= world.time)
		danger_source = null
		walk_to(src, start_turf, 1, total_multiplicative_slowdown())
		addtimer(CALLBACK(src, PROC_REF(position_hard_reset)), warp_home_timer)

/mob/living/carbon/human/npc/bouncer/proc/position_hard_reset()
	if(is_guarding)
		danger_source = null
		if(get_turf(src) != start_turf)
			forceMove(start_turf)
		dir = default_direction



/mob/living/carbon/human/npc/bouncer/ShiftClick(mob/user)
	if(istype(user, /mob/living/carbon/human) && user.stat != DEAD && can_be_reasoned_with() && in_range(src, user))
		var/list/interact_options = list(
			"Persuade for Entry" = image(icon = 'icons/obj/dice.dmi', icon_state = "d10"))

		var/obj/item/held_item = user.get_active_held_item()
		if(held_item && istype(held_item,/obj/item/card/id/police))
			interact_options["Show Badge"] = image(icon = held_item.icon, icon_state = held_item.icon_state)

		var/mob/living/carbon/human/user_human = user
		if(user_human?.wear_mask?.flags_inv&HIDEFACE || user_human?.head?.flags_inv&HIDEFACE)
			interact_options["Show Face"] = image(icon = 'code/modules/wod13/clothing.dmi', icon_state = "balaclava")

		var/picked_option = show_radial_menu(user, src, interact_options, radius = 38, require_near = TRUE)
		switch(picked_option)
			if("Persuade for Entry")
				to_chat(user, "<span class='notice'>You try to talk your way through.</span>")
				linked_perm.notify_barrier_social_bypass(user_human, src)
				return
			if("Show Badge")
				to_chat(user, "<span class='notice'>You flash your [held_item] as you try to talk your way through.</span>")
				linked_perm.notify_barrier_social_bypass(user_human, src, TRUE)
				return
			if("Show Face")
				to_chat(user, "<span class='notice'>You discretely show [src] your face...</span>")
				linked_perm.notify_barrier_unmask_bypass(user_human, src)
				return
	.=..()


/mob/living/carbon/human/npc/bouncer/proc/can_be_reasoned_with()
	if(!is_guarding || get_turf(src)!=start_turf)
		return FALSE
	return TRUE


/mob/living/carbon/human/npc/bouncer/proc/speak_seldom(var/phrase, mob/target)
	if(can_be_reasoned_with() && world.time > message_cooldown)
		message_cooldown = world.time + repeat_delay
		RealisticSay(phrase)
		dir = get_dir(loc, get_turf(target))
		addtimer(CALLBACK(src, PROC_REF(resume_neutral_direction)), resume_neutral_direction_delay)

/mob/living/carbon/human/npc/bouncer/proc/resume_neutral_direction()
	dir = default_direction
