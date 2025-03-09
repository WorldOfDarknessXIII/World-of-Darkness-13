/datum/splat/supernatural/kindred
	splat_id = "kindred"
	splat_traits = list(
		TRAIT_VIRUSIMMUNE,	//PSEUDO_M_K kindred can spread disease, amend this
		TRAIT_NOBLEED,		//PSEUDO_M_K we need to account for losing vitae to massive damage
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOCRITDAMAGE,
	)
	splat_flag = KINDRED_SPLAT
	splat_actions = list(
		/datum/action/my_info/kindred,
	)
	power_stat_name = "Vitae"
	power_stat_max = 5
	power_stat_current = 5
	integrity = /datum/integrity_tracker/humanity
	var/generation = 13
	var/dust_anim = "dust-h"
	var/spend_blood_per_turn = 1
	var/spent_blood_turn = 0
	var/datum/vampireclane/clane
	COOLDOWN_DECLARE(torpor_timer)
	COOLDOWN_DECLARE(violated_masquerade)
	var/datum/vampireclane/clane					//
	var/masquerade = 5								//
	selectable = TRUE
	damage_mods = list(
		"brute" = 0.5,
		"burn" = 2,
	)

/datum/splat/supernatural/kindred/on_apply()
	//Special handling here since we subtype the ghoul splat from the kindred splat
	if(splat_flag & KINDRED_SPLAT)
		splat_signals = list(
		PROC_REF(on_vampire_bitten) = COMSIG_MOB_VAMPIRE_SUCKED,
		PROC_REF(lose_organ) = COMSIG_CARBON_LOSE_ORGAN,
		PROC_REF(slip_into_torpor) = SIGNAL_ADDTRAIT(TRAIT_CRITICAL_CONDITION),
		)
	..()


///A proc to handle the special case of a ghoul being turned into a vampire so they don't lose relevant discipline knowledge
///And such
/datum/splat/supernatural/kindred/proc/handle_ghoul_uplift(datum/splat/supernatural/kindred/ghoul/uplifted_splat)
	#warn "implement this"
	return TRUE

/datum/action/my_info/kindred
	name = "About Me"
	desc = "Check assigned role, clan, generation, humanity, masquerade, known disciplines, known contacts etc."
	button_icon_state = "masquerade"
	check_flags = NONE

/datum/action/my_info/kindred/Trigger()
	#warn "implement this"

/datum/splat/supernatural/kindred/on_apply()
	..()

	initialize_generation(my_character)

	var/datum/action/give_vitae/vitae = new()
	vitae.Grant(my_character)

	var/datum/action/blood_power/bloodpower = new()
	bloodpower.Grant(my_character)
	var/datum/discipline/bloodheal/giving_bloodheal = new(clamp(spend_blood_per_turn, 1, 10))
	give_discipline(giving_bloodheal)



/datum/splat/supernatural/kindred/on_remove()

	//UnregisterSignal(C, COMSIG_MOB_VAMPIRE_SUCKED)
	..()
	#warn "implement this"

/datum/action/blood_power
	name = "Blood Power"
	desc = "Use vitae to gain supernatural abilities."
	button_icon_state = "bloodpower"
	button_icon = 'code/modules/wod13/UI/actions.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/actions.dmi'
	vampiric = TRUE

/datum/action/blood_power/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(owner)
		if(owner.client)
			if(owner.client.prefs)
				if(owner.client.prefs.old_discipline)
					button_icon = 'code/modules/wod13/disciplines.dmi'
					icon_icon = 'code/modules/wod13/disciplines.dmi'
				else
					button_icon = 'code/modules/wod13/UI/actions.dmi'
					icon_icon = 'code/modules/wod13/UI/actions.dmi'
	. = ..()

/datum/action/blood_power/Trigger()
	#warn "implement this"

/datum/action/give_vitae
	name = "Give Vitae"
	desc = "Give your vitae to someone, make the Blood Bond."
	button_icon_state = "vitae"
	vampiric = TRUE
	var/giving = FALSE

/datum/action/give_vitae/Trigger()
	#warn "implement this"

/**
 * Initialises Disciplines for new vampire mobs, applying effects and creating action buttons.
 *
 * If discipline_pref is true, it grabs all of the source's Disciplines from their preferences
 * and applies those using the give_discipline() proc. If false, it instead grabs a given list
 * of Discipline typepaths and initialises those for the character. Only works for ghouls and
 * vampires, and it also applies the Clan's post_gain() effects
 *
 * Arguments:
 * * discipline_pref - Whether Disciplines will be taken from preferences. True by default.
 * * disciplines - list of Discipline typepaths to grant if discipline_pref is false.
 */
/mob/living/carbon/human/proc/create_disciplines(discipline_pref = TRUE, list/disciplines)	//EMBRACE BASIC
	#warn "implement this"

/**
 * Creates an action button and applies post_gain effects of the given Discipline.
 *
 * Arguments:
 * * discipline - Discipline datum that is being given to this mob.
 */
/datum/splat/supernatural/kindred/proc/give_discipline(datum/discipline/discipline)
	#warn "implement this"


/mob/living/carbon/human/proc/give_chi_discipline(datum/chi_discipline/discipline)
	#warn "implement this"

/datum/splat/supernatural/kindred/check_roundstart_eligible()
	#warn "implement this"


/**
 * Signal handler for lose_organ to near-instantly kill Kindred whose hearts have been removed.
 *
 * Arguments:
 * * source - The Kindred whose organ has been removed.
 * * organ - The organ which has been removed.
 */
/datum/splat/supernatural/kindred/proc/lose_organ(var/mob/living/carbon/human/source, var/obj/item/organ/organ)
	SIGNAL_HANDLER

	if (istype(organ, /obj/item/organ/heart))
		spawn()
			if (!source.getorganslot(ORGAN_SLOT_HEART))
				source.death()

/datum/splat/supernatural/kindred/proc/slip_into_torpor(mob/living/carbon/human/source)
	SIGNAL_HANDLER

	#warn "implement this"

/datum/splat/supernatural/kindred/proc/handle_fire()
	my_character.adjustFireLoss(my_character.maxHealth * 0.02)

/**
 * Checks a vampire for whitelist access to a Discipline.
 *
 * Checks the given vampire to see if they have access to a certain Discipline through
 * one of their selectable Clans. This is only necessary for "unique" or Clan-restricted
 * Disciplines, as those have a chance to only be available to a certain Clan that
 * the vampire may or may not be whitelisted for.
 *
 * Arguments:
 * * vampire_checking - The vampire mob being checked for their access.
 * * discipline_checking - The Discipline type that access to is being checked.
 */
/proc/can_access_discipline(mob/living/carbon/human/vampire_checking, discipline_checking)
	if (!iskindred(vampire_checking))
		return FALSE
	if (!vampire_checking.client)
		return FALSE

	//make sure it's actually restricted and this check is necessary
	var/datum/discipline/discipline_object_checking = new discipline_checking
	if (!discipline_object_checking.clan_restricted)
		qdel(discipline_object_checking)
		return TRUE
	qdel(discipline_object_checking)

	//first, check their Clan Disciplines to see if that gives them access
	if (vampire_checking.clane.clane_disciplines.Find(discipline_checking))
		return TRUE

	//next, go through all Clans to check if they have access to any with the Discipline
	for (var/clan_type in subtypesof(/datum/vampireclane))
		var/datum/vampireclane/clan_checking = new clan_type

		//skip this if they can't access it due to whitelists
		if (clan_checking.whitelisted)
			if (!SSwhitelists.is_whitelisted(checked_ckey = vampire_checking.ckey, checked_whitelist = clan_checking.name))
				qdel(clan_checking)
				continue

		if (clan_checking.clane_disciplines.Find(discipline_checking))
			qdel(clan_checking)
			return TRUE

		qdel(clan_checking)

	//nothing found
	return FALSE

/datum/splat/supernatural/kindred/proc/handle_death(datum/source)
	#warn "implement this"
	//dust if old
	//broadcast to witnesses

/datum/keybinding/human/bite // PSEUDO_M_K need to add vampire section to controls
	hotkey_keys = list("F")
	name = "bite"
	full_name = "Bite"
	description = "Bite whoever you're aggressively grabbing, and feed on them if possible."
	keybind_signal = COMSIG_KB_HUMAN_BITE_DOWN

/datum/keybinding/human/bite/down(client/user)
	. = ..()
	#warn "implement this"
	//SEND_SIGNAL(user, COMSIG_HUMAN_ATTEMPT_BITE)

/*
/mob/living/carbon/human/Life()
	update_blood_hud()
	update_zone_hud()
	update_rage_hud()
	update_shadow()
	handle_vampire_music()
	update_auspex_hud()*/
	//PSEUDO_M update huds

/mob/living/proc/update_blood_hud()
	#warn "implement this"

/atom/movable/screen/blood
	name = "bloodpool"
	icon = 'code/modules/wod13/UI/bloodpool.dmi'
	icon_state = "blood0"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/blood/Click()
	. = ..()
	#warn "implement this"

/datum/action/drinkblood
	name = "Drink blood."
	desc = "Bite whatever you have in a strong grab, and drink."
	button_icon_state = "ghoul"

/datum/action/drinkblood/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(owner.pulling) || owner.grab_state < GRAB_AGGRESSIVE)
		to_chat(owner, "<span class='warning'>You need to be aggressively grabbing something living to drink blood.</span>")
		return FALSE
	var/mob/living/victim = owner.pulling
	bite(owner, victim)
	. = ..()

/datum/action/drinkblood/proc/add_bite_animation(mob/living/carbon/victim)
	victim.remove_overlay(BITE_LAYER)
	var/mutable_appearance/bite_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "bite", -BITE_LAYER)
	victim.overlays_standing[BITE_LAYER] = bite_overlay
	victim.apply_overlay(BITE_LAYER)
	spawn(1.5 SECONDS)
		if(src)
			victim.remove_overlay(BITE_LAYER)

/datum/action/drinkblood/proc/bite(mob/living/biter, mob/living/victim)

	#warn "implement this"
	//bite anim
	//witness broadcast

/datum/action/drinkblood/proc/drink_blood(mob/living/bloodsucker, mob/living/juicebox)

/**
 * On being bit by a vampire
 *
 * This handles vampire bite sleep immunity and any future special interactions.
 */
/datum/splat/supernatural/kindred/proc/on_vampire_bitten(datum/source, mob/living/carbon/being_bitten)
	SIGNAL_HANDLER

	if(iskindred(being_bitten))
		return COMPONENT_RESIST_VAMPIRE_KISS


/datum/splat/supernatural/kindred/proc/initialize_generation(mob/living/carbon/human/vampire)
	if (iskindred(vampire) && vampire.generation)
		var/old_max_bloodpool = vampire.maxbloodpool
		switch(vampire.generation)
			if (1)
				vampire.maxbloodpool = 1000
				spend_blood_per_turn = 1000
			if (2)
				vampire.maxbloodpool = 150
				spend_blood_per_turn = 30
			if (3)
				vampire.maxbloodpool = 100
				spend_blood_per_turn = 20
			if (4)
				vampire.maxbloodpool = 50
				spend_blood_per_turn = 10
			if (5)
				vampire.maxbloodpool = 40
				spend_blood_per_turn = 8
			if (6)
				vampire.maxbloodpool = 30
				spend_blood_per_turn = 6
			if (7)
				vampire.maxbloodpool = 20
				spend_blood_per_turn = 4
			if (8)
				vampire.maxbloodpool = 15
				spend_blood_per_turn = 3
			if (9)
				vampire.maxbloodpool = 14
				spend_blood_per_turn = 2
			if (10)
				vampire.maxbloodpool = 13
				spend_blood_per_turn = 1
			if (11)
				vampire.maxbloodpool = 12
				spend_blood_per_turn = 1
			if (12)
				vampire.maxbloodpool = 11
				spend_blood_per_turn = 1
			else //no thinblood support just yet
				vampire.maxbloodpool = 10
				spend_blood_per_turn = 1

		//forces blood_volume into line with new blood potency
		if (old_max_bloodpool != vampire.maxbloodpool)
			var/old_bloodpool = vampire.bloodpool
			vampire.update_blood_values()
			vampire.set_blood_points(old_bloodpool)

		//adjust to new generational levels
		/*var/datum/discipline/bloodheal/bloodheal = get_discipline(/datum/discipline/bloodheal)
		if (bloodheal) PSEUDO_M handle bloodheal setting for generation
			bloodheal.set_level(clamp(spend_blood_per_turn, 1, 10))*/
		#warn "implement this"

/datum/splat/supernatural/kindred/proc/can_spend_blood(mob/living/carbon/human/vampire, amount)
	if ((spent_blood_turn + amount) > spend_blood_per_turn)
		return FALSE
	if (!vampire.can_adjust_blood_points(-amount))
		return FALSE
	return TRUE

/datum/splat/supernatural/kindred/proc/spend_blood(mob/living/carbon/human/vampire, amount)
	spent_blood_turn += amount
	vampire.adjust_blood_points(-amount)
	//one decisecond shorter than a turn to allow powers to refresh on a full turn basis
	addtimer(CALLBACK(src, PROC_REF(refresh_spent_blood), amount), DURATION_TURN - 1)

/datum/splat/supernatural/kindred/proc/try_spend_blood(mob/living/carbon/human/vampire, amount)
	if (can_spend_blood(vampire, amount))
		spend_blood(vampire, amount)
		return TRUE
	return FALSE

/datum/splat/supernatural/kindred/proc/refresh_spent_blood(amount)
	spent_blood_turn -= amount

/datum/splat/supernatural/kindred/proc/AdjustMasquerade()
	return TRUE
	#warn "implement this"
