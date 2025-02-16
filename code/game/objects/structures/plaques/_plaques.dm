/obj/structure/plaque //This is a plaque you can craft with gold, then permanently engrave a title and description on, with a fountain pen.
	icon = 'icons/obj/decals.dmi'
	icon_state = "blankplaque"
	name = "blank plaque"
	desc = "A blank plaque, use a fancy pen to engrave it. It can be detatched from the wall with a wrench."
	anchored = TRUE
	opacity = FALSE
	density = FALSE
	layer = SIGN_LAYER
	max_integrity = 200 //Twice as durable as regular signs.
	armor = list(MELEE = 50, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	flags_1 = RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1
	///Custom plaque structures and items both start "unengraved", once engraved with a fountain pen their text can't be altered again. Static plaques are already engraved.
	var/engraved = FALSE

/obj/item/plaque //The item version of the above.
	icon = 'icons/obj/decals.dmi'
	icon_state = "blankplaque"
	inhand_icon_state = "blankplaque"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	name = "blank plaque"
	desc = "A blank plaque, use a fancy pen to engrave it. It can be placed on a wall."
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 200
	armor = list(MELEE = 50, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	///This points the item to make the proper structure when placed on a wall.
	var/plaque_path = /obj/structure/plaque
	///Custom plaque structures and items both start "unengraved", once engraved with a fountain pen their text can't be altered again.
	var/engraved = FALSE

/obj/structure/plaque/attack_hand(mob/user)
	. = ..()
	if(. || user.is_blind())
		return
	user.examinate(src)

/obj/structure/plaque/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pen/fountain))
		if(engraved)
			to_chat(user, "<span class='warning'>This plaque has already been engraved.</span>")
			return
		var/namechoice = input(user, "Title this plaque. (e.g. 'Best HoP Award', 'Great Ashwalker War Memorial')", "Plaque Customization")
		if(!namechoice)
			return
		var/descriptionchoice = input(user, "Engrave this plaque's text.", "Plaque Customization")
		if(!descriptionchoice)
			return
		if(!Adjacent(user)) //Make sure user is adjacent still
			to_chat(user, "<span class='warning'>You need to stand next to the plaque to engrave it!</span>")
			return
		user.visible_message("<span class='notice'>[user] begins engraving [src].</span>", \
			"<span class='notice'>You begin engraving [src].</span>")
		if(!do_after(user, 4 SECONDS, target = src)) //This spits out a visible message that somebody is engraving a plaque, then has a delay.
			return
		name = "\improper [namechoice]" //We want improper here so examine doesn't get weird if somebody capitalizes the plaque title.
		desc = "The plaque reads: '[descriptionchoice]'"
		engraved = TRUE //The plaque now has a name, description, and can't be altered again.
		user.visible_message("<span class='notice'>[user] engraves [src].</span>", \
			"<span class='notice'>You engrave [src].</span>")
		return
	if(istype(I, /obj/item/pen))
		if(engraved)
			to_chat(user, "<span class='warning'>This plaque has already been engraved, and your pen isn't fancy enough to engrave it anyway! Find a fountain pen.</span>")
			return
		to_chat(user, "<span class='warning'>Your pen isn't fancy enough to engrave this! Find a fountain pen.</span>") //Go steal the Curator's.
		return
	return ..()

/obj/item/plaque/attackby(obj/item/I, mob/user, params) //Same as part of the above, except for the item in hand instead of the structure.
	if(istype(I, /obj/item/pen/fountain))
		if(engraved)
			to_chat(user, "<span class='warning'>This plaque has already been engraved.</span>")
			return
		var/namechoice = input(user, "Title this plaque. (e.g. 'Best HoP Award', 'Great Ashwalker War Memorial')", "Plaque Customization")
		if(!namechoice)
			return
		var/descriptionchoice = input(user, "Engrave this plaque's text.", "Plaque Customization")
		if(!descriptionchoice)
			return
		if(!Adjacent(user)) //Make sure user is adjacent still
			to_chat(user, "<span class='warning'>You need to stand next to the plaque to engrave it!</span>")
			return
		user.visible_message("<span class='notice'>[user] begins engraving [src].</span>", \
			"<span class='notice'>You begin engraving [src].</span>")
		if(!do_after(user, 40, target = src)) //This spits out a visible message that somebody is engraving a plaque, then has a delay.
			return
		name = "\improper [namechoice]" //We want improper here so examine doesn't get weird if somebody capitalizes the plaque title.
		desc = "The plaque reads: '[descriptionchoice]'"
		engraved = TRUE //The plaque now has a name, description, and can't be altered again.
		user.visible_message("<span class='notice'>[user] engraves [src].</span>", \
			"<span class='notice'>You engrave [src].</span>")
		return
	if(istype(I, /obj/item/pen))
		if(engraved)
			to_chat(user, "<span class='warning'>This plaque has already been engraved, and your pen isn't fancy enough to engrave it anyway! Find a fountain pen.</span>")
			return
		to_chat(user, "<span class='warning'>Your pen isn't fancy enough to engrave this! Find a fountain pen.</span>") //Go steal the Curator's.
		return
	return ..()

/obj/item/plaque/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!iswallturf(target) || !proximity)
		return
	var/turf/target_turf = target
	var/turf/user_turf = get_turf(user)
	var/obj/structure/plaque/placed_plaque = new plaque_path(user_turf) //We place the plaque on the turf the user is standing, and pixel shift it to the target wall, as below.
	//This is to mimic how signs and other wall objects are usually placed by mappers, and so they're only visible from one side of a wall.
	var/dir = get_dir(user_turf, target_turf)
	if(dir & NORTH)
		placed_plaque.pixel_y = 32
	else if(dir & SOUTH)
		placed_plaque.pixel_y = -32
	if(dir & EAST)
		placed_plaque.pixel_x = 32
	else if(dir & WEST)
		placed_plaque.pixel_x = -32
	user.visible_message("<span class='notice'>[user] fastens [src] to [target_turf].</span>", \
		"<span class='notice'>You attach [src] to [target_turf].</span>")
	playsound(target_turf, 'sound/items/deconstruct.ogg', 50, TRUE)
	if(engraved)
		placed_plaque.name = name
		placed_plaque.desc = desc
		placed_plaque.engraved = engraved
	placed_plaque.icon_state = icon_state
	placed_plaque.obj_integrity = obj_integrity
	placed_plaque.setDir(dir)
	qdel(src)
