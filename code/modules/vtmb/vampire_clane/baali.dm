/datum/vampireclane/baali
	name = "Baali"
	desc = "The Baali are a bloodline of vampires associated with demon worship. Because of their affinity with the unholy, the Baali are particularly vulnerable to holy iconography, holy ground and holy water. They are highly vulnerable to True Faith."
	curse = "Fear of the Religion."
	clane_disciplines = list(
		/datum/discipline/obfuscate,
		/datum/discipline/presence,
		/datum/discipline/daimonion
	)
	male_clothes = /obj/item/clothing/under/vampire/baali
	female_clothes = /obj/item/clothing/under/vampire/baali/female
	enlightenment = TRUE
	whitelisted = TRUE
	clan_keys = /obj/item/vamp/keys/baali

/datum/vampireclane/baali/on_gain(mob/living/carbon/human/H)
	..()
	H.faction |= "Baali"
	var/datum/brain_trauma/mild/phobia/security/religious_trauma = new()
	H.gain_trauma(religious_trauma, TRAUMA_RESILIENCE_ABSOLUTE)

/mob/living/simple_animal/hostile/baali_guard
	name = "Infernal Creature"
	desc = "The peak of abominations armor. Unbelievably undamagable..."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "baali"
	icon_living = "baali"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speak_chance = 0
	speed = 0
	maxHealth = 1500
	health = 1500
	butcher_results = list(/obj/item/stack/human_flesh = 20)
	harm_intent_damage = 40
	melee_damage_lower = 40
	melee_damage_upper = 40
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	bloodpool = 10
	maxbloodpool = 10
	faction = list("Baali")

/mob/living/simple_animal/hostile/baali_guard/Initialize()
	. = ..()
	give_player()

/mob/living/simple_animal/hostile/baali_guard/proc/give_player()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as Infernal Creature?", null, null, null, 50, src)
	for(var/mob/dead/observer/G in GLOB.player_list)
		if(G.key)
			to_chat(G, "<span class='ghostalert'>Someone is summoning a demon!</span>")
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		name = C.name
		key = C.key
		visible_message("<span class='danger'>[src] rises with fresh soul!</span>")
		return TRUE
	visible_message("<span class='warning'>[src] remains unsouled...</span>")
	return FALSE
