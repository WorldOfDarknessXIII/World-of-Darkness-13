/datum/discipline/animalism
	name = "Animalism"
	desc = "Summons spectral animals over your targets. Violates Masquerade."
	icon_state = "animalism"

/datum/discipline/animalism/New(level)
	all_powers = subtypesof(/datum/discipline_power/animalism)
	..()

/datum/discipline_power/animalism
	name = "Animalism power name"
	desc = "Animalism power description"

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

	effect_sound = 'code/modules/wod13/sounds/wolves.ogg'
	violates_masquerade = TRUE

	cooldown_length = 8 SECONDS

/datum/discipline_power/animalism/activate()
	. = ..()
	if (level >= 5)
		return .

	var/limit = min(2, level) + owner.social + owner.more_companions - 1
	if(length(owner.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/B = pick(owner.beastmaster)
		B.death()
	if(!length(owner.beastmaster))
		var/datum/action/beastmaster_stay/E1 = new()
		E1.Grant(owner)
		var/datum/action/beastmaster_deaggro/E2 = new()
		E2.Grant(owner)

//SUMMON RAT
/datum/discipline_power/animalism/summon_rat
	name = "Skittering Critters"
	desc = "Summons rats to follow you and gnaw on your enemies."

	level = 1
	violates_masquerade = FALSE

/datum/discipline_power/animalism/summon_rat/activate()
	. = ..()
	var/mob/living/simple_animal/hostile/beastmaster/rat/R = new(get_turf(owner))
	R.my_creator = owner
	owner.beastmaster |= R
	R.beastmaster = owner

//SUMMON CAT
/datum/discipline_power/animalism/summon_cat
	name = "Clawing Felines"
	desc = "Summons very cute cats to accompany you in the night."

	level = 2
	violates_masquerade = FALSE

/datum/discipline_power/animalism/summon_cat/activate()
	. = ..()
	var/mob/living/simple_animal/hostile/beastmaster/cat/C = new(get_turf(owner))
	C.my_creator = owner
	owner.beastmaster |= C
	C.beastmaster = owner

//SUMMON WOLF
/*
/obj/effect/spectral_wolf
	name = "Spectral Wolf"
	desc = "Bites enemies in other dimensions."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "wolf"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
*/

/datum/discipline_power/animalism/summon_wolf
	name = "Spectral Wolf"
	desc = "Summons a phantasmal wolf to attack the target."

	level = 3

/datum/discipline_power/animalism/summon_wolf/activate()
	. = ..()
	var/mob/living/simple_animal/hostile/beastmaster/D = new(get_turf(owner))
	D.my_creator = owner
	owner.beastmaster |= D
	D.beastmaster = owner

//SUMMON BAT
/datum/discipline_power/animalism/summon_bat
	name = "Bloodsucker's Communion"
	desc = "Summons a swarm of bats to drain blood from the victim and transfer it to you."

	level = 4

/datum/discipline_power/animalism/summon_bat/activate()
	. = ..()
	var/mob/living/simple_animal/hostile/beastmaster/rat/flying/F = new(get_turf(owner))
	F.my_creator = owner
	owner.beastmaster |= F
	F.beastmaster = owner

//RAT SHAPESHIFT
/obj/effect/proc_holder/spell/targeted/shapeshift/animalism
	name = "Animalism Form"
	desc = "Take on the shape a rat."
	charge_max = 5 SECONDS
	cooldown_min = 5 SECONDS
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/pet/rat

/datum/discipline_power/animalism/rat_shapeshift
	name = "Skitter"
	desc = "Become one of the rats that crawl beneath the city."

	duration_length = 20 SECONDS

	var/obj/effect/proc_holder/spell/targeted/shapeshift/animalism/AN

/datum/discipline_power/animalism/rat_shapeshift/activate()
	. = ..()
	if(!AN)
		AN = new(owner)
	AN.Shapeshift(owner)

/datum/discipline_power/animalism/rat_shapeshift/deactivate()
	. = ..()
	if(owner.stat != DEAD)
		AN.Restore(AN.myshape)
		owner.Stun(1.5 SECONDS)
