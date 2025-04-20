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

	power_type = /datum/chi_discipline
	replace_splats = list(
		/datum/splat
	)

	selectable = TRUE
	whitelisted = TRUE

	var/dharma_level
	var/datum/dharma/dharma
	var/po
	var/hun

	//Is P'o doing it's thing or defending the host
	var/po_combat = FALSE
	//Which Chi is used to animate last
	var/animated = "None"
	var/atom/po_focus

	COOLDOWN_DECLARE(torpor_timer)
	COOLDOWN_DECLARE(po_call)
	COOLDOWN_DECLARE(chi_heal)

/datum/splat/hungry_dead/kuei_jin/New(dharma_level = 1, dharma, po, hun)
	. = ..()

	src.dharma_level = dharma_level
	src.dharma = dharma
	src.po = po
	src.hun = hun

/datum/splat/hungry_dead/kuei_jin/on_gain()
	. = ..()

	set_dharma_level(dharma_level)

	// Register relevant signals
	RegisterSignal(owner, COMSIG_MOB_DRINK_VITAE, PROC_REF(handle_drinking_vitae))
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(handle_death))

/datum/splat/hungry_dead/kuei_jin/proc/set_dharma_level(dharma_level)
	src.dharma_level = dharma_level

	// Makes Yin Chi, Yang Chi, Hun, and Po conform to maximums
	update_virtues()

	// Handle draining breath action, which is only available at Dharma 5+
	if (dharma_level >= 5)
		var/datum/action/breathe_chi/drain_breath
		for (var/datum/action/breathe_chi/found_action in owner.actions)
			drain_breath = found_action

		if (!drain_breath)
			drain_breath = new
			drain_breath.Grant(owner)
	else
		for (var/datum/action/breathe_chi/breathe_chi_action in owner.actions)
			breathe_chi_action.Destroy()

	// Handle draining chi through osmosis, which is only available at Dharma 6+
	if (dharma_level >= 6)
		var/datum/action/area_chi/osmosis
		for (var/datum/action/area_chi/found_action in owner.actions)
			osmosis = found_action

		if (!osmosis)
			osmosis = new
			osmosis.Grant(owner)
	else
		for (var/datum/action/area_chi/osmosis in owner.actions)
			osmosis.Destroy()

/datum/splat/hungry_dead/kuei_jin/proc/update_virtues()
	var/virtue_pair_limit = max(10, dharma_level * 2)

	var/total_chi = owner.max_yin_chi + owner.max_yang_chi
	var/total_virtues = hun + owner.max_demon_chi

	var/chi_discrepancy = virtue_pair_limit - total_chi
	var/virtue_discrepancy = virtue_pair_limit - total_virtues

	if ((chi_discrepancy == 0) && (virtue_discrepancy == 0))
		return

	owner.max_yin_chi += chi_discrepancy / 2
	owner.max_yang_chi += chi_discrepancy / 2
	owner.yin_chi = min(owner.yin_chi, owner.max_yin_chi)
	owner.yang_chi = min(owner.yang_chi, owner.max_yang_chi)

	hun += virtue_discrepancy / 2
	owner.max_demon_chi += virtue_discrepancy / 2
	owner.demon_chi = min(owner.demon_chi, owner.max_demon_chi)

/datum/splat/hungry_dead/kuei_jin/proc/po_trigger(atom/source, affected_type)
	if (affected_type && (po != affected_type))
		return
	if(HAS_TRAIT(owner, TRAIT_IN_FRENZY))
		return
	if(!COOLDOWN_FINISHED(src, po_call))
		return
	COOLDOWN_START(src, po_call, 10 SECONDS)

	po_focus = source
	owner.demon_chi = min(owner.demon_chi + 1, owner.max_demon_chi)
	to_chat(owner, span_warning("Some <b>DEMON</b> Chi fills you..."))

/datum/splat/hungry_dead/kuei_jin/proc/check_balance()
	if (owner.max_yin_chi > owner.max_yang_chi + 3)
		return "Yin"
	else if (owner.max_yang_chi > owner.max_yin_chi + 3)
		return "Yang"

	return "Balanced"

/datum/splat/hungry_dead/kuei_jin/proc/handle_drinking_vitae(mob/living/source, mob/living/vampire, amount)
	SIGNAL_HANDLER

	// make sure they're actually getting the vitae in them
	if (HAS_TRAIT(owner, TRAIT_ALLERGIC_TO_VITAE))
		return

	// flavour for Kuei-jin drinking Vitae
	to_chat(owner, span_medradio("The Kin-jin's blood becomes bitter <b>Yin Chi</b> in your body."))

/datum/splat/hungry_dead/kuei_jin/proc/handle_death(mob/living/source, gibbed)
	SIGNAL_HANDLER

	ADD_TRAIT(source, TRAIT_CANNOT_BE_EMBRACED, VAMPIRE_TRAIT)

	SEND_SOUND(source, sound('code/modules/wod13/sounds/final_death.ogg', 0, 0, 50))

	source.ghostize(FALSE)

	if (!ishuman(source))
		return
	var/mob/living/carbon/human/kuei_jin = source

	if (HAS_TRAIT(kuei_jin, TRAIT_IN_FRENZY))
		kuei_jin.exit_frenzymod()

	var/years_undead = kuei_jin.chronological_age - kuei_jin.age
	switch (years_undead)
		if (-INFINITY to 10) //normal corpse
			return
		if (10 to 50)
			kuei_jin.rot_body(1) //skin takes on a weird colouration
			kuei_jin.visible_message(span_notice("[src]'s skin loses some of its colour."))
		if (50 to 100)
			kuei_jin.rot_body(2) //looks slightly decayed
			kuei_jin.visible_message(span_notice("[src]'s skin rapidly decays."))
		if (100 to 150)
			kuei_jin.rot_body(3) //looks very decayed
			kuei_jin.visible_message(span_warning("[src]'s body rapidly decomposes!"))
		if (150 to 200)
			kuei_jin.rot_body(4) //mummified skeletonised corpse
			kuei_jin.visible_message(span_warning("[src]'s body rapidly skeletonises!"))
		if (200 to INFINITY)
			playsound(kuei_jin, 'code/modules/wod13/sounds/vicissitude.ogg', 80, TRUE)
			kuei_jin.lying_fix()
			kuei_jin.dir = SOUTH
			INVOKE_ASYNC(kuei_jin, TYPE_PROC_REF(/mob/living/carbon/human, dust), TRUE, TRUE)

/mob/living/carbon/human/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	. = ..()
	if(!message)
		return
	if(say_mod(message) != verb_yell)
		return

	for(var/mob/living/carbon/human/hearer in ohearers(5, src))
		var/datum/splat/hungry_dead/kuei_jin/kuei_jin = is_kuei_jin(hearer)
		kuei_jin.po_trigger(src, "Legalist")
