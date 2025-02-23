/turf
	var/umbra = FALSE

/turf/open/floor/plating/umbra
	gender = PLURAL
	name = "nothing"
	icon = 'icons/wod13/tiles.dmi'
	icon_state = "black"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_SNOW
	barefootstep = FOOTSTEP_SNOW
	heavyfootstep = FOOTSTEP_SNOW
	plane = PLANE_SPACE
	layer = SPACE_LAYER
	light_power = 0.25
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	umbra = TRUE
	density = TRUE
	planetary_atmos = TRUE

/turf/open/floor/plating/umbra/Initialize()
	. = ..()
	var/obj/minespot/M = locate() in src
	if(M)
		density = FALSE

/obj/minespot
	name = "safe umbral tether"
	desc = "Connects the parts of Penumbra together."
	icon = 'icons/wod13/umbra.dmi'
	icon_state = "tile1"
	plane = GAME_PLANE
	layer = BELOW_OBJ_LAYER
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	anchored = TRUE
	density = TRUE
	var/marked = FALSE
	var/bomb = FALSE
	var/uncovered = FALSE

/obj/minespot/Initialize()
	. = ..()
	color = "#8e8e8e"
	icon_state = "tile[rand(1, 16)]"

/obj/minespot/playable
	name = "umbral tether"

/obj/minespot/playable/Initialize()
	. = ..()
	if(prob(30))
		bomb = TRUE

/obj/minespot/proc/uncover()
	if(bomb)
		animate(src, color = "#FFFFFF", time = 10)
		icon_state = "boom"
		uncovered = TRUE
		density = FALSE
		return
	var/amount_of_bombs = 0
	for(var/obj/minespot/M in range(1, src))
		if(M.bomb)
			amount_of_bombs += 1
	uncovered = TRUE
	density = FALSE
	switch(amount_of_bombs)
		if(0)
			animate(src, color = "#FFFFFF", time = 10)
		if(1)
			animate(src, color = "#00edff", time = 10)
		if(2)
			animate(src, color = "#40ff00", time = 10)
		if(3)
			animate(src, color = "#ffbf00", time = 10)
		if(4)
			animate(src, color = "#ff0000", time = 10)
		if(5)
			animate(src, color = "#ff0089", time = 10)
		if(6)
			animate(src, color = "#c800ff", time = 10)
		if(7)
			animate(src, color = "#4000ff", time = 10)
		if(8)
			animate(src, color = "#4000ff", time = 10)
//	icon_state = "[amount_of_bombs]"
//	if(amount_of_bombs == 0)
//		for(var/obj/minespot/M in range(1, src))
//			M.uncover()

/obj/minespot/attack_hand(mob/user)
	. = ..()
	if(uncovered)
		return
	uncovered = TRUE
	density = FALSE
	if(bomb)
		animate(src, color = "#FFFFFF", time = 10)
		icon_state = "boom"
	else
		var/amount_of_bombs = 0
		for(var/obj/minespot/M in range(1, src))
			if(M.bomb)
				amount_of_bombs = min(8, amount_of_bombs+1)
			if(M.marked)
				amount_of_bombs = max(0, amount_of_bombs-1)
		switch(amount_of_bombs)
			if(0)
				animate(src, color = "#FFFFFF", time = 10)
			if(1)
				animate(src, color = "#00edff", time = 10)
			if(2)
				animate(src, color = "#40ff00", time = 10)
			if(3)
				animate(src, color = "#ffbf00", time = 10)
			if(4)
				animate(src, color = "#ff0000", time = 10)
			if(5)
				animate(src, color = "#ff0089", time = 10)
			if(6)
				animate(src, color = "#c800ff", time = 10)
			if(7)
				animate(src, color = "#4000ff", time = 10)
			if(8)
				animate(src, color = "#4000ff", time = 10)
		if(amount_of_bombs == 0)
			for(var/obj/minespot/M in range(1, src))
				M.uncover()

/mob/living/carbon/CtrlClickOn(atom/A)
	. = ..()
	if(istype(A, /obj/minespot))
		var/obj/minespot/M = A
		if(!M.uncovered)
			if(!M.marked)
				M.icon_state = "marked"
				M.marked = TRUE
			else
				M.icon_state = "unknown"
				M.marked = FALSE

/obj/umbra_portal
	name = "gateway"
	desc = "Step to the other side."
	icon = 'icons/wod13/48x48.dmi'
	icon_state = "portal"
	density = TRUE
	anchored = TRUE
	plane = ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	pixel_w = -8
	var/obj/umbra_portal/exit
	var/id

/obj/umbra_portal/proc/later_initialize()
	set_light(2, 1, "#a4a0fb")
	if(id)
		for(var/obj/umbra_portal/U in GLOB.umbra_portals)
			if(U.id)
				if(U.id == id)
					U.exit = src
					exit = U
		GLOB.umbra_portals += src

/obj/umbra_portal/Destroy()
	. = ..()
	if(id)
		for(var/obj/umbra_portal/U in GLOB.umbra_portals)
			if(U.id)
				if(U.id == id)
					U.exit = null
					exit = null
		GLOB.umbra_portals -= src

/obj/umbra_portal/Bumped(atom/movable/AM)
	. = ..()
	if (istype(AM, /mob/living/carbon))
		var/mob/living/carbon/interacting_mob = AM
		if (interacting_mob.client)
			var/turf/T = get_step(exit, get_dir(interacting_mob, src))
			interacting_mob.forceMove(T)
			playsound(loc, 'code/modules/wod13/sounds/portal_enter.ogg', 75, FALSE)
			playsound(T, 'code/modules/wod13/sounds/portal_enter.ogg', 75, FALSE)
