/datum/splat/hungry_dead/kuei_jin
	name = "Kuei-jin"
	desc = "The tormented dead, having escaped their eternal punishment to return to their bodies and start on the path to Enlightenment."

	splat_traits = list(
		TRAIT_LIMBATTACHMENT,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOBLEED,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOCRITDAMAGE,
		TRAIT_ROTS_IN_SUNLIGHT,
		TRAIT_CAN_TORPOR
	)
	splat_species_traits = list(
		DRINKSBLOOD
	)
	splat_actions = list(
		/datum/action/reanimate_yang,
		/datum/action/reanimate_yin
	)

	max_resources = list(
		RESOURCE_YANG_CHI = 5,
		RESOURCE_YIN_CHI = 5,
		RESOURCE_DEMON_CHI = 5
	)
	resources = list(
		RESOURCE_YANG_CHI = 5,
		RESOURCE_YIN_CHI = 5,
		RESOURCE_DEMON_CHI = 5
	)
	power_type = /datum/chi_discipline
	replace_splats = list(
		/datum/splat/vampire,
		/datum/splat/werewolf
	)

	selectable = TRUE
	whitelisted = TRUE

	var/datum/dharma/dharma
	COOLDOWN_DECLARE(torpor_timer)

/mob/living/carbon/human/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	. = ..()
	if(!message)
		return
	if(say_mod(message) != verb_yell)
		return

	for(var/mob/living/carbon/human/hearer in ohearers(5, src))
		var/datum/splat/hungry_dead/kuei_jin/kuei_jin = is_kuei_jin(hearer)
		if(kuei_jin?.dharma.Po != "Legalist")
			continue
		kuei_jin.dharma.roll_po(src, hearer)
