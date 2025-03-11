/datum/discipline/obtenebration
	name = "Obtenebration"
	desc = "Controls the darkness around you."
	icon_state = "obtenebration"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/obtenebration

/datum/discipline_power/obtenebration
	name = "Obtenebration power name"
	desc = "Obtenebration power description"

	effect_sound = 'sound/magic/voidblink.ogg'

//SHADOW PLAY
/datum/discipline_power/obtenebration/shadow_play
	name = "Shadow Play"
	desc = "Manipulate shadows to block visibility."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_TURF | TARGET_MOB | TARGET_OBJ | TARGET_SELF
	range = 7

	multi_activate = TRUE
	duration_length = 10 SECONDS
	cooldown_length = 5 SECONDS

	var/atom/movable/shadow

/datum/discipline_power/obtenebration/shadow_play/activate(target)
	. = ..()
	shadow = new(target)
	shadow.set_light(3, -7)

/datum/discipline_power/obtenebration/shadow_play/deactivate(target)
	. = ..()
	if (shadow)
		QDEL_NULL(shadow)

//SHROUD OF NIGHT
/datum/discipline_power/obtenebration/shroud_of_night
	name = "Shroud of Night"
	desc = "Turn the shadows into appendages to pull your enemies."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_LYING | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB
	range = 7

	aggravating = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS

/datum/discipline_power/obtenebration/shroud_of_night/activate(mob/living/target)
	. = ..()
	target.Stun(1 SECONDS)
	var/obj/item/ammo_casing/magic/tentacle/lasombra/casing = new (owner.loc)
	casing.fire_casing(target, owner, null, null, null, ran_zone(), 0,  owner)

//ARMS OF THE ABYSS
/datum/discipline_power/obtenebration/arms_of_the_abyss
	name = "Arms of the Abyss"
	desc = "Use shadows as your arms to harm and grab others from afar."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 30 SECONDS
	cooldown_length = 15 SECONDS

/datum/discipline_power/obtenebration/arms_of_the_abyss/activate()
	. = ..()
	owner.drop_all_held_items()
	owner.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel/lasombra(owner))
	owner.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel/lasombra(owner))

/datum/discipline_power/obtenebration/arms_of_the_abyss/deactivate()
	. = ..()
	for(var/obj/item/melee/vampirearms/knife/gangrel/lasombra/arm in owner.contents)
		qdel(arm)

//BLACK METAMORPHOSIS
/datum/discipline_power/obtenebration/black_metamorphosis
	name = "Black Metamorphosis"
	desc = "Fuse with your inner darkness, gaining shadowy armor."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	vitae_cost = 2

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 15 SECONDS
	cooldown_length = 10 SECONDS

/datum/discipline_power/obtenebration/black_metamorphosis/activate()
	. = ..()
	owner.physiology.damage_resistance += 60
	animate(owner, color = "#000000", time = 1 SECONDS, loop = 1)

/datum/discipline_power/obtenebration/black_metamorphosis/deactivate()
	. = ..()
	playsound(owner.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	owner.physiology.damage_resistance -= 60
	animate(owner, color = initial(owner.color), time = 1 SECONDS, loop = 1)

//TENEBROUS FORM
/datum/discipline_power/obtenebration/tenebrous_form
	name = "Tenebrous Form"
	desc = "Become a shadow and move without your physical form."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING

	violates_masquerade = TRUE

	cooldown_length = 20 SECONDS

	var/obj/effect/proc_holder/spell/targeted/shadowwalk/tenebrous_form_spell

/datum/discipline_power/obtenebration/tenebrous_form/activate()
	. = ..()
	if (!tenebrous_form_spell)
		tenebrous_form_spell = new

	tenebrous_form_spell.cast(user = owner)

/datum/discipline_power/obtenebration/tenebrous_form/post_gain()
	. = ..()
	var/datum/action/mysticism/mystic = new()
	owner.mysticism_knowledge = TRUE
	mystic.Grant(owner)
	mystic.level = level
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/mystome)

/datum/crafting_recipe/mystome
	name = "Abyss Mysticism Tome"
	time = 10 SECONDS
	reqs = list(/obj/item/paper = 3, /obj/item/drinkable_bloodpack = 1)
	result = /obj/item/mystic_tome
	always_available = FALSE
	category = CAT_MISC

/datum/action/mysticism
	name = "Mysticism"
	desc = "Abyss Mysticism rune drawing."
	button_icon_state = "thaumaturgy"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/drawing = FALSE
	var/level = 1

/datum/action/mysticism/Trigger()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 2)
		to_chat(H, span_warning("You need more <b>BLOOD</b> to do that!"))
		return
	if(drawing)
		return

	if(istype(H.get_active_held_item(), /obj/item/mystic_tome))
		var/list/shit = list()
		for(var/i in subtypesof(/obj/abyssrune))
			var/obj/abyssrune/R = new i(owner)
			if(R.mystlevel <= level)
				shit += i
			qdel(R)
		var/ritual = input(owner, "Choose rune to draw:", "Mysticism") as null|anything in shit
		if(ritual)
			drawing = TRUE
			if(do_after(H, 3 SECONDS * max(1, 5 - H.mentality), H))
				drawing = FALSE
				new ritual(H.loc)
				H.bloodpool = max(H.bloodpool - 2, 0)
				if(H.CheckEyewitness(H, H, 7, FALSE))
					H.AdjustMasquerade(-1)
			else
				drawing = FALSE
	else
		var/list/shit = list()
		for(var/i in subtypesof(/obj/abyssrune))
			var/obj/abyssrune/R = new i(owner)
			if(R.mystlevel <= level)
				shit += i
			qdel(R)
		var/ritual = input(owner, "Choose rune to draw (You need a Mystic Tome to reduce random):", "Mysticism") as null|anything in list("???")
		if(ritual)
			drawing = TRUE
			if(do_after(H, 30*max(1, 5-H.mentality), H))
				drawing = FALSE
				var/rune = pick(shit)
				new rune(H.loc)
				H.bloodpool = max(H.bloodpool - 2, 0)
				if(H.CheckEyewitness(H, H, 7, FALSE))
					H.AdjustMasquerade(-1)
			else
				drawing = FALSE
