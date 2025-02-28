/mob/living
	see_invisible = SEE_INVISIBLE_LIVING
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ANTAG_HUD)
	pressure_resistance = 10
	hud_type = /datum/hud/living
	interaction_flags_click = ALLOW_RESTING
	interaction_flags_mouse_drop = ALLOW_RESTING

	///Tracks the current size of the mob in relation to its original size. Use update_transform(resize) to change it.
	var/current_size = RESIZE_DEFAULT_SIZE
	var/lastattacker = null
	var/lastattackerckey = null

	var/mob/living/lastattacked = null

	//Health and life related vars
	/// Maximum health that should be possible.
	var/maxHealth = MAX_LIVING_HEALTH
	/// The mob's current health.
	var/health = MAX_LIVING_HEALTH

	/// The max amount of stamina damage we can have at once (Does NOT effect stamcrit thresholds. See crit_threshold)
	var/max_stamina = 120
	///Stamina damage, or exhaustion. You recover it slowly naturally, and are knocked down if it gets too high. Holodeck and hallucinations deal this.
	var/staminaloss = 0

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	///Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	var/bruteloss = 0
	///Oxygen depravation damage (no air in lungs)
	var/oxyloss = 0
	///Toxic damage caused by being poisoned or radiated
	var/toxloss = 0
	///Burn damage caused by being way too hot, too cold or burnt.
	var/fireloss = 0

	/// The movement intent of the mob (run/wal)
	var/move_intent = MOVE_INTENT_RUN

	/// Rate at which fire stacks should decay from this mob
	var/fire_stack_decay_rate = -0.05

	/// when the mob goes from "normal" to crit
	var/crit_threshold = HEALTH_THRESHOLD_CRIT
	///When the mob enters hard critical state and is fully incapacitated.
	var/hardcrit_threshold = HEALTH_THRESHOLD_FULLCRIT

	//Damage dealing vars! These are meaningless outside of specific instances where it's checked and defined.
	/// Lower bound of damage done by unarmed melee attacks. Mob code is a mess, only works where this is checked for.
	var/melee_damage_lower = 0
	/// Upper bound of damage done by unarmed melee attacks. Please ensure you check the xyz_defenses.dm for the mobs in question to see if it uses this or hardcoded values.
	var/melee_damage_upper = 0

	/// Generic bitflags for boolean conditions at the [/mob/living] level. Keep this for inherent traits of living types, instead of runtime-changeable ones.
	var/living_flags = NONE

	/// Flags that determine the potential of a mob to perform certain actions. Do not change this directly.
	var/mobility_flags = MOBILITY_FLAGS_DEFAULT

	var/resting = FALSE

	/// Variable to track the body position of a mob, regardgless of the actual angle of rotation (usually matching it, but not necessarily).
	var/body_position = STANDING_UP
	/// Number of degrees of rotation of a mob. 0 means no rotation, up-side facing NORTH. 90 means up-side rotated to face EAST, and so on.
	var/lying_angle = 0
	/// Value of lying lying_angle before last change. TODO: Remove the need for this.
	var/lying_prev = 0
	/// Does the mob rotate when lying
	var/rotate_on_lying = FALSE
	///Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.
	var/last_special = 0

	///A message sent when the mob dies, with the *deathgasp emote
	var/death_message = ""
	///A sound sent when the mob dies, with the *deathgasp emote
	var/death_sound

	/// Helper vars for quick access to firestacks, these should be updated every time firestacks are adjusted
	var/on_fire = FALSE
	var/fire_stacks = 0

	/**
	  * Allows mobs to move through dense areas without restriction. For instance, in space or out of holder objects.
	  *
	  * FALSE is off, [INCORPOREAL_MOVE_BASIC] is normal, [INCORPOREAL_MOVE_SHADOW] is for ninjas
	  * and [INCORPOREAL_MOVE_JAUNT] is blocked by holy water/salt
	  */
	var/incorporeal_move = FALSE

	var/list/quirks = list()
	///a list of surgery datums. generally empty, they're added when the player wants them.
	var/list/surgeries = list()
	///Mob specific surgery speed modifier
	var/mob_surgery_speed_mod = 1

	/// Used by [living/Bump()][/mob/living/proc/Bump] and [living/PushAM()][/mob/living/proc/PushAM] to prevent potential infinite loop.
	var/now_pushing = null

	///The mob's latest time-of-death
	var/timeofdeath = 0
	///The mob's latest time-of-death, as a station timestamp instead of world.time
	var/station_timestamp_timeofdeath

	/// Sets AI behavior that allows mobs to target and dismember limbs with their basic attack.
	var/limb_destroyer = 0

	var/mob_size = MOB_SIZE_HUMAN
	/// List of biotypes the mob belongs to. Used by diseases and reagents mainly.
	var/mob_biotypes = MOB_ORGANIC
	/// The type of respiration the mob is capable of doing. Used by adjustOxyLoss.
	var/mob_respiration_type = RESPIRATION_OXYGEN
	///more or less efficiency to metabolize helpful/harmful reagents and regulate body temperature..
	var/metabolism_efficiency = 1
	///does the mob have distinct limbs?(arms,legs, chest,head)
	var/has_limbs = FALSE

	///How many legs does this mob have by default. This shouldn't change at runtime.
	var/default_num_legs = 2
	///How many legs does this mob currently have. Should only be changed through set_num_legs()
	var/num_legs = 2
	///How many usable legs this mob currently has. Should only be changed through set_usable_legs()
	var/usable_legs = 2

	///How many hands does this mob have by default. This shouldn't change at runtime.
	var/default_num_hands = 2
	///How many hands hands does this mob currently have. Should only be changed through set_num_hands()
	var/num_hands = 2
	///How many usable hands does this mob currently have. Should only be changed through set_usable_hands()
	var/usable_hands = 2

	var/list/pipes_shown = list()
	var/last_played_vent = 0
	/// The last direction we moved in a vent. Used to make holding two directions feel nice
	var/last_vent_dir = 0
	/// Cell tracker datum we use to manage the pipes around us, for faster ventcrawling
	/// Should only exist if you're in a pipe
	var/datum/cell_tracker/pipetracker

	var/smoke_delay = 0 ///used to prevent spam with smoke reagent reaction on mob.

	///what icon the mob uses for speechbubbles
	var/bubble_icon = "default"
	///if this exists AND the normal sprite is bigger than 32x32, this is the replacement icon state (because health doll size limitations). the icon will always be screen_gen.dmi
	var/health_doll_icon

	var/last_bumped = 0
	///if a mob's name should be appended with an id when created e.g. Mob (666)
	var/unique_name = FALSE
	///the id a mob gets when it's created
	var/numba = 0

	///these will be yielded from butchering with a probability chance equal to the butcher item's effectiveness
	var/list/butcher_results = null
	///these will always be yielded from butchering
	var/list/guaranteed_butcher_results = null
	///effectiveness prob. is modified negatively by this amount; positive numbers make it more difficult, negative ones make it easier
	var/butcher_difficulty = 0

	///how much blood the mob has
	var/blood_volume = 0

	///a list of all status effects the mob has
	var/list/status_effects
	var/list/implants = null

	///used for database logging
	var/last_words

	///whether this can be picked up and held.
	var/can_be_held = FALSE
	/// The w_class of the holder when held.
	var/held_w_class = WEIGHT_CLASS_NORMAL
	///if it can be held, can it be equipped to any slots? (think pAI's on head)
	var/worn_slot_flags = NONE

	var/ventcrawl_layer = PIPING_LAYER_DEFAULT
	var/losebreath = 0

	//List of active diseases
	/// list of all diseases in a mob
	var/list/diseases
	var/list/disease_resistances

	///Whether the mob is slowed down when dragging another prone mob
	var/slowed_by_drag = TRUE

	/// List of changes to body temperature, used by desease symtoms like fever
	var/list/body_temp_changes = list()

	//this stuff is here to make it simple for admins to mess with custom held sprites
	///left hand icon for holding mobs
	var/icon/held_lh = 'icons/mob/inhands/pets_held_lh.dmi'
	///right hand icon for holding mobs
	var/icon/held_rh = 'icons/mob/inhands/pets_held_rh.dmi'
	///what it looks like when the mob is held on your head
	var/icon/head_icon = 'icons/mob/clothing/head/pets_head.dmi'
	/// icon_state for holding mobs.
	var/held_state = ""

	///If combat mode is on or not
	var/combat_mode = FALSE

	/// Is this mob allowed to be buckled/unbuckled to/from things?
	var/can_buckle_to = TRUE

	///The x amount a mob's sprite should be offset due to the current position they're in
	var/body_position_pixel_x_offset = 0
	///The y amount a mob's sprite should be offset due to the current position they're in or size (e.g. lying down moves your sprite down)
	var/body_position_pixel_y_offset = 0

	//Shitty VtM vars I'm moving here so they're not strewn around the codebase
	var/bloodquality = 1

	var/list/drunked_of = list()

	var/total_cleaned = 0

	var/physique = 1
	var/dexterity = 1
	var/social = 1
	var/mentality = 1
	var/lockpicking = 0
	var/athletics = 0
	var/blood = 1

	var/additional_physique = 0
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

	var/last_taste_time
	var/last_taste_text

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

	///The height offset of a mob's maptext due to their current size.
	var/body_maptext_height_offset = 0

	/// FOV view that is applied from either nativeness or traits
	var/fov_view
	/// Lazy list of FOV traits that will apply a FOV view when handled.
	var/list/fov_traits
	///what multiplicative slowdown we get from turfs currently.
	var/current_turf_slowdown = 0

	/// Is the mob looking vertically
	var/looking_vertically = FALSE

	/// Living mob's mood datum
	var/datum/mood/mob_mood

	// Multiple imaginary friends!
	/// Contains the owner and all imaginary friend mobs if they exist, otherwise null
	var/list/imaginary_group = null

	/// What our current gravity state is. Used to avoid duplicate animates and such
	var/gravity_state = null

	/// How long it takes to return to 0 stam
	var/stamina_regen_time = 10 SECONDS
