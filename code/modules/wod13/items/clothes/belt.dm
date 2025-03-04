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


