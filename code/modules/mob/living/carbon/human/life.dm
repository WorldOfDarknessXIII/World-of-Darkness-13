

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!


/mob/living/carbon/human/Life()
	if (notransform)
		return

	. = ..()

	if (QDELETED(src))
		return FALSE

	//Body temperature stability and damage
	dna.species.handle_body_temperature(src)

	if(!IS_IN_STASIS(src))
		if(.) //not dead

			for(var/datum/mutation/human/HM in dna.mutations) // Handle active genes
				HM.on_life()

		if(stat != DEAD)
			//heart attack stuff
			handle_heart()
			handle_liver()

		dna.species.spec_life(src) // for mutantraces
	else
		for(var/i in all_wounds)
			var/datum/wound/iter_wound = i
			iter_wound.on_stasis()

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	if(stat != DEAD)
		return TRUE



/mob/living/carbon/human/handle_traits()
	if (getOrganLoss(ORGAN_SLOT_BRAIN) >= 60)
		SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "brain_damage", /datum/mood_event/brain_damage)
	else
		SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "brain_damage")
	return ..()

/mob/living/carbon/human/breathe()
	if(!dna.species.breathe(src))
		..()

/mob/living/carbon/human/check_breath(datum/gas_mixture/breath)
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return

	var/L = getorganslot(ORGAN_SLOT_LUNGS)

	if(!L)
		if(health >= crit_threshold)
			adjustOxyLoss(HUMAN_MAX_OXYLOSS + 1)
		else if(!HAS_TRAIT(src, TRAIT_NOCRITDAMAGE))
			adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		failed_last_breath = TRUE

		var/datum/species/S = dna.species

		if(S.breathid == "o2")
			throw_alert("not_enough_oxy", /atom/movable/screen/alert/not_enough_oxy)
		else if(S.breathid == "tox")
			throw_alert("not_enough_tox", /atom/movable/screen/alert/not_enough_tox)
		else if(S.breathid == "co2")
			throw_alert("not_enough_co2", /atom/movable/screen/alert/not_enough_co2)
		else if(S.breathid == "n2")
			throw_alert("not_enough_nitro", /atom/movable/screen/alert/not_enough_nitro)

		return FALSE
	else
		if(istype(L, /obj/item/organ/lungs))
			var/obj/item/organ/lungs/lun = L
			lun.check_breath(breath,src)

/// Environment handlers for species
/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment)
	// If we are in a cryo bed do not process life functions
	if(istype(loc, /obj/machinery/atmospherics/components/unary/cryo_cell))
		return

	dna.species.handle_environment(environment, src)

/**
 * Adjust the core temperature of a mob
 *
 * vars:
 * * amount The amount of degrees to change body temperature by
 * * min_temp (optional) The minimum body temperature after adjustment
 * * max_temp (optional) The maximum body temperature after adjustment
 */
/mob/living/carbon/human/proc/adjust_coretemperature(amount, min_temp=0, max_temp=INFINITY)
	coretemperature = clamp(coretemperature + amount, min_temp, max_temp)

/**
 * get_body_temperature Returns the body temperature with any modifications applied
 *
 * This applies the result from proc/get_body_temp_normal_change() against the bodytemp_normal
 * for the species and returns the result
 *
 * arguments:
 * * apply_change (optional) Default True This applies the changes to body temperature normal
 */
/mob/living/carbon/human/get_body_temp_normal(apply_change=TRUE)
	if(!apply_change)
		return dna.species.bodytemp_normal
	return dna.species.bodytemp_normal + get_body_temp_normal_change()

///FIRE CODE
/mob/living/carbon/human/handle_fire()
	. = ..()
	if(.) //if the mob isn't on fire anymore
		return

	if(dna)
		. = dna.species.handle_fire(src) //do special handling based on the mob's species. TRUE = they are immune to the effects of the fire.

	if(!last_fire_update)
		last_fire_update = fire_stacks
	if((fire_stacks > HUMAN_FIRE_STACK_ICON_NUM && last_fire_update <= HUMAN_FIRE_STACK_ICON_NUM) || (fire_stacks <= HUMAN_FIRE_STACK_ICON_NUM && last_fire_update > HUMAN_FIRE_STACK_ICON_NUM))
		last_fire_update = fire_stacks
		update_fire()


/mob/living/carbon/human/proc/get_thermal_protection()
	var/thermal_protection = 0 //Simple check to estimate how protected we are against multiple temperatures
	if(wear_suit)
		if(wear_suit.max_heat_protection_temperature >= FIRE_SUIT_MAX_TEMP_PROTECT)
			thermal_protection += (wear_suit.max_heat_protection_temperature*0.7)
	if(head)
		if(head.max_heat_protection_temperature >= FIRE_HELM_MAX_TEMP_PROTECT)
			thermal_protection += (head.max_heat_protection_temperature*THERMAL_PROTECTION_HEAD)
	thermal_protection = round(thermal_protection)
	return thermal_protection

/mob/living/carbon/human/IgniteMob()
	//If have no DNA or can be Ignited, call parent handling to light user
	//If firestacks are high enough
	if(!dna || dna.species.CanIgniteMob(src))
		return ..()
	. = FALSE //No ignition

/mob/living/carbon/human/extinguish_mob()
	if(!dna || !dna.species.extinguish_mob(src))
		last_fire_update = null
		..()
//END FIRE CODE


/mob/living/carbon/human/handle_random_events()
	//Puke if toxloss is too high
	if(!stat)
		if(getToxLoss() >= 45 && nutrition > 20)
			lastpuke += prob(50)
			if(lastpuke >= 50) // about 25 second delay I guess
				vomit(20)
				lastpuke = 0


/mob/living/carbon/human/has_smoke_protection()
	if(isclothing(wear_mask))
		if(wear_mask.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	if(isclothing(glasses))
		if(glasses.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	if(isclothing(head))
		var/obj/item/clothing/CH = head
		if(CH.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	return ..()

/mob/living/carbon/human/proc/handle_heart()
	var/we_breath = !HAS_TRAIT_FROM(src, TRAIT_NOBREATH, SPECIES_TRAIT)

	if(!undergoing_cardiac_arrest())
		return

	if(we_breath)
		adjustOxyLoss(8)
		Unconscious(80)
	// Tissues die without blood circulation
	adjustBruteLoss(2)

