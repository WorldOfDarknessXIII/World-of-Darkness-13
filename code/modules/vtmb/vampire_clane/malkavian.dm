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

/datum/vampireclane/malkavian/post_gain(mob/living/carbon/human/H)
	. = ..()
	var/datum/action/cooldown/malk_hivemind/GH = new()
	if(H)
		var/datum/preferences/H_M_client = H.client.prefs
		var/index = H_M_client.discipline_types.Find(/datum/discipline/dementation)
		if(index)
			var/dementation_level = H_M_client.discipline_levels[index]
			
			if(dementation_level >= 3)
				var/cooldown_time_change = 40 SECONDS
				cooldown_time_change -= dementation_level * 5 SECONDS
				 
				cooldown_time_change = max(cooldown_time_change, 0)
				 
				GH.cooldown_time = cooldown_time_change
				GH.Grant(H)

	GLOB.malkavian_list += H

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
				var/datum/preferences/H_client = H.client.prefs
				
				var/H_generation = H_client.generation
				
				var/index = H_client.discipline_types.Find(/datum/discipline/auspex)
				
				var/font_size = 13 + (13 - H_generation)
				
				font_size = clamp(font_size, 13, 25)
				
				if(index)
					var/auspex_level = H_client.discipline_levels[index]
					
					var/encrypted_message = encrypt_message(new_thought, auspex_level)
				
					var/styled_message = "<span style='font-size:[font_size]px;'>[encrypted_message]</span>"
					
					to_chat(H, "<span class='ghostalert'>[styled_message]</span>")


		message_admins("[ADMIN_LOOKUPFLW(usr)] said \"[new_thought]\" through the Madness Network.")
		log_game("[key_name(usr)] said \"[new_thought]\" through the Madness Network.")
