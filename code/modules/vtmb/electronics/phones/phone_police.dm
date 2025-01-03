/obj/item/vamp/device/police
	name = "\A police device"
	desc = "A device exclusive for the police force."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "phone_p"
	inhand_icon_state = "phone_p"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	item_flags = NOBLUDGEON
	flags_1 = HEAR_1
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	onflooricon = 'code/modules/wod13/onfloor.dmi'


	var/list/ABP_list = list()
	var/list/ABP_list_mine = list()


/obj/item/vamp/device/police/New()
	..()
	GLOB.police_devices_list += src


/obj/item/vamp/device/police/Destroy()
	GLOB.police_devices_list -= src
	..()

/obj/proc/FindUltimateOwner()
	while(src)
		if(isliving(src.loc))
			return src.loc
		src = src.loc
	return null



/obj/item/vamp/device/police/attack_self(mob/user)
	. = ..()

	var/mob/living/carbon/human/P = usr
	var/list/jobs = list("Police Officer", "Police Chief", "Police Sergeant","Federal Investigator")
	var/list/jobs_notify = list("Police Officer", "Police Chief", "Police Sergeant","Federal Investigator", "SWAT", "National Guard")


	if(P.job in jobs)
		var/list/options = list("Add an APB","Remove an APB","See Currents APB","See APB History","See Currents SWAT Hunts")
		var/option =  input(usr, "Select an option", "APB Option") as null|anything in options


		if(option == "Add an APB")
			var/criminal_name = input(user, "Write the name of the criminal", "ABP System")  as text|null
			if(criminal_name)
				criminal_name = sanitize_name(criminal_name)
				if(criminal_name in GLOB.APB_names)
					to_chat(usr, "<span class='warning'>[criminal_name] already exists in the APB list!</span>")
					return
				var/reason = input(user, "Write the reason of the APB:", "APB Reason")  as text|null
				if(reason)
					reason = sanitize(reason)
				else
					reason = "No reason provided"
				var/found = FALSE
				for(var/mob/living/carbon/human/H in GLOB.player_list)
					if(H)
						if(H.true_real_name == criminal_name)
							found = TRUE
							GLOB.APB_names += criminal_name
							GLOB.APB_reasons += reason
							ABP_list_mine += criminal_name

							GLOB.APB_names_history += criminal_name
							GLOB.APB_reasons_history += reason
							GLOB.APB_who_why_history += ("Added By [P.true_real_name], with the reason: [reason]")

							to_chat(usr, "<span class='notice'>The criminal has been added to the ABP list!.</span>")


							for(var/obj/DEVICE in GLOB.police_devices_list)
								if(istype(DEVICE, /obj/item/vamp/device/police))
									var/mob/living/carbon/human/L = DEVICE.FindUltimateOwner()
									if(L && L.job in jobs_notify)
										if(L != usr)
											to_chat(L, "<span class='notice'>[criminal_name] has been added to the APB list with the reason: [reason].</span>")

							H.APB = TRUE
							SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
							to_chat(H, "<span class='userdanger'><b>YOU ARE IN THE APB LIST!</b></span>")

							message_admins("[ADMIN_LOOKUPFLW(usr)] put an APB on [ADMIN_LOOKUPFLW(H)] with the reason [reason].")
							log_game("[key_name(P)] put an APB on [key_name(H)] with the reason [reason] ")
				if(!found)
					to_chat(usr, "<span class='warning'>The city has nobody with that name")


		if(option == "Remove an APB")
			if(ABP_list_mine.len == 0)
				to_chat(usr, "<span class='warning'>You have no APBs to remove!</span>")
				return
			var/name_to_remove = input(user, "Select an APB to remove:", "Remove APB") as null|anything in ABP_list_mine
			if(name_to_remove)
				var/reason_to_remove = input(user, "Write the reason of the removal", "Remove ABP Reason")  as text|null
				ABP_list_mine -= name_to_remove
				var/index = GLOB.APB_names.Find(name_to_remove)
				if(index)
					var/criminal_name = GLOB.APB_names[index]
					var/reason = (index <= GLOB.APB_reasons.len ? GLOB.APB_reasons[index] : "No reason provided")


					GLOB.APB_names -= criminal_name
					GLOB.APB_reasons -= reason

					GLOB.APB_names_history += criminal_name
					GLOB.APB_reasons_history += reason
					GLOB.APB_who_why_history += ("Removed By [P.true_real_name], with the reason: [reason_to_remove]")

					to_chat(usr, "<span class='notice'>[criminal_name] has been removed from the APB list! Reason: [reason_to_remove]</span>")

					for(var/obj/DEVICE in GLOB.police_devices_list)
						if(istype(DEVICE, /obj/item/vamp/device/police))
							var/mob/living/carbon/human/L = DEVICE.FindUltimateOwner()
							if(L && L.job in jobs_notify)
								if(L != usr)
									to_chat(L, "<span class='notice'>[criminal_name] has been removed from the APB list with the reason: [reason_to_remove].</span>")

					for(var/mob/living/carbon/human/H in GLOB.player_list)
						if(H)
							if(H.true_real_name == criminal_name)
								H.APB = FALSE
								to_chat(H, "<b>YOU ARE OUT OF THE APB LIST!!</b>")
								SEND_SOUND(H, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))

		if(option == "See Currents APB")
			if(GLOB.APB_names.len == 0)
				to_chat(usr, "<span class='warning'>There are no current APBs in the system!</span>")
				return

			var/text = "<b>Current APBs:</b><br>"
			for(var/i = 1, i <= GLOB.APB_names.len, i++)
				var/criminal_name = GLOB.APB_names[i]
				var/reason = (i <= GLOB.APB_reasons.len ? GLOB.APB_reasons[i] : "No reason provided")
				text += "[i]. <b>Criminal name: [criminal_name]</b> - Reason: [reason]<br>"

			to_chat(usr, text)

		if(option == "See APB History")
			if(GLOB.APB_names_history.len == 0)
				to_chat(usr, "<span class='warning'>There is no APB historic available!</span>")
				return

			var/text = "<b>APB History:</b><br>"
			for(var/i = 1, i <= GLOB.APB_names_history.len, i++)
				var/criminal_name = GLOB.APB_names_history[i]
				var/who_why = (i <= GLOB.APB_who_why_history.len ? GLOB.APB_who_why_history[i] : "No details available")
				text += "[i]. <b>[criminal_name]</b><br>&emsp;[who_why]<br>"

			to_chat(usr, text)

		if(option == "See Currents SWAT Hunts")
			if(GLOB.SWAT_names.len == 0)
				to_chat(usr, "<span class='warning'>There are no current SWAT Hunts in the system!</span>")
				return

			var/text = "<b>Current SWAT Hunts:</b><br>"
			for(var/i = 1, i <= GLOB.SWAT_names.len, i++)
				var/criminal_name = GLOB.SWAT_names[i]
				var/reason = (i <= GLOB.SWAT_reasons.len ? GLOB.SWAT_reasons[i] : "No reason provided")
				text += "[i]. <b>Criminal name: [criminal_name]</b> - Reason: [reason]<br>"

			to_chat(usr, text)

	else
		to_chat(usr, "<span class='warning'>You can't acess this device!</span>")



/obj/item/vamp/device/police/police_chief
	name = "\A police device for the police chief"
	desc = "A device exclusive for the police chief."

/obj/item/vamp/device/police/police_chief/attack_self(mob/user)

	var/mob/living/carbon/human/P = usr
	var/list/jobs = list("Police Chief")
	var/list/jobs_notify = list("Police Officer", "Police Chief", "Police Sergeant","Federal Investigator", "SWAT", "National Guard")

	if(P.job in jobs)
		var/list/options = list("Add an APB","Remove an APB","See Currents APB","See APB History", "Request the SWAT", "Call off the SWAT","See Currents SWAT Hunts" ,"See SWAT History")
		var/option =  input(usr, "Select an option", "APB Option") as null|anything in options


		if(option == "Add an APB")
			var/criminal_name = input(user, "Write the name of the criminal", "ABP System")  as text|null
			if(criminal_name)
				criminal_name = sanitize_name(criminal_name)
				if(criminal_name in GLOB.APB_names)
					to_chat(usr, "<span class='warning'>[criminal_name] already exists in the APB list!</span>")
					return
				var/reason = input(user, "Write the reason of the APB:", "APB Reason")  as text|null
				if(reason)
					reason = sanitize(reason)
				else
					reason = "No reason provided"
				var/found = FALSE
				for(var/mob/living/carbon/human/H in GLOB.player_list)
					if(H)
						if(H.true_real_name == criminal_name)
							found = TRUE
							GLOB.APB_names += criminal_name
							GLOB.APB_reasons += reason
							ABP_list_mine += criminal_name

							GLOB.APB_names_history += criminal_name
							GLOB.APB_reasons_history += reason
							GLOB.APB_who_why_history += ("Added By [P.true_real_name], with the reason: [reason]")

							to_chat(usr, "<span class='notice'>The criminal has been added to the ABP list!.</span>")

							for(var/obj/DEVICE in GLOB.police_devices_list)
								if(istype(DEVICE, /obj/item/vamp/device/police))
									var/mob/living/carbon/human/L = DEVICE.FindUltimateOwner()
									if(L && L.job in jobs_notify)
										if(L != usr)
											to_chat(L, "<span class='notice'>[criminal_name] has been added to the APB list with the reason: [reason].</span>")

							H.APB = TRUE
							SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
							to_chat(H, "<span class='userdanger'><b>YOU ARE IN THE APB LIST!</b></span>")

							message_admins("[ADMIN_LOOKUPFLW(usr)] put an APB on [ADMIN_LOOKUPFLW(H)] with the reason [reason].")
							log_game("[key_name(P)] put an APB on [key_name(H)] with the reason [reason] ")
				if(!found)
					to_chat(usr, "<span class='warning'>The city has nobody with that name")


		if(option == "Remove an APB")
			if(GLOB.APB_names.len == 0)
				to_chat(usr, "<span class='warning'>You have no APBs to remove!</span>")
				return
			var/name_to_remove = input(user, "Select an APB to remove:", "Remove APB") as null|anything in GLOB.APB_names
			if(name_to_remove)
				var/reason_to_remove = input(user, "Write the reason of the removal", "Remove ABP Reason")  as text|null
				ABP_list_mine -= name_to_remove
				var/index = GLOB.APB_names.Find(name_to_remove)
				if(index)
					var/criminal_name = GLOB.APB_names[index]
					var/reason = (index <= GLOB.APB_reasons.len ? GLOB.APB_reasons[index] : "No reason provided")


					GLOB.APB_names -= criminal_name
					GLOB.APB_reasons -= reason

					GLOB.APB_names_history += criminal_name
					GLOB.APB_reasons_history += reason
					GLOB.APB_who_why_history += ("Removed By [P.true_real_name], with the reason: [reason_to_remove]")

					to_chat(usr, "<span class='notice'>[criminal_name] has been removed from the APB list! Reason: [reason_to_remove]</span>")


					for(var/obj/DEVICE in GLOB.police_devices_list)
						if(istype(DEVICE, /obj/item/vamp/device/police))
							var/mob/living/carbon/human/L = DEVICE.FindUltimateOwner()
							if(L && L.job in jobs_notify)
								if(L != usr)
									to_chat(L, "<span class='notice'>[criminal_name] has been removed from the APB list with the reason: [reason_to_remove].</span>")

					for(var/mob/living/carbon/human/H in GLOB.player_list)
						if(H)
							if(H.true_real_name == criminal_name)
								H.APB = FALSE
								to_chat(H, "<b>YOU ARE OUT OF THE APB LIST!!</b>")
								SEND_SOUND(H, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))

		if(option == "See Currents APB")
			if(GLOB.APB_names.len == 0)
				to_chat(usr, "<span class='warning'>There are no current APBs in the system!</span>")
				return

			var/text = "<b>Current APBs:</b><br>"
			for(var/i = 1, i <= GLOB.APB_names.len, i++)
				var/criminal_name = GLOB.APB_names[i]
				var/reason = (i <= GLOB.APB_reasons.len ? GLOB.APB_reasons[i] : "No reason provided")
				text += "[i]. <b>Criminal name: [criminal_name]</b> - Reason: [reason]<br>"

			to_chat(usr, text)

		if(option == "See APB History")
			if(GLOB.APB_names_history.len == 0)
				to_chat(usr, "<span class='warning'>There is no APB historic available!</span>")
				return

			var/text = "<b>APB History:</b><br>"
			for(var/i = 1, i <= GLOB.APB_names_history.len, i++)
				var/criminal_name = GLOB.APB_names_history[i]
				var/who_why = (i <= GLOB.APB_who_why_history.len ? GLOB.APB_who_why_history[i] : "No details available")
				text += "[i]. <b>[criminal_name]</b><br>&emsp;[who_why]<br>"

			to_chat(usr, text)

		if(option == "Request the SWAT")
			var/criminal_name = input(user, "Write the name of the criminal", "SWAT System")  as text|null
			if(criminal_name)
				criminal_name = sanitize_name(criminal_name)
				if(criminal_name in GLOB.SWAT_names)
					to_chat(usr, "<span class='warning'>[criminal_name] already exists in the SWAT list!</span>")
					return
				var/reason = input(user, "Write the reason of the SWAT call:", "SWAT Reason")  as text|null
				if(reason)
					reason = sanitize(reason)
				else
					reason = "No reason provided"
				var/found = FALSE
				for(var/mob/living/carbon/human/H in GLOB.player_list)
					if(H)
						if(H.true_real_name == criminal_name)
							found = TRUE
							GLOB.SWAT_names += criminal_name
							GLOB.SWAT_reasons += reason

							GLOB.SWAT_names_history += criminal_name
							GLOB.SWAT_reasons_history += reason
							GLOB.SWAT_who_why_history += ("Added By [P.true_real_name], with the reason: [reason]")

							to_chat(usr, "<span class='notice'>The criminal has been added to the SWAT list!.</span>")


							for(var/obj/DEVICE in GLOB.police_devices_list)
								if(istype(DEVICE, /obj/item/vamp/device/police))
									var/mob/living/carbon/human/L = DEVICE.FindUltimateOwner()
									if(L && L.job in jobs_notify)
										if(L != usr)
											to_chat(L, "<span class='notice'>[criminal_name] has been added to the SWAT list with the reason: [reason].</span>")

							H.warrant = TRUE
							SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
							to_chat(H, "<span class='userdanger'><b>YOU ARE BEING HUNTED BY THE SWAT!</b></span>")

							message_admins("[ADMIN_LOOKUPFLW(usr)] has called the SWAT on [ADMIN_LOOKUPFLW(H)] with the reason [reason].")
							log_game("[key_name(P)] has called the SWAT on [key_name(H)] with the reason [reason] ")
				if(!found)
					to_chat(usr, "<span class='warning'>The city has nobody with that name")


		if(option == "Call off the SWAT")
			if(GLOB.SWAT_names.len == 0)
				to_chat(usr, "<span class='warning'>You have no SWAT calls to remove!</span>")
				return
			var/name_to_remove = input(user, "Select an SWAT call to remove:", "Remove SWAT call") as null|anything in GLOB.SWAT_names
			if(name_to_remove)
				var/reason_to_remove = input(user, "Write the reason of the removal", "Remove SWAT Reason")  as text|null
				var/index = GLOB.SWAT_names.Find(name_to_remove)
				if(index)
					var/criminal_name = GLOB.SWAT_names[index]
					var/reason = (index <= GLOB.SWAT_reasons.len ? GLOB.SWAT_reasons[index] : "No reason provided")


					GLOB.SWAT_names -= criminal_name
					GLOB.SWAT_reasons -= reason

					GLOB.SWAT_names_history += criminal_name
					GLOB.SWAT_reasons_history += reason
					GLOB.SWAT_who_why_history += ("Removed By [P.true_real_name], with the reason: [reason_to_remove]")

					to_chat(usr, "<span class='notice'>[criminal_name] has been removed from the SWAT list! Reason: [reason_to_remove]</span>")



					for(var/obj/DEVICE in GLOB.police_devices_list)
						if(istype(DEVICE, /obj/item/vamp/device/police))
							var/mob/living/carbon/human/L = DEVICE.FindUltimateOwner()
							if(L && L.job in jobs_notify)
								if(L != usr)
									to_chat(L, "<span class='notice'>[criminal_name] has been removed from the SWAT list with the reason: [reason_to_remove].</span>")

					for(var/mob/living/carbon/human/H in GLOB.player_list)
						if(H)
							if(H.true_real_name == criminal_name)
								H.warrant = FALSE
								to_chat(H, "<b>YOU ARE NOT BEING HUNTED BY THE SWAT ANYMORE!</b>")
								SEND_SOUND(H, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))

		if(option == "See Currents SWAT Hunts")
			if(GLOB.SWAT_names.len == 0)
				to_chat(usr, "<span class='warning'>There are no current SWAT Hunts in the system!</span>")
				return

			var/text = "<b>Current SWAT Hunts:</b><br>"
			for(var/i = 1, i <= GLOB.SWAT_names.len, i++)
				var/criminal_name = GLOB.SWAT_names[i]
				var/reason = (i <= GLOB.SWAT_reasons.len ? GLOB.SWAT_reasons[i] : "No reason provided")
				text += "[i]. <b>Criminal name: [criminal_name]</b> - Reason: [reason]<br>"

			to_chat(usr, text)


		if(option == "See SWAT History")
			if(GLOB.SWAT_names_history.len == 0)
				to_chat(usr, "<span class='warning'>There is no SWAT historic available!</span>")
				return

			var/text = "<b>SWAT History:</b><br>"
			for(var/i = 1, i <= GLOB.SWAT_names_history.len, i++)
				var/criminal_name = GLOB.SWAT_names_history[i]
				var/who_why = (i <= GLOB.SWAT_who_why_history.len ? GLOB.SWAT_who_why_history[i] : "No details available")
				text += "[i]. <b>[criminal_name]</b><br>&emsp;[who_why]<br>"

			to_chat(usr, text)

	else
		to_chat(usr, "<span class='warning'>You can't acess this device!</span>")



/obj/item/vamp/device/police/fbi
	name = "\A device for the FBI Agents"
	desc = "A device exclusive for the FBI Agents."


/obj/item/vamp/device/police/fbi/attack_self(mob/user)

	var/mob/living/carbon/human/P = usr
	var/list/jobs = list("Federal Investigator")
	var/list/jobs_notify = list("Police Officer", "Police Chief", "Police Sergeant","Federal Investigator", "SWAT", "National Guard")

	if(P.job in jobs)
		var/list/options = list("Add an APB","Remove an APB","See Currents APB","See APB History", "See Currents SWAT Hunts"  ,"See SWAT History","Request the National Guard")
		var/option =  input(usr, "Select an option", "APB Option") as null|anything in options


		if(option == "Add an APB")
			var/criminal_name = input(user, "Write the name of the criminal", "ABP System")  as text|null
			if(criminal_name)
				criminal_name = sanitize_name(criminal_name)
				if(criminal_name in GLOB.APB_names)
					to_chat(usr, "<span class='warning'>[criminal_name] already exists in the APB list!</span>")
					return
				var/reason = input(user, "Write the reason of the APB:", "APB Reason")  as text|null
				if(reason)
					reason = sanitize(reason)
				else
					reason = "No reason provided"
				var/found = FALSE
				for(var/mob/living/carbon/human/H in GLOB.player_list)
					if(H)
						if(H.true_real_name == criminal_name)
							found = TRUE
							GLOB.APB_names += criminal_name
							GLOB.APB_reasons += reason
							ABP_list_mine += criminal_name

							GLOB.APB_names_history += criminal_name
							GLOB.APB_reasons_history += reason
							GLOB.APB_who_why_history += ("Added By [P.true_real_name], with the reason: [reason]")

							to_chat(usr, "<span class='notice'>The criminal has been added to the ABP list!.</span>")

							for(var/obj/DEVICE in GLOB.police_devices_list)
								if(istype(DEVICE, /obj/item/vamp/device/police))
									var/mob/living/carbon/human/L = DEVICE.FindUltimateOwner()
									if(L && L.job in jobs_notify)
										if(L != usr)
											to_chat(L, "<span class='notice'>[criminal_name] has been added to the APB list with the reason: [reason].</span>")

							H.APB = TRUE
							SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
							to_chat(H, "<span class='userdanger'><b>YOU ARE IN THE APB LIST!</b></span>")

							message_admins("[ADMIN_LOOKUPFLW(usr)] put an APB on [ADMIN_LOOKUPFLW(H)]  with the reason [reason].")
							log_game("[key_name(P)] put an APB on [key_name(H)] with the reason [reason] ")
				if(!found)
					to_chat(usr, "<span class='warning'>The city has nobody with that name")


		if(option == "Remove an APB")
			if(GLOB.APB_names.len == 0)
				to_chat(usr, "<span class='warning'>You have no APBs to remove!</span>")
				return
			var/name_to_remove = input(user, "Select an APB to remove:", "Remove APB") as null|anything in GLOB.APB_names
			if(name_to_remove)
				var/reason_to_remove = input(user, "Write the reason of the removal", "Remove ABP Reason")  as text|null
				ABP_list_mine -= name_to_remove
				var/index = GLOB.APB_names.Find(name_to_remove)
				if(index)
					var/criminal_name = GLOB.APB_names[index]
					var/reason = (index <= GLOB.APB_reasons.len ? GLOB.APB_reasons[index] : "No reason provided")


					GLOB.APB_names -= criminal_name
					GLOB.APB_reasons -= reason

					GLOB.APB_names_history += criminal_name
					GLOB.APB_reasons_history += reason
					GLOB.APB_who_why_history += ("Removed By [P.true_real_name], with the reason: [reason_to_remove]")

					to_chat(usr, "<span class='notice'>[criminal_name] has been removed from the APB list! Reason: [reason_to_remove]</span>")


					for(var/obj/DEVICE in GLOB.police_devices_list)
						if(istype(DEVICE, /obj/item/vamp/device/police))
							var/mob/living/carbon/human/L = DEVICE.FindUltimateOwner()
							if(L && L.job in jobs_notify)
								if(L != usr)
									to_chat(L, "<span class='notice'>[criminal_name] has been removed from the APB list with the reason: [reason_to_remove].</span>")

					for(var/mob/living/carbon/human/H in GLOB.player_list)
						if(H)
							if(H.true_real_name == criminal_name)
								H.APB = FALSE
								to_chat(H, "<b>YOU ARE OUT OF THE APB LIST!!</b>")
								SEND_SOUND(H, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))

		if(option == "See Currents APB")
			if(GLOB.APB_names.len == 0)
				to_chat(usr, "<span class='warning'>There are no current APBs in the system!</span>")
				return

			var/text = "<b>Current APBs:</b><br>"
			for(var/i = 1, i <= GLOB.APB_names.len, i++)
				var/criminal_name = GLOB.APB_names[i]
				var/reason = (i <= GLOB.APB_reasons.len ? GLOB.APB_reasons[i] : "No reason provided")
				text += "[i]. <b>Criminal name: [criminal_name]</b> - Reason: [reason]<br>"

			to_chat(usr, text)

		if(option == "See APB History")
			if(GLOB.APB_names_history.len == 0)
				to_chat(usr, "<span class='warning'>There is no APB history available!</span>")
				return

			var/text = "<b>APB History:</b><br>"
			for(var/i = 1, i <= GLOB.APB_names_history.len, i++)
				var/criminal_name = GLOB.APB_names_history[i]
				var/who_why = (i <= GLOB.APB_who_why_history.len ? GLOB.APB_who_why_history[i] : "No details available")
				text += "[i]. <b>[criminal_name]</b><br>&emsp;[who_why]<br>"

			to_chat(usr, text)


		if(option == "See Currents SWAT Hunts")
			if(GLOB.SWAT_names.len == 0)
				to_chat(usr, "<span class='warning'>There are no current SWAT Hunts in the system!</span>")
				return

			var/text = "<b>Current SWAT Hunts:</b><br>"
			for(var/i = 1, i <= GLOB.SWAT_names.len, i++)
				var/criminal_name = GLOB.SWAT_names[i]
				var/reason = (i <= GLOB.SWAT_reasons.len ? GLOB.SWAT_reasons[i] : "No reason provided")
				text += "[i]. <b>Criminal name: [criminal_name]</b> - Reason: [reason]<br>"

			to_chat(usr, text)

		if(option == "See SWAT History")
			if(GLOB.SWAT_names_history.len == 0)
				to_chat(usr, "<span class='warning'>There is no SWAT history available!</span>")
				return

			var/text = "<b>SWAT History:</b><br>"
			for(var/i = 1, i <= GLOB.SWAT_names_history.len, i++)
				var/criminal_name = GLOB.SWAT_names_history[i]
				var/who_why = (i <= GLOB.SWAT_who_why_history.len ? GLOB.SWAT_who_why_history[i] : "No details available")
				text += "[i]. <b>[criminal_name]</b><br>&emsp;[who_why]<br>"

			to_chat(usr, text)

		if(option == "Request the National Guard")
			var/reason = input(user, "Why should your superiors send the National Guard?", "Request System")  as text|null

			message_admins("[ADMIN_LOOKUPFLW(usr)] requested the National Guard with the reason: [reason].")
			log_game("[key_name(P)] requested the National Guard with the reason [reason] ")


	else
		to_chat(usr, "<span class='warning'>You can't acess this device!</span>")


//Use this for the admin  police spawns

/obj/item/vamp/device/police/admin_spawn
	name = "\A police device for the "
	desc = "A device exclusive for the "

/obj/item/vamp/device/police/admin_spawn/attack_self(mob/user)

	var/mob/living/carbon/human/P = usr
	var/list/jobs = list("SWAT", "National Guard")
	var/list/jobs_notify = list("Police Officer", "Police Chief", "Police Sergeant","Federal Investigator", "SWAT", "National Guard")

	if(P.job in jobs)
		var/list/options = list("Add an APB","Remove an APB","See Currents APB","See APB History" ,"See Currents SWAT Hunts","See SWAT History", "Report to your superiors")
		var/option =  input(usr, "Select an option", "APB Option") as null|anything in options


		if(option == "Add an APB")
			var/criminal_name = input(user, "Write the name of the criminal", "ABP System")  as text|null
			if(criminal_name)
				criminal_name = sanitize_name(criminal_name)
				if(criminal_name in GLOB.APB_names)
					to_chat(usr, "<span class='warning'>[criminal_name] already exists in the APB list!</span>")
					return
				var/reason = input(user, "Write the reason of the APB:", "APB Reason")  as text|null
				if(reason)
					reason = sanitize(reason)
				else
					reason = "No reason provided"
				var/found = FALSE
				for(var/mob/living/carbon/human/H in GLOB.player_list)
					if(H)
						if(H.true_real_name == criminal_name)
							found = TRUE
							GLOB.APB_names += criminal_name
							GLOB.APB_reasons += reason
							ABP_list_mine += criminal_name

							GLOB.APB_names_history += criminal_name
							GLOB.APB_reasons_history += reason
							GLOB.APB_who_why_history += ("Added By [P.true_real_name], with the reason: [reason]")

							to_chat(usr, "<span class='notice'>The criminal has been added to the ABP list!.</span>")

							for(var/obj/DEVICE in GLOB.police_devices_list)
								if(istype(DEVICE, /obj/item/vamp/device/police))
									var/mob/living/carbon/human/L = DEVICE.FindUltimateOwner()
									if(L && L.job in jobs_notify)
										if(L != usr)
											to_chat(L, "<span class='notice'>[criminal_name] has been added to the APB list with the reason: [reason].</span>")

							H.APB = TRUE
							SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
							to_chat(H, "<span class='userdanger'><b>YOU ARE IN THE APB LIST!</b></span>")

							message_admins("[ADMIN_LOOKUPFLW(usr)] put an APB on [ADMIN_LOOKUPFLW(H)]  with the reason [reason].")
							log_game("[key_name(P)] put an APB on [key_name(H)] with the reason [reason] ")
				if(!found)
					to_chat(usr, "<span class='warning'>The city has nobody with that name")


		if(option == "Remove an APB")
			if(GLOB.APB_names.len == 0)
				to_chat(usr, "<span class='warning'>You have no APBs to remove!</span>")
				return
			var/name_to_remove = input(user, "Select an APB to remove:", "Remove APB") as null|anything in GLOB.APB_names
			if(name_to_remove)
				var/reason_to_remove = input(user, "Write the reason of the removal", "Remove ABP Reason")  as text|null
				ABP_list_mine -= name_to_remove
				var/index = GLOB.APB_names.Find(name_to_remove)
				if(index)
					var/criminal_name = GLOB.APB_names[index]
					var/reason = (index <= GLOB.APB_reasons.len ? GLOB.APB_reasons[index] : "No reason provided")


					GLOB.APB_names -= criminal_name
					GLOB.APB_reasons -= reason

					GLOB.APB_names_history += criminal_name
					GLOB.APB_reasons_history += reason
					GLOB.APB_who_why_history += ("Removed By [P.true_real_name], with the reason: [reason_to_remove]")

					to_chat(usr, "<span class='notice'>[criminal_name] has been removed from the APB list! Reason: [reason_to_remove]</span>")


					for(var/obj/DEVICE in GLOB.police_devices_list)
						if(istype(DEVICE, /obj/item/vamp/device/police))
							var/mob/living/carbon/human/L = DEVICE.FindUltimateOwner()
							if(L && L.job in jobs_notify)
								if(L != usr)
									to_chat(L, "<span class='notice'>[criminal_name] has been removed from the APB list with the reason: [reason_to_remove].</span>")

					for(var/mob/living/carbon/human/H in GLOB.player_list)
						if(H)
							if(H.true_real_name == criminal_name)
								H.APB = FALSE
								to_chat(H, "<b>YOU ARE OUT OF THE APB LIST!!</b>")
								SEND_SOUND(H, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))

		if(option == "See Currents APB")
			if(GLOB.APB_names.len == 0)
				to_chat(usr, "<span class='warning'>There are no current APBs in the system!</span>")
				return

			var/text = "<b>Current APBs:</b><br>"
			for(var/i = 1, i <= GLOB.APB_names.len, i++)
				var/criminal_name = GLOB.APB_names[i]
				var/reason = (i <= GLOB.APB_reasons.len ? GLOB.APB_reasons[i] : "No reason provided")
				text += "[i]. <b>Criminal name: [criminal_name]</b> - Reason: [reason]<br>"

			to_chat(usr, text)

		if(option == "See APB History")
			if(GLOB.APB_names_history.len == 0)
				to_chat(usr, "<span class='warning'>There is no APB history available!</span>")
				return

			var/text = "<b>APB History:</b><br>"
			for(var/i = 1, i <= GLOB.APB_names_history.len, i++)
				var/criminal_name = GLOB.APB_names_history[i]
				var/who_why = (i <= GLOB.APB_who_why_history.len ? GLOB.APB_who_why_history[i] : "No details available")
				text += "[i]. <b>[criminal_name]</b><br>&emsp;[who_why]<br>"

			to_chat(usr, text)

		if(option == "See Currents SWAT Hunts")
			if(GLOB.SWAT_names.len == 0)
				to_chat(usr, "<span class='warning'>There are no current SWAT Hunts in the system!</span>")
				return

			var/text = "<b>Current SWAT Hunts:</b><br>"
			for(var/i = 1, i <= GLOB.SWAT_names.len, i++)
				var/criminal_name = GLOB.SWAT_names[i]
				var/reason = (i <= GLOB.SWAT_reasons.len ? GLOB.SWAT_reasons[i] : "No reason provided")
				text += "[i]. <b>Criminal name: [criminal_name]</b> - Reason: [reason]<br>"

			to_chat(usr, text)

		if(option == "See SWAT History")
			if(GLOB.SWAT_names_history.len == 0)
				to_chat(usr, "<span class='warning'>There is no SWAT history available!</span>")
				return

			var/text = "<b>SWAT History:</b><br>"
			for(var/i = 1, i <= GLOB.SWAT_names_history.len, i++)
				var/criminal_name = GLOB.SWAT_names_history[i]
				var/who_why = (i <= GLOB.SWAT_who_why_history.len ? GLOB.SWAT_who_why_history[i] : "No details available")
				text += "[i]. <b>[criminal_name]</b><br>&emsp;[who_why]<br>"
			to_chat(usr, text)

		if(option == "Report to your superiors")
			var/report = input(user, "What do you wish to report?", "Report System")  as text|null

			message_admins("[ADMIN_LOOKUPFLW(usr)] reported to his superiors, report: [report].")
			log_game("[key_name(P)] reported to their superiors, report: [report]. ")


	else
		to_chat(usr, "<span class='warning'>You can't acess this device!</span>")



/obj/item/vamp/device/police/admin_spawn/swat
	name = "\A police device for the Special Weapons and Tactics Forces "
	desc = "A device exclusive for the Special Weapons and Tactics Forces "


/obj/item/vamp/device/police/admin_spawn/national_guard
	name = "\A police device for the National Guard "
	desc = "A device exclusive for the National Guard "



