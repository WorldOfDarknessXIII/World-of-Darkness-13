// The item currently handling the modification of the signature system, see postal.dm and signature_system.dm
/obj/item/passport
	name = "\improper fake passport"
	desc = "Just some book with words, none of real identity here.<br>Use it in hand to add or remove eligible document signers."
	icon = 'code/modules/wod13/items.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	icon_state = "passport1"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_ID
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	var/closed = TRUE

/obj/item/passport/attack_self(mob/user)
	. = ..()
	var/option =  input(usr, "Select an option:", "Passport Options") as null|anything in list("Open/Close","Add Eligible Signer", "Remove Eligible Signer")
	switch(option)
		if("Open/Close")
			if(closed)
				icon_state = "passport0"
			else
				icon_state = "passport1"
			to_chat(user, "<span class='notice'>You [closed ? "close" : "open"] [src].</span>")
			closed = !closed
			return
		// Adding people who can sign your documents, handled by /datum/component/signature_system
		if("Add Eligible Signer")
			var/datum/component/signature_system/signature_system = user.GetComponent(/datum/component/signature_system)
			// Our mob does not have this component
			if(!signature_system)
				return
			// Get all human mobs except for the user
			var/list/eligible_signers_minus_owner = list()
			for(var/mob/living/carbon/human/human in GLOB.player_list)
				eligible_signers_minus_owner += human
			eligible_signers_minus_owner.Remove(user)
			var/choice =  input(user,"Choose a person who will also be able to sign your documents. This will allow them to sign your mail and open them, too.","Add Eligible Signer") as null|anything in sortList(eligible_signers_minus_owner)
			if(choice)
				// Try to add the new name to the list
				. = signature_system.add_signer(choice)
				if(!.)
					to_chat(user, "This person is already an eligible signer!")
					return
				to_chat(user, "You have added [choice] to your eligible signers. This will allow them to sign your mail and open them, too.")
		if("Remove Eligible Signer")
			var/datum/component/signature_system/signature_system = user.GetComponent(/datum/component/signature_system)
			// Our mob does not have this component
			if(!signature_system)
				return
			var/list/eligible_signers_minus_owner = sortList(signature_system.eligible_signers)
			// You cannot remove yourself, silly
			eligible_signers_minus_owner.Remove(user)
			if(length(eligible_signers_minus_owner))
				var/choice = input(user,"Choose a person to be removed from your eligible signers. They will no longer be able to sign your mail or open them.","Remove Eligible Signer") as null|anything in sortList(eligible_signers_minus_owner)
				if(choice)
					. = signature_system.remove_signer(choice)
					// This person is no longer in the list, silent failure here as this only should happen if you spam this option or due to admin VVing
					if(!.)
						return
					to_chat(user, "You have removed [choice] from your eligible signers. They will no longer be able to sign your mail or open them.")

