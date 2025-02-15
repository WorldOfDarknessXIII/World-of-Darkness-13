
GLOBAL_LIST_EMPTY(airlocks)					        //list of all airlocks
GLOBAL_LIST_EMPTY(curtains)							//list of all curtains
GLOBAL_LIST_EMPTY(machines)					        //NOTE: this is a list of ALL machines now. The processing machines list is SSmachine.processing !
GLOBAL_LIST_EMPTY(navbeacons)					    //list of all bot nagivation beacons, used for patrolling.
GLOBAL_LIST_EMPTY(deliverybeacons)			        //list of all MULEbot delivery beacons.
GLOBAL_LIST_EMPTY(deliverybeacontags)			    //list of all tags associated with delivery beacons.
GLOBAL_LIST_EMPTY(wayfindingbeacons)			    //list of all navigation beacons used by wayfinding pinpointers
GLOBAL_LIST_EMPTY(alarmdisplay)				        //list of all machines or programs that can display station alerts

GLOBAL_LIST(chemical_reactions_list)				//list of all /datum/chemical_reaction datums. Used during chemical reactions
GLOBAL_LIST(chemical_reagents_list)				//list of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
GLOBAL_LIST_EMPTY(tech_list)					//list of all /datum/tech datums indexed by id.
GLOBAL_LIST_EMPTY(surgeries_list)				//list of all surgeries by name, associated with their path.
GLOBAL_LIST_EMPTY(crafting_recipes)				//list of all table craft recipes
GLOBAL_LIST_EMPTY(poi_list)					//list of points of interest for observe/follow
GLOBAL_LIST_EMPTY(ladders)
GLOBAL_LIST_EMPTY(trophy_cases)
///This is a global list of all signs you can change an existing sign or new sign backing to, when using a pen on them.
GLOBAL_LIST_EMPTY(editable_sign_types)

GLOBAL_LIST_EMPTY(mob_spawners) 		    // All mob_spawn objects


GLOBAL_LIST_EMPTY(subscribers_numbers_list)
GLOBAL_LIST_EMPTY(phone_numbers_list)
GLOBAL_LIST_EMPTY(phones_list)
GLOBAL_LIST_EMPTY(published_numbers)		//Numbers that are published
GLOBAL_LIST_EMPTY(published_number_names) //Names of published numbers.
GLOBAL_LIST_EMPTY(bank_account_list)

GLOBAL_LIST_EMPTY(masquerade_breakers_list)
GLOBAL_LIST_EMPTY(masquerade_latejoin)

GLOBAL_LIST_EMPTY(generators)
GLOBAL_LIST_EMPTY(totems)
GLOBAL_LIST_EMPTY(umbra_portals)

GLOBAL_LIST_EMPTY(fucking_joined)
GLOBAL_LIST_EMPTY(respawn_timers)

GLOBAL_LIST_EMPTY(police_radios)
GLOBAL_LIST_EMPTY(cleanable_list)
GLOBAL_LIST_EMPTY(malkavian_list)
GLOBAL_LIST_EMPTY(auspex_list)
GLOBAL_LIST_EMPTY(stock_licenses)
GLOBAL_LIST_EMPTY(npc_activities)
GLOBAL_LIST_EMPTY(sabbatites)
GLOBAL_LIST_EMPTY(fog_suka)
GLOBAL_LIST_EMPTY(rain_suka)
GLOBAL_LIST_EMPTY(snow_suka)

GLOBAL_LIST_EMPTY(beast_list)
GLOBAL_LIST_EMPTY(weed_list)
GLOBAL_LIST_EMPTY(zombie_list)

GLOBAL_LIST_INIT(psychokids, list())
