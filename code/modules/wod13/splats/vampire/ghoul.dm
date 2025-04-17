/datum/splat/vampire/ghoul
	selectable = TRUE
	whitelisted = FALSE

	var/mob/living/regnant

/datum/splat/vampire/ghoul/New(mob/living/regnant)
	. = ..()

	src.regnant = regnant

/datum/splat/vampire/ghoul/on_gain()
	. = ..()

	// Ghouls get 1st rank bloodheal
	add_power(/datum/discipline/bloodheal, 1)
