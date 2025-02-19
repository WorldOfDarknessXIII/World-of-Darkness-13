/datum/discipline/fortitude
	name = "Fortitude"
	desc = "Boosts armor."
	icon_state = "fortitude"
	power_type = /datum/discipline_power/fortitude

/datum/discipline_power/fortitude
	name = "Fortitude power name"
	desc = "Fortitude power description"

	check_flags = DISC_CHECK_CONSCIOUS

	activate_sound = 'code/modules/wod13/sounds/fortitude_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/fortitude_deactivate.ogg'

	toggled = TRUE
	duration_length = DURATION_TURN

//FORTITUDE 1
/datum/discipline_power/fortitude/one
	name = "Fortitude 1"
	desc = "Harden your muscles. Become sturdier than the bodybuilders."

	level = 1

	grouped_powers = list(
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/four,
		/datum/discipline_power/fortitude/five
	)

/datum/discipline_power/fortitude/one/activate()
	. = ..()
	owner.physiology.armor.melee += 15
	owner.physiology.armor.bullet += 15

/datum/discipline_power/fortitude/one/deactivate()
	. = ..()
	owner.physiology.armor.melee -= 15
	owner.physiology.armor.bullet -= 15

//FORTITUDE 2
/datum/discipline_power/fortitude/two
	name = "Fortitude 2"
	desc = "Become as stone. Let nothing breach your protections."

	level = 2

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/four,
		/datum/discipline_power/fortitude/five
	)

/datum/discipline_power/fortitude/two/activate()
	. = ..()
	owner.physiology.armor.melee += 30
	owner.physiology.armor.bullet += 30

/datum/discipline_power/fortitude/two/deactivate()
	. = ..()
	owner.physiology.armor.melee -= 30
	owner.physiology.armor.bullet -= 30

//FORTITUDE 3
/datum/discipline_power/fortitude/three
	name = "Fortitude 3"
	desc = "Look down upon those who would try to kill you. Shrug off grievous attacks."

	level = 3

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/four,
		/datum/discipline_power/fortitude/five
	)

/datum/discipline_power/fortitude/three/activate()
	. = ..()
	owner.physiology.armor.melee += 45
	owner.physiology.armor.bullet += 45

/datum/discipline_power/fortitude/three/deactivate()
	. = ..()
	owner.physiology.armor.melee -= 45
	owner.physiology.armor.bullet -= 45

//FORTITUDE 4
/datum/discipline_power/fortitude/four
	name = "Fortitude 4"
	desc = "Be like steel. Walk into fire and come out only singed."

	level = 4

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/five
	)

/datum/discipline_power/fortitude/four/activate()
	. = ..()
	owner.physiology.armor.melee += 60
	owner.physiology.armor.bullet += 60

/datum/discipline_power/fortitude/four/deactivate()
	. = ..()
	owner.physiology.armor.melee -= 60
	owner.physiology.armor.bullet -= 60

//FORTITUDE 5
/datum/discipline_power/fortitude/five
	name = "Fortitude 5"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 5

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/four
	)

/datum/discipline_power/fortitude/five/activate()
	. = ..()
	owner.physiology.armor.melee += 75
	owner.physiology.armor.bullet += 75

/datum/discipline_power/fortitude/five/deactivate()
	. = ..()
	owner.physiology.armor.melee -= 75
	owner.physiology.armor.bullet -= 75
