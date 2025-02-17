/obj/item/quran
	name = "quran"
	desc = "Inshallah..."
	icon_state = "quran"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/quran/attack(mob/living/target, mob/living/user)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/pathof = "Humanity"
		if(H.clane)
			if(H.clane.enlightenment)
				pathof = "Enlightenment"
		to_chat(user, "<b>[pathof]: [H.humanity]</b>")
