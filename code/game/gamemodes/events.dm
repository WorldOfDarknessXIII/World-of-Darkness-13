

	priority_announce("All SMESs on [station_name()] have been recharged. We apologize for the inconvenience.", "Power Systems Nominal", 'sound/ai/poweron.ogg')
	for(var/obj/machinery/power/smes/S in GLOB.machines)
		if(!is_station_level(S.z))
			continue
		S.charge = S.capacity
		S.output_level = S.output_level_max
		S.output_attempt = TRUE
		S.update_icon()
		S.power_change()

