/datum/discipline/protean
	name = "Protean"
	desc = "Lets your beast out, making you stronger and faster. Violates Masquerade."
	icon_state = "protean"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/protean

/datum/discipline_power/protean
	name = "Protean power name"
	desc = "Protean power description"

	activate_sound = 'code/modules/wod13/sounds/protean_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/protean_deactivate.ogg'

//EYES OF THE BEAST
/datum/discipline_power/protean/eyes_of_the_beast
	name = "Eyes of the Beast"
	desc = "Let your eyes be a gateway to your Beast. Gain its eyes."

	level = 1

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 20 SECONDS
	cooldown_length = 20 SECONDS

	grouped_powers = list(
		/datum/discipline_power/protean/feral_claws,
		/datum/discipline_power/protean/earth_meld,
		/datum/discipline_power/protean/shape_of_the_beast,
		/datum/discipline_power/protean/mist_form
	)

/datum/discipline_power/protean/eyes_of_the_beast/activate()
	. = ..()
	owner.drop_all_held_items()
	owner.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel(owner))
	owner.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel(owner))
	owner.add_client_colour(/datum/client_colour/glass_colour/red)

/datum/discipline_power/protean/eyes_of_the_beast/deactivate()
	. = ..()
	for(var/obj/item/melee/vampirearms/knife/gangrel/G in owner.contents)
		qdel(G)
	owner.remove_client_colour(/datum/client_colour/glass_colour/red)

//FERAL CLAWS
/datum/movespeed_modifier/protean2
	multiplicative_slowdown = -0.15

/datum/discipline_power/protean/feral_claws
	name = "Feral Claws"
	desc = "Become a predator and grow hideous talons."

	level = 2

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 20 SECONDS
	cooldown_length = 20 SECONDS

	grouped_powers = list(
		/datum/discipline_power/protean/eyes_of_the_beast,
		/datum/discipline_power/protean/earth_meld,
		/datum/discipline_power/protean/shape_of_the_beast,
		/datum/discipline_power/protean/mist_form
	)

/datum/discipline_power/protean/feral_claws/activate()
	. = ..()
	owner.drop_all_held_items()
	owner.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel(owner))
	owner.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel(owner))
	owner.add_client_colour(/datum/client_colour/glass_colour/red)
	owner.add_movespeed_modifier(/datum/movespeed_modifier/protean2)

/datum/discipline_power/protean/feral_claws/deactivate()
	. = ..()
	for(var/obj/item/melee/vampirearms/knife/gangrel/G in owner.contents)
		qdel(G)
	owner.remove_client_colour(/datum/client_colour/glass_colour/red)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/protean2)

//EARTH MELD
/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel
	name = "Gangrel Form"
	desc = "Take on the shape a wolf."
	charge_max = 50
	cooldown_min = 5 SECONDS
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/gangrel

/datum/discipline_power/protean/earth_meld
	name = "Earth Meld"
	desc = "Hide yourself in the earth itself."

	level = 3

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 20 SECONDS
	cooldown_length = 20 SECONDS

	grouped_powers = list(
		/datum/discipline_power/protean/eyes_of_the_beast,
		/datum/discipline_power/protean/feral_claws,
		/datum/discipline_power/protean/shape_of_the_beast,
		/datum/discipline_power/protean/mist_form
	)

	var/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel/GA

/datum/discipline_power/protean/earth_meld/activate()
	. = ..()
	if (!GA)
		GA = new(owner)
	owner.drop_all_held_items()
	GA.Shapeshift(owner)

/datum/discipline_power/protean/earth_meld/deactivate()
	. = ..()
	GA.Restore(GA.myshape)
	owner.Stun(1.5 SECONDS)
	owner.do_jitter_animation(30)

//SHAPE OF THE BEAST
/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel/better
	shapeshift_type = /mob/living/simple_animal/hostile/gangrel/better

/datum/discipline_power/protean/shape_of_the_beast
	name = "Shape of the Beast"
	desc = "Assume the form of an animal and retain your power."

	level = 4

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 20 SECONDS
	cooldown_length = 20 SECONDS

	grouped_powers = list(
		/datum/discipline_power/protean/eyes_of_the_beast,
		/datum/discipline_power/protean/feral_claws,
		/datum/discipline_power/protean/earth_meld,
		/datum/discipline_power/protean/mist_form
	)

	var/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel/better/GA

/datum/discipline_power/protean/shape_of_the_beast/activate()
	. = ..()
	if (!GA)
		GA = new(owner)
	owner.drop_all_held_items()
	GA.Shapeshift(owner)

/datum/discipline_power/protean/shape_of_the_beast/deactivate()
	. = ..()
	GA.Restore(GA.myshape)
	owner.Stun(1 SECONDS)
	owner.do_jitter_animation(15)

//MIST FORM
/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel/best
	shapeshift_type = /mob/living/simple_animal/hostile/gangrel/best

/datum/discipline_power/protean/mist_form
	name = "Mist Form"
	desc = "Dissipate your body and move as mist."

	level = 5

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 20 SECONDS
	cooldown_length = 20 SECONDS

	grouped_powers = list(
		/datum/discipline_power/protean/eyes_of_the_beast,
		/datum/discipline_power/protean/feral_claws,
		/datum/discipline_power/protean/earth_meld,
		/datum/discipline_power/protean/shape_of_the_beast
	)

	var/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel/best/GA

/datum/discipline_power/protean/mist_form/activate()
	. = ..()
	if (!GA)
		GA = new(owner)
	owner.drop_all_held_items()
	GA.Shapeshift(owner)

/datum/discipline_power/protean/mist_form/deactivate()
	. = ..()
	GA.Restore(GA.myshape)
	owner.Stun(1 SECONDS)
	owner.do_jitter_animation(15)
