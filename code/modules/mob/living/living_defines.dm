/mob/living
	see_invisible = SEE_INVISIBLE_LIVING
	sight = 0
	see_in_dark = 2
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ANTAG_HUD,NANITE_HUD,DIAG_NANITE_FULL_HUD)
	pressure_resistance = 10

	hud_type = /datum/hud/living

	var/resize = 1 ///Badminnery resize
	var/lastattacker = null
	var/lastattackerckey = null

	var/mob/living/lastattacked = null

	//Health and life related vars
	/// Maximum health that should be possible.
	var/maxHealth = MAX_LIVING_HEALTH
	/// The mob's current health.
	var/health = MAX_LIVING_HEALTH

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	var/bruteloss = 0	///Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	var/oxyloss = 0		///Oxygen depravation damage (no air in lungs)
	var/toxloss = 0		///Toxic damage caused by being poisoned or radiated
	var/fireloss = 0	///Burn damage caused by being way too hot, too cold or burnt.
	var/cloneloss = 0	///Damage caused by being cloned or ejected from the cloner early. slimes also deal cloneloss damage to victims
	var/staminaloss = 0		///Stamina damage, or exhaustion. You recover it slowly naturally, and are knocked down if it gets too high. Holodeck and hallucinations deal this.
	var/crit_threshold = HEALTH_THRESHOLD_CRIT /// when the mob goes from "normal" to crit
	///When the mob enters hard critical state and is fully incapacitated.
	var/hardcrit_threshold = HEALTH_THRESHOLD_FULLCRIT

	//Damage dealing vars! These are meaningless outside of specific instances where it's checked and defined.
	// Lower bound of damage done by unarmed melee attacks. Mob code is a mess, only works where this is checked for.
	var/melee_damage_lower = 0
	// Upper bound of damage done by unarmed melee attacks. Please ensure you check the xyz_defenses.dm for the mobs in question to see if it uses this or hardcoded values.
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

	var/hallucination = 0 ///Directly affects how long a mob will hallucinate for

	var/last_special = 0 ///Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.
	var/timeofdeath = 0

	/**
	  * Allows mobs to move through dense areas without restriction. For instance, in space or out of holder objects.
	  *
	  * FALSE is off, [INCORPOREAL_MOVE_BASIC] is normal, [INCORPOREAL_MOVE_SHADOW] is for ninjas
	  * and [INCORPOREAL_MOVE_JAUNT] is blocked by holy water/salt
	  */
	var/incorporeal_move = FALSE

	var/list/roundstart_quirks = list()

	var/list/surgeries = list()	///a list of surgery datums. generally empty, they're added when the player wants them.

	var/now_pushing = null //! Used by [living/Bump()][/mob/living/proc/Bump] and [living/PushAM()][/mob/living/proc/PushAM] to prevent potential infinite loop.

	var/cameraFollow = null

	var/tod = null /// Time of death

	var/on_fire = FALSE ///The "Are we on fire?" var
	var/fire_stacks = 0 ///Tracks how many stacks of fire we have on, max is usually 20

	var/ventcrawler = 0 //0 No vent crawling, 1 vent crawling in the nude, 2 vent crawling always
	var/limb_destroyer = 0 //1 Sets AI behavior that allows mobs to target and dismember limbs with their basic attack.

	var/mob_size = MOB_SIZE_HUMAN
	var/mob_biotypes = MOB_ORGANIC
	var/metabolism_efficiency = 1 ///more or less efficiency to metabolize helpful/harmful reagents and regulate body temperature..
	var/has_limbs = 0 ///does the mob have distinct limbs?(arms,legs, chest,head)

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
	var/last_played_vent

	var/smoke_delay = 0 ///used to prevent spam with smoke reagent reaction on mob.

	var/bubble_icon = "default" ///what icon the mob uses for speechbubbles
	var/health_doll_icon ///if this exists AND the normal sprite is bigger than 32x32, this is the replacement icon state (because health doll size limitations). the icon will always be screen_gen.dmi

	var/last_bumped = 0
	var/unique_name = FALSE ///if a mob's name should be appended with an id when created e.g. Mob (666)
	var/numba = 0 ///the id a mob gets when it's created

	var/list/butcher_results = null ///these will be yielded from butchering with a probability chance equal to the butcher item's effectiveness
	var/list/guaranteed_butcher_results = null ///these will always be yielded from butchering
	var/butcher_difficulty = 0 ///effectiveness prob. is modified negatively by this amount; positive numbers make it more difficult, negative ones make it easier

	var/list/weather_immunities

	var/stun_absorption = null ///converted to a list of stun absorption sources this mob has when one is added

	var/blood_volume = 0 ///how much blood the mob has
	var/obj/effect/proc_holder/ranged_ability ///Any ranged ability the mob has, as a click override

	var/see_override = 0 ///0 for no override, sets see_invisible = see_override in silicon & carbon life process via update_sight()

	var/list/status_effects ///a list of all status effects the mob has
	var/druggy = 0

	//Speech
	var/stuttering = 0
	var/slurring = 0
	var/cultslurring = 0
	var/derpspeech = 0

	var/list/implants = null

	var/last_words	///used for database logging

	var/list/obj/effect/proc_holder/abilities = list()

	var/can_be_held = FALSE	//whether this can be picked up and held.
	var/worn_slot_flags = NONE //if it can be held, can it be equipped to any slots? (think pAI's on head)

	var/radiation = 0 ///If the mob is irradiated.
	var/ventcrawl_layer = PIPING_LAYER_DEFAULT
	var/losebreath = 0

	//List of active diseases
	var/list/diseases /// list of all diseases in a mob
	var/list/disease_resistances

	var/slowed_by_drag = TRUE ///Whether the mob is slowed down when dragging another prone mob

	/// List of changes to body temperature, used by desease symtoms like fever
	var/list/body_temp_changes = list()

	//this stuff is here to make it simple for admins to mess with custom held sprites
	var/icon/held_lh = 'icons/mob/pets_held_lh.dmi'//icons for holding mobs
	var/icon/held_rh = 'icons/mob/pets_held_rh.dmi'
	var/icon/head_icon = 'icons/mob/pets_held.dmi'//what it looks like on your head
	var/held_state = ""//icon state for the above

	/// Is this mob allowed to be buckled/unbuckled to/from things?
	var/can_buckle_to = TRUE

	///The y amount a mob's sprite should be offset due to the current position they're in (e.g. lying down moves your sprite down)
	var/body_position_pixel_x_offset = 0
	///The x amount a mob's sprite should be offset due to the current position they're in
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
	var/additional_mentality = 0
	var/additional_social = 0
	var/additional_blood = 0
	var/more_companions = 0
	var/melee_professional = FALSE

	var/last_message
	var/total_erp = 0

	var/last_taste_time
	var/last_taste_text

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

	var/vampire_faction

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

	var/obj/overlay/gnosis

	var/isdwarfy = FALSE
	var/ischildren = FALSE
	var/istower = FALSE

	var/total_contracted = 0

	///Whether the mob currently has the JUMP button selected
	var/prepared_to_jump = FALSE
	///Allows Gargoyles to move through solid objects using Visceratika 5.
	var/gargoyle_pass = FALSE
	///If this mob can strip people from range with a delay of 0.1 seconds. Currently only activated by Mytherceria 2.
	var/enhanced_strip = FALSE
