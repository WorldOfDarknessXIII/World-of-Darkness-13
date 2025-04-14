/// Any humanoid (non-Xeno) mob, such as humans, plasmamen, lizards.
/mob/living/carbon/human
	name = "Unknown"
	real_name = "Unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "human_basic"
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE|LONG_GLIDE
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ID_HUD,WANTED_HUD,IMPLOYAL_HUD,IMPCHEM_HUD,IMPTRACK_HUD, NANITE_HUD, DIAG_NANITE_FULL_HUD,ANTAG_HUD,GLAND_HUD,SENTIENT_DISEASE_HUD,FAN_HUD)
	hud_type = /datum/hud/human
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, INTENT_HARM)
	pressure_resistance = 25
	can_buckle = TRUE
	buckle_lying = 0
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	can_be_shoved_into = TRUE

	//Hair colour and style
	var/hair_color = "000"
	var/hairstyle = "Bald"

///Colour used for the hair gradient.
	var/grad_color = "000"
	///Style used for the hair gradient.
	var/grad_style

	//Facial hair colour and style
	var/facial_hair_color = "000"
	var/facial_hairstyle = "Shaved"

	//Eye colour
	var/eye_color = "000"

	var/skin_tone = "caucasian1"	//Skin tone

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup
	var/lip_color = "white"

	///Character's biological age
	var/age = 30
	///Character's chronological age
	var/chronological_age = 30

	var/underwear = "Nude"	//Which underwear the player wants
	var/underwear_color = "000"
	var/undershirt = "Nude" //Which undershirt the player wants
	var/socks = "Nude" //Which socks the player wants
	var/backpack = DBACKPACK		//Which backpack type the player has chosen.
	var/jumpsuit_style = PREF_SUIT		//suit/skirt

	//Equipment slots
	var/obj/item/clothing/wear_suit = null
	var/obj/item/clothing/w_uniform = null
	var/obj/item/belt = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/name_override //For temporary visible name changes

	var/datum/physiology/physiology

	var/list/datum/bioware = list()

	/// What types of mobs are allowed to ride/buckle to this mob
	var/static/list/can_ride_typecache = typecacheof(list(/mob/living/carbon/human, /mob/living/simple_animal/slime, /mob/living/simple_animal/parrot))
	var/lastpuke = 0
	var/last_fire_update
	var/account_id
	var/bank_id

	var/hardcore_survival_score = 0
	/// For agendered spessmen, which body type to use
	var/body_type = MALE

	/// How many "units of blood" we have on our hands
	var/blood_in_hands = 0

	/// The core temperature of the human compaired to the skin temp of the body
	var/coretemperature = BODYTEMP_NORMAL

	///Exposure to damaging heat levels increases stacks, stacks clean over time when temperatures are lower. Stack is consumed to add a wound.
	var/heat_exposure_stacks = 0

	//Shitty VtM vars I'm moving here so they're not strewn around the codebase
	var/datum/vampireclane/clane

	var/last_repainted_mark

	//var/given_penis = FALSE

	///Performs CPR on the target after a delay. //[Lucia] what does this mean?
	var/last_cpr_exp = 0

	var/dementia = FALSE

	//[Lucia] I have no clue why this is necessary, TODO: remove
	var/mob/living/caster

	var/datum/job/JOB
	var/roundstart_vampire = FALSE
	var/last_loot_check = 0

	var/phonevoicetag = 10

	var/hided = FALSE
	var/additional_hands = FALSE
	var/additional_wings = FALSE
	var/additional_centipede = FALSE
	var/additional_armor = FALSE

	var/unique_body_sprite

	var/image/suckbar
	var/atom/suckbar_loc

	var/last_showed = 0
	var/last_raid = 0
	var/killed_count = 0

	var/base_body_mod = ""
	var/icon/body_sprite

	bloodquality = 2

	var/soul_state = SOUL_PRESENT

	var/can_be_embraced = TRUE

	yang_chi = 4
	max_yang_chi = 4
	yin_chi = 2
	max_yin_chi = 2

	var/ooc_notes

	///The Examine Panel TGUI.
	var/datum/examine_panel/tgui = new() //create the datum
