/datum/vampireclane/gargoyle
	name = "Gargoyle"
	desc = "The Gargoyles are a vampiric bloodline created by the Tremere as their servitors. Although technically not a Tremere bloodline, the bloodline is largely under their control. In the Final Nights, Gargoyle populations seem to be booming; this is largely because older, free Gargoyles are coming out of hiding to join the Camarilla, because more indentured Gargoyles break free from the clutches of the Tremere, and because the free Gargoyles have also begun to Embrace more mortals on their own."
	curse = "All Gargoyles, much like the Nosferatu, are hideous to look at, a byproduct of their occult origins (and the varied Kindred stock from which they originate). This means that Gargoyles, just like the Nosferatu, have to hide their existence from common mortals, as their mere appearance is a breach of the Masquerade. In addition, the nature of the bloodline's origin manifests itself in the fact that Gargoyles are highly susceptible to mind control of any source. This weakness is intentional; a flaw placed into all Gargoyles by the Tremere in the hope that it would make them easier to control (and less likely to rebel)."
	clane_disciplines = list(
		/datum/discipline/fortitude = 1,
		/datum/discipline/potence = 2,
		/datum/discipline/visceratika = 3
	)
	alt_sprite = "gargoyle"
	no_facial = TRUE
	violating_appearance = TRUE
	male_clothes = /obj/item/clothing/under/vampire/malkavian
	female_clothes = /obj/item/clothing/under/vampire/malkavian
	haircuts = list(
		"Bald",
		"Pyotr",
		"Tau",
		"Balding Hair",
		"Boddicker",
		"Feather",
		"Gelled Back",
		"Cornrows",
		"Cornrows 2",
		"Cornrow Bun",
		"Cornrow Braid",
		"Cornrow Tail"
	)
	current_accessory = "gargoyle_full"
	accessories = list("gargoyle_full", "gargoyle_left", "gargoyle_right", "gargoyle_broken", "gargoyle_round", "none")
	accessories_layers = list("gargoyle_full" = UNICORN_LAYER, "gargoyle_left" = UNICORN_LAYER, "gargoyle_right" = UNICORN_LAYER, "gargoyle_broken" = UNICORN_LAYER, "gargoyle_round" = UNICORN_LAYER, "none" = UNICORN_LAYER)
	whitelisted = TRUE

/datum/vampireclane/gargoyle/on_gain(mob/living/carbon/human/H)
	..()
	H.dna.species.no_equip = list(ITEM_SLOT_OCLOTHING, ITEM_SLOT_SUITSTORE)
	H.dna.species.wings_icon = "Gargoyle"
	H.physiology.armor.melee += 20
	H.physiology.armor.bullet += 20

/datum/vampireclane/gargoyle/post_gain(mob/living/carbon/human/H)
	..()
	H.dna.species.GiveSpeciesFlight(H)

//datum/discipline/visceratika/post_gain(mob/living/carbon/human/H)
//	var/obj/effect/proc_holder/spell/voice_of_god/S = new(H)
//	H.mind.AddSpell(S)

/datum/discipline/visceratika
	name = "Visceratika"
	desc = "The Discipline of Visceratika is the exclusive possession of the Gargoyle bloodline and is an extension of their natural affinity for stone, earth, and things made thereof."
	icon_state = "visceratika"
	cost = 1
	ranged = FALSE
	delay = 15 SECONDS
	activate_sound = 'code/modules/wod13/sounds/visceratika.ogg'
	leveldelay = FALSE
	fearless = TRUE
	clane_restricted = TRUE

/datum/discipline/visceratika/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	switch(level_casting)
		if(1)
			for(var/mob/living/L in GLOB.player_list)
				if(L)
					if(get_area(L) == get_area(caster))
						var/their_name = L.name
						if(ishuman(L))
							var/mob/living/carbon/human/H = L
							their_name = H.true_real_name
						to_chat(caster, "[their_name]")
		if(2)
			ADD_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
			spawn(delay+caster.discipline_time_plus)
				REMOVE_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
		if(3)
			caster.alpha = 10
			caster.obfuscate_level = 3
			ADD_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
			spawn(delay+caster.discipline_time_plus)
				caster.obfuscate_level = 0
				caster.alpha = 255
				REMOVE_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
		if(4)
			caster.Stun(delay+caster.discipline_time_plus)
			caster.petrify(delay+caster.discipline_time_plus, "Visceratika")
			ADD_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
			spawn(delay+caster.discipline_time_plus)
				REMOVE_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
		if(5)
			caster.gargoyle_pass = TRUE
			caster.alpha = 10
			caster.obfuscate_level = 3
			ADD_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
			spawn(delay+caster.discipline_time_plus)
				caster.obfuscate_level = 0
				caster.alpha = 255
				caster.gargoyle_pass = FALSE
				REMOVE_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)

/turf/closed/Enter(atom/movable/mover, atom/oldloc)
	if(isliving(mover))
		var/mob/living/L = mover
		if(L.gargoyle_pass)
			if(get_area(L) == get_area(src))
				return TRUE
	return ..()
