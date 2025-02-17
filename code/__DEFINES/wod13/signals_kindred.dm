// This is the new signals file for every signal vampire related in WOD13
// New signals related to vampires and things vampires do should be defined here

///called in bloodsucking.dm at the end of /mob/living/carbon/human/proc/drinksomeblood
#define COMSIG_MOB_VAMPIRE_SUCKED "mob_vampire_sucked"
	///vampire suck resisted
	#define COMPONENT_RESIST_VAMPIRE_KISS (1<<0)
