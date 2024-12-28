/datum/vampireclane/ventrue
	name = "Ventrue"
	desc = "The Ventrue are not called the Clan of Kings for nothing. Carefully choosing their progeny from mortals familiar with power, wealth, and influence, the Ventrue style themselves the aristocrats of the vampire world. Their members are expected to assume command wherever possible, and they’re willing to endure storms for the sake of leading from the front."
	curse = "Low-rank and animal blood is disgusting."
	clane_disciplines = list(
		/datum/discipline/dominate,
		/datum/discipline/fortitude,
		/datum/discipline/presence
	)
	male_clothes = /obj/item/clothing/under/vampire/ventrue
	female_clothes = /obj/item/clothing/under/vampire/ventrue/female

/datum/discipline/dominate/post_gain(mob/living/carbon/human/H)
	if(level >= 1)
		var/obj/effect/proc_holder/spell/voice_of_god/S = new(H)
		H.mind.AddSpell(S)

/datum/action/dominate
	name = "Dominate"
	desc = "Dominate over other living or un-living beings."
	button_icon_state = "dominate"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/cool_down = 0

/datum/action/dominate/Trigger()
	. = ..()
	if((cool_down + 5 SECONDS) >= world.time)
		return
	var/mob/living/carbon/human/A = owner
	if(HAS_TRAIT(A, TRAIT_MUTE))
		to_chat(A, "<span class='warning'>You find yourself unable to speak!</span>")
		return
	var/new_say = input(owner, "Choose the phrase to dominate:") as text|null
	if(new_say)
		for(var/mob/living/carbon/human/H in ohearers(7, src))
			if(H)
				if(H.can_hear())
					var/mypower = 13-A.generation+A.social
					var/theirpower = 13-H.generation+H.mentality
					if(theirpower <= mypower)
						H.cure_trauma_type(/datum/brain_trauma/severe/hypnotic_trigger, TRAUMA_RESILIENCE_BASIC)
						H.gain_trauma(new /datum/brain_trauma/severe/hypnotic_trigger(new_say), TRAUMA_RESILIENCE_BASIC)
						H.do_jitter_animation(30)
		owner.say("[new_say]")
