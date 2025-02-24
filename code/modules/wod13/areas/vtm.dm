/area/vtm
	name = "San Francisco"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "sewer"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	var/music
	var/upper = TRUE
	var/zone_type = "masquerade"
	var/zone_owner

/area/vtm/powered(chan)
	if(!requires_power)
		return TRUE
	return FALSE

/area/vtm/Entered(mob/living/entrant)
	..()
	if(!entrant || !entrant?.client?.ambience_playing)
		return
	entrant.client.ambience_playing = 0
	SEND_SOUND(entrant, sound(null, channel = CHANNEL_BUZZ))