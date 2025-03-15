/datum/splat
	var/name = "Splat"
	var/desc = "A game line in the World of Darkness franchise."
	var/splat_traits = list()
	var/splat_species_traits = list()
	var/splat_actions = list()
	var/power_type = /datum/discipline
	var/list/datum/discipline/powers = list()
	var/mob/living/owner

/datum/splat/proc/assign(mob/living/owner)
	src.owner = owner
	on_gain()

/datum/splat/proc/unassign()
	owner.splats -= src
	on_lose()
	qdel(src)

/datum/splat/proc/on_gain()
	var/datum/dna/owner_dna = owner.has_dna()

/datum/splat/proc/on_lose()
	var/datum/dna/owner_dna = owner.has_dna()

/mob/proc/add_splat(splat_type)
	return

/mob/living/add_splat(splat_type)
	var/datum/splat/new_splat = new splat_type
	new_splat.assign(src)

/mob/proc/remove_splat(splat_type)
	return

/mob/living/remove_splat(splat_type)
	var/datum/splat/removing_splat = get_splat(splat_type)
	removing_splat.unassign()

/mob/proc/get_splat(splat_type)
	return

/mob/living/get_splat(splat_type)
	for (var/datum/splat/splat in splats)
		if (!istype(splat, splat_type))
			continue

		return splat
