/proc/create_bank_code()
	var/bank_code = ""
	for(var/i = 1 to 10)
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

	var/atm_balance = 0
	var/obj/item/vamp/creditcard/current_card = null
	light_system = STATIC_LIGHT
	light_color = COLOR_GREEN
	light_range = 2
	light_power = 1
	light_on = TRUE



/datum/bank_account
	var/account_owner = ""
	var/bank_id = 0
	var/balance = 0
	var/code = ""
	var/list/credit_cards = list()

var/mob/living/carbon/human/H
/datum/bank_account/New()
	..()
	if(!code || code == "")
		code = create_bank_code()
		var/random_id = rand(100000, 999999)
		bank_id = random_id
		GLOB.bank_account_list += src

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

	var/owner = ""
	var/datum/bank_account/account
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
		account = new /datum/bank_account()
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
		account.balance = rand(100, 1000)

/obj/machinery/vamp/atm/Initialize()
	..()

/obj/machinery/vamp/atm/attackby(obj/item/W, mob/user)
	var/obj/item/vamp/creditcard/card = null
	var/obj/item/stack/dollar/cash = null

	if(istype(W, /obj/item/vamp/creditcard))
		card = W
	else if(istype(W, /obj/item/stack/dollar))
		cash = W
	else
		to_chat(user, "<span class='notice'>This does not work with the ATM.</span>")

	if(cash)
		var/amount = cash.amount
		atm_balance += amount
		to_chat(user, "<span class='notice'>You have deposited [amount] dollars into the ATM. The ATM now holds [atm_balance] dollars.</span>")
		qdel(cash)
		return

	if(card)
		to_chat(user, "<span class='notice'>Prompting for card code.</span>") // debug
		var/input_code = input(user, "Enter your code:", "ATM Access") as text
		if(input_code == card.account.code)
			to_chat(user, "<span class='notice'>Access granted. Welcome to Bianchi bank.</span>")
			var/choice
			while(TRUE)
				choice = alert(user, "Choose an action:", "Current Balance: $[card.account.balance]", "Withdraw Money", "Deposit into Card", "Exit")

				if(choice == "Withdraw Money")
					var/amount = input(user, "Enter the amount to withdraw:", "Withdraw Money") as num
					if(card.account.balance < amount)
						to_chat(user, "<span class='notice'>Insufficient funds.</span>")
					else
						while(amount > 0)
							var/withdraw_amount = min(amount, 1000)
							cash = new /obj/item/stack/dollar()
							cash.amount = withdraw_amount
							to_chat(user, "<span class='notice'>You have withdrawn [withdraw_amount] dollars.</span>")
							cash.loc = user.loc
							amount -= withdraw_amount
							card.account.balance -= withdraw_amount

				else if(choice == "Deposit into Card")
					if(atm_balance > 0)
						card.account.balance += atm_balance
						to_chat(user, "<span class='notice'>You have deposited [atm_balance] dollars into your card. Your new balance is [card.account.balance] dollars.</span>")
						atm_balance = 0
					else
						to_chat(user, "<span class='notice'>The ATM is empty. Nothing to deposit.</span>")
				else if(choice == "Exit")
					to_chat(user, "<span class='notice'>Thank you for using Bianchi bank.</span>")
					break
				else
					to_chat(user, "<span class='notice'>Transaction cancelled.</span>")
		else
			to_chat(user, "<span class='notice'>Invalid code.</span>")

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
