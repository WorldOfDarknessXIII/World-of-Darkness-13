/obj/structure/vaultdoor
	name = "Vault Door"
	desc = "A heavy duty door that looks like it could withstand a lot of punishment."
	icon = 'code/modules/wod13/doors.dmi'
	icon_state = "vault-1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	pixel_w = -16
	anchored = TRUE
	density = TRUE
	opacity = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

	var/id = ""
	var/baseicon = "vault"
	var/brokenicon = "vault_broken"
	var/pincode
	var/closed = TRUE
	var/lock_id = ""
	var/door_moving = FALSE
	var/is_broken = FALSE
	var/door_health = 100

	var/open_sound = 'code/modules/wod13/sounds/vault_door_opening.ogg'
	var/close_sound = 'code/modules/wod13/sounds/vault_door_closing.ogg'
	var/lock_sound = 'code/modules/wod13/sounds/vault_door_lock.ogg'

	//[Lucifernix] - Do the doors use keys, combination locks, or electric pin codes, or a mix of all three?
	var/uses_key_lock = FALSE
	var/uses_combination_lock = FALSE
	var/uses_pincode_lock = FALSE

	var/combination_locked = FALSE
	var/pincode_locked = FALSE
	var/key_locked = FALSE

/obj/structure/vaultdoor/New()
	..()
	if(uses_pincode_lock)
		pincode = create_unique_pincode()
		pincode_locked = TRUE
	if(uses_combination_lock)
		combination_locked = TRUE
	if(uses_key_lock)
		key_locked = TRUE

/obj/structure/vaultdoor/pincode
	uses_pincode_lock = TRUE

/obj/structure/vaultdoor/combination
	uses_combination_lock = TRUE

/obj/structure/vaultdoor/key
	uses_key_lock = TRUE

/obj/structure/vaultdoor/pincode_key
	uses_pincode_lock = TRUE
	uses_key_lock = TRUE

/obj/structure/vaultdoor/pincode_combination_key
	uses_pincode_lock = TRUE
	uses_combination_lock = TRUE
	uses_key_lock = TRUE

/obj/structure/vaultdoor/attack_hand(mob/user)
	. = ..()
	var/mob/living/door_user = user
	if(is_broken)
		return
	if(is_locked() || key_locked)
		if(uses_pincode_lock)
			ui_interact()
		if(door_user.a_intent != INTENT_HARM)
			to_chat(user, "<span class='warning'>[src] is locked!</span>")
		return

	if(closed && !door_moving)
		open_door(user)
	else if (!door_moving)
		close_door(user)

/obj/structure/vaultdoor/proc/break_open()
	if(is_broken)
		return
	is_broken = TRUE
	icon_state = "[brokenicon]-1"
	density = FALSE
	opacity = FALSE
	layer = OPEN_DOOR_LAYER
	visible_message("<span class='warning' style='color:red; font-size:20px;'><b>[src] breaks!</b></span>")

/obj/structure/vaultdoor/proc/open_door(mob/user)
	playsound(src, open_sound, 75, TRUE)
	door_moving = TRUE
	if(do_after(user, 4 SECONDS))
		icon_state = "[baseicon]-0"
		density = FALSE
		opacity = FALSE
		layer = OPEN_DOOR_LAYER
		to_chat(user, "<span class='notice'>You open [src].</span>")
		closed = FALSE
		door_moving = FALSE

/obj/structure/vaultdoor/proc/close_door(mob/user)
	for(var/atom/movable/door_blocker in src.loc)
		if(door_blocker.density)
			to_chat(user, "<span class='warning'>[door_blocker] is preventing you from closing [src].</span>")
			return
	playsound(src, close_sound, 75, TRUE)
	door_moving = TRUE
	if(do_after(user, 4 SECONDS))
		icon_state = "[baseicon]-1"
		density = TRUE
		layer = ABOVE_ALL_MOB_LAYER
		to_chat(user, "<span class='notice'>You close [src].</span>")
		closed = TRUE
		door_moving = FALSE

/obj/structure/vaultdoor/proc/is_locked()
	return combination_locked || pincode_locked

/obj/structure/vaultdoor/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Pincode lock or combination lock can be re-locked with alt-click!</span>"
	. += "<span class='notice'>Door health: [door_health]/100.</span>"
	if(is_locked() || key_locked)
		. += "<span class='warning'>[src] is locked.</span>"
	if(uses_pincode_lock)
		. += "<span class='notice'>[src] requires a pin code to unlock.</span>"
	if(uses_combination_lock)
		. += "<span class='notice'>[src] requires a combination to unlock.</span>"
	if(uses_key_lock)
		. += "<span class='notice'>[src] requires a key to unlock.</span>"


/obj/structure/vaultdoor/AltClick(mob/user)
	. = ..()
	if(is_broken)
		return
	if(!is_locked() && closed)
		lock_door(user)

/obj/structure/vaultdoor/proc/lock_door(mob/user)
	if(uses_combination_lock && !combination_locked)
		combination_locked = TRUE
		to_chat(user, "<span class='notice'>You lock [src] with a combination lock.</span>")
	else if (uses_pincode_lock && !pincode_locked)
		pincode_locked = TRUE
		to_chat(user, "<span class='notice'>You lock [src] with a pincode lock.</span>")
	else if (combination_locked || pincode_locked)
		to_chat(user, "<span class='warning'>[src] is already locked!</span>")

/obj/structure/vaultdoor/attackby(obj/item/used_item, mob/living/user, params)
	if(is_broken)
		return
	if(istype(used_item, /obj/item/vamp/keys))
		var/obj/item/vamp/keys/key = used_item
		if(key.accesslocks)
			for(var/i in key.accesslocks)
				if(i == lock_id)
					if(uses_key_lock)
						if(key_locked)
							if(closed)
								playsound(src, lock_sound, 75, TRUE)
								if(do_after(user, 3 SECONDS))
									to_chat(user, "[src] is now unlocked.")
									key_locked = FALSE
							else
								to_chat(user, "[src] is open and cannot be locked or unlocked.")
								return
						else
							if(closed)
								playsound(src, lock_sound, 75, TRUE)
								if(do_after(user, 3 SECONDS))
									playsound(src, lock_sound, 75, TRUE)
									to_chat(user, "[src] is now locked with keys.")
									key_locked = TRUE
							else
								to_chat(user, "[src] is open and cannot be locked or unlocked.")
								return
				else
					to_chat(user, "<span class='warning'>[src] can't be unlocked with these keys!</span>")

/obj/structure/vaultdoor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(is_broken)
		return
	if(!pincode_locked)
		return
	else if(!ui)
		ui = new(user, src, "VaultDoor")
		ui.open()

/obj/structure/vaultdoor/ui_data(mob/user)
	var/list/data = list()
	data["pincode"] = pincode
	return data

/obj/structure/vaultdoor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "submit_pincode")
		if(params["pincode"] == pincode)
			to_chat(usr, "<span class='notice'>Access Granted.</span>")
			pincode_locked = FALSE
		else
			to_chat(usr, "<span class='notice'>Access Denied.</span>")
		. = TRUE
	update_icon()
