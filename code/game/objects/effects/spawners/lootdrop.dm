/obj/effect/spawner/lootdrop
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_loot"
	layer = OBJ_LAYER
	var/lootcount = 1		//how many items will be spawned
	var/lootdoubles = TRUE	//if the same item can be spawned twice
	var/list/loot			//a list of possible items to spawn e.g. list(/obj/item, /obj/structure, /obj/effect)
	var/fan_out_items = FALSE //Whether the items should be distributed to offsets 0,1,-1,2,-2,3,-3.. This overrides pixel_x/y on the spawner itself

/obj/effect/spawner/lootdrop/Initialize(mapload)
	..()
	if(loot?.len)
		var/loot_spawned = 0
		while((lootcount-loot_spawned) && loot.len)
			var/lootspawn = pickweight(loot)
			while(islist(lootspawn))
				lootspawn = pickweight(lootspawn)
			if(!lootdoubles)
				loot.Remove(lootspawn)

			if(lootspawn)
				var/atom/movable/spawned_loot = new lootspawn(loc)
				if (!fan_out_items)
					if (pixel_x != 0)
						spawned_loot.pixel_x = pixel_x
					if (pixel_y != 0)
						spawned_loot.pixel_y = pixel_y
				else
					if (loot_spawned)
						spawned_loot.pixel_x = spawned_loot.pixel_y = ((!(loot_spawned%2)*loot_spawned/2)*-1)+((loot_spawned%2)*(loot_spawned+1)/2*1)
			loot_spawned++
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/lootdrop/gambling
	name = "gambling valuables spawner"
	loot = list(
				/obj/item/gun/ballistic/revolver/russian = 5,
				/obj/item/clothing/head/ushanka = 3,
				/obj/item/storage/box/syndie_kit/throwing_weapons,
				/obj/item/coin/gold,
				/obj/item/reagent_containers/food/drinks/bottle/vodka/badminka,
				)

/obj/effect/spawner/lootdrop/garbage_spawner
	name = "garbage_spawner"
	loot = list(/obj/effect/spawner/lootdrop/food_packaging = 56,
				/obj/item/trash/can = 8,
				/obj/item/shard = 8,
				/obj/effect/spawner/lootdrop/botanical_waste = 8,
				/obj/effect/spawner/lootdrop/cigbutt = 8,
				/obj/item/reagent_containers/syringe = 5,
				/obj/item/food/deadmouse = 2,
				/obj/item/light/tube/broken = 3,
				/obj/item/light/tube/broken = 1,
				/obj/item/trash/candle = 1)

/obj/effect/spawner/lootdrop/cigbutt
	name = "cigarette butt spawner"
	loot = list(/obj/item/cigbutt = 65,
				/obj/item/cigbutt/roach = 20,
				/obj/item/cigbutt/cigarbutt = 15)

/obj/effect/spawner/lootdrop/food_packaging
	name = "food packaging spawner"
	loot = list(/obj/item/trash/raisins = 20,
				/obj/item/trash/cheesie = 10,
				/obj/item/trash/candy = 10,
				/obj/item/trash/chips = 10,
				/obj/item/trash/sosjerky = 10,
				/obj/item/trash/pistachios = 10,
				/obj/item/trash/boritos = 8,
				/obj/item/trash/can/food/beans = 6,
				/obj/item/trash/popcorn = 5,
				/obj/item/trash/energybar = 5,
				/obj/item/trash/can/food/peaches/maint = 4,
				/obj/item/trash/semki = 2)

/obj/effect/spawner/lootdrop/refreshing_beverage
	name = "good soda spawner"
	loot = list(/obj/item/reagent_containers/food/drinks/soda_cans/grey_bull = 15,
				/obj/item/reagent_containers/food/drinks/soda_cans/monkey_energy = 10,
				/obj/item/reagent_containers/food/drinks/beer/light = 10,
				/obj/item/reagent_containers/food/drinks/soda_cans/shamblers = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/space_mountain_wind = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/sol_dry = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/cola = 5)

/obj/effect/spawner/lootdrop/grille_or_trash
	name = "maint grille or trash spawner"
	loot = list(/obj/structure/grille = 5,
			/obj/item/cigbutt = 1,
			/obj/item/trash/cheesie = 1,
			/obj/item/trash/candy = 1,
			/obj/item/trash/chips = 1,
			/obj/item/food/deadmouse = 1,
			/obj/item/trash/pistachios = 1,
			/obj/item/trash/plate = 1,
			/obj/item/trash/popcorn = 1,
			/obj/item/trash/raisins = 1,
			/obj/item/trash/sosjerky = 1,
			/obj/item/trash/syndi_cakes = 1)


/obj/item/loot_table_maker
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_loot"
	var/spawner_to_test = /obj/effect/spawner/lootdrop/maintenance //what lootdrop spawner to use the loot pool of
	var/loot_count = 180 //180 is about how much maint loot spawns per map as of 11/14/2019
	//result outputs
	var/list/spawned_table //list of all items "spawned" and how many
	var/list/stat_table //list of all items "spawned" and their occurrance probability

/obj/item/loot_table_maker/Initialize()
	. = ..()
	make_table()

/obj/item/loot_table_maker/attack_self(mob/user)
	to_chat(user, "Loot pool re-rolled.")
	make_table()

/obj/item/loot_table_maker/proc/make_table()
	spawned_table = list()
	stat_table = list()
	var/obj/effect/spawner/lootdrop/spawner_to_table = new spawner_to_test
	var/lootpool = spawner_to_table.loot
	qdel(spawner_to_table)
	for(var/i in 1 to loot_count)
		var/loot_spawn = pick_loot(lootpool)
		if(!(loot_spawn in spawned_table))
			spawned_table[loot_spawn] = 1
		else
			spawned_table[loot_spawn] += 1
	stat_table += spawned_table
	for(var/item in stat_table)
		stat_table[item] /= loot_count

/obj/item/loot_table_maker/proc/pick_loot(lootpool) //selects path from loot table and returns it
	var/lootspawn = pickweight(lootpool)
	while(islist(lootspawn))
		lootspawn = pickweight(lootspawn)
	return lootspawn

