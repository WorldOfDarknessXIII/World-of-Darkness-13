/obj/structure/werewolf_totem
	name = "Tribe Totem"
	desc = "Gives power to all Garou of that tribe and steals it from others."
	icon = 'icons/mob/32x64.dmi'
	icon_state = "glassw"
	plane = GAME_PLANE
	layer = SPACEVINE_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/tribe
	var/totem_health = 500
	var/obj/overlay/totem_light_overlay
	var/totem_overlay_color = "#FFFFFF"

	var/turf/teleport_turf
	var/opening = FALSE

/obj/structure/werewolf_totem/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(I.force)
		adjust_totem_health(round(I.force/2))

/obj/structure/werewolf_totem/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	. = ..()
	adjust_totem_health(round(P.damage/2))

/obj/structure/werewolf_totem/Initialize()
	. = ..()
	for(var/obj/effect/landmark/teleport_mark/T in GLOB.landmarks_list)
		if(T.tribe == tribe)
			teleport_turf = get_turf(T)
	set_light(3, 0.5, totem_overlay_color)
	GLOB.totems += src
	totem_light_overlay = new(src)
	totem_light_overlay.icon = icon
	totem_light_overlay.icon_state = "[icon_state]_overlay"
	totem_light_overlay.plane = ABOVE_LIGHTING_PLANE
	totem_light_overlay.layer = ABOVE_LIGHTING_LAYER
	totem_light_overlay.color = totem_overlay_color
	overlays |= totem_light_overlay

/obj/structure/werewolf_totem/proc/adjust_totem_health(amount)
	icon_state = "[initial(icon_state)]_broken"
	totem_light_overlay.icon_state = "[icon_state]_overlay"

/obj/structure/werewolf_totem/wendigo
	name = "Wendigo Totem"
	desc = "Gives power to all Garou of that tribe and steals it from others."
	icon_state = "wendigo"
	tribe = "Wendigo"
	totem_overlay_color = "#81ff4f"

/obj/structure/werewolf_totem/glasswalker
	name = "Glasswalker Totem"
	desc = "Gives power to all Garou of that tribe and steals it from others."
	icon_state = "glassw"
	tribe = "Glasswalkers"
	totem_overlay_color = "#35b0ff"

/obj/structure/werewolf_totem/spiral
	name = "Spiral Totem"
	desc = "Gives power to all Garou of that tribe and steals it from others."
	icon = 'code/modules/wod13/64x32.dmi'
	icon_state = "spiral"
	tribe = "Black Spiral Dancers"
	totem_overlay_color = "#ff5235"

/obj/effect/landmark/teleport_mark
	name = "Teleport"
	icon_state = "x"
	var/tribe

/obj/structure/werewolf_totem/attack_hand(mob/user)
	. = ..()
