/datum/discipline/bloodheal
	name = "Bloodheal"
	desc = "Use the power of your Vitae to mend your flesh."
	icon_state = "bloodheal"
	power_type = /datum/discipline_power/bloodheal
	selectable = FALSE

/datum/discipline_power/bloodheal
	name = "Bloodheal power name"
	desc = "Bloodheal power description"

	activate_sound = 'code/modules/wod13/sounds/bloodhealing.ogg'

	level = 1
	check_flags = DISC_CHECK_TORPORED
	vitae_cost = 1
	bypass_spending_limits = FALSE

	violates_masquerade = FALSE

	toggled = TRUE
	duration_length = DURATION_TURN

/datum/discipline_power/bloodheal/activate()
	//no damage at all to heal, just skip
	var/continue_power = adjust_vitae_cost(no_waste = FALSE)

	. = ..()

	if (!continue_power)
		return

	//normal bashing/lethal damage
	owner.heal_ordered_damage(20 * vitae_cost, list(BRUTE, TOX, OXY, STAMINA))

	if(length(owner.all_wounds))
		for (var/i in 1 to min(vitae_cost, length(owner.all_wounds)))
			var/datum/wound/wound = owner.all_wounds[i]
			wound.remove_wound()

	//aggravated damage
	owner.heal_ordered_damage(4 * vitae_cost, list(BURN, CLONE))

	//organ damage healing
	var/obj/item/organ/brain/brain = owner.getorganslot(ORGAN_SLOT_BRAIN)
	if (brain)
		brain.applyOrganDamage(-20 * vitae_cost)

	var/obj/item/organ/eyes/eyes = owner.getorganslot(ORGAN_SLOT_EYES)
	if (eyes)
		eyes.applyOrganDamage(-20 * vitae_cost)
		owner.adjust_blindness(-5 * vitae_cost)
		owner.adjust_blurriness(-5 * vitae_cost)

	//healing too quickly attracts attention
	if (violates_masquerade)
		owner.visible_message(
			"<span class='warning'>[owner]'s wounds heal with unnatural speed!</span>",
			"<span class='warning'>Your wounds visibly heal with unnatural speed!</span>"
		)

	//update UI
	owner.update_damage_overlays()
	owner.update_health_hud()

/datum/discipline_power/bloodheal/deactivate()
	. = ..()

	//reset vitae cost after being bumped down
	vitae_cost = initial(vitae_cost)

/datum/discipline_power/bloodheal/can_activate(atom/target, alert)
	adjust_vitae_cost(no_waste = FALSE)
	. = ..()
	vitae_cost = initial(vitae_cost)

/datum/discipline_power/bloodheal/refresh()
	if (!active)
		return
	if (!owner)
		return

	//adjust vitae costs and skip if it would just waste vitae
	if (!adjust_vitae_cost(no_waste = TRUE))
		addtimer(CALLBACK(src, PROC_REF(refresh)), duration_length)
		return

	var/repeat = FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		var/datum/species/kindred/species = human.dna.species
		if (species.can_spend_blood(human, vitae_cost))
			repeat = TRUE
		else
			to_chat(owner, "<span class='warning'>You can't spend enough blood to keep using [src]!")
	else
		if (owner.can_adjust_blood_points(-vitae_cost))
			repeat = TRUE
		else
			to_chat(owner, "<span class='warning'>You can't spend enough blood to keep using [src]!")

	if (repeat)
		COOLDOWN_START(src, duration, duration_length)
		activate()
		return

	try_deactivate()

/datum/discipline_power/bloodheal/proc/adjust_vitae_cost(no_waste = FALSE)
	vitae_cost = initial(vitae_cost)
	var/total_bashing_lethal_damage = owner.getBruteLoss() + owner.getToxLoss() + owner.getOxyLoss()
	var/total_aggravated_damage = owner.getCloneLoss() + owner.getFireLoss()

	if (total_bashing_lethal_damage + total_aggravated_damage <= 0)
		vitae_cost = 0
		return FALSE

	//not enough damage to justify spending blood this turn
	if (((total_bashing_lethal_damage < 20) && (total_aggravated_damage < 4)) && no_waste)
		return FALSE

	var/heal_bashing_lethal_left_over = (20 * vitae_cost) - total_bashing_lethal_damage
	var/heal_aggravated_left_over = (4 * vitae_cost) - total_aggravated_damage

	var/enough_damage_to_heal = (heal_bashing_lethal_left_over < 0) || (heal_aggravated_left_over < 0)
	if (!enough_damage_to_heal)
		//lower blood expenditure to what's necessary
		var/vitae_to_heal_bashing_lethal = vitae_cost - ceil(heal_bashing_lethal_left_over * 0.05)
		var/vitae_to_heal_aggravated = vitae_cost - ceil(heal_aggravated_left_over * 0.0125)
		vitae_cost = min(vitae_to_heal_bashing_lethal, vitae_to_heal_aggravated)

	return TRUE

//BLOODHEAL 1
/datum/discipline_power/bloodheal/one
	name = "Minor Bloodheal"
	desc = "Slowly mend your undead flesh."

	level = 1
	vitae_cost = 1

	violates_masquerade = FALSE

//BLOODHEAL 2
/datum/discipline_power/bloodheal/two
	name = "Bloodheal"
	desc = "Mend your undead flesh."

	level = 2
	vitae_cost = 2

	violates_masquerade = FALSE

//BLOODHEAL 3
/datum/discipline_power/bloodheal/three
	name = "Quick Bloodheal"
	desc = "Mend your undead flesh with unnatural speed."

	level = 3
	vitae_cost = 3

	violates_masquerade = TRUE

//BLOODHEAL 4
/datum/discipline_power/bloodheal/four
	name = "Major Bloodheal"
	desc = "Heal even the most grievous wounds in short order."

	level = 4
	vitae_cost = 4

	violates_masquerade = TRUE

//BLOODHEAL 5
/datum/discipline_power/bloodheal/five
	name = "Greater Bloodheal"
	desc = "Regrow entire bodyparts without breaking a sweat."

	level = 5
	vitae_cost = 5

	violates_masquerade = TRUE

//BLOODHEAL 6
/datum/discipline_power/bloodheal/six
	name = "Grand Bloodheal"
	desc = "Regrow entire bodyparts without breaking a sweat."

	level = 6
	vitae_cost = 6

	violates_masquerade = TRUE

//BLOODHEAL 7
/datum/discipline_power/bloodheal/seven
	name = "Grand Bloodheal"
	desc = "Reconstitute your body from near nothing."

	level = 7
	vitae_cost = 7

	violates_masquerade = TRUE

//BLOODHEAL 8
/datum/discipline_power/bloodheal/eight
	name = "Godlike Bloodheal"
	desc = "On the edge of Final Death, let your blood explode outwards and recreate you."

	level = 8
	vitae_cost = 8

	violates_masquerade = TRUE

//BLOODHEAL 9
/datum/discipline_power/bloodheal/nine
	name = "Surpassing Bloodheal"
	desc = "Even as a titanic beast, you could restore your physical form in short order."

	level = 9
	vitae_cost = 9

	violates_masquerade = TRUE

//BLOODHEAL 10
/datum/discipline_power/bloodheal/ten
	name = "Ascended Bloodheal"
	desc = "So long as you have access to blood, you cannot die. Your curse will not allow it."

	level = 10
	vitae_cost = 10

	violates_masquerade = TRUE
