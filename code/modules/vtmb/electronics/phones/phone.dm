/proc/create_unique_phone_number(var/exchange = 513)
	if(length(GLOB.subscribers_numbers_list) < 1)
		create_subscribers_numbers()
	var/subscriber_code = pick(GLOB.subscribers_numbers_list)
	GLOB.subscribers_numbers_list -= subscriber_code
	return "[exchange][subscriber_code]"

/proc/create_subscribers_numbers()
	for(var/i in 1 to 9999)
		var/ii = "0000"
		switch(i)
			if(1 to 9)
				ii = "000[i]"
			if(10 to 99)
				ii = "00[i]"
			if(100 to 999)
				ii = "0[i]"
			if(1000 to 9999)
				ii = "[i]"
		GLOB.subscribers_numbers_list += ii

/obj/item/vamp/phone
	name = "\improper phone"
	desc = "A portable device to call anyone you want."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "phone0"
	inhand_icon_state = "phone0"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	item_flags = NOBLUDGEON
	flags_1 = HEAR_1
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	onflooricon = 'code/modules/wod13/onfloor.dmi'

	var/exchange_num = 513
	var/list/contacts = list()
	var/closed = TRUE
	var/number
	var/obj/item/vamp/phone/online
	var/talking = FALSE
	var/choosed_number = ""
	var/last_call = 0
	var/call_sound = 'code/modules/wod13/sounds/call.ogg'
	var/can_fold = 1
	var/interface = "Telephone"

	/// Phone icon states
	var/open_state = "phone2"
	var/closed_state = "phone1"
	var/folded_state = "phone0"

/obj/item/vamp/phone/Initialize()
	..()
	RegisterSignal(src, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hearing))
	if(!number || number == "")
		number = create_unique_phone_number(exchange_num)
		GLOB.phone_numbers_list += number
		GLOB.phones_list += src

/obj/item/vamp/phone/Destroy()
	GLOB.phone_numbers_list -= number
	GLOB.phones_list -= src
	UnregisterSignal(src, COMSIG_MOVABLE_HEAR)
	..()

/obj/item/vamp/phone/attack_hand(mob/user)
	. = ..()
	ui_interact(user)

/obj/item/vamp/phone/interact(mob/user)
	. = ..()
	ui_interact(user)

/obj/item/vamp/phone/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
//	if(iskindred(user))
//		var/mob/living/carbon/human/H = user
//		if(H.clane)
//			if(H.clane.name == "Lasombra")
//				return
	if(closed)
		closed = FALSE
		icon_state = open_state
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, interface, interface)
		ui.open()
/*
	else
		closed = TRUE
		icon_state = "phone0"
		talking = FALSE
		if(online)
			online.online = null
			online.talking = FALSE
			online = null
			ui.close()


/obj/item/vamp/phone/attack_self(mob/user)
	if(!closed)
		closed = TRUE
		icon_state = "phone0"
		talking = FALSE
		if(online)
			online.online = null
			online.talking = FALSE
			online = null
	else
		return ..()
*/

/obj/item/vamp/phone/AltClick(mob/user)
	if(can_fold && !closed)
		closed = TRUE
		icon_state = folded_state
		talking = FALSE
		if(online)
			online.online = null
			online.talking = FALSE
			online = null

/obj/item/vamp/phone/ui_data(mob/user)
	var/list/data = list()
	data["calling"] = FALSE
	if(last_call+100 > world.time && !talking)
		data["calling"] = TRUE

	data["online"] = online
	data["talking"] = talking
	data["my_number"] = choosed_number
	data["choosed_number"] = choosed_number
	if(online)
		data["calling_user"] = "(+1 707) [online.number]"
		for(var/datum/phonecontact/P in contacts)
			if(P.number == online.number)
				data["calling_user"] = P.name

	return data
/*
/obj/item/vamp/phone/proc/OpenMenu(var/mob/mobila)
	var/dat = "<body><center><h2>Phone</h2><BR>"
	if(last_call+100 > world.time && !talking)
		dat += "Calling...<BR>"
		dat += "<a href='byond://?src=[REF(src)];choice=hang'><b>Hang up</b></a><BR>"
	else
		if(online)
			var/who_talking_with = "(+1 707) [online.number]"
			for(var/datum/phonecontact/P in contacts)
				if(P.number == online.number)
					who_talking_with = P.name
			if(talking)
				dat += "Current call: [who_talking_with]<BR>"
				dat += "<a href='byond://?src=[REF(src)];choice=hang'><b>Hang up</b></a><BR>"
			else
				dat += "[who_talking_with] is calling!<BR>"
				dat += "<a href='byond://?src=[REF(src)];choice=accept'><b>Accept</b></a><BR>"
				dat += "<a href='byond://?src=[REF(src)];choice=decline'><b>Decline</b></a><BR>"
		else
			if(number)
				dat += "My number is (+1 707) [number]<BR>"
			dat += "Typed number: [choosed_number]_<BR>"
			dat += "<a href='byond://?src=[REF(src)];choice=1'>1</a>||<a href='byond://?src=[REF(src)];choice=2'>2</a>||<a href='byond://?src=[REF(src)];choice=3'>3</a><BR>"
			dat += "<a href='byond://?src=[REF(src)];choice=4'>4</a>||<a href='byond://?src=[REF(src)];choice=5'>5</a>||<a href='byond://?src=[REF(src)];choice=6'>6</a><BR>"
			dat += "<a href='byond://?src=[REF(src)];choice=7'>7</a>||<a href='byond://?src=[REF(src)];choice=8'>8</a>||<a href='byond://?src=[REF(src)];choice=9'>9</a><BR>"
			dat += "<a href='byond://?src=[REF(src)];choice=space'>_</a>||<a href='byond://?src=[REF(src)];choice=0'>0</a>||<a href='byond://?src=[REF(src)];choice=cage'>#</a><BR>"
			dat += "<a href='byond://?src=[REF(src)];choice=reset'>*</a><BR>"
			dat += "<a href='byond://?src=[REF(src)];choice=call'><b>Call</b></a><BR>"
			dat += "<a href='byond://?src=[REF(src)];choice=contacts'><b>Contacts</b></a><BR>"
			dat += "<a href='byond://?src=[REF(src)];choice=add'><b>Add contact</b></a><BR>"
	dat += "</center>"
	dat += "Ambulance number is: 911<BR>"
	dat += "Cleaning services number is: 700 4424<BR>"
	dat += "</body>"
	mobila << browse(dat, "window=phone;size=250x350;border=1;can_resize=0;can_minimize=0")
	onclose(mobila, "phone", src)
*/

/obj/item/vamp/phone/ui_act(action, params)
	. = ..()
	if(.)
		return
//	var/mob/living/carbon/human/V = usr


	switch(action)
		if("hang")
			last_call = 0
			if(talking)
				talking = FALSE
				if(online)
					online.talking = FALSE
			if(online)
				playsound(online, 'code/modules/wod13/sounds/phonestop.ogg', 25, FALSE)
				online.online = null
				online = null
			.= TRUE
		if("accept")
			if(online)
				talking = TRUE
				online.online = src
				online.talking = TRUE
			.= TRUE
		if("decline")
			talking = FALSE
			if(online)
				playsound(online, 'code/modules/wod13/sounds/phonestop.ogg', 25, FALSE)
				online.online = null
				online.talking = FALSE
				online = null
			.= TRUE
		if("call")
//			if((iskindred(V) && V.clane.name == "Lasombra"))
//				return
//			else
			choosed_number = replacetext(choosed_number, " ", "")
			for(var/obj/item/vamp/phone/PHN in GLOB.phones_list)
				if(PHN.number == choosed_number)
					if(!PHN.online && !PHN.talking)
						last_call = world.time
						online = PHN
						PHN.online = src
						Recall(online, usr)
					else
						to_chat(usr, "<span class='notice'>Abonent is busy.</span>")
			if(!online)
				if(choosed_number == "#111")
					call_sound = 'code/modules/wod13/sounds/call.ogg'
					to_chat(usr, "<span class='notice'>Settings are now reset to default.</span>")
				else if(choosed_number == "#228")
					call_sound = 'code/modules/wod13/sounds/nokia.ogg'
					to_chat(usr, "<span class='notice'>Code activated.</span>")
				else if(choosed_number == "#666")
					call_sound = 'sound/voice/human/malescream_6.ogg'
					to_chat(usr, "<span class='notice'>Code activated.</span>")
				else if(choosed_number == "#34")
					if(ishuman(usr))
						var/mob/living/carbon/human/H = usr
						H.emote("moan")
					to_chat(usr, "<span class='notice'>Code activated.</span>")
				else
					to_chat(usr, "<span class='notice'>Invalid number.</span>")
			.= TRUE
		if("contacts")
			var/list/options = list("Add", "Choose", "My Number", "Publish Number", "Published Numbers")
			var/option =  input(usr, "Select an option", "Option Selection") as null|anything in options
			var/result
			switch(option)
				if("Publish Number")
					if (!islist(GLOB.published_numbers))
						GLOB.published_numbers = list()
					if (!islist(GLOB.published_number_names))
						GLOB.published_number_names = list()

					var/name = input(usr, "Input name", "Publish Number") as text|null
					if(name && src.number)
						if(src.number in GLOB.published_numbers)
							to_chat(usr, "<span class ='notice'>This number is already published.</span>")
						else
							GLOB.published_numbers += src.number
							GLOB.published_number_names += name
							to_chat(usr, "<span class='notice'>Your number is now published.</span>")
       					//to_chat(usr, "<span class='notice'>Published numbers: [GLOB.published_numbers]</span>")
       					//to_chat(usr, "<span class='notice'>Published names: [GLOB.published_number_names]</span>")
					else
						to_chat(usr, "<span class='notice'>You must input a name to publish your number.</span>")

				if ("Published Numbers")
					var/list_length = min(length(GLOB.published_numbers), length(GLOB.published_number_names))
					for(var/i = 1 to list_length)
						var/number = GLOB.published_numbers[i]
						var/display_number_first = copytext(number, 1, 4)
						var/display_number_second = copytext(number, 4, 8)
						var/split_number = display_number_first + " " + display_number_second
						var/name = GLOB.published_number_names[i]
						to_chat(usr, "- [name]: [split_number]")
				if("Add")
					var/new_contact = input(usr, "Input phone number", "Add Contact")  as text|null
					if(new_contact)
						var/datum/phonecontact/NEWC = new()
						new_contact = replacetext(new_contact, " ", "") //Removes spaces
						NEWC.number = "[new_contact]"
						contacts += NEWC
						var/new_contact_name = input(usr, "Input name", "Add Contact")  as text|null
						if(new_contact_name)
							NEWC.name = "[new_contact_name]"
						else
							var/numbrr = length(contacts)+1
							NEWC.name = "Contact [numbrr]"
				if("Choose")
					var/list/shit = list()
					for(var/datum/phonecontact/CNTCT in contacts)
						if(CNTCT)
							shit += CNTCT.name
					if(length(shit) >= 1)
						result = input(usr, "Select a contact", "Contact Selection") as null|anything in shit
						if(result)
							for(var/datum/phonecontact/CNTCT in contacts)
								if(CNTCT.name == result)
									if(CNTCT.number == "")
										CNTCT.check_global_contacts()
										if(CNTCT.number == "")
											to_chat(usr, "<span class='notice'>Sorry, [CNTCT.name] does not have a number.</span>")
									choosed_number = CNTCT.number
				if("My Number")
					var/number_first_part = copytext(number, 1, 4)
					var/number_second_part = copytext(number, 4, 8)
					to_chat(usr, number_first_part + " " + number_second_part)
			.= TRUE
		if("keypad")
			playsound(loc, 'sound/machines/terminal_select.ogg', 15, TRUE)
			switch(params["value"])
				if("C")
					choosed_number = ""
					.= TRUE
					return
				if("_")
					choosed_number += " "
					.= TRUE
					return

			choosed_number += params["value"]
			.= TRUE

	return FALSE


/obj/item/vamp/phone/proc/add_important_contacts()
	var/mob/living/L
	if(isliving(loc))
		L = loc
	for(var/datum/phonecontact/PHNCNTCT in contacts)
		if(PHNCNTCT)
			if(PHNCNTCT.check_global_contacts())
				if(L)
					to_chat(L, "<span class='notice'>Some important contacts in your phone work again.</span>")

/*obj/item/vamp/phone/proc/publish_number(var/name)
	var/list/entry = list("number" = src.number, "name" = name)
	published_numbers |= entry

/obj/item/vamp/phone/proc/view_published_numbers()
	var/list/display = list()
	for(var/list/entry in published_numbers)
		display |= "[entry["name"]]: [entry["number"]]
	return display"*/

/obj/item/vamp/phone/proc/Recall(var/obj/item/vamp/phone/abonent, var/mob/usar)
	if(last_call+100 <= world.time && !talking)
		last_call = 0
		if(online)
			playsound(src, 'code/modules/wod13/sounds/phonestop.ogg', 25, FALSE)
			online.online = null
			online = null
	if(!talking && online)
		playsound(src, 'code/modules/wod13/sounds/phone.ogg', 10, FALSE)
		playsound(online, online.call_sound, 25, FALSE)
		addtimer(CALLBACK(src, PROC_REF(Recall), online, usar), 20)
//	usar << browse(null, "window=phone")
//	OpenMenu(usar)
/*
/obj/item/vamp/phone/Topic(href, href_list)
	..()
	var/mob/living/U = usr
	if(usr.canUseTopic(src, FALSE, FALSE, NO_TK) && !href_list["close"] && !closed)
		switch(href_list["choice"])
			if("hang")
				last_call = 0
				if(talking)
					talking = FALSE
					if(online)
						online.talking = FALSE
				if(online)
					playsound(online, 'code/modules/wod13/sounds/phonestop.ogg', 25, FALSE)
					online.online = null
					online = null
			if("accept")
				if(online)
					talking = TRUE
					online.online = src
					online.talking = TRUE
					for(var/mob/living/L in oviewers(online))
						L << browse(null, "window=phone")
						online.OpenMenu(L)
			if("decline")
				talking = FALSE
				if(online)
					playsound(online, 'code/modules/wod13/sounds/phonestop.ogg', 25, FALSE)
					online.online = null
					online.talking = FALSE
					online = null
			if("call")
				for(var/obj/item/vamp/phone/PHN in GLOB.phones_list)
					if(PHN.number == choosed_number)
						if(!PHN.online && !PHN.talking)
							last_call = world.time
							online = PHN
							PHN.online = src
							Recall(online, usr)
						else
							to_chat(usr, "<span class='notice'>Abonent is busy.</span>")
				if(online)
					for(var/mob/living/L in oviewers(online))
						L << browse(null, "window=phone")
						online.OpenMenu(L)
				else
					if(choosed_number == "#111")
						call_sound = 'code/modules/wod13/sounds/call.ogg'
						to_chat(usr, "<span class='notice'>Settings are now reset to default.</span>")
					else if(choosed_number == "#228")
						call_sound = 'code/modules/wod13/sounds/nokia.ogg'
						to_chat(usr, "<span class='notice'>Code activated.</span>")
					else if(choosed_number == "#666")
						call_sound = 'sound/voice/human/malescream_6.ogg'
						to_chat(usr, "<span class='notice'>Code activated.</span>")
					else if(choosed_number == "#34")
						usr << link("https://rule34.xxx/index.php?page=post&s=list&tags=werewolf")
						to_chat(usr, "<span class='notice'>Code activated.</span>")
					else
						to_chat(usr, "<span class='notice'>Invalid number.</span>")
			if("contacts")
				var/list/shit = list()
				for(var/datum/phonecontact/CNTCT in contacts)
					if(CNTCT)
						shit += CNTCT.name
				if(length(shit) >= 1)
					var/result = input(usr, "Select a contact", "Contact Selection") as null|anything in shit
					if(result)
						for(var/datum/phonecontact/CNTCT in contacts)
							if(CNTCT.name == result)
								if(CNTCT.number == "")
									CNTCT.check_global_contacts()
									if(CNTCT.number == "")
										to_chat(usr, "<span class='notice'>Sorry, [CNTCT.name] still got no actual number.</span>")
								choosed_number = CNTCT.number
			if("add")
				var/new_contact = input(usr, "Input phone number", "Add Contact")  as text|null
				if(new_contact)
					var/datum/phonecontact/NEWC = new()
					NEWC.number = "[new_contact]"
					contacts += NEWC
					var/new_contact_name = input(usr, "Input name", "Add Contact")  as text|null
					if(new_contact_name)
						NEWC.name = "[new_contact_name]"
					else
						var/numbrr = length(contacts)+1
						NEWC.name = "Contact [numbrr]"
			if("1")
				choosed_number += "1"
			if("2")
				choosed_number += "2"
			if("3")
				choosed_number += "3"
			if("4")
				choosed_number += "4"
			if("5")
				choosed_number += "5"
			if("6")
				choosed_number += "6"
			if("7")
				choosed_number += "7"
			if("8")
				choosed_number += "8"
			if("9")
				choosed_number += "9"
			if("0")
				choosed_number += "0"
			if("space")
				choosed_number += " "
			if("cage")
				choosed_number += "#"
			if("reset")
				choosed_number = ""
		U << browse(null, "window=phone")
		OpenMenu(usr)
		playsound(loc, 'sound/machines/terminal_select.ogg', 15, TRUE)
	else
		U << browse(null, "window=phone")
*/


/obj/item/vamp/phone/proc/handle_hearing(datum/source, list/hearing_args)
	var/message = hearing_args[HEARING_RAW_MESSAGE]
	if(online && talking)
		if(hearing_args[HEARING_SPEAKER])
			if(isliving(hearing_args[HEARING_SPEAKER]))
				var/voice_saying = "unknown voice"
				var/spchspn = SPAN_ROBOT
				switch(get_dist(src, hearing_args[HEARING_SPEAKER]))
					if(3 to INFINITY)
						return
					if(1 to 2)
						spchspn = "small"
					else
						spchspn = SPAN_ROBOT
				if(ishuman(hearing_args[HEARING_SPEAKER]))
					var/mob/living/carbon/human/SPK = hearing_args[HEARING_SPEAKER]
					voice_saying = "[age2agedescription(SPK.age)] [SPK.gender] voice ([SPK.phonevoicetag])"

					if(SPK.clane && SPK.clane.name == "Lasombra")
						message = scramble_lasombra_message(message)
						playsound(online, 'code/modules/wod13/sounds/lasombra_whisper.ogg', 50, FALSE)
					else
						playsound(online, 'code/modules/wod13/sounds/phonetalk.ogg', 50, FALSE)
//					if(SPK.clane)
//						if(SPK.clane.name == "Lasombra")
//							return
				var/obj/phonevoice/VOIC = new(online)
				VOIC.name = voice_saying
				VOIC.speech_span = spchspn
				VOIC.say("[message]")
//				playsound(online, 'code/modules/wod13/sounds/phonetalk.ogg', 50, FALSE)
				qdel(VOIC)

/obj/item/vamp/phone/street
	desc = "An ordinary street payphone"
	icon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "streetphone"
	anchored = TRUE
	number = "1447"
	can_fold = 0

	/// Phone icon states
	open_state = "streetphone"
	closed_state = "streetphone"
	folded_state = "streetphone"

/obj/item/vamp/phone/clean
	desc = "The usual phone of a cleaning company used to communicate with employees"
	icon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "redphone"
	anchored = TRUE
	number = "700 4424"
	can_fold = 0

	open_state = "redphone"
	closed_state = "redphone"
	folded_state = "redphone"

/obj/item/vamp/phone/clean/Initialize()
	. = ..()
	GLOB.phone_numbers_list += number
	GLOB.phones_list += src

/// Phone Types

/obj/item/vamp/phone/prince
	exchange_num = 267

/obj/item/vamp/phone/prince/Initialize()
	..()
	GLOB.princenumber = number
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/barkeeper/BARKEEPER = new()
	contacts += BARKEEPER
	var/datum/phonecontact/malkavian/M = new()
	contacts += M
	var/datum/phonecontact/nosferatu/N = new()
	contacts += N
	var/datum/phonecontact/toreador/T = new()
	contacts += T
	var/datum/phonecontact/ventrue/V = new()
	contacts += V
	var/datum/phonecontact/brujah/B = new()
	contacts += B

/obj/item/vamp/phone/sheriff
	exchange_num = 267

/obj/item/vamp/phone/sheriff/Initialize()
	..()
	GLOB.sheriffnumber = number
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE

/obj/item/vamp/phone/clerk
	exchange_num = 267

/obj/item/vamp/phone/clerk/Initialize()
	..()
	GLOB.clerknumber = number
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE

/obj/item/vamp/phone/barkeeper
	exchange_num = 485

/obj/item/vamp/phone/barkeeper/Initialize()
	..()
	GLOB.barkeepernumber = number
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/dealer/DEALER = new()
	contacts += DEALER

/obj/item/vamp/phone/dealer
	exchange_num = 485

/obj/item/vamp/phone/dealer/Initialize()
	..()
	GLOB.dealernumber = number
	var/datum/phonecontact/barkeeper/BARKEEPER = new()
	contacts += BARKEEPER

/obj/item/vamp/phone/camarilla
	exchange_num = 267

/obj/item/vamp/phone/camarilla/Initialize()
	..()
//	GLOB.dealernumber = number
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE

/obj/item/vamp/phone/anarch
	exchange_num = 485

/obj/item/vamp/phone/anarch/Initialize()
	..()
//	GLOB.dealernumber = number
	var/datum/phonecontact/barkeeper/BARKEEPER = new()
	contacts += BARKEEPER

/obj/item/vamp/phone/malkavian/Initialize()
	..()
	GLOB.malkaviannumber = number
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE

/obj/item/vamp/phone/nosferatu/Initialize()
	..()
	GLOB.nosferatunumber = number
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE

/obj/item/vamp/phone/toreador/Initialize()
	..()
	GLOB.toreadornumber = number
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE

/obj/item/vamp/phone/brujah/Initialize()
	..()
	GLOB.brujahnumber = number
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE

/obj/item/vamp/phone/ventrue/Initialize()
	..()
	GLOB.ventruenumber = number
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
