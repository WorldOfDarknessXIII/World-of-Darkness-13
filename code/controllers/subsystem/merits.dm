SUBSYSTEM_DEF(merits)
	name = "Merits"
	init_order = INIT_ORDER_MERITS
	var/list/datum/merit/merit_types = list()
	initialized = FALSE

/datum/controller/subsystem/merits/Initialize()
	for(var/merit in subtypesof(/datum/merit))
		var/datum/merit/_merit = new merit()
		if(_merit.generic)
			continue
		merit_types[merit] = _merit
	return ..()
