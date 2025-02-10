/datum/splat/supernatural/garou
	splat_id = "garou"
	power_stat_name = "Gnosis"
	power_stat_max = 5
	var/rage = 1


/proc/adjust_rage(var/amount, var/mob/living/carbon/C, var/sound = TRUE)
	if(amount > 0)
		if(C.auspice.rage < 10)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/rage_increase.ogg', 0, 0, 75))
			to_chat(C, "<span class='userdanger'><b>RAGE INCREASES</b></span>")
			C.auspice.rage = min(10, C.auspice.rage+amount)
	if(amount < 0)
		if(C.auspice.rage > 0)
			C.auspice.rage = max(0, C.auspice.rage+amount)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/rage_decrease.ogg', 0, 0, 75))
			to_chat(C, "<span class='userdanger'><b>RAGE DECREASES</b></span>")
	C.update_rage_hud()

	if(amount && sound)
		if(prob(20))
			C.emote("growl")
			if(iscrinos(C))
				playsound(get_turf(C), 'code/modules/wod13/sounds/crinos_growl.ogg', 75, FALSE)
			if(islupus(C))
				playsound(get_turf(C), 'code/modules/wod13/sounds/lupus_growl.ogg', 75, FALSE)
			if(isgarou(C))
				if(C.gender == FEMALE)
					playsound(get_turf(C), 'code/modules/wod13/sounds/female_growl.ogg', 75, FALSE)
				else
					playsound(get_turf(C), 'code/modules/wod13/sounds/male_growl.ogg', 75, FALSE)

/proc/adjust_gnosis(var/amount, var/mob/living/carbon/C, var/sound = TRUE)
	if(amount > 0)
		if(C.auspice.gnosis < C.auspice.start_gnosis)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
			to_chat(C, "<span class='boldnotice'><b>GNOSIS INCREASES</b></span>")
			C.auspice.gnosis = min(C.auspice.start_gnosis, C.auspice.gnosis+amount)
	if(amount < 0)
		if(C.auspice.gnosis > 0)
			C.auspice.gnosis = max(0, C.auspice.gnosis+amount)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/rage_decrease.ogg', 0, 0, 75))
			to_chat(C, "<span class='boldnotice'><b>GNOSIS DECREASES</b></span>")
	C.update_rage_hud()

/datum/splat/supernatural/garou/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(HAS_TRAIT(H, TRAIT_UNMASQUERADE))
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.adjust_veil(-1)
	if(istype(get_area(H), /area/vtm))
		var/area/vtm/V = get_area(H)
		if(V.zone_type == "masquerade" && V.upper)
			if(H.pulling)
				if(ishuman(H.pulling))
					var/mob/living/carbon/human/pull = H.pulling
					if(pull.stat == DEAD)
						var/obj/item/card/id/id_card = H.get_idcard(FALSE)
						if(!istype(id_card, /obj/item/card/id/clinic))
							if(H.CheckEyewitness(H, H, 7, FALSE))
								if(H.last_loot_check+50 <= world.time)
									H.last_loot_check = world.time
									H.last_nonraid = world.time
									H.killed_count = H.killed_count+1
									if(!H.warrant && !H.ignores_warrant)
										if(H.killed_count >= 5)
											H.warrant = TRUE
											SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
										else
											SEND_SOUND(H, sound('code/modules/wod13/sounds/sus.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>SUSPICIOUS ACTION (corpse)</b></span>")
			for(var/obj/item/I in H.contents)
				if(I)
					if(I.masquerade_violating)
						if(I.loc == H)
							if(H.CheckEyewitness(H, H, 7, FALSE))
								if(H.last_loot_check+50 <= world.time)
									H.last_loot_check = world.time
									H.last_nonraid = world.time
									H.killed_count = H.killed_count+1
									if(!H.warrant && !H.ignores_warrant)
										if(H.killed_count >= 5)
											H.warrant = TRUE
											SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
										else
											SEND_SOUND(H, sound('code/modules/wod13/sounds/sus.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>SUSPICIOUS ACTION (equipment)</b></span>")
	if((H.last_bloodpool_restore + 60 SECONDS) <= world.time)
		H.last_bloodpool_restore = world.time
		H.bloodpool = min(H.maxbloodpool, H.bloodpool+1)
	if(glabro)
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.adjust_veil(-1)
