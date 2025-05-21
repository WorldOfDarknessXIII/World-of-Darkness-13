/datum/vampire_clan/malkavian
	name = "Malkavian"
	desc = "Derided as Lunatics by other vampires, the Blood of the Malkavians lets them perceive and foretell truths hidden from others. Like the �wise madmen� of poetry their fractured perspective stems from seeing too much of the world at once, from understanding too deeply, and feeling emotions that are just too strong to bear."
	curse = "Insanity."
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/dementation,
		/datum/discipline/obfuscate
	)
	male_clothes = /obj/item/clothing/under/vampire/malkavian
	female_clothes = /obj/item/clothing/under/vampire/malkavian/female
	clan_keys = /obj/item/vamp/keys/malkav

	var/list/mob/living/madness_network

/datum/vampire_clan/malkavian/on_gain(mob/living/carbon/human/vampire)
	. = ..()

	var/datum/action/cooldown/malk_hivemind/hivemind = new()
	var/datum/action/cooldown/malk_speech/malk_font = new()
	hivemind.Grant(vampire)
	malk_font.Grant(vampire)

	// Madness Network handling
	LAZYADD(madness_network, vampire)
	RegisterSignal(vampire, COMSIG_MOB_SAY, PROC_REF(handle_say), override = TRUE)
	RegisterSignal(vampire, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hear), override = TRUE)

/datum/vampire_clan/malkavian/on_lose(mob/living/carbon/human/vampire)
	. = ..()

	for (var/datum/action/cooldown/malkavian_action in vampire.actions)
		if (!istype(malkavian_action, /datum/action/cooldown/malk_hivemind) && !istype(malkavian_action, /datum/action/cooldown/malk_speech))
			continue

		malkavian_action.Remove()

	// Remove Madness Network
	LAZYREMOVE(madness_network, vampire)
	UnregisterSignal(vampire, COMSIG_MOB_SAY)
	UnregisterSignal(vampire, COMSIG_MOVABLE_HEAR)

/datum/vampire_clan/malkavian/proc/handle_say(mob/living/source, list/speech_args)
	SIGNAL_HANDLER

	if (!prob(20))
		return

	say_in_madness_network(speech_args[SPEECH_MESSAGE])

/datum/vampire_clan/malkavian/proc/handle_hear(mob/living/source, list/hearing_args)
	SIGNAL_HANDLER

	if (!prob(3))
		return

	say_in_madness_network(hearing_args[HEARING_RAW_MESSAGE])

/datum/vampire_clan/malkavian/proc/say_in_madness_network(message)
	for (var/mob/living/malkavian in madness_network)
		to_chat(malkavian, span_ghostalert(message))

/datum/action/cooldown/malk_hivemind
	name = "Hivemind"
	desc = "Talk"
	button_icon_state = "hivemind"
	check_flags = AB_CHECK_CONSCIOUS
	vampiric = TRUE
	cooldown_time = 5 SECONDS

/datum/action/cooldown/malk_hivemind/Trigger()
	. = ..()
	if(!IsAvailable())
		return

	var/datum/vampire_clan/malkavian/clan_malkavian = GLOB.vampire_clans[/datum/vampire_clan/malkavian]
	if (!(owner in clan_malkavian.madness_network))
		return

	var/new_thought = stripped_input(owner, "Have any thoughts about this, buddy?")
	if (!new_thought)
		return

	StartCooldown()
	clan_malkavian.say_in_madness_network(new_thought)

	message_admins("[ADMIN_LOOKUPFLW(usr)] said \"[new_thought]\" through the Madness Network.")
	log_game("[key_name(usr)] said \"[new_thought]\" through the Madness Network.")

/datum/action/cooldown/malk_speech
	name = "Madness Speech"
	desc = "Unleash your innermost thoughts"
	button_icon_state = "malk_speech"
	check_flags = AB_CHECK_CONSCIOUS
	vampiric = TRUE
	cooldown_time = 5 MINUTES

/datum/action/cooldown/malk_speech/Trigger()
	. = ..()
	var/mad_speak = FALSE
	if(IsAvailable())
		mad_speak = input(owner, "What revelations do we wish to convey?") as null|text
	if(CHAT_FILTER_CHECK(mad_speak))
		//before we inadvertently obfuscate the message to pass filters, filter it first.
		//as funny as malkavians saying "amogus" would be, the filter also includes slurs... how unfortunate.
		to_chat(src, span_warning("That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[mad_speak]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return

	if(mad_speak)
		StartCooldown()
		// replace some letters to make the font more closely resemble that of vtm: bloodlines' malkavian dialogue
		// big thanks to Metek for helping me condense this from a bunch of ugly regex replace procs
		var/list/replacements = list(
			"a"    = "𝙖",            "A" = "𝘼",
			"d"    = pick("𝓭","𝓓"), "D" = "𝓓",
			"e"    = "𝙚",            "E" = "𝙀",
			"i"    = "𝙞",            "I" = pick("ﾉ", "𝐼"), //rudimentary prob(50) to pick one or the other
			"l"    = pick("𝙇","l"),  "L" = pick("𝙇","𝓛"),
			"n"    = "𝙣",            "N" = pick("𝓝","𝙉"),
			"o"    = "𝙤",            "O" = "𝙊",
			"s"    = "𝘴",            "S" = "𝙎",
			"u"    = "𝙪",            "U" = "𝙐",
			"v"	   = "𝐯",            "V" = "𝓥",
		)
		for(var/letter in replacements)
			mad_speak = replacetextEx(mad_speak, letter, replacements[letter])
		owner.say(mad_speak, spans = list(SPAN_SANS)) // say() handles sanitation on its own
