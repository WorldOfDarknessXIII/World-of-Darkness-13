/datum/vampireclane/malkavian
	name = "Malkavian"
	desc = "Derided as Lunatics by other vampires, the Blood of the Malkavians lets them perceive and foretell truths hidden from others. Like the �wise madmen� of poetry their fractured perspective stems from seeing too much of the world at once, from understanding too deeply, and feeling emotions that are just too strong to bear."
	curse = "Insanity."
	clane_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/dementation,
		/datum/discipline/obfuscate
	)
	male_clothes = /obj/item/clothing/under/vampire/malkavian
	female_clothes = /obj/item/clothing/under/vampire/malkavian/female
	clan_keys = /obj/item/vamp/keys/malkav

/datum/vampireclane/malkavian/post_gain(mob/living/carbon/human/malky)
	. = ..()
	var/datum/action/cooldown/malk_hivemind/hivemind = new()
	var/datum/action/cooldown/malk_speech/malk_font = new()
	hivemind.Grant(malky)
	malk_font.Grant(malky)
	GLOB.malkavian_list += malky

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

	var/new_thought = input(owner, "Have any thoughts about this, buddy?") as null|text
	if(new_thought)
		StartCooldown()
		new_thought = trim(copytext_char(sanitize(new_thought), 1, MAX_MESSAGE_LEN))
		for(var/mob/living/carbon/human/H in GLOB.malkavian_list)
			if (iskindred(H) && (H.stat != DEAD))
				to_chat(H, "<span class='ghostalert'>[new_thought]</span>")

		message_admins("[ADMIN_LOOKUPFLW(usr)] said \"[new_thought]\" through the Madness Network.")
		log_game("[key_name(usr)] said \"[new_thought]\" through the Madness Network.")

/datum/action/cooldown/malk_speech
	name = "Madness Speech"
	desc = "Unleash your innermost thoughts"
	button_icon_state = "malk_speech"
	check_flags = AB_CHECK_CONSCIOUS
	vampiric = TRUE
	cooldown_time = 5 MINUTES
	///clane datum
	var/datum/vampireclane/malkavian/clane_datum

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
