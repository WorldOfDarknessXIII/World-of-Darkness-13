/**
 * # Needs Home Soil
 *
 * Causes a vampire to need to keep soil
 * from their homeland on their person, or
 * else they start losing power (blood)
 * periodically.
 *
 */
/datum/component/needs_home_soil
	var/obj/item/ground_heir/soil

/datum/component/needs_home_soil/Initialize(obj/item/ground_heir/soil)
	. = ..()

	if (!istype(soil, /obj/item/ground_heir))
		return COMPONENT_INCOMPATIBLE
	src.soil = soil

	RegisterSignal(soil, COMSIG_PARENT_QDELETING, PROC_REF(handle_soil_destroyed))

/datum/component/needs_home_soil/RegisterWithParent()
	if (!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(soil, COMSIG_MOVABLE_MOVED, PROC_REF(handle_soil_moved))

/datum/component/needs_home_soil/proc/handle_soil_moved(obj/item/ground_heir/source, atom/OldLoc, dir)
	SIGNAL_HANDLER

	var/mob/living/needs_soil = parent
	var/list/atom/movable/mob_contents = needs_soil.GetAllContents()
	if (mob_contents.Find(source))
		STOP_PROCESSING(SSdcs, src)
	else
		START_PROCESSING(SSdcs, src)

/datum/component/needs_home_soil/process(delta_time)
	if (!DT_PROB(3, delta_time))
		return

	var/mob/living/lacking_soil = parent
	lacking_soil.bloodpool = clamp(lacking_soil.bloodpool - 1, 0, lacking_soil.maxbloodpool)

	to_chat(lacking_soil, span_warning("You are missing your home soil. Being without it weakens you..."))

/datum/component/needs_home_soil/proc/handle_soil_destroyed(obj/item/ground_heir/source, force)
	SIGNAL_HANDLER

	// Deal 25% of their health in clone damage and reduce their bloodpool size by 3, to a minimum of 8
	var/mob/living/lacking_soil = parent
	lacking_soil.apply_damage(0.25 * lacking_soil.getMaxHealth(), CLONE)
	// Currently nonfunctional, will be fixed in the splat rework
	lacking_soil.maxbloodpool = max(lacking_soil.maxbloodpool - 3, 8)
	lacking_soil.bloodpool = clamp(lacking_soil.bloodpool - 3, 0, lacking_soil.maxbloodpool)

	to_chat(lacking_soil, span_danger("Your home soil has been destroyed! Its loss debilitates you."))

	qdel(src)
