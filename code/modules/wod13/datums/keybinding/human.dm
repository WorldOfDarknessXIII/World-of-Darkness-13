/datum/keybinding/human/bite
	hotkey_keys = list("F")
	name = "bite"
	full_name = "Bite"
	description = "Bite whoever you're aggressively grabbing, and feed on them if possible."
	keybind_signal = COMSIG_KB_HUMAN_BITE_DOWN

/datum/keybinding/human/bite/down(client/user)
	. = ..()
	if(.)
		return
	//the code below is directly imported from onyxcombat.dm's /atom/movable/screen/drinkblood/Click() proc
	//turning all of this into one centralised proc would be preferable, but it requires more effort than I'm willing to put in right now
	if(ishuman(user.mob))
		var/mob/living/carbon/human/BD = user.mob
		BD.update_blood_hud()
		if(world.time < BD.last_drinkblood_use+30)
			return
		if(world.time < BD.last_drinkblood_click+10)
			return
		BD.last_drinkblood_click = world.time
//		if(BD.bloodpool >= BD.maxbloodpool)
//			SEND_SOUND(BD, sound('code/modules/wod13/need_blood.ogg'))
//			to_chat(BD, "<span class='warning'>You're full of <b>BLOOD</b>.</span>")
//			return
		if(BD.grab_state > GRAB_PASSIVE)
			if(ishuman(BD.pulling))
				var/mob/living/carbon/human/PB = BD.pulling
				if(is_ghoul(BD))
					if(!is_kindred(PB))
						SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
						to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
						return
				if(!is_ghoul(BD) && !is_kindred(BD) && !is_kuei_jin(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
					return
				if(PB.stat == DEAD && !HAS_TRAIT(BD, TRAIT_GULLET) && !is_kuei_jin(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>This creature is <b>DEAD</b>.</span>")
					return
				if(PB.bloodpool <= 0 && (!is_kindred(PB) || !is_kindred(BD)))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>There is no <b>BLOOD</b> in this creature.</span>")
					return
				if(BD.clan)
					var/special_clan = FALSE
					if(BD.clan.name == "Salubri")
						if(!PB.IsSleeping() && PB.stat != DEAD)
							to_chat(BD, "<span class='warning'>You can't drink from aware targets!</span>")
							return
						special_clan = TRUE
						PB.emote("moan")
					if(BD.clan.name == "Giovanni")
						PB.emote("scream")
						special_clan = TRUE
					if(!special_clan)
						PB.emote("groan")
				PB.add_bite_animation()
			if(isliving(BD.pulling))
				if(!is_kindred(BD) && !is_kuei_jin(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
					return
				var/mob/living/LV = BD.pulling
				if(LV.bloodpool <= 0 && (!is_kindred(LV) || !is_kindred(BD)))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>There is no <b>BLOOD</b> in this creature.</span>")
					return
				if(LV.stat == DEAD && !HAS_TRAIT(BD, TRAIT_GULLET) && !is_kuei_jin(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>This creature is <b>DEAD</b>.</span>")
					return
				var/skipface = (BD.wear_mask && (BD.wear_mask.flags_inv & HIDEFACE)) || (BD.head && (BD.head.flags_inv & HIDEFACE))
				if(!skipface)
					if(!HAS_TRAIT(BD, TRAIT_BLOODY_LOVER))
						playsound(BD, 'code/modules/wod13/sounds/drinkblood1.ogg', 50, TRUE)
						LV.visible_message("<span class='warning'><b>[BD] bites [LV]'s neck!</b></span>", "<span class='warning'><b>[BD] bites your neck!</b></span>")
					if(!HAS_TRAIT(BD, TRAIT_BLOODY_LOVER))
						if(BD.CheckEyewitness(LV, BD, 7, FALSE))
							BD.AdjustMasquerade(-1)
					else
						playsound(BD, 'code/modules/wod13/sounds/kiss.ogg', 50, TRUE)
						LV.visible_message("<span class='italics'><b>[BD] kisses [LV]!</b></span>", "<span class='userlove'><b>[BD] kisses you!</b></span>")
					if(is_kindred(LV))
						var/mob/living/carbon/human/HV = BD.pulling
						if(HV.stakeimmune)
							to_chat(BD, "<span class='warning'>There is no <b>HEART</b> in this creature.</span>")
							return
					BD.drinksomeblood(LV)
	return TRUE
