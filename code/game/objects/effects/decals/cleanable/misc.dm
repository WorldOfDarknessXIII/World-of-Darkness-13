/obj/effect/decal/cleanable/generic
	name = "clutter"
	desc = "Someone should clean that up."
	icon = 'icons/obj/debris.dmi'
	icon_state = "shards"
	beauty = -50

/obj/effect/decal/cleanable/ash
	name = "ashes"
	desc = "Ashes to ashes, dust to dust, and into space."
	icon = 'icons/obj/debris.dmi'
	icon_state = "ash"
	mergeable_decal = FALSE
	beauty = -50
	decal_reagent = /datum/reagent/ash
	reagent_amount = 30

<<<<<<< HEAD
/obj/effect/decal/cleanable/fire_ash
	name = "ashes"
	desc = "Ashes to ashes, dust to dust, and into space."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dirt"
	mergeable_decal = FALSE
	beauty = -75
	color = "#000000"

/obj/effect/decal/cleanable/ash/Initialize()
=======
/obj/effect/decal/cleanable/ash/Initialize(mapload)
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441
	. = ..()
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

/obj/effect/decal/cleanable/ash/NeverShouldHaveComeHere(turf/here_turf)
	return !istype(here_turf, /obj/structure/bodycontainer/crematorium) && ..()

/obj/effect/decal/cleanable/ash/large
	name = "large pile of ashes"
	icon_state = "big_ash"
	beauty = -100
	decal_reagent = /datum/reagent/ash
	reagent_amount = 60

/obj/effect/decal/cleanable/glass
	name = "tiny shards"
	desc = "Back to sand."
	icon = 'icons/obj/debris.dmi'
	icon_state = "tiny"
	beauty = -100

/obj/effect/decal/cleanable/glass/Initialize(mapload)
	. = ..()
	setDir(pick(GLOB.cardinals))

/obj/effect/decal/cleanable/glass/ex_act()
	qdel(src)
	return TRUE

/obj/effect/decal/cleanable/glass/plasma
	icon_state = "plasmatiny"

/obj/effect/decal/cleanable/glass/titanium
	icon_state = "titaniumtiny"

/obj/effect/decal/cleanable/glass/plastitanium
	icon_state = "plastitaniumtiny"

//Screws that are dropped on the Z level below when deconstructing a reinforced floor plate.
/obj/effect/decal/cleanable/glass/plastitanium/screws //I don't know how to sprite scattered screws, this can work until a spriter gets their hands on it.
	name = "pile of screws"
	desc = "Looks like they fell from the ceiling"

/obj/effect/decal/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	icon = 'icons/effects/dirt.dmi'
	icon_state = "dirt-flat-0"
	base_icon_state = "dirt"
	smoothing_flags = NONE
	smoothing_groups = SMOOTH_GROUP_CLEANABLE_DIRT
	canSmoothWith = SMOOTH_GROUP_CLEANABLE_DIRT + SMOOTH_GROUP_WALLS
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	beauty = -75

/obj/effect/decal/cleanable/dirt/Initialize(mapload)
	. = ..()
	icon_state = pick("dirt-flat-0","dirt-flat-1","dirt-flat-2","dirt-flat-3")
	var/obj/structure/broken_flooring/broken_flooring = locate(/obj/structure/broken_flooring) in loc
	if(!isnull(broken_flooring))
		return
	var/turf/T = get_turf(src)
	if(T.tiled_dirt)
		smoothing_flags = SMOOTH_BITMASK
		QUEUE_SMOOTH(src)
	if(smoothing_flags & USES_SMOOTHING)
		QUEUE_SMOOTH_NEIGHBORS(src)

/obj/effect/decal/cleanable/dirt/Destroy()
	if(smoothing_flags & USES_SMOOTHING)
		QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/effect/decal/cleanable/gasoline
	name = "gasoline"
	desc = "I HOPE YOU DIE IN A FIRE!!!"
	icon = 'icons/effects/dirt.dmi'
	icon_state = "water"
	base_icon_state = "water"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLEANABLE_DIRT)
	canSmoothWith = list(SMOOTH_GROUP_CLEANABLE_DIRT, SMOOTH_GROUP_WALLS)
//	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	beauty = -50
	alpha = 64
	color = "#c6845b"

/obj/effect/decal/cleanable/gasoline/update_icon()
	QUEUE_SMOOTH(src)
	QUEUE_SMOOTH_NEIGHBORS(src)

/obj/effect/decal/cleanable/gasoline/Crossed(atom/movable/AM, oldloc)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.on_fire)
			var/obj/effect/fire/F = locate() in get_turf(src)
			if(!F)
				new /obj/effect/fire(get_turf(src))
	..(AM)

/obj/effect/decal/cleanable/gasoline/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	if(istype(T, /turf/open/floor))
		var/turf/open/floor/F = T
		F.spread_chance = 100
		F.burn_material += 100
//	smoothing_flags = SMOOTH_BITMASK
	QUEUE_SMOOTH(src)
	QUEUE_SMOOTH_NEIGHBORS(src)

/obj/effect/decal/cleanable/gasoline/Destroy()
	QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/effect/decal/cleanable/gasoline/fire_act(exposed_temperature, exposed_volume)
	var/obj/effect/fire/F = locate() in loc
	if(!F)
		new /obj/effect/fire(loc)
	..()

/obj/effect/decal/cleanable/gasoline/attackby(obj/item/I, mob/living/user)
	var/attacked_by_hot_thing = I.get_temperature()
	if(attacked_by_hot_thing)
		call_dharma("grief", user)
		visible_message("<span class='warning'>[user] tries to ignite [src] with [I]!</span>", "<span class='warning'>You try to ignite [src] with [I].</span>")
		log_combat(user, src, (attacked_by_hot_thing < 480) ? "tried to ignite" : "ignited", I)
		fire_act(attacked_by_hot_thing)
		return
	return ..()

/obj/effect/decal/cleanable/dirt/dust
	name = "dust"
	desc = "A thin layer of dust coating the floor."
	icon_state = "dust"
	base_icon_state = "dust"

/obj/effect/decal/cleanable/dirt/dust/Initialize(mapload)
	. = ..()
	icon_state = base_icon_state

/obj/effect/decal/cleanable/greenglow
	name = "glowing goo"
	desc = "Jeez. I hope that's not for lunch."
	icon_state = "greenglow"
	light_power = 3
	light_range = 2
	light_color = LIGHT_COLOR_GREEN
	beauty = -300

/obj/effect/decal/cleanable/greenglow/ex_act()
	return FALSE

/obj/effect/decal/cleanable/greenglow/filled
	decal_reagent = /datum/reagent/uranium
	reagent_amount = 5

/obj/effect/decal/cleanable/greenglow/filled/Initialize(mapload)
	decal_reagent = pick(/datum/reagent/uranium, /datum/reagent/uranium/radium)
	. = ..()

/obj/effect/decal/cleanable/greenglow/ecto
	name = "ectoplasmic puddle"
	desc = "You know who to call."
	light_power = 2

/obj/effect/decal/cleanable/greenglow/radioactive
	name = "radioactive goo"
	desc = "Holy crap, stop looking at this and move away immediately! It's radioactive!"
	light_power = 5
	light_range = 3
	light_color = LIGHT_COLOR_NUCLEAR

/obj/effect/decal/cleanable/greenglow/radioactive/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	AddComponent(
		/datum/component/radioactive_emitter, \
		cooldown_time = 5 SECONDS, \
		range = 4, \
		threshold = RAD_MEDIUM_INSULATION, \
	)

/obj/effect/decal/cleanable/cobweb
	name = "cobweb"
	desc = "Somebody should remove that."
	gender = NEUTER
	layer = WALL_OBJ_LAYER
	icon = 'icons/effects/web.dmi'
	icon_state = "cobweb1"
	resistance_flags = FLAMMABLE
	beauty = -100
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/cobweb/cobweb2
	icon_state = "cobweb2"

/obj/effect/decal/cleanable/molten_object
	name = "gooey grey mass"
	desc = "It looks like a melted... something."
	gender = NEUTER
	icon = 'icons/effects/effects.dmi'
	icon_state = "molten"
	mergeable_decal = FALSE
	beauty = -150
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/molten_object/large
	name = "big gooey grey mass"
	icon_state = "big_molten"
	beauty = -300

//Vomit (sorry)
/obj/effect/decal/cleanable/vomit
	name = "vomit"
	desc = "Gosh, how unpleasant."
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	random_icon_states = list("vomit_1", "vomit_2", "vomit_3", "vomit_4")
	beauty = -150

/obj/effect/decal/cleanable/vomit/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(isflyperson(H))
			playsound(get_turf(src), 'sound/items/drink.ogg', 50, TRUE) //slurp
			H.visible_message(span_alert("[H] extends a small proboscis into the vomit pool, sucking it with a slurping sound."))
			reagents.trans_to(H, reagents.total_volume, transferred_by = user, methods = INGEST)
			qdel(src)

/obj/effect/decal/cleanable/vomit/toxic // this has a more toned-down color palette, which may be why it's used as the default in so many spots
	icon_state = "vomittox_1"
	random_icon_states = list("vomittox_1", "vomittox_2", "vomittox_3", "vomittox_4")

/obj/effect/decal/cleanable/vomit/purple // ourple
	icon_state = "vomitpurp_1"
	random_icon_states = list("vomitpurp_1", "vomitpurp_2", "vomitpurp_3", "vomitpurp_4")

/obj/effect/decal/cleanable/vomit/nanites
	name = "nanite-infested vomit"
	desc = "Gosh, you can see something moving in there."
	icon_state = "vomitnanite_1"
	random_icon_states = list("vomitnanite_1", "vomitnanite_2", "vomitnanite_3", "vomitnanite_4")

/obj/effect/decal/cleanable/vomit/nebula
	name = "nebula vomit"
	desc = "Gosh, how... beautiful."
	icon_state = "vomitnebula_1"
	random_icon_states = list("vomitnebula_1", "vomitnebula_2", "vomitnebula_3", "vomitnebula_4")
	beauty = 10

/obj/effect/decal/cleanable/vomit/nebula/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/effect/decal/cleanable/vomit/nebula/update_overlays()
	. = ..()
	. += emissive_appearance(icon, icon_state, src, alpha = src.alpha)

/// Nebula vomit with extra guests
/obj/effect/decal/cleanable/vomit/nebula/worms

/obj/effect/decal/cleanable/vomit/nebula/worms/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	for (var/i in 1 to rand(2, 3))
		new /mob/living/basic/hivelord_brood(loc)

/obj/effect/decal/cleanable/vomit/old
	name = "crusty dried vomit"
	desc = "You try not to look at the chunks, and fail."

/obj/effect/decal/cleanable/vomit/old/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	icon_state += "-old"
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_SLUDGE, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 10)

/obj/effect/decal/cleanable/vomit/old/black_bile
	name = "black bile"
	desc = "There's something wiggling in there..."
	color = COLOR_DARK

/obj/effect/decal/cleanable/chem_pile
	name = "chemical pile"
	desc = "A pile of chemicals. You can't quite tell what's inside it."
	gender = NEUTER
	icon = 'icons/obj/debris.dmi'
	icon_state = "ash"

/obj/effect/decal/cleanable/shreds
	name = "shreds"
	desc = "The shredded remains of what appears to be clothing."
	icon_state = "shreds"
	gender = PLURAL
	mergeable_decal = FALSE

/obj/effect/decal/cleanable/shreds/ex_act(severity, target)
	if(severity >= EXPLODE_DEVASTATE) //so shreds created during an explosion aren't deleted by the explosion.
		qdel(src)
		return TRUE

	return FALSE

/obj/effect/decal/cleanable/shreds/Initialize(mapload, oldname)
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	if(!isnull(oldname))
		desc = "The sad remains of what used to be [oldname]"
	. = ..()

/obj/effect/decal/cleanable/glitter
	name = "generic glitter pile"
	desc = "The herpes of arts and crafts."
	icon = 'icons/effects/atmospherics.dmi'
	icon_state = "plasma_old"
	gender = NEUTER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/cleanable/glitter/pink
	name = "pink glitter"
	icon_state = "plasma"

/obj/effect/decal/cleanable/glitter/white
	name = "white glitter"
	icon_state = "nitrous_oxide"

/obj/effect/decal/cleanable/glitter/blue
	name = "blue glitter"
	icon_state = "freon"

/obj/effect/decal/cleanable/plasma
	name = "stabilized plasma"
	desc = "A puddle of stabilized plasma."
	icon_state = "flour"
	icon = 'icons/effects/tomatodecal.dmi'
	color = "#2D2D2D"

/obj/effect/decal/cleanable/insectguts
	name = "insect guts"
	desc = "One bug squashed. Four more will rise in its place."
	icon = 'icons/effects/blood.dmi'
	icon_state = "xfloor1"
	random_icon_states = list("xfloor1", "xfloor2", "xfloor3", "xfloor4", "xfloor5", "xfloor6", "xfloor7")

/obj/effect/decal/cleanable/confetti
	name = "confetti"
	desc = "Tiny bits of colored paper thrown about for the janitor to enjoy!"
	icon = 'icons/effects/confetti_and_decor.dmi'
	icon_state = "confetti"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT //the confetti itself might be annoying enough

/obj/effect/decal/cleanable/plastic
	name = "plastic shreds"
	desc = "Bits of torn, broken, worthless plastic."
	icon = 'icons/obj/debris.dmi'
	icon_state = "shards"
	color = "#c6f4ff"

/obj/effect/decal/cleanable/wrapping
	name = "wrapping shreds"
	desc = "Torn pieces of cardboard and paper, left over from a package."
	icon = 'icons/obj/debris.dmi'
	icon_state = "paper_shreds"

/obj/effect/decal/cleanable/wrapping/pinata
	name = "pinata shreds"
	desc = "Torn pieces of papier-mâché, left over from a pinata"
	icon_state = "pinata_shreds"

/obj/effect/decal/cleanable/wrapping/pinata/syndie
	icon_state = "syndie_pinata_shreds"

/obj/effect/decal/cleanable/wrapping/pinata/donk
	icon_state = "donk_pinata_shreds"

/obj/effect/decal/cleanable/garbage
	name = "decomposing garbage"
	desc = "A split open garbage bag, its stinking content seems to be partially liquified. Yuck!"
	icon = 'icons/obj/debris.dmi'
	icon_state = "garbage"
	plane = GAME_PLANE
	layer = FLOOR_CLEAN_LAYER //To display the decal over wires.
	beauty = -150
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/garbage/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_SLUDGE, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 15)

/obj/effect/decal/cleanable/feet_trail
	name = "trails"
	desc = "Can lead somewhere... Or not."
	icon = 'icons/effects/dirt.dmi'
	icon_state = "feet_trail"

/obj/effect/decal/cleanable/feet_trail/Initialize()
	. = ..()
	pixel_x = rand(-4, 4)
	pixel_y = rand(-4, 4)

/obj/effect/decal/cleanable/drag_trail
	name = "trails"
	desc = "Can lead somewhere... Or not."
	icon = 'icons/effects/dirt.dmi'
	icon_state = "drag_trail"

/obj/effect/decal/cleanable/car_trail
	name = "trails"
	desc = "Can lead somewhere... Or not."
	icon = 'icons/effects/dirt.dmi'
	icon_state = "car_trail"
