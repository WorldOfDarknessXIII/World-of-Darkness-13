GLOBAL_LIST_EMPTY(vampire_computers)

/obj/vampire_computer
	name = "computer"
	desc = "See the Internet."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "computer"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/main = FALSE
	var/datum/app/current_app
	var/datum/app/focus_app
	var/list/datum/app/apps = list()
	var/owner = "none"
	var/logged = FALSE
	var/x_pos = 0
	var/y_pos = 0
	var/password
	var/username


/obj/vampire_computer/Initialize()
	. = ..()
	GLOB.vampire_computers += src
	username = gen_username()
	password = gen_pass()
	var/obj/item/paper/password_paper = new (loc)
	password_paper.name = "don't forget your password!"
	password_paper.info = "<center><h2>Hello, [username]!</h2></center><br>I have to remind you about it again, but please don't forget your password - <b>[password]</b>"
	var/datum/app/icq/icq = new ()
	var/datum/app/notepad/notepad = new ()
	var/datum/app/gmail/gmail = new ()
	var/datum/app/news/news = new ()

	gmail.generate_email()
	if(main)
		news.can_send = TRUE
	// Отправка почты на комп принца от всех, у кого owner это не none, а, например, regent
	apps.Add(icq)
	apps.Add(notepad)
	apps.Add(gmail)
	apps.Add(news)

	for(var/obj/vampire_computer/C in GLOB.vampire_computers)
		if(C.main)
			if(owner != "none")
				var/datum/app/gmail/main_gmail = C.apps[3]
				main_gmail.send_email("Hello! This message is from [owner]'s computer.", "Hello!", gmail.email_adress)

/obj/vampire_computer/attack_hand(mob/user)
	. = ..()
	ui_interact(user)

/obj/vampire_computer/Destroy()
	. = ..()
	GLOB.vampire_computers -= src

/obj/vampire_computer/prince
	icon_state = "computerprince"
	main = TRUE

/obj/vampire_computer/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("set_notepad_text")
			var/datum/app/notepad/app = locate(params["ref"]) in apps
			app.text = params["text"]
			return TRUE
		if("set_current_app")
			current_app = locate(params["ref"]) in apps
			current_app.minimized = FALSE
			return TRUE
		if("set_focus_app")
			var/datum/app/app = locate(params["ref"]) in apps
			focus_app = app
			return TRUE
		if("launch_app")
			var/datum/app/app = locate(params["ref"]) in apps
			if(!app.launched)
				app.launched = TRUE
			else
				app.minimized = FALSE
			current_app = app
			focus_app = null
			if(istype(app, /datum/app/news) && icon_state == "computermessage")
				icon_state = initial(icon_state)
			return TRUE
		if("close")
			var/datum/app/app = locate(params["ref"]) in apps
			app.launched = FALSE
			if(!app.desktop_app)
				apps.Remove(app)
			return TRUE
		if("minimize")
			var/datum/app/app = locate(params["ref"]) in apps
			if(app.minimized)
				app.minimized = FALSE
			else
				app.minimized = TRUE
			current_app = null
			return TRUE
		if("set_app_cords")
			var/datum/app/app = locate(params["ref"]) in apps
			app.x = set_cords(params["rel_x"], 1185, 0)
			app.y = set_cords(params["rel_y"], 600, 0)
			return TRUE
		if("send_message")
			if(params["message"] != "" && params["message"])
				var/datum/app/icq/app = locate(params["ref"]) in apps
				app.SendMessage(params["message"])
				return TRUE
		if("icq_login_user")
			if(params["username"] != "" && params["username"])
				for(var/obj/vampire_computer/C in GLOB.vampire_computers)
					var/datum/app/icq/icq = C.apps[1]
					if(icq.username == params["username"])
						throw_error("This name is already exists!")
						return TRUE
				var/datum/app/icq/app = locate(params["ref"]) in apps
				app.username = params["username"]
				return TRUE
		if("set_email_check")
			var/datum/app/gmail/gmail = apps[3]
			var/datum/email/email = locate(params["ref"]) in gmail.emails
			if(!email.checked)
				email.checked = TRUE
			else
				email.checked = FALSE
			return TRUE
		if("set_email_star")
			var/datum/app/gmail/gmail = apps[3]
			var/datum/email/email = locate(params["ref"]) in gmail.emails
			if(!email.stared)
				email.stared = TRUE
			else
				email.stared = FALSE
			return TRUE
		if("select_all_emails")
			var/datum/app/gmail/gmail = apps[3]
			for(var/datum/email/email in gmail.emails)
				email.checked = TRUE
			return TRUE
		if("deselect_all_emails")
			var/datum/app/gmail/gmail = apps[3]
			for(var/datum/email/email in gmail.emails)
				email.checked = FALSE
			return TRUE
		if("delete_emails")
			var/datum/app/gmail/gmail = apps[3]
			for(var/datum/email/email in gmail.emails)
				if(email.checked)
					gmail.emails.Remove(email)
			return TRUE
		if("gmail_switch_screen")
			var/datum/app/gmail/gmail = apps[3]
			gmail.screen = params["screen"]
			return TRUE
		if("set_current_email")
			var/datum/app/gmail/gmail = apps[3]
			gmail.current_email = locate(params["ref"]) in gmail.emails
			return TRUE
		if("news_send_message")
			if(params["message"] != "" && params["message"])
				for(var/obj/vampire_computer/C in GLOB.vampire_computers)
					var/datum/app/news/news = C.apps[4]
					var/message = trim(copytext_char(sanitize(params["message"]), 1, MAX_MESSAGE_LEN))
					news.text = message
					message_admins("[key_name(usr)] sent an announcement:\"- [message]\"")
					if(!C.main)
						C.say("New announcement from Prince!")
						C.icon_state = "computermessage"
					else
						C.say("Announcement sent.")
				for(var/obj/item/vamp/phone/P in GLOB.phones_list)
					P.say("New announcement!")
			return TRUE
		if("delete_email")
			var/datum/app/gmail/gmail = apps[3]
			var/datum/email/email = locate(params["ref"]) in gmail.emails
			gmail.emails.Remove(email)
			gmail.screen = 1
			return TRUE
		if("gmail_send_email")
			var/datum/app/gmail/gmail = apps[3]
			if(!params["message"])
				throw_error("You must write a message!")
				return TRUE
			else if(!params["subject"])
				throw_error("You must write a subject!")
				return TRUE
			else if(!params["to"])
				throw_error("You must write a reciever adress!")
				return TRUE
			var/sended = gmail.send_email(params["message"], params["subject"], params["to"])
			if(!sended)
				throw_error("This email is not exists!")
			return TRUE
		if("login")
			if(params["username"] == username && params["password"] == password)
				playsound(loc, 'sound/winxp/startup.wav', 100)
				logged = TRUE
				return TRUE
			else
				playsound(loc, 'sound/winxp/error.wav', 100)
				return TRUE

/obj/vampire_computer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WindowsXP", "WindowsXP")
		ui.open()

/obj/vampire_computer/proc/throw_error(error)
	playsound(loc, 'sound/winxp/error.wav', 100)
	var/datum/app/error/error_app = new ()
	error_app.error_message = error
	error_app.launched = TRUE
	current_app = error_app
	apps.Add(error_app)

/obj/vampire_computer/proc/set_cords(cord, max, min)
	if(cord < max && cord > min)
		return cord
	else if(cord > max)
		return max
	else if(cord < min)
		return min


/obj/vampire_computer/ui_data(mob/user)
	var/list/data = list()
	var/list/data_apps = list()

	for(var/datum/app/app in apps)
		var/list/app_data = app.data()
		app_data["reference"] =REF(app)
		data_apps += list(app_data)

	data["apps"] = data_apps
	data["current_app"] = 0
	if(current_app)
		data["current_app"] = REF(current_app)

	data["focus_ref"] = REF(focus_app)
	data["logged"] = logged
	data["password"] = password
	data["x"] = x_pos
	data["y"] = y_pos
	return data

/obj/vampire_computer/proc/gen_username()
	var/name = pick(GLOB.first_names_male + GLOB.first_names_female)
	name += pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	name += pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	return name

/obj/vampire_computer/proc/gen_pass()
	var/newPass
	newPass += pick("the", "if", "of", "as", "in", "a", "you", "from", "to", "an", "too", "little", "snow", "dead", "drunk", "rosebud", "duck", "al", "le")
	newPass += pick("diamond", "beer", "mushroom", "assistant", "clown", "captain", "twinkie", "security", "nuke", "small", "big", "escape", "yellow", "gloves", "monkey", "engine", "nuclear", "ai")
	newPass += pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	return newPass
