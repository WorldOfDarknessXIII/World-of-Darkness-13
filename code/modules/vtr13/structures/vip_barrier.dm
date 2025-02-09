


/obj/structure/vip_barrier
	name = "Basic Check Point"
	desc = "Not a real checkpoint."
	icon = 'icons/obj/vtr13/barrier.dmi'
	icon_state = "camarilla_blocking"
	var/block_sound = "sound/vtr13/bouncer_blocked.ogg"

	//Social bypass numbers
	var/social_bypass_allowed = TRUE
	var/social_bypass_time = 20 SECONDS
	var/can_use_badge = TRUE
	var/mean_to_cops = TRUE
	var/social_roll_difficulty = 7

	//Display settings
	var/always_invisible = FALSE

	density = FALSE
	anchored = TRUE



	//Assigns an ID to NPCs that guard certain doors, must match a barrier's ID
	//*********All barriers under a protected_zone_id should be of the same type!*********
	var/protected_zone_id = "test"

	var/datum/vip_barrier_perm/linked_perm = null


/obj/structure/vip_barrier/Initialize()
	. = ..()

	//we do this in an initialize so mappers do not have to code as much
	if(!GLOB.vip_barrier_perms?[protected_zone_id])
		GLOB.vip_barrier_perms[protected_zone_id] = new /datum/vip_barrier_perm(protected_zone_id)

	linked_perm = GLOB.vip_barrier_perms[protected_zone_id]
	linked_perm.add_barrier(src)

	RegisterSignal(linked_perm, COMSIG_VIP_PERM_ACTIVE_GUARD_UPDATE, PROC_REF(signal_update_icon))

	//spessman purity means I have to register a signal with myself, pain
	RegisterSignal(src, COMSIG_BARRIER_NOTIFY_GUARD_BLOCKED, PROC_REF(playBlockSound))

	update_icon()


/obj/structure/vip_barrier/CanPass(atom/movable/mover, turf/target)
	. = ..()
	var/entry_allowed = TRUE

	if(check_direction_always_allowed(mover) || !istype(mover, /mob/living/carbon/human))
		return TRUE

	var/mob/mover_mob = mover
	if(!mover_mob.client)
		return TRUE

	if(linked_perm && linked_perm.actively_guarded)
		entry_allowed = check_entry_permission_base(mover_mob)

	if(!entry_allowed && mover.pulledby && istype(mover.pulledby, /mob/living/carbon/human))
		entry_allowed = check_entry_permission_base(mover.pulledby)

	if(entry_allowed)
		SEND_SIGNAL(src, COMSIG_BARRIER_NOTIFY_GUARD_ENTRY, mover_mob)
	else
		SEND_SIGNAL(src, COMSIG_BARRIER_NOTIFY_GUARD_BLOCKED, mover_mob)

	return entry_allowed

/obj/structure/vip_barrier/proc/check_direction_always_allowed(atom/movable/mover)
	if(src.loc == mover.loc)
		return TRUE
	var/origin_dir = get_dir(src, mover)
	return !(origin_dir & src.dir)

/obj/structure/vip_barrier/proc/playBlockSound(atom/movable/mover)
	SIGNAL_HANDLER
	playsound(mover, block_sound, vol = 10, falloff_distance = 2, vary = TRUE)


//Call this parent after any children run
/obj/structure/vip_barrier/proc/check_entry_permission_base(mob/living/carbon/human/entering_mob)
	if(LAZYFIND(linked_perm.allow_list, entering_mob.name))
		return TRUE

	if(LAZYFIND(linked_perm.block_list, entering_mob.name))
		return FALSE

	return check_entry_permission_custom(entering_mob)

//Function for providing custom blocks and allowances for entering people
/obj/structure/vip_barrier/proc/check_entry_permission_custom(mob/living/carbon/human/entering_mob)
	return TRUE

/obj/structure/vip_barrier/proc/handle_social_bypass(mob/user, mob/bouncer, used_badge = FALSE)
	if(check_entry_permission_base(user))
		to_chat(user, "<span class='notice'>...But you are already allowed entry.</span>")
		return

	var/mob/living/carbon/human/human_user = user

	if(do_mob(user, bouncer, max(5 SECONDS, social_bypass_time - (human_user.get_total_social() * 2 SECONDS))))

		//handle block list babies
		if(LAZYFIND(linked_perm.block_list, human_user.name))
			if(identify_cop(human_user, used_badge))
				linked_perm.notify_guard_police_denial()
			else
				linked_perm.notify_guard_blocked_denial()

		var/involved_social_roll = social_roll_difficulty
		if(used_badge)
			involved_social_roll -= 1

		if(user.storyteller_roll(human_user.get_total_social(), involved_social_roll))
			to_chat(user, "<span class='notice'>You manage to persuade your way past the guards.</span>")
			linked_perm.allow_list += human_user.name
		else
			to_chat(user, "<span class='notice'>The guards turn you away, taking note of you as they do.</span>")
			linked_perm.block_list += human_user.name
			if(identify_cop(human_user, used_badge))
				linked_perm.notify_guard_police_denial()
			else
				linked_perm.notify_guard_blocked()


/obj/structure/vip_barrier/proc/identify_cop(var/mob/living/carbon/human/human_user, var/used_badge = FALSE)
	if(mean_to_cops && (used_badge || (human_user.wear_id && istype(human_user.wear_id,/obj/item/card/id/police))))
		return TRUE
	return FALSE



/obj/structure/vip_barrier/proc/signal_update_icon()
	SIGNAL_HANDLER
	update_icon()

/obj/structure/vip_barrier/update_icon()
	if(always_invisible)
		alpha = 0
		return
	if(linked_perm.actively_guarded)
		alpha = 255
	else
		alpha = 128
