/datum/vampireclan/giovanni
	name = "Giovanni"
	desc = "The Giovanni are the usurpers of Clan Cappadocian and one of the youngest clans. The Giovanni has historically been both a clan and a family. They Embrace almost exclusively within their family, and are heavily focused on the goals of money and necromantic power."
	curse = "Harmful bites."
	clan_disciplines = list(
		/datum/discipline/potence,
		/datum/discipline/dominate,
		/datum/discipline/necromancy
	)
	male_clothes = /obj/item/clothing/under/vampire/suit
	female_clothes = /obj/item/clothing/under/vampire/suit/female
	whitelisted = FALSE

/datum/discipline/necromancy/post_gain(mob/living/carbon/human/H)
	H.faction |= "Giovanni"
	H.grant_language(/datum/language/italian)
	if(level >= 2)
		var/datum/action/ghost_hear/GH = new()
		GH.Grant(H)

/datum/action/ghost_hear
	name = "See Ghosts"
	desc = "Allows you to see ghosts."
	button_icon_state = "ghost"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE

/datum/action/ghost_hear/Trigger()
	. = ..()
	if(isliving(owner))
		var/mob/living/L = owner
		if(!L.hearing_ghosts)
			L.see_invisible = SEE_INVISIBLE_OBSERVER
			L.hearing_ghosts = TRUE
			to_chat(owner, "<span class='notice'>You activate the Necromancy Vision on.</span>")
		else
			L.see_invisible = initial(owner.see_invisible)
			L.hearing_ghosts = FALSE
			to_chat(owner, "<span class='warning'>You activate the Necromancy Vision off.</span>")
