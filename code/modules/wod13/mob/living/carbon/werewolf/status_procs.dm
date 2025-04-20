/mob/living/carbon/werewolf/Stun(amount, ignore_canstun = FALSE)
	. = ..()
	if(!.)
		move_delay_add = min(move_delay_add + round(amount / 2), 10) //a maximum delay of 10

/mob/living/carbon/werewolf/SetStun(amount, ignore_canstun = FALSE)
	. = ..()
	if(!.)
		move_delay_add = min(move_delay_add + round(amount / 2), 10)

/mob/living/carbon/werewolf/AdjustStun(amount, ignore_canstun = FALSE)
	. = ..()
	if(!.)
		move_delay_add = clamp(move_delay_add + round(amount/2), 0, 10)