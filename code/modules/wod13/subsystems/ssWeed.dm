SUBSYSTEM_DEF(weed)
	name = "Weed Growth"
	init_order = INIT_ORDER_DEFAULT
	wait = 1800
	priority = FIRE_PRIORITY_VERYLOW

/datum/controller/subsystem/weed/fire()
	for(var/obj/structure/weedshit/W in GLOB.weed_list)
		if(W)
			if(W.growth_stage != 0 && W.growth_stage != 5)
				if(!W.wet)
					if(W.health)
						W.health = max(0, W.health-1)
					else
						W.growth_stage = 5
				else if(W.health)
					if(prob(33))
						W.wet = FALSE
					W.health = min(3, W.health+1)
					W.growth_stage = min(4, W.growth_stage+1)
			W.update_weed_icon()
