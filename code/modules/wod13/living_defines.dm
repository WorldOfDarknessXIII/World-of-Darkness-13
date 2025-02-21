/mob/living
	var/bloodquality = 1

	var/list/drunked_of = list()

	var/total_cleaned = 0

	var/strength = 1
	var/dexterity = 1
	var/social = 1
	var/mentality = 1
	var/lockpicking = 0
	var/athletics = 0
	var/blood = 1

	var/additional_strength = 0
	var/additional_dexterity = 0
	var/additional_mentality = 0
	var/additional_social = 0
	var/additional_blood = 0
	var/additional_lockpicking = 0
	var/additional_athletics = 0
	var/more_companions = 0
	var/melee_professional = FALSE

	var/info_known = INFO_KNOWN_UNKNOWN

	var/last_message
	var/total_erp = 0

	var/no_fire_delay = FALSE

	var/experience_plus = 0
	var/discipline_time_plus = 0
	var/bloodpower_time_plus = 0
	var/thaum_damage_plus = 0

	var/resistant_to_disciplines = FALSE
	var/auspex_examine = FALSE

	var/dancing = FALSE

	var/temporis_visual = FALSE
	var/temporis_blur = FALSE

	var/frenzy_chance_boost = 10

	var/last_bloodpool_restore = 0

	var/list/knowscontacts = list()

	var/mysticism_knowledge = FALSE

	var/thaumaturgy_knowledge = FALSE

	var/elysium_checks = 0
	var/bloodhunted = FALSE

	var/hearing_ghosts = FALSE

	var/stakeimmune = FALSE

	var/last_vampire_ambience = 0
	var/wait_for_music = 30
	var/wasforced

	var/spell_immunity = FALSE

	var/isfishing = FALSE

	var/mob/parrying = null
	var/parry_class = WEIGHT_CLASS_TINY
	var/parry_cd = 0
	var/blocking = FALSE
	var/last_m_intent = MOVE_INTENT_RUN
	var/last_bloodheal_use = 0
	var/last_bloodpower_use = 0
	var/last_drinkblood_use = 0
	var/last_bloodheal_click = 0
	var/last_bloodpower_click = 0
	var/last_drinkblood_click = 0
	var/harm_focus = SOUTH
	var/masquerade_votes = 0
	var/list/voted_for = list()
	var/flavor_text
	var/true_real_name
	var/died_already = FALSE

	var/bloodpool = 5
	var/maxbloodpool = 5
	var/generation = 13
	var/humanity = 7
	var/masquerade = 5
	var/last_masquerade_violation = 0
	var/last_nonraid = 0
	var/warrant = FALSE
	var/ignores_warrant = FALSE

	var/obj/overlay/gnosis

	var/isdwarfy = FALSE
	var/ischildren = FALSE
	var/istower = FALSE

	var/total_contracted = 0

	///Whether the mob currently has the JUMP button selected
	var/prepared_to_jump = FALSE
	///If this mob can strip people from range with a delay of 0.1 seconds. Currently only activated by Mytherceria 2.
	var/enhanced_strip = FALSE

	//Kuei Jin stuff
	var/yang_chi = 2
	var/max_yang_chi = 2
	var/yin_chi = 1
	var/max_yin_chi = 1
	var/demon_chi = 0
	var/max_demon_chi = 0
	COOLDOWN_DECLARE(chi_restore)
	var/datum/action/chi_discipline/chi_ranged
