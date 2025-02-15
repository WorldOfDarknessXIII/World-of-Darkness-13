/datum/reagent/blood
	data = list("donor"=null,"blood_DNA"=null,"blood_type"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null,"cloneable"=null,"factions"=null,"quirks"=null,"clan"=null,"generation"=null)
	name = "Blood"
	color = "#C80000" // rgb: 200, 0, 0
	metabolization_rate = 5 //fast rate so it disappears fast.
	taste_description = "iron"
	taste_mult = 1.3
	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"
	shot_glass_icon_state = "shotglassred"
	penetrates_skin = NONE

	// FEED ME

/datum/reagent/blood/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()

	if(iscarbon(exposed_mob))
		var/mob/living/carbon/exposed_carbon = exposed_mob
		if(exposed_carbon.get_blood_id() == /datum/reagent/blood && ((methods & INJECT) || ((methods & INGEST) && exposed_carbon.dna && exposed_carbon.dna.species && (DRINKSBLOOD in exposed_carbon.dna.species.species_traits))))
			if(!data || !(data["blood_type"] in get_safe_blood(exposed_carbon.dna.blood_type)))
				exposed_carbon.reagents.add_reagent(/datum/reagent/toxin, reac_volume * 0.5)
			else
				exposed_carbon.blood_volume = min(exposed_carbon.blood_volume + round(reac_volume, 0.1), BLOOD_VOLUME_MAXIMUM)


/datum/reagent/blood/on_merge(list/mix_data)
	if(data && mix_data)
		if(data["blood_DNA"] != mix_data["blood_DNA"])
			data["cloneable"] = 0 //On mix, consider the genetic sampling unviable for pod cloning if the DNA sample doesn't match.
	return 1

/datum/reagent/blood/expose_turf(turf/exposed_turf, reac_volume)//splash the blood all over the place
	. = ..()
	if(!istype(exposed_turf))
		return
	if(reac_volume < 3)
		return

	var/obj/effect/decal/cleanable/blood/bloodsplatter = locate() in exposed_turf //find some blood here
	if(!bloodsplatter)
		bloodsplatter = new(exposed_turf)
	if(data["blood_DNA"])
		bloodsplatter.add_blood_DNA(list(data["blood_DNA"] = data["blood_type"]))


/datum/reagent/water
	name = "Water"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen."
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha)
	taste_description = "water"
	var/cooling_temperature = 2
	glass_icon_state = "glass_clear"
	glass_name = "glass of water"
	glass_desc = "The father of all refreshments."
	shot_glass_icon_state = "shotglassclear"

/*
 *	Water reaction to turf
 */
/*
 *	Water reaction to an object
 */

/datum/reagent/water/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	exposed_obj.extinguish()
	exposed_obj.wash(CLEAN_TYPE_ACID)


/*
 *	Water reaction to a mob
 */

/datum/reagent/water/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with water can help put them out!
	. = ..()
	if(methods & TOUCH)
		exposed_mob.extinguish_mob() // extinguish removes all fire stacks

/datum/reagent/water/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(M.blood_volume)
		M.blood_volume += 0.1 // water is good for you!

///For weird backwards situations where water manages to get added to trays nutrients, as opposed to being snowflaked away like usual.

/datum/reagent/water/holywater/on_mob_life(mob/living/carbon/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3, 150)
	M.adjustToxLoss(2, FALSE)
	M.adjustFireLoss(2, FALSE)
	M.adjustOxyLoss(2, FALSE)
	M.adjustBruteLoss(2, FALSE)
	..()
