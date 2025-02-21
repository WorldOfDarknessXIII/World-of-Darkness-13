/datum/species/vamp_mannequin
	name = "mannequin"
	id = "mannequin"
	inherent_traits = list(TRAIT_GODMODE, TRAIT_NO_EYELIDS,TRAIT_NOBLOOD, TRAIT_NO_UNDERWEAR, TRAIT_VIRUSIMMUNE,TRAIT_NOHUNGER,TRAIT_NOBREATH,TRAIT_TOXIMMUNE,TRAIT_NOCRITDAMAGE,TRAIT_ADVANCEDTOOLUSER,TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_NOFIRE,TRAIT_CHUNKYFINGERS,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE)
	inherent_biotypes = MOB_HUMANOID
	payday_modifier = 0.75
	siemens_coeff = 0
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC
	meat = /obj/item/food/meat/slab/human/mutant/golem
	sexes = 1

/datum/species/vamp_mannequin/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	human_who_gained_species.skin_tone = "albino"
	human_who_gained_species.update_body_parts()
	human_who_gained_species.update_body()
	human_who_gained_species.update_icon()
	human_who_gained_species.dna.real_name = "mannequin"
	human_who_gained_species.real_name = "mannequin"
	human_who_gained_species.true_real_name = "mannequin"
	human_who_gained_species.real_name = "mannequin"

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
	for(var/mob/living/L in range(7, man))
		if(L.client)
			man.face_atom(L)
			if(prob(50))
				step(man, L)

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
		step_to(man,T,0)

/mob/living/carbon/human/species/vamp_mannequin
	race = /datum/species/vamp_mannequin

/mob/living/carbon/human/species/vamp_mannequin/napoleon

/mob/living/carbon/human/species/vamp_mannequin/napoleon/Initialize()
	. = ..()
	equip_to_slot_or_del(new /obj/item/clothing/head/vampire/napoleon(src), ITEM_SLOT_HEAD)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/vampire/jackboots/high(src), ITEM_SLOT_FEET)
	equip_to_slot_or_del(new /obj/item/clothing/under/vampire/napoleon(src), ITEM_SLOT_ICLOTHING)

/mob/living/carbon/human/species/vamp_mannequin/nazi

/mob/living/carbon/human/species/vamp_mannequin/nazi/Initialize()
	. = ..()
	equip_to_slot_or_del(new /obj/item/clothing/head/vampire/nazi(src), ITEM_SLOT_HEAD)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/vampire/jackboots/high(src), ITEM_SLOT_FEET)
	equip_to_slot_or_del(new /obj/item/clothing/under/vampire/nazi(src), ITEM_SLOT_ICLOTHING)

//prevents this thing from being stripped
/mob/living/carbon/human/species/vamp_mannequin/nazi/Topic(href, href_list)
	if(href_list["item"])
		message_admins("[ADMIN_LOOKUPFLW(usr)] tried to strip the Nazi mannequin.")
		to_chat(usr, "<span class='warning'>You don't really want to pick that up...</span>")
		return
	else
		..()

//prevents anything from being dropped by the mannequin on gib
/mob/living/carbon/human/species/vamp_mannequin/nazi/gib(no_brain, no_organs, no_bodyparts, safe_gib)
	qdel(src)

/mob/living/carbon/human/species/vamp_mannequin/conquestador

/mob/living/carbon/human/species/vamp_mannequin/conquestador/Initialize()
	. = ..()
	equip_to_slot_or_del(new /obj/item/clothing/head/vampire/helmet/spain(src), ITEM_SLOT_HEAD)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/vampire/jackboots/work(src), ITEM_SLOT_FEET)
	equip_to_slot_or_del(new /obj/item/clothing/under/vampire/tremere(src), ITEM_SLOT_ICLOTHING)
	equip_to_slot_or_del(new /obj/item/clothing/suit/vampire/vest/medieval(src), ITEM_SLOT_OCLOTHING)

/mob/living/carbon/human/species/vamp_mannequin/cowboy

/mob/living/carbon/human/species/vamp_mannequin/cowboy/Initialize()
	. = ..()
	equip_to_slot_or_del(new /obj/item/clothing/head/vampire/cowboy(src), ITEM_SLOT_HEAD)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/vampire/brown(src), ITEM_SLOT_FEET)
	equip_to_slot_or_del(new /obj/item/clothing/under/vampire/bouncer(src), ITEM_SLOT_ICLOTHING)
	equip_to_slot_or_del(new /obj/item/clothing/suit/vampire/trench/alt(src), ITEM_SLOT_OCLOTHING)
