#define REGENERATION_FILTER "healing_glow"

/**
 * # Regenerator component
 *
 * A mob with this component will regenerate its health over time, as long as it has not received damage
 * in the last X seconds. Taking any damage will reset this cooldown.
 */
/datum/component/regenerator
	/// You will only regain health if you haven't been hurt for this many seconds
	var/regeneration_delay
	/// Brute reagined every second
	var/brute_per_second
	/// Burn reagined every second
	var/burn_per_second
	/// Toxin reagined every second
	var/tox_per_second
	/// Oxygen reagined every second
	var/oxy_per_second
	/// If TRUE, we'll try to heal wounds as well. Useless for non-humans.
	var/heals_wounds = FALSE
	/// Colour of regeneration animation, or none if you don't want one
	var/outline_colour
	/// When this timer completes we start restoring health, it is a timer rather than a cooldown so we can do something on its completion
	var/regeneration_start_timer

/datum/component/regenerator/Initialize(
	regeneration_delay = 6 SECONDS,
	brute_per_second = 2,
	burn_per_second = 0,
	tox_per_second = 0,
	oxy_per_second = 0,
	heals_wounds = FALSE,
	outline_colour = COLOR_PALE_GREEN,
)
	if (!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	src.regeneration_delay = regeneration_delay
	src.brute_per_second = brute_per_second
	src.burn_per_second = burn_per_second
	src.tox_per_second = tox_per_second
	src.oxy_per_second = oxy_per_second
	src.heals_wounds = heals_wounds
	src.outline_colour = outline_colour

/datum/component/regenerator/RegisterWithParent()
	. = ..()

/datum/component/regenerator/UnregisterFromParent()
	. = ..()
	if(regeneration_start_timer)
		deltimer(regeneration_start_timer)
	stop_regenerating()

/datum/component/regenerator/Destroy(force)
	stop_regenerating()
	. = ..()
	if(regeneration_start_timer)
		deltimer(regeneration_start_timer)

/// Start processing health regeneration, and show animation if provided
/datum/component/regenerator/proc/start_regenerating()
	if (!should_be_regenning(parent))
		return
	var/mob/living/living_parent = parent
	living_parent.visible_message(span_notice("[living_parent]'s wounds begin to knit closed!"))
	START_PROCESSING(SSobj, src)
	regeneration_start_timer = null
	if (!outline_colour)
		return
	living_parent.add_filter(REGENERATION_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 0, "size" = 1))
	var/filter = living_parent.get_filter(REGENERATION_FILTER)
	animate(filter, alpha = 200, time = 0.5 SECONDS, loop = -1)
	animate(alpha = 0, time = 0.5 SECONDS)

/datum/component/regenerator/proc/stop_regenerating()
	STOP_PROCESSING(SSobj, src)
	var/mob/living/living_parent = parent
	var/filter = living_parent.get_filter(REGENERATION_FILTER)
	animate(filter)
	living_parent.remove_filter(REGENERATION_FILTER)

/datum/component/regenerator/process(seconds_per_tick = SSMOBS_DT)
	if (!should_be_regenning(parent))
		stop_regenerating()
		return

	var/mob/living/living_parent = parent
	// Heal bonus for being in crit. Only applies to carbons
	var/heal_mod = HAS_TRAIT(living_parent, TRAIT_CRITICAL_CONDITION) ? 2 : 1

	var/need_mob_update = FALSE
	if(brute_per_second)
		need_mob_update += living_parent.adjustBruteLoss(-1 * heal_mod * brute_per_second * seconds_per_tick, updating_health = FALSE)
	if(burn_per_second)
		need_mob_update += living_parent.adjustFireLoss(-1 * heal_mod * burn_per_second * seconds_per_tick, updating_health = FALSE)
	if(tox_per_second)
		need_mob_update += living_parent.adjustToxLoss(-1 * heal_mod * tox_per_second * seconds_per_tick, updating_health = FALSE)
	if(oxy_per_second)
		need_mob_update += living_parent.adjustOxyLoss(-1 * heal_mod * oxy_per_second * seconds_per_tick, updating_health = FALSE)

	if(heals_wounds && iscarbon(parent))
		var/mob/living/carbon/carbon_parent = living_parent
		for(var/datum/wound/iter_wound as anything in carbon_parent.all_wounds)
			if(SPT_PROB(2 - (iter_wound.severity / 2), seconds_per_tick))
				iter_wound.remove_wound()
				need_mob_update++

	if(need_mob_update)
		living_parent.updatehealth()

/// Checks if the passed mob is in a valid state to be regenerating
/datum/component/regenerator/proc/should_be_regenning(mob/living/who)
	if(who.stat == DEAD)
		return FALSE
	if(heals_wounds && iscarbon(who))
		var/mob/living/carbon/carbon_who = who
		if(length(carbon_who.all_wounds) > 0)
			return TRUE
	if(who.health != who.maxHealth)
		return TRUE
	return FALSE

#undef REGENERATION_FILTER
