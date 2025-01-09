/obj/effect/temp_visual/dir_setting/muzzle_flash_highlight
	name = "muzzle flash highlight"
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "firing"

	var/atom/movable/firing_effect_movable
	anchored = FALSE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	duration = 2 //in deciseconds

/obj/effect/temp_visual/dir_setting/muzzle_flash_highlight/Initialize(mapload, set_dir)
	. = ..()
	firing_effect_movable = new(get_turf(src))
	firing_effect_movable.set_light(3, 2, "#ffedbb")
	animate(src, alpha = 0, time = 2)

/obj/effect/temp_visual/dir_setting/muzzle_flash_highlight/Destroy()
	. = ..()
	qdel(firing_effect_movable)
