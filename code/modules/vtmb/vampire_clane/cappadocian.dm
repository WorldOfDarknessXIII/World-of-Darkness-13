/datum/vampireclane/cappadocian
	name = "Cappadocian"
	desc = "A presumed-to-be-extinct Clan of necromancers, the Cappadocians studied death specifically in the physical world. The Giovanni were Embraced into their line to help further their studies into the underworld. They were rewarded with Diablerie and the destruction of their Clan and founder."
	curse = "Extremely corpselike appearance that worsens with age."
	clane_disciplines = list(
		/datum/discipline/auspex = 1,
		/datum/discipline/fortitude = 2,
		/datum/discipline/necromancy = 3
	)
	violating_appearance = FALSE
	alt_sprite = "rotten1"
	alt_sprite_greyscale = TRUE

	whitelisted = TRUE

/datum/vampireclane/cappadocian/on_gain(mob/living/carbon/human/H)
	var/years_undead = H.chronological_age - H.age
	switch(years_undead)
		if (-INFINITY to 100)
			rot_body(1)
		if (100 to 300)
			rot_body(2)
		if (300 to 500)
			rot_body(3)
		if (500 to INFINITY)
			rot_body(4)

	..()

