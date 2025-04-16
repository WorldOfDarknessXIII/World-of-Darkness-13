/datum/tribe/black_spiral_dancers
	name = "Black Spiral Dancers"
	desc = "Werewolves utterly corrupted and fallen to their mortal enemy, the Wyrm."

	gifts = list(
		/datum/action/gift/stinky_fur,
		/datum/action/gift/venom_claws,
		/datum/action/gift/burning_scars
	)

/datum/tribe/black_spiral_dancers/on_gain(/mob/living/character, level)
	. = ..()

	character.yin_chi = 2 * level + 1
	character.max_yin_chi = 2 * level + 1
	character.yang_chi = 5
	character.max_yang_chi = 5

/datum/action/gift/stinky_fur
	name = "Stinky Fur"
	desc = "Garou creates an aura of very toxic smell, which disorientates everyone around."
	button_icon_state = "stinky_fur"

/datum/action/gift/stinky_fur/Trigger()
	. = ..()
	if(allowed_to_proceed)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/necromancy.ogg', 75, FALSE)
		for (var/mob/living/carbon/victim in orange(5, owner))
			if (prob(25))
				victim.vomit()
			victim.dizziness += 10
			victim.add_confusion(10)

/datum/action/gift/venom_claws
	name = "Venom Claws"
	desc = "While this ability is active, strikes with claws poison foes of garou."
	button_icon_state = "venom_claws"
	rage_req = 1

/datum/action/gift/venom_claws/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(ishuman(owner))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/venom_claws.ogg', 75, FALSE)
			var/mob/living/carbon/human/H = owner
			H.melee_damage_lower = initial(H.melee_damage_lower)+15
			H.melee_damage_upper = initial(H.melee_damage_upper)+15
			H.tox_damage_plus = 15
			to_chat(owner, "<span class='notice'>You feel your claws filling with pure venom...</span>")
			spawn(12 SECONDS)
				H.tox_damage_plus = 0
				H.melee_damage_lower = initial(H.melee_damage_lower)
				H.melee_damage_upper = initial(H.melee_damage_upper)
				to_chat(owner, "<span class='warning'>Your claws are not poison anymore...</span>")
		else
			playsound(get_turf(owner), 'code/modules/wod13/sounds/venom_claws.ogg', 75, FALSE)
			var/mob/living/carbon/H = owner
			H.melee_damage_lower = initial(H.melee_damage_lower)+10
			H.melee_damage_upper = initial(H.melee_damage_upper)+10
			H.tox_damage_plus = 10
			to_chat(owner, "<span class='notice'>You feel your claws filling with pure venom...</span>")
			spawn(12 SECONDS)
				H.tox_damage_plus = 0
				H.melee_damage_lower = initial(H.melee_damage_lower)
				H.melee_damage_upper = initial(H.melee_damage_upper)
				to_chat(owner, "<span class='warning'>Your claws are not poison anymore...</span>")

/datum/action/gift/burning_scars
	name = "Burning Scars"
	desc = "Garou creates an aura of very hot air, which burns everyone around."
	button_icon_state = "burning_scars"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/burning_scars/Trigger()
	. = ..()
	if(allowed_to_proceed)
		owner.visible_message(
			span_danger("[owner.name] crackles with heat!"),
			span_danger("You crackle with heat, charging up your Gift!")
		)
		if(do_after(owner, 3 SECONDS))
			for (var/mob/living/victim in orange(5, owner))
				victim.apply_damage(40, BURN)

			for (var/turf/affected_turf in orange(4, get_turf(owner)))
				var/obj/effect/fire/fire = new(affected_turf)
				spawn(0.5 SECONDS)
					qdel(fire)
