
/datum/socialrole/bandit
	s_tones = list("albino",
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
		"african2")

	min_age = 18
	max_age = 45
	preferedgender = MALE
	male_names = null
	surnames = null
	is_criminal = TRUE

	hair_colors = list("040404",	//Black
											"120b05",	//Dark Brown
											"342414",	//Brown
											"554433")	//Light Brown
	male_hair = list("Balding Hair",
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
										"Volaju")
	male_facial = list("Beard (Abraham Lincoln)",
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
											"Shaved")

	shoes = list(
		/obj/item/clothing/shoes/vampire/sneakers,
		/obj/item/clothing/shoes/vampire/sneakers/red,
		/obj/item/clothing/shoes/vampire/jackboots
	)
	uniforms = list(
		/obj/item/clothing/under/vampire/larry,
		/obj/item/clothing/under/vampire/bandit,
		/obj/item/clothing/under/vampire/biker
	)
	hats = list(
		/obj/item/clothing/head/vampire/bandana,
		/obj/item/clothing/head/vampire/bandana/red,
		/obj/item/clothing/head/vampire/bandana/black,
		/obj/item/clothing/head/vampire/beanie,
		/obj/item/clothing/head/vampire/beanie/black
	)
	pockets = list(
		/obj/item/stack/dollar/rand,
		/obj/item/vamp/keys/hack
	)

	//[Lucia] - this has been edited to have better English because it included slurs, but none of the others have yet
	male_phrases = list(
		"Whatchu staring at?",
		"Tryina threaten me or sumthin'?",
		"You need somethin'?",
		"You've got some balls, that's for sure.",
		"You know who I work for?",
		"Get the hell outta here, 'fore I get my gang on yo' ass.",
		"You need sumn' punk?",
		"Get lost, liberal.",
		"Get outta this side of town.",
		"Think you scare me? You know who I work for?",
		"Think you're hot shit?"
	)
	neutral_phrases = list(
		"Why you starin' at me like that?",
		"Another dumbass tryin' to look threatening.",
		"Halloween's over, what's with the costumes.",
		"I think that whore gave me the clap.",
		"Gotta get home soon, family to feed and all that.",
		"Get lost, liberal.",
		"I think.. I miss my wife.",
		"What? You need somethin?",
		"Outta my way.",
		"Piss off asshole, ain't in the mood for your shit.",
		"Fuck off."
	)
	random_phrases = list(
		"Dumbass.",
		"I miss my girl...",
		"What's wrong bro?",
		"GOOD. FUCKING. EVENING.",
		"Evenin.",
		"Y'know I saw you sellin' dope, right?",
		"We're fucking doomed...",
		"It's over...",
		"Guh..."
	)
	answer_phrases = list(
		"I've got it...",
		"Fucking hellhole, this whole town.",
		"Shit, man.",
		"You don' look like I know you.. Do I know you?",
		"Right.",
		"Uhmm... Cool I guess",
		"Had some good food over at gummaguts, stomach hurts though..."
	)
	help_phrases = list(
		"God, not again!",
		"Fucking FREAK!",
		"What the hell are you doing!?",
		"You fucked up!",
		"Check yo' self, fool!",
		"We got shit, shit that'll shut you up for good!"
	)

/datum/socialrole/usualmale
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
		"african2")

	min_age = 18
	max_age = 85
	preferedgender = MALE
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
		"080918"    //Punk Blue
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

	shoes = list(
		/obj/item/clothing/shoes/vampire/sneakers,
		/obj/item/clothing/shoes/vampire,
		/obj/item/clothing/shoes/vampire/brown
	)
	uniforms = list(
		/obj/item/clothing/under/vampire/mechanic,
		/obj/item/clothing/under/vampire/sport,
		/obj/item/clothing/under/vampire/office,
		/obj/item/clothing/under/vampire/sexy,
		/obj/item/clothing/under/vampire/slickback,
		/obj/item/clothing/under/vampire/emo
	)
	pockets = list(
		/obj/item/vamp/keys/npc,
		/obj/item/stack/dollar/rand
	)

	male_phrases = list(
		"Need something? Or are you just trying to waste my time?",
		"What's up?",
		"What'd you say?",
		"I'm late, my wife is gonna kill me.",
		"You heard about the new place in town..?",
		"Can't speak right now.",
		"Good night I guess?",
		"Guh...",
		"I dunno what to say.",
		"That's all, folks."
	)
	neutral_phrases = list(
		"What do you need, mate?",
		"Do you need something?",
		"Can you repeat what you were saying?",
		"I'm late, don't interrupt me.",
		"Check the bar if you want somebody to bother...",
		"Can't speak right now.",
		"Goodnight, I guess?",
		"Guh...",
		"I dunno what to say.",
		"That's all, folks."
	)
	random_phrases = list(
		"Hey, mate!",
		"I miss my beer...",
		"Everything okay?",
		"Hello.",
		"Haven't I seen you around before?",
		"Something wrong here.",
		"Oooh, dude..."
	)
	answer_phrases = list(
		"Trying...",
		"Awesome.",
		"Bad, mate.",
		"You picked wrong person.",
		"Yeah, right.",
		"O'kaay...",
		"Nice."
	)
	help_phrases = list(
		"Oh God!",
		"Go away!!",
		"What the hell is happening?!",
		"Stop!",
		"Someone, help!",
		"Mommy!"
	)

/datum/socialrole/usualfemale
	s_tones = list("albino",
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
		"african2")

	min_age = 18
	max_age = 85
	preferedgender = FEMALE
	female_names = null
	surnames = null
// [dentbrain] man... actually coming up with shit for people to say is HARD work........
	hair_colors = list("040404",	//Black
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
										"080918")	//Punk Blue
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

	shoes = list(/obj/item/clothing/shoes/vampire/heels,
								/obj/item/clothing/shoes/vampire/sneakers,
								/obj/item/clothing/shoes/vampire/jackboots)
	uniforms = list(/obj/item/clothing/under/vampire/black,
									/obj/item/clothing/under/vampire/red,
									/obj/item/clothing/under/vampire/gothic)
	pockets = list(/obj/item/vamp/keys/npc,
					/obj/item/stack/dollar/rand)

	female_phrases = list(
		"What do you need?",
		"Do you need something?",
		"Do I really need to answer?",
		"I'm late.",
		"Pervert...",
		"Can't speak right now.",
		"Buy yourself a watch",
		"Hey.",
		"Go away."
	)
	neutral_phrases = list(
		"What do you need?",
		"Do you need something?",
		"Do I really need to answer?",
		"I'm late.",
		"Pervert...",
		"Can't speak right now.",
		"Buy yourself a watch",
		"Hey.",
		"Go away."
	)
	random_phrases = list(
		"Hey, fatso!",
		"I miss my beer...",
		"What's up?",
		"Heyyyyy.",
		"Do I know you?",
		"There's something wrong with this city, you know?",
		"Oh, wow."
	)
	answer_phrases = list(
		"I'm trying...",
		"Crazy.",
		"Things aren't good, baby.",
		"You mixed me up with someone else.",
		"Yeah, exactly.",
		"Okay...",
		"Fine."
	)
	help_phrases = list(
		"Oh God!",
		"Go away!!",
		"What the heck is happening?!",
		"Stop!",
		"Someone, help!",
		"Mommy!"
	)

/datum/socialrole/poormale
	s_tones = list("albino",
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
		"african2")

	min_age = 45
	max_age = 85
	preferedgender = MALE
	male_names = null
	surnames = null

	hair_colors = list("040404",	//Black
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
										"080918")	//Punk Blue
	male_hair = list("Balding Hair",
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
										"Volaju")
	male_facial = list("Beard (Abraham Lincoln)",
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
											"Sideburns")

	shoes = list(/obj/item/clothing/shoes/vampire/jackboots/work)
	uniforms = list(/obj/item/clothing/under/vampire/homeless)
	suits = list(/obj/item/clothing/suit/vampire/coat)
	hats = list(/obj/item/clothing/head/vampire/beanie/black)
	gloves = list(/obj/item/clothing/gloves/vampire/work)
	neck = list(/obj/item/clothing/neck/vampire/scarf/red,
							/obj/item/clothing/neck/vampire/scarf,
							/obj/item/clothing/neck/vampire/scarf/blue,
							/obj/item/clothing/neck/vampire/scarf/green,
							/obj/item/clothing/neck/vampire/scarf/white)

	male_phrases = list("Fuck, shit, daa-amn...",
											"We're fucked!",
											"Grubrhggsmm...",
											"Brrr.",
											"Drunk...")
	neutral_phrases = list("Fuck, shit, daa-amn...",
											"We're fucked!",
											"Grubrhggsmm...",
											"Brrr.",
											"Drunk...")
	random_phrases = list("Fuck, shit, daa-amn...",
											"We're fucked!",
											"Grubrhggsmm...",
											"Brrr.",
											"Drunk...")
	answer_phrases = list("Fuck, shit, daa-amn...",
											"We're fucked!",
											"Grubrhggsmm...",
											"Brrr.",
											"Drunk...")
	help_phrases = list("Aaaugh!",
											"AAAAHHHH!!",
											"What da' fuck? WHO'RE YOU?!",
											"Shit!",
											"Ass!",
											"Dick!")

/datum/socialrole/poorfemale
	s_tones = list("albino",
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
		"african2")

	min_age = 45
	max_age = 85
	preferedgender = FEMALE
	female_names = null
	surnames = null

	hair_colors = list("040404",	//Black
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
										"080918")	//Punk Blue
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

	shoes = list(/obj/item/clothing/shoes/vampire/brown)
	uniforms = list(/obj/item/clothing/under/vampire/homeless/female)
	suits = list(/obj/item/clothing/suit/vampire/coat/alt)
	hats = list(/obj/item/clothing/head/vampire/beanie/homeless)

	female_phrases = list("Fuck, shit, daa-amn...",
											"We're fucked!",
											"Grubrhggsmm...",
											"Brrr.",
											"Drunk...")
	neutral_phrases = list("Fuck, shit, daa-amn...",
											"We're fucked!",
											"Grubrhggsmm...",
											"Brrr.",
											"Drunk...")
	random_phrases = list("Fuck, shit, daa-amn...",
											"We're fucked!",
											"Grubrhggsmm...",
											"Brrr.",
											"Drunk...")
	answer_phrases = list("Fuck, shit, daa-amn...",
											"We're fucked!",
											"Grubrhggsmm...",
											"Brrr.",
											"Drunk...")
	help_phrases = list("Aaaugh!",
											"AAAAHHHH!!",
											"What the fuck? WHO'RE YOU?!",
											"Shit!",
											"Ass!",
											"Dick!")

/datum/socialrole/richmale
	s_tones = list("albino",
		"caucasian1",
		"caucasian2")

	min_age = 18
	max_age = 85
	preferedgender = MALE
	male_names = null
	surnames = null

	hair_colors = list("040404",	//Black
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
										"080918")	//Punk Blue
	male_hair = list("Business Hair",
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
										"Volaju")
	male_facial = list("Beard (Neckbeard)",
											"Beard (Three o Clock Shadow)",
											"Sideburns (Elvis)",
											"Sideburns",
											"Shaved")

	shoes = list(/obj/item/clothing/shoes/vampire,
								/obj/item/clothing/shoes/vampire/white)
	uniforms = list(/obj/item/clothing/under/vampire/rich)
	inhand_items = list(/obj/item/storage/briefcase)
	pockets = list(/obj/item/vamp/keys/npc,
					/obj/item/stack/dollar/fifty,
					/obj/item/stack/dollar/hundred)

	male_phrases = list("Did you ask something?",
											"My stocks! my stocks! They're falling...!",
											"You know, eventually we'll have our money on the computer, and the computer will do our taxes for us!",
											"I'm going somewhere important... unlike you.",
											"Get lost, filthy hobo...",
											"Ugh, work has me up so late, they better be paying me more...",
											"Finally quit that stupid job... so glad I moved here.")
	neutral_phrases = list("Did you say somethin..?",
											"Excuse me?",
											"Hm? What is it?",
											"I've got to get going, got somewhere important to be.",
											"Get lost, jackass, get a job or something",
											"Get lost, peasant...",
											"Huh..? Sorry, the coffee hasn't kicked in.",
											"it's the middle of the night, I don't wanna deal with your shit right now.")
	help_phrases = list("What in the god damn?!",
											"I'm calling the cops!",
											"OH HELL NO.",
											"That ain't gonna be happening to me!",
											"Someone, call the cops!")

/datum/socialrole/richfemale
	s_tones = list("albino",
		"caucasian1",
		"caucasian2")

	min_age = 18
	max_age = 85
	preferedgender = FEMALE
	female_names = null
	surnames = null

	hair_colors = list("040404",	//Black
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
										"080918")	//Punk Blue
	female_hair = list("Ahoge",
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
										"Gentle",
										"Long Hair 1",
										"Long Hair 2",
										"Long Hair 3",
										"Short Hair Rosa",
										"Shoulder-length Hair",
										"Volaju")

	shoes = list(/obj/item/clothing/shoes/vampire/heels,
								/obj/item/clothing/shoes/vampire/heels/red)
	uniforms = list(/obj/item/clothing/under/vampire/business)
	pockets = list(/obj/item/vamp/keys/npc,
					/obj/item/stack/dollar/fifty,
					/obj/item/stack/dollar/hundred)

	female_phrases = list("Whaddya want, I'm busy!",
											"Excuse me, do you know the way to the pyramid?",
											"...What?",
											"I'm going somewhere important, not like you'd get it.",
											"Get lost, filthy hobo...",
											"Get lost, peasant...",
											"You been to the bar tonight? It's a good place for hobos like you...",
											"Stop doing that, imbecile.")
	neutral_phrases = list("Did you ask something?",
											"Excuse me?",
											"What?",
											"I'm going somewhere important.",
											"Get lost, peasant...",
											"Whaa-aat...",
											"Stop doing that, imbecile.")
	help_phrases = list("What in the god damn?!",
											"Go away or I will call the cops!!",
											"What is happening?!",
											"Stop doing this!",
											"Someone, call the ambulance!")

/mob/living/carbon/human/npc/bandit
	max_stat = 3
	my_backup_weapon_type = /obj/item/melee/vampirearms/knife

/mob/living/carbon/human/npc/bandit/Initialize()
	. = ..()
	if(prob(50))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/bandit)

/mob/living/carbon/human/npc/walkby

/mob/living/carbon/human/npc/walkby/Initialize()
	. = ..()
	if(prob(50))
		base_body_mod = pick("s", "f")
	AssignSocialRole(pick(/datum/socialrole/usualmale, /datum/socialrole/usualfemale))

/mob/living/carbon/human/npc/hobo
	bloodquality = BLOOD_QUALITY_LOW
	old_movement = TRUE

/mob/living/carbon/human/npc/hobo/Initialize()
	. = ..()
	if(prob(33))
		base_body_mod = "s"
	AssignSocialRole(pick(/datum/socialrole/poormale, /datum/socialrole/poorfemale))

/mob/living/carbon/human/npc/business
	bloodquality = BLOOD_QUALITY_HIGH

/mob/living/carbon/human/npc/business/Initialize()
	. = ..()
	if(prob(66))
		base_body_mod = "s"
	AssignSocialRole(pick(/datum/socialrole/richmale, /datum/socialrole/richfemale))

/mob/living/simple_animal/pet/rat
	name = "rat"
	desc = "It's a rat."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "rat"
	icon_living = "rat"
	icon_dead = "rat_dead"
	emote_hear = list("squeeks.")
	emote_see = list("shakes its head.", "shivers.")
	speak_chance = 0
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/food/meat/slab = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	can_be_held = TRUE
	density = FALSE
	anchored = FALSE
	footstep_type = FOOTSTEP_MOB_CLAW
	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 1
	maxbloodpool = 1
	del_on_death = 1
	maxHealth = 5
	health = 5

/mob/living/simple_animal/pet/rat/Initialize()
	. = ..()
	pixel_w = rand(-8, 8)
	pixel_z = rand(-8, 8)

/mob/living/simple_animal/pet/rat/Life()
	. = ..()
	if(!isturf(loc)) // if rat is, for example, in-hand or inside a crate, won't run this self-deletion code
		return
	if(client)
		return
	var/delete_me = TRUE
	for(var/mob/living/carbon/human/H in viewers(5, src))
		if(H)
			delete_me = FALSE
	if(delete_me)
		death()

/mob/living/simple_animal/pet/rat/will_escape_storage()
	if(prob(10))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/beastmaster/rat
	name = "rat"
	desc = "It's a rat."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "rat"
	icon_living = "rat"
	icon_dead = "rat_dead"
	emote_hear = list("squeeks.")
	emote_see = list("shakes its head.", "shivers.")
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'code/modules/wod13/sounds/rat.ogg'
	speak_chance = 0
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/food/meat/slab = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	can_be_held = TRUE
	density = FALSE
	anchored = FALSE
	footstep_type = FOOTSTEP_MOB_CLAW
	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 1
	maxbloodpool = 1
	del_on_death = 1
	maxHealth = 20
	health = 20
	harm_intent_damage = 10
	melee_damage_lower = 5
	melee_damage_upper = 10
	speed = 0
	dodging = TRUE

/mob/living/simple_animal/hostile/beastmaster/rat/Initialize()
	. = ..()
	pixel_w = rand(-8, 8)
	pixel_z = rand(-8, 8)

/mob/living/simple_animal/hostile/beastmaster/rat/flying
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	name = "bat"
	desc = "It's a bat."
	is_flying_animal = TRUE
	maxHealth = 10
	health = 10
	speed = -0.8

/mob/living/simple_animal/hostile/beastmaster/rat/flying/UnarmedAttack(atom/A)
	. = ..()
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.bloodpool)
			if(prob(10))
				H.bloodpool = max(0, H.bloodpool-1)
				beastmaster.bloodpool = min(beastmaster.maxbloodpool, beastmaster.bloodpool+1)

/datum/socialrole/shop
	s_tones = list("albino",
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
		"african2")

	min_age = 18
	max_age = 45
	preferedgender = MALE
	male_names = null
	surnames = null

	hair_colors = list("040404",	//Black
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
										"080918")	//Punk Blue
	male_hair = list("Balding Hair",
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
										"Volaju")
	male_facial = list("Beard (Abraham Lincoln)",
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
											"Shaved")

	shoes = list(/obj/item/clothing/shoes/vampire/sneakers,
								/obj/item/clothing/shoes/vampire,
								/obj/item/clothing/shoes/vampire/brown)
	uniforms = list(/obj/item/clothing/under/vampire/mechanic)
	pockets = list(/obj/item/vamp/keys/npc,
					/obj/item/stack/dollar/rand)

	male_phrases = list("Wanna buy something?",
											"Can I help?",
											"Hey, wanna buy it?")
	neutral_phrases = list("Wanna buy something?",
											"Can I help?",
											"Hey, wanna buy it?")
	random_phrases = list("Check this!",
												"Can I help?",
												"Hey, wanna buy it?")
	answer_phrases = list("I just work here...")
	help_phrases = list("What in the god damn?!",
											"Go away or I will call the cops!!",
											"What is happening?!",
											"Stop doing this!",
											"Someone, call the ambulance!")

/mob/living/carbon/human/npc/shop
	staying = TRUE
	is_talking = TRUE

/mob/living/carbon/human/npc/shop/Initialize()
	. = ..()
	if(prob(66))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/shop)

/datum/socialrole/shop/bacotell
	uniforms = list(/obj/item/clothing/under/vampire/bacotell)

/mob/living/carbon/human/npc/bacotell
	staying = TRUE

/mob/living/carbon/human/npc/bacotell/Initialize()
	. = ..()
	if(prob(66))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/shop/bacotell)

/datum/socialrole/shop/bubway
	uniforms = list(/obj/item/clothing/under/vampire/bubway)

/mob/living/carbon/human/npc/bubway
	staying = TRUE

/mob/living/carbon/human/npc/bubway/Initialize()
	. = ..()
	if(prob(66))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/shop/bubway)

/datum/socialrole/shop/gummaguts
	uniforms = list(/obj/item/clothing/under/vampire/gummaguts)

/mob/living/carbon/human/npc/gummaguts
	staying = TRUE

/mob/living/carbon/human/npc/gummaguts/Initialize()
	. = ..()
	if(prob(66))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/shop/gummaguts)

/datum/socialrole/police
	s_tones = list("albino",
								"caucasian1",
								"caucasian2",
								"caucasian3")

	min_age = 18
	max_age = 45
	male_names = null
	surnames = null

	hair_colors = list("040404",	//Black
										"120b05",	//Dark Brown
										"342414",	//Brown
										"554433",	//Light Brown
										"695c3b",	//Dark Blond
										"ad924e",	//Blond
										"dac07f",	//Light Blond
										"802400",	//Ginger
										"a5380e",	//Ginger alt
										"ffeace",	//Albino
										)

	male_hair = list("Balding Hair",
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
										"Volaju",)

	female_hair = list("Ahoge",
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
										"Gentle",
										"Long Hair 1",
										"Long Hair 2",
										"Long Hair 3",
										"Short Hair Rosa",
										"Shoulder-length Hair",
										"Volaju")


	male_facial = list("Beard (Abraham Lincoln)",
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
											"Shaved",)

	shoes = list(/obj/item/clothing/shoes/vampire/jackboots)
	uniforms = list(/obj/item/clothing/under/vampire/police)
	hats = list(/obj/item/clothing/head/vampire/police)
	suits = list(/obj/item/clothing/suit/vampire/vest/police)
	pockets = list(/obj/item/stack/dollar/rand)

	male_phrases = list("I see you.",
											"Looking suspicious...",
											"Don't try anything stupid.",
											"Nothing to see here.",
											"We're watching you...Scum.",
											"Have you seen a man in a black coat with black hair?",
											"Citizen.",
											"You catch the game last night?" )

	neutral_phrases = list("I see you.",
											"Looking suspicious...",
											"Don't try anything stupid.",
											"Nothing to see here.",
											"We're watching you...Scum.",
											"Have you seen a man in a black coat with black hair?",
											"Citizen.",
											"You catch the game last night?")

	female_phrases = list("I see you.",
											"Looking suspicious...",
											"Don't try anything stupid.",
											"Nothing to see here.",
											"We're watching you...Scum.",
											"Have you seen a man in a black coat with black hair?",
											"Citizen.",
											"You catch the game last night?" )

	random_phrases = list("I see you.",
											"Looking suspicious...",
											"Don't try anything stupid.",
											"Nothing to see here.",
											"We're watching you...Scum.",
											"Have you seen a man in a black coat with black hair?",
											"Citizen.",
											"You catch the game last night?",)
	answer_phrases = list("I'm here to protect you.")
	help_phrases = list("Lay down!",
											"Stop right there!!",
											"Drop your weapon!",
											"Stop there right now!!",
											"This is SFPD, hands on your head!",
											"You have the right to remain silent!",
											"Bush gave me the right to kick your head in!",
											"I'm gonna beat you harder than the Eagles got beat by the Patriots!",)

/mob/living/carbon/human/npc/police
	fights_anyway = TRUE
	max_stat = 4
	my_backup_weapon_type = /obj/item/melee/classic_baton/vampire

/mob/living/carbon/human/npc/police/Initialize()
	. = ..()
	if(prob(66))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/police)

/mob/living/carbon/human/npc/police/Life()
	. = ..()
	if(stat < 1)
		if(prob(10))
			for(var/mob/living/carbon/human/H in oviewers(4, src))
				if(H)
					if(H.warrant)
						Aggro(H, FALSE)


/datum/socialrole/guard
	s_tones = list(
		"albino",
		"caucasian1",
		"caucasian2",
		"caucasian3"
	)

	min_age = 18
	max_age = 85
	preferedgender = MALE
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

	shoes = list(/obj/item/clothing/shoes/vampire)
	uniforms = list(/obj/item/clothing/under/vampire/guard)
	pockets = list(/obj/item/vamp/keys/npc, /obj/item/stack/dollar/rand)

	neutral_phrases = list(
		"No loitering.",
		"I'm kinda, like, a cop, you know.",
		"I could go for some bearclaws right about now.",
		"Like the uniform?",
		"Hey, catch me later, I'll buy you a beer."
	)
	neutral_phrases = list(
		"No loitering.",
		"I'm kinda, like, a cop, you know?",
		"I could go for some bearclaws right about now.",
		"Like the uniform?",
		"Hey, catch me later, I'll buy you a beer."
	)
	random_phrases = list(
		"It's been a real quiet night.",
		"My brothers and father are security guards, too."
	)
	answer_phrases = list("I need some coffee.")
	help_phrases = list(
		"It's go time!",
		"Stop right there!!",
		"Drop your weapon!",
		"Freeze!!",
		"Not just a mall cop, you know!"
	)

/mob/living/carbon/human/npc/guard
	staying = TRUE
	fights_anyway = TRUE
	max_stat = 4
	my_weapon_type = /obj/item/gun/ballistic/automatic/vampire/m1911
	my_backup_weapon_type = /obj/item/melee/classic_baton/vampire

/mob/living/carbon/human/npc/guard/Initialize()
	. = ..()
	if(prob(66))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/guard)

/mob/living/carbon/human/npc/walkby/club/Life()
	. = ..()
	if(staying && stat < 2)
		if(prob(5))
			var/hasjukebox = FALSE
			for(var/obj/machinery/jukebox/J in range(5, src))
				if(J)
					hasjukebox = TRUE
					if(J.active)
						if(prob(50))
							dancefirst(src)
						else
							dancesecond(src)
			if(!hasjukebox)
				staying = FALSE

/mob/living/carbon/human/npc/walkby/club
	staying = TRUE

/datum/socialrole/stripfemale
	s_tones = list("albino",
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
		"african2")

	min_age = 18
	max_age = 30
	preferedgender = FEMALE
	female_names = null
	surnames = null

	hair_colors = list("040404",	//Black
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
										"080918")	//Punk Blue
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

	shoes = list(/obj/item/clothing/shoes/vampire/heels)
	uniforms = list(/obj/item/clothing/under/vampire/burlesque)
	backpacks = list()

	female_phrases = list("No touching~.",
											"Like what you see?",
											"Wanna play?",
											"He-he.",
											"Want a private dance?...",
											"Sit and rest.",
											"Do you like this?",
											"Ahh...")
	neutral_phrases = list("No touching~.",
											"Like what you see?",
											"Wanna play?",
											"He-he.",
											"Want a private dance?...",
											"Sit and rest.",
											"Do you like this?",
											"Ahh...")
	random_phrases = list("No touching~.",
											"Like what you see?",
											"Wanna play?",
											"He-he.",
											"Want a private dance?...",
											"Sit and rest.",
											"Do you like this?",
											"Ahh...")
	answer_phrases = list("That'll cost...",
												"He-he-he.",
												"Twenty bucks.",
												"Sure you do...")
	help_phrases = list("Oh God!",
											"Ahhh!!",
											"I'm just a stripper!",
											"Stop!",
											"Help me!",
											"Help!")

/mob/living/carbon/human/npc/stripper
	staying = TRUE

/mob/living/carbon/human/npc/stripper/Initialize()
	. = ..()
	base_body_mod = "s"
	AssignSocialRole(/datum/socialrole/stripfemale)
	underwear = "Nude"
	undershirt = "Nude"
	socks = "Nude"
	update_body()

/mob/living/carbon/human/npc/stripper/Life()
	. = ..()
	if(stat < 2)
		if(prob(20))
			for(var/obj/structure/pole/P in range(1, src))
				if(P)
					drop_all_held_items()
					ClickOn(P)

/mob/living/carbon/human/npc/incel
	staying = TRUE

/mob/living/carbon/human/npc/incel/Initialize()
	. = ..()
	if(prob(50))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/usualmale)

/datum/socialrole/shop/illegal
	masks = list(/obj/item/clothing/mask/vampire/balaclava)
	shoes = list(/obj/item/clothing/shoes/vampire/sneakers)
	uniforms = list(/obj/item/clothing/under/vampire/emo)
	pockets = list(/obj/item/stack/dollar/rand)

	male_phrases = list("Pss... wanna try some weed?",
											"Hey, vagabond...",
											"Check this shit...")
	neutral_phrases = list("Pss... wanna try some weed?",
											"Hey, vagabond...",
											"Check this shit...")
	random_phrases = list("Pss... wanna try some weed?",
											"Hey, vagabond...",
											"Check this shit...")
	answer_phrases = list("Nothing personal...")
	help_phrases = list("Cops!",
											"Fuck the police!!",
											"COPS?!!")
	is_criminal = TRUE

/mob/living/carbon/human/npc/illegal
	staying = TRUE
	is_talking = TRUE

/mob/living/carbon/human/npc/illegal/Initialize()
	. = ..()
	AssignSocialRole(/datum/socialrole/shop/illegal)
