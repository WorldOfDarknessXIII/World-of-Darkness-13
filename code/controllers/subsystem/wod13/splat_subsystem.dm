/* A subsystem for handling splats when putting behavior on the splat itself would be too constrained (a list of vampires, for example)
 * Also handles generating a new splat to apply to someone
 * Doesn't process.
*/
SUBSYSTEM_DEF(splats)
	name = "splats"
	init_order = INIT_ORDER_SPLATS
	flags = SS_NO_FIRE

	///To save a headache on contributors trying to remember the paths
	var/list/splat_types = list(
		"human"		=	/datum/splat/human,
		"kindred"	=	/datum/splat/supernatural/kindred,
		"garou"		=	/datum/splat/supernatural/garou,
		"ghoul"		=	/datum/splat/supernatural/kindred/ghoul,
		"kuei_jin"	=	/datum/splat/supernatural/kuei_jin,
	)
	///An associated list of lazy lists for splats applied; keys are the splat owner, values are the splat
	var/list/splat_havers = list()

/datum/controller/subsystem/splats/Initialize()
	RegisterSignal(src, COMSIG_SPLAT_SPLAT_APPLIED_TO, PROC_REF(track_splat_assignment))
	RegisterSignal(src, COMSIG_SPLAT_SPLAT_REMOVED_FROM, PROC_REF(untrack_splat_assignment))
	return ..()

/datum/controller/subsystem/splats/proc/give_new_splat(mob/living/target, splat_index)
	var/splat_type = splat_types[splat_index]
	var/datum/splat/new_splat = new splat_type()
	new_splat.Apply(target)

/datum/controller/subsystem/splats/proc/track_splat_assignment(datum/source, mob/living/splatted_person, datum/splat/splat_applied)
	SIGNAL_HANDLER

	if(!splat_havers.Find(splatted_person))
		splat_havers[splatted_person] = list()
	splat_havers[splatted_person][splat_applied.splat_id] = splat_applied
	return TRUE

/datum/controller/subsystem/splats/proc/untrack_splat_assignment(datum/source, mob/living/unsplatted_person, datum/splat/splat_removed)
	SIGNAL_HANDLER

	if(!splat_havers.Find(unsplatted_person))
		CRASH("Tried to untrack [splat_removed] from [unsplatted_person], but [unsplatted_person] wasn't being tracked!")
	if(!splat_havers[unsplatted_person].Find(splat_removed.splat_id))
		CRASH("Tried to untrack [splat_removed] from [unsplatted_person]'s tracked splats, but [splat_removed] wasn't being tracked!")
	splat_havers[unsplatted_person][splat_removed.splat_id] = null
	splat_havers[unsplatted_person] -= splat_removed.splat_id
	if(!length(splat_havers[unsplatted_person]))
		splat_havers[unsplatted_person] = null
		splat_havers -= unsplatted_person
	return TRUE
