/datum/discipline/auspex
	name = "Auspex"
	desc = "Allows to see entities, auras and their health through walls."
	icon_state = "auspex"
	power_type = /datum/discipline_power/auspex

/datum/discipline_power/auspex
	name = "Auspex power name"
	desc = "Auspex power description"

	check_flags = DISC_CHECK_CONSCIOUS

	activate_sound = 'code/modules/wod13/sounds/auspex.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/auspex_deactivate.ogg'

	toggled = TRUE
	duration_length = 30 SECONDS

/datum/discipline_power/auspex/activate()
	. = ..()
	owner.add_client_colour(/datum/client_colour/glass_colour/lightblue)
	owner.update_sight()

/datum/discipline_power/auspex/deactivate()
	. = ..()
	owner.remove_client_colour(/datum/client_colour/glass_colour/lightblue)
	owner.update_sight()

//HEIGHTENED SENSES
/datum/discipline_power/auspex/heightened_senses
	name = "Heightened Senses"
	desc = "Enhances your senses far past human limitations."

	level = 1

/datum/discipline_power/auspex/heightened_senses/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
	ADD_TRAIT(owner, TRAIT_NIGHT_VISION, TRAIT_GENERIC)

/datum/discipline_power/auspex/heightened_senses/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_NIGHT_VISION, TRAIT_GENERIC)

//AURA PERCEPTION
/datum/discipline_power/auspex/aura_perception
	name = "Aura Perception"
	desc = "Allows you to perceive the auras of those near you."

	level = 2

/datum/discipline_power/auspex/aura_perception/activate()
	. = ..()
	var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	abductor_hud.add_hud_to(owner)

/datum/discipline_power/auspex/aura_perception/deactivate()
	. = ..()
	var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	abductor_hud.remove_hud_from(owner)

//THE SPIRIT'S TOUCH
/datum/discipline_power/auspex/the_spirits_touch
	name = "The Spirit's Touch"
	desc = "Allows you to feel the physical wellbeing of those near you."

	level = 3

/datum/discipline_power/auspex/the_spirits_touch/activate()
	. = ..()
	var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	health_hud.add_hud_to(owner)

/datum/discipline_power/auspex/the_spirits_touch/deactivate()
	. = ..()
	var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	health_hud.remove_hud_from(owner)

//TELEPATHY
/datum/discipline_power/auspex/telepathy
	name = "Telepathy"
	desc = "Feel the psychic resonances left on objects you can touch."

	level = 4

/datum/discipline_power/auspex/telepathy/activate()
	. = ..()
	owner.auspex_examine = TRUE

/datum/discipline_power/auspex/telepathy/deactivate()
	. = ..()
	owner.auspex_examine = FALSE

//sobs loudly
//rework me
/atom/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/Z = user
		if(Z.auspex_examine)
			if(!isturf(src) && !isobj(src) && !ismob(src))
				return
			var/list/fingerprints = list()
			var/list/blood = return_blood_DNA()
			var/list/fibers = return_fibers()
			var/list/reagents = list()

			if(ishuman(src))
				var/mob/living/carbon/human/H = src
				if(!H.gloves)
					fingerprints += md5(H.dna.uni_identity)

			else if(!ismob(src))
				fingerprints = return_fingerprints()


				if(isturf(src))
					var/turf/T = src
					// Only get reagents from non-mobs.
					if(T.reagents && T.reagents.reagent_list.len)

						for(var/datum/reagent/R in T.reagents.reagent_list)
							T.reagents[R.name] = R.volume

							// Get blood data from the blood reagent.
							if(istype(R, /datum/reagent/blood))

								if(R.data["blood_DNA"] && R.data["blood_type"])
									var/blood_DNA = R.data["blood_DNA"]
									var/blood_type = R.data["blood_type"]
									LAZYINITLIST(blood)
									blood[blood_DNA] = blood_type
				if(isobj(src))
					var/obj/T = src
					// Only get reagents from non-mobs.
					if(T.reagents && T.reagents.reagent_list.len)

						for(var/datum/reagent/R in T.reagents.reagent_list)
							T.reagents[R.name] = R.volume

							// Get blood data from the blood reagent.
							if(istype(R, /datum/reagent/blood))

								if(R.data["blood_DNA"] && R.data["blood_type"])
									var/blood_DNA = R.data["blood_DNA"]
									var/blood_type = R.data["blood_type"]
									LAZYINITLIST(blood)
									blood[blood_DNA] = blood_type

			// We gathered everything. Create a fork and slowly display the results to the holder of the scanner.

			var/found_something = FALSE

			// Fingerprints
			if(length(fingerprints))
				to_chat(user, "<span class='info'><B>Prints:</B></span>")
				for(var/finger in fingerprints)
					to_chat(user, "[finger]")
				found_something = TRUE

			// Blood
			if (length(blood))
				to_chat(user, "<span class='info'><B>Blood:</B></span>")
				found_something = TRUE
				for(var/B in blood)
					to_chat(user, "Type: <font color='red'>[blood[B]]</font> DNA (UE): <font color='red'>[B]</font>")

			//Fibers
			if(length(fibers))
				to_chat(user, "<span class='info'><B>Fibers:</B></span>")
				for(var/fiber in fibers)
					to_chat(user, "[fiber]")
				found_something = TRUE

			//Reagents
			if(length(reagents))
				to_chat(user, "<span class='info'><B>Reagents:</B></span>")
				for(var/R in reagents)
					to_chat(user, "Reagent: <font color='red'>[R]</font> Volume: <font color='red'>[reagents[R]]</font>")
				found_something = TRUE

			if(!found_something)
				to_chat(user, "<I># No forensic traces found #</I>") // Don't display this to the holder user
			return

//PSYCHIC PROJECTION
/datum/discipline_power/auspex/psychic_projection
	name = "Psychic Projection"
	desc = "Leave your body behind and fly across the land."

	level = 5

	toggled = FALSE

/datum/discipline_power/auspex/psychic_projection/activate()
	. = ..()
	owner.ghostize(can_reenter_corpse = TRUE, aghosted = FALSE, auspex_ghosted = TRUE)
	owner.soul_state = SOUL_PROJECTING
