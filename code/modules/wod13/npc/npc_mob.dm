/mob/living/npc/
	name = "npc mob subtype master"
	desc = "hi, if you're reading me, someone made a mistake. Most likely the coder. Please report this as a bug."
	icon = 'icons/mob/npc.dmi'
	icon_state = "npc"

	var/icon_generator_datum = /datum/icon_generator //This can be set to a subpath for a specifc equipment set.

/mob/living/npc/Initialize()
	. = ..()
	var/datum/icon_generator/generator_datum = new icon_generator_datum(src)
	generator_datum.generate_icon()
