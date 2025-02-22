/datum/looping_sound/void_loop
	mid_sounds = list('sound/ambience/VoidsEmbrace.ogg'=1)
	mid_length = 1669 // exact length of the music in ticks
	volume = 100
	extra_range = 30

/datum/looping_sound/void_loop/start(atom/add_thing)
	. = ..()
