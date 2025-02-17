/obj/structure/weedshit
	name = "hydroponics"
	desc = "Definitely not for the weed."
	icon = 'code/modules/wod13/weed.dmi'
	icon_state = "soil_dry0"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	var/wet = FALSE
	var/growth_stage = 0
	var/health = 3

/obj/structure/weedshit/buyable
	anchored = FALSE

/obj/structure/weedshit/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to [anchored ? "un" : ""]secure [src] [anchored ? "from" : "to"] the ground.</span>"
	if(!wet)
		. += "<span class='warning'>[src] is dry!</span>"
	if(growth_stage == 5)
		. += "<span class='warning'>The crop is dead!</span>"
	else
		if(health <= 2)
			. += "<span class='warning'>The crop is looking unhealthy.</span>"

/obj/structure/weedshit/attack_hand(mob/user, params)
	. = ..()
	if(growth_stage == 5)
		growth_stage = 0
		health = 3
		to_chat(user, "<span class='notice'>You rip the rotten weed out of [src].</span>")
	if(growth_stage == 4)
		growth_stage = 1
		to_chat(user, "<span class='notice'>You pull the grown weed out of [src].</span>")
		var/mob/living/carbon/human/H = user
		var/amount
		switch(storyteller_roll(H.get_total_mentality(), 6, TRUE))
			if(3 to INFINITY)
				amount = 4
			if(2)
				amount = 3
			if(1)
				amount = 2
			else
				amount = 1
		for(var/i = 1 to amount)
			new /obj/item/food/vampire/weed(get_turf(user))
	update_weed_icon()

/obj/structure/weedshit/AltClick(mob/user)
	if(!user.Adjacent(src))
		return
	to_chat(user, "<span class='notice'>You start [anchored ? "unsecuring" : "securing"] [src] [anchored ? "from" : "to"] the ground.</span>")
	if(do_after(user, 15))
		if(anchored)
			to_chat(user, "<span class='notice'>You unsecure [src] from the ground.</span>")
			anchored = FALSE
			return
		else
			to_chat(user, "<span class='notice'>You secure [src] to the ground.</span>")
			anchored = TRUE
			return

/obj/structure/weedshit/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/bailer))
		var/obj/item/bailer/B = W
		if(B.amount_of_water)
			B.amount_of_water = max(0, B.amount_of_water-1)
			wet = TRUE
			to_chat(user, "<span class='notice'>You fill [src] with water.</span>")
			playsound(src, 'sound/effects/refill.ogg', 50, TRUE)
			call_dharma("cleangrow", user)
		else
			to_chat(user, "<span class='warning'>[W] is empty!</span>")
	if(istype(W, /obj/item/weedseed))
		if(growth_stage == 0)
			health = 3
			growth_stage = 1
			qdel(W)
	update_weed_icon()
	return

/obj/structure/weedshit/Initialize()
	. = ..()
	GLOB.weed_list += src

/obj/structure/weedshit/Destroy()
	. = ..()
	GLOB.weed_list -= src

/obj/structure/weedshit/proc/update_weed_icon()
	icon_state = "soil[wet ? "" : "_dry"][growth_stage]"
