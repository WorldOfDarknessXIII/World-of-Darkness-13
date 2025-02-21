/datum/martial_art/cowalker
	name = "Cowalker"
	id = MARTIALART_COWALKER
	allow_temp_override = FALSE

/datum/martial_art/cowalker/on_projectile_hit(mob/living/A, obj/projectile/P, def_zone)
	. = ..()
	if(iskindred(A) && A.temporis_visual == TRUE)
		if(prob(75))
			A.visible_message("<span class='danger'>The projectiles seem to phase through [A]! You shot at the wrong copy!</span>", "<span class='userdanger'>They shot the wrong you!</span>")
			playsound(get_turf(A), pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, TRUE)
			return BULLET_ACT_FORCE_PIERCE
		return BULLET_ACT_HIT
	else if(iskindred(A) && A.temporis_blur == TRUE)
		A.visible_message("<span class='danger'>[A] moved out of the way before you even pulled the trigger! They can move faster than your shots!</span>", "<span class='userdanger'>You stepped out of the way of the bullets!</span>")
		playsound(get_turf(A), pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, TRUE)
		return BULLET_ACT_FORCE_PIERCE

	return BULLET_ACT_HIT
