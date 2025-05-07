/mob/living/npc/
	name = "npc mob subtype master"
	desc = "hi, if you're reading me, someone made a mistake. Most likely the coder. Please report this as a bug."
	icon = 'icons/mob/npc.dmi'
	icon_state = "npc"
	density = 1
	mouse_opacity = 1
	melee_damage_lower = 10
	melee_damage_upper = 20

	var/icon_generator_datum = /datum/icon_generator //This can be set to a subpath for a specifc equipment set.
	var/datum/combat_ai/ai_datum

/mob/living/npc/Initialize()
	. = ..()
	var/datum/icon_generator/generator_datum = new icon_generator_datum(src)
	generator_datum.generate_icon()
	ai_datum = new(src)

/mob/living/npc/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness)
	if(!damage || !damagetype) return
	ai_datum.process_damage(1, damagetype)
