/obj/structure/vip_barrier/stripclub
	name = "VIP Area"
	desc = "An Elysium for some, only staff and undead clients are allowed entry."
	protected_zone_id = "elysium_strip"
	social_roll_difficulty = 9


/obj/structure/vip_barrier/stripclub/check_entry_permission_custom(var/mob/living/carbon/human/entering_mob)
	if(iskindred(entering_mob) || (entering_mob.mind && entering_mob.mind.assigned_role == "Stripper"))
		return TRUE
	return FALSE
