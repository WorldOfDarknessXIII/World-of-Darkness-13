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
		"ghoul"		=	/datum/splat/supernatural/ghoul,
		"kuei_jin"	=	/datum/splat/supernatural/kuei_jin,
	)
	///An associated list of lazy lists for splats applied; keys are the splat owner, values are the splat
	var/list/human_splats = list(
		)
	var/list/kindred_splats = list(
		)
	var/list/garou_splats = list(
		)
	var/list/ghoul_splats = list(
		)
	var/list/kueijin_splats = list(
		)

/datum/controller/subsystem/splats/Initialize()
	RegisterSignal(src, COMSIG_SPLAT_SPLAT_APPLIED_TO, PROC_REF(track_splat_assignment))
	return ..()

/datum/controller/subsystem/splats/proc/give_new_splat(mob/living/target, splat)
	if(ispath(splat, /datum/splat))
		var/datum/splat/new_splat = new()
		new_splat.Apply(target)
		return new_splat
	if(!istext(splat))
		CRASH("Tried to splat [target] with an undefined value: [splat]")
	var/splat_type = splat_types[splat]
	var/datum/splat/new_splat = new(splat_type)
	new_splat.Apply(target)
	return new_splat

/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
