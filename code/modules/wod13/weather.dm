SUBSYSTEM_DEF(cityweather)
	name = "City Weather"
	init_order = INIT_ORDER_DEFAULT
	wait = 600
	priority = FIRE_PRIORITY_DEFAULT

	var/current_weather = "Clear"	//"Clear", "Rain" and "Fog"
	var/list/forecast = list()
	var/raining = FALSE
	var/fogging = FALSE
	var/snowing = FALSE

/datum/controller/subsystem/cityweather/fire()
	if(SScity_time.hour > 5 && SScity_time.hour < 21)
		return

	if(raining && length(GLOB.cleanable_list))
		var/obj/effect/decal/cleanable/C = pick(GLOB.cleanable_list)
		if(C)
			qdel(C)

//	if(raining)
//		var/turf/T = pick(affected_turfs)
//		T.wash(CLEAN_SCRUB)

//	for(var/i in 1 to 9)
//		var/weath = forecast[i]
//		to_chat(world, "DEBUG, [i], [weath]")

	var/cityhour = 1
	switch(SScity_time.hour)
		if(21)
			cityhour = 1
		if(22)
			cityhour = 2
		if(23)
			cityhour = 3
		if(0)
			cityhour = 4
		if(1)
			cityhour = 5
		if(2)
			cityhour = 6
		if(3)
			cityhour = 7
		if(4)
			cityhour = 8
		if(5)
			cityhour = 9

	if(forecast[cityhour] != current_weather)
		current_weather = forecast[cityhour]
		switch(forecast[cityhour])
			if("Clear")
				to_chat(world, "The night sky becomes clear...")
				if(raining)
					for(var/obj/effect/vamp_weather/V in GLOB.rain_suka)
						V.invisibility = INVISIBILITY_MAXIMUM
						animate(V, transform = null, pixel_w = 0, pixel_z = 0, alpha = 255)
				raining = FALSE
				if(fogging)
					for(var/obj/effect/vamp_weather/V in GLOB.rain_suka)
						V.invisibility = INVISIBILITY_MAXIMUM
						animate(V, transform = null, pixel_w = 0, pixel_z = 0, alpha = 255)
				fogging = FALSE
				if(snowing)
					for(var/obj/effect/vamp_weather/V in GLOB.rain_suka)
						V.invisibility = INVISIBILITY_MAXIMUM
						animate(V, transform = null, pixel_w = 0, pixel_z = 0, alpha = 255)
				snowing = FALSE
			if("Rain")
				to_chat(world, "Clouds are uniting on the sky, small raindrops irrigate the city...")
				raining = TRUE
				if(fogging)
					for(var/obj/effect/vamp_weather/V in GLOB.rain_suka)
						V.invisibility = INVISIBILITY_MAXIMUM
						animate(V, transform = null, pixel_w = 0, pixel_z = 0, alpha = 255)
				fogging = FALSE
				if(snowing)
					for(var/obj/effect/vamp_weather/V in GLOB.rain_suka)
						V.invisibility = INVISIBILITY_MAXIMUM
						animate(V, transform = null, pixel_w = 0, pixel_z = 0, alpha = 255)
				snowing = FALSE
				for(var/obj/effect/vamp_weather/V in GLOB.rain_suka)
					V.invisibility = 0
					animate(V, transform = null, pixel_w = 0, pixel_z = 0, alpha = 255)
					V.layer = SPACEVINE_LAYER
					V.plane = GAME_PLANE
					V.icon = 'icons/wod13/newweather.dmi'
					V.icon_state = "rain[rand(1, 15)]"
					V.pixel_w = -16
					V.pixel_z = -32
					var/matrix/M = new
					M.Scale(0.5, 0.5)
					V.transform = M
			if("Snow")
				to_chat(world, "Clouds are uniting on the sky, small snowflakes irrigate the city...")
				if(raining)
					for(var/obj/effect/vamp_weather/V in GLOB.rain_suka)
						V.invisibility = INVISIBILITY_MAXIMUM
						animate(V, transform = null, pixel_w = 0, pixel_z = 0, alpha = 255)
				raining = FALSE
				if(fogging)
					for(var/obj/effect/vamp_weather/V in GLOB.rain_suka)
						V.invisibility = INVISIBILITY_MAXIMUM
						animate(V, transform = null, pixel_w = 0, pixel_z = 0, alpha = 255)
				fogging = FALSE
				snowing = TRUE
				for(var/obj/effect/vamp_weather/V in GLOB.rain_suka)
					V.invisibility = 0
					animate(V, transform = null, pixel_w = 0, pixel_z = 0, alpha = 255)
					V.layer = SPACEVINE_LAYER
					V.plane = GAME_PLANE
					V.icon = 'icons/wod13/newweather.dmi'
					V.icon_state = "snow[rand(1, 15)]"
					V.pixel_w = -16
					V.pixel_z = 0
			if("Fog")
				to_chat(world, "Visibility range quickly decreases...")
				if(raining)
					for(var/obj/effect/vamp_weather/V in GLOB.rain_suka)
						V.invisibility = INVISIBILITY_MAXIMUM
						animate(V, transform = null, pixel_w = 0, pixel_z = 0, alpha = 255)
				raining = FALSE
				fogging = TRUE
				if(snowing)
					for(var/obj/effect/vamp_weather/V in GLOB.rain_suka)
						V.invisibility = INVISIBILITY_MAXIMUM
						animate(V, transform = null, pixel_w = 0, pixel_z = 0, alpha = 255)
				snowing = FALSE
				for(var/obj/effect/vamp_weather/V in GLOB.rain_suka)
					V.invisibility = 0
					animate(V, transform = null, pixel_w = 0, pixel_z = 0, alpha = 255)
					V.layer = SPACEVINE_LAYER
					V.plane = GAME_PLANE
					V.icon = 'icons/wod13/fog.dmi'
					V.icon_state = "fog"
					V.pixel_w = -96
					V.pixel_z = -96
					animate(V, pixel_x = rand(-96, 96), pixel_y = rand(-96, 96), alpha = rand(5, 21), transform = matrix()*rand(1, 3), transform = turn(matrix(), rand(0, 360)), time = rand(100, 200), loop = -1)
					animate(transform = null, pixel_x = 0, pixel_y = 0, alpha = rand(5, 21), time = rand(100, 200))

/datum/controller/subsystem/cityweather/Initialize()
	. = ..()
	create_forecast()

/datum/controller/subsystem/cityweather/proc/create_forecast()
	for(var/i in 1 to 9)
		forecast += i
		var/weather = "Clear"
		if(i != 1 && i != 9)
			if(prob(50))
				if(GLOB.winter)
					weather = pick("Clear", "Snow", "Fog")
				else
					weather = pick("Clear", "Rain", "Fog")
		forecast[i] = weather

/datum/controller/subsystem/cityweather/proc/get_forecast(mob/user)
	for(var/i in 1 to 9)
		var/weath = forecast[i]
		var/time = "21:00"
		switch(i)
			if(1)
				time = "21:00"
			if(2)
				time = "22:00"
			if(3)
				time = "23:00"
			if(4)
				time = "00:00"
			if(5)
				time = "01:00"
			if(6)
				time = "02:00"
			if(7)
				time = "03:00"
			if(8)
				time = "04:00"
			if(9)
				time = "05:00"
		to_chat(user, "[time], [weath]")

/obj/effect/realistic_fog
	icon = 'icons/wod13/fog.dmi'
	icon_state = "fog"
	alpha = 0
	plane = GAME_PLANE
	layer = SPACEVINE_LAYER
	anchored = TRUE
	density = FALSE
	mouse_opacity = 0
	pixel_w = -96
	pixel_z = -96

/obj/effect/realistic_fog/Initialize()
	. = ..()
	animate(src, pixel_x = rand(-96, 96), pixel_y = rand(-96, 96), alpha = rand(5, 21), transform = matrix()*rand(1, 3), transform = turn(matrix(), rand(0, 360)), time = rand(100, 200), loop = -1)
	animate(transform = null, pixel_x = 0, pixel_y = 0, alpha = rand(5, 21), time = rand(100, 200))

/obj/effect/new_rain
	icon = 'icons/wod13/newweather.dmi'
	icon_state = "rain1"
	alpha = 0
	plane = GAME_PLANE
	layer = SPACEVINE_LAYER
	anchored = TRUE
	density = FALSE
	mouse_opacity = 0
	pixel_w = -16
	pixel_z = -32

/obj/effect/new_rain/Initialize()
	. = ..()
	icon_state = "rain[rand(1, 15)]"
	var/matrix/M = new
	M.Scale(0.5, 0.5)
	transform = M
	animate(src, alpha = 64, time = 30)

/obj/effect/new_rain/Cross(atom/movable/AM)
	. = ..()
	if(isitem(AM))
		AM.wash(CLEAN_WASH)

/obj/effect/new_snow
	icon = 'icons/wod13/newweather.dmi'
	icon_state = "snow1"
	alpha = 0
	plane = GAME_PLANE
	layer = SPACEVINE_LAYER
	anchored = TRUE
	density = FALSE
	mouse_opacity = 0
	pixel_w = -16

/obj/effect/new_snow/Initialize()
	. = ..()
	icon_state = "snow[rand(1, 15)]"
	animate(src, alpha = 128, time = 30)

/obj/effect/vamp_weather
	plane = GAME_PLANE
	layer = SPACEVINE_LAYER
	anchored = TRUE
	density = FALSE
	mouse_opacity = 0

/obj/effect/vamp_weather/Initialize()
	. = ..()
	GLOB.rain_suka += src

/turf/open/Initialize()
	. = ..()
	if(istype(get_area(src), /area/vtm))
		var/area/vtm/V = get_area(src)
		if(V.upper)
			new /obj/effect/vamp_weather(src)


