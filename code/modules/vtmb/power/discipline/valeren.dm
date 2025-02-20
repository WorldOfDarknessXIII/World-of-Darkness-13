/datum/discipline/valeren
	name = "Healer Valeren"
	desc = "Use your third eye in healing or protecting needs."
	icon_state = "valeren"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/valeren

/datum/discipline_power/valeren
	name = "Valeren power name"
	desc = "Valeren power description"

	activate_sound = 'code/modules/wod13/sounds/valeren.ogg'

//SENSE VITALITY
/datum/discipline_power/valeren/sense_vitality
	name = "Sense Vitality"
	desc = "Discipline power description"

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_FREE_HAND
	target_type = TARGET_MOB
	range = 1

	cooldown_length = 5 SECONDS

/datum/discipline_power/valeren/sense_vitality/activate(mob/living/target)
	. = ..()
	healthscan(owner, target, 1, FALSE)
	chemscan(owner, target)
	to_chat(owner, "<b>[target]</b> has <b>[num2text(target.bloodpool)]/[target.maxbloodpool]</b> blood points.")
	to_chat(owner, "<b>[target]</b> has a rating of <b>[target.humanity]</b> on their path.")

//ANESTHETIC TOUCH
/datum/discipline_power/valeren/anesthetic_touch
	name = "Anesthetic Touch"
	desc = "Soothe your patient's pain, or put them to peaceful sleep."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_LYING | DISC_CHECK_FREE_HAND
	target_type = TARGET_LIVING
	range = 1

	aggravating = TRUE
	hostile = TRUE

	cooldown_length = 10 SECONDS

/datum/discipline_power/valeren/anesthetic_touch/activate(mob/living/target)
	. = ..()
	//I'm not a fan of how punishing this is towards human players, but not my job to rework it
	//refactor this when the species refactoring comes through
	if (ishumanbasic(target))
		target.SetSleeping(15 SECONDS)
	else
		target.add_confusion(5)
		target.drowsyness += 4

//CORPORE SANO
/datum/discipline_power/valeren/corpore_sano
	name = "Corpore Sano"
	desc = "Lay hands on your patient and heal their wounds."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 1

	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS

/datum/discipline_power/valeren/corpore_sano/activate(mob/living/target)
	. = ..()
	owner.Beam(target, icon_state="sm_arc", time = 5 SECONDS, maxdistance = 9, beam_type = /obj/effect/ebeam/medical)
	target.adjustBruteLoss(-50, TRUE)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(length(human_target.all_wounds))
			var/datum/wound/wound = pick(human_target.all_wounds)
			wound.remove_wound()
	target.adjustFireLoss(-50, TRUE)
	target.update_damage_overlays()
	target.update_health_hud()

//SHEPHERD'S WATCH
/datum/discipline_power/valeren/shepherds_watch
	name = "Shepherd's Watch"
	desc = "Create a supernatural barrier to protect yourself from harm."

	level = 4

	cooldown_length = 40 SECONDS

/datum/discipline_power/valeren/shepherds_watch/activate()
	. = ..()
	for (var/turf/turf in orange(1, get_turf(owner)))
		new /obj/effect/forcefield/wizard(turf, owner)

//UNBURDEN THE BESTIAL SOUL
/datum/discipline_power/valeren/unburden_the_bestial_soul
	name = "Unburden The Bestial Soul"
	desc = "Draw out a Kindred's soul and heal it of impurities."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_FREE_HAND
	target_type = TARGET_LIVING
	range = 1

	cooldown_length = 5 SECONDS

	var/points_can_restore = 3

/datum/discipline_power/valeren/unburden_the_bestial_soul/can_activate_untargeted(alert)
	. = ..()

	if (points_can_restore <= 0)
		if (alert)
			to_chat(owner, "<span class='warning'>You've exhausted yourself too much to cleanse more souls.</span>")
		return FALSE

	return .

/datum/discipline_power/valeren/unburden_the_bestial_soul/can_activate(mob/living/target, alert)
	. = ..()

	if (!iskindred(target))
		if (alert)
			to_chat(owner, "<span class='warning'>[src] can only be used on Kindred.</span>")
		return FALSE

	if (!target.client)
		if (alert)
			to_chat(owner, "<span class='warning'>[target] does not have a soul to cleanse!</span>")
		return FALSE

	if (target.humanity >= 10 && !target.client?.prefs?.enlightenment)
		if (alert)
			to_chat(owner, "<span class='warning'>[target]'s soul is already completely pure.</span>")
		return FALSE

	return .

/datum/discipline_power/valeren/unburden_the_bestial_soul/pre_activation(mob/living/carbon/human/target)
	//overrides should take care to still send and receive these signals! copy and paste this!
	var/signal_return = SEND_SIGNAL(src, COMSIG_POWER_PRE_ACTIVATION, target) | SEND_SIGNAL(owner, COMSIG_POWER_PRE_ACTIVATION, target)
	if (target)
		signal_return |= SEND_SIGNAL(target, COMSIG_POWER_PRE_ACTIVATION_ON)
	if (signal_return & POWER_CANCEL_ACTIVATION)
		//feedback is sent by the proc cancelling activation
		return

	to_chat(owner, "<span class='warning'>You begin cleansing [target]'s soul...</span>")
	if (do_mob(owner, target, 10 SECONDS))
		activate(target)

/datum/discipline_power/valeren/unburden_the_bestial_soul/activate(mob/living/carbon/human/target)
	. = ..()
	to_chat(owner, "<span class='notice'>You have healed [target]'s soul slightly.</span>")
	target.AdjustHumanity(1, 10)
	points_can_restore--


