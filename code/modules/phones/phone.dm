/obj/item/flip_phone
	name = "flip phone"
	desc = "A portable device to call anyone you want."
	icon = 'icons/wod13/items/items.dmi'
	icon_state = "phone0"
	inhand_icon_state = "phone0"
	lefthand_file = 'icons/wod13/lefthand.dmi'
	righthand_file = 'icons/wod13/righthand.dmi'
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF | ACID_PROOF

	// There's a radio in my phone that calls me stud muffin.
	var/obj/item/radio/phone_radio

	/// Do we have a SIM card?
	var/obj/item/sim_card/sim_card
	/// Phone flags
	var/phone_flags = NONE
	/// The number the user is currently dialing.
	var/dialed_number
	// The frequency the phone is currently using to call another phone.
	var/secure_frequency

/obj/item/flip_phone/Initialize(mapload)
	. = ..()
	sim_card = new()
	phone_radio = new()
	register_context()
	RegisterSignal(src, COMSIG_PHONE_RING, PROC_REF(ring))

/obj/item/flip_phone/Destroy(force)
	. = ..()
	if(sim_card)
		QDEL_NULL(sim_card)
	if(phone_radio)
		QDEL_NULL(phone_radio)

/obj/item/flip_phone/examine(mob/user)
	. = ..()
	. += span_notice("[EXAMINE_HINT("Interact")] to look at the screen.")
	. += span_notice("[EXAMINE_HINT("Alt-Click")] or [EXAMINE_HINT("Right-Click")] to toggle the screen.")
	if(sim_card)
		. += span_notice("[EXAMINE_HINT("Ctrl-Click")] to remove [sim_card].")
	else
		. += span_notice("You can [EXAMINE_HINT("Insert")] a SIM card.")

/obj/item/flip_phone/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	context[SCREENTIP_CONTEXT_RMB] = "Toggle Screen"
	. = CONTEXTUAL_SCREENTIP_SET
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Toggle Screen"
	. = CONTEXTUAL_SCREENTIP_SET

	if(sim_card)
		context[SCREENTIP_CONTEXT_CTRL_LMB] = "Remove [sim_card]"
		. = CONTEXTUAL_SCREENTIP_SET
	else
		context[SCREENTIP_CONTEXT_LMB] = "Insert SIM Card"
		. = CONTEXTUAL_SCREENTIP_SET

	return . || NONE

/obj/item/flip_phone/attack_self(mob/user, modifiers)
	. = ..()
	if(!(phone_flags & PHONE_OPEN))
		toggle_screen(user)
	ui_interact()

/obj/item/flip_phone/click_alt(mob/user)
	toggle_screen(user)
	return CLICK_ACTION_SUCCESS

/obj/item/flip_phone/attack_self_secondary(mob/user, modifiers)
	toggle_screen(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/flip_phone/item_ctrl_click(mob/user)
	if(!(user.is_holding(src)))
		return CLICK_ACTION_ANY
	if(sim_card && do_after(user, 2 SECONDS, src))
		balloon_alert(user, "you remove \the [sim_card]!")
		end_phone_call()
		user.put_in_hands(sim_card)
		sim_card = null
		phone_flags |= PHONE_NO_SIM
		return CLICK_ACTION_SUCCESS
	balloon_alert(user, "no sim card!")
	return CLICK_ACTION_BLOCKING

/obj/item/flip_phone/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/sim_card))
		if(sim_card)
			balloon_alert(user, "[sim_card] already installed!")
			return ITEM_INTERACT_BLOCKING
		balloon_alert(user, "you insert \the [attacking_item]!")
		sim_card = attacking_item
		user.transferItemToLoc(attacking_item, src)
		phone_flags &= PHONE_NO_SIM
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/item/flip_phone/ui_status(mob/user, datum/ui_state/state)
	if(!(phone_flags & PHONE_OPEN))
		return UI_CLOSE
	return ..()

/obj/item/flip_phone/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Telephone")
		ui.open()

/obj/item/flip_phone/ui_data(mob/user)
	var/list/data = list()
	data["dialed_number"] = dialed_number
	data["my_number"] = sim_card ? sim_card.phone_number : "No SIM card inserted."
	return data

/obj/item/flip_phone/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("keypad")
			switch(params["value"])
				if("C")
					dialed_number = null
					return TRUE
			dialed_number += params["value"]
			return TRUE
		if("call")
			initialize_phone_call(usr)
			return TRUE
	return FALSE

/obj/item/flip_phone/proc/toggle_screen(mob/user)
	if(phone_flags & PHONE_OPEN)
		phone_flags &= PHONE_OPEN
	else
		phone_flags |= PHONE_OPEN
	icon_state = (phone_flags & PHONE_OPEN) ? "phone2" : "phone0"
	inhand_icon_state = (phone_flags & PHONE_OPEN) ? "phone2" : "phone0"
	update_appearance()

/obj/item/flip_phone/proc/initialize_phone_call(mob/user)
	if(!sim_card)
		balloon_alert(user, "no SIM card installed!")
		return
	secure_frequency = SSphones.initiate_phone_call(sim_card, dialed_number)
	if(secure_frequency)
		phone_radio.set_frequency(secure_frequency)
		phone_radio.set_broadcasting(TRUE)
		phone_radio.set_listening(TRUE)
		phone_flags |= PHONE_IN_CALL

/obj/item/flip_phone/proc/end_phone_call()
	phone_radio.set_frequency(0)
	phone_radio.set_broadcasting(FALSE)
	phone_radio.set_listening(FALSE)
	SSphones.end_phone_call(sim_card, dialed_number)
	phone_flags &= PHONE_IN_CALL

/obj/item/flip_phone/proc/ring()
	say("RING RING RING")
