///Used in set_typing_indicator()
GLOBAL_LIST_EMPTY(typing_indicator)

//Say verb
/mob/verb/say_verb()
	set name = "Say"
	set category = "IC"

	// This is to avoid multiple instancing
	set_typing_indicator(FALSE)
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	set_typing_indicator(TRUE)
	var/message = input("What are you trying to say?") as text|null
	set_typing_indicator(FALSE)

	if(!message || message_max_length_check(message))
		return

	say(message)

//Whisper verb
/mob/verb/whisper_verb()
	set name = "Whisper"
	set category = "IC"

	set_typing_indicator(FALSE)
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	set_typing_indicator(TRUE)
	var/message = input("What are you trying to whisper?") as text|null
	set_typing_indicator(FALSE)

	if(!message || message_max_length_check(message))
		return

	whisper(message)

/mob/proc/whisper(message, datum/language/language=null)
	say(message, language) //only living mobs actually whisper, everything else just talks

//The me emote verb
/mob/verb/me_verb()
	set name = "Me"
	set category = "IC"

	set_typing_indicator(FALSE, TRUE)
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	set_typing_indicator(TRUE, TRUE)
	var/message = input("What are you trying to emote?") as text|null
	set_typing_indicator(FALSE, TRUE)

	if(!message || message_max_length_check(message))
		return
	message = message_clean(message)

	usr.emote("me", 1, message, TRUE)

/mob/proc/message_max_length_check(message)
	if(length(message) > MAX_BROADCAST_LEN && client)
		to_chat(src, span_warning("Your message was too long to be sent. The message:<br>[message]"))
		return TRUE

/mob/living/verb/flavor_verb()
	set name = "Flavor Text"
	set category = "IC"
	var/flavor = input("Choose your new flavor text:") as text|null
	if(flavor)
		flavor_text = trim(copytext_char(sanitize(flavor), 1, 512))

///Speak as a dead person (ghost etc)
/mob/proc/say_dead(message)
	var/name = real_name
	var/alt_name = ""

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	var/jb = is_banned_from(ckey, "Deadchat")
	if(QDELETED(src))
		return

	if(jb)
		to_chat(src, "<span class='danger'>You have been banned from deadchat.</span>")
		return

	if (src.client)
		if(src.client.prefs.muted & MUTE_DEADCHAT)
			to_chat(src, "<span class='danger'>You cannot talk in deadchat (muted).</span>")
			return

		if(src.client.handle_spam_prevention(message,MUTE_DEADCHAT))
			return

	var/mob/dead/observer/O = src
	if(isobserver(src) && O.auspex_ghosted) //[Lucifernix] - Makes it so you can't talk to ghosts in auspex
		return
	if(isobserver(src) && O.deadchat_name)
		name = "[O.deadchat_name]"
	else
		if(mind?.name)
			name = "[mind.name]"
		else
			name = real_name
		if(name != real_name)
			alt_name = " (died as [real_name])"

	var/spanned = say_quote(message)
	var/source = "<span class='game'><span class='name'>[name]</span>[alt_name]" //<span class='prefix'>DEAD:</span> [ChillRaccoon] - removed due to a maggot developer
	var/rendered = " <span class='message'>[emoji_parse(spanned)]</span></span>"
	log_talk(message, LOG_SAY, tag="DEAD")
	if(SEND_SIGNAL(src, COMSIG_MOB_DEADSAY, message) & MOB_DEADSAY_SIGNAL_INTERCEPT)
		return
	var/displayed_key = key
	if(client?.holder?.fakekey)
		displayed_key = null
	deadchat_broadcast(rendered, source, follow_target = src, speaker_key = displayed_key)

///Check if this message is an emote
/mob/proc/check_emote(message, forced)
	if(message[1] == "*")
		emote(copytext(message, length(message[1]) + 1), intentional = !forced)
		return TRUE

///Check if the mob has a hivemind channel
/mob/proc/hivecheck()
	return FALSE

///The amount of items we are looking for in the message
#define MESSAGE_MODS_LENGTH 6
/**
 * Extracts and cleans message of any extenstions at the begining of the message
 * Inserts the info into the passed list, returns the cleaned message
 *
 * Result can be
 * * SAY_MODE (Things like aliens, channels that aren't channels)
 * * MODE_WHISPER (Quiet speech)
 * * MODE_SING (Singing)
 * * MODE_HEADSET (Common radio channel)
 * * RADIO_EXTENSION the extension we're using (lots of values here)
 * * RADIO_KEY the radio key we're using, to make some things easier later (lots of values here)
 * * LANGUAGE_EXTENSION the language we're trying to use (lots of values here)
 */
/mob/proc/get_message_mods(message, list/mods)
	for(var/I in 1 to MESSAGE_MODS_LENGTH)
		// Prevents "...text" from being read as a radio message
		if (length(message) > 1 && message[2] == message[1])
			continue

		var/key = message[1]
		var/chop_to = 2 //By default we just take off the first char
		if(key == "#" && !mods[WHISPER_MODE])
			mods[WHISPER_MODE] = MODE_WHISPER
		else if(key == "%" && !mods[MODE_SING])
			mods[MODE_SING] = TRUE
		else if(key == ";" && !mods[MODE_HEADSET])
			if(stat == CONSCIOUS) //necessary indentation so it gets stripped of the semicolon anyway.
				mods[MODE_HEADSET] = TRUE
		else if((key in GLOB.department_radio_prefixes) && length(message) > length(key) + 1 && !mods[RADIO_EXTENSION])
			mods[RADIO_KEY] = lowertext(message[1 + length(key)])
			mods[RADIO_EXTENSION] = GLOB.department_radio_keys[mods[RADIO_KEY]]
			chop_to = length(key) + 2
		else if(key == "," && !mods[LANGUAGE_EXTENSION])
			for(var/ld in GLOB.all_languages)
				var/datum/language/LD = ld
				if(initial(LD.key) == message[1 + length(message[1])])
					// No, you cannot speak in xenocommon just because you know the key
					if(!can_speak_language(LD))
						return message
					mods[LANGUAGE_EXTENSION] = LD
					chop_to = length(key) + length(initial(LD.key)) + 1
			if(!mods[LANGUAGE_EXTENSION])
				return message
		else
			return message
		message = trim_left(copytext_char(message, chop_to))
		if(!message)
			return
	return message

/mob/proc/set_typing_indicator(state, me)
	if(!GLOB.typing_indicator[bubble_icon])
		GLOB.typing_indicator[bubble_icon] = image('icons/mob/talk.dmi', null, "[bubble_icon]0", ABOVE_HUD_LAYER)
		var/image/I = GLOB.typing_indicator[bubble_icon]
		I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	// Don't try to pop a bubble if we are mute
	if(ishuman(src) && !me)
		var/mob/living/carbon/human/H = src
		if(HAS_TRAIT(H, TRAIT_MUTE))
			overlays -= GLOB.typing_indicator[bubble_icon]
			typing = FALSE
			return FALSE

	// TODO: this will need to be adjusted to NPCs in another PR
	if(!client)
		return FALSE

	if(stat != CONSCIOUS || is_muzzled())
		overlays -= GLOB.typing_indicator[bubble_icon]
		typing = FALSE
		return FALSE

	if(state && !typing)
		overlays += GLOB.typing_indicator[bubble_icon]
		typing = TRUE

	if(!state && typing)
		overlays -= GLOB.typing_indicator[bubble_icon]
		typing = FALSE

	return state

/mob/proc/speech_ending_bubble(bubble_state = "", bubble_loc = src, list/bubble_recipients = list())
	var/image/speech_bubble = image('icons/mob/talk.dmi', bubble_loc, bubble_state, FLY_LAYER)
	speech_bubble.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay), speech_bubble, bubble_recipients, 2 SECONDS)
