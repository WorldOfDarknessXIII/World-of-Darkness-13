


/obj/effect/vip_barrier
	name = "Basic Check Point"
	desc = "Not a real checkpoint."
	icon = 'icons/obj/wod13/barrier.dmi'
	icon_state = "camarilla_blocking"
	var/block_sound = "sound/wod13/bouncer_blocked.ogg"

	//Social bypass numbers
	var/social_bypass_allowed = TRUE
	var/social_bypass_time = 20 SECONDS
	var/unmask_bypass_time = 10 SECONDS
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


/obj/effect/vip_barrier/Initialize()
	. = ..()

	if(src.type == /obj/effect/vip_barrier)
		CRASH("VIP Barrier created using default type, please use a child of this type in mapping.")

	//we do this in an initialize so mappers do not have to code as much
	if(SSbouncer_barriers.vip_barrier_perms?[protected_zone_id])
		linked_perm = SSbouncer_barriers.vip_barrier_perms[protected_zone_id]
		linked_perm.add_barrier(src)
		//spessman purity means I have to register a signal with myself, pain
		RegisterSignal(src, COMSIG_BARRIER_NOTIFY_GUARD_BLOCKED, PROC_REF(playBlockSound))
		update_icon()
	else if(SSbouncer_barriers.initialized)
		CRASH("A VIP barrier was created for vip_barrier_perms that were not loaded!")

/obj/effect/vip_barrier/CanPass(atom/movable/mover, turf/target)
	. = ..()
	var/entry_allowed = TRUE

	if(!isliving(mover))
		return entry_allowed

	if(check_direction_always_allowed(mover))
		return entry_allowed

	var/mob/living/mover_mob = mover
	if(!mover_mob.mind)
		entry_allowed = FALSE
	else if(linked_perm.actively_guarded)

		if(handle_masked_entry(mover))
			return FALSE
		
		entry_allowed = check_entry_permission_base(mover_mob)

	if(!entry_allowed && mover.pulledby && isliving(mover.pulledby))
		entry_allowed = check_entry_permission_base(mover.pulledby)

	if(entry_allowed)
		SEND_SIGNAL(src, COMSIG_BARRIER_NOTIFY_GUARD_ENTRY, mover_mob)
	else
		SEND_SIGNAL(src, COMSIG_BARRIER_NOTIFY_GUARD_BLOCKED, mover_mob)

	return entry_allowed

//returns TRUE if a person is blocked for being masked. Else, False.
/obj/effect/vip_barrier/proc/handle_masked_entry(mob/living/mover)
	if(!mover || !istype(mover, /mob/living/carbon/human))
		return FALSE

	var/mob/living/carbon/human/mover_human = mover
	if((mover_human?.wear_mask?.flags_inv&HIDEFACE || mover_human?.head?.flags_inv&HIDEFACE) && !LAZYFIND(linked_perm.allow_list, mover))
		
		SEND_SIGNAL(src, COMSIG_BARRIER_NOTIFY_GUARD_MASKED, mover)
		return TRUE
	
	return FALSE

/obj/effect/vip_barrier/proc/check_direction_always_allowed(atom/movable/mover)
	if(src.loc == mover.loc)
		return TRUE
	var/origin_dir = get_dir(src, mover)
	return !(origin_dir & src.dir)

/obj/effect/vip_barrier/proc/playBlockSound(atom/movable/mover)
	SIGNAL_HANDLER
	playsound(mover, block_sound, vol = 10, falloff_distance = 2, vary = TRUE)


//Call this parent after any children run
/obj/effect/vip_barrier/proc/check_entry_permission_base(mob/living/carbon/human/entering_mob)
	if(LAZYFIND(linked_perm.allow_list, entering_mob))
		return TRUE

	if(LAZYFIND(linked_perm.block_list, entering_mob))
		return FALSE

	return check_entry_permission_custom(entering_mob)

//Function for providing custom blocks and allowances for entering people
/obj/effect/vip_barrier/proc/check_entry_permission_custom(mob/living/carbon/human/entering_mob)
	return TRUE


/obj/effect/vip_barrier/proc/handle_unmask_bypass(mob/living/carbon/human/user, mob/bouncer)
	if(!do_mob(user, bouncer, max(2 SECONDS, unmask_bypass_time - (user.get_total_social() * 2 SECONDS))))
		return
	if(check_entry_permission_base(user))
		to_chat(user, "<span class='notice'>[bouncer] subtly nods, giving you permission to enter.</span>")
		linked_perm.allow_list += user
		return
	to_chat(user, "<span class='notice'>[bouncer] shakes their head.</span>")
	linked_perm.notify_guard_blocked_denial(user)

/obj/effect/vip_barrier/proc/handle_social_bypass(mob/living/carbon/human/user, mob/bouncer, used_badge = FALSE)
	if(check_entry_permission_base(user))
		to_chat(user, "<span class='notice'>...But you are already allowed entry.</span>")
		return

	//handle block list babies
	if(LAZYFIND(linked_perm.block_list, user))
		if(identify_cop(user, used_badge))
			linked_perm.notify_guard_police_denial(user)
		else
			linked_perm.notify_guard_blocked_denial(user)
		return

	if(!do_mob(user, bouncer, max(5 SECONDS, social_bypass_time - (user.get_total_social() * 2 SECONDS))))
		return

	var/involved_social_roll = social_roll_difficulty
	if(used_badge)
		involved_social_roll -= 1

	if(user.storyteller_roll(user.get_total_social(), involved_social_roll) == ROLL_SUCCESS)
		to_chat(user, "<span class='notice'>You manage to persuade your way past the guards.</span>")
		linked_perm.allow_list += user
		return

	to_chat(user, "<span class='notice'>The guards turn you away, taking note of you as they do.</span>")
	linked_perm.block_list += user
	if(identify_cop(user, used_badge))
		linked_perm.notify_guard_police_denial(user)
	else
		linked_perm.notify_guard_blocked_denial(user)

/obj/effect/vip_barrier/proc/identify_cop(mob/living/carbon/human/user, used_badge = FALSE)
	if(mean_to_cops && (used_badge || (user.wear_id && istype(user.wear_id,/obj/item/card/id/police))))
		return TRUE
	return FALSE

/obj/effect/vip_barrier/proc/signal_update_icon()
	SIGNAL_HANDLER
	update_icon()

/obj/effect/vip_barrier/update_icon()
	if(always_invisible)
		alpha = 0
		return
	if(linked_perm.actively_guarded)
		alpha = 255
	else
		alpha = 128
