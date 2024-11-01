/datum/vampireclane/salubri
	name = "Salubri"
	desc = "The Salubri are one of the original 13 clans of the vampiric descendants of Caine. Salubri believe that vampiric existence is torment from which Golconda or death is the only escape. Consequently, the modern Salubri would Embrace, teach a childe the basics of the route, leave clues for the childe to follow to achieve Golconda, and then have their childe diablerize them."
	curse = "Hunted and only con feeding."
	clane_disciplines = list(
		/datum/discipline/auspex = 1,
		/datum/discipline/fortitude = 2,
		/datum/discipline/valeren = 3
	)
	male_clothes = "/obj/item/clothing/under/vampire/salubri"
	female_clothes = "/obj/item/clothing/under/vampire/salubri/female"
	enlightement = FALSE

/datum/discipline/valeren/post_gain(mob/living/carbon/human/H)
	H.put_in_r_hand(new /obj/item/vamp/keys/salubri(H))
	if(level >= 4)
		var/obj/effect/proc_holder/spell/targeted/forcewall/salubri/FW = new(H)
		H.mind.AddSpell(FW)
