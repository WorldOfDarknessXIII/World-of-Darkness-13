/datum/tribe/wendigo
	name = "Wendigo"
	desc = "Deadly hunters hailing from North America, raging against the devastation wrought by European colonists."

	gifts = list(
		/datum/action/gift/stoic_pose,
		/datum/action/gift/freezing_wind,
		/datum/action/gift/bloody_feast
	)

/datum/tribe/wendigo/on_gain(mob/living/character, level)
	. = ..()

	character.yin_chi = 1
	character.max_yin_chi = 1
	character.yang_chi = 2 * level + 5
	character.max_yang_chi = 2 * level + 5

/datum/action/gift/stoic_pose
	name = "Stoic Pose"
	desc = "With this gift garou sends theirself into cryo-state, ignoring all incoming damage but also covering themself in a block of ice."
	button_icon_state = "stoic_pose"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/stoic_pose/Trigger()
	. = ..()
	if(allowed_to_proceed)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/ice_blocking.ogg', 100, FALSE)
		var/mob/living/carbon/C = owner
		if(is_garou(C))
			var/obj/were_ice/W = new (get_turf(owner))
			C.Stun(12 SECONDS)
			C.forceMove(W)
			spawn(12 SECONDS)
				C.forceMove(get_turf(W))
				qdel(W)
		if(iscrinos(C))
			var/obj/were_ice/crinos/W = new (get_turf(owner))
			C.Stun(12 SECONDS)
			C.forceMove(W)
			spawn(12 SECONDS)
				C.forceMove(get_turf(W))
				qdel(W)
		if(islupus(C))
			var/obj/were_ice/lupus/W = new (get_turf(owner))
			C.Stun(12 SECONDS)
			C.forceMove(W)
			spawn(12 SECONDS)
				C.forceMove(get_turf(W))
				qdel(W)

/datum/action/gift/freezing_wind
	name = "Freezing Wind"
	desc = "Garou of Wendigo Tribe can create a stream of cold, freezing wind, and strike her foes with it."
	button_icon_state = "freezing_wind"
	rage_req = 1

/datum/action/gift/freezing_wind/Trigger()
	. = ..()
	if(allowed_to_proceed)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/wind_cast.ogg', 100, FALSE)
		for(var/turf/T in range(3, get_step(get_step(owner, owner.dir), owner.dir)))
			if(owner.loc != T)
				var/obj/effect/wind/W = new(T)
				W.dir = owner.dir
				W.strength = 100
				spawn(20 SECONDS)
					qdel(W)

/datum/action/gift/bloody_feast
	name = "Bloody Feast"
	desc = "By eating a grabbed corpse, garou can redeem their lost health and heal the injuries."
	button_icon_state = "bloody_feast"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/bloody_feast/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		if (C.pulling)
			if (isliving(C.pulling))
				var/mob/living/L = C.pulling
				if (L.stat == DEAD)
					playsound(get_turf(owner), 'code/modules/wod13/sounds/bloody_feast.ogg', 50, FALSE)
					qdel(L)
					C.revive(full_heal = TRUE, admin_revive = TRUE)
