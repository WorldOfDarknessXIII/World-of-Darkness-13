/obj/effect/vip_barrier/giovanni
	name = "Giovanni Checkpoint"
	desc = "This here's a family gathering, capice?"
	protected_zone_id = "giovanni"
	social_roll_difficulty = 7

/obj/effect/vip_barrier/giovanni/check_entry_permission_custom(var/mob/living/carbon/human/entering_mob)
	if(entering_mob.mind && entering_mob.mind.assigned_role && GLOB.giovanni_positions.Find(entering_mob.mind.assigned_role))
		return TRUE
	return FALSE
