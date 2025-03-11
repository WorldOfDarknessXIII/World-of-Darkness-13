/datum/discipline/serpentis
	name = "Serpentis"
	desc = "Act like a cobra, get the powers to stun targets with your gaze and your tongue, praise the mummy traditions and spread them to your childe. Violates Masquerade."
	icon_state = "serpentis"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/serpentis

/datum/discipline_power/serpentis
	name = "Serpentis power name"
	desc = "Serpentis power description"

	activate_sound = 'code/modules/wod13/sounds/serpentis.ogg'

//THE EYES OF THE SERPENT
/datum/discipline_power/serpentis/the_eyes_of_the_serpent
	name = "The Eyes of the Serpent"
	desc = "Gain the hypnotic eyes of the serpent, and immobilise all who look into them."

	level = 1
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SEE
	target_type = TARGET_LIVING
	range = 3

	aggravating = FALSE
	hostile = FALSE
	violates_masquerade = TRUE

	multi_activate = TRUE
	duration_length = 0.5 SECONDS
	cooldown_length = 5 SECONDS

/datum/discipline_power/serpentis/the_eyes_of_the_serpent/can_activate_untargeted(alert)
	. = ..()
	if (owner?.is_eyes_covered())
		if (alert)
			to_chat(owner, span_warning("You cannot use [name] with your eyes covered!"))
		. = FALSE
	return .

/datum/discipline_power/serpentis/the_eyes_of_the_serpent/activate(mob/living/target)
	. = ..()
	var/antidir = NORTH
	switch(owner.dir)
		if(NORTH)
			antidir = SOUTH
		if(SOUTH)
			antidir = NORTH
		if(WEST)
			antidir = EAST
		if(EAST)
			antidir = WEST
	if(target.dir == antidir)
		target.Immobilize(2 SECONDS)
		target.visible_message(span_warning("<b>[owner] hypnotizes [target] with [owner.p_their()] eyes!</b>"), span_warning("<b>[owner] hypnotizes you like a cobra!</b>"))
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.remove_overlay(MUTATIONS_LAYER)
			var/mutable_appearance/serpentis_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "serpentis", -MUTATIONS_LAYER)
			H.overlays_standing[MUTATIONS_LAYER] = serpentis_overlay
			H.apply_overlay(MUTATIONS_LAYER)

/datum/discipline_power/serpentis/the_eyes_of_the_serpent/deactivate(mob/living/target)
	. = ..()
	if (ishuman(target))
		var/mob/living/carbon/human/human_target = target
		human_target.remove_overlay(MUTATIONS_LAYER)

//THE TONGUE OF THE ASP
/datum/discipline_power/serpentis/the_tongue_of_the_asp
	name = "The Tongue of the Asp"
	desc = "Lengthen your tongue and strike your enemies with it, draining their blood."

	level = 2
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING
	target_type = TARGET_LIVING
	range = 3

	effect_sound = 'code/modules/wod13/sounds/tongue.ogg'
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS

/datum/discipline_power/serpentis/the_tongue_of_the_asp/can_activate_untargeted(alert)
	. = ..()
	if (owner?.is_mouth_covered())
		if (alert)
			to_chat(owner, span_warning("You cannot use [name] with your mouth covered!"))
		. = FALSE
	return .

/datum/discipline_power/serpentis/the_tongue_of_the_asp/activate(mob/living/target)
	. = ..()
	target.bloodpool = max(target.bloodpool - 2, 0)
	owner.bloodpool = min(owner.bloodpool + 2, owner.maxbloodpool)
	var/obj/item/ammo_casing/magic/tentacle/casing = new (get_turf(owner))
	casing.fire_casing(target, owner, null, null, null, ran_zone(), 0,  owner)
	qdel(casing)

//THE SKIN OF THE ADDER
/datum/discipline_power/serpentis/the_skin_of_the_adder
	name = "The Skin of the Adder"
	desc = "Become like a snake and harden your skin into scales."

	level = 3
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING

	violates_masquerade = TRUE

	duration_length = 5 SECONDS
	cooldown_length = 15 SECONDS

/datum/discipline_power/serpentis/the_skin_of_the_adder/activate()
	. = ..()
	//this is bad and needs to allow for actual cancelling/deactivation rather than just a timer in the proc
	owner.Stun(duration_length)
	owner.petrify(duration_length, "Serpentis")

//THE FORM OF THE COBRA
/datum/discipline_power/serpentis/the_form_of_the_cobra
	name = "The Form of the Cobra"
	desc = "Become a huge, black cobra and eviscerate your enemies."

	level = 4
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING
	vitae_cost = 2

	violates_masquerade = TRUE

	duration_length = 15 SECONDS
	cooldown_length = 30 SECONDS

	var/obj/effect/proc_holder/spell/targeted/shapeshift/cobra/BC

/datum/discipline_power/serpentis/the_form_of_the_cobra/activate()
	. = ..()
	if(!BC)
		BC = new(owner)
	BC.Shapeshift(owner)

/datum/discipline_power/serpentis/the_form_of_the_cobra/deactivate()
	. = ..()
	BC.Restore(BC.myshape)
	owner.Stun(1.5 SECONDS)
	owner.do_jitter_animation(3 SECONDS)

/obj/effect/proc_holder/spell/targeted/shapeshift/cobra
	name = "Cobra"
	desc = "Take on the shape a beast."
	charge_max = 15 SECONDS
	cooldown_min = 15 SECONDS
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/cobra

/mob/living/simple_animal/hostile/cobra
	name = "Cobra Form"
	desc = "Hssssss..."
	icon = 'code/modules/wod13/48x48.dmi'
	icon_state = "cobra"
	icon_living = "cobra"
	mob_biotypes = MOB_ORGANIC | MOB_HUMANOID
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

//THE HEART OF DARKNESS
/datum/discipline_power/serpentis/the_heart_of_darkness
	name = "The Heart of Darkness"
	desc = "Remove your heart and place it in an urn to protect it from stakes and Diablerie."

	level = 5
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING | DISC_CHECK_FREE_HAND

	violates_masquerade = TRUE

	cooldown_length = 20 SECONDS

	var/obj/item/urn/urn

/datum/discipline_power/serpentis/the_heart_of_darkness/activate()
	. = ..()
	if(!urn)
		if(owner.dna?.species)
			owner.dna.species.inherent_traits |= TRAIT_STUNIMMUNE
			owner.dna.species.inherent_traits |= TRAIT_SLEEPIMMUNE
			owner.dna.species.inherent_traits |= TRAIT_NOSOFTCRIT
			owner.stakeimmune = TRUE
			urn = new(owner.loc)
			urn.own = owner
			var/obj/item/organ/heart/heart = owner.getorganslot(ORGAN_SLOT_HEART)
			heart.forceMove(urn)
	else
		if(owner.dna?.species)
			owner.dna.species.inherent_traits -= TRAIT_STUNIMMUNE
			owner.dna.species.inherent_traits -= TRAIT_SLEEPIMMUNE
			owner.dna.species.inherent_traits -= TRAIT_NOSOFTCRIT
			owner.stakeimmune = FALSE
			for(var/obj/item/organ/heart/heart in urn)
				heart.forceMove(owner)
				heart.Insert(owner)
		urn.own = null
		qdel(urn)
		urn = null

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
