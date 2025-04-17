/datum/splat/vampire/ghoul
	selectable = TRUE
	whitelisted = FALSE

	var/mob/living/regnant

/datum/splat/vampire/ghoul/New(mob/living/regnant)
	. = ..()

	src.regnant = regnant
