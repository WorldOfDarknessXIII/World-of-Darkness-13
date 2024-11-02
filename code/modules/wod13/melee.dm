/obj/item/melee/vampirearms
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	var/quieted = FALSE

/obj/item
	var/masquerade_violating = FALSE

/obj/item/melee/vampirearms/fireaxe
	icon = 'code/modules/wod13/48x32weapons.dmi'
	icon_state = "fireaxe0"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	force = 5
	throwforce = 50
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	attack_verb_continuous = list("attacks", "chops", "cleaves", "tears", "lacerates", "cuts")
	attack_verb_simple = list("attack", "chop", "cleave", "tear", "lacerate", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 30)
	resistance_flags = FIRE_PROOF
	wound_bonus = -15
	bare_wound_bonus = 20
	armour_penetration = 30
	pixel_w = -8
	masquerade_violating = FALSE
	var/wielded = FALSE

/obj/item/melee/vampirearms/fireaxe/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)

/obj/item/melee/vampirearms/fireaxe/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 80, 0 , hitsound)
	AddComponent(/datum/component/two_handed, force_unwielded=5, force_wielded=70, icon_wielded="fireaxe1")

/obj/item/melee/vampirearms/fireaxe/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/obj/item/melee/vampirearms/fireaxe/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/melee/vampirearms/fireaxe/update_icon_state()
	icon_state = "fireaxe0"

/obj/item/melee/vampirearms/fireaxe/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(wielded)
		if(istype(A, /obj/structure/window) || istype(A, /obj/structure/grille))
			var/obj/structure/W = A
			W.obj_destruction("fireaxe")

/obj/item/melee/vampirearms/katana
	name = "katana"
	desc = "An elegant weapon, its tiny edge is capable of cutting through flesh and bone with ease."
	icon = 'code/modules/wod13/48x32weapons.dmi'
	icon_state = "katana"
	flags_1 = CONDUCT_1
	force = 60
	throwforce = 10
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT
	block_chance = 50
	armour_penetration = 50
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/weapons/rapierhit.ogg'
	wound_bonus = 10
	bare_wound_bonus = 25
	pixel_w = -8
	resistance_flags = FIRE_PROOF
	masquerade_violating = FALSE

/obj/item/melee/vampirearms/baseball
	name = "baseball bat"
	desc = "There ain't a skull in the league that can withstand a swatter."
	icon = 'code/modules/wod13/weapons.dmi'
	icon_state = "baseball"
	force = 30
	wound_bonus = -10
	throwforce = 10
	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/melee/vampirearms/baseball/attack(mob/living/target, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored && !HAS_TRAIT(target, TRAIT_TOUGH_FLESH))
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, 1, whack_speed, user)

/obj/item/melee/vampirearms/baseball/hand
	name = "ripped arm"
	desc = "Wow, that was someone's arm."
	icon_state = "hand"
	force = 50
	masquerade_violating = TRUE

/obj/item/melee/vampirearms/tire
	name = "tire iron"
	desc = "Can be used as a tool or as a weapon."
	icon = 'code/modules/wod13/weapons.dmi'
	icon_state = "pipe"
	force = 20
	wound_bonus = -10
	throwforce = 10
	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF

/obj/item/melee/vampirearms/knife
	name = "knife"
	desc = "Don't cut yourself accidentally."
	icon = 'code/modules/wod13/weapons.dmi'
	icon_state = "knife"
	force = 30
	wound_bonus = -10
	throwforce = 10
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/weapons/slash.ogg'
	armour_penetration = 20
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF

/obj/item/melee/vampirearms/knife/gangrel
	name = "claws"
	icon_state = "gangrel"
	w_class = WEIGHT_CLASS_BULKY
	force = 5
	armour_penetration = 100	//It's magical damage
	item_flags = DROPDEL
	masquerade_violating = TRUE

/obj/item/melee/vampirearms/knife/gangrel/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(isliving(target))
		var/mob/living/L = target
		L.apply_damage(30, CLONE)

/obj/item/melee/vampirearms/knife/gangrel/lasombra
	name = "shadow tentacle"
	force = 5
	armour_penetration = 100
	icon_state = "lasombra"
	masquerade_violating = TRUE

/obj/item/melee/touch_attack/quietus
	name = "\improper poison touch"
	desc = "This is kind of like when you rub your feet on a shag rug so you can zap your friends, only a lot less safe."
	icon = 'code/modules/wod13/weapons.dmi'
	catchphrase = null
	on_use_sound = 'sound/magic/disintegrate.ogg'
	icon_state = "quietus"
	inhand_icon_state = "mansus"

/obj/item/melee/touch_attack/quietus/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(isliving(target))
		var/mob/living/L = target
		L.adjustFireLoss(10)
		L.AdjustKnockdown(3 SECONDS)
		L.adjustStaminaLoss(50)
	return ..()

/obj/item/melee/touch_attack/werewolf
	name = "\improper falling touch"
	desc = "This is kind of like when you rub your feet on a shag rug so you can zap your friends, only a lot less safe."
	icon = 'code/modules/wod13/weapons.dmi'
	catchphrase = null
	on_use_sound = 'sound/magic/disintegrate.ogg'
	icon_state = "falling"
	inhand_icon_state = "disintegrate"

/obj/item/melee/touch_attack/werewolf/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(isliving(target))
		var/mob/living/L = target
		L.AdjustKnockdown(2 SECONDS)
		L.adjustStaminaLoss(50)
		L.Immobilize(20)
		if(L.body_position != LYING_DOWN)
			L.toggle_resting()
	return ..()

/obj/item/quietus_upgrade
	name = "poison for weapons"
	desc = "Upgrade your melee weapons with it."
	icon_state = "quietus"
	icon = 'code/modules/wod13/items.dmi'
	w_class = WEIGHT_CLASS_SMALL
	item_flags = DROPDEL

/obj/item/melee/vampirearms/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/quietus_upgrade))
		if(!quieted)
			quieted = TRUE
			armour_penetration = min(100, armour_penetration+30)
			force += 20
			color = "#72b27c"
			qdel(I)

/obj/item/melee/vampirearms/knife/gangrel/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/melee/vampirearms/chainsaw
	name = "chainsaw"
	desc = "A versatile power tool. Useful for limbing trees and delimbing humans."
	icon = 'code/modules/wod13/weapons.dmi'
	icon_state = "chainsaw"
	flags_1 = CONDUCT_1
	force = 15
	var/force_on = 150
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 10
	throw_speed = 2
	throw_range = 4
	attack_verb_continuous = list("saws", "tears", "lacerates", "cuts", "chops", "dices")
	attack_verb_simple = list("saw", "tear", "lacerate", "cut", "chop", "dice")
	hitsound = "swing_hit"
	sharpness = SHARP_EDGED
	actions_types = list(/datum/action/item_action/startchainsaw)
	tool_behaviour = TOOL_SAW
	toolspeed = 0.5
	resistance_flags = FIRE_PROOF
	var/on = FALSE
	var/wielded = FALSE

/obj/item/melee/vampirearms/chainsaw/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)

/obj/item/melee/vampirearms/chainsaw/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 30, 100, 0, 'sound/weapons/chainsawhit.ogg', TRUE)
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/melee/vampirearms/chainsaw/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/obj/item/melee/vampirearms/chainsaw/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/melee/vampirearms/chainsaw/attack_self(mob/user)
	on = !on
	to_chat(user, "As you pull the starting cord dangling from [src], [on ? "it begins to whirr." : "the chain stops moving."]")
	force = on ? force_on : initial(force)
	throwforce = on ? force_on : initial(force)
	var/datum/component/butchering/butchering = src.GetComponent(/datum/component/butchering)
	butchering.butchering_enabled = on

	if(on)
		hitsound = 'sound/weapons/chainsawhit.ogg'
	else
		hitsound = "swing_hit"

	if(src == user.get_active_held_item())
		user.update_inv_hands()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/vampire_stake
	name = "stake"
	desc = "Paralyzes blank-bodies if aimed straight to the heart."
	icon = 'code/modules/wod13/weapons.dmi'
	icon_state = "stake"
	force = 10
//	wound_bonus = -10
	throwforce = 10
	attack_verb_continuous = list("pierces", "cuts")
	attack_verb_simple = list("pierce", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	armour_penetration = 50
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/vampire_stake/attack(mob/living/target, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return
	if(target.IsParalyzed() || target.IsKnockdown() || target.IsStun())
		return
	if(!target.IsParalyzed() && iskindred(target) && !target.stakeimmune)
		visible_message("<span class='warning'>[user] aims [src] straight to the [target]'s heart!</span>", "<span class='warning'>You aim [src] straight to the [target]'s heart!</span>")
		if(do_after(user, 20, target))
			user.do_attack_animation(target)
			visible_message("<span class='warning'>[user] pierces [target]'s torso!</span>", "<span class='warning'>You pierce [target]'s torso!</span>")
			target.Paralyze(1200)
			target.Sleeping(1200)
			qdel(src)

/obj/item/melee/vampirearms/shovel
	icon = 'code/modules/wod13/weapons.dmi'
	icon_state = "shovel"
	name = "shovel"
	desc = "Great weapon against mortal or immortal."
	force = 40
	throwforce = 10
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("attacks", "chops", "tears", "beats")
	attack_verb_simple = list("attack", "chop", "tear", "beat")
	armor = list(MELEE = 25, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	resistance_flags = FIRE_PROOF
	masquerade_violating = FALSE

/obj/item/melee/vampirearms/shovel/attack(mob/living/target, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return
	if(!target.IsStun() && prob(25))
		visible_message("<span class='warning'>[user] bonks [src]'s head!</span>", "<span class='warning'>You bonk[target]'s head!</span>")
		target.Stun(5)
		target.drop_all_held_items()

/obj/item/melee/vampirearms/katana/kosa
	name = "scythe"
	desc = "More instrument, than a weapon. Instrumentally cuts heads..."
	icon = 'code/modules/wod13/weapons.dmi'
	icon_state = "kosa"
	force = 50
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = null
	block_chance = 30
	armour_penetration = 20
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/weapons/rapierhit.ogg'
	wound_bonus = 5
	bare_wound_bonus = 10
	resistance_flags = FIRE_PROOF
	masquerade_violating = TRUE

/obj/item/melee/vampirearms/eguitar
	icon = 'code/modules/wod13/48x32weapons.dmi'
	icon_state = "rock0"
	name = "electric guitar"
	desc = "You are pretty fly for a white guy..."
	force = 40
	throwforce = 25
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	attack_verb_continuous = list("attacks", "chops", "rocks", "hits")
	attack_verb_simple = list("attack", "chop", "rock", "hit")
	hitsound = 'code/modules/wod13/sounds/rock.ogg'
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 30)
	resistance_flags = FIRE_PROOF
	wound_bonus = -15
	bare_wound_bonus = 20
	armour_penetration = 30
	pixel_w = -8
	actions_types = list(/datum/action/item_action/eguitar)
	var/wielded = FALSE
	var/on = FALSE
	var/last_solo = 0

/obj/item/melee/vampirearms/eguitar/AltClick(mob/user)
	if(last_solo+600 > world.time)
		return
	var/result = input(user, "Select a riff") as null|anything in list("1", "2", "3", "4")
	if(result)
		last_solo = world.time
		if(result == "1")
			playsound(loc, 'code/modules/wod13/sounds/solo1.ogg', 100, FALSE)
		if(result == "2")
			playsound(loc, 'code/modules/wod13/sounds/solo2.ogg', 100, FALSE)
		if(result == "3")
			playsound(loc, 'code/modules/wod13/sounds/solo3.ogg', 100, FALSE)
		if(result == "4")
			playsound(loc, 'code/modules/wod13/sounds/solo4.ogg', 100, FALSE)

/obj/item/melee/vampirearms/eguitar/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)

/obj/item/melee/vampirearms/eguitar/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=40, force_wielded=10, icon_wielded="rock1")

/obj/item/melee/vampirearms/eguitar/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/obj/item/melee/vampirearms/eguitar/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/melee/vampirearms/eguitar/update_icon_state()
	icon_state = "rock0"

/obj/item/shield/door
	name = "\improper door"
	desc = "It opens and closes."
	icon_state = "door"
	icon = 'code/modules/wod13/weapons.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	force = 20
	throwforce = 40
	throw_speed = 2
	throw_range = 3
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	max_integrity = 999999
	material_flags = MATERIAL_NO_EFFECTS
