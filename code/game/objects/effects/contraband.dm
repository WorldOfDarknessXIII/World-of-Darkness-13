// This is synced up to the poster placing animation.
#define PLACE_SPEED 37

// The poster item

/obj/item/poster
	name = "poorly coded poster"
	icon = 'icons/obj/contraband.dmi'
	force = 0
	resistance_flags = FLAMMABLE
	var/poster_type
	var/obj/structure/sign/poster/poster_structure

/obj/item/poster/Initialize(mapload, obj/structure/sign/poster/new_poster_structure)
	. = ..()
	poster_structure = new_poster_structure
	if(!new_poster_structure && poster_type)
		poster_structure = new poster_type(src)

	// posters store what name and description they would like their
	// rolled up form to take.
	if(poster_structure)
		name = poster_structure.poster_item_name
		icon_state = poster_structure.poster_item_icon_state

		name = "[name] - [poster_structure.original_name]"

/obj/item/poster/Destroy()
	poster_structure = null
	. = ..()

// These icon_states may be overridden, but are for mapper's convinence
/obj/item/poster/random_contraband
	name = "random contraband poster"
	poster_type = /obj/structure/sign/poster/contraband/random
	icon_state = "rolled_poster"

// The poster sign/structure

/obj/structure/sign/poster
	name = "poster"
	var/original_name
	icon = 'icons/obj/contraband.dmi'
	anchored = TRUE
	buildable_sign = FALSE //Cannot be unwrenched from a wall.
	var/ruined = FALSE
	var/random_basetype
	var/never_random = FALSE // used for the 'random' subclasses.

	var/poster_item_name = "hypothetical poster"
	var/poster_item_icon_state = "rolled_poster"
	var/poster_item_type = /obj/item/poster

/obj/structure/sign/poster/Initialize()
	. = ..()
	if(random_basetype)
		randomise(random_basetype)
	if(!ruined)
		original_name = name // can't use initial because of random posters
		name = "poster - [name]"

	AddComponent(/datum/component/beauty, 300)

/obj/structure/sign/poster/proc/randomise(base_type)
	var/list/poster_types = subtypesof(base_type)
	var/list/approved_types = list()
	for(var/t in poster_types)
		var/obj/structure/sign/poster/T = t
		if(initial(T.icon_state) && !initial(T.never_random))
			approved_types |= T

	var/obj/structure/sign/poster/selected = pick(approved_types)

	name = initial(selected.name)
	icon_state = initial(selected.icon_state)
	poster_item_name = initial(selected.poster_item_name)
	poster_item_icon_state = initial(selected.poster_item_icon_state)
	ruined = initial(selected.ruined)


/obj/structure/sign/poster/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER)
		I.play_tool_sound(src, 100)
		if(ruined)
			to_chat(user, "<span class='notice'>You remove the remnants of the poster.</span>")
			qdel(src)
		else
			to_chat(user, "<span class='notice'>You carefully remove the poster from the wall.</span>")
			roll_and_drop(user.loc)

/obj/structure/sign/poster/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(ruined)
		return
	visible_message("<span class='notice'>[user] rips [src] in a single, decisive motion!</span>" )
	playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, TRUE)

	var/obj/structure/sign/poster/ripped/R = new(loc)
	R.pixel_y = pixel_y
	R.pixel_x = pixel_x
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/sign/poster/proc/roll_and_drop(loc)
	pixel_x = 0
	pixel_y = 0
	var/obj/item/poster/P = new poster_item_type(loc, src)
	forceMove(P)
	return P

//separated to reduce code duplication. Moved here for ease of reference and to unclutter r_wall/attackby()
/turf/closed/wall/proc/place_poster(obj/item/poster/P, mob/user)
	if(!P.poster_structure)
		to_chat(user, "<span class='warning'>[P] has no poster... inside it? Inform a coder!</span>")
		return

	// Deny placing posters on currently-diagonal walls, although the wall may change in the future.
	if (smoothing_flags & SMOOTH_DIAGONAL_CORNERS)
		for (var/O in overlays)
			var/image/I = O
			if(copytext(I.icon_state, 1, 3) == "d-") //3 == length("d-") + 1
				return

	var/stuff_on_wall = 0
	for(var/obj/O in contents) //Let's see if it already has a poster on it or too much stuff
		if(istype(O, /obj/structure/sign/poster))
			to_chat(user, "<span class='warning'>The wall is far too cluttered to place a poster!</span>")
			return
		stuff_on_wall++
		if(stuff_on_wall == 3)
			to_chat(user, "<span class='warning'>The wall is far too cluttered to place a poster!</span>")
			return

	to_chat(user, "<span class='notice'>You start placing the poster on the wall...</span>"	)

	var/obj/structure/sign/poster/D = P.poster_structure

	var/temp_loc = get_turf(user)
	flick("poster_being_set",D)
	D.forceMove(src)
	qdel(P)	//delete it now to cut down on sanity checks afterwards. Agouri's code supports rerolling it anyway
	playsound(D.loc, 'sound/items/poster_being_created.ogg', 100, TRUE)

	if(do_after(user, PLACE_SPEED, target=src))
		if(!D || QDELETED(D))
			return

		if(iswallturf(src) && user && user.loc == temp_loc)	//Let's check if everything is still there
			to_chat(user, "<span class='notice'>You place the poster!</span>")
			return

	to_chat(user, "<span class='notice'>The poster falls down!</span>")
	D.roll_and_drop(get_turf(user))

// Various possible posters follow

/obj/structure/sign/poster/ripped
	ruined = TRUE
	icon_state = "poster_ripped"
	name = "ripped poster"

/obj/structure/sign/poster/random
	name = "random poster" // could even be ripped
	icon_state = "random_anything"
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster

/obj/structure/sign/poster/contraband
	poster_item_name = "contraband poster"
	poster_item_icon_state = "rolled_poster"

/obj/structure/sign/poster/contraband/random
	name = "random contraband poster"
	icon_state = "random_contraband"
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster/contraband

/obj/structure/sign/poster/lacunacoil
	name = "Lacuna Coil"
	icon_state = "poster_1"

/obj/structure/sign/poster/vesuvius
	name = "Vesuvius"
	icon_state = "poster_2"

/obj/structure/sign/poster/redlady
	name = "Red Lady"
	icon_state = "poster_3"

/obj/structure/sign/poster/car
	name = "Buy a Car"
	icon_state = "poster_4"

/obj/structure/sign/poster/ministry
	name = "Ministry"
	icon_state = "poster_5"

/obj/structure/sign/poster/contraband/blade
	name = "Blade"
	icon_state = "poster_6"

/obj/structure/sign/poster/contraband/bloodrayne
	name = "Bloodrayne"
	icon_state = "poster_7"

/obj/structure/sign/poster/gravitykills
	name = "Gravity Kills"
	icon_state = "poster_8"

/obj/structure/sign/poster/genitorturers
	name = "Genitorturers"
	icon_state = "poster_9"

/obj/structure/sign/poster/chiasm
	name = "Chiasm"
	icon_state = "poster_10"

/obj/structure/sign/posterdarlingvioletta
	name = "Darling Violetta"
	icon_state = "poster_11"

/obj/structure/sign/poster/tiamat
	name = "Tiamat"
	icon_state = "poster_12"

/obj/structure/sign/poster/contraband/pixies
	name = "Pixies"
	icon_state = "poster_13"

/obj/structure/sign/poster/diemydarling
	name = "Die My Darling!"
	icon_state = "poster_14"

/obj/structure/sign/poster/contraband/dmc
	name = "Devil May Cry"
	icon_state = "poster_15"

/obj/structure/sign/poster/contraband/kish
	name = "King and Jester"
	icon_state = "poster_16"

#undef PLACE_SPEED
