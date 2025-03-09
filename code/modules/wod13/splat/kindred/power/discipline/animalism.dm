/datum/discipline/animalism
	name = "Animalism"
	desc = "Summons spectral animals over your targets. Violates Masquerade."
	icon_state = "animalism"
	power_type = /datum/discipline_power/animalism

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
		var/mob/living/simple_animal/hostile/beastmaster/beast = pick(owner.beastmaster)
		beast.death()
	if(!length(owner.beastmaster))
		var/datum/action/beastmaster_stay/stay = new()
		stay.Grant(owner)
		var/datum/action/beastmaster_deaggro/deaggro = new()
		deaggro.Grant(owner)

//SUMMON RAT
/datum/discipline_power/animalism/summon_rat
	name = "Skittering Critters"
	desc = "Summons rats to follow you and gnaw on your enemies."

	level = 1
	violates_masquerade = FALSE

/datum/discipline_power/animalism/summon_rat/activate()
	. = ..()
	var/mob/living/simple_animal/hostile/beastmaster/rat/rat = new(get_turf(owner))
	rat.my_creator = owner
	owner.beastmaster |= rat
	rat.beastmaster = owner

//SUMMON CAT
/datum/discipline_power/animalism/summon_cat
	name = "Clawing Felines"
	desc = "Summons very cute cats to accompany you in the night."

	level = 2
	violates_masquerade = FALSE

/datum/discipline_power/animalism/summon_cat/activate()
	. = ..()
	var/mob/living/simple_animal/hostile/beastmaster/cat/cat = new(get_turf(owner))
	cat.my_creator = owner
	owner.beastmaster |= cat
	cat.beastmaster = owner

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
	var/mob/living/simple_animal/hostile/beastmaster/dog = new(get_turf(owner))
	dog.my_creator = owner
	owner.beastmaster |= dog
	dog.beastmaster = owner

//SUMMON BAT
/datum/discipline_power/animalism/summon_bat
	name = "Bloodsucker's Communion"
	desc = "Summons a swarm of bats to drain blood from the victim and transfer it to you."

	level = 4

/datum/discipline_power/animalism/summon_bat/activate()
	. = ..()
	var/mob/living/simple_animal/hostile/beastmaster/rat/flying/bat = new(get_turf(owner))
	bat.my_creator = owner
	owner.beastmaster |= bat
	bat.beastmaster = owner

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

	var/obj/effect/proc_holder/spell/targeted/shapeshift/animalism/shapeshift

/datum/discipline_power/animalism/rat_shapeshift/activate()
	. = ..()
	if(!shapeshift)
		shapeshift = new(owner)
	shapeshift.Shapeshift(owner)

/datum/discipline_power/animalism/rat_shapeshift/deactivate()
	. = ..()
	if(owner.stat != DEAD)
		shapeshift.Restore(shapeshift.myshape)
		owner.Stun(1.5 SECONDS)
