//orphaned proc free to a good home (folder)
/mob/living/proc/handle_vampire_music()
	if(!client)
		return
	if(stat == DEAD)
		return

	var/turf/T

	if(!isturf(loc))
		var/atom/A = loc
		if(!isturf(A.loc))
			return
		T = A.loc
	else
		T = loc

	if(istype(get_area(T), /area/vtm))
		var/area/vtm/VTM = get_area(T)
		if(VTM)
			/*
			if(VTM.upper)
				if(SScityweather.raining)
					SEND_SOUND(src, sound('code/modules/wod13/sounds/rain.ogg', 0, 0, CHANNEL_RAIN, 25))
					wash(CLEAN_WASH)
			*/

			var/cacophony = FALSE

			if(iskindred(src))
				var/mob/living/carbon/human/H = src
				if(H.clane)
					if(H.clane.name == "Daughters of Cacophony")
						cacophony = FALSE //This Variable was TRUE, which makes the DoC music loop play.

			if(!cacophony)
				if(!(client && (client.prefs.toggles & SOUND_AMBIENCE)))
					return

				if(!VTM.music)
					client << sound(null, 0, 0, CHANNEL_LOBBYMUSIC)
					last_vampire_ambience = 0
					wait_for_music = 0
					return
				var/datum/vampiremusic/VMPMSC = new VTM.music()
				if(VMPMSC.forced && wait_for_music != VMPMSC.length)
					client << sound(null, 0, 0, CHANNEL_LOBBYMUSIC)
					last_vampire_ambience = 0
					wait_for_music = 0
					wasforced = TRUE

				else if(wasforced && wait_for_music != VMPMSC.length)
					client << sound(null, 0, 0, CHANNEL_LOBBYMUSIC)
					last_vampire_ambience = 0
					wait_for_music = 0
					wasforced = FALSE

				if(last_vampire_ambience+wait_for_music+10 < world.time)
					wait_for_music = VMPMSC.length
					client << sound(VMPMSC.sound, 0, 0, CHANNEL_LOBBYMUSIC, 10)
					last_vampire_ambience = world.time
				qdel(VMPMSC)
			else
				if(last_vampire_ambience+wait_for_music+10 < world.time)
					wait_for_music = 1740
					client << sound('code/modules/wod13/sounds/daughters.ogg', 0, 0, CHANNEL_LOBBYMUSIC, 5)
					last_vampire_ambience = world.time
