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

	RegisterSignal(soil, COMSIG_ATOM_ENTERED, PROC_REF(handle_soil_entered))
	RegisterSignal(soil, COMSIG_ATOM_EXITED, PROC_REF(handle_soil_exited))

/datum/component/needs_home_soil/proc/handle_soil_entered(obj/item/ground_heir/source, atom/movable/entering, atom/oldLoc)
	SIGNAL_HANDLER

	var/mob/living/needs_soil = parent
	var/list/atom/movable/mob_contents = needs_soil.GetAllContents()
	if (!mob_contents.Find(entering))
		return

	STOP_PROCESSING(SSdcs, src)

/datum/component/needs_home_soil/proc/handle_soil_exited(obj/item/ground_heir/source, atom/movable/exiting, atom/newloc)
	SIGNAL_HANDLER

	var/mob/living/needs_soil = parent
	var/list/atom/movable/mob_contents = needs_soil.GetAllContents()
	if (mob_contents.Find(newloc))
		return

	START_PROCESSING(SSdcs, src)

/datum/component/needs_home_soil/process(delta_time)
	if (!DT_PROB(1.25, delta_time))
		return

	var/mob/living/lacking_soil = parent
	lacking_soil.bloodpool = clamp(lacking_soil.bloodpool - 1, 0, lacking_soil.maxbloodpool)

	to_chat(lacking_soil, span_warning("You are missing your home soil. Being without it weakens you..."))

/datum/component/needs_home_soil/proc/handle_soil_destroyed(obj/item/ground_heir/source, force)
	SIGNAL_HANDLER

	// Deal 25% of their health in clone damage and reduce their bloodpool size by 3, to a minimum of 8
	var/mob/living/lacking_soil = parent
	lacking_soil.apply_damage(0.25 * lacking_soil.getMaxHealth(), CLONE)
	lacking_soil.maxbloodpool = max(lacking_soil.maxbloodpool - 3, 8)

	to_chat(lacking_soil, span_danger("Your home soil has been destroyed! Its loss debilitates you."))

	qdel(src)
