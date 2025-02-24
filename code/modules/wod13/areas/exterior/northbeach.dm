/area/vtm/northbeach
	name = "North Beach"
	icon_state = "northbeach"
	ambience_index = AMBIENCE_BEACH
	music = /datum/vampiremusic/santamonica
	upper = TRUE

/area/vtm/northbeach/Entered(mob/living/entrant)
	..()
	if(!entrant || entrant?.client?.ambience_playing)
		return

	entrant.client.ambience_playing = 1
	SEND_SOUND(entrant, sound('code/modules/wod13/sounds/beach.ogg', repeat = 1, wait = 0, volume = 35, channel = CHANNEL_BUZZ))
