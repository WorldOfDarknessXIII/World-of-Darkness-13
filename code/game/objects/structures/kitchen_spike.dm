#define MEATSPIKE_IRONROD_REQUIREMENT 4

/obj/structure/kitchenspike_frame
	name = "meatspike frame"
	icon = 'icons/obj/service/kitchen.dmi'
	icon_state = "spikeframe"
	desc = "The frame of a meat spike."
	density = TRUE
	anchored = FALSE
	max_integrity = 200

/obj/structure/kitchenspike_frame/Initialize(mapload)
	. = ..()
	register_context()

/obj/structure/kitchenspike_frame/examine(mob/user)
	. = ..()
	. += "It can be <b>welded</b> apart."
	. += "You could attach <b>[MEATSPIKE_IRONROD_REQUIREMENT]</b> iron rods to it to create a <b>Meat Spike</b>."

/obj/structure/kitchenspike_frame/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(isnull(held_item))
		return NONE

	var/message = ""
	if(held_item.tool_behaviour == TOOL_WELDER)
		message = "Deconstruct"
	else if(held_item.tool_behaviour == TOOL_WRENCH)
		message = "Bolt Down Frame"

	if(!message)
		return NONE
	context[SCREENTIP_CONTEXT_LMB] = message
	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/kitchenspike_frame/welder_act(mob/living/user, obj/item/tool)
	if(!tool.tool_start_check(user, amount = 0))
		return FALSE
	to_chat(user, span_notice("You begin cutting \the [src] apart..."))
	if(!tool.use_tool(src, user, 5 SECONDS, volume = 50))
		return TRUE
	visible_message(span_notice("[user] slices apart \the [src]."),
		span_notice("You cut \the [src] apart with \the [tool]."),
		span_hear("You hear welding."))
	new /obj/item/stack/sheet/iron(loc, MEATSPIKE_IRONROD_REQUIREMENT)
	qdel(src)
	return TRUE

/obj/structure/kitchenspike_frame/wrench_act(mob/living/user, obj/item/tool)
	default_unfasten_wrench(user, tool)
	return TRUE

/obj/structure/kitchenspike_frame/attackby(obj/item/attacking_item, mob/user, params)
	add_fingerprint(user)
	if(!istype(attacking_item, /obj/item/stack/rods))
		return ..()
	var/obj/item/stack/rods/used_rods = attacking_item
	if(used_rods.get_amount() >= MEATSPIKE_IRONROD_REQUIREMENT)
		used_rods.use(MEATSPIKE_IRONROD_REQUIREMENT)
		balloon_alert(user, "meatspike built")
		var/obj/structure/new_meatspike = new /obj/structure/kitchenspike(loc)
		transfer_fingerprints_to(new_meatspike)
		qdel(src)
		return
	balloon_alert(user, "[MEATSPIKE_IRONROD_REQUIREMENT] rods needed!")

/obj/structure/kitchenspike
	name = "meat spike"
	icon = 'icons/obj/service/kitchen.dmi'
	icon_state = "spike"
	desc = "A spike for collecting meat from animals."
	density = TRUE
	anchored = TRUE
	buckle_lying = FALSE
	can_buckle = TRUE
	max_integrity = 250

/obj/structure/kitchenspike/Initialize(mapload)
	. = ..()
	register_context()

/obj/structure/kitchenspike/examine(mob/user)
	. = ..()
	. += "<b>Drag a mob</b> onto it to hook it in place."
	. += "A <b>crowbar</b> could remove those spikes."

/obj/structure/kitchenspike/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(isnull(held_item))
		return NONE

	if(held_item.tool_behaviour == TOOL_CROWBAR)
		context[SCREENTIP_CONTEXT_LMB] = "Remove Spikes"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/structure/kitchenspike/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/kitchenspike/crowbar_act(mob/living/user, obj/item/tool)
	if(has_buckled_mobs())
		to_chat(user, span_warning("You can't do that while something's on the spike!"))
		return TRUE

	if(tool.use_tool(src, user, 2 SECONDS, volume = 100))
		to_chat(user, span_notice("You pry the spikes out of the frame."))
		deconstruct(TRUE)
		return TRUE
	return FALSE

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/structure/kitchenspike/attack_hand(mob/user)
	if(VIABLE_MOB_CHECK(user.pulling) && user.a_intent == INTENT_GRAB && !has_buckled_mobs())
		var/mob/living/L = user.pulling
		if(do_mob(user, src, 120))
			if(has_buckled_mobs()) //to prevent spam/queing up attacks
				return
			if(L.buckled)
				return
			if(user.pulling != L)
				return
			playsound(src.loc, 'sound/effects/splat.ogg', 25, TRUE)
			L.visible_message("<span class='danger'>[user] slams [L] onto the meat spike!</span>", "<span class='userdanger'>[user] slams you onto the meat spike!</span>", "<span class='hear'>You hear a squishy wet noise.</span>")
			L.forceMove(drop_location())
			L.emote("scream")
			L.add_splatter_floor()
			L.adjustBruteLoss(30)
			L.setDir(2)
			buckle_mob(L, force=1)
			var/matrix/m180 = matrix(L.transform)
			m180.Turn(180)
			animate(L, transform = m180, time = 3)
			L.pixel_y = L.base_pixel_y + PIXEL_Y_OFFSET_LYING
			if(ishuman(L))
				call_dharma("torture", user)
	else if (has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			user_unbuckle_mob(L, user)
	else
		..()



/obj/structure/kitchenspike/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE) //Don't want them getting put on the rack other than by spiking
	return

/obj/structure/kitchenspike/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if(M != user)
			M.visible_message("<span class='notice'>[user] tries to pull [M] free of [src]!</span>",\
				"<span class='notice'>[user] is trying to pull you off [src], opening up fresh wounds!</span>",\
				"<span class='hear'>You hear a squishy wet noise.</span>")
			if(!do_after(user, 300, target = src))
				if(M?.buckled)
					M.visible_message("<span class='notice'>[user] fails to free [M]!</span>",\
					"<span class='notice'>[user] fails to pull you off of [src].</span>")
				return

		else
			M.visible_message("<span class='warning'>[M] struggles to break free from [src]!</span>",\
			"<span class='notice'>You struggle to break free from [src], exacerbating your wounds! (Stay still for two minutes.)</span>",\
			"<span class='hear'>You hear a wet squishing noise..</span>")
			M.adjustBruteLoss(30)
			if(!do_after(M, 1200, target = src))
				if(M?.buckled)
					to_chat(M, "<span class='warning'>You fail to free yourself!</span>")
				return
		if(!M.buckled)
			return
		release_mob(M)

/obj/structure/kitchenspike/proc/release_mob(mob/living/M)
	var/matrix/m180 = matrix(M.transform)
	m180.Turn(180)
	animate(M, transform = m180, time = 3)
	M.pixel_y = M.base_pixel_y + PIXEL_Y_OFFSET_LYING
	M.adjustBruteLoss(30)
	src.visible_message(text("<span class='danger'>[M] falls free of [src]!</span>"))
	unbuckle_mob(M,force=1)
	M.emote("scream")
	M.AdjustParalyzed(20)

/obj/structure/kitchenspike/Destroy()
	if(has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			release_mob(L)
	return ..()

/obj/structure/kitchenspike/post_buckle_mob(mob/living/target)
	playsound(src.loc, 'sound/effects/splat.ogg', 25, TRUE)
	target.emote("scream")
	target.add_splatter_floor()
	target.adjustBruteLoss(30)
	target.setDir(2)
	var/matrix/m180 = matrix(target.transform)
	m180.Turn(180)
	animate(target, transform = m180, time = 3)
	target.pixel_y = target.base_pixel_y + PIXEL_Y_OFFSET_LYING
	ADD_TRAIT(target, TRAIT_MOVE_UPSIDE_DOWN, REF(src))

/obj/structure/kitchenspike/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(buckled_mob != user)
		buckled_mob.visible_message(span_notice("[user] tries to pull [buckled_mob] free of [src]!"),\
			span_notice("[user] is trying to pull you off [src], opening up fresh wounds!"),\
			span_hear("You hear a squishy wet noise."))
		if(!do_after(user, 30 SECONDS, target = src))
			if(buckled_mob?.buckled)
				buckled_mob.visible_message(span_notice("[user] fails to free [buckled_mob]!"),\
					span_notice("[user] fails to pull you off of [src]."))
			return

	else
		buckled_mob.visible_message(span_warning("[buckled_mob] struggles to break free from [src]!"),\
		span_notice("You struggle to break free from [src], exacerbating your wounds! (Stay still for two minutes.)"),\
		span_hear("You hear a wet squishing noise.."))
		buckled_mob.adjustBruteLoss(30)
		if(!do_after(buckled_mob, 2 MINUTES, target = src, hidden = TRUE))
			if(buckled_mob?.buckled)
				to_chat(buckled_mob, span_warning("You fail to free yourself!"))
			return
	return ..()

/obj/structure/kitchenspike/post_unbuckle_mob(mob/living/buckled_mob)
	buckled_mob.adjustBruteLoss(30)
	INVOKE_ASYNC(buckled_mob, TYPE_PROC_REF(/mob, emote), "scream")
	buckled_mob.AdjustParalyzed(20)
	var/matrix/m180 = matrix(buckled_mob.transform)
	m180.Turn(180)
	animate(buckled_mob, transform = m180, time = 3)
	buckled_mob.pixel_y = buckled_mob.base_pixel_y + PIXEL_Y_OFFSET_LYING
	REMOVE_TRAIT(buckled_mob, TRAIT_MOVE_UPSIDE_DOWN, REF(src))

/obj/structure/kitchenspike/atom_deconstruct(disassembled = TRUE)
	if(disassembled)
		var/obj/structure/meatspike_frame = new /obj/structure/kitchenspike_frame(src.loc)
		transfer_fingerprints_to(meatspike_frame)
	else
		new /obj/item/stack/sheet/iron(src.loc, 4)
	new /obj/item/stack/rods(loc, MEATSPIKE_IRONROD_REQUIREMENT)

#undef MEATSPIKE_IRONROD_REQUIREMENT
