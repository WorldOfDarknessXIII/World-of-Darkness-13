/obj/effect/proc_holder/spell/voice_of_god
	name = "Voice of Domination"
	desc = "Speak with an incredibly compelling voice, forcing listeners to obey your commands."
	charge_max = 1200 //variable
	cooldown_min = 0
	level_max = 1
	clothes_req = FALSE
	antimagic_allowed = TRUE
	action_icon = 'icons/mob/actions/actions_items.dmi'
	action_icon_state = "voice_of_god"
	action_background_icon_state = "default"
	var/command
	var/cooldown_mod = 1
	var/power_mod = 1
	var/list/spans = list("colossus","yell")
	var/speech_sound = 'sound/magic/clockwork/invoke_general.ogg'
	var/speech_volume = 300
	var/speech_vary = TRUE
	var/reverb = FALSE

/obj/effect/proc_holder/spell/voice_of_god/can_cast(mob/user = usr)
	if(!user.can_speak())
		to_chat(user, "<span class='warning'>You are unable to speak!</span>")
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/voice_of_god/choose_targets(mob/user = usr)
	perform(user=user)

/obj/effect/proc_holder/spell/voice_of_god/perform(list/targets, recharge = 1, mob/user = usr)
	command = input(user, "Speak with the Voice of Domination", "Command") as null|text
	if(QDELETED(src) || QDELETED(user))
		return
	if(!command)
		revert_cast(user)
		return
	..()

/obj/effect/proc_holder/spell/voice_of_god/cast(list/targets, mob/user = usr)
	if (findtext(command, "fall"))
		speech_sound = 'sound/magic/fall.ogg'
		speech_volume = 1500
		speech_vary = FALSE
		reverb = TRUE
	else
		speech_sound = 'sound/magic/clockwork/invoke_general.ogg'
		speech_volume = 200
		speech_vary = TRUE
		reverb = FALSE
	playsound(get_turf(user), speech_sound, speech_volume, speech_vary, 5, use_reverb = reverb)
	var/cooldown = voice_of_god(uppertext(command), user, spans, base_multiplier = power_mod)
	charge_max = (cooldown * cooldown_mod)

/obj/effect/proc_holder/spell/voice_of_god/clown
	name = "Voice of Clown"
	desc = "Speak with an incredibly funny voice, startling people into obeying you for a brief moment."
	power_mod = 0.1
	cooldown_mod = 0.5
	spans = list("clown")
	speech_sound = 'sound/spookoween/scary_horn2.ogg'
