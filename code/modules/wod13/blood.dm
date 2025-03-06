/****************************************************
	VAMPIRE: THE MASQUERADE BLOOD POOL HANDLING
****************************************************/

/mob/living/proc/can_adjust_blood_points(amount)
	var/blood_per_point = initial(blood_volume) / maxbloodpool

	if (amount == 0)
		return TRUE
	else if (amount > 0)
		if ((blood_volume + blood_per_point * amount) > initial(blood_volume))
			return FALSE
		if ((bloodpool + amount) > maxbloodpool)
			return FALSE
	else
		if ((blood_volume + blood_per_point * amount) < 0)
			return FALSE
		if ((bloodpool + amount) < 0)
			return FALSE
	return TRUE

/mob/living/proc/try_adjust_blood_points(amount)
	if (can_adjust_blood_points(amount))
		adjust_blood_points(amount)
		return TRUE
	else
		return FALSE

/mob/living/proc/adjust_blood_points(points)
	var/blood_per_point = initial(blood_volume) / maxbloodpool
	blood_volume = clamp(blood_volume + points * blood_per_point, 0, initial(blood_volume))

	update_blood_values()

/mob/living/proc/set_blood_points(points)
	adjust_blood_points(points - bloodpool)

/mob/living/proc/adjust_blood_volume(gain)
	var/blood_per_point = initial(blood_volume) / maxbloodpool

	var/factor = blood_per_point / BLOOD_POINT_NORMAL
	gain *= factor
	blood_volume = clamp(blood_volume + gain, 0, initial(blood_volume))

	update_blood_values()

/mob/living/proc/update_blood_values()
	var/blood_per_point = initial(blood_volume) / maxbloodpool

	blood_volume = clamp(blood_volume, 0, initial(blood_volume))
	bloodpool = clamp(blood_volume / blood_per_point, 0, maxbloodpool)

	update_blood_hud()

/mob/living/proc/set_blood_volume(volume)
	adjust_blood_volume(volume - blood_volume)

/mob/living/proc/blood_points_per_units(units)
	var/blood_per_point = initial(blood_volume) / maxbloodpool

	return (units / blood_per_point)

/mob/living/proc/transfer_blood_points(mob/living/to_mob, amount)
	var/points_to_transfer = clamp(amount, 0, bloodpool)
	adjust_blood_points(-points_to_transfer)
	to_mob.adjust_blood_points(points_to_transfer)
