/obj/item/sim_card
	name = "\improper SIM card"
	desc = "A SIM card with a phone number attached to it."
	icon = 'icons/wod13/items/items.dmi'
	icon_state = "book" //WOD13TODO: Replace this with actual SIM card icon later.
	inhand_icon_state = "book"
	lefthand_file = 'icons/wod13/lefthand.dmi'
	righthand_file = 'icons/wod13/righthand.dmi'
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF | ACID_PROOF

	var/phone_number
	var/datum/weakref/phone_weakref = null

/obj/item/sim_card/Initialize(mapload)
	. = ..()
	phone_number = SSphones.generate_phone_number(src)
	register_context()

/obj/item/sim_card/Destroy(force)
	. = ..()
	UnregisterSignal(src)
	SSphones.assigned_phone_numbers.Remove(src)

/obj/item/sim_card/examine(mob/user)
	. = ..()
	. += span_notice("[EXAMINE_HINT("Interact")] to crush it in your hands.")

/obj/item/sim_card/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	context[SCREENTIP_CONTEXT_LMB] = "Crush SIM Card"
	. = CONTEXTUAL_SCREENTIP_SET

	return . || NONE

/obj/item/sim_card/attack_self(mob/user, modifiers)
	. = ..()

	balloon_alert(user, "you start crushing [src]!")
	if(do_after(user, 5 SECONDS, src))
		balloon_alert(user, "you crush [src]!")
		new /obj/effect/decal/cleanable/robot_debris(get_turf(user))
		qdel(src)
		return CLICK_ACTION_SUCCESS
	return CLICK_ACTION_BLOCKING

