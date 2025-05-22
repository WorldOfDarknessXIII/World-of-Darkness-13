/**
 * # Holy Weakness
 *
 * A weakness that causes affected
 * mobs to periodically light on fire
 * when entering holy areas. Currently
 * "holy areas" means churches.
 */
/datum/element/holy_weakness
	element_flags = ELEMENT_DETACH

	/// Mobs being exposed to and harmed by holiness
	var/list/mob/living/exposed_to_holiness

/datum/element/holy_weakness/Attach(datum/target)
	. = ..()

	if (!isliving(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ENTER_AREA, PROC_REF(handle_enter_area))

/datum/element/holy_weakness/Detach(datum/source, force)
	UnregisterSignal(source, COMSIG_ENTER_AREA)
	UnregisterSignal(source, COMSIG_EXIT_AREA)

	LAZYREMOVE(exposed_to_holiness, source)

	return ..()

/datum/element/holy_weakness/proc/handle_enter_area(mob/living/source, area/entered_area)
	SIGNAL_HANDLER

	// Holy weakness only triggers on entering churches
	if (!istype(entered_area, /area/vtm/church))
		return

	to_chat(source, span_danger("Leave this holy place!"))

	// Start repeatedly setting this mob on fire if they stay in the holy area
	START_PROCESSING(SSdcs, src)
	LAZYADD(exposed_to_holiness, source)

	// Stop effects when the mob leaves this area
	RegisterSignal(source, COMSIG_EXIT_AREA, PROC_REF(handle_exit_area))

/datum/element/holy_weakness/proc/handle_exit_area(mob/living/source, area/exited_area)
	SIGNAL_HANDLER

	// Signal should only trigger when the mob leaves a holy area, but just to be safe
	if (!istype(exited_area, /area/vtm/church))
		return

	// Stop setting this mob on fire, stop processing if everyone's been removed
	LAZYREMOVE(exposed_to_holiness, source)
	if (!exposed_to_holiness)
		STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(source, COMSIG_EXIT_AREA)

/datum/element/holy_weakness/process(delta_time)
	// Ignite all exposed mobs on a probability of ~25% per 4 seconds
	for (var/mob/living/cursed_mob as anything in exposed_to_holiness)
		if (!DT_PROB(6.25, delta_time))
			continue

		to_chat(cursed_mob, span_warning("You don't belong in this holy place!"))

		cursed_mob.apply_damage(20, BURN)
		cursed_mob.adjust_fire_stacks(6)
		cursed_mob.IgniteMob()

