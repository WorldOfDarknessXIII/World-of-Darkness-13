/datum/splat
	var/name = "Splat"
	var/desc = "A game line in the World of Darkness franchise."

	var/splat_traits = list()
	var/splat_species_traits = list()
	var/splat_actions = list()

	var/list/max_resources = list()
	var/list/resources = list()
	var/power_type = /datum/discipline
	var/list/replace_splats = list()
	var/list/incompatible_splats = list()

	var/selectable = FALSE
	var/whitelisted = FALSE

	var/list/datum/discipline/powers = list()
	var/mob/living/owner

/* GAINING SPLATS */
/datum/splat/proc/assign(mob/living/owner)
	src.owner = owner
	owner.splats += src
	on_gain()

/datum/splat/proc/on_gain()
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(owner, COMSIG_MOB_GAIN_SPLAT, src)

	add_species_traits()

	add_traits()

	add_actions()

/datum/splat/proc/add_species_traits()
	var/datum/dna/owner_dna = owner.has_dna()
	if (!owner_dna)
		return

	for (var/species_trait in splat_species_traits)
		owner_dna.species.species_traits |= species_trait

/datum/splat/proc/add_traits()
	for (var/trait in splat_traits)
		ADD_TRAIT(owner, trait, SPLAT_TRAIT)

/datum/splat/proc/add_actions()
	for (var/adding_action in splat_actions)
		var/datum/action/new_action = new adding_action
		new_action.Grant(owner)

/* LOSING SPLATS */
/datum/splat/proc/unassign(annihilate = TRUE)
	on_lose()

	owner.splats -= src
	owner.mind?.splats -= src

	// this clears out every single instantiated datum on this splat, very dangerous
	if (annihilate)
		QDEL_LIST(powers)

	qdel(src)

/datum/splat/proc/on_lose()
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(owner, COMSIG_MOB_LOSE_SPLAT, src)

	remove_species_traits()

	remove_traits()

	remove_actions()

/datum/splat/proc/remove_species_traits()
	var/datum/dna/owner_dna = owner.has_dna()
	if (!owner_dna)
		return

	// to make sure we don't remove another splat's species traits
	var/list/other_splat_species_traits = list()
	for (var/datum/splat/splat in (owner.splats - src))
		other_splat_species_traits |= splat.splat_species_traits

	// remove this splat's species traits
	for (var/species_trait in splat_species_traits)
		if (species_trait in other_splat_species_traits)
			continue

		owner_dna.species.species_traits -= species_trait

/datum/splat/proc/remove_traits()
	// to make sure we don't remove another splat's traits
	var/list/other_splat_traits = list()
	for (var/datum/splat/splat in (owner.splats - src))
		other_splat_traits |= splat.splat_traits

	// remove this splat's traits
	for (var/trait in splat_traits)
		if (trait in other_splat_traits)
			continue

		REMOVE_TRAIT(owner, trait, SPLAT_TRAIT)

/datum/splat/proc/remove_actions()
	// to make sure we don't remove another splat's actions
	var/list/other_splat_actions = list()
	for (var/datum/splat/splat in (owner.splats - src))
		other_splat_actions |= splat.splat_actions

	// actually remove the actions
	for (var/removing_action in splat_actions)
		if (removing_action in other_splat_actions)
			continue

		for (var/datum/action/action in owner.actions)
			if (!istype(action, removing_action))
				continue

			action.Remove()

/* POWER MANAGEMENT */
// standardise this all when the power system is made universal
/datum/splat/proc/create_powers(list/power_types, list/levels)
	return

/datum/splat/proc/add_power(power_type, level)
	return

/datum/splat/proc/remove_power(power_type)
	return

/* RESOURCE MANAGEMENT */
/datum/splat/proc/get_resource(resource)
	return resources[resource]

/datum/splat/proc/add_resource(resource, amount = 1)
	if (!resource || (amount <= 0))
		return FALSE

	if (!(resource in resources) || !(resource in max_resources))
		return FALSE

	if (resources[resource] == max_resources[resource])
		return FALSE

	resources[resource] = min(resources[resource] + amount, max_resources[resource])

	return TRUE

/datum/splat/proc/remove_resource(resource, amount = 1)
	if (!resource || (amount <= 0))
		return FALSE

	if (!(resource in resources) || !(resource in max_resources))
		return FALSE

	if ((resources[resource] - amount) < 0)
		return FALSE

	resources[resource] -= amount

	return TRUE

/* DIRECT SPLAT INTERACTION */
/mob/proc/get_splat(splat_type)
	RETURN_TYPE(/datum/splat)

	return

/mob/living/get_splat(splat_type)
	RETURN_TYPE(/datum/splat)

	for (var/datum/splat/splat in splats)
		if (!istype(splat, splat_type))
			continue

		return splat

/mob/proc/is_splat_incompatible(splat_type)
	return

/mob/living/is_splat_incompatible(splat_type)
	for (var/datum/splat/splat in splats)
		if (splat_type in splat.incompatible_splats)
			return TRUE
		if (splat.type == splat_type)
			return TRUE

	return FALSE
