/obj/structure/vip_barrier/elysium
	name = "Elysium Checkpoint"
	desc = "The barrier between a moonlit night and a world of darkness."
	protected_zone_id = "elysium"


/obj/structure/vip_barrier/elysium/check_entry_permission_custom(var/mob/living/carbon/human/entering_mob)
	if(iskindred(entering_mob))
		return TRUE
	return FALSE
