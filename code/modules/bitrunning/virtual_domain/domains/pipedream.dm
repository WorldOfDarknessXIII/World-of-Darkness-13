/datum/lazy_template/virtual_domain/pipedream
	name = "Disposal Pipe Factory"
	cost = BITRUNNER_COST_LOW
	desc = "An abandoned and infested factory manufacturing disposal pipes."
	difficulty = BITRUNNER_DIFFICULTY_LOW
	completion_loot = list(/obj/item/stack/pipe_cleaner_coil/random/five = 1)
	help_text = "Not long ago, this place was thriving with activity. The workers \
	seemed to have left in a hurry, and now productivity is in the bin. Something \
	must have trashed the place, but what?"
	is_modular = TRUE
	key = "pipedream"
	map_name = "pipedream"
	mob_modules = list(
		/datum/modular_mob_segment/hivebots,
		/datum/modular_mob_segment/hivebots_strong
	)
	reward_points = BITRUNNER_REWARD_LOW

// ID Cards
/obj/item/card/id/advanced/factory
	name = "factory worker ID"

/obj/item/card/id/advanced/factory/qm
	name = "factory quartermaster ID"

//Outfits
/datum/outfit/factory
	name = "Factory Worker"

	id = /obj/item/card/id/advanced/
	uniform = /obj/item/clothing/under/rank/cargo/tech
	suit = /obj/item/clothing/suit/hazardvest
	belt = /obj/item/radio
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/soft/yellow
	shoes = /obj/item/clothing/shoes/workboots
	l_pocket = /obj/item/flashlight/seclite

/datum/outfit/factory/guard
	name = "Factory Guard"

	uniform = /obj/item/clothing/under/rank/security/officer/grey
	suit = /obj/item/clothing/suit/armor/vest/alt
	belt = /obj/item/radio
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/soft/sec
	shoes = /obj/item/clothing/shoes/jackboots/sec
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld

/datum/outfit/factory/qm
	name = "Factory Quartermaster"

	id = /obj/item/card/id/advanced/silver
	uniform = /obj/item/clothing/under/rank/cargo/qm
	belt = /obj/item/radio
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/soft/yellow
	shoes = /obj/item/clothing/shoes/jackboots/sec
	l_pocket = /obj/item/melee/baton/telescopic
	r_pocket = /obj/item/stamp/head/qm

// Corpses
/obj/effect/mob_spawn/corpse/human/factory
	name = "Factory Worker"
	outfit = /datum/outfit/factory
	icon_state = "corpsecargotech"

/obj/effect/mob_spawn/corpse/human/factory/guard
	name = "Factory Guard"
	outfit = /datum/outfit/factory/guard
	icon_state = "corpsecargotech"

/obj/effect/mob_spawn/corpse/human/factory/qm
	name = "Factory Quartermaster"
	outfit = /datum/outfit/factory/qm
	icon_state = "corpsecargotech"

