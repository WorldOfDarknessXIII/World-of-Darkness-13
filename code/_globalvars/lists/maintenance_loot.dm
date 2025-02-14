//as of:10/28/2019:
//boxstation: ~153 loot items spawned
//metastation: ~183 loot items spawned
//deltastation: ~165 loot items spawned

//how to balance maint loot spawns:
// 1) Ensure each category has items of approximately the same power level
// 2) Tune weight of each category until average power of a maint loot spawn is acceptable
// 3) Mapping considerations - Loot value should scale with difficulty of acquisition, or an assistaint will run through collecting free gear with no risk

//goal of maint loot:
// 1) Provide random equipment to people who take effort to crawl maint
// 2) Create memorable moments with very rare, crazy items

//Loot tables

GLOBAL_LIST_INIT(trash_loot, list(//junk: useless, very easy to get, or ghetto chemistry items
	list(//trash
		/obj/item/trash/can = 1,
		/obj/item/trash/raisins = 1,
		/obj/item/trash/candy = 1,
		/obj/item/trash/cheesie = 1,
		/obj/item/trash/chips = 1,
		/obj/item/trash/popcorn = 1,
		/obj/item/trash/sosjerky = 1,
		/obj/item/trash/plate = 1,
		/obj/item/trash/pistachios = 1,

		/obj/item/folder/yellow = 1,
		/obj/item/hand_labeler = 1,
		/obj/item/pen = 1,
		/obj/item/paper = 1,
		/obj/item/paper/crumpled = 1,
		/obj/item/photo/old = 1,
		/obj/item/stack/sheet/cardboard = 1,
		/obj/item/storage/box = 1,

		/obj/item/reagent_containers/food/drinks/drinkingglass = 1,
		/obj/item/coin/silver = 1,
		/obj/effect/decal/cleanable/ash = 1,
		/obj/item/cigbutt = 1,
		/obj/item/camera = 1,
		/obj/item/camera_film = 1,
		/obj/item/light/bulb = 1,
		/obj/item/light/tube = 1,
		/obj/item/food/urinalcake = 1,

		/obj/item/airlock_painter = 1,
		/obj/item/airlock_painter/decal = 1,
		/obj/item/rack_parts = 1,
		/obj/item/clothing/mask/breath = 1,
		/obj/item/shard = 1,

		/obj/item/reagent_containers/pill/maintenance = 1,
		/obj/item/toy/eightball = 1,
		) = 8,
	))



GLOBAL_LIST_INIT(common_loot, list( //common: basic items
	list(//tools
		/obj/item/screwdriver = 1,
		/obj/item/wirecutters = 1,
		/obj/item/wrench = 1,
		/obj/item/crowbar = 1,
		/obj/item/t_scanner = 1,
		/obj/item/geiger_counter = 1,
		/obj/item/analyzer = 1,
		/obj/item/mop = 1,
		/obj/item/pushbroom = 1,
		/obj/item/reagent_containers/glass/bucket = 1,
		/obj/item/toy/crayon/spraycan = 1,
		) = 1,

	list(//equipment
		/obj/item/clothing/mask/gas = 1,
		/obj/item/radio/headset = 1,
		/obj/item/storage/backpack = 1,
		/obj/item/clothing/shoes/sneakers/black = 1,
		/obj/item/clothing/suit/hazardvest = 1,
		/obj/item/clothing/suit/toggle/labcoat = 1,
		/obj/item/clothing/under/color/grey = 1,
		/obj/item/clothing/gloves/color/fyellow = 1,
		/obj/effect/spawner/lootdrop/gloves = 1,
		/obj/item/storage/wallet/random = 1,
		/obj/item/clothing/glasses/science = 1,
		/obj/item/clothing/glasses/meson = 1,
		/obj/item/storage/belt/fannypack = 1,
		/obj/item/clothing/gloves/tackler/offbrand = 1,
		) = 1,

	list(//construction and crafting
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/cell = 1,
		/obj/item/stack/rods/twentyfive = 1,
		/obj/item/stack/sheet/metal/twenty = 1,
		/obj/item/stack/sheet/mineral/plasma = 1,
		/obj/item/sign = 1,

		//assemblies
		/obj/item/assembly/infra = 1,
		/obj/item/assembly/signaler = 1,
		/obj/item/assembly/mousetrap = 1,
		/obj/item/assembly/prox_sensor = 1,
		/obj/item/assembly/timer = 1,
		/obj/item/assembly/igniter = 1,
		/obj/item/assembly/health = 1,

		/obj/item/stack/package_wrap = 1,
		) = 1,

	list(//medical and chemicals
		/obj/item/storage/fancy/cigarettes/dromedaryco = 1,
		/obj/item/grenade/chem_grenade/cleaner = 1,
		/obj/item/storage/box/matches = 1,
		/obj/item/reagent_containers/syringe = 1,
		/obj/item/reagent_containers/glass/beaker = 1,
		/obj/item/reagent_containers/glass/rag = 1,
		/obj/item/reagent_containers/hypospray/medipen/pumpup = 2,
		) = 1,

	list(//food
		/obj/item/reagent_containers/food/drinks/beer = 1,
		/obj/item/reagent_containers/food/drinks/coffee = 1,
		) = 1,

	list(//misc
		/obj/item/radio/off = 1,
		/obj/item/extinguisher = 1,
		/obj/item/tank/internals/emergency_oxygen = 1,
		/obj/item/bodybag = 1,
		/obj/item/grenade/smokebomb = 1,
		/obj/item/stack/spacecash/c10 = 1,
		/obj/item/stack/sticky_tape = 1,

		//light sources
		/obj/item/flashlight = 1,
		/obj/effect/spawner/lootdrop/glowstick = 1,
		/obj/item/clothing/head/hardhat/red = 1,
		/obj/item/flashlight/flare = 1,
		) = 1,
	))

//Maintenance loot spawner pools
#define maint_trash_weight 4499
#define maint_common_weight 4500
#define maint_uncommon_weight 1000
#define maint_oddity_weight 1 //1 out of 10,000 would give metastation (180 spawns) a 2 in 111 chance of spawning an oddity per round, similar to xeno egg
#define maint_holiday_weight 3500 // When holiday loot is enabled, it'll give every loot item a 25% chance of being a holiday item

//Loot pool used by default maintenance loot spawners
GLOBAL_LIST_INIT(maintenance_loot, list(
	GLOB.trash_loot = maint_trash_weight,
	GLOB.common_loot = maint_common_weight,
	GLOB.uncommon_loot = maint_uncommon_weight,
	GLOB.oddity_loot = maint_oddity_weight,
	))

GLOBAL_LIST_INIT(ratking_trash, list(//Garbage: used by the regal rat mob when spawning garbage.
			/obj/item/cigbutt,
			/obj/item/trash/cheesie,
			/obj/item/trash/candy,
			/obj/item/trash/chips,
			/obj/item/trash/pistachios,
			/obj/item/trash/plate,
			/obj/item/trash/popcorn,
			/obj/item/trash/raisins,
			/obj/item/trash/sosjerky,
			/obj/item/trash/syndi_cakes))

GLOBAL_LIST_INIT(ratking_coins, list(//Coins: Used by the regal rat mob when spawning coins.
			/obj/item/coin/iron,
			/obj/item/coin/silver,
			/obj/item/coin/plastic,
			/obj/item/coin/titanium))
