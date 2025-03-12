// WoD13 component
// Items with this component can be sold and will also dictate how much humanity is gained or lost from it.
// Does not cover individual item costs, it can be changed to allow for that but one would have to go through many items to individually add the selling component.

/datum/component/selling
	///Sale price of the item
	var/cost
	///Items of the same category will be mass-sold when click-dragging them
	var/object_category
	///Dictates whether the item can be sold at a pawn shop or black market
	var/illegal
	///Will affect humanity by a specific value when sold, most often with a negative value (such as -1).
	var/humanity_loss
	///Down to what point humanity can be reduced when selling the item.
	var/humanity_loss_limit

/datum/component/selling/Initialize(new_cost, new_object_category, new_illegal, new_humanity_loss, new_humanity_loss_limit)
	if(!isobj(parent)) //Only items can be sold
		return COMPONENT_INCOMPATIBLE
	cost = new_cost
	object_category = new_object_category
	illegal = new_illegal
	humanity_loss = new_humanity_loss
	humanity_loss_limit = new_humanity_loss_limit

//Whether it can be sold
/datum/component/selling/proc/can_sell()
	return TRUE

//Will display a message if it has been sold successfully
/datum/component/selling/proc/sale_success_message()
	return

//Will display a message if it hasn't been sold successfully (such as failing can_sell())
/datum/component/selling/proc/sale_fail_message()
	return

/datum/component/selling/organ/Initialize(new_cost, new_object_category, new_illegal, new_humanity_loss, new_humanity_loss_limit)
	if(!istype(parent, /obj/item/organ))
		return COMPONENT_INCOMPATIBLE
	..()

/datum/component/selling/organ/can_sell()
	var/obj/item/organ/organ = parent
	if(organ.damage > round(organ.maxHealth / 2))
		return FALSE
	return TRUE

/datum/component/selling/organ/sale_success_message()
	return span_userdanger("Selling organs is a depraved act! If I keep doing this I will become a wight.")

/datum/component/selling/organ/sale_fail_message()
	return span_warning("[src] is too damaged to sell!")
