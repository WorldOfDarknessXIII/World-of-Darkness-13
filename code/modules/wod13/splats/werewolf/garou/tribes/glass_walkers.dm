/datum/tribe/glass_walkers
	name = "Glass Walkers"
	desc = "Urban werewolves, embracing technology and adapting to modern life so they can use their enemies' tools against them."

	gifts = list(
		/datum/action/gift/smooth_move,
		/datum/action/gift/digital_feelings,
		/datum/action/gift/elemental_improvement
	)

	caern_area = /area/vtm/interior/glasswalker

/datum/tribe/glass_walkers/on_gain(mob/living/character, level)
	. = ..()

	character.yin_chi = level + 1
	character.max_yin_chi = level + 1
	character.yang_chi = level + 5
	character.max_yang_chi = level + 5

/datum/action/gift/smooth_move
	name = "Smooth Move"
	desc = "Garou jumps forward, avoiding every damage for a moment."
	button_icon_state = "smooth_move"
	//rage_req = 1   somewhat useless gift with MMB pounce

/datum/action/gift/smooth_move/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/turf/T = get_turf(get_step(get_step(get_step(owner, owner.dir), owner.dir), owner.dir))
		if(!T || T == owner.loc)
			return
		owner.visible_message("<span class='danger'>[owner] charges!</span>")
		owner.setDir(get_dir(owner, T))
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(owner.loc,owner)
		animate(D, alpha = 0, color = "#FF0000", transform = matrix()*2, time = 1)
		spawn(3)
			owner.throw_at(T, get_dist(owner, T), 1, owner, 0)

/datum/action/gift/digital_feelings
	name = "Digital Feelings"
	desc = "Every technology creates an electrical strike, which hits garou's enemies."
	button_icon_state = "digital_feelings"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/digital_feelings/Trigger()
	. = ..()
	if(allowed_to_proceed)
		owner.visible_message("<span class='danger'>[owner.name] crackles with static electricity!</span>", "<span class='danger'>You crackle with static electricity, charging up your Gift!</span>")
		if(do_after(owner, 3 SECONDS))
			playsound(owner, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
			tesla_zap(owner, 3, 30, ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE | ZAP_MOB_STUN | ZAP_ALLOW_DUPLICATES)
			for(var/mob/living/L in orange(6, owner))
				if(L)
					L.electrocute_act(30, owner, siemens_coeff = 1, flags = NONE)

/datum/action/gift/elemental_improvement
	name = "Elemental Improvement"
	desc = "Garou flesh replaces itself with prothesis, making it less vulnerable to brute damage, but more for burn damage."
	button_icon_state = "elemental_improvement"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/elemental_improvement/Trigger()
	. = ..()
	if(allowed_to_proceed)
		animate(owner, color = "#6a839a", time = 10)
		if(ishuman(owner))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/electro_cast.ogg', 75, FALSE)
			var/mob/living/carbon/human/H = owner
			H.physiology.armor.melee = 25
			H.physiology.armor.bullet = 45
			to_chat(owner, "<span class='notice'>You feel your skin replaced with the machine...</span>")
			spawn(20 SECONDS)
				H.physiology.armor.melee = initial(H.physiology.armor.melee)
				H.physiology.armor.bullet = initial(H.physiology.armor.bullet)
				to_chat(owner, "<span class='warning'>Your skin is natural again...</span>")
				owner.color = "#FFFFFF"
		else
			playsound(get_turf(owner), 'code/modules/wod13/sounds/electro_cast.ogg', 75, FALSE)
			var/mob/living/carbon/werewolf/H = owner
			H.werewolf_armor = 45
			to_chat(owner, "<span class='notice'>You feel your skin replaced with the machine...</span>")
			spawn(20 SECONDS)
				H.werewolf_armor = initial(H.werewolf_armor)
				to_chat(owner, "<span class='warning'>Your skin is natural again...</span>")
				owner.color = "#FFFFFF"
