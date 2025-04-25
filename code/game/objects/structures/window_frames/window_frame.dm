/obj/structure/window_frame
	name = "window frame"
	desc = "A frame. For a window. If a window is missing you can likely replace it with an apropriate kit."
	icon = 'code/modules/wod13/lowwalls.dmi'
	icon_state = "wall-window"
	base_icon_state = "wall"
	var/climbable = 1 //Climbable. As in can by climbed through and past. Done if dragged onto in not-hostile intent.
	var/scaleable = 1 //Scaleable. As in can be scaled to a higher z level. Done if dragged onto in hostile intent.
	var/window = /obj/structure/window/fulltile/
	var/in_use = 0
	var/curtain_dir
	smoothing_flags = SMOOTH_BITMASK
	layer = CLOSED_TURF_LAYER
	resistance_flags = 	INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	density = 1
	anchored = 1

/obj/structure/window_frame/MouseDrop_T(atom/dropping, mob/user, params)
	if(user.a_intent != INTENT_HARM)
		//Adds the component only once. We do it here & not in Initialize() because there are tons of windows & we don't want to add to their init times
		LoadComponent(/datum/component/leanable, dropping)
	else
		if(scaleable)
			if(get_dist(user, src) < 2)
				var/turf/above_turf = locate(user.x, user.y, user.z + 1)
				if(above_turf && istype(above_turf, /turf/open/openspace))
					var/mob/living/carbon/human/carbon_human = user
					carbon_human.climb_wall(above_turf)
				else
					to_chat(user, "<span class='warning'>You can't climb there!</span>")
			return
	. = ..()

/obj/structure/window_frame/ex_act(severity, target)
	return

/obj/structure/window_frame/Initialize()
	. = ..()
	if(window)
		var/obj/W = new window(get_turf(src))
		W.plane = GAME_PLANE
		W.layer = ABOVE_ALL_MOB_LAYER
		if(curtain_dir)
			var/obj/structure/window/fulltile/window_ref = W
			window_ref.curtain = 1
			window_ref.curtain_dir = curtain_dir
			window_ref.create_curtain()
	if(climbable)
		AddElement(/datum/element/climbable)

/obj/structure/window_frame/attackby(obj/item/I, mob/living/user, params)
	if(istype(I,/obj/item/window_repair_kit))
		var/obj/item/window_repair_kit/repair_kit = I
		if(repair_kit.uses_check(1) == 0)
			to_chat(user, span_warning("The kit has no more panels left. You can safely discard it."))
			return
		var/turf/current_turf = get_turf(src)
		for (var/obj/structure/window/window in current_turf)
			if(window)
				to_chat(user,span_warning("There already seems to be a window panel here!"))
				return
		if(in_use == 0)
			visible_message(span_notice("[user] starts to replace a window."),span_notice("You start replacing a window"),span_warning("You hear glass scraping against something!"))
			in_use = 1
			if(do_after(user, 5 SECONDS))
				in_use = 0
				playsound(src, 'sound/items/deconstruct.ogg', 50)
				repair_kit.process_use(1)
				var/obj/W = new window(get_turf(src))
				W.plane = GAME_PLANE
				W.layer = ABOVE_ALL_MOB_LAYER
				return
			in_use = 0
	. = ..()
