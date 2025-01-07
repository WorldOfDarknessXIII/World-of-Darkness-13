/obj/item/gun/ballistic/vampire
	icon = 'code/modules/wod13/weapons.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	can_suppress = FALSE
	recoil = 2

/obj/item/gun/ballistic/automatic/vampire
	icon = 'code/modules/wod13/weapons.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	can_suppress = FALSE
	recoil = 2

/obj/item/ammo_box/magazine/internal/cylinder/rev44
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/vampire/c44
	caliber = CALIBER_44
	max_ammo = 6

/obj/item/gun/ballistic/vampire/revolver
	name = "\improper magnum revolver"
	desc = "Feelin' lucky, punk?"
	icon_state = "revolver"
	inhand_icon_state = "revolver"
	worn_icon_state = "revolver"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev44
	initial_caliber = CALIBER_44
	fire_sound = 'code/modules/wod13/sounds/revolver.ogg'
	load_sound = 'sound/weapons/gun/revolver/load_bullet.ogg'
	eject_sound = 'sound/weapons/gun/revolver/empty.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 85
	dry_fire_sound = 'sound/weapons/gun/revolver/dry_fire.ogg'
	casing_ejector = FALSE
	internal_magazine = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	tac_reloads = FALSE
	cost = 25
	var/spin_delay = 10
	var/recent_spin = 0

/obj/item/gun/ballistic/vampire/revolver/chamber_round(keep_bullet, spin_cylinder = TRUE, replace_new_round)
	if(!magazine) //if it mag was qdel'd somehow.
		CRASH("revolver tried to chamber a round without a magazine!")
	if(spin_cylinder)
		chambered = magazine.get_round(TRUE)
	else
		chambered = magazine.stored_ammo[1]

/obj/item/gun/ballistic/vampire/revolver/shoot_with_empty_chamber(mob/living/user as mob|obj)
	..()
	chamber_round()

/obj/item/gun/ballistic/vampire/revolver/AltClick(mob/user)
	..()
	spin()

/obj/item/gun/ballistic/vampire/revolver/verb/spin()
	set name = "Spin Chamber"
	set category = "Object"
	set desc = "Click to spin your revolver's chamber."

	var/mob/M = usr

	if(M.stat || !in_range(M,src))
		return

	if (recent_spin > world.time)
		return
	recent_spin = world.time + spin_delay

	if(do_spin())
		playsound(usr, "revolver_spin", 30, FALSE)
		usr.visible_message("<span class='notice'>[usr] spins [src]'s chamber.</span>", "<span class='notice'>You spin [src]'s chamber.</span>")
	else
		verbs -= /obj/item/gun/ballistic/vampire/revolver/verb/spin

/obj/item/gun/ballistic/vampire/revolver/proc/do_spin()
	var/obj/item/ammo_box/magazine/internal/cylinder/C = magazine
	. = istype(C)
	if(.)
		C.spin()
		chamber_round(spin_cylinder = FALSE)

/obj/item/gun/ballistic/revolver/get_ammo(countchambered = FALSE, countempties = TRUE)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/gun/ballistic/vampire/revolver/examine(mob/user)
	. = ..()
	var/live_ammo = get_ammo(FALSE, FALSE)
	. += "[live_ammo ? live_ammo : "None"] of those are live rounds."
	if (current_skin)
		. += "It can be spun with <b>alt+click</b>"


/obj/item/gun/ballistic/vampire/revolver/snub
	name = "\improper snub-nosed revolver"
	desc = "a cheap Saturday night special revolver. Sometimes called a 'purse gun'. It takes 9mm rounds."
	icon_state = "revolver_snub"
	inhand_icon_state = "revolver_snub"
	worn_icon_state = "revolver_snub"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev9mm
	w_class = WEIGHT_CLASS_SMALL
	initial_caliber = CALIBER_9MM
	fire_sound_volume = 65
	projectile_damage_multiplier = 1.2 //21.6 damage, slightly higher than the m1911, just so it is possible to kill NPCs within 6 bullets
	cost = 20

/obj/item/ammo_box/magazine/internal/cylinder/rev9mm
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	caliber = CALIBER_9MM
	max_ammo = 6

/obj/item/ammo_box/magazine/m44
	name = "handgun magazine (.44)"
	icon = 'code/modules/wod13/ammo.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "deagle"
	ammo_type = /obj/item/ammo_casing/vampire/c44
	caliber = CALIBER_44
	max_ammo = 7
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/vampire/deagle
	name = "\improper Desert Eagle"
	desc = "A powerful .44 handgun."
	icon_state = "deagle"
	inhand_icon_state = "deagle"
	worn_icon_state = "deagle"
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/m44
	recoil = 3
	burst_size = 1
	fire_delay = 0
	actions_types = list()
	bolt_type = BOLT_TYPE_LOCKING
	fire_sound = 'code/modules/wod13/sounds/deagle.ogg'
	dry_fire_sound = 'sound/weapons/gun/pistol/dry_fire.ogg'
	load_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	load_empty_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	eject_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	eject_empty_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	vary_fire_sound = FALSE
	rack_sound = 'sound/weapons/gun/pistol/rack_small.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/lock_small.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/drop_small.ogg'
	fire_sound_volume = 75
	cost = 75

/obj/item/ammo_box/magazine/m50
	name = "handgun magazine (.50)"
	icon = 'code/modules/wod13/ammo.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "deagle"
	ammo_type = /obj/item/ammo_casing/vampire/c50
	caliber = CALIBER_50
	max_ammo = 7
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/vampire/deagle/c50
	name = "\improper McLusky .50 caliber "
	desc = "An extremely powerful, and rare, handcannon."
	icon_state = "deagle50"
	inhand_icon_state = "deagle"
	worn_icon_state = "deagle"
	mag_type = /obj/item/ammo_box/magazine/m50
	fire_sound_volume = 125 //MY EARS

/obj/item/ammo_box/magazine/vamp45acp
	name = "pistol magazine (.45 ACP)"
	icon = 'code/modules/wod13/ammo.dmi'
//	lefthand_file = 'code/modules/wod13/righthand.dmi'
//	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "m1911"
	ammo_type = /obj/item/ammo_casing/vampire/c45acp
	caliber = CALIBER_45
	max_ammo = 8
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/vampire/m1911
	name = "\improper Colt 1911"
	desc = "A reliable .45 ACP handgun."
	icon_state = "m1911"
	inhand_icon_state = "m1911"
	worn_icon_state = "m1911"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/vamp45acp
	burst_size = 1
	fire_delay = 0
	actions_types = list()
	bolt_type = BOLT_TYPE_LOCKING
	fire_sound = 'code/modules/wod13/sounds/m1911.ogg'
	dry_fire_sound = 'sound/weapons/gun/pistol/dry_fire.ogg'
	load_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	load_empty_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	eject_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	eject_empty_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	vary_fire_sound = FALSE
	rack_sound = 'sound/weapons/gun/pistol/rack_small.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/lock_small.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/drop_small.ogg'
	fire_sound_volume = 100
	cost = 55

/obj/item/ammo_box/magazine/glock9mm
	name = "automatic pistol magazine (9mm)"
	icon = 'code/modules/wod13/ammo.dmi'
//	lefthand_file = 'code/modules/wod13/righthand.dmi'
//	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "glock19"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	caliber = CALIBER_9MM
	max_ammo = 15
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/vampire/glock19
	name = "\improper Glock 19"
	desc = "Very fast 9mm handgun."
	icon_state = "glock19"
	inhand_icon_state = "glock19"
	worn_icon_state = "glock19"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/glock9mm
	burst_size = 3
	fire_delay = 1
	actions_types = list()
	bolt_type = BOLT_TYPE_LOCKING
	fire_sound = 'code/modules/wod13/sounds/glock.ogg'
	dry_fire_sound = 'sound/weapons/gun/pistol/dry_fire.ogg'
	load_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	load_empty_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	eject_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	eject_empty_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	vary_fire_sound = FALSE
	rack_sound = 'sound/weapons/gun/pistol/rack_small.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/lock_small.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/drop_small.ogg'
	fire_sound_volume = 100
	cost = 70

/obj/item/ammo_box/magazine/glock45acp
	name = "automatic pistol magazine (.45 ACP)"
	icon = 'code/modules/wod13/ammo.dmi'
//	lefthand_file = 'code/modules/wod13/righthand.dmi'
//	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "glock21"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	caliber = CALIBER_45
	max_ammo = 12
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/vampire/glock21
	name = "\improper Glock 21"
	desc = "Very fast 45 ACP handgun."
	icon_state = "glock19"
	inhand_icon_state = "glock19"
	worn_icon_state = "glock19"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/glock45acp
	burst_size = 3
	fire_delay = 1
	actions_types = list()
	bolt_type = BOLT_TYPE_LOCKING
	fire_sound = 'code/modules/wod13/sounds/glock.ogg'
	dry_fire_sound = 'sound/weapons/gun/pistol/dry_fire.ogg'
	load_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	load_empty_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	eject_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	eject_empty_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	vary_fire_sound = FALSE
	rack_sound = 'sound/weapons/gun/pistol/rack_small.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/lock_small.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/drop_small.ogg'
	fire_sound_volume = 100
	cost = 150

/obj/item/ammo_box/magazine/vamp9mm
	name = "uzi magazine (9mm)"
	icon = 'code/modules/wod13/ammo.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "uzi"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	caliber = CALIBER_9MM
	max_ammo = 32
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/vampire/uzi
	name = "\improper Killamatic Uzi"
	desc = "A lightweight, burst-fire submachine gun, for when you really want someone dead. Uses 9mm rounds."
	icon_state = "uzi"
	inhand_icon_state = "uzi"
	worn_icon_state = "uzi"
	mag_type = /obj/item/ammo_box/magazine/vamp9mm
	burst_size = 5
	spread = 11
	recoil = 5
	bolt_type = BOLT_TYPE_OPEN
	show_bolt_icon = FALSE
	mag_display = TRUE
	rack_sound = 'sound/weapons/gun/pistol/slide_lock.ogg'
	fire_sound = 'code/modules/wod13/sounds/uzi.ogg'
	cost = 175

/obj/item/ammo_box/magazine/vamp9mp5
	name = "mp5 magazine (9mm)"
	icon = 'code/modules/wod13/ammo.dmi'
//	lefthand_file = 'code/modules/wod13/righthand.dmi'
//	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "mp5"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	caliber = CALIBER_9MM
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/vampire/mp5
	name = "\improper HK MP5"
	desc = "A lightweight, burst-fire submachine gun, for when you really want to do some dirty cool job. Uses 9mm rounds."
	icon_state = "mp5"
	icon = 'code/modules/wod13/48x32weapons.dmi'
	inhand_icon_state = "mp5"
	worn_icon_state = "mp5"
	mag_type = /obj/item/ammo_box/magazine/vamp9mp5
	burst_size = 4
	spread = 4
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	rack_sound = 'sound/weapons/gun/pistol/slide_lock.ogg'
	fire_sound = 'code/modules/wod13/sounds/mp5.ogg'
	cost = 200

/obj/item/ammo_box/magazine/vamp556
	name = "carbine magazine (5.56mm)"
	icon = 'code/modules/wod13/ammo.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "rifle"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm
	caliber = CALIBER_556
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/vampire/ar15
	name = "\improper AR-15 Carbine"
	desc = "A two-round burst 5.56 toploading carbine, designated 'AR-15'."
	icon = 'code/modules/wod13/48x32weapons.dmi'
	icon_state = "rifle"
	inhand_icon_state = "rifle"
	worn_icon_state = "rifle"
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/vamp556
	burst_size = 2
	fire_delay = 2
	spread = 4
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	fire_sound = 'code/modules/wod13/sounds/rifle.ogg'
	masquerade_violating = TRUE
	cost = 250

/obj/item/ammo_box/magazine/vamp545
	name = "rifle magazine (5.45mm)"
	icon = 'code/modules/wod13/ammo.dmi'
//	lefthand_file = 'code/modules/wod13/righthand.dmi'
//	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "ak"
	ammo_type = /obj/item/ammo_casing/vampire/c545mm
	caliber = CALIBER_545
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/vampire/ak74
	name = "\improper Kalashnikov's Automatic Rifle 74"
	desc = "Pretty old, but also easy fireable and cleanable by vodka.Uses 5.45 rounds."
	icon = 'code/modules/wod13/48x32weapons.dmi'
	icon_state = "ak74"
	inhand_icon_state = "ak74"
	worn_icon_state = "ak74"
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/vamp545
	recoil = 5
	burst_size = 3
	fire_delay = 3
	spread = 8
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	fire_sound = 'code/modules/wod13/sounds/ak.ogg'
	masquerade_violating = TRUE
	cost = 225

/obj/item/ammo_box/magazine/vampaug
	name = "AUG magazine (5.56mm)"
	icon = 'code/modules/wod13/ammo.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "aug"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm
	caliber = CALIBER_556
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/vampire/aug
	name = "\improper Steyr AUG-77"
	desc = "A three-round burst 5.56 bullpup design, designated 'Steyr AUG-77'."
	icon = 'code/modules/wod13/48x32weapons.dmi'
	icon_state = "aug"
	inhand_icon_state = "aug"
	worn_icon_state = "aug"
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/vampaug
	burst_size = 3
	fire_delay = 2
	spread = 3
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	fire_sound = 'code/modules/wod13/sounds/rifle.ogg'
	masquerade_violating = TRUE
	cost = 350
	is_iron = FALSE

/obj/item/ammo_box/magazine/vampthompson
	name = "tommy gun magazine (.45 ACP)"
	icon = 'code/modules/wod13/ammo.dmi'
	icon_state = "thompson"
//	lefthand_file = 'code/modules/wod13/righthand.dmi'
//	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	ammo_type = /obj/item/ammo_casing/vampire/c45acp
	caliber = CALIBER_45
	max_ammo = 50
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/vampire/thompson
	name = "\improper Thompson Submachine Gun"
	desc = "\"Mamma-mia, Mercurio! Yu shot 'im in da head, he can't speek now! Yu guappo, Mercurio, yu naturale guappo!\""
	icon = 'code/modules/wod13/48x32weapons.dmi'
	icon_state = "thompson"
	inhand_icon_state = "thompson"
	worn_icon_state = "thompson"
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/vampthompson
	recoil = 7
	burst_size = 5
	fire_delay = 3
	spread = 15
	bolt_type = BOLT_TYPE_OPEN
	show_bolt_icon = FALSE
	mag_display = TRUE
	fire_sound = 'code/modules/wod13/sounds/thompson.ogg'
	masquerade_violating = TRUE
	cost = 250

/obj/item/ammo_box/magazine/internal/vampire/sniper
	name = "sniper rifle internal magazine"
	desc = "Oh god, this shouldn't be here"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm
	caliber = CALIBER_556
	max_ammo = 5
	multiload = TRUE

/obj/item/gun/ballistic/automatic/vampire/sniper
	name = "sniper rifle"
	desc = "A long ranged weapon that does significant damage. No, you can't quickscope."
	icon = 'code/modules/wod13/48x32weapons.dmi'
	icon_state = "sniper"
	inhand_icon_state = "sniper"
	worn_icon_state = "sniper"
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/internal/vampire/sniper
	bolt_wording = "bolt"
	bolt_type = BOLT_TYPE_STANDARD
	semi_auto = FALSE
	internal_magazine = TRUE
	fire_sound = 'code/modules/wod13/sounds/sniper.ogg'
	fire_sound_volume = 90
	vary_fire_sound = FALSE
	rack_sound = 'sound/weapons/gun/rifle/bolt_out.ogg'
	bolt_drop_sound = 'sound/weapons/gun/rifle/bolt_in.ogg'
	tac_reloads = FALSE
	fire_delay = 40
	burst_size = 1
	w_class = WEIGHT_CLASS_NORMAL
	zoomable = TRUE
	zoom_amt = 10 //Long range, enough to see in front of you, but no tiles behind you.
	zoom_out_amt = 5
	slot_flags = ITEM_SLOT_BACK
	projectile_damage_multiplier = 1.5
	actions_types = list()
	masquerade_violating = TRUE
	cost = 250

/obj/item/ammo_box/magazine/internal/vampshotgun
	name = "shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/vampire/c12g
	caliber = CALIBER_12G
	multiload = FALSE
	max_ammo = 6
	masquerade_violating = FALSE

/obj/item/gun/ballistic/shotgun/vampire
	name = "shotgun"
	desc = "A traditional shotgun with wood furniture and a six-round tube magazine."
	icon = 'code/modules/wod13/48x32weapons.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_BULKY
	icon_state = "pomp"
	inhand_icon_state = "pomp"
	worn_icon_state = "pomp"
	recoil = 6
	fire_delay = 6
	mag_type = /obj/item/ammo_box/magazine/internal/vampshotgun
	can_be_sawn_off	= FALSE
	fire_sound = 'code/modules/wod13/sounds/pomp.ogg'
	recoil = 4
	inhand_x_dimension = 32
	inhand_y_dimension = 32

/obj/item/gun/ballistic/shotgun/toy/crossbow/vampire
	name = "crossbow"
	desc = "Welcome to the Middle Ages!"
	icon = 'code/modules/wod13/48x32weapons.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "crossbow0"
	inhand_icon_state = "crossbow0"
	fire_delay = 16
	mag_type = /obj/item/ammo_box/magazine/internal/vampcrossbow
	fire_sound = 'sound/items/syringeproj.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	masquerade_violating = TRUE
	is_iron = FALSE

/obj/item/ammo_box/magazine/internal/vampcrossbow
	ammo_type = /obj/item/ammo_casing/caseless/bolt
	caliber = CALIBER_FOAM
	max_ammo = 2

/obj/item/ammo_casing/caseless/bolt
	name = "bolt"
	desc = "Welcome to the Middle Ages!"
	projectile_type = /obj/projectile/bullet/crossbow_bolt
	caliber = CALIBER_FOAM
	icon_state = "arrow"
	icon = 'code/modules/wod13/ammo.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	harmful = TRUE

/obj/item/molotov
	name = "molotov cocktail"
	desc = "Well fire weapon."
	icon_state = "molotov"
	icon = 'code/modules/wod13/weapons.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/active = FALSE
	masquerade_violating = TRUE

/obj/item/molotov/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	for(var/turf/open/floor/F in range(2, hit_atom))
		if(F)
			new /obj/effect/decal/cleanable/gasoline(F)
	if(active)
		new /obj/effect/fire(get_turf(hit_atom))
	playsound(get_turf(hit_atom), 'code/modules/wod13/sounds/explode.ogg', 100, TRUE)
	qdel(src)
	..()

/obj/item/molotov/attackby(obj/item/I, mob/user, params)
	if(I.get_temperature() && !active)
		active = TRUE
		log_bomber(user, "has primed a", src, "for detonation")
		icon_state = "molotov_flamed"

/obj/item/vampire_flamethrower
	name = "flamethrower"
	desc = "Well fire weapon."
	icon_state = "flamethrower4"
	icon = 'code/modules/wod13/weapons.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	masquerade_violating = TRUE
	var/oil = 1000

/obj/item/vampire_flamethrower/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/gas_can))
		var/obj/item/gas_can/G = W
		if(G.stored_gasoline > 10 && oil < 1000)
			var/gas_to_transfer = min(G.stored_gasoline, 1000-oil)
			G.stored_gasoline = max(0, G.stored_gasoline-gas_to_transfer)
			oil = min(1000, oil+gas_to_transfer)
			if(oil)
				playsound(get_turf(user), 'code/modules/wod13/sounds/gas_fill.ogg', 50, TRUE)
				to_chat(user, "<span class='notice'>You fill [src].</span>")
				icon_state = "flamethrower4"

/obj/item/vampire_flamethrower/examine(mob/user)
	. = ..()
	. += "<b>Ammo:</b> [(oil/1000)*100]%"

/obj/item/vampire_flamethrower/afterattack(atom/target, mob/user, flag)
	. = ..()
//	if(flag)
//		return
//	if(ishuman(user))
//		if(!can_trigger_gun(user))
//			return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, "<span class='warning'>You can't bring yourself to fire \the [src]! You don't want to risk harming anyone...</span>")
		return
	playsound(get_turf(user), 'code/modules/wod13/sounds/flamethrower.ogg', 50, TRUE)
	visible_message("<span class='warning'>[user] fires [src]!</span>", "<span class='warning'>You fire [src]!</span>")
	if(user && user.get_active_held_item() == src) // Make sure our user is still holding us
		var/turf/target_turf = get_turf(target)
		if(target_turf)
			var/turflist = getline(user, target_turf)
			log_combat(user, target, "flamethrowered", src)
			for(var/turf/open/floor/F in turflist)
				if(F)
					if(F != user.loc)
						if(oil)
							new /obj/effect/decal/cleanable/gasoline(F)
							oil = max(0, oil-10)
							if(oil == 0)
								icon_state = "flamethrower1"
						new /obj/effect/fire(F)
