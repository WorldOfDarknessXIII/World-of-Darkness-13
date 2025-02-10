/obj/effect/vip_barrier/elysium
	name = "Elysium Checkpoint"
	desc = "The barrier between a moonlit night and a world of darkness."
	protected_zone_id = "elysium"
	social_roll_difficulty = 9


/obj/effect/vip_barrier/elysium_2
	protected_zone_id = "elysium_2"



/obj/effect/vip_barrier/elysium/theatre
	protected_zone_id = "elysium_theatre"

/obj/effect/vip_barrier/elysium/theatre_backdoor
	protected_zone_id = "theatre_backdoor"

/obj/effect/vip_barrier/elysium/check_entry_permission_custom(var/mob/living/carbon/human/entering_mob)
	if(iskindred(entering_mob) || isghoul(entering_mob))
		return TRUE
	return FALSE
