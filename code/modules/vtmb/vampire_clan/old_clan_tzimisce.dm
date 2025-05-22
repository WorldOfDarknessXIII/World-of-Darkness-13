/datum/vampire_clan/old_clan_tzimisce
	name = "Old Clan Tzimisce"
	desc = " The Old Clan Tzimisce are a small group of Fiends who predate the use of fleshcrafting. They regard Vicissitude as a disease of the soul, and refuse to learn or employ it. In most other respects, though, they resemble the rest of the Clan."
	curse = "Grounded to material domain."
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/animalism,
		/datum/discipline/dominate
	)
	male_clothes = /obj/item/clothing/under/vampire/sport
	female_clothes = /obj/item/clothing/under/vampire/red
	enlightenment = TRUE
	restricted_disciplines = list(/datum/discipline/vicissitude)
	whitelisted = FALSE

/datum/vampire_clan/old_clan_tzimisce/on_join_round(mob/living/carbon/human/H)
	. = ..()

	var/obj/item/ground_heir/heirloom = new(get_turf(H))
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
		LOCATION_HANDS = ITEM_SLOT_HANDS
	)
	H.equip_in_one_of_slots(heirloom, slots, FALSE)
	H.AddComponent(/datum/component/needs_home_soil, heirloom)
