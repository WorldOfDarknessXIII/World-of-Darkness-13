/obj/item/clothing/under/vampire
	desc = "Some clothes."
	name = "clothes"
	icon_state = "error"
	has_sensor = NO_SENSORS
	random_sensor = FALSE
	can_adjust = FALSE
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 15)
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_worn = TRUE
	fitted = NO_FEMALE_UNIFORM
	cost = 10

/obj/item/clothing/under/vampire/brujah
	name = "Punk attire"
	desc = "Some punk clothes."
	icon_state = "brujah_m"

/obj/item/clothing/under/vampire/brujah/female
	icon_state = "brujah_f"

/obj/item/clothing/under/vampire/gangrel
	name = "Rugged attire"
	desc = "Some hobo clothes."
	icon_state = "gangrel_m"

/obj/item/clothing/under/vampire/gangrel/female
	icon_state = "gangrel_f"

/obj/item/clothing/under/vampire/malkavian
	name = "Grimey pants"
	desc = "Some macho-man pants."
	icon_state = "malkavian_m"

/obj/item/clothing/under/vampire/malkavian/female
	name = "Odd Goth schoolgirl attire"
	icon_state = "malkavian_f"

/obj/item/clothing/under/vampire/nosferatu
	name = "Gimp outfit"
	desc = "Some leather clothes."
	icon_state = "nosferatu_m"

/obj/item/clothing/under/vampire/nosferatu/female
	name = "Gimp outfit"
	icon_state = "nosferatu_f"

/obj/item/clothing/under/vampire/toreador
	name = "flamboyant outfit"
	desc = "Some sexy clothes."
	icon_state = "toreador_m"

/obj/item/clothing/under/vampire/toreador/female
	icon_state = "toreador_f"

/obj/item/clothing/under/vampire/tremere
	name = "Burgundy suit"
	desc = "Some weirdly tidy clothing."
	icon_state = "tremere_m"

/obj/item/clothing/under/vampire/tremere/female
	name = "Burgundy suit skirt"
	icon_state = "tremere_f"

/obj/item/clothing/under/vampire/ventrue
	name = "Black luxury suit"
	desc = "Some rich clothes."
	icon_state = "ventrue_m"

/obj/item/clothing/under/vampire/ventrue/female
	name = "Black luxury suit skirt"
	icon_state = "ventrue_f"

/obj/item/clothing/under/vampire/baali
	name = "Odd outfit"
	desc = "Some oddly un-orthodox clothes."
	icon_state = "baali_m"

/obj/item/clothing/under/vampire/baali/female
	icon_state = "baali_f"

/obj/item/clothing/under/vampire/salubri
	name = "Grey attire"
	desc = "Some very neutral clothes without much bright colors."
	icon_state = "salubri_m"

/obj/item/clothing/under/vampire/salubri/female
	icon_state = "salubri_f"

/obj/item/clothing/under/vampire/punk
	desc = "Some punk clothes."
	icon_state = "dirty"

/obj/item/clothing/under/vampire/turtleneck_white
	desc = "A white turtleneck"
	icon_state = "turtleneck_white"

/obj/item/clothing/under/vampire/turtleneck_black
	desc = "A black turtleneck"
	icon_state = "turtleneck_black"

/obj/item/clothing/under/vampire/turtleneck_red
	desc = "A red turtleneck"
	icon_state = "turtleneck_red"

/obj/item/clothing/under/vampire/turtleneck_navy
	desc = "A navy turtleneck"
	icon_state = "turtleneck_navy"

/obj/item/clothing/under/vampire/napoleon
	name = "French Admiral suit"
	desc = "Some oddly historical clothes."
	icon_state = "napoleon"

/obj/item/clothing/under/vampire/nazi
	desc = "Some historical clothes."
	icon_state = "nazi"

/obj/item/clothing/under/vampire/military_fatigues
	name = "Military fatigues"
	desc = "Some military clothes."
	icon_state = "milfatigues"

/obj/item/clothing/under/vampire/nazi/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ADMIN_TRAIT)

//FOR NPC

//GANGSTERS AND BANDITS

/obj/item/clothing/under/vampire/larry
	name = "White tanktop"
	desc = "Some loosefitting undershirt."
	icon_state = "larry"

/obj/item/clothing/under/vampire/bandit
	name = "Tan tanktop"
	desc = "An oddly wornout tanktop."
	icon_state = "bandit"

/obj/item/clothing/under/vampire/biker
	name = "Biker attire"
	desc = "Some dirty clothes."
	icon_state = "biker"

//USUAL

/obj/item/clothing/under/vampire/mechanic
	name = "Blue overalls"
	desc = "Some usual clothes."
	icon_state = "mechanic"

/obj/item/clothing/under/vampire/sport
	name = "Red track suit"
	desc = "Some usual clothes."
	icon_state = "sport"

/obj/item/clothing/under/vampire/office
	name = "Dark suit"
	desc = "Some usual clothes."
	icon_state = "office"

/obj/item/clothing/under/vampire/sexy
	name = "purple outfit"
	desc = "Some usual clothes."
	icon_state = "sexy"

/obj/item/clothing/under/vampire/slickback
	desc = "Some slick-looking clothes."
	icon_state = "slickback"

/obj/item/clothing/under/vampire/burlesque
	desc = "Some burlesque clothes."
	icon_state = "burlesque"

/obj/item/clothing/under/vampire/burlesque/daisyd
	desc = "Some short shorts."
	icon_state = "daisyd"

/obj/item/clothing/under/vampire/emo
	name = "Uncolorful attire"
	desc = "Some usual clothes."
	icon_state = "emo"

//WOMEN

/obj/item/clothing/under/vampire/black
	desc = "Some usual clothes."
	icon_state = "black"

/obj/item/clothing/under/vampire/red
	desc = "Some usual clothes."
	icon_state = "red"

/obj/item/clothing/under/vampire/gothic
	desc = "Some usual clothes."
	icon_state = "gothic"

//PATRICK BATEMAN (High Society)

/obj/item/clothing/under/vampire/rich
	desc = "Some rich clothes."
	icon_state = "rich"

/obj/item/clothing/under/vampire/business
	desc = "Some rich clothes."
	icon_state = "business"

//Homeless

/obj/item/clothing/under/vampire/homeless
	name = "Old dirty attire"
	desc = "Some hobo clothes."
	icon_state = "homeless_m"

/obj/item/clothing/under/vampire/homeless/female
	icon_state = "homeless_f"

//Police and Guards

/obj/item/clothing/under/vampire/police
	name = "Police officer uniform"
	desc = "Some law clothes."
	icon_state = "police"

/obj/item/clothing/under/vampire/guard
	name = "Security guard uniform"
	desc = "Some guard clothes."
	icon_state = "guard"

//JOBS

/obj/item/clothing/under/vampire/janitor
	name = "janitorial uniform"
	desc = "Some work clothes."
	icon_state = "janitor"

/obj/item/clothing/under/vampire/nurse
	name = "nurse scrubs"
	desc = "Some sterile clothes."
	icon_state = "nurse"

/obj/item/clothing/under/vampire/graveyard
	desc = "Some work clothes."
	icon_state = "graveyard"

/obj/item/clothing/under/vampire/suit
	name = "suit"
	desc = "Some business clothes."
	icon_state = "suit"

/obj/item/clothing/under/vampire/suit/female
	name = "suitskirt"
	icon_state = "suit_f"

/obj/item/clothing/under/vampire/sheriff
	name = "suit"
	desc = "Some business clothes."
	icon_state = "sheriff"

/obj/item/clothing/under/vampire/sheriff/female
	name = "suitskirt"
	icon_state = "sheriff_f"

/obj/item/clothing/under/vampire/clerk
	name = "suit"
	desc = "Some business clothes."
	icon_state = "clerk"

/obj/item/clothing/under/vampire/clerk/female
	name = "suitskirt"
	icon_state = "clerk_f"

/obj/item/clothing/under/vampire/prince
	name = "suit"
	desc = "Some business clothes."
	icon_state = "prince"

/obj/item/clothing/under/vampire/prince/female
	name = "suitskirt"
	icon_state = "prince_f"

/obj/item/clothing/under/vampire/hound
	name = "suit"
	desc = "Some business clothes."
	icon_state = "agent"

/obj/item/clothing/under/vampire/archivist
	name = "suit"
	desc = "Some old clothes."
	icon_state = "archivist"

/obj/item/clothing/under/vampire/archivist/female
	name = "suitskirt"
	icon_state = "archivist_f"

/obj/item/clothing/under/vampire/bar
	name = "suit"
	desc = "Some maid clothes."
	icon_state = "bar"

/obj/item/clothing/under/vampire/bar/female
	name = "skirt"
	icon_state = "bar_f"

/obj/item/clothing/under/vampire/bouncer
	name = "suit"
	desc = "Some business clothes."
	icon_state = "bouncer"

/obj/item/clothing/under/vampire/supply
	name = "uniform"
	desc = "Some work clothes."
	icon_state = "supply"

//PRIMOGEN

/obj/item/clothing/under/vampire/primogen_malkavian
	name = "pants"
	desc = "Some weirdo rich clothes."
	icon_state = "malkav_pants"

/obj/item/clothing/under/vampire/voivode
	name = "suit"
	desc = "Some fancy clothes."
	icon_state = "voivode"

/obj/item/clothing/under/vampire/bogatyr
	name = "suit"
	desc = "Some nice clothes."
	icon_state = "bogatyr"

/obj/item/clothing/under/vampire/bogatyr/female
	name = "suit"
	desc = "Some nice clothes."
	icon_state = "bogatyr_f"

/obj/item/clothing/under/vampire/primogen_malkavian/female
	name = "suit"
	icon_state = "malkav_suit"

/obj/item/clothing/under/vampire/primogen_toreador
	name = "suit"
	desc = "Some sexy rich clothes."
	icon_state = "toreador_male"

/obj/item/clothing/under/vampire/primogen_toreador/female
	name = "Crimson red dress"
	desc = "Some sexy rich lady clothes."
	icon_state = "toreador_female"

/obj/item/clothing/suit/vampire/trench/malkav
	icon_state = "malkav_coat"

/obj/item/clothing/head/vampire/malkav
	name = "weirdo hat"
	desc = "Can look dangerous or sexy despite the circumstances. Provides some kind of protection."
	icon_state = "malkav_hat"
	armor = list(MELEE = 25, BULLET = 25, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/under/vampire/fancy_gray
	name = "Fancy gray suit"
	desc = "A suit for a real business."
	icon_state = "fancy_gray"

/obj/item/clothing/under/vampire/fancy_red
	name = "Fancy red suit"
	desc = "A suit for a real business."
	icon_state = "fancy_red"

/obj/item/clothing/under/vampire/leatherpants
	name = "Leather pants"
	desc = "A suit for a TRULY REAL business."
	icon_state = "leather_pants"


//PENTEX
/obj/item/clothing/under/pentex
	desc = "Some clothes."
	name = "clothes"
	icon_state = "error"
	has_sensor = NO_SENSORS
	random_sensor = FALSE
	can_adjust = FALSE
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 15)
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_worn = TRUE
	fitted = NO_FEMALE_UNIFORM
	cost = 10

/obj/item/clothing/under/pentex/pentex_janitor
	name = "Ardus Enterprises custodian jumpsuit"
	desc = "An Ardus Enterprises custodian's uniform."
	icon_state = "pentex_janitor"
	armor = list(BIO = 100, ACID = 15, RAD = 5)

/obj/item/clothing/under/pentex/pentex_shortsleeve
	name = "Endron polo-shirt"
	desc = "An Endron International employee uniform. This one is a nice polo!"
	icon_state = "pentex_shortsleeve"

/obj/item/clothing/under/pentex/pentex_longleeve
	name = "Endron shirt"
	desc = "An Endron International employee uniform. This one has sleeves!"
	icon_state = "pentex_longsleeve"

/obj/item/clothing/under/pentex/pentex_turtleneck
	name = "Endron turtleneck"
	desc = "An Endron International employee uniform. This one is a nice turtleneck!"
	icon_state = "pentex_turtleneck"

/obj/item/clothing/under/pentex/pentex_suit
	name = "Endron suit"
	desc = "A nice suit with a green dress-shirt. This one has an Endron International tag on it!"
	icon_state = "pentex_suit"

/obj/item/clothing/under/pentex/pentex_suitskirt
	name = "Endron suitskirt"
	desc = "A nice suitskirt with a green dress-shirt. This one has an Endron International tag on it!"
	icon_state = "pentex_suitskirt"

/obj/item/clothing/under/pentex/pentex_executive_suit
	name = "Endron executive suit"
	desc = "A  white designer suit with a green dress shirt. This one has an Endron International tag on it!"
	icon_state = "pentex_executivesuit"

/obj/item/clothing/under/pentex/pentex_executiveskirt
	name = "Endron executive suitskirt"
	desc = "A white designer suitskirt with a green dress shirt. This one has an Endron International tag on it!"
	icon_state = "pentex_executiveskirt"

//SHOES

//SHOES

//SHOES

/obj/item/clothing/shoes/vampire
	name = "shoes"
	desc = "Comfortable-looking shoes."
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	icon_state = "shoes"
	gender = PLURAL
	can_be_tied = FALSE
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_worn = TRUE
	cost = 5

/obj/item/clothing/shoes/vampire/brown
	icon_state = "shoes_brown"

/obj/item/clothing/shoes/vampire/white
	icon_state = "shoes_white"

/obj/item/clothing/shoes/vampire/jackboots
	name = "boots"
	desc = "Robust-looking boots."
	icon_state = "jackboots"

/obj/item/clothing/shoes/vampire/jackboots/high
	name = "high boots"
	desc = "High boots. What else did you expect?"
	icon_state = "tall_boots"

/obj/item/clothing/shoes/vampire/jackboots/punk
	icon_state = "daboots"

/obj/item/clothing/shoes/vampire/jackboots/work
	icon_state = "jackboots_work"

/obj/item/clothing/shoes/vampire/sneakers
	name = "sneakers"
	desc = "Sport-looking sneakers."
	icon_state = "sneakers"

/obj/item/clothing/shoes/vampire/sneakers/red
	icon_state = "sneakers_red"

/obj/item/clothing/shoes/vampire/heels
	name = "heels"
	desc = "Rich-looking heels."
	icon_state = "heels"

/obj/item/clothing/shoes/vampire/heels/red
	icon_state = "heels_red"

/obj/item/clothing/shoes/vampire/businessscaly
	name = "scaly shoes"
	desc = "Shoes with scales."
	icon_state = "scales_shoes"

/obj/item/clothing/shoes/vampire/businessblack
	name = "black shoes"
	desc = "Classic black shoes."
	icon_state = "business_shoes"

/obj/item/clothing/shoes/vampire/businesstip
	name = "metal tip shoes"
	desc = "Shoes with a metal tip."
	icon_state = "metal_shoes"

//SUITS

//SUITS

//SUITS

/obj/item/clothing/suit/vampire
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'

	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	max_integrity = 250
	resistance_flags = NONE
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)
	body_worn = TRUE
	cost = 15

/obj/item/clothing/suit/hooded/heisenberg
	name = "chemical costume"
	desc = "A costume made for chemical protection."
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "heisenberg"
	inhand_icon_state = "heisenberg"
	body_parts_covered = CHEST | GROIN | ARMS
	cold_protection = CHEST | GROIN | ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor = list(MELEE = 0, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 50, BIO = 0, RAD = 0, FIRE = 50, ACID = 100, WOUND = 10)
	hoodtype = /obj/item/clothing/head/hooded/heisenberg_hood
	body_worn = TRUE

/obj/item/clothing/head/hooded/heisenberg_hood
	name = "chemical hood"
	desc = "A hood attached to a cchemical costume."
	icon_state = "heisenberg_helm"
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEHAIR | HIDEEARS
	armor = list(MELEE = 0, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 50, BIO = 0, RAD = 0, FIRE = 50, ACID = 100, WOUND = 10)
	body_worn = TRUE

//** SPOOOOKY ROBES FROM THE CAPPADOCIAN UPDATE **//
/obj/item/clothing/suit/hooded/robes
	name = "white robe"
	desc = "Some angelic-looking robes."
	icon_state = "robes"
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	inhand_icon_state = "robes"
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = CHEST | GROIN | LEGS | ARMS
	cold_protection = CHEST | GROIN | LEGS | ARMS
	hoodtype = /obj/item/clothing/head/hooded/robes_hood
	body_worn = TRUE

/obj/item/clothing/head/hooded/robes_hood
	name = "white hood"
	desc = "The hood of some angelic-looking robes."
	icon_state = "robes_hood"
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_parts_covered = HEAD
	cold_protection = HEAD
	flags_inv = HIDEHAIR | HIDEEARS
	body_worn = TRUE

/obj/item/clothing/suit/hooded/robes/black
	name = "black robe"
	desc = "Some creepy-looking robes."
	icon_state = "robes_black"
	inhand_icon_state = "robes_black"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/black

/obj/item/clothing/head/hooded/robes_hood/black
	name = "black hood"
	desc = "The hood of some creepy-looking robes."
	icon_state = "robes_black_hood"

/obj/item/clothing/suit/hooded/robes/grey
	name = "grey robe"
	desc = "Some somber-looking robes."
	icon_state = "robes_grey"
	inhand_icon_state = "robes_grey"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/grey

/obj/item/clothing/head/hooded/robes_hood/grey
	name = "grey hood"
	desc = "The hood of some somber-looking robes."
	icon_state = "robes_grey_hood"

/obj/item/clothing/suit/hooded/robes/darkred
	name = "dark red robe"
	desc = "Some zealous-looking robes."
	icon_state = "robes_darkred"
	inhand_icon_state = "robes_darkred"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/darkred

/obj/item/clothing/head/hooded/robes_hood/darkred
	name = "dark red hood"
	desc = "The hood of some zealous-looking robes."
	icon_state = "robes_darkred_hood"

/obj/item/clothing/suit/hooded/robes/yellow
	name = "yellow robe"
	desc = "Some happy-looking robes."
	icon_state = "robes_yellow"
	inhand_icon_state = "robes_yellow"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/yellow

/obj/item/clothing/head/hooded/robes_hood/yellow
	name = "yellow hood"
	desc = "The hood of some happy-looking robes."
	icon_state = "robes_yellow_hood"

/obj/item/clothing/suit/hooded/robes/green
	name = "green robe"
	desc = "Some earthy-looking robes."
	icon_state = "robes_green"
	inhand_icon_state = "robes_green"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/green

/obj/item/clothing/head/hooded/robes_hood/green
	name = "green hood"
	desc = "The hood of some earthy-looking robes."
	icon_state = "robes_green_hood"

/obj/item/clothing/suit/hooded/robes/red
	name = "red robe"
	desc = "Some furious-looking robes."
	icon_state = "robes_red"
	inhand_icon_state = "robes_red"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/red

/obj/item/clothing/head/hooded/robes_hood/red
	name = "red hood"
	desc = "The hood of some furious-looking robes."
	icon_state = "robes_red_hood"

/obj/item/clothing/suit/hooded/robes/purple
	name = "purple robe"
	desc = "Some elegant-looking robes."
	icon_state = "robes_purple"
	inhand_icon_state = "robes_purple"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/purple

/obj/item/clothing/head/hooded/robes_hood/purple
	name = "purple hood"
	desc = "The hood of some elegant-looking robes."
	icon_state = "robes_purple_hood"

/obj/item/clothing/suit/hooded/robes/blue
	name = "blue robe"
	desc = "Some watery-looking robes."
	icon_state = "robes_blue"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/blue

/obj/item/clothing/head/hooded/robes_hood/blue
	name = "blue hood"
	desc = "The hood of some watery-looking robes."
	icon_state = "robes_blue_hood"

/obj/item/clothing/suit/hooded/robes/tremere
	name = "tremere robes"
	desc = "Black robes with red highlights, marked with the emblem of House Tremere."
	icon_state = "tremere_robes"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/tremere

/obj/item/clothing/head/hooded/robes_hood/tremere
	name = "tremere hood"
	desc = "A black hood with red highlights, marked with the emblem of House Tremere."
	icon_state = "tremere_hood"

/obj/item/clothing/suit/hooded/robes/magister
	name = "magister robes"
	desc = "A red robe with an ornate golden trim, marked with the emblem of House Tremere."
	icon_state = "magister_robes"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/magister

/obj/item/clothing/head/hooded/robes_hood/magister
	name = "magister hood"
	desc = "A red hood with an ornate golden trim, marked with the emblem of House Tremere."
	icon_state = "magister_hood"

/obj/item/clothing/suit/vampire/coat
	name = "coat"
	desc = "Warm and heavy clothing."
	icon_state = "coat1"

/obj/item/clothing/suit/vampire/coat/alt
	icon_state = "coat2"

/obj/item/clothing/suit/vampire/coat/winter
	name = "coat"
	desc = "Warm and heavy clothing."
	icon_state = "winter1"

/obj/item/clothing/suit/vampire/coat/winter/alt
	icon_state = "winter2"

/obj/item/clothing/suit/vampire/slickbackcoat
	name = "opulent coat"
	desc = "Lavish, luxurious, and deeply purple. Slickback Clothing Co. It exudes immense energy."
	icon_state = "slickbackcoat"
	armor = list(MELEE = 5, BULLET = 5, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 5)

/obj/item/clothing/suit/vampire/jacket
	name = "leather jacket"
	desc = "True clothing for any punk. Provides some kind of protection."
	icon_state = "jacket1"
	armor = list(MELEE = 25, BULLET = 25, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 25, ACID = 10, WOUND = 25)

/obj/item/clothing/suit/vampire/jacket/fbi
	name = "Federal Bureau of Investigation jacket"
	desc = "\"FBI OPEN UP!!\""
	icon_state = "fbi"
	armor = list(MELEE = 25, BULLET = 25, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 25, ACID = 10, WOUND = 25)

/obj/item/clothing/suit/vampire/jacket/punk
	icon_state = "punk"
	armor = list(MELEE = 50, BULLET = 50, LASER = 10, ENERGY = 10, BOMB = 50, BIO = 0, RAD = 0, FIRE = 25, ACID = 10, WOUND = 25)

/obj/item/clothing/suit/vampire/jacket/better
	icon_state = "jacket2"
	armor = list(MELEE = 35, BULLET = 35, LASER = 10, ENERGY = 10, BOMB = 35, BIO = 0, RAD = 0, FIRE = 35, ACID = 10, WOUND = 35)

/obj/item/clothing/suit/vampire/trench
	name = "trenchcoat"
	desc = "Best noir clothes for night. Provides some kind of protection."
	icon_state = "trench1"
	armor = list(MELEE = 25, BULLET = 25, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 25, ACID = 10, WOUND = 25)

/obj/item/clothing/suit/vampire/trench/alt
	icon_state = "trench2"

/obj/item/clothing/suit/vampire/trench/archive
	name = "rich trenchcoat"
	desc = "Best choise for pleasant life... or not."
	icon_state = "trench3"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/suit/vampire/trench/strauss
	name = "red trenchcoat"
	desc = "True power lies not in wealth, but in the things it affords you."
	icon_state = "strauss_coat"
	armor = list(MELEE = 25, BULLET = 25, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 25, ACID = 10, WOUND = 25)

/obj/item/clothing/suit/vampire/trench/tzi
	name = "fleshcoat"
	desc = "HUMAN LEATHER JACKET."
	icon_state = "trench_tzi"
	armor = list(MELEE = 50, BULLET = 50, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 50)
	clothing_traits = list(TRAIT_UNMASQUERADE)

/obj/item/clothing/suit/vampire/trench/voivode
	name = "regal coat"
	desc = "A beautiful jacket. The blue colors belong to clan Tzimisce. Whoever owns this must be important."
	icon_state = "voicoat"
	armor = list(MELEE = 60, BULLET = 60, LASER = 10, ENERGY = 10, BOMB = 55, BIO = 0, RAD = 0, FIRE = 45, ACID = 10, WOUND = 25)

/obj/item/clothing/suit/vampire/vest
	name = "bulletproof vest"
	desc = "Durable, lightweight vest designed to protect against most threats efficiently."
	icon_state = "vest"
	armor = list(MELEE = 55, BULLET = 55, LASER = 10, ENERGY = 10, BOMB = 55, BIO = 0, RAD = 0, FIRE = 45, ACID = 10, WOUND = 25)
	allowed = list(
		/obj/item/card/id,
		/obj/item/flashlight,
		/obj/item/melee/classic_baton/vampire,
		/obj/item/restraints/handcuffs
	)

/obj/item/clothing/suit/vampire/vest/medieval
	name = "medieval vest"
	desc = "Probably spanish. Provides good protection."
	icon_state = "medieval"
	armor = list(MELEE = 55, BULLET = 55, LASER = 10, ENERGY = 10, BOMB = 55, BIO = 0, RAD = 0, FIRE = 45, ACID = 10, WOUND = 25)

//Police + Army
/obj/item/clothing/suit/vampire/vest/police
	name = "police duty vest"
	icon_state = "pdvest"
	desc = "Lightweight, bulletproof vest with SFPD markings, tailored for active duty."

/obj/item/clothing/suit/vampire/vest/police/sergeant
	name = "police duty vest"
	icon_state = "sgtvest"
	desc = "Lightweight, bulletproof vest with SFPD markings, tailored for active duty. This one has sergeant insignia on it."

// They got an Army vest post-PD update. I am just giving them the same, instead coded into their equipment instead of mapped.
/obj/item/clothing/suit/vampire/vest/police/chief
	name = "police chief duty vest"
	icon_state = "chiefvest"
	desc = "Composite bulletproof vest with SFPD markings, tailored for improved protection. This one has captain insignia on it."
	armor = list(MELEE = 70, BULLET = 70, LASER = 10, ENERGY = 10, BOMB = 60, BIO = 0, RAD = 0, FIRE = 50, ACID = 10, WOUND = 30)

/obj/item/clothing/suit/vampire/vest/army
	desc = "Army equipment. Provides great protection against blunt force."
	icon_state = "army"
	w_class = WEIGHT_CLASS_BULKY
	armor = list(MELEE = 70, BULLET = 70, LASER = 10, ENERGY = 10, BOMB = 55, BIO = 0, RAD = 0, FIRE = 45, ACID = 10, WOUND = 25)
//	clothing_traits = list(TRAIT_UNMASQUERADE)
	masquerade_violating = TRUE

/obj/item/clothing/suit/vampire/eod
	name = "EOD suit"
	desc = "Demoman equipment. Provides best protection against nearly everything."
	icon_state = "eod"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 2
	w_class = WEIGHT_CLASS_BULKY
	armor = list(MELEE = 90, BULLET = 90, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 0, RAD = 0, FIRE = 70, ACID = 90, WOUND = 50)
//	clothing_traits = list(TRAIT_UNMASQUERADE)
	masquerade_violating = TRUE

/obj/item/clothing/suit/vampire/bogatyr
	name = "Bogatyr armor"
	desc = "A regal set of armor made of unknown materials."
	icon_state = "bogatyr_armor"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 1
	w_class = WEIGHT_CLASS_BULKY
	armor = list(MELEE = 75, BULLET = 75, LASER = 15, ENERGY = 15, BOMB = 20, BIO = 0, RAD = 0, FIRE = 55, ACID = 70, WOUND = 35)
//	clothing_traits = list(TRAIT_UNMASQUERADE)

/obj/item/clothing/suit/vampire/labcoat
	name = "labcoat"
	desc = "For medicine and research purposes."
	icon_state = "labcoat"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 90, WOUND = 10)

/obj/item/clothing/suit/vampire/labcoat/director
	name = "clinic director's labcoat"
	desc = "Special labcoat for clinic director with Saint John Clinic's emblems."
	icon_state = "director"

/obj/item/clothing/suit/vampire/fancy_gray
	name = "fancy gray jacket"
	desc = "Gray-colored jacket"
	icon_state = "fancy_gray_jacket"

/obj/item/clothing/suit/vampire/fancy_red
	name = "fancy red jacket"
	desc = "Red-colored jacket"
	icon_state = "fancy_red_jacket"

/obj/item/clothing/suit/vampire/majima_jacket
	name = "too much fancy jacket"
	desc = "Woahhh, check it out! Two macho men havin' a tussle in the nude!? This is a world of shit I didn't know even existed..."
	icon_state = "majima_jacket"

/obj/item/clothing/suit/vampire/bahari
	name = "Dark mother's suit"
	desc = "When I first tasted the fruit of the Trees,\
			felt the seeds of Life and Knowledge, burn within me, I swore that day I would not turn back..."
	icon_state = "bahari"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/suit/vampire/kasaya
	name = "Kasaya"
	desc = "A traditional robe worn by monks and nuns of the Buddhist faith."
	icon_state = "kasaya"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/suit/vampire/imam
	name = "Imam robe"
	desc = "A traditional robe worn by imams of the Islamic faith."
	icon_state = "imam"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/suit/vampire/noddist
	name = "Noddist robe"
	desc = "Shine black the sun! Shine blood the moon! Gehenna is coming soon."
	icon_state = "noddist"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/suit/vampire/orthodox
	name = "Orthodox robe"
	desc = "A traditional robe worn by priests of the Orthodox faith."
	icon_state = "vestments"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

//Pentex Overwear

/obj/item/clothing/suit/pentex
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	max_integrity = 250
	resistance_flags = NONE
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)
	body_worn = TRUE
	cost = 15

/obj/item/clothing/suit/pentex/pentex_labcoat
	name = "Endron labcoat"
	desc = "A crisp white labcoat. This one has the Endron International logo stiched onto the breast!"
	icon_state = "pentex_closedlabcoat"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 90, WOUND = 10)

/obj/item/clothing/suit/pentex/pentex_labcoat_alt
	name = "Endron labcoat"
	desc = "A crisp white labcoat. This one has a green trim and the Endron International logo stiched onto the breast!"
	icon_state = "pentex_labcoat_alt"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 90, WOUND = 10)

//GLASSES

//GLASSES

//GLASSES

/obj/item/clothing/glasses/vampire
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_worn = TRUE

/obj/item/clothing/glasses/vampire/yellow
	name = "yellow aviators"
	desc = "For working in dark environment."
	icon_state = "yellow"
	inhand_icon_state = "glasses"

/obj/item/clothing/glasses/vampire/red
	name = "red aviators"
	desc = "For working in dark environment."
	icon_state = "redg"
	inhand_icon_state = "glasses"

/obj/item/clothing/glasses/vampire/sun
	name = "sunglasses"
	desc = "For looking cool."
	icon_state = "sun"
	inhand_icon_state = "glasses"
	darkness_view = 1
	flash_protect = FLASH_PROTECTION_FLASH

/obj/item/clothing/glasses/vampire/perception
	name = "perception glasses"
	desc = "For reading books."
	icon_state = "perception"
	inhand_icon_state = "glasses"
	vision_correction = TRUE

//HATS

//HATS

//HATS

/obj/item/clothing/head/vampire
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)
	body_worn = TRUE
	cost = 10

/obj/item/clothing/head/vampire/bandana
	name = "bandana"
	desc = "A stylish bandana."
	icon_state = "bandana"

/obj/item/clothing/head/vampire/bandana/red
	icon_state = "bandana_red"

/obj/item/clothing/head/vampire/bandana/black
	icon_state = "bandana_black"

/obj/item/clothing/head/vampire/baseballcap
    name = "baseball cap"
    desc = "A soft hat with a rounded crown and a stiff bill projecting in front. Giants baseball, there's nothing like it!"
    icon_state = "baseballcap"

/obj/item/clothing/head/vampire/ushanka
    name = "ushanka"
    desc = "A heavy fur cap with ear-covering flaps."
    icon_state = "ushanka"

/obj/item/clothing/head/vampire/beanie
	name = "beanie"
	desc = "A stylish beanie."
	icon_state = "hat"

/obj/item/clothing/head/vampire/beanie/black
	icon_state = "hat_black"

/obj/item/clothing/head/vampire/beanie/homeless
	icon_state = "hat_homeless"

/obj/item/clothing/head/vampire/wizard/blue
	name = "blue wizard hat"
	desc = "A watery-looking wizard hat."
	icon_state = "wizardhat_blue"

/obj/item/clothing/head/vampire/wizard/black
	name = "black wizard hat"
	desc = "A sinister-looking wizard hat."
	icon_state = "wizardhat_black"

/obj/item/clothing/head/vampire/wizard/darkred
	name = "dark red wizard hat"
	desc = "A zealous-looking wizard hat."
	icon_state = "wizardhat_darkred"

/obj/item/clothing/head/vampire/wizard/green
	name = "green wizard hat"
	desc = "An earthy looking wizard hat."
	icon_state = "wizardhat_green"

/obj/item/clothing/head/vampire/wizard/grey
	name = "grey wizard hat"
	desc = "A somber-looking wizard hat."
	icon_state = "wizardhat_grey"

/obj/item/clothing/head/vampire/wizard/purple
	name = "purple wizard hat"
	desc = "An elegant-looking wizard hat."
	icon_state = "wizardhat_purple"

/obj/item/clothing/head/vampire/wizard/red
	name = "red wizard hat"
	desc = "A furious-looking wizard hat."
	icon_state = "wizardhat_red"

/obj/item/clothing/head/vampire/wizard/white
	name = "white wizard hat"
	desc = "An angelic-looking wizard hat."
	icon_state = "wizardhat_white"

/obj/item/clothing/head/vampire/wizard/yellow
	name = "yellow wizard hat"
	desc = "A happy-looking wizard hat."
	icon_state = "wizardhat_yellow"

/obj/item/clothing/head/vampire/police
	name = "police hat"
	desc = "Can look dangerous or sexy despite the circumstances. Provides some kind of protection."
	icon_state = "law"
	armor = list(MELEE = 20, BULLET = 20, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/head/vampire/cowboy
	name = "cowboy hat"
	desc = "Looks cool anyway. Provides some kind of protection."
	icon_state = "cowboy"
	armor = list(MELEE = 20, BULLET = 20, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/head/vampire/british
	name = "british police hat"
	desc = "Want some tea? Provides some kind of protection."
	icon_state = "briish"
	armor = list(MELEE = 20, BULLET = 20, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/head/vampire/napoleon
	name = "french admiral hat"
	desc = "Dans mon esprit tout divague, je me perds dans tes yeux... Je me noie dans la vague de ton regard amoureux..."
	icon_state = "french"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 0)

/obj/item/clothing/head/vampire/nazi
	name = "german bad guy hat"
	desc = "\"Du wirst immer ein Schwein sein!\""
	icon_state = "ss"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 0)

/obj/item/clothing/head/vampire/nazi/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ADMIN_TRAIT)

/obj/item/clothing/head/vampire/top
	name = "top hat"
	desc = "Want some tea? Provides some kind of protection."
	icon_state = "top"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 0)

/obj/item/clothing/head/vampire/skull
	name = "skull helmet"
	desc = "Damn... Provides some kind of protection."
	icon_state = "skull"
	armor = list(MELEE = 20, BULLET = 20, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/head/vampire/helmet
	name = "police helmet"
	desc = "Looks dangerous. Provides good protection."
	icon_state = "helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	armor = list(MELEE = 40, BULLET = 40, LASER = 40, ENERGY = 40, BOMB = 20, BIO = 0, RAD = 0, FIRE = 20, ACID = 40, WOUND = 25)
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
//	clothing_traits = list(TRAIT_UNMASQUERADE)
	masquerade_violating = TRUE

/obj/item/clothing/head/vampire/helmet/egorium
	name = "strange mask"
	desc = "Looks mysterious. Provides good protection."
	icon_state = "masque"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	masquerade_violating = FALSE

/obj/item/clothing/head/vampire/helmet/spain
	name = "spain helmet"
	desc = "Concistador! Provides good protection."
	icon_state = "spain"
	flags_inv = HIDEEARS
	armor = list(MELEE = 40, BULLET = 40, LASER = 40, ENERGY = 40, BOMB = 20, BIO = 0, RAD = 0, FIRE = 20, ACID = 40, WOUND = 25)
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	masquerade_violating = FALSE

/obj/item/clothing/head/vampire/army
	name = "army helmet"
	desc = "Looks dangerous. Provides great protection against blunt force."
	icon_state = "viet"
	flags_inv = HIDEEARS|HIDEHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	armor = list(MELEE = 60, BULLET = 60, LASER = 60, ENERGY = 60, BOMB = 40, BIO = 0, RAD = 0, FIRE = 20, ACID = 40, WOUND = 25)
//	clothing_traits = list(TRAIT_UNMASQUERADE)
	masquerade_violating = TRUE

/obj/item/clothing/head/vampire/hardhat
    name = "construction helmet"
    desc = "A thermoplastic hard helmet used to protect the head from injury."
    icon_state = "hardhat"
    armor = list(MELEE = 20, BULLET = 5, LASER = 0, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 5, ACID = 0, WOUND = 15)

/obj/item/clothing/head/vampire/eod
	name = "EOD helmet"
	desc = "Looks dangerous. Provides best protection against nearly everything."
	icon_state = "bomb"
	armor = list(MELEE = 70, BULLET = 70, LASER = 90, ENERGY = 90, BOMB = 100, BIO = 0, RAD = 0, FIRE = 50, ACID = 90, WOUND = 40)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	w_class = WEIGHT_CLASS_BULKY
//	clothing_traits = list(TRAIT_UNMASQUERADE)
	masquerade_violating = TRUE

/obj/item/clothing/head/vampire/bogatyr
	name = "Bogatyr helmet"
	desc = "A regal helmet made of unknown materials."
	icon_state = "bogatyr_helmet"
	armor = list(MELEE = 55, BULLET = 50, LASER = 60, ENERGY = 60, BOMB = 20, BIO = 0, RAD = 0, FIRE = 40, ACID = 70, WOUND = 30)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	w_class = WEIGHT_CLASS_BULKY
//	clothing_traits = list(TRAIT_UNMASQUERADE)

/obj/item/clothing/head/vampire/bahari_mask
	name = "Dark mother's mask"
	desc = "When I first tasted the fruit of the Trees,\
			felt the seeds of Life and Knowledge, burn within me, I swore that day I would not turn back..."
	icon_state = "bahari_mask"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/head/vampire/straw_hat
	name = "straw hat"
	desc = "A straw hat."
	icon_state = "strawhat"

/obj/item/clothing/head/vampire/hijab
	name = "hijab"
	desc = "A traditional headscarf worn by Muslim women."
	icon_state = "hijab"
	flags_inv = HIDEEARS|HIDEHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""

/obj/item/clothing/head/vampire/taqiyah
	name = "taqiyah"
	desc = "A traditional hat worn by Muslim men."
	icon_state = "taqiyah"

/obj/item/clothing/head/vampire/noddist_mask
	name = "Noddist mask"
	desc = "Shine black the sun! Shine blood the moon! Gehenna is coming soon."
	icon_state = "noddist_mask"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/head/vampire/kalimavkion
	name = "Kalimavkion"
	desc = "A traditional hat worn by Orthodox priests."
	icon_state = "kalimavkion"

/obj/item/clothing/head/vampire/prayer_veil
	name = "Prayer veil"
	desc = "A traditional veil."
	icon_state = "prayer_veil"
	flags_inv = HIDEEARS|HIDEHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""

/obj/item/clothing/head/pentex
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)
	body_worn = TRUE
	cost = 10

/obj/item/clothing/head/pentex/pentex_yellowhardhat
	name = "Endron hardhat"
	desc = "A yellow hardhat. This one has an Endron International logo on it!"
	icon_state = "pentex_hardhat_yellow"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/pentex/pentex_whitehardhat
	name = "Endron hardhat"
	desc = "A white hardhat. This one has an Endron International logo on it!"
	icon_state = "pentex_hardhat_white"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/pentex/pentex_beret
	name = "First Team beret"
	desc = "A black beret with a mysterious golden insigna bearing a spiral."
	icon_state = "pentex_beret"
	flags_inv = HIDEHAIR

//GLOVES

//GLOVES

//GLOVES

/obj/item/clothing/gloves/vampire
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	inhand_icon_state = "fingerless"
	undyeable = TRUE
	body_worn = TRUE

/obj/item/clothing/gloves/vampire/leather
	name = "leather gloves"
	desc = "Looks dangerous. Provides some kind of protection."
	icon_state = "leather"
	transfer_prints = TRUE
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	resistance_flags = NONE
	armor = list(MELEE = 15, BULLET = 15, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 30)

/obj/item/clothing/gloves/vampire/work
	name = "work gloves"
	desc = "Provides fire protection for working in extreme environments."
	icon_state = "work"
	permeability_coefficient = 0.9
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list(MELEE = 30, BULLET = 15, LASER = 0, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 70, ACID = 30)

/obj/item/clothing/gloves/vampire/investigator
	name = "investigator gloves"
	desc = "Standard issue FBI workgloves tailored for investigators. Made out of latex outer lining and padded for acid and fire protection."
	icon_state = "work"
	permeability_coefficient = 0.5
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list(MELEE = 30, BULLET = 20, LASER = 5, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 70, ACID = 70)

/obj/item/clothing/gloves/vampire/cleaning
	name = "cleaning gloves"
	desc = "Provides acid protection."
	icon_state = "cleaning"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 70)

/obj/item/clothing/gloves/vampire/latex
	name = "latex gloves"
	desc = "Provides acid protection."
	icon_state = "latex"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 70)

//NECK

//NECK

//NECK

/obj/item/clothing/neck/vampire
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	inhand_icon_state = ""
	w_class = WEIGHT_CLASS_SMALL
	body_worn = TRUE

/obj/item/clothing/neck/vampire/scarf
	name = "black scarf"
	desc = "Provides protection against cold."
	icon_state = "scarf"

/obj/item/clothing/neck/vampire/scarf/red
	name = "red scarf"
	icon_state = "scarf_red"

/obj/item/clothing/neck/vampire/scarf/blue
	name = "blue scarf"
	icon_state = "scarf_blue"

/obj/item/clothing/neck/vampire/scarf/green
	name = "green scarf"
	icon_state = "scarf_green"

/obj/item/clothing/neck/vampire/scarf/white
	name = "white scarf"
	icon_state = "scarf_white"

/obj/item/clothing/neck/vampire/prayerbeads
	name = "prayer beads"
	desc = "These beads are used for prayer."
	icon_state = "beads"

/obj/item/clothing/under/vampire/bacotell
	desc = "Some BacoTell clothes."
	icon_state = "bacotell"

/obj/item/clothing/under/vampire/bubway
	desc = "Some Bubway clothes."
	icon_state = "bubway"

/obj/item/clothing/under/vampire/gummaguts
	desc = "Some Gumma Guts clothes."
	icon_state = "gummaguts"

/obj/item/clothing/mask/vampire
	name = "respirator"
	desc = "A face-covering mask that can be connected to an air supply. While good for concealing your identity, it isn't good for blocking gas flow." //More accurate
	icon_state = "respirator"
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	inhand_icon_state = ""
	w_class = WEIGHT_CLASS_NORMAL
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags_cover = MASKCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	body_worn = TRUE

/obj/item/clothing/mask/vampire/balaclava
	name = "balaclava"
	desc = "LOADSAMONEY"
	icon_state = "balaclava"
	inhand_icon_state = "balaclava"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/pentex/pentex_balaclava
	name = "Thick balaclava"
	desc = "A black balaclava. This one is particularly thick."
	icon_state = "pentex_balaclava"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/tragedy
	name = "tragedy"
	desc = "The Greek Tragedy mask."
	icon_state = "tragedy"
	inhand_icon_state = "tragedy"
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/comedy
	name = "comedy"
	desc = "The Greek Comedy mask."
	icon_state = "comedy"
	inhand_icon_state = "comedy"
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/shemagh
	name = "shemagh"
	desc = "Covers your face pretty well."
	icon_state = "shemagh"
	inhand_icon_state = "shemagh"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/venetian_mask
	name = "Venetian mask"
	desc = "You could wear this to a real masquerade."
	icon_state = "venetian_mask"
	inhand_icon_state = "venetian_mask"
	flags_inv = HIDEFACE | HIDEFACIALHAIR | HIDESNOUT
	flags_cover = MASKCOVERSMOUTH
	visor_flags_inv = HIDEFACE | HIDEFACIALHAIR | HIDESNOUT

/obj/item/clothing/mask/vampire/venetian_mask/fancy
	name = "fancy Venetian mask"
	desc = "Weird rich people definitely wear this kind of stuff."
	icon_state = "venetian_mask_fancy"
	inhand_icon_state = "venetian_mask_fancy"

/obj/item/clothing/mask/vampire/venetian_mask/jester
	name = "jester mask"
	desc = "They will all be amused, every last one of them."
	icon_state = "venetian_mask_jester"
	inhand_icon_state = "venetian_mask_jester"

/obj/item/clothing/mask/vampire/venetian_mask/scary
	name = "bloody mask"
	desc = "With this, you'll look ready to butcher someone."
	icon_state = "venetian_mask_scary"
	inhand_icon_state = "venetian_mask_scary"
	flags_inv = HIDEFACE
	flags_cover = NONE
	visor_flags_inv = HIDEFACE

/obj/item/storage/belt/holster/detective/vampire
	name = "holster"
	desc = "a holster for your gun."
	component_type = /datum/component/storage/concrete/vtm/holster

/obj/item/storage/belt/holster/detective/vampire/police
	desc = "standard issue holster for standard issue sidearms."

/obj/item/storage/belt/holster/detective/vampire/police/PopulateContents()
	new /obj/item/ammo_box/vampire/c9mm/moonclip(src)
	new /obj/item/ammo_box/vampire/c9mm/moonclip(src)
	new /obj/item/gun/ballistic/vampire/revolver/snub(src)

/obj/item/storage/belt/holster/detective/vampire/officer

/obj/item/storage/belt/holster/detective/vampire/officer/PopulateContents()
	new /obj/item/gun/ballistic/automatic/vampire/glock19(src)
	new /obj/item/ammo_box/magazine/glock9mm(src)
	new /obj/item/ammo_box/magazine/glock9mm(src)

/obj/item/storage/belt/holster/detective/vampire/fbi

/obj/item/storage/belt/holster/detective/vampire/fbi/PopulateContents()
	new /obj/item/gun/ballistic/automatic/vampire/glock21(src)
	new /obj/item/ammo_box/magazine/glock45acp(src)
	new /obj/item/ammo_box/magazine/glock45acp(src)


