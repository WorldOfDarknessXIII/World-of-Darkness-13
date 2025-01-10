/datum/vampireclan/banu_haqim
	name = "Banu Haqim"
	desc = "Banu Haqim, also known as Assamites, are traditionally seen by Western Kindred as dangerous assassins and diablerists, but in truth they are guardians, warriors, and scholars who seek to distance themselves from the Jyhad."
	curse = "Blood Addiction."
	clan_disciplines = list(
		/datum/discipline/celerity,
		/datum/discipline/obfuscate,
		/datum/discipline/quietus
	)
	male_clothes = /obj/item/clothing/under/vampire/bandit
	female_clothes = /obj/item/clothing/under/vampire/bandit
	clan_keys = /obj/item/vamp/keys/banuhaqim
	whitelisted = TRUE

/*
/datum/discipline/quietus/post_gain(mob/living/carbon/human/H)
	if(level >= 3)
		var/datum/action/silence_radius/SI = new()
		SI.Grant(H)
*/
/datum/action/silence_radius
	name = "Silence Radius"
	desc = "Silence nearby location."
	button_icon_state = "quietus"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/last_silence = 0

/datum/action/silence_radius/Trigger()
	if((last_silence + 30 SECONDS) >= world.time)
		return
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		if(H.bloodpool < 2)
			to_chat(owner, "<span class='warning'>You don't have enough <b>BLOOD</b> to do that!</span>")
			return
		to_chat(owner, "<span class='notice'>You activate the Quietus Silence.</span>")
		H.bloodpool = max(0, H.bloodpool-2)
		last_silence = world.time
		for(var/turf/T in range(7, src))
			T.silented = TRUE
			spawn(300)
				if(T)
					T.silented = FALSE
