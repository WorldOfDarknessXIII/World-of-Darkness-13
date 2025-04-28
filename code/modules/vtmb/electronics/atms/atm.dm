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
	layer = BELOW_MOB_LAYER
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

/obj/machinery/vamp/atm/New()
	..()
	logged_in = FALSE
	current_card = null



/datum/vtm_bank_account
	var/account_owner = ""
	var/bank_id = 0
	var/balance = 0
	var/code = ""
	var/list/credit_cards = list()

var/mob/living/carbon/human/H
/datum/vtm_bank_account/New()
	..()
	if(!code || code == "")
		code = create_bank_code()
		var/random_id = rand(1, 999999)
		bank_id = random_id
		GLOB.bank_account_list += src

/obj/item/vamp/creditcard
	name = "debit card"
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

	var/owner = ""
	var/datum/vtm_bank_account/account
	var/code
	var/balance = 0
	var/has_checked = FALSE

/obj/item/vamp/creditcard/prince
	icon_state = "card2"
	inhand_icon_state = "card2"

/obj/item/vamp/creditcard/seneschal
	icon_state = "card2"
	inhand_icon_state = "card2"

/obj/item/vamp/creditcard/elder
	icon_state = "card3"
	inhand_icon_state = "card3"

/obj/item/vamp/creditcard/giovanniboss
	icon_state = "card2"
	inhand_icon_state = "card2"

/obj/item/vamp/creditcard/rich

/obj/item/vamp/creditcard/New(mob/user)
	..()
	if(!account || code == "")
		account = new /datum/vtm_bank_account()
	if(user)
		owner = user.ckey
	if(istype(src, /obj/item/vamp/creditcard/prince))
		account.balance = rand(10000, 15000)
	else if(istype(src, /obj/item/vamp/creditcard/elder))
		account.balance = rand(3000, 7000)
	else if(istype(src, /obj/item/vamp/creditcard/rich))
		account.balance = rand(1000, 4000)
	else if(istype(src, /obj/item/vamp/creditcard/giovanniboss))
		account.balance = rand(8000, 15000)
	else if(istype(src, /obj/item/vamp/creditcard/seneschal))
		account.balance = rand(4000, 8000)
	else
		account.balance = rand(600, 1000)

/obj/machinery/vamp/atm/Initialize()
	..()

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
				while(amount > 0)
					var/drop_amount = min(amount, 1000)
					var/obj/item/stack/dollar/cash = new /obj/item/stack/dollar()
					cash.amount = drop_amount
					to_chat(usr, "<span class='notice'>You have withdrawn [drop_amount] dollars.</span>")
					cash.loc = usr.loc
					amount -= drop_amount
					current_card.account.balance -= drop_amount
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
/*
/obj/machinery/vamp/atm/attack_hand(mob/user)
	.=..()
	ui_interact(user)

/obj/machinery/vamp/atm/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/vamp/creditcard))
		inserted_card = W
		to_chat(user, "<span class='notice'>Card inserted into ATM.</span>")
		user.ui_interact(src)
		return
	else
		return

/obj/machinery/vamp/atm/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Atm")
		ui.open()

/obj/machinery/vamp/atm/ui_data(mob/user)
	var/list/data = list()
//	data["balance"] = balance
	data["atm_balance"] = atm_balance

	return data

/obj/machinery/vamp/atm/ui_act(action, params)
	.=..()
	if(.)
		return

	switch(action)
		if("login")
			var/input_code = input(usr, "Enter your code:", "ATM access")
			if(input_code == inserted_card.account.code)
				to_chat(usr, "<span class='notice'>Access granted.</span>")
				logged_in = TRUE
			else
				to_chat(usr, "<span class='notice'>Invalid PIN Code.</span>")
				logged_in = FALSE


/obj/machinery/vamp/atm/attack_hand(mob/user)
	.=..()
	ui_interact(user)
*/
