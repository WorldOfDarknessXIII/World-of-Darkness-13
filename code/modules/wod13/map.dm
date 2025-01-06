/obj/damap
	icon = 'code/modules/wod13/map.dmi'
	icon_state = "map"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/damap/supply
	icon = 'code/modules/wod13/disciplines.dmi'
	icon_state = "supply"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/damap/church
	icon = 'code/modules/wod13/disciplines.dmi'
	icon_state = "church"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/damap/graveyard
	icon = 'code/modules/wod13/disciplines.dmi'
	icon_state = "graveyard"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/damap/hotel
	icon = 'code/modules/wod13/disciplines.dmi'
	icon_state = "hotel"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/damap/tower
	icon = 'code/modules/wod13/disciplines.dmi'
	icon_state = "tower"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/damap/clean
	icon = 'code/modules/wod13/disciplines.dmi'
	icon_state = "clean"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/damap/theatre
	icon = 'code/modules/wod13/disciplines.dmi'
	icon_state = "theatre"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/damap/bar
	icon = 'code/modules/wod13/disciplines.dmi'
	icon_state = "bar"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/damap/hospital
	icon = 'code/modules/wod13/disciplines.dmi'
	icon_state = "hospital"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/structure/vampmap
	name = "\improper map"
	desc = "Locate yourself now."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "map"
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/vampmap/attack_hand(mob/user)
	. = ..()
	var/dat = {"
			<style type="text/css">

			body {
				background-color: #090909; color: white;
			}

			</style>
			"}
	var/obj/damap/DAMAP = new(user)
	var/obj/damap/supply/SU = new(user)
	var/obj/damap/church/CH = new(user)
	var/obj/damap/graveyard/GR = new(user)
	var/obj/damap/hotel/HO = new(user)
	var/obj/damap/tower/TO = new(user)
	var/obj/damap/clean/CL = new(user)
	var/obj/damap/theatre/TH = new(user)
	var/obj/damap/bar/BA = new(user)
	var/obj/damap/hospital/HS = new(user)
	var/obj/overlay/AM = new(DAMAP)
	AM.icon = 'code/modules/wod13/disciplines.dmi'
	AM.icon_state = "target"
	AM.layer = ABOVE_HUD_LAYER
	AM.pixel_x = x-4
	AM.pixel_y = y-4
	DAMAP.overlays |= AM
	dat += "<center>[icon2html(getFlatIcon(DAMAP), user)]</center><BR>"
	dat += "<center>[icon2html(getFlatIcon(SU), user)] - Railway Station;</center><BR>"
	dat += "<center>[icon2html(getFlatIcon(CH), user)] - Catholic Church;</center><BR>"
	dat += "<center>[icon2html(getFlatIcon(GR), user)] - City Graveyard;</center><BR>"
	dat += "<center>[icon2html(getFlatIcon(HO), user)] - Hotel \"Cock Roach\";</center><BR>"
	dat += "<center>[icon2html(getFlatIcon(TO), user)] - Millenium Tower;</center><BR>"
	dat += "<center>[icon2html(getFlatIcon(CL), user)] - Cleaning Services;</center><BR>"
	dat += "<center>[icon2html(getFlatIcon(TH), user)] - National Theatre;</center><BR>"
	dat += "<center>[icon2html(getFlatIcon(BA), user)] - Bar \"Big Shoe\";</center><BR>"
	dat += "<center>[icon2html(getFlatIcon(HS), user)] - City Hospital.</center>"
	user << browse(dat, "window=map;size=400x600;border=1;can_resize=0;can_minimize=0")
	onclose(user, "map", src)
	qdel(DAMAP)
	qdel(AM)
	qdel(SU)
	qdel(CH)
	qdel(GR)
	qdel(HO)
	qdel(TO)
	qdel(CL)
	qdel(TH)
	qdel(BA)
	qdel(HS)


/obj/effect/mob_spawn/human/citizen
	name = "just a civilian"
	desc = "A humming sleeper with a silhouetted occupant inside. Its stasis function is broken and it's likely being used as a bed."
	mob_name = "a civillian"
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	outfit = /datum/outfit/civillian1
	roundstart = FALSE
	death = FALSE
	random = FALSE
	mob_species = /datum/species/human
	short_desc = "You just woke up from strange noises outside. This city is totally cursed..."
	flavour_text = "Each day you notice some weird shit going at night. Each day, new corpses, new missing people, new police-don't-give-a-fuck. This time you definitely should go and see the mysterious powers of the night... or not? You are too afraid because you are not aware of it."
	assignedrole = "Civillian"

/obj/effect/mob_spawn/human/citizen/Initialize(mapload)
	. = ..()
	if(prob(50))
		qdel(src)
		return
	var/arrpee = rand(1,4)
	switch(arrpee)
		if(2)
			outfit = /datum/outfit/civillian2
		if(3)
			outfit = /datum/outfit/civillian3
		if(4)
			outfit = /datum/outfit/civillian4

/obj/effect/mob_spawn/human/citizen/special(mob/living/new_spawn)
	var/my_name = "Tyler"
	if(new_spawn.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	new_spawn.fully_replace_character_name(null,"[my_name] [my_surname]")

/datum/outfit/civillian1
	name = "civillian"
	uniform = /obj/item/clothing/under/vampire/sport
	shoes = /obj/item/clothing/shoes/vampire/sneakers
	id = /obj/item/cockclock
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/npc/fix
	back = /obj/item/storage/backpack/satchel

/datum/outfit/civillian2
	name = "civillian"
	uniform = /obj/item/clothing/under/vampire/office
	shoes = /obj/item/clothing/shoes/vampire
	id = /obj/item/cockclock
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/npc/fix
	back = /obj/item/storage/backpack/satchel

/datum/outfit/civillian3
	name = "civillian"
	uniform = /obj/item/clothing/under/vampire/emo
	shoes = /obj/item/clothing/shoes/vampire
	id = /obj/item/cockclock
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/npc/fix
	back = /obj/item/storage/backpack/satchel

/datum/outfit/civillian4
	name = "civillian"
	uniform = /obj/item/clothing/under/vampire/bandit
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/cockclock
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/npc/fix
	back = /obj/item/storage/backpack/satchel

/obj/effect/mob_spawn/human/corpse/ciz1
	name = "Citizen"
	id_job = "Citizen"
	outfit = /datum/outfit/civillian1

/obj/effect/mob_spawn/human/corpse/ciz2
	name = "Citizen"
	id_job = "Citizen"
	outfit = /datum/outfit/civillian2

/obj/effect/mob_spawn/human/corpse/ciz3
	name = "Citizen"
	id_job = "Citizen"
	outfit = /datum/outfit/civillian3

/obj/effect/mob_spawn/human/corpse/ciz4
	name = "Citizen"
	id_job = "Citizen"
	outfit = /datum/outfit/civillian4

/datum/outfit/syndicatecommandocorpse
	name = "Syndicate Commando Corpse"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/space/hardsuit/syndi
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset
	mask = /obj/item/clothing/mask/gas/syndicate
	back = /obj/item/tank/jetpack/oxygen
	r_pocket = /obj/item/tank/internals/emergency_oxygen
	id = /obj/item/card/id/syndicate
// TRIAD

/obj/effect/mob_spawn/human/triad_soldier
	name = "a triad soldier"
	desc = "A humming sleeper with a silhouetted occupant inside. Its stasis function is broken and it's likely being used as a bed."
	mob_name = "a triad soldier"
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	outfit = /datum/outfit/triadsoldier
	roundstart = FALSE
	death = FALSE
	random = FALSE
	mob_species = /datum/species/human
	short_desc = "You were sleeping. But you can't anymore."
	flavour_text = "You woke up because of the stupid washing machines. Probably better that you go and check what the gang's up to..."
	assignedrole = "Triad Soldier"

/obj/effect/mob_spawn/human/triad_soldier/special(mob/living/new_spawn)
	var/my_name = "Tyler"
	if(new_spawn.gender == MALE)
		my_name = pick(GLOB.first_names_male_triad)
	else
		my_name = pick(GLOB.first_names_female_triad)
	var/my_surname = pick(GLOB.last_names_triad)
	new_spawn.fully_replace_character_name(null,"[my_name] [my_surname]")

/datum/outfit/triadsoldier
	name = "triad soldier"
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/jackboots
//	suit = /obj/item/clothing/suit/vampire/vest
//	belt = /obj/item/melee/classic_baton
	id = /obj/item/cockclock
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/triads
	r_hand = /obj/item/gun/ballistic/automatic/vampire/glock19
	back = /obj/item/storage/backpack/satchel
//
/obj/effect/mob_spawn/human/police
	name = "a police officer"
	desc = "A humming sleeper with a silhouetted occupant inside. Its stasis function is broken and it's likely being used as a bed."
	mob_name = "a police officer"
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	outfit = /datum/outfit/policeofficer
	roundstart = FALSE
	death = FALSE
	random = FALSE
	mob_species = /datum/species/human
	short_desc = "You worked a simple night shift, but then..."
	flavour_text = "You woke up on your regular night shift and noticed something strange happening in the city. Only man interested in finding the truth is you..."
	assignedrole = "Police Officer"

/obj/effect/mob_spawn/human/police/special(mob/living/new_spawn)
	var/my_name = "Tyler"
	if(new_spawn.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	new_spawn.fully_replace_character_name(null,"[my_name] [my_surname]")

/datum/outfit/policeofficer
	name = "police officer"
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest
	belt = /obj/item/melee/classic_baton
	id = /obj/item/cockclock
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/radio/cop
	l_hand = /obj/item/vamp/keys/police
	r_hand = /obj/item/police_radio
	back = /obj/item/storage/backpack/satchel

/obj/effect/mob_spawn/human/achaplain
	name = "a chaplain"
	desc = "A humming sleeper with a silhouetted occupant inside. Its stasis function is broken and it's likely being used as a bed."
	mob_name = "a chaplain"
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	outfit = /datum/outfit/achaplain
	roundstart = FALSE
	death = FALSE
	random = FALSE
	mob_species = /datum/species/human
	short_desc = "You were guarding the Church, but then..."
	flavour_text = "You are a man of true Faith, but people in this city are not. You should protect the House of God..."
	assignedrole = "Chaplain"

/obj/effect/mob_spawn/human/achaplain/special(mob/living/new_spawn)
	var/my_name = "Tyler"
	if(new_spawn.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	new_spawn.fully_replace_character_name(null,"[my_name] [my_surname]")
	new_spawn.mind.holy_role = HOLY_ROLE_PRIEST

/datum/outfit/achaplain
	name = "chaplain"
	uniform = /obj/item/clothing/under/vampire/graveyard
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/card/id/hunter
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/church
	r_hand = /obj/item/gun/ballistic/shotgun/vampire
	back = /obj/item/storage/backpack/satchel

//Officer Chunk ghostspawn role
/obj/effect/mob_spawn/human/chunkguard
	name = "Millenium Tower Security Guard"
	desc = "A humming sleeper with a silhouetted occupant inside. Its stasis function is broken and it's likely being used as a bed."
	mob_name = "a Millenium Tower Security Guard"
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	outfit = /datum/outfit/chunk
	roundstart = FALSE
	death = FALSE
	random = FALSE
	mob_species = /datum/species/human
	short_desc = "You are working the night shift on Millenium Towers, just like any other night...."
	flavour_text = "You are up late protecting Millenium Towers on behalf of your pasty-faced, but filthy rich, boss. Come to think of it, you only ever see him at night..."
	assignedrole = "Millenium Tower Secuity Guard"

/obj/effect/mob_spawn/human/chunkguard/special(mob/living/new_spawn)
	var/my_name = "Tyler"
	if(new_spawn.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	new_spawn.fully_replace_character_name(null,"[my_name] [my_surname]")

/datum/outfit/chunk
	name = "Security Guard Chunk"
	uniform = /obj/item/clothing/under/vampire/guard
	shoes = /obj/item/clothing/shoes/vampire
	belt = /obj/item/gun/ballistic/automatic/vampire/m1911
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/camarilla
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/flashlight=1, /obj/item/vamp/creditcard=1,/obj/item/food/vampire/donut=5,/obj/item/card/id/chunk=1)

/obj/item/card/id/chunk
	name = "Millenium Tower Security ID"
	id_type_name = "Security ID"
	desc = "An ID showing propensity for donuts"
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id2"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id2"

/obj/item/card/id/chunk/AltClick(mob/user)
	return
