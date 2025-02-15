/obj/item/vamp/keys/npc
	name = "Some keys"
	accesslocks = list(
		"npc"
	)

/obj/item/vamp/keys/npc/Initialize()
	. = ..()
	accesslocks = list(
		"npc[rand(1, 20)]"
	)

/obj/item/vamp/keys/npc/fix
	roundstart_fix = TRUE