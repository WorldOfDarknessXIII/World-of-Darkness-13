/datum/socialrole/bouncer
	is_criminal = TRUE

	//Appearence
	s_tones = list(
		"albino",
		"caucasian1",
		"caucasian2",
		"caucasian3",
		"latino",
		"mediterranean",
		"asian1",
		"asian2",
		"arab",
		"indian",
		"african1",
		"african2"
	)

	min_age = 18
	max_age = 85
	male_names = null
	surnames = null

	hair_colors = list(
		"040404",	//Black
		"120b05",	//Dark Brown
		"342414",	//Brown
		"554433",	//Light Brown
		"695c3b",	//Dark Blond
		"ad924e",	//Blond
		"dac07f",	//Light Blond
		"802400",	//Ginger
		"a5380e",	//Ginger alt
		"ffeace",	//Albino
		"650b0b",	//Punk Red
		"14350e",	//Punk Green
		"080918"	//Punk Blue
	)
	male_hair = list(
		"Balding Hair",
		"Bedhead",
		"Bedhead 2",
		"Bedhead 3",
		"Boddicker",
		"Business Hair",
		"Business Hair 2",
		"Business Hair 3",
		"Business Hair 4",
		"Coffee House",
		"Combover",
		"Crewcut",
		"Father",
		"Flat Top",
		"Gelled Back",
		"Joestar",
		"Keanu Hair",
		"Oxton",
		"Volaju"
	)
	male_facial = list(
		"Beard (Abraham Lincoln)",
		"Beard (Chinstrap)",
		"Beard (Full)",
		"Beard (Cropped Fullbeard)",
		"Beard (Hipster)",
		"Beard (Neckbeard)",
		"Beard (Three o Clock Shadow)",
		"Beard (Five o Clock Shadow)",
		"Beard (Seven o Clock Shadow)",
		"Moustache (Hulk Hogan)",
		"Moustache (Watson)",
		"Sideburns (Elvis)",
		"Sideburns",
		"Shaved"
	)

	female_hair = list("Ahoge",
		"Long Bedhead",
		"Beehive",
		"Beehive 2",
		"Bob Hair",
		"Bob Hair 2",
		"Bob Hair 3",
		"Bob Hair 4",
		"Bobcurl",
		"Braided",
		"Braided Front",
		"Braid (Short)",
		"Braid (Low)",
		"Bun Head",
		"Bun Head 2",
		"Bun Head 3",
		"Bun (Large)",
		"Bun (Tight)",
		"Double Bun",
		"Emo",
		"Emo Fringe",
		"Feather",
		"Gentle",
		"Long Hair 1",
		"Long Hair 2",
		"Long Hair 3",
		"Long Over Eye",
		"Long Emo",
		"Long Fringe",
		"Ponytail",
		"Ponytail 2",
		"Ponytail 3",
		"Ponytail 4",
		"Ponytail 5",
		"Ponytail 6",
		"Ponytail 7",
		"Ponytail (High)",
		"Ponytail (Short)",
		"Ponytail (Long)",
		"Ponytail (Country)",
		"Ponytail (Fringe)",
		"Poofy",
		"Short Hair Rosa",
		"Shoulder-length Hair",
		"Volaju")

	shoes = list(/obj/item/clothing/shoes/vampire/jackboots)
	uniforms = list(/obj/item/clothing/under/vampire/guard)
	pockets = list(/obj/item/vamp/keys/npc, /obj/item/stack/dollar/rand)
	backpacks = list()

	//Voice Lines
	neutral_phrases = list(
		"Buddy, you'd better step back.",
		"Only VIP's are allowed through here.",
		"Mind your manners."
	)
	random_phrases = list(
		"Real quiet night tonight."
	)

	answer_phrases = list("Shit, man.")
	help_phrases = list(
		"It's time you walked out.",
		"Let me show you the door.",
		"We were having a peaceful night, till you showed up.",
		"This is gonna hurt me more than it hurts you."
	)


	//Phrase said when someone is denied entry
	var/denial_phrases = list(
		"You aren't on the list.",
		"No entry. Not for you.",
		"It's a private gathering, past here."
	)


	var/entry_phrases = list(
		"Good to see you again.",
		"Welcome to the dark side.",
		"We've been expecting you.",
		"A pleasure, as always."
	)

	var/police_block_phrases = list(
		"Fuck Twelve.",
		"Oh yeah? Why don't you come back with a warrant?",
		"You aren't getting in without a warrant.",
		"I know my rights. You stay the hell out."
	)

	var/block_phrases = list(
		"I thought we told you to piss off.",
		"For the last time, you aren't getting in.",
		"Nice story, bucko. Now scram."
	)

	var/unmask_phrases = list(
		"Hey, if you want inside, show me your face first.",
		"Come let us take a look at you, before you go in.",
		"Wait, I can't see your face. Show it to me before you go in.",
		"I can't let some masked nobody inside. Come over here and show me your ugly mug."
	)

	var/bouncer_weapon_type = /obj/item/gun/ballistic/shotgun/vampire
	var/bouncer_backup_weapon_type = /obj/item/melee/vampirearms/machete
