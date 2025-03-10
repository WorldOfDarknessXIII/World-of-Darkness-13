#define HAS_SEEDS(seedable) (seedable.vars.Find("seed") ? (istype(seedable.vars["seed"], /obj/item/seeds) ? seedable.vars["seed"] : FALSE) : FALSE)

/datum/element/seed_extractable
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH

/datum/element/seed_extractable/Attach(obj/item/target)
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	if(!HAS_SEEDS(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_PARENT_ATTACKBY, PROC_REF(attempt_extract_seed))
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	return ..()

/datum/element/seed_extractable/Detach(obj/item/target)
	UnregisterSignal(target, COMSIG_ITEM_ATTACK)
	UnregisterSignal(target, COMSIG_PARENT_EXAMINE)
	return ..()

/datum/element/seed_extractable/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_notice("Perhaps a sharp object could be used to extract the seeds from this.")

/datum/element/seed_extractable/proc/attempt_extract_seed(obj/item/source, obj/item/tool, mob/living/pulper)
	SIGNAL_HANDLER

	if(tool.sharpness != SHARP_EDGED)
		return NONE
	var/obj/item/seeds/seed = HAS_SEEDS(source)
	if(!seed)
		return NONE
	var/i
	for(i = 0; i < rand(1, 3); i++)
		var/obj/item/seeds/new_seed = seed.Copy()
		new_seed.forceMove(get_turf(source))
	to_chat(pulper, "You manage to carve a seed or two out of [source].")
	qdel(source)

#undef HAS_SEEDS
