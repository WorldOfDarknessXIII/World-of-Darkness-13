/obj/item/vtm_artifact/pickup(mob/user)
	..()
	if(identified)
		owner = user
		START_PROCESSING(SSobj, src)
		get_powers()

/obj/item/vtm_artifact/dropped(mob/user)
	..()
	if(identified)
		if(isturf(loc))
			STOP_PROCESSING(SSobj, src)
			if(owner)
				remove_powers()
				owner = null

/obj/item/vtm_artifact/process(delta_time)
	if(owner != loc && owner != loc.loc)
		forceMove(get_turf(src))
		STOP_PROCESSING(SSobj, src)
		if(owner)
			remove_powers()
			owner = null

/obj/item/vtm_artifact
	name = "unidentified occult fetish"
	desc = "Who knows what secrets it could contain..."
	icon_state = "arcane"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	is_magic = TRUE
	var/mob/living/owner
	var/true_name = "artifact"
	var/true_desc = "Debug"
	var/identified = FALSE
	var/gained_boosts = FALSE

/obj/item/vtm_artifact/proc/identificate()
	if(!identified)
		name = true_name
		desc = true_desc
		identified = TRUE

/obj/item/vtm_artifact/proc/get_powers()
	if(!identified)
		return

/obj/item/vtm_artifact/proc/remove_powers()
	if(!identified)
		return

/obj/item/vtm_artifact/weekapaug_thistle
	true_name = "Weekapaug Thistle"
	true_desc = "Increases combat defense."
	icon_state = "w_thistle"

/obj/item/vtm_artifact/weekapaug_thistle/get_powers()
	..()
	var/mob/living/carbon/human/H = owner
	H.physiology.armor.melee = H.physiology.armor.melee+10
	H.physiology.armor.bullet = H.physiology.armor.bullet+10

/obj/item/vtm_artifact/weekapaug_thistle/remove_powers()
	..()
	var/mob/living/carbon/human/H = owner
	H.physiology.armor.melee = H.physiology.armor.melee-10
	H.physiology.armor.bullet = H.physiology.armor.bullet-10

/obj/item/vtm_artifact/tarulfang
	true_name = "Tarulfang"
	true_desc = "Decreases chance of frenzy."
	icon_state = "tarulfang"

/obj/item/vtm_artifact/weekapaug_thistle/get_powers()
	..()
	owner.frenzy_chance_boost = 5

/obj/item/vtm_artifact/weekapaug_thistle/remove_powers()
	..()
	owner.frenzy_chance_boost = 10

/obj/item/vtm_artifact/mummywrap_fetish
	true_name = "Mummywrap Fetish"
	true_desc = "Passive health regeneration."
	icon_state = "m_fetish"
	var/last_regen = 0

/obj/item/vtm_artifact/mummywrap_fetish/process(delta_time)
	. = ..()
	if(identified && owner)
		if(last_regen+60 < world.time)
			last_regen = world.time
			owner.adjustBruteLoss(-5)
			owner.adjustFireLoss(-5)

/obj/item/vtm_artifact/saulocept
	true_name = "Saulocept"
	true_desc = "More experience points."
	icon_state = "saulocept"

/obj/item/vtm_artifact/saulocept/get_powers()
	..()
	owner.experience_plus = 10

/obj/item/vtm_artifact/saulocept/remove_powers()
	..()
	owner.experience_plus = 0

/obj/item/vtm_artifact/galdjum
	true_name = "Galdjum"
	true_desc = "Increases disciplines duration."
	icon_state = "galdjum"

/obj/item/vtm_artifact/galdjum/get_powers()
	..()
	owner.discipline_time_plus = 25

/obj/item/vtm_artifact/galdjum/remove_powers()
	..()
	owner.discipline_time_plus = 0

/datum/movespeed_modifier/fae_charm
	multiplicative_slowdown = -0.20

/obj/item/vtm_artifact/fae_charm
	true_name = "Fae Charm"
	true_desc = "Faster movement speed."
	icon_state = "fae_charm"

/obj/item/vtm_artifact/fae_charm/get_powers()
	..()
	owner.add_movespeed_modifier(/datum/movespeed_modifier/fae_charm)

/obj/item/vtm_artifact/fae_charm/remove_powers()
	..()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/fae_charm)

/obj/item/vtm_artifact/heart_of_eliza
	true_name = "Heart of Eliza"
	true_desc = "Melee damage boost."
	icon_state = "h_eliza"

/obj/item/vtm_artifact/heart_of_eliza/get_powers()
	..()
	var/mob/living/carbon/human/H = owner
	if(H.dna)
		H.dna.species.meleemod = H.dna.species.meleemod+0.5

/obj/item/vtm_artifact/heart_of_eliza/remove_powers()
	..()
	var/mob/living/carbon/human/H = owner
	if(H.dna)
		H.dna.species.meleemod = H.dna.species.meleemod-0.5

/obj/item/vtm_artifact/bloodstar
	true_name = "Bloodstar"
	true_desc = "Increases Bloodpower duration."
	icon_state = "bloodstar"

/obj/item/vtm_artifact/bloodstar/get_powers()
	..()
	owner.bloodpower_time_plus = 50

/obj/item/vtm_artifact/bloodstar/remove_powers()
	..()
	owner.bloodpower_time_plus = 0

/obj/item/vtm_artifact/daimonori
	true_name = "Daimonori"
	true_desc = "Increases thaumaturgy damage."
	icon_state = "daimonori"

/obj/item/vtm_artifact/daimonori/get_powers()
	..()
	owner.thaum_damage_plus = 20

/obj/item/vtm_artifact/daimonori/remove_powers()
	..()
	owner.thaum_damage_plus = 0

/obj/item/vtm_artifact/key_of_alamut
	true_name = "Key of Alamut"
	true_desc = "Decreases incoming damage."
	icon_state = "k_alamut"

/obj/item/vtm_artifact/key_of_alamut/get_powers()
	..()
	var/mob/living/carbon/human/H = owner
	if(H.dna.species.brutemod == 0.3)
		return
	if(H.dna)
		H.dna.species.brutemod = H.dna.species.brutemod-0.2
		H.dna.species.burnmod = H.dna.species.burnmod-0.2

/obj/item/vtm_artifact/key_of_alamut/remove_powers()
	..()
	var/mob/living/carbon/human/H = owner
	if(H.dna.species.brutemod == 0.5)
		return
	if(H.dna)
		H.dna.species.brutemod = H.dna.species.brutemod+0.2
		H.dna.species.burnmod = H.dna.species.burnmod+0.2

/obj/item/vtm_artifact/odious_chalice
	true_name = "Odious Chalice"
	true_desc = "Stores blood from every attack."
	icon_state = "o_chalice"
	var/stored_blood = 0

/obj/item/vtm_artifact/odious_chalice/examine(mob/user)
	. = ..()
	. += "[src] contains [stored_blood] blood points..."

/obj/item/vtm_artifact/odious_chalice/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!iskindred(M))
		return
	if(!stored_blood)
		return
	if(!identified)
		return
	M.adjustBruteLoss(-5*stored_blood, TRUE)
	M.adjustFireLoss(-5*stored_blood, TRUE)
	M.update_damage_overlays()
	M.update_health_hud()
	M.update_blood_hud()
	playsound(M.loc,'sound/items/drink.ogg', 50, TRUE)
	return

/obj/item/vtm_artifact/rand
	icon_state = "art_rand"

/obj/item/vtm_artifact/rand/Initialize()
	. = ..()
	var/spawnprobability = 0.5 //setting spawn probability of artifacts
	if (rand() < spawnprobability) //generates a number between 0 and 1, if it's greater than .5, then we execute the next step
		var/spawn_artifact = pick(/obj/item/vtm_artifact/odious_chalice, /obj/item/vtm_artifact/key_of_alamut, /obj/item/vtm_artifact/daimonori, /obj/item/vtm_artifact/bloodstar, /obj/item/vtm_artifact/heart_of_eliza, /obj/item/vtm_artifact/fae_charm, /obj/item/vtm_artifact/galdjum, /obj/item/vtm_artifact/saulocept, /obj/item/vtm_artifact/mummywrap_fetish, /obj/item/vtm_artifact/weekapaug_thistle)
		new spawn_artifact(loc)
	qdel(src)
