/obj/item/blood_hunt
	name = "Blood Hunt Announcer"
	desc = "Announce a Blood Hunt to the city."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "eye"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/blood_hunt/attack_self(mob/user)
	. = ..()
	var/chosen_name = input(user, "Write the hunted or forgiven character name:", "Blood Hunt")  as text|null
	if(chosen_name)
		chosen_name = sanitize_name(chosen_name)
		var/reason = input(user, "Write the reason of the Blood Hunt:", "Blood Hunt Reason")  as text|null
		if(reason)
			reason = sanitize(reason)
		else
			reason = "No reason necessary."
		var/name_in_list = FALSE
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H)
				if(H.true_real_name == chosen_name)
					if(H in SSbloodhunt.hunted)
						if(HAS_TRAIT(src, TRAIT_HUNTED))
							to_chat(user, "<span class='warning'>You can't remove [chosen_name] from the list!</span>")
							return
						SSbloodhunt.hunted -= H
						H.bloodhunted = FALSE
						SSbloodhunt.update_shit()
						to_chat(user, "<span class='warning'>You remove [chosen_name] from the Hunted list.</span>")
						for(var/mob/living/carbon/human/R in GLOB.player_list)
							if(R && iskindred(R) && R.client)
								to_chat(R, "<b>The Blood Hunt after <span class='green'>[H.true_real_name]</span> is over!</b>")
								SEND_SOUND(R, sound('code/modules/wod13/sounds/announce.ogg'))
					else
						SSbloodhunt.announce_hunted(H, reason)
						to_chat(user, "<span class='warning'>You add [chosen_name] to the Hunted list.</span>")
					name_in_list = TRUE
		if(!name_in_list)
			to_chat(user, "<span class='warning'>There is no such name in the city!</span>")
