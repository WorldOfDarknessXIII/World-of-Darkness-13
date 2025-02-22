/datum/martial_art/cowalker
	name = "Cowalker"
	id = MARTIALART_COWALKER
	allow_temp_override = FALSE

/datum/martial_art/cowalker/on_teach(mob/living/new_holder)
	RegisterSignal(new_holder, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(hit_by_projectile))


/datum/martial_art/cowalker/proc/hit_by_projectile(mob/living/A, obj/projectile/hitting_projectile, def_zone)
	SIGNAL_HANDLER

	if(iskindred(A) && A.temporis_visual == TRUE)
		if(prob(75))
			A.visible_message("<span class='danger'>The projectiles seem to phase through [A]! You shot at the wrong copy!</span>", "<span class='userdanger'>They shot the wrong you!</span>")
			playsound(get_turf(A), pick('sound/items/weapons/bulletflyby.ogg', 'sound/items/weapons/bulletflyby2.ogg', 'sound/items/weapons/bulletflyby3.ogg'), 75, TRUE)
			return BULLET_ACT_FORCE_PIERCE
		return BULLET_ACT_HIT
	else if(iskindred(A) && A.temporis_blur == TRUE)
		A.visible_message("<span class='danger'>[A] moved out of the way before you even pulled the trigger! They can move faster than your shots!</span>", "<span class='userdanger'>You stepped out of the way of the bullets!</span>")
		playsound(get_turf(A), pick('sound/items/weapons/bulletflyby.ogg', 'sound/items/weapons/bulletflyby2.ogg', 'sound/items/weapons/bulletflyby3.ogg'), 75, TRUE)
		return BULLET_ACT_FORCE_PIERCE

	return BULLET_ACT_HIT
