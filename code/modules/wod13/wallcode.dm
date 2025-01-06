//Smooth Operator soset biby

/obj/effect/addwall
	name = "Debug"
	desc = "First rule of debug placeholder: Do not talk about debug placeholder."
	icon = 'code/modules/wod13/addwalls.dmi'
	base_icon_state = "wall"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYERS_LAYER
	anchored = TRUE
	mouse_opacity = 0
//	vis_flags = VIS_HIDE

/obj/effect/addwall/Crossed(atom/movable/AM, oldloc)
	. = ..()
	var/someoneshere = FALSE
	for(var/mob/living/L in get_turf(src))
		if(L)
			someoneshere = TRUE
	if(!someoneshere)
		alpha = 255
	else
		alpha = 128

/obj/effect/addwall/Uncrossed(atom/movable/AM)
	. = ..()
	var/someoneshere = FALSE
	for(var/mob/living/L in get_turf(src))
		if(L)
			someoneshere = TRUE
	if(!someoneshere)
		alpha = 255
	else
		alpha = 128

/turf/closed/wall/vampwall
	name = "old brick wall"
	desc = "A huge chunk of old bricks used to separate rooms."
	icon = 'code/modules/wod13/walls.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	opacity = TRUE
	density = TRUE
	smoothing_flags = SMOOTH_BITMASK

	var/obj/effect/addwall/addwall
	var/low = FALSE
	var/window

/turf/closed/wall/vampwall/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(low)
		if(.)
			return
		if(istype(mover) && (mover.pass_flags & PASSTABLE))
			return TRUE
		if(istype(mover.loc, /turf/closed/wall/vampwall)) //Because "low" type walls aren't standardized and are subtypes of different wall types
			var/turf/closed/wall/vampwall/vw = mover.loc
			if(vw.low)
				return TRUE
		//Roughly the same elevation
		if(locate(/obj/structure/table) in get_turf(mover))
			return TRUE

/turf/closed/wall/vampwall/attackby(obj/item/W, mob/user, params)
	return

/turf/closed/wall/vampwall/attack_hand(mob/user)
	return

/*/turf/closed/wall/vampwall/attack_hand(mob/user)
	if(ismob(user))
		var/mob/living/carbon/human/H = user

		var/new_z = H.z + 1
		var/turf/above_turf = locate(H.x, H.y, new_z)
		if(H.body_position != STANDING_UP)
			return
		if(above_turf && istype(above_turf, /turf/open/openspace))
			to_chat(H, "<span class='notice'>You start climbing up...")

			var/initial_x = H.x
			var/initial_y = H.y
			var/initial_z = H.z

			spawn(20)
				if(H.x != initial_x || H.y != initial_y || H.z != initial_z)
					return

				var/roll = rand(1, 20)
				var/physique = H.physique
				if(roll + physique*2 >= 15)
					H.loc = above_turf
					var/turf/forward_turf = get_step(H.loc, H.dir)
					if(forward_turf && !forward_turf.density)
						H.forceMove(forward_turf)
						to_chat(H, "<span class='notice'>You climb up.</span>")
				else
					to_chat(user, ("<span class='warning'>You fail to climb up.</span>"))
	else
		return
*/

/turf/closed/wall/vampwall/ex_act(severity, target)
	return

/turf/closed/wall/vampwall/Initialize()
	..()
	if(window)
		var/obj/W = new window(src)
		W.plane = GAME_PLANE
		W.layer = ABOVE_ALL_MOB_LAYER
	else if(!low)
		addwall = new(get_step(src, NORTH))
		addwall.icon_state = icon_state
		addwall.name = name
		addwall.desc = desc

	if(low)
		AddElement(/datum/element/climbable)

/turf/closed/wall/vampwall/set_smoothed_icon_state(new_junction)
	..()
	if(addwall)
		addwall.icon_state = icon_state

/turf/closed/wall/vampwall/Destroy()
	..()
	if(addwall)
		qdel(addwall)

/turf/closed/wall/vampwall/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE //Let the windows block the air transfer

/turf/closed/wall/vampwall/low/window
	icon_state = "wall-window"
	window = /obj/structure/window/fulltile

/turf/closed/wall/vampwall/rich
	name = "rich-looking wall"
	desc = "A huge chunk of expensive bricks used to separate rooms."
	icon_state = "rich-0"
	base_icon_state = "rich"

/turf/closed/wall/vampwall/rich/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE

/turf/closed/wall/vampwall/rich/low/window
	icon_state = "rich-window"
	window = /obj/structure/window/fulltile

/turf/closed/wall/vampwall/rich/low/window/reinforced
	icon_state = "rich-reinforced"
	window = /obj/structure/window/reinforced/fulltile/indestructable

/turf/closed/wall/vampwall/junk
	name = "junk brick wall"
	desc = "A huge chunk of dirty bricks used to separate rooms."
	icon_state = "junk-0"
	base_icon_state = "junk"

/turf/closed/wall/vampwall/junk/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE

/turf/closed/wall/vampwall/junk/low/window
	icon_state = "junk-window"
	window = /obj/structure/window/fulltile

/turf/closed/wall/vampwall/junk/alt
	icon_state = "junkalt-0"
	base_icon_state = "junkalt"

/turf/closed/wall/vampwall/junk/alt/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE

/turf/closed/wall/vampwall/junk/alt/low/window
	icon_state = "junkalt-window"
	window = /obj/structure/window/fulltile

/turf/closed/wall/vampwall/market
	name = "concrete wall"
	desc = "A huge chunk of concrete used to separate rooms."
	icon_state = "market-0"
	base_icon_state = "market"

/turf/closed/wall/vampwall/market/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE

/turf/closed/wall/vampwall/market/low/window
	icon_state = "market-window"
	window = /obj/structure/window/fulltile

/turf/closed/wall/vampwall/market/low/window/reinforced
	icon_state = "market-reinforced"
	window = /obj/structure/window/reinforced/fulltile/indestructable

/turf/closed/wall/vampwall/old
	name = "old brick wall"
	desc = "A huge chunk of old bricks used to separate rooms."
	icon_state = "old-0"
	base_icon_state = "old"

/turf/closed/wall/vampwall/old/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE

/turf/closed/wall/vampwall/old/low/window
	icon_state = "old-window"
	window = /obj/structure/window/fulltile

/turf/closed/wall/vampwall/old/low/window/reinforced
	icon_state = "old-reinforced"
	window = /obj/structure/window/reinforced/fulltile/indestructable

/turf/closed/wall/vampwall/painted
	name = "painted brick wall"
	desc = "A huge chunk of painted bricks used to separate rooms."
	icon_state = "painted-0"
	base_icon_state = "painted"

/turf/closed/wall/vampwall/painted/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE

/turf/closed/wall/vampwall/painted/low/window
	icon_state = "painted-window"
	window = /obj/structure/window/fulltile

/turf/closed/wall/vampwall/painted/low/window/reinforced
	icon_state = "painted-reinforced"
	window = /obj/structure/window/reinforced/fulltile/indestructable

/turf/closed/wall/vampwall/rich/old
	name = "old rich-looking wall"
	desc = "A huge chunk of old bricks used to separate rooms."
	icon_state = "theater-0"
	base_icon_state = "theater"

/turf/closed/wall/vampwall/rich/old/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE

/turf/closed/wall/vampwall/rich/old/low/window
	icon_state = "theater-window"
	window = /obj/structure/window/fulltile

/turf/closed/wall/vampwall/rich/old/low/window/reinforced
	icon_state = "theater-reinforced"
	window = /obj/structure/window/reinforced/fulltile/indestructable

/turf/closed/wall/vampwall/brick
	name = "brick wall"
	desc = "A huge chunk of bricks used to separate rooms."
	icon_state = "brick-0"
	base_icon_state = "brick"

/turf/closed/wall/vampwall/brick/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE

/turf/closed/wall/vampwall/brick/low/window
	icon_state = "brick-window"
	window = /obj/structure/window/fulltile

/turf/closed/wall/vampwall/rock
	name = "rock wall"
	desc = "A huge chunk of rocks separating whole territory."
	icon_state = "rock-0"
	base_icon_state = "rock"

/turf/closed/wall/vampwall/city
	name = "wall"
	desc = "A huge chunk of concrete and bricks used to separate rooms."
	icon_state = "city-0"
	base_icon_state = "city"

/turf/closed/wall/vampwall/city/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE

/turf/closed/wall/vampwall/city/low/window
	icon_state = "city-window"
	window = /obj/structure/window/fulltile

/turf/closed/wall/vampwall/metal
	name = "metal wall"
	desc = "A huge chunk of metal used to separate rooms."
	icon_state = "metal-0"
	base_icon_state = "metal"

/turf/closed/wall/vampwall/metal/reinforced
	name = "reinforced metal wall"
	desc = "A huge chunk of reinforced metal used to separate rooms."
	icon_state = "metalreinforced-0"
	base_icon_state = "metalreinforced"

/turf/closed/wall/vampwall/metal/alt
	name = "metal wall"
	desc = "A huge chunk of metal used to separate rooms."
	icon_state = "metalalt-0"
	base_icon_state = "metalalt"

/turf/closed/wall/vampwall/metal/glass
	name = "metal wall"
	desc = "A huge chunk of metal used to separate rooms."
	icon_state = "metalglass-0"
	base_icon_state = "metalglass"
	opacity = FALSE

/turf/closed/wall/vampwall/bar
	name = "dark brick wall"
	desc = "A huge chunk of bricks used to separate rooms."
	icon_state = "bar-0"
	base_icon_state = "bar"

/turf/closed/wall/vampwall/bar/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE

/turf/closed/wall/vampwall/bar/low/window
	icon_state = "bar-window"
	window = /obj/structure/window/fulltile

/turf/closed/wall/vampwall/wood
	name = "wood wall"
	desc = "A huge chunk of dirty logs used to separate rooms."
	icon_state = "wood-0"
	base_icon_state = "wood"

/turf/closed/wall/vampwall/wood/low
	icon = 'code/modules/wod13/lowwalls.dmi'
	opacity = FALSE
	low = TRUE
	blocks_air = FALSE

/turf/closed/wall/vampwall/wood/low/window
	icon_state = "wood-window"
	window = /obj/structure/window/fulltile

/turf/closed/wall/vampwall/rust
	name = "rusty wall"
	desc = "A huge chunk of rusty metal used to separate rooms."
	icon_state = "rust-0"
	base_icon_state = "rust"

/turf/closed/wall/vampwall/dirtywood
	name = "dirty wood wall"
	desc = "A huge chunk of brown metal used to separate rooms."
	icon_state = "dirtywood-0"
	base_icon_state = "dirtywood"

/turf/closed/wall/vampwall/green
	name = "green wall"
	desc = "A huge chunk of green metal used to separate rooms."
	icon_state = "green-0"
	base_icon_state = "green"

/turf/closed/wall/vampwall/rustbad
	name = "rusty wall"
	desc = "A huge chunk of rusty metal used to separate rooms."
	icon_state = "rustbad-0"
	base_icon_state = "rustbad"

/turf/closed/wall/vampwall/redbrick
	name = "red brick wall"
	desc = "A huge chunk of red bricks used to separate rooms."
	icon_state = "redbrick-0"
	base_icon_state = "redbrick"

//TURFS

/obj/effect/decal/asphalt
	name = "asphalt"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "decal1"
	mouse_opacity = 0

/obj/effect/decal/asphalt/Initialize()
	..()
	icon_state = "decal[rand(1, 24)]"
	update_icon()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				alpha = 25

/obj/effect/decal/snow_overlay
	name = "snow"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "snow_overlay"
	alpha = 200
	mouse_opacity = 0

/obj/effect/decal/asphaltline
	name = "asphalt"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "line"
	mouse_opacity = 0

/obj/effect/decal/asphaltline/alt
	icon_state = "line_alt"

/obj/effect/decal/asphaltline/Initialize()
	..()
	icon_state = "[initial(icon_state)][rand(1, 3)]"
	update_icon()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)][rand(1, 3)]-snow"

/obj/effect/decal/crosswalk
	name = "asphalt"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "crosswalk1"
	mouse_opacity = 0

/obj/effect/decal/crosswalk/Initialize()
	..()
	icon_state = "crosswalk[rand(1, 3)]"
	update_icon()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "crosswalk[rand(1, 3)]-snow"

/turf/open/floor/plating/asphalt
	gender = PLURAL
	name = "asphalt"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "asphalt1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_ASPHALT
	barefootstep = FOOTSTEP_ASPHALT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/asphalt/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				new /obj/effect/decal/snow_overlay(src)
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW
	if(prob(50))
		icon_state = "asphalt[rand(1, 3)]"
		update_icon()
	if(prob(25))
		new /obj/effect/decal/asphalt(src)
	set_light(1, 0.5, "#a4b7ff")

/turf/open/floor/plating/asphalt/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/asphalt/ex_act(severity, target)
	contents_explosion(severity, target)

/obj/effect/decal/stock
	name = "stock"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "stock"
	mouse_opacity = 0

/turf/open/floor/plating/sidewalkalt
	gender = PLURAL
	name = "sidewalk"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "sidewalk_alt"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/sidewalkalt/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow[rand(1, 14)]"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

/turf/open/floor/plating/sidewalk
	gender = PLURAL
	name = "sidewalk"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "sidewalk1"
	var/number_of_variations = 3
	var/based_icon_state = "sidewalk"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/sidewalk/Initialize()
	. = ..()
	icon_state = "[based_icon_state][rand(1, number_of_variations)]"
	set_light(1, 0.5, "#a4b7ff")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow[rand(1, 14)]"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

/turf/open/floor/plating/sidewalk/poor
	icon_state = "sidewalk_poor1"
	based_icon_state = "sidewalk_poor"

/turf/open/floor/plating/sidewalk/rich
	icon_state = "sidewalk_rich1"
	number_of_variations = 6
	based_icon_state = "sidewalk_rich"

/turf/open/floor/plating/sidewalk/old
	icon_state = "sidewalk_old1"
	number_of_variations = 4
	based_icon_state = "sidewalk_old"

/turf/open/floor/plating/roofwalk
	gender = PLURAL
	name = "roof"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "roof"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/roofwalk/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow[rand(1, 14)]"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

//Airless version of this because they are used as a z-level 4 roof on a z-level 3 building, and since they aren't meant to be reached...
/turf/open/floor/plating/roofwalk/no_air
	blocks_air = 1

/obj/effect/decal/bordur
	name = "sidewalk"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "border"
	mouse_opacity = 0

/obj/effect/decal/bordur/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"
//				footstep = FOOTSTEP_SNOW
//				barefootstep = FOOTSTEP_SNOW
//				clawfootstep = FOOTSTEP_SNOW
//				heavyfootstep = FOOTSTEP_SNOW

/obj/effect/decal/bordur/corner
	icon_state = "border_corner"

//OTHER TURFS

/turf/open/floor/plating/parquetry
	gender = PLURAL
	name = "parquetry"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "parquet"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/parquetry/old
	icon_state = "parquet-old"

/turf/open/floor/plating/parquetry/rich
	icon_state = "parquet-rich"

/turf/open/floor/plating/granite
	gender = PLURAL
	name = "granite"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "granite"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/granite/black
	icon_state = "granite-black"

/turf/open/floor/plating/concrete
	gender = PLURAL
	name = "concrete"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "concrete1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/concrete/Initialize()
	..()
	icon_state = "concrete[rand(1, 4)]"

/turf/open/floor/plating/vampgrass
	gender = PLURAL
	name = "grass"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "grass1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TRAVA
	barefootstep = FOOTSTEP_TRAVA
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampgrass/Initialize()
	..()
	set_light(1, 0.5, "#a4b7ff")
	icon_state = "grass[rand(1, 3)]"
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow[rand(1, 14)]"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

/turf/open/floor/plating/vampcarpet
	gender = PLURAL
	name = "carpet"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "carpet_black"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampdirt
	gender = PLURAL
	name = "dirt"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "dirt"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_ASPHALT
	barefootstep = FOOTSTEP_ASPHALT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampdirt/Initialize()
	. = ..()
	set_light(1, 0.5, "#a4b7ff")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow[rand(1, 14)]"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

/turf/open/floor/plating/vampdirt/rails
	name = "rails"
	icon_state = "dirt_rails"

/turf/open/floor/plating/vampdirt/rails/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow_rails"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

/turf/open/floor/plating/vampplating
	gender = PLURAL
	name = "plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "plating"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampplating/mono
	icon_state = "plating-mono"

/turf/open/floor/plating/vampplating/stone
	icon_state = "plating-stone"

/turf/open/floor/plating/rough
	gender = PLURAL
	name = "rough floor"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "rough"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/rough/cave
	icon_state = "cave1"

/turf/open/floor/plating/rough/cave/Initialize()
	. = ..()
	icon_state = "cave[rand(1, 7)]"

/turf/open/floor/plating/stone
	gender = PLURAL
	name = "rough floor"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "stone"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/stone
	icon_state = "stone1"

/turf/open/floor/plating/stone/Initialize()
	.=..()
	icon_state = "cave[rand(1, 7)]"

/turf/open/floor/plating/toilet
	gender = PLURAL
	name = "plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "toilet1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/toilet/Initialize()
	..()
	icon_state = "toilet[rand(1, 9)]"

/turf/open/floor/plating/circled
	gender = PLURAL
	name = "fancy plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "circle1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/circled/Initialize()
	..()
	icon_state = "circle[rand(1, 8)]"

/turf/open/floor/plating/church
	gender = PLURAL
	name = "fancy plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "church1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/church/Initialize()
	..()
	icon_state = "church[rand(1, 4)]"

/turf/open/floor/plating/saint
	gender = PLURAL
	name = "fancy plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "saint1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/saint/Initialize()
	..()
	icon_state = "saint[rand(1, 2)]"

//OBOI

/obj/effect/decal/wallpaper
	name = "wall paint"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "wallpaper"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER	//WALLPAPER_LAYER dont work

/obj/effect/decal/wallpaper/Initialize()
	..()
	if(isclosedturf(loc))
		forceMove(get_step(src, SOUTH))
		pixel_y = 32

/obj/effect/decal/wallpaper/low
	icon_state = "wallpaper_low"

/obj/effect/decal/wallpaper/grey
	icon_state = "wallpaper-grey"

/obj/effect/decal/wallpaper/grey/low
	icon_state = "wallpaper-grey_low"

/obj/effect/decal/wallpaper/light
	icon_state = "wallpaper-light"

/obj/effect/decal/wallpaper/light/low
	icon_state = "wallpaper-light_low"

/obj/effect/decal/wallpaper/red
	icon_state = "wallpaper-asylum"

/obj/effect/decal/wallpaper/red/low
	icon_state = "wallpaper-asylum_low"

/obj/effect/decal/wallpaper/blue
	icon_state = "wallpaper-club"

/obj/effect/decal/wallpaper/blue/low
	icon_state = "wallpaper-club_low"

/obj/effect/decal/wallpaper/paper
	name = "wallpapers"
	icon_state = "wallpaper-cheap"

/obj/effect/decal/wallpaper/paper/low
	icon_state = "wallpaper-cheap_low"

/obj/effect/decal/wallpaper/paper/green
	icon_state = "wallpaper-green"

/obj/effect/decal/wallpaper/paper/green/low
	icon_state = "wallpaper-green_low"

/obj/effect/decal/wallpaper/paper/stripe
	icon_state = "wallpaper-stripe"

/obj/effect/decal/wallpaper/paper/stripe/low
	icon_state = "wallpaper-stripe_low"

/obj/effect/decal/wallpaper/paper/rich
	icon_state = "wallpaper-rich"

/obj/effect/decal/wallpaper/paper/rich/low
	icon_state = "wallpaper-rich_low"

/obj/effect/decal/wallpaper/paper/darkred
	icon_state = "wallpaper-dred"

/obj/effect/decal/wallpaper/paper/darkred/low
	icon_state = "wallpaper-dred_low"

/obj/effect/decal/wallpaper/paper/darkgreen
	icon_state = "wallpaper-dgreen"

/obj/effect/decal/wallpaper/paper/darkgreen/low
	icon_state = "wallpaper-dgreen_low"

/obj/effect/decal/wallpaper/stone
	name = "wall decoration"
	icon_state = "wallpaper-stone"

/obj/effect/decal/wallpaper/stone/low
	icon_state = "wallpaper-stone_low"

/obj/effect/decal/wallpaper/gold
	icon_state = "wallpaper-gold"

/obj/effect/decal/wallpaper/gold/alt
	icon_state = "wallpaper-gold_alt"

/obj/effect/decal/wallpaper/gold/low
	icon_state = "wallpaper-gold_low"

/turf/open/floor/plating/vampwood
	gender = PLURAL
	name = "wood"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "bwood"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampwood/Initialize()
	..()
	set_light(1, 0.5, "#a4b7ff")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				initial_gas_mix = WINTER_DEFAULT_ATMOS
				icon_state = "snow[rand(1, 14)]"
				footstep = FOOTSTEP_SNOW
				barefootstep = FOOTSTEP_SNOW
				heavyfootstep = FOOTSTEP_SNOW

/turf/open/floor/plating/vampbeach
	gender = PLURAL
	name = "sand"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "sand1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampbeach/Initialize()
	..()
	icon_state = "sand[rand(1, 4)]"
	set_light(1, 0.5, "#a4b7ff")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "snow[rand(1, 14)]"

/turf/open/floor/plating/vampocean
	gender = PLURAL
	name = "water"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "ocean"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	density = TRUE

/turf/open/floor/plating/vampocean/Initialize()
	..()
	set_light(1, 0.5, "#a4b7ff")

/turf/open/floor/plating/vampacid
	gender = PLURAL
	name = "goop"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "acid"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	density = FALSE

/turf/open/floor/plating/vampacid/Initialize()
	..()
	set_light(1, 0.5, "#1b7c4c")


/turf/open/floor/plating/vampacid/Entered(atom/movable/AM)
	if(acid_burn(AM))
		START_PROCESSING(SSobj, src)

/turf/open/floor/plating/vampacid/proc/acid_burn(mob/living/L)
	if(isliving(L))
		if(L.movement_type & FLYING)
			return
		L.apply_damage(10, CLONE)
		L.apply_damage(30, TOX)
		to_chat(L, "<span class='warning'>Your flesh burns!</span>")



/obj/effect/decal/coastline
	name = "water"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "coastline"

/obj/effect/decal/coastline/corner
	icon_state = "coastline_corner"

/obj/effect/decal/shadow
	name = "shadow"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "shadow"

/obj/effect/decal/shadow/Initialize()
	. = ..()
	if(istype(loc, /turf/open/openspace))
		forceMove(get_step(src, NORTH))
		pixel_y = -32

/obj/effect/decal/support
	name = "support"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "support"

/turf/open/floor/plating/shit
	gender = PLURAL
	name = "sewage"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "shit"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER

/*
/turf/open/floor/plating/shit/Initialize()
	. = ..()
	if(prob(50))
		new /obj/effect/realistic_fog(src)
*/

/turf/open/floor/plating/shit/border
	icon_state = "shit_border"

/turf/open/floor/plating/vampcanal
	gender = PLURAL
	name = "plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "canal1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampcanal/Enter(atom/movable/mover, atom/oldloc)
	. = ..()
	if(istype(mover, /mob/living/carbon/human))
		if(prob(10))
			new /mob/living/simple_animal/pet/rat(oldloc)

/turf/open/floor/plating/vampcanal/Initialize()
	..()
	icon_state = "canal[rand(1, 3)]"

/turf/open/floor/plating/vampcanalplating
	gender = PLURAL
	name = "plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "canal_plating1"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_PARKET
	barefootstep = FOOTSTEP_PARKET
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/vampcanalplating/Enter(atom/movable/mover, atom/oldloc)
	. = ..()
	if(istype(mover, /mob/living/carbon/human))
		if(prob(10))
			new /mob/living/simple_animal/pet/rat(oldloc)

/turf/open/floor/plating/vampcanal/Initialize()
	..()
	icon_state = "canal_plating[rand(1, 4)]"

/turf/closed/indestructible/elevatorshaft
	name = "elevator shaft"
	desc = "Floors, floors, floors..."
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "black"

/turf/open/floor/plating/bacotell
	gender = PLURAL
	name = "plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "bacotell"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/gummaguts
	gender = PLURAL
	name = "plating"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "gummaguts"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_TROTUAR
	barefootstep = FOOTSTEP_TROTUAR
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
