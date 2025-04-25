/obj/item/window_repair_kit
	name = "window repair kit"
	desc = "A panel and all the supplies needed to replace a broken window. Comes in a set of ten for all your replacement needs."
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "sheet-plastitaniumglass_3"
	var/uses_left = 10
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/window_repair_kit/proc/process_use(use_ammount)
	uses_left -= use_ammount
	if(uses_left > 7) icon_state = "sheet-plastitaniumglass_3"
	if(uses_left < 7 && uses_left > 4) icon_state ="sheet-plastitaniumglass_2"
	if(uses_left < 4) icon_state = "sheet-plastitaniumglass"
	update_icon()
	return

/obj/item/window_repair_kit/proc/uses_check(use_ammount)
	if(!use_ammount) return
	if(uses_left < use_ammount)
		return 0
	else
		return 1
