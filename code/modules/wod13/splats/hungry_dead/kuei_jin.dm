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
		RESOURCE_DEMON_CHI = 5
	)
	resources = list(
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

/datum/splat/hungry_dead/kuei_jin/on_gain()
	. = ..()

	RegisterSignal(owner, COMSIG_MOB_DRINK_VITAE, PROC_REF(handle_drinking_vitae))

/datum/splat/hungry_dead/kuei_jin/proc/handle_drinking_vitae(mob/living/source, mob/living/vampire, amount)
	SIGNAL_HANDLER

	// make sure they're actually getting the vitae in them
	if (HAS_TRAIT(owner, TRAIT_ALLERGIC_TO_VITAE))
		return

	// flavour for Kuei-jin drinking Vitae
	to_chat(owner, span_medradio("The Kin-jin's blood becomes bitter <b>Yin Chi</b> in your body."))

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
