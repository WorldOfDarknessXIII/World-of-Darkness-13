/datum/discipline/potence
	name = "Potence"
	desc = "Boosts melee and unarmed damage."
	icon_state = "potence"
	power_type = /datum/discipline_power/potence

/datum/discipline_power/potence
	name = "Potence power name"
	desc = "Potence power description"

	activate_sound = 'code/modules/wod13/sounds/potence_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/potence_deactivate.ogg'

//POTENCE 1
/datum/discipline_power/potence/one
	name = "Potence 1"
	desc = "Enhance your muscles. Never hit softly."

	level = 1

	check_flags = DISC_CHECK_CAPABLE

	toggled = TRUE
	duration_length = 2 TURNS

	var/datum/component/tackler

	grouped_powers = list(
		/datum/discipline_power/potence/two,
		/datum/discipline_power/potence/three,
		/datum/discipline_power/potence/four,
		/datum/discipline_power/potence/five
	)

/datum/discipline_power/potence/one/activate()
	. = ..()
	owner.dna.species.punchdamagelow += 8
	owner.dna.species.punchdamagehigh += 8
	owner.dna.species.meleemod += 0.4
	owner.dna.species.attack_sound = 'code/modules/wod13/sounds/heavypunch.ogg'
	tackler = owner.AddComponent(/datum/component/tackler, stamina_cost=0, base_knockdown = 1 SECONDS, range = 3, speed = 1, skill_mod = 0, min_distance = 0)
	owner.potential = 1

/datum/discipline_power/potence/one/deactivate()
	. = ..()
	owner.dna.species.punchdamagelow -= 8
	owner.dna.species.punchdamagehigh -= 8
	owner.dna.species.meleemod -= 0.4
	owner.dna.species.attack_sound = initial(owner.dna.species.attack_sound)
	owner.remove_overlay(POTENCE_LAYER)
	owner.potential = 0
	qdel(tackler)

//POTENCE 2
/datum/discipline_power/potence/two
	name = "Potence 2"
	desc = "Become powerful beyond your muscles. Wreck people and things."

	level = 2

	check_flags = DISC_CHECK_CAPABLE

	toggled = TRUE
	duration_length = 2 TURNS

	var/datum/component/tackler

	grouped_powers = list(
		/datum/discipline_power/potence/one,
		/datum/discipline_power/potence/three,
		/datum/discipline_power/potence/four,
		/datum/discipline_power/potence/five
	)

/datum/discipline_power/potence/two/activate()
	. = ..()
	owner.dna.species.punchdamagelow += 16
	owner.dna.species.punchdamagehigh += 16
	owner.dna.species.meleemod += 0.8
	owner.dna.species.attack_sound = 'code/modules/wod13/sounds/heavypunch.ogg'
	tackler = owner.AddComponent(/datum/component/tackler, stamina_cost=0, base_knockdown = 1 SECONDS, range = 4, speed = 1, skill_mod = 0, min_distance = 0)
	owner.potential = 2

/datum/discipline_power/potence/two/deactivate()
	. = ..()
	owner.dna.species.punchdamagelow -= 16
	owner.dna.species.punchdamagehigh -= 16
	owner.dna.species.meleemod -= 0.8
	owner.dna.species.attack_sound = initial(owner.dna.species.attack_sound)
	owner.remove_overlay(POTENCE_LAYER)
	owner.potential = 0
	qdel(tackler)

//POTENCE 3
/datum/discipline_power/potence/three
	name = "Potence 3"
	desc = "Become a force of destruction. Lift and break the unliftable and the unbreakable."

	level = 3

	check_flags = DISC_CHECK_CAPABLE

	toggled = TRUE
	duration_length = 2 TURNS

	var/datum/component/tackler

	grouped_powers = list(
		/datum/discipline_power/potence/one,
		/datum/discipline_power/potence/two,
		/datum/discipline_power/potence/four,
		/datum/discipline_power/potence/five
	)

/datum/discipline_power/potence/three/activate()
	. = ..()
	owner.dna.species.punchdamagelow += 24
	owner.dna.species.punchdamagehigh += 24
	owner.dna.species.meleemod += 1.2
	owner.dna.species.attack_sound = 'code/modules/wod13/sounds/heavypunch.ogg'
	tackler = owner.AddComponent(/datum/component/tackler, stamina_cost=0, base_knockdown = 1 SECONDS, range = 5, speed = 1, skill_mod = 0, min_distance = 0)
	owner.potential = 3

/datum/discipline_power/potence/three/deactivate()
	. = ..()
	owner.dna.species.punchdamagelow -= 24
	owner.dna.species.punchdamagehigh -= 24
	owner.dna.species.meleemod -= 1.2
	owner.dna.species.attack_sound = initial(owner.dna.species.attack_sound)
	owner.remove_overlay(POTENCE_LAYER)
	owner.potential = 0
	qdel(tackler)

//POTENCE 4
/datum/discipline_power/potence/four
	name = "Potence 4"
	desc = "Become an unyielding machine for as long as your Vitae lasts."

	level = 4

	check_flags = DISC_CHECK_CAPABLE

	toggled = TRUE
	duration_length = 2 TURNS

	var/datum/component/tackler

	grouped_powers = list(
		/datum/discipline_power/potence/one,
		/datum/discipline_power/potence/two,
		/datum/discipline_power/potence/three,
		/datum/discipline_power/potence/five
	)

/datum/discipline_power/potence/four/activate()
	. = ..()
	owner.dna.species.punchdamagelow += 32
	owner.dna.species.punchdamagehigh += 32
	owner.dna.species.meleemod += 1.6
	owner.dna.species.attack_sound = 'code/modules/wod13/sounds/heavypunch.ogg'
	tackler = owner.AddComponent(/datum/component/tackler, stamina_cost=0, base_knockdown = 1 SECONDS, range = 6, speed = 1, skill_mod = 0, min_distance = 0)
	owner.potential = 4

/datum/discipline_power/potence/four/deactivate()
	. = ..()
	owner.dna.species.punchdamagelow -= 32
	owner.dna.species.punchdamagehigh -= 32
	owner.dna.species.meleemod -= 1.6
	owner.dna.species.attack_sound = initial(owner.dna.species.attack_sound)
	owner.remove_overlay(POTENCE_LAYER)
	owner.potential = 0
	qdel(tackler)

//POTENCE 5
/datum/discipline_power/potence/five
	name = "Potence 5"
	desc = "The people could worship you as a god if you showed them this."

	level = 5

	check_flags = DISC_CHECK_CAPABLE

	toggled = TRUE
	duration_length = 2 TURNS

	var/datum/component/tackler

	grouped_powers = list(
		/datum/discipline_power/potence/one,
		/datum/discipline_power/potence/two,
		/datum/discipline_power/potence/three,
		/datum/discipline_power/potence/four
	)

/datum/discipline_power/potence/five/activate()
	. = ..()
	owner.dna.species.punchdamagelow += 40
	owner.dna.species.punchdamagehigh += 40
	owner.dna.species.meleemod += 2
	owner.dna.species.attack_sound = 'code/modules/wod13/sounds/heavypunch.ogg'
	tackler = owner.AddComponent(/datum/component/tackler, stamina_cost=0, base_knockdown = 1 SECONDS, range = 7, speed = 1, skill_mod = 0, min_distance = 0)
	owner.potential = 5

/datum/discipline_power/potence/five/deactivate()
	. = ..()
	owner.dna.species.punchdamagelow -= 40
	owner.dna.species.punchdamagehigh -= 40
	owner.dna.species.meleemod -= 2
	owner.dna.species.attack_sound = initial(owner.dna.species.attack_sound)
	owner.remove_overlay(POTENCE_LAYER)
	owner.potential = 0
	qdel(tackler)
