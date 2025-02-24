// ==============================
// Counterfeit P25 Radio & Subtypes
// ==============================

/obj/item/clothing/ears/fake_p25radio
	name = "P25 radio"
	desc = "A rugged, high-performance two-way radio designed for secure, clear communication in demanding environments, featuring a durable shoulder microphone for hands-free operation. Use .r to transmit through the radio and alt-click to toggle radio receiving."
	icon = 'icons/obj/radio.dmi'
	icon_state = "p25"
	w_class = WEIGHT_CLASS_SMALL
	worn_icon = "blank" // needed so that weird pink default thing doesn't show up
	worn_icon_state = "blank" // needed so that weird pink default thing doesn't show up

/obj/item/clothing/ears/fake_p25radio/examine_more(mob/user)
	. = list(span_notice("On closer examination, it becomes evident this radio is counterfeit. It is entirely nonfunctional."))

/obj/item/clothing/ears/fake_p25radio/police
	name = "P25 police radio"
	desc = "A police-issue high-performance two-way radio designed for secure, clear communication in demanding environments, featuring a durable shoulder microphone for hands-free operation. Use .r to transmit and alt-click to toggle receiving, dispatch monitoring, or press your panic button."

/obj/item/clothing/ears/fake_p25radio/police/government
	name = "P25 government radio"
