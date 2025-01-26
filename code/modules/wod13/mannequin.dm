/datum/species/vamp_mannequin
	name = "mannequin"
	id = "mannequin"
	species_traits = list(NOEYESPRITES,NOBLOOD,NO_UNDERWEAR)
	inherent_traits = list(TRAIT_VIRUSIMMUNE,TRAIT_NOHUNGER,TRAIT_NOBREATH,TRAIT_TOXIMMUNE,TRAIT_NOCRITDAMAGE,TRAIT_ADVANCEDTOOLUSER,TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_NOFIRE,TRAIT_CHUNKYFINGERS,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE)
	inherent_biotypes = MOB_HUMANOID
	payday_modifier = 0.75
	siemens_coeff = 0
	punchdamagelow = 5
	punchdamagehigh = 5
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC
	damage_overlay_type = ""
	meat = /obj/item/food/meat/slab/human/mutant/golem
	sexes = 1
	limbs_id = "mannequin"
//	fixed_mut_color = "aaa"
	use_skintones = FALSE
//	var/last_spooked_out = 0

/datum/species/vamp_mannequin/on_species_gain(mob/living/carbon/human/C)
	. = ..()
	C.status_flags |= GODMODE
	C.skin_tone = "albino"
	C.dna.species.limbs_id = "mannequin"
	C.update_body_parts()
	C.update_body()
	C.update_icon()
	C.dna.real_name = "mannequin"
	C.real_name = "mannequin"
	C.true_real_name = "mannequin"
	C.real_name = "mannequin"

/datum/species/vamp_mannequin/check_roundstart_eligible()
	return FALSE

/datum/species/vamp_mannequin/spec_life(mob/living/carbon/human/H)
	. = ..()
	var/turf/T = get_turf(H)
	var/light_amount = T.get_lumcount()
	var/area/vtm/V = get_area(H)
	if(!V.upper)
		if(light_amount < 0.2)
			do_spooky(H)
		else
			walk_to(H, 0)
	else
		walk_to(H, 0)

/datum/species/vamp_mannequin/proc/do_spooky(var/mob/living/carbon/human/man)
//	if(last_spooked_out+10 > world.time)
//		return
//	last_spooked_out = world.time
	for(var/mob/living/L in range(7, man))
		if(L.client)
			man.face_atom(L)
			if(prob(50))
				walk_to(man, L, 0, man.total_multiplicative_slowdown())

	for(var/mob/living/carbon/human/H in range(1, man))
		if(H.client)
			if(!H.lock_on_by_mannequin)
				H.lock_on_by_mannequin = TRUE
				man.forceMove(get_turf(H))
				if(get_dist(man, H) < 2)
					var/obj/item/bodypart/affected = H.get_bodypart(pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
					if(affected != null)
						man.visible_message("[man] slices off [H]'s [affected]!", "<span class='notice'>You slice [man]'s [affected] off.</span>")
						affected.dismember(BRUTE)
					H.lock_on_by_mannequin = FALSE

	if(prob(33))
		var/turf/T = get_step(man, pick(NORTH, SOUTH, WEST, EAST))
//		man.face_atom(T)
		step_to(man,T,0)
