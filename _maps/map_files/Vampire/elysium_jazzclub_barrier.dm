/obj/effect/vip_barrier/elysium
	name = "Elysium JazzClub Checkpoint"
	desc = "Beyond this point lay riches and secrets untold."
	protected_zone_id = "jazzclub"
	social_roll_difficulty = 7

/obj/effect/vip_barrier/jazzclub
	protected_zone_id = "jazzclub"

/obj/effect/vip_barrier/elysium/jazzclub_elevator
	protected_zone_id = "jazzclub_elevator"

/obj/effect/vip_barrier/elysium/jazzclub_ballroom
	protected_zone_id = "jazzclub_ballroom"

/obj/effect/vip_barrier/elysium/jazzclub_basement_1
	protected_zone_id = "jazzclub_basement_1"

/obj/effect/vip_barrier/elysium/jazzclub_basement_2
	protected_zone_id = "jazzclub_basement_2"

/obj/effect/vip_barrier/elysium/check_entry_permission_custom(var/mob/living/carbon/human/entering_mob)
	if(iskindred(entering_mob) || isghoul(entering_mob))
		return TRUE
	return FALSE
