/proc/create_bank_code()
	var/bank_code = ""
	for(var/i = 1 to 4)
		bank_code += "[rand(0, 9)]"
	return bank_code

/obj/machinery/vamp/atm
	name = "ATM Machine"
	desc = "Check your balance or make a transaction"
	icon = 'icons/obj/vtm_atm.dmi'
	icon_state = "atm"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/logged_in = FALSE
	var/entered_code

	var/atm_balance = 0
	var/obj/item/vamp/creditcard/current_card = null
	light_system = STATIC_LIGHT
	light_color = COLOR_GREEN
	light_range = 2
	light_power = 1
	light_on = TRUE

/datum/vtm_bank_account
	var/name = ""
	var/account_owner = ""
	var/bank_id = 0
	var/balance = 0
	var/code = ""

/datum/vtm_bank_account/New()
	. = ..()
	if(!code || code == "")
		code = create_bank_code()
		var/random_id = rand(1, 999999)
		bank_id = random_id
		GLOB.bank_account_list += src

/datum/vtm_bank_account/proc/setup_owner(mob/living/carbon/human/owner)
	var/starting_balance = SSjob.get_starting_balance(SSjob.GetJob(owner.mind.assigned_role))
	// some jobs don't have a bank account because they're punk rock
	if(starting_balance)
		//starting_balance can be +-20% of usual, just to shake things up a little
		var/lady_luck = rand((starting_balance * 0.2), (starting_balance * 0.2 * -1))
		starting_balance += lady_luck
	balance = starting_balance
	account_owner = owner.real_name
	name = owner.real_name + "'s Bank Account"
	// we already nullcheck this before this setup gets called
	var/datum/mind/owner_mind = owner.mind
	owner_mind.store_memory("My bank account ID is [bank_id]. My bank code is [code].")

/obj/item/vamp/creditcard
	name = "\improper credit card"
	desc = "Used to access bank money."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "card1"
	inhand_icon_state = "card1"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	item_flags = NOBLUDGEON
	flags_1 = HEAR_1
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	onflooricon = 'code/modules/wod13/onfloor.dmi'

	var/datum/vtm_bank_account/account

/obj/item/vamp/creditcard/elder
	icon_state = "card3"
	inhand_icon_state = "card3"

/obj/item/vamp/creditcard/giovanniboss
	icon_state = "card2"
	inhand_icon_state = "card2"

/obj/item/vamp/creditcard/prince
	icon_state = "card2"
	inhand_icon_state = "card2"

/obj/item/vamp/creditcard/seneschal
	icon_state = "card2"
	inhand_icon_state = "card2"

/obj/item/vamp/creditcard/rich
	icon_state = "card2"
	inhand_icon_state = "card2"

/obj/item/vamp/creditcard/Initialize(mapload)
	. = ..()
	account = new /datum/vtm_bank_account()
	return INITIALIZE_HINT_LATELOAD

/obj/item/vamp/creditcard/LateInitialize()
	. = ..()
	var/mob/living/carbon/human/owner = get(loc, /mob/living/carbon/human)
	//Maybe someone printed a new credit card? I don't fucking know
	if(!owner)
		return
	//For now, assume only players have bank accounts
	if(!owner.mind)
		return
	account.setup_owner(owner)

/obj/machinery/vamp/atm/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/vamp/creditcard))
		if(logged_in)
			to_chat(user, "<span class='notice'>Someone is already logged in.</span>")
			return
		current_card = P
		to_chat(user, "<span class='notice'>Card swiped.</span>")
		return

	else if(istype(P, /obj/item/stack/dollar))
		var/obj/item/stack/dollar/cash = P
		if(!logged_in)
			to_chat(user, "<span class='notice'>You need to be logged in.</span>")
			return
		else
			atm_balance += cash.amount
			to_chat(user, "<span class='notice'>You have deposited [cash.amount] dollars into the ATM. The ATM now holds [atm_balance] dollars.</span>")
			qdel(P)
			return

/obj/machinery/vamp/atm/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Atm", name)
		ui.open()

/obj/machinery/vamp/atm/ui_data(mob/user)
	var/list/data = list()
	var/list/accounts = list()

	for(var/datum/vtm_bank_account/account in GLOB.bank_account_list)
		if(account && account.account_owner)
			accounts += list(
				list("account_owner" = account.account_owner
				)
			)
		else
			accounts += list(
				list(
					"account_owner" = "Unnamed Account"
				)
			)

	data["logged_in"] = logged_in
	data["card"] = current_card ? TRUE : FALSE
	data["entered_code"] = entered_code
	data["atm_balance"] = atm_balance
	data["bank_account_list"] = json_encode(accounts)
	if(current_card)
		data["balance"] = current_card.account.balance
		data["account_owner"] = current_card.account.account_owner
		data["bank_id"] = current_card.account.bank_id
		data["code"] = current_card.account.code
	else
		data["balance"] = 0
		data["account_owner"] = ""
		data["bank_id"] = ""
		data["code"] = ""

	return data

/obj/machinery/vamp/atm/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	.=..()
	if(.)
		return
	switch(action)
		if("login")
			if(params["code"] == current_card.account.code)
				logged_in = TRUE
				return TRUE
			else
				return FALSE
		if("logout")
			logged_in = FALSE
			entered_code = ""
			current_card = null
			return TRUE
		if("withdraw")
			var/amount = text2num(params["withdraw_amount"])
			if(amount != round(amount))
				to_chat(usr, "<span class='notice'>Withdraw amount must be a round number.")
			else if(current_card.account.balance < amount)
				to_chat(usr, "<span class='notice'>Insufficient funds.</span>")
			else
				var/remaining_amount = amount
				do
					var/obj/item/stack/dollar/cash = new /obj/item/stack/dollar()
					if(remaining_amount >= 10000)
						cash.amount = 10000
					else
						cash.amount = remaining_amount
					remaining_amount -= 10000
					var/mob/living/carbon/human/user = usr // not rebuilding this right now
					if(!user.put_in_active_hand(cash))
						cash.forceMove(get_turf(src))
				while(remaining_amount > 0)
				to_chat(usr, "<span class='notice'>You have withdrawn [amount] dollars.</span>")
				current_card.account.balance -= amount
			return TRUE
		if("transfer")
			var/amount = text2num(params["transfer_amount"])
			if(!amount || amount <= 0)
				to_chat(usr, "<span class='notice'>Invalid transfer amount.</span>")
				return FALSE

			var/target_account_id = params["target_account"]
			if(!target_account_id)
				to_chat(usr, "<span class='notice'>Invalid target account ID.</span>")
				return FALSE

			var/datum/vtm_bank_account/target_account = null
			for(var/datum/vtm_bank_account/account in GLOB.bank_account_list)
				if(account.account_owner == target_account_id)
					target_account = account
					break

			if(!target_account)
				to_chat(usr, "<span class='notice'>Invalid target account.</span>")
				return FALSE
			if(current_card.account.balance < amount)
				to_chat(usr, "<span class='notice'>Insufficient funds.</span>")
				return FALSE

			current_card.account.balance -= amount
			target_account.balance += amount
			to_chat(usr, "<span class='notice'>You have transferred [amount] dollars to account [target_account.account_owner].</span>")
			return TRUE

		if("change_pin")
			var/new_pin = params["new_pin"]
			current_card.account.code = new_pin
			return TRUE
		if("deposit")
			if(atm_balance > 0)
				current_card.account.balance += atm_balance
				to_chat(usr, "<span class='notice'>You have deposited [atm_balance] dollars into your card. Your new balance is [current_card.account.balance] dollars.</span>")
				atm_balance = 0
				return TRUE

			else
				to_chat(usr, "<span class='notice'>The ATM is empty. Nothing to deposit.</span>")
				return TRUE
