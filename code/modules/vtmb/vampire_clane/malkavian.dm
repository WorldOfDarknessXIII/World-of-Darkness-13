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
	///malkavian is mad speech?
	var/is_mad_speech = FALSE

/datum/vampireclane/malkavian/post_gain(mob/living/carbon/human/malky)
	. = ..()
	var/datum/action/cooldown/malk_hivemind/hivemind = new()
	var/datum/action/cooldown/malk_speech/malk_font = new()
	hivemind.Grant(malky)
	malk_font.Grant(malky)
	malk_font.link_with_datum(src)
	GLOB.malkavian_list += malky

/datum/discipline/dementation/post_gain(mob/living/carbon/human/H)
	..()
	H.add_quirk(/datum/quirk/insanity)

/datum/action/cooldown/malk_hivemind
	name = "Hivemind"
	desc = "Talk"
	button_icon_state = "hivemind"
	check_flags = AB_CHECK_CONSCIOUS
	vampiric = TRUE
	cooldown_time = 5 SECONDS

/datum/action/cooldown/malk_hivemind/Trigger()
	. = ..()
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
	cooldown_time = 300 SECONDS
	///clane datum
	var/datum/vampireclane/malkavian/clane_datum

/datum/action/cooldown/malk_speech/Trigger()
	. = ..()
	if(!clane_datum)
		to_chat(H, span_warning("No clane datum that is linked, yell at coders!"))

	clane_datum.is_mad_speech = !clane_datum.is_mad_speech
	if(clane_datum.is_mad_speech)
		to_chat(owner, "<span class='hypnophrase'>Your Speech will Now Use the Madness Font</span>")
	else
		to_chat(owner, "<span class='hypnophrase'>Your Speech will No Longer Use the Madness Font</span>")

/datum/action/cooldown/malk_speech/proc/link_with_datum(datum/vampireclane/malkavian/malky)
	clane_datum = malky
