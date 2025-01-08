/obj/lombard
	name = "pawnshop"
	desc = "Sell your stuff."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	icon_state = "sell"
	icon = 'code/modules/wod13/props.dmi'
	anchored = TRUE
	var/illegal = FALSE

/obj/lombard/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/stack))
		return
	if(istype(W, /obj/item/organ))
		var/obj/item/organ/O = W
		if(O.damage > round(O.maxHealth/2))
			to_chat(user, "<span class='warning'>[W] is too damaged to sell!</span>")
			return
	if(W.cost > 0)
		if(W.illegal == illegal)
			for(var/i in 1 to (W.cost / 5) * (user.social + (user.additional_social * 0.1)))
				new /obj/item/stack/dollar(loc)
			playsound(loc, 'code/modules/wod13/sounds/sell.ogg', 50, TRUE)
			if(istype(W, /obj/item/organ))
				var/mob/living/carbon/human/H = user
				to_chat(src, "<span class='userdanger'><b>Selling organs is a depraved act! If I keep doing this I will become a wight.</b></span>")
				H.AdjustHumanity(-1, 0)
			else if(istype(W, /obj/item/reagent_containers/food/drinks/meth/cocaine))
				var/mob/living/carbon/human/H = user
				H.AdjustHumanity(-1, 5)
			else if(istype(W, /obj/item/reagent_containers/food/drinks/meth))
				var/mob/living/carbon/human/H = user
				H.AdjustHumanity(-1, 4)
			else if(illegal)
				var/mob/living/carbon/human/H = user
				H.AdjustHumanity(-1, 7)
			qdel(W)
			return
	else
		..()

/obj/lombard/blackmarket
	name = "black market"
	desc = "Sell illegal goods."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	icon_state = "sell_d"
	icon = 'code/modules/wod13/props.dmi'
	anchored = TRUE
	illegal = TRUE
