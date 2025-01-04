SUBSYSTEM_DEF(die_in_a_fire)
	name = "Die In A Fire"
	init_order = INIT_ORDER_DEFAULT
	wait = 10
	priority = FIRE_PRIORITY_DEFAULT

	var/list/currentrun = list()

/datum/controller/subsystem/die_in_a_fire/fire(resumed = FALSE)
	if (!resumed)
		var/list/activelist = GLOB.fires_list
		src.currentrun = activelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/obj/effect/fire/F = currentrun[currentrun.len]
		--currentrun.len

		if (QDELETED(F)) // Some issue causes nulls to get into this list some times. This keeps it running, but the bug is still there.
			GLOB.fires_list -= F
			log_world("Found a null in fires list!")
			continue

		//!NPC.route_optimisation()
		if(MC_TICK_CHECK)
			return
		F.handle_automated_spread()

/obj/effect/fire
	name = "fire"
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "fire"
	layer = FLY_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/stage = 1
	plane = ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER

/obj/structure
	var/pepeled = FALSE

/obj/structure/proc/pepel()
	if(!pepeled)
		pepeled = TRUE
		color = "#808080"

/obj/effect/fire/proc/handle_automated_spread()
	playsound(get_turf(src), 'code/modules/wod13/sounds/fire.ogg', 80, TRUE)
	var/area/AR = get_area(src)
	if(AR.fire_controled)
		AR.fire_extinguishment()
	for(var/obj/effect/decal/cleanable/gasoline/G in loc)
		if(G)
			qdel(G)
	for(var/mob/living/L in loc)
		if(L)
			L.fire_stacks += 5
			L.IgniteMob()
			L.apply_damage(10*stage, BURN, BODY_ZONE_CHEST)
	for(var/obj/machinery/light/M in loc)
		if(M)
			if(M.status != LIGHT_BROKEN && M.status != LIGHT_EMPTY)
				M.break_light_tube()
	for(var/obj/S in loc)
		if(S)
			var/breakable = TRUE
			if(S.resistance_flags & INDESTRUCTIBLE)
				breakable = FALSE
			if(breakable)
				S.fire_act(1000)
			if(istype(S, /obj/structure/vamptree))
				var/obj/structure/vamptree/T = S
				T.burnshit()
//				if(!isitem(S))
//					S.take_damage(10*stage, BURN, MELEE, 1)
	for(var/obj/effect/decal/cleanable/blood/B in loc)
		if(B)
			B.dry()
	for(var/obj/structure/vampdoor/V in loc)
		if(V)
			if(V.burnable)
				V.color = "#808080"
				if(V.closed)
					V.closed = FALSE
					V.locked = FALSE
					playsound(V, V.open_sound, 75, TRUE)
					V.icon_state = "[V.baseicon]-0"
					V.density = FALSE
					V.opacity = FALSE
					V.layer = OPEN_DOOR_LAYER
	var/total_burn = 0
	if(istype(get_turf(src), /turf/open/floor))
		var/turf/open/floor/A = get_turf(src)
		A.burn_material = max(0, A.burn_material-(1*stage))
		total_burn += A.burn_material
		if(prob(A.spread_chance))
			change_stage(min(3, stage+1))
		if(A.burn_material == 0)
			new /obj/effect/decal/cleanable/fire_ash(A)
			A.spread_chance = initial(A.spread_chance)
	if(total_burn)
		for(var/turf/open/floor/A in range(1, src))
			var/obj/structure/vampdoor/V = locate() in A
			var/allowed_to_spread = FALSE

			if(!V)
				allowed_to_spread = TRUE
			else
				if(!V.opacity)
					allowed_to_spread = TRUE
				if(V.burnable)
					allowed_to_spread = TRUE

			if(allowed_to_spread)
				if(A != loc && A.burn_material)
					var/obj/effect/fire/F = locate() in A
					if(!F && prob(A.spread_chance))
						playsound(get_turf(A), 'code/modules/wod13/sounds/spread.ogg', 80, TRUE)
						var/obj/effect/fire/R = new(A)
						R.color = color
	else
		qdel(src)

/obj/effect/fire/Crossed(atom/movable/AM, oldloc)
	. = ..()
	if(isliving(AM))
		var/mob/living/L = AM
		L.fire_stacks += 5
		L.IgniteMob()

/obj/effect/fire/Destroy()
	. = ..()
	set_light(0)
	GLOB.fires_list -= src

/obj/effect/fire/Initialize()
	. = ..()
	set_light(3, 2, "#ffa800")
	GLOB.fires_list += src

/obj/effect/fire/proc/change_stage(var/stag)
	switch(stag)
		if(0)
			qdel(src)
		if(1)
			stage = 1
			icon = 'code/modules/wod13/icons.dmi'
		if(2)
			stage = 2
			icon = 'code/modules/wod13/32x48.dmi'
		if(3)
			stage = 3
			icon = 'code/modules/wod13/64x64.dmi'

/turf/open/floor/Initialize()
	..()
	if(istype(get_area(src), /area/vtm))
		var/area/vtm/V = get_area(src)
		if(!V.upper)
			spread_chance += 10

/turf/open/floor
	var/spread_chance = 3
	var/burn_material = 3

/turf/open/floor/plating/granite
	spread_chance = 0
	burn_material = 0

/turf/open/floor/plating/parquetry
	spread_chance = 10
	burn_material = 20

/turf/open/floor/plating/vampgrass
	spread_chance = 10
	burn_material = 10

/turf/open/floor/plating/vampcarpet
	spread_chance = 10
	burn_material = 20

/turf/open/floor/carpet
	spread_chance = 20
	burn_material = 20

/turf/open/floor/plating/vampdirt
	spread_chance = 5
	burn_material = 5

/turf/open/floor/plating/church
	spread_chance = 10
	burn_material = 10

/turf/open/floor/plating/saint
	spread_chance = 10
	burn_material = 10

/turf/open/floor/plating/vampwood
	spread_chance = 10
	burn_material = 10

/turf/open/floor/plating/vampbeach
	spread_chance = 1
	burn_material = 1

/turf/open/floor/plating/vampocean
	spread_chance = 0
	burn_material = 0

/turf/open/floor/plating/shit
	spread_chance = 20
	burn_material = 20

/turf/open/floor/plating/vampcanal
	spread_chance = 5
	burn_material = 5

/turf/open/floor/plating/vampcanalplating
	spread_chance = 5
	burn_material = 5
