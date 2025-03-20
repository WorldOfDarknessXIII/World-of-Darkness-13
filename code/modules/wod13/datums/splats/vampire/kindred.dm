/datum/splat/vampire/kindred
	name = "Kindred"
	desc = "Undead predators that have been feeding on humanity since stone was first turned into tools. They use the powers of their stolen blood to control human societies."

	splat_traits = list(
		TRAIT_LIMBATTACHMENT,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOBLEED,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOCRITDAMAGE
	)
	splat_species_traits = list(
		DRINKSBLOOD
	)
	splat_actions = list(
		/datum/action/give_vitae,
		/datum/action/blood_power
	)

	max_resources = list(
		RESOURCE_VITAE = 10,
		RESOURCE_HUMANITY = 10
	)
	resources = list(
		RESOURCE_VITAE = 10,
		RESOURCE_HUMANITY = 7
	)
	power_type = /datum/discipline
	replace_splats = list(
		/datum/splat/vampire
	)
	incompatible_splats = list(
		/datum/splat/hungry_dead/kuei_jin
	)

	var/datum/vampireclane/clan

/datum/splat/vampire/kindred/proc/give_vitae(mob/living/victim, to_give = 1)

/datum/splat/vampire/kindred/proc/embrace(mob/living/victim)

/datum/splat/vampire/kindred/proc/ghoul(mob/living/victim)

/datum/splat/vampire/kindred/proc/bloodbond(mob/living/victim)

/mob/proc/can_embrace()
	if (HAS_TRAIT(src, TRAIT_CANNOT_BE_EMBRACED))
		return FALSE

	return TRUE

/mob/living/carbon/can_embrace()
	. = ..()
	if (!.)
		return .

	var/obj/item/organ/brain/brain = getorgan(/obj/item/organ/brain)
	if (!brain)
		return FALSE
	if (brain.organ_flags & ORGAN_FAILING)
		return FALSE

	return TRUE
