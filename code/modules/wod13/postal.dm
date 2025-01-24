// The postal system
// Supply Technicians can use the letter machine to spawn delivery lists in exchange of their own money.
// The delivery lists spawns with a bunch of letters associated with it, each letter having one living, active player as a target.
// The letter can only be opened by the target and whoever the target allows them to, handled by passport.dm and signature_system.dm.
// The Supply Technician has to ensure the delivery list is signed by the relevant party for their own payment BEFORE the letter is opened.
// A signed delivery list can be returned to the letter machine which pays for the amount of signatures the Technician collected.
// Letters can be opened with or without signing, but the Technician gets no money for any letter that was opened without signing the delivery list.

// For admins: This system can be tweaked on a per-item basis or on a global level via SSeconomy.
// If you wish to edit it on a global scale, go to MC tab > Economy, click the numbers next to it > edit the variables starting with the mail_ prefix.
// If you want to do it on a per-letter basis, you can change its own loot table by resetting the 'possible_gifts' list to default (empty),
// and then add whatever item's path you want it to contain.
// You can edit the recipient by marking the target mob and changing the 'recipient' variable to it.

// Letter that can only be opened by their recipient, contains a random item
/obj/item/letter
	name = "letter"
	desc = "A letter containing a small gift. Only its recipient can open it.<br>Use it in hand to open it."
	icon_state = "letter"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	///The person who can open this letter, assigned upon Initialize()
	var/mob/living/carbon/human/recipient
	///The list of items this letter can contain, we copy this list on Initialize() so admins can create custom letters
	var/list/possible_gifts = list()
	///Do we belong to a delivery list? By default, yes, but this remains null when admins spawn this item by itself
	var/obj/item/mail_delivery_list/associated_delivery_list

/obj/item/letter/Initialize()
	. = ..()
	possible_gifts = SSeconomy.mail_possible_gifts

	// Find living humans
	var/list/possible_choices = list()
	for(var/mob/living/carbon/human/human in SSticker.mode.current_players[CURRENT_LIVING_PLAYERS])
		possible_choices.Add(human)

	if(length(possible_choices))
		recipient = pick(possible_choices)
		name = "letter ([recipient])"
		return

	// Nobody is alive: admins are likely spawning stuff before roundstart
	become_invalid()

/obj/item/letter/Destroy()
	// Reference handling with mail_delivery_list
	if(associated_delivery_list)
		var/obj/item/mail_delivery_list/delivery_list = associated_delivery_list
		delivery_list.letters_associated.Remove(src)
		associated_delivery_list = null
	return ..()

// We spawned without a recipient or the mail_delivery_list got destroyed
/obj/item/letter/proc/become_invalid()
	SIGNAL_HANDLER
	associated_delivery_list = null

/obj/item/letter/examine(mob/user)
	. = ..()
	if(recipient)
		. += "This letter is addressed to <b>[recipient].</b>"
	if(!associated_delivery_list)
		. += "This letter cannot be delivered for money. It can be recycled at the letter machine and it can be still opened by its owner."

/obj/item/letter/proc/check_for_eligible_opener(mob/user)
	if(!ishuman(user))
		return
	var/datum/component/signature_system/signature_system = recipient.GetComponent(/datum/component/signature_system)
	if(!signature_system)
		return
	var/is_eligible_signer = signature_system.is_eligible_signer(user)
	if(is_eligible_signer)
		return TRUE

/obj/item/letter/attack_self(mob/user)
	. = ..()
	// We get its contents and destroy the letter
	if(check_for_eligible_opener(user))
		playsound(loc, 'sound/items/poster_ripped.ogg', 50, TRUE)
		var/gift_to_spawn = pick(possible_gifts)
		user.put_in_hands(new gift_to_spawn)
		// Save this for roundend reasons
		SSeconomy.mail_last_recipient = user.real_name
		qdel(src)
		return
	// Wrong person tries to open it
	to_chat(user, "<span class='warning'>This mail was not meant for you! Only its recipient can open it.</span>")
	return

// When spawned, spawns a bunch of letters with it TODO: More explanation
/obj/item/mail_delivery_list
	name = "delivery list"
	desc = "A list of names of people who are waiting for a mail delivery.<br>Click it with a pen in your hand to sign it."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "delivery_list"
	inhand_icon_state = "delivery_list"
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	slot_flags = ITEM_SLOT_BELT
	resistance_flags = FLAMMABLE
	///The letters associated with this item, they spawn with the item itself
	var/list/letters_associated = list()
	///How many signatures we collected
	var/amount_of_signatures = 0

// Spawn letters when it gets spawned and associate them with the list
/obj/item/mail_delivery_list/Initialize()
	. = ..()
	var/obj/item/letter/new_letter
	for(var/i = 0, i < SSeconomy.mail_delivery_list_letters, ++i)
		new_letter = new /obj/item/letter(get_turf(src))

		// Reference handling
		new_letter.RegisterSignal(new_letter, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/obj/item/letter, become_invalid))
		new_letter.associated_delivery_list = src
		letters_associated.Add(new_letter)

// If this object is destroyed, invalidate all letters associated with it and remove the weak references
/obj/item/mail_delivery_list/Destroy()
	for(var/obj/item/letter/chosen_letter)
		chosen_letter.become_invalid()
		chosen_letter.UnregisterSignal(chosen_letter, COMSIG_PARENT_QDELETING)
		letters_associated.Remove(chosen_letter)
	return ..()

// Signing it, uses the signature_system component
/obj/item/mail_delivery_list/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pen))
		if(!length(letters_associated))
			to_chat(user, "<span class='notice'>There is nothing left to sign!</span>")
			return
		var/was_signed = FALSE
		// Let's see if we can find anything to sign
		for(var/obj/item/letter/letter in letters_associated)
			// This variable is for the audio so it doesn't play multiple times
			if((letter.associated_delivery_list == src) && letter.check_for_eligible_opener(user))
				letter.become_invalid()
				letters_associated.Remove(letter)
				amount_of_signatures++
				to_chat(user, "<span class='notice'>You sign [src].</span>")
				// Increment this for roundend reasons
				SSeconomy.mail_signed++
				was_signed = TRUE
		if(was_signed)
			playsound(loc, 'sound/items/pen_signing.ogg', 20, TRUE)

/obj/item/mail_delivery_list/examine(mob/user)
	. = ..()
	if(!length(letters_associated))
		. += "This delivery list is empty!"
		return
	. += "The following [length(letters_associated) > 1 ? "people are" : "person is"] waiting for their mail:"
	for(var/obj/item/letter/letter in letters_associated)
		. += letter.recipient

// The machine printing
/obj/lettermachine
	name = "letter machine"
	desc = "Work as letterman! Find a job!<br>Insert cash to purchase letters."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "mail"
	density = TRUE
	anchored = TRUE
	plane = GAME_PLANE
	layer = CAR_LAYER
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/money = 0

/obj/lettermachine/attack_hand(mob/living/user)
	if(money >= SSeconomy.mail_delivery_list_cost)
		new /obj/item/mail_delivery_list(get_turf(src))
		playsound(src, 'sound/items/handling/paper_pickup.ogg', 30)
		say("A new set of letters were delivered!")
		money = max(0, money - SSeconomy.mail_delivery_list_cost)
	else
		say("Not enough money on [src]'s balance! Insert more cash!")
	..()

/obj/lettermachine/attackby(obj/item/I, mob/user, params)
	// Refilling the machine with money to buy letters
	if(istype(I, /obj/item/stack/dollar))
		var/obj/item/stack/dollar/cash_money = I
		money += cash_money.amount
		say("$[cash_money.amount] inserted!")
		qdel(cash_money)
		return

	// Cashing in the signed delivery list
	if(istype(I, /obj/item/mail_delivery_list))
		var/obj/item/mail_delivery_list/delivery_list = I
		if(!delivery_list.amount_of_signatures)
			say("You need at least one signature to get paid!")
			return
		if(!length(delivery_list.letters_associated))
			say("Delivery list recycled.")
			qdel(delivery_list)
			return
		// This is to ensure people don't game increments with lucky lagspikes
		var/possible_maximum_payment = SSeconomy.mail_delivery_list_letters * SSeconomy.mail_delivery_signed_letter_reward
		var/payment = min(delivery_list.amount_of_signatures * SSeconomy.mail_delivery_signed_letter_reward, possible_maximum_payment)
		// Reset our payment
		say("You have cashed in [delivery_list.amount_of_signatures] [delivery_list.amount_of_signatures > 1 ? "signatures" : "signature"], worth $[payment]!")
		delivery_list.amount_of_signatures = 0
		// Pay our employee
		var/obj/item/stack/dollar/money = new /obj/item/stack/dollar()
		money.amount = payment
		user.put_in_hands(money)
		return

	// Returning invalid letters
	if(istype(I, /obj/item/letter))
		var/obj/item/letter/letter = I
		if(!letter.associated_delivery_list)
			var/refund_amount = round(SSeconomy.mail_delivery_list_letters / SSeconomy.mail_delivery_list_cost)
			// This is a safety net in case admins wrongly varedited SSeconomy
			refund_amount = max(1, refund_amount)
			qdel(letter)
			// Pay our employee
			var/obj/item/stack/dollar/money = new /obj/item/stack/dollar()
			money.amount = refund_amount
			user.put_in_hands(money)
			say("Letter refunded.")

/obj/lettermachine/examine(mob/user)
	. = ..()
	. += "[src] contains <b>[money] dollars</b>."
