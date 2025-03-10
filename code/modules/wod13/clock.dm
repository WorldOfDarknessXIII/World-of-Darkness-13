/obj/item/cockclock
	name = "\improper wrist watch"
	desc = "A portable device to check time."
	icon = 'code/modules/wod13/clock.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	icon_state = "watch"
	worn_icon_state = "watch"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	slot_flags = ITEM_SLOT_GLOVES | ITEM_SLOT_ID
	onflooricon = 'code/modules/wod13/onfloor.dmi'

/obj/item/cockclock/Initialize()
	. = ..()
	AddComponent(/datum/component/selling, 50, "watch", FALSE)

/obj/item/cockclock/examine(mob/user)
	. = ..()
	to_chat(user, "<b>[SScity_time.timeofnight]</b>")

/obj/item/passport
	name = "\improper fake passport"
	desc = "Just some book with words, none of real identity here."
	icon = 'code/modules/wod13/items.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	icon_state = "passport1"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_ID
	onflooricon = 'code/modules/wod13/onfloor.dmi'

	var/clozed = TRUE

/obj/item/passport/attack_self(mob/user)
	. = ..()
	if(clozed)
		clozed = FALSE
		icon_state = "passport0"
		to_chat(user, "<span class='notice'>You open [src].</span>")
	else
		clozed = TRUE
		icon_state = "passport1"
		to_chat(user, "<span class='notice'>You close [src].</span>")
