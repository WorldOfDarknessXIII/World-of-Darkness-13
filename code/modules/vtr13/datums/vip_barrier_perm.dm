

//Holds associated lists of walls and bouncers in a single permission network.
/datum/vip_barrier_perm
	var/name
	var/list/linked_barriers = list()
	var/list/linked_bouncers = list()
	var/actively_guarded = TRUE

	var/guard_recheck_lag = 1 SECONDS

	//people the guards have determined can pass anyways
	var/list/allow_list = list()

	//people the guards have decided to deny no matter what
	var/list/block_list = list("Unknown")


/datum/vip_barrier_perm/New(var/protected_zone_id)
	name = protected_zone_id


//registers bouncer with the perms
/datum/vip_barrier_perm/proc/add_bouncer(var/target_bouncer)
	linked_bouncers += target_bouncer

	//if bouncer is dead we can permanently remove it from the check
	RegisterSignal(target_bouncer, COMSIG_LIVING_DEATH, PROC_REF(process_dead_bouncer))

	//if bouncers are KO'd or Sleeping, disable barrier
	RegisterSignal(target_bouncer, COMSIG_LIVING_STATUS_UNCONSCIOUS, PROC_REF(check_barrier_guarded_with_recheck))


//registers barrier with the perms
/datum/vip_barrier_perm/proc/add_barrier(var/target_barrier)
	linked_barriers += target_barrier
	RegisterSignal(target_barrier, COMSIG_BARRIER_NOTIFY_GUARD_BLOCKED, PROC_REF(notify_guard_blocked))
	RegisterSignal(target_barrier, COMSIG_BARRIER_NOTIFY_GUARD_ENTRY, PROC_REF(notify_guard_entry))


//handles bouncer death
/datum/vip_barrier_perm/proc/process_dead_bouncer()
	if(linked_bouncers)
		for(var/mob/living/carbon/human/npc/bouncer/linked_bouncer in linked_bouncers)
			if(linked_bouncer.stat == DEAD)
				linked_bouncers -= linked_bouncer
				UnregisterSignal(linked_bouncer, COMSIG_LIVING_DEATH)
				UnregisterSignal(linked_bouncer, COMSIG_LIVING_STATUS_UNCONSCIOUS)
				UnregisterSignal(linked_bouncer, COMSIG_LIVING_STATUS_SLEEP)

	#ifdef TESTING
	else
		log_world("BOUNCERBUGS: [src] processed a dead bouncer but no bouncers are loaded. What?")
	#endif
	check_barrier_guarded()



/datum/vip_barrier_perm/proc/check_barrier_guarded()
	var/barrier_is_guarded = FALSE

	for(var/mob/living/carbon/human/npc/bouncer/linked_bouncer in linked_bouncers)
		if(linked_bouncer.stat == DEAD)
			continue
		if(linked_bouncer.IsSleeping())
			continue
		if(linked_bouncer.IsUnconscious())
			continue
		barrier_is_guarded = TRUE
		break

	if(!actively_guarded && barrier_is_guarded)
		actively_guarded = TRUE
		SEND_SIGNAL(src, COMSIG_VIP_PERM_ACTIVE_GUARD_UPDATE)

	else if (actively_guarded && !barrier_is_guarded)
		actively_guarded = FALSE
		SEND_SIGNAL(src, COMSIG_VIP_PERM_ACTIVE_GUARD_UPDATE)


//Have the perms check if the barrier is under active guard, then recheck after the given time.
//Works in tandem with temporary effects like a bouncer being KO'd
/datum/vip_barrier_perm/proc/check_barrier_guarded_with_recheck(amount, ignorestun)
	SIGNAL_HANDLER
	check_barrier_guarded()
	addtimer(CALLBACK(src, PROC_REF(check_barrier_guarded)), amount+guard_recheck_lag)


//=============================================================================
//Procs for communication between barriers and bouncers
/datum/vip_barrier_perm/proc/notify_guard_entry(var/mob/target_mob)
	SIGNAL_HANDLER
	if(!linked_bouncers.len)
		return
	var/mob/living/carbon/human/npc/bouncer/target_bouncer = pick(linked_bouncers)
	target_bouncer.speak_entry_phrase(target_mob)

/datum/vip_barrier_perm/proc/notify_guard_blocked(var/mob/target_mob)
	SIGNAL_HANDLER
	if(!linked_bouncers.len)
		return
	var/mob/living/carbon/human/npc/bouncer/target_bouncer = pick(linked_bouncers)
	target_bouncer.speak_denial_phrase(target_mob)

/datum/vip_barrier_perm/proc/notify_guard_police_denial(var/mob/target_mob)
	if(!linked_bouncers.len)
		return
	var/mob/living/carbon/human/npc/bouncer/target_bouncer = pick(linked_bouncers)
	target_bouncer.speak_police_block_phrase(target_mob)

/datum/vip_barrier_perm/proc/notify_guard_blocked_denial(var/mob/target_mob)
	if(!linked_bouncers.len)
		return
	var/mob/living/carbon/human/npc/bouncer/target_bouncer = pick(linked_bouncers)
	target_bouncer.speak_block_phrase(target_mob)

/datum/vip_barrier_perm/proc/notify_barrier_social_bypass(mob/user, used_badge)
	if(!linked_barriers.len)
		return
	var/obj/structure/vip_barrier/target_barrier = linked_barriers[1]
	target_barrier.handle_social_bypass(user,used_badge)


//=============================================================================

