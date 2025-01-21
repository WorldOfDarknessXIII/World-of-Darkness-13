/obj/structure/vip_barrier/elysium
	name = "Elysium Checkpoint"
	desc = "The barrier between a moonlit night and a world of darkness."
	icon_block = "camarilla_blocking"
	icon_pass = "camarilla_passing"
	protected_zone_id = "elysium"


/obj/structure/vip_barrier/elysium/check_entry_permission_custom(var/mob/living/carbon/human/entering_mob)
	if(iskindred(entering_mob))
		return TRUE
	return FALSE
