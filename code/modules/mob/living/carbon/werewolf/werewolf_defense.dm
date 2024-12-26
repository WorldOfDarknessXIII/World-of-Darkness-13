
/mob/living/carbon/werewolf/get_eye_protection()
	return ..() + 2 //potential cyber implants + natural eye protection

/mob/living/carbon/werewolf/get_ear_protection()
	return 2 //no ears

/mob/living/carbon/werewolf/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	..(AM, skipcatch = TRUE, hitpush = FALSE)

/mob/living/carbon/werewolf/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(.)	//to allow surgery to return properly.
		return FALSE

	switch(M.a_intent)
		if("help")
			help_shake_act(M)
		if("grab")
			grabbedby(M)
		if ("harm")
			M.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
			return TRUE
		if("disarm")
			M.do_attack_animation(src, ATTACK_EFFECT_DISARM)
			return TRUE
	return FALSE

/mob/living/carbon/werewolf/attack_animal(mob/living/simple_animal/M)
	. = ..()
	do_werewolf_rage_from_attack()
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		switch(M.melee_damage_type)
			if(BRUTE)
				adjustBruteLoss(damage)
			if(BURN)
				adjustFireLoss(damage)
			if(TOX)
				adjustToxLoss(damage)
			if(OXY)
				adjustOxyLoss(damage)
			if(CLONE)
				adjustCloneLoss(damage)
			if(STAMINA)
				adjustStaminaLoss(damage)

/mob/living/carbon/werewolf/ex_act(severity, target, origin)
	if(origin && istype(origin, /datum/spacevine_mutation) && isvineimmune(src))
		return
	..()
	if(QDELETED(src))
		return
	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	switch (severity)
		if (EXPLODE_DEVASTATE)
			gib()
			return

		if (EXPLODE_HEAVY)
			take_overall_damage(60, 60)
			if(ears)
				ears.adjustEarDamage(30,120)

		if(EXPLODE_LIGHT)
			take_overall_damage(30,0)
			if(prob(50))
				Unconscious(20)
			if(ears)
				ears.adjustEarDamage(15,60)

/mob/living/carbon/werewolf/soundbang_act(intensity = 1, stun_pwr = 20, damage_pwr = 5, deafen_pwr = 15)
	return 0

/mob/living/carbon/werewolf/acid_act(acidpwr, acid_volume)
	return FALSE//aliens are immune to acid.

/mob/living/carbon/werewolf/attack_hand(mob/living/carbon/human/M)
	if(..())
		switch(M.a_intent)
			if ("harm")
				var/damage = rand(1, 9)
				if (prob(90))
					playsound(loc, "punch", 25, TRUE, -1)
					visible_message("<span class='danger'>[M] punches [src]!</span>", \
									"<span class='userdanger'>[M] punches you!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, M)
					to_chat(M, "<span class='danger'>You punch [src]!</span>")
					if ((stat != DEAD) && (damage > 9 || prob(5)))//Regular humans have a very small chance of knocking an alien down.
						Unconscious(3 SECONDS)
						visible_message("<span class='danger'>[M] knocks [src] down!</span>", \
										"<span class='userdanger'>[M] knocks you down!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", null, M)
						to_chat(M, "<span class='danger'>You knock [src] down!</span>")
					var/obj/item/bodypart/affecting = get_bodypart(ran_zone(M.zone_selected))
					apply_damage(damage, BRUTE, affecting)
					log_combat(M, src, "attacked")
				else
					playsound(loc, 'sound/weapons/punchmiss.ogg', 25, TRUE, -1)
					visible_message("<span class='danger'>[M]'s punch misses [src]!</span>", \
									"<span class='danger'>You avoid [M]'s punch!</span>", "<span class='hear'>You hear a swoosh!</span>", COMBAT_MESSAGE_RANGE, M)
					to_chat(M, "<span class='warning'>Your punch misses [src]!</span>")

			if ("disarm")
				if (body_position == STANDING_UP)
					if (prob(5))
						Unconscious(3 SECONDS)
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
						log_combat(M, src, "pushed")
						visible_message("<span class='danger'>[M] pushes [src] down!</span>", \
										"<span class='userdanger'>[M] pushes you down!</span>", "<span class='hear'>You hear aggressive shuffling followed by a loud thud!</span>", null, M)
						to_chat(M, "<span class='danger'>You push [src] down!</span>")
					else
						if (prob(50))
							dropItemToGround(get_active_held_item())
							playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
							visible_message("<span class='danger'>[M] disarms [src]!</span>", \
											"<span class='userdanger'>[M] disarms you!</span>", "<span class='hear'>You hear aggressive shuffling!</span>", COMBAT_MESSAGE_RANGE, M)
							to_chat(M, "<span class='danger'>You disarm [src]!</span>")
						else
							playsound(loc, 'sound/weapons/punchmiss.ogg', 25, TRUE, -1)
							visible_message("<span class='danger'>[M] fails to disarm [src]!</span>",\
											"<span class='danger'>[M] fails to disarm you!</span>", "<span class='hear'>You hear a swoosh!</span>", COMBAT_MESSAGE_RANGE, M)
							to_chat(M, "<span class='warning'>You fail to disarm [src]!</span>")



/mob/living/carbon/werewolf/crinos/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_CLAW
	..()

/mob/living/carbon/werewolf/lupus/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_BITE
	..()

/mob/living/carbon/werewolf/getarmor(def_zone, type)
	if(type == BRUTE)
		return werewolf_armor
	else
		return 0
