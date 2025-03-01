

//Holds associated lists of walls and bouncers in a single permission network.
/datum/vip_barrier_perm
	var/name
	var/list/linked_barriers = list()
	var/list/linked_bouncers = list()
	var/actively_guarded = TRUE

	var/hint_delivery_lag = 1 SECONDS

	//people the guards have determined can pass anyways
	var/list/allow_list = list()

	//people the guards have decided to deny no matter what
	var/list/block_list = list("Unknown")

	var/list/gave_interaction_hint_list = list()


/datum/vip_barrier_perm/New(var/protected_zone_id)
	name = protected_zone_id


//registers bouncer with the perms
/datum/vip_barrier_perm/proc/add_bouncer(var/target_bouncer)
	linked_bouncers += target_bouncer

//registers barrier with the perms
/datum/vip_barrier_perm/proc/add_barrier(var/target_barrier)
	linked_barriers += target_barrier
	RegisterSignal(target_barrier, COMSIG_BARRIER_NOTIFY_GUARD_BLOCKED, PROC_REF(notify_guard_blocked))
	RegisterSignal(target_barrier, COMSIG_BARRIER_NOTIFY_GUARD_ENTRY, PROC_REF(notify_guard_entry))
	RegisterSignal(target_barrier, COMSIG_BARRIER_NOTIFY_GUARD_MASKED, PROC_REF(notify_guard_masked_denial))


//handles bouncer death
/datum/vip_barrier_perm/proc/process_dead_bouncer(mob/living/carbon/human/npc/bouncer/dead_bouncer)
	dead_bouncer.is_guarding = FALSE
	linked_bouncers -= dead_bouncer
	if(!linked_bouncers)
		for(var/obj/effect/vip_barrier/barrier in linked_barriers)
			UnregisterSignal(barrier, COMSIG_BARRIER_NOTIFY_GUARD_BLOCKED)
			UnregisterSignal(barrier, COMSIG_BARRIER_NOTIFY_GUARD_ENTRY)



/datum/vip_barrier_perm/proc/check_barrier_guarded()
	var/barrier_is_guarded = FALSE

	for(var/mob/living/carbon/human/npc/bouncer/linked_bouncer in linked_bouncers)
		if(!linked_bouncer.is_guarding)
			continue
		barrier_is_guarded = TRUE
		break

	if(!actively_guarded && barrier_is_guarded)
		actively_guarded = TRUE
		for(var/obj/effect/vip_barrier/barrier in linked_barriers)
			barrier.update_icon()

	else if (actively_guarded && !barrier_is_guarded)
		actively_guarded = FALSE
		for(var/obj/effect/vip_barrier/barrier in linked_barriers)
			barrier.update_icon()

//=============================================================================
//Procs for communication between barriers and bouncers
/datum/vip_barrier_perm/proc/notify_guard_entry(datum/source, mob/target_mob)
	SIGNAL_HANDLER
	if(!linked_bouncers.len)
		return
	var/mob/living/carbon/human/npc/bouncer/target_bouncer = pick(linked_bouncers)
	target_bouncer.speak_seldom(pick(target_bouncer.entry_phrases), target_mob)

/datum/vip_barrier_perm/proc/notify_guard_blocked(datum/source, mob/target_mob)
	SIGNAL_HANDLER
	if(!linked_bouncers.len)
		return
	if(prob(80))
		return
	var/mob/living/carbon/human/npc/bouncer/target_bouncer = pick(linked_bouncers)
	target_bouncer.speak_seldom(pick(target_bouncer.denial_phrases), target_mob)
	trigger_hint_interaction(target_mob)

/datum/vip_barrier_perm/proc/notify_guard_masked_denial(datum/source, mob/target_mob)
	SIGNAL_HANDLER
	if(!linked_bouncers.len)
		return
	var/mob/living/carbon/human/npc/bouncer/target_bouncer = pick(linked_bouncers)
	target_bouncer.speak_seldom(pick(target_bouncer.unmask_phrases), target_mob)
	trigger_hint_interaction(target_mob)

/datum/vip_barrier_perm/proc/notify_guard_police_denial(mob/target_mob)
	if(!linked_bouncers.len)
		return
	var/mob/living/carbon/human/npc/bouncer/target_bouncer = pick(linked_bouncers)
	target_bouncer.speak_seldom(pick(target_bouncer.police_block_phrases), target_mob)
	trigger_hint_interaction(target_mob)

/datum/vip_barrier_perm/proc/notify_guard_blocked_denial(mob/target_mob)
	if(!linked_bouncers.len)
		return
	var/mob/living/carbon/human/npc/bouncer/target_bouncer = pick(linked_bouncers)
	target_bouncer.speak_seldom(pick(target_bouncer.block_phrases), target_mob)

/datum/vip_barrier_perm/proc/notify_barrier_social_bypass(mob/user, mob/bouncer, used_badge)
	if(!linked_barriers.len)
		return
	var/obj/effect/vip_barrier/target_barrier = linked_barriers[1]
	target_barrier.handle_social_bypass(user, bouncer, used_badge)

/datum/vip_barrier_perm/proc/notify_barrier_unmask_bypass(mob/user, mob/bouncer)
	if(!linked_barriers.len)
		return
	var/obj/effect/vip_barrier/target_barrier = linked_barriers[1]
	target_barrier.handle_unmask_bypass(user, bouncer)

//=============================================================================

/datum/vip_barrier_perm/proc/trigger_hint_interaction(mob/living/target_mob)
	if(!target_mob.mind || LAZYFIND(gave_interaction_hint_list, target_mob))
		return
	gave_interaction_hint_list += target_mob
	addtimer(CALLBACK(src, PROC_REF(give_interact_hint), target_mob), hint_delivery_lag)

/datum/vip_barrier_perm/proc/give_interact_hint(mob/target_mob)
	to_chat(target_mob, span_notice("Hint: You can interact with a bouncer by moving close and shift-clicking them."))
