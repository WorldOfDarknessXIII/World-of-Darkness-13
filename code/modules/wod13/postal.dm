/obj/lettermachine
	name = "letter machine"
	desc = "Work as letterman! Find a job!"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "mail"
	density = TRUE
	anchored = TRUE
	plane = GAME_PLANE
	layer = CAR_LAYER
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/money = 0

/obj/lettermachine/attack_hand(mob/living/user)
	if(money >= 10)
		new /obj/item/letter(loc)
		say("New letter delivered!")
		money = max(0, money-10)
	else
		say("Not enough money on [src] balance!")
	..()

/obj/lettermachine/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/dollar))
		var/obj/item/stack/dollar/D = I
		money = money+D.amount
		say("[D] inserted!")
		qdel(D)
	if(istype(I, /obj/item/mark))
		new /obj/item/stack/dollar/ten(loc)
		new /obj/item/stack/dollar/ten(loc)
		new /obj/item/stack/dollar/ten(loc)
		say("[I] delivered!")
		qdel(I)
	return

/obj/lettermachine/examine(mob/user)
	. = ..()
	. += "[src] contains <b>[money] dollars</b>."

/obj/item/letter
	name = "letter"
	icon_state = "letter"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/mob/living/carbon/human/Targ

/obj/item/mark
	name = "letter mark"
	icon_state = "mark"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_TINY

/obj/item/letter/Initialize()
	. = ..()
	var/list/mail_recipients = list()
	for(var/mob/living/carbon/human/alive in GLOB.player_list)
		if(alive.stat != DEAD)
			mail_recipients += alive
	if(length(mail_recipients))
		Targ = pick(mail_recipients)
		name = "letter ([Targ])"

/obj/item/letter/examine(mob/user)
	. = ..()
	. += "This letter is adressed to <b>[Targ]</b>"

/obj/item/letter/attack_self(mob/user)
	. = ..()
	if(user == Targ)
		playsound(loc, 'sound/items/poster_ripped.ogg', 50, TRUE)
		var/IT = pick(/obj/item/storage/pill_bottle/estrogen,
						/obj/item/storage/pill_bottle/antibirth,
						/obj/item/storage/pill_bottle/ephedrine,
						/obj/item/storage/pill_bottle/potassiodide,
						/obj/item/vampire_stake,
						/obj/item/stack/dollar/rand,
						/obj/item/melee/vampirearms/knife,
						/obj/item/melee/vampirearms/tire,
						/obj/item/gun/ballistic/vampire/revolver,
						/obj/item/vamp/keys/hack)
		new IT(user.loc)
		new /obj/item/mark(user.loc)
		qdel(src)

/obj/item/storage/pill_bottle/estrogen
	name = "estrogen pill bottle"
	desc = "There are boobs on the top."

/obj/item/storage/pill_bottle/estrogen/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/epinephrine(src)

/obj/item/storage/pill_bottle/ephedrine
	name = "ephedrine pill bottle"
	desc = "There is opium attention sign on the top."

/obj/item/storage/pill_bottle/ephedrine/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/pill/ephedrine(src)

/obj/item/reagent_containers/pill/ephedrine
	name = "ephedrine pill"
	desc = "Used to stabilize patients."
	icon_state = "pill5"
	list_reagents = list(/datum/reagent/medicine/ephedrine = 15)
	rename_with_volume = TRUE

/obj/item/storage/pill_bottle/antibirth
	name = "antibirth pill bottle"
	desc = "There is crossed sex icon on the top."

/obj/item/storage/pill_bottle/antibirth/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/iron(src)
