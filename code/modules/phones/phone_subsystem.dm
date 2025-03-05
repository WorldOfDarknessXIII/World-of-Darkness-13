// Subsystem that is responsible for handling the phone system.
// Generates a list of all phone numbers roundstart and lists them respectively to who needs them.
// Handles phone calls.

SUBSYSTEM_DEF(phones)
	name = "Phones"
	init_order = INIT_ORDER_DEFAULT
	flags = SS_NO_FIRE

	var/list/assigned_phone_numbers = list() // Seven digits, always start with 5

/datum/controller/subsystem/phones/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/phones/proc/random_number()
	return rand(5000000, 5999999)

// If this ever goes over the hard limit of 1000000 phone numbers, we have a problem.
/datum/controller/subsystem/phones/proc/generate_phone_number(obj/item/sim_card/sim_card)
	for(var/generation_attempt in 1 to 1000000)
		var/randomly_generated_phone_number = random_number()
		if(randomly_generated_phone_number in assigned_phone_numbers)
			continue
		assigned_phone_numbers[sim_card] |= randomly_generated_phone_number
		return randomly_generated_phone_number
	CRASH("[src] failed to generate a unique phone number after 1000000 attempts.")
