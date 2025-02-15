/obj/structure/vampdoor/npc
	icon_state = "wood-1"
	baseicon = "wood"
	locked = TRUE
	lock_id = "npc"
	burnable = TRUE
	lockpick_difficulty = 4

/obj/structure/vampdoor/npc/Initialize()
	. = ..()
	lock_id = "npc[rand(1, 20)]"
