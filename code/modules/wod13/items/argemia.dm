/obj/item/argemia
	name = "strange plushie"
	desc = "Voiding..."
	icon_state = "argemia"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/argemia/microwave_act(obj/machinery/microwave/M)
	playsound(M.loc, 'code/modules/wod13/sounds/aeaeae.ogg', 100, FALSE)
	spawn(50)
		explosion(M.loc, 0, 1, 2)