/mob/living/carbon/werewolf/Life()
	update_icons()
	update_rage_hud()
	return..()

/mob/living/carbon/Life()
	. = ..()
	if(isgarou(src) || iswerewolf(src))
		if(key && stat <= HARD_CRIT)
			var/datum/preferences/P = GLOB.preferences_datums[ckey(key)]
			if(P)
				if(P.masquerade != masquerade)
					P.masquerade = masquerade
					P.save_preferences()
					P.save_character()


		if(stat != DEAD)
			var/gaining_rage = TRUE
			for(var/obj/structure/werewolf_totem/W in GLOB.totems)
				if(W)
					if(W.totem_health)
						if(W.tribe == auspice.tribe)
							if(get_area(W) == get_area(src) && client)
								gaining_rage = FALSE
								if(last_gnosis_buff+300 < world.time)
									last_gnosis_buff = world.time
									adjust_gnosis(1, src, TRUE)
			if(iscrinos(src))
				if(auspice.base_breed == "Crinos")
					gaining_rage = FALSE
			//else if(auspice.rage == 0) //! [ChillRaccoon] - FIXME
			//	transformator.trans_gender(src, auspice.base_breed)
			if(islupus(src))
				if(auspice.base_breed == "Lupus")
					gaining_rage = FALSE
			//else if(auspice.rage == 0)
			//	transformator.trans_gender(src, auspice.base_breed)
			if(ishuman(src))
				if(auspice.base_breed == "Homid")
					gaining_rage = FALSE
			//else if(auspice.rage == 0)
			//	transformator.trans_gender(src, auspice.base_breed)

			if(gaining_rage && client)
				if((last_rage_gain + 1 MINUTES) < world.time)
					last_rage_gain = world.time
					adjust_rage(1, src, TRUE)

			if(masquerade == 0)
				if(!is_special_character(src))
					if(auspice.gnosis)
						to_chat(src, "<span class='warning'>My Veil is too low to connect with the spirits of Umbra!</span>")
						adjust_gnosis(-1, src, FALSE)

			if(auspice.rage >= 9)
				if(!in_frenzy)
					if((last_frenzy_check + 40 SECONDS) <= world.time)
						last_frenzy_check = world.time
						rollfrenzy()

			if(istype(get_area(src), /area/vtm/interior/penumbra))
				if((last_veil_restore + 40 SECONDS) < world.time)
					adjust_veil(1, src, TRUE)
					last_veil_restore = world.time

			switch(auspice.tribe)
				if("Wendigo")
					if(istype(get_area(src), /area/vtm/forest))
						if((last_veil_restore + 50 SECONDS) <= world.time)
							adjust_veil(1, src, TRUE)
							last_veil_restore = world.time

				if("Glasswalkers")
					if(istype(get_area(src), /area/vtm/interior/glasswalker))
						if((last_veil_restore + 50 SECONDS) <= world.time)
							adjust_veil(1, src, TRUE)
							last_veil_restore = world.time

				if("Black Spiral Dancers")
					if(istype(get_area(src), /area/vtm/interior/endron_facility))
						if((last_veil_restore + 50 SECONDS) <= world.time)
							adjust_veil(1, src, TRUE)
							last_veil_restore = world.time


/mob/living/carbon/werewolf/crinos/Life()
	. = ..()
	if(CheckEyewitness(src, src, 5, FALSE))
		adjust_veil(-1)

/mob/living/carbon/werewolf/check_breath(datum/gas_mixture/breath)
	return

/mob/living/carbon/werewolf/handle_status_effects()
	..()
	//natural reduction of movement delay due to stun.
	if(move_delay_add > 0)
		move_delay_add = max(0, move_delay_add - rand(1, 2))

/mob/living/carbon/werewolf/handle_changeling()
	return

/mob/living/carbon/werewolf/handle_fire()//Aliens on fire code
	. = ..()
	if(.) //if the mob isn't on fire anymore
		return
	adjust_bodytemperature(BODYTEMP_HEATING_MAX) //If you're on fire, you heat up!

/mob/living/carbon/proc/adjust_veil(var/amount)
	if(!GLOB.canon_event)
		return
	if(last_veil_adjusting+200 >= world.time)
		return
	if(amount > 0)
		if(HAS_TRAIT(src, TRAIT_VIOLATOR))
			return
	if(amount < 0)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.zone_type != "masquerade")
				return
	last_veil_adjusting = world.time
	if(!is_special_character(src))
		if(amount < 0)
			if(masquerade > 0)
				SEND_SOUND(src, sound('code/modules/wod13/sounds/veil_violation.ogg', 0, 0, 75))
				to_chat(src, "<span class='boldnotice'><b>VEIL VIOLATION</b></span>")
				masquerade = max(0, masquerade+amount)
		if(amount > 0)
			if(masquerade < 5)
				SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
				to_chat(src, "<span class='boldnotice'><b>VEIL REINFORCEMENT</b></span>")
				masquerade = min(5, masquerade+amount)
