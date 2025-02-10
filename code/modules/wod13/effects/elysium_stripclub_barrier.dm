/obj/effect/vip_barrier/stripclub
	name = "VIP Area"
	desc = "Marks the beginning of the city's neutral zone for nonhumans. Beyond, true freaks of the night may congregate safely."
	protected_zone_id = "elysium_strip"
	social_roll_difficulty = 9


/obj/effect/vip_barrier/stripclub/check_entry_permission_custom(var/mob/living/carbon/human/entering_mob)
	if(!ishumanbasic(entering_mob) || (entering_mob.mind && entering_mob.mind.assigned_role == "Stripper"))
		return TRUE
	return FALSE
