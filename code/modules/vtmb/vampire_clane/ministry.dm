/datum/vampireclane/ministry
	name = "Ministry"
	desc = "The Ministry, also called the Ministry of Set, Followers of Set, or Setites, are a clan of vampires who believe their founder was the Egyptian god Set."
	curse = "Decreased moving speed in lighted areas."
	clane_disciplines = list(
		/datum/discipline/obfuscate = 1,
		/datum/discipline/presence = 2,
		/datum/discipline/serpentis = 3
	)
	male_clothes = /obj/item/clothing/under/vampire/slickback
	female_clothes = /obj/item/clothing/under/vampire/burlesque

/datum/vampireclane/ministry/on_gain(mob/living/carbon/human/H)
	..()
	H.add_quirk(/datum/quirk/lightophobia)

/datum/vampireclane/ministry/post_gain(mob/living/carbon/human/H)
	..()
	var/obj/item/organ/eyes/night_vision/NV = new()
	NV.Insert(H, TRUE, FALSE)

/datum/discipline/serpentis/post_gain(mob/living/carbon/human/H)
	if(level >= 3)
		var/datum/action/mummyfy/mummy = new()
		mummy.Grant(H)
	if(level >= 4)
		var/datum/action/urn/U = new()
		U.Grant(H)
	if(level >= 5)
		var/datum/action/cobra/C = new()
		C.Grant(H)

/obj/item/urn
	name = "organ urn"
	desc = "Stores some precious organs..."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "urn"
	is_magic = TRUE
	var/mob/living/own

/obj/item/urn/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	qdel(src)

/obj/item/urn/attack_self(mob/user)
	. = ..()
	qdel(src)

/obj/item/urn/Destroy()
	. = ..()
	if(own)
		own.death()


/datum/action/urn
	name = "Make Urn"
	desc = "Move your heart to the urn and become immune to stakes."
	button_icon_state = "urn"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/obj/item/urn/urn
	var/cool_down = 0

/datum/action/urn/Trigger()
	. = ..()
	if(cool_down+200 >= world.time)
		return
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		cool_down = world.time
		if(H.bloodpool < 1)
			to_chat(owner, "<span class='warning'>You don't have enough <b>BLOOD</b> to do that!</span>")
			return
		to_chat(owner, "<span class='notice'>You activate the Serpentis Urn.</span>")
		H.bloodpool = max(0, H.bloodpool-1)
		if(!urn)
			if(H.dna)
				if(H.dna.species)
					H.dna.species.inherent_traits |= TRAIT_STUNIMMUNE
					H.dna.species.inherent_traits |= TRAIT_SLEEPIMMUNE
					H.dna.species.inherent_traits |= TRAIT_NOSOFTCRIT
					H.stakeimmune = TRUE
					urn = new(H.loc)
					urn.own = owner
					var/obj/item/organ/heart/heart = H.getorganslot(ORGAN_SLOT_HEART)
					heart.forceMove(urn)

		else
			if(H.dna)
				if(H.dna.species)
					H.dna.species.inherent_traits -= TRAIT_STUNIMMUNE
					H.dna.species.inherent_traits -= TRAIT_SLEEPIMMUNE
					H.dna.species.inherent_traits -= TRAIT_NOSOFTCRIT
					H.stakeimmune = FALSE
					for(var/obj/item/organ/heart/heart in urn)
						heart.forceMove(H)
						heart.Insert(H)
			urn.own = null
			qdel(urn)
			urn = null

/datum/action/mummyfy
	name = "Mummyfy"
	desc = "Fall in torpor-like condition and ignore physical damage."
	button_icon_state = "serpentis"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/abuse_fix = 0

/datum/action/mummyfy/Trigger()
	. = ..()
	if(abuse_fix+150 > world.time)
		return
	var/mob/living/carbon/human/G = owner
	if(G.CheckEyewitness(G, G, 7, FALSE))
		G.AdjustMasquerade(-1)
	abuse_fix = world.time
	G.Stun(100)
	G.petrify(100, "Serpentis")

/obj/effect/proc_holder/spell/targeted/shapeshift/cobra
	name = "Cobra"
	desc = "Take on the shape a beast."
	charge_max = 50
	cooldown_min = 50
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/cobra

/datum/action/cobra
	name = "Cobra Form"
	desc = "Take on the shape a cobra."
	button_icon_state = "cobra"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/obj/effect/proc_holder/spell/targeted/shapeshift/cobra/BC

/datum/action/cobra/Trigger()
	. = ..()
	var/mob/living/carbon/human/NG = owner
	if(NG.stat > 1 || NG.IsSleeping() || NG.IsUnconscious() || NG.IsParalyzed() || NG.IsKnockdown() || NG.IsStun() || HAS_TRAIT(NG, TRAIT_RESTRAINED) || !isturf(NG.loc))
		return
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 2)
		to_chat(owner, "<span class='warning'>You don't have enough <b>BLOOD</b> to do that!</span>")
		return
	if(!BC)
		BC = new(owner)
	H.bloodpool = max(0, H.bloodpool-2)
	BC.Shapeshift(H)
	spawn(150)
		if(BC)
			BC.Restore(BC.myshape)
			NG.Stun(15)
			NG.do_jitter_animation(30)

/mob/living/simple_animal/hostile/cobra
	name = "Cobra Form"
	desc = "Hssssss..."
	icon = 'code/modules/wod13/48x48.dmi'
	icon_state = "cobra"
	icon_living = "cobra"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speak_chance = 0
	speed = -1
	maxHealth = 300
	health = 300
	butcher_results = list(/obj/item/stack/human_flesh = 20)
	harm_intent_damage = 5
	melee_damage_lower = 50
	melee_damage_upper = 50
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	bloodpool = 10
	maxbloodpool = 10
	pixel_w = -8
