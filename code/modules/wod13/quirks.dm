/*
Experienced Driver
Bone Key
Anonymous
Bloody Lover
Tough Flesh
Slowpoke
\"Blood\" Sucker
One Handed
Non Intellectual
Coffin Therapy
Not Crossing the Rubicon
Hungry
Fenix
Dwarf
Homosexual
Dancer
*/
/datum/quirk/broker
	name = "Broker"
	desc = "You are working on stock market in Millenium Tower."
	value = 0
	gain_text = "<span class='notice'>You feel more financial stable.</span>"
	lose_text = "<span class='warning'>You don't feel rich anymore.</span>"

/datum/quirk/broker/on_spawn()
	if(!iswerewolf(quirk_holder))
		var/mob/living/carbon/human/H = quirk_holder
		var/obj/item/stocks_license/pills = new()
		pills.whose = H.real_name
		pills.name = "[H.real_name]'s stocks trading license"
		var/list/slots = list(
			LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
			LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
			LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
			LOCATION_HANDS = ITEM_SLOT_HANDS
		)
		H.equip_in_one_of_slots(pills, slots, FALSE)

/datum/quirk/experienced_driver
	name = "Experienced Driver"
	desc = "Driving, repairing and sustaining a car is much easier to you."
	mob_trait = TRAIT_EXP_DRIVER
	value = 2
	gain_text = "<span class='notice'>You feel more experienced about cars.</span>"
	lose_text = "<span class='warning'>You feel more clueless about cars.</span>"

/datum/quirk/annonymus
	name = "Anonymous"
	desc = "You always bring a mask."
	value = 1
	gain_text = "<span class='notice'>You feel more anonymus.</span>"
	lose_text = "<span class='warning'>You don't feel anonymous anymore.</span>"

/datum/quirk/annonymus/on_spawn()
	if(!iswerewolf(quirk_holder))
		var/mob/living/carbon/human/H = quirk_holder
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/vampire/balaclava(H), ITEM_SLOT_MASK)

/datum/quirk/bloody_lover
	name = "Bloody Lover"
	desc = "Your bites feel more like a kiss."
	mob_trait = TRAIT_BLOODY_LOVER
	value = 2
	gain_text = "<span class='notice'>You feel more experienced in love.</span>"
	lose_text = "<span class='warning'>You feel more clueless in love.</span>"
	allowed_species = list("Vampire", "Kuei-Jin")

/datum/quirk/tough_flesh
	name = "Tough Flesh"
	desc = "Your flesh is much sturdier than normal. You are much better in resisting stuns, bumps and hits."
	mob_trait = TRAIT_TOUGH_FLESH
	value = 3
	gain_text = "<span class='notice'>You feel tough.</span>"
	lose_text = "<span class='warning'>You feel fragile again.</span>"

/datum/movespeed_modifier/slowpoke
	multiplicative_slowdown = 1

/datum/quirk/slowpoke
	name = "Slowpoke"
	desc = "You move slower."
	value = -3
	gain_text = "<span class='warning'>You feel slo-o-o-o-o-o-o-o-o-o-o-o-ow.</span>"
	lose_text = "<span class='notice'>You can feel a normal speed again.</span>"

/datum/quirk/slowpoke/on_spawn()
	var/mob/living/carbon/H = quirk_holder
	H.add_movespeed_modifier(/datum/movespeed_modifier/slowpoke)

/datum/quirk/bloody_sucker
	name = "Addicted"
	desc = "You just can't stop sucking, before your victim dies."
	mob_trait = TRAIT_BLOODY_SUCKER
	value = -2
	gain_text = "<span class='warning'>You feel anxious about the way you feed.</span>"
	lose_text = "<span class='warning'>You can feed normal again.</span>"
	allowed_species = list("Vampire", "Kuei-Jin")

/datum/quirk/lazy
	name = "Lazy"
	desc = "You do things much more slowly than others."
	mob_trait = TRAIT_LAZY
	value = -2
	gain_text = "<span class='warning'>You feel anxious about the way you feed.</span>"
	lose_text = "<span class='warning'>You can feed normal again.</span>"

/datum/quirk/one_hand
	name = "One Handed"
	desc = "You've lost an arm before the embrace, and it's still unhealed."
	value = -3
	gain_text = "<span class='warning'>You don't feel one of your arms.</span>"
	lose_text = "<span class='notice'>You feel both of your arms again.</span>"

/datum/quirk/one_hand/on_spawn()
	if(!iswerewolf(quirk_holder))
		var/mob/living/carbon/human/H = quirk_holder
		var/obj/item/bodypart/B1 = H.get_bodypart(BODY_ZONE_R_ARM)
		var/obj/item/bodypart/B2 = H.get_bodypart(BODY_ZONE_L_ARM)
		if(prob(50))
			B1.drop_limb()
			qdel(B1)
		else
			B2.drop_limb()
			qdel(B2)

/datum/quirk/non_int
	name = "Non Intellectual"
	desc = "You are far more special than other beings from your kind, so you gain experience slower."
	mob_trait = TRAIT_NON_INT
	value = -5
	gain_text = "<span class='warning'>You feel dumb.</span>"
	lose_text = "<span class='notice'>You don't feel dumb anymore.</span>"
	allowed_species = list("Vampire", "Human", "Ghoul", "Kuei-Jin")

/datum/quirk/coffin_therapy
	name = "Coffin Therapy"
	desc = "Your wounds heal only in a coffin."
	mob_trait = TRAIT_COFFIN_THERAPY
	value = -2
	gain_text = "<span class='warning'>You feel like you need a coffin.</span>"
	lose_text = "<span class='notice'>You don't need a coffin anymore.</span>"
	allowed_species = list("Vampire", "Ghoul")

/datum/quirk/rubicon
	name = "Crossing the Rubicon"
	desc = "You are afraid of water, so you can't cross it."
	mob_trait = TRAIT_RUBICON
	value = -1
	gain_text = "<span class='warning'>You feel afraid of water.</span>"
	lose_text = "<span class='notice'>You aren't afraid of water anymore.</span>"
	allowed_species = list("Vampire", "Ghoul")

/datum/quirk/hungry
	name = "Hungry"
	desc = "You need more food to feed your hunger."
	mob_trait = TRAIT_HUNGRY
	value = -3
	gain_text = "<span class='warning'>You feel extra <b>HUNGRY</b>.</span>"
	lose_text = "<span class='notice'>You don't feel extra <b>HUNGRY</b> anymore.</span>"
	allowed_species = list("Vampire", "Ghoul")

/datum/action/fly_upper
	name = "Fly Up"
	desc = "Fly to the upper level."
	button_icon_state = "fly"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/last_acrobate = 0

/datum/action/fly_upper/Trigger()
	owner.up()

/datum/quirk/dancer
	name = "Dancer"
	desc = "You know a couple of dance moves."
	value = 2
	gain_text = "<span class='notice'>You want to dance.</span>"
	lose_text = "<span class='warning'>You don't want to dance anymore.</span>"

/datum/quirk/dancer/on_spawn()
	var/mob/living/carbon/H = quirk_holder
	var/datum/action/dance/DA = new()
	DA.Grant(H)

/datum/action/dance
	name = "Dance"
	desc = "Dance from dusck till dawn!"
	button_icon_state = "dance"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/last_added_humanity = 0

/datum/action/dance/Trigger()
	if(HAS_TRAIT(owner, TRAIT_INCAPACITATED))
		to_chat(owner, "<span class='warning'>You're a little too close to being dead to get down!</span>")
		return

	if(HAS_TRAIT(owner, TRAIT_FLOORED))
		to_chat(owner, "<span class='warning'>You got to get up before you get down!</span>")
		return
//	var/mob/living/carbon/H = owner
	if(prob(50))
		dancefirst(owner)
	else
		dancesecond(owner)

	if(last_added_humanity+6000 < world.time)
		for(var/obj/machinery/jukebox/J in range(7, owner))
			if(J)
				if(J.active)
					if(ishuman(owner))
						var/mob/living/carbon/human/human = owner
						human.AdjustHumanity(1, 8)
						last_added_humanity = world.time

/datum/quirk/dwarf
	name = "Dwarf"
	desc = "You are short."
	value = 0
	gain_text = "<span class='notice'>You feel short.</span>"
	lose_text = "<span class='notice'>You don't feel short anymore.</span>"

/datum/quirk/dwarf/add()
	if(iswerewolf(quirk_holder))
		return
	quirk_holder.AddElement(/datum/element/dwarfism, COMSIG_PARENT_PREQDELETED, src)

/datum/quirk/dwarf/remove()
	if (!quirk_holder)
		return
	quirk_holder.RemoveElement(/datum/element/dwarfism)

#define SHORT 4/5
#define TALL 5/4

///Very similar to squish, but for dwarves and shorties
/datum/element/dwarfism
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2
	var/comsig
	var/list/attached_targets = list()

/datum/element/dwarfism/Attach(datum/target, comsig, comsig_target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE

	src.comsig = comsig

	var/mob/living/carbon/human/L = target
	if(L.lying_angle != 0)
		L.transform = L.transform.Scale(SHORT, 1)
		L.transform = L.transform.Translate(L.lying_angle == 90 ? 16*(SHORT-1) : -(16*(SHORT-1)), 0) //Makes sure you stand on the tile no matter the size - sand
	else
		L.transform = L.transform.Scale(1, SHORT)
		L.transform = L.transform.Translate(0, 16*(SHORT-1)) //Makes sure you stand on the tile no matter the size - sand
	attached_targets[target] = comsig_target
	RegisterSignal(target, comsig, PROC_REF(check_loss)) //Second arg of the signal will be checked against the comsig_target.

/datum/element/dwarfism/proc/check_loss(mob/living/L, comsig_target)
	if(attached_targets[L] == comsig_target)
		Detach(L)

/datum/element/dwarfism/Detach(mob/living/L)
	. = ..()
	if(QDELETED(L))
		return
	if(L.lying_angle != 0)
		L.transform = L.transform.Scale(TALL, 1)
		L.transform = L.transform.Translate(L.lying_angle == 90 ? 16*(TALL-1) : -(16*(TALL-1)), 0) //Makes sure you stand on the tile no matter the size - sand
	else
		L.transform = L.transform.Scale(1, TALL)
		L.transform = L.transform.Translate(0, 16*(TALL-1)) //Makes sure you stand on the tile no matter the size - sand
	UnregisterSignal(L, comsig)
	attached_targets -= L

#undef SHORT
#undef TALL

/datum/quirk/homosexual
	name = "Homosexual"
	desc = "You love your gender more than the opposite."
	value = 0
	mob_trait = TRAIT_HOMOSEXUAL
	gain_text = "<span class='notice'>You feel gay.</span>"
	lose_text = "<span class='notice'>You don't feel gay anymore.</span>"

/datum/quirk/foreign
	name = "Foreigner"
	desc = "You don't know English language! If you don't know other languages - that means you don't know any."
	value = -3
	gain_text = "<span class='notice'>The words being spoken around you don't make any sense."
	lose_text = "<span class='notice'>You've developed fluency in English."
	medical_record_text = "Patient does not speak English and may require an interpreter."

/datum/quirk/foreign/add()
	var/mob/living/carbon/H = quirk_holder
	H.add_blocked_language(/datum/language/english)

/datum/quirk/foreign/remove()
	var/mob/living/carbon/H = quirk_holder
	H.remove_blocked_language(/datum/language/english)

/datum/quirk/espanol
	name = "Espanol"
	desc = "You know the Spanish language."
	value = 1

/datum/quirk/espanol/add()
	var/mob/living/carbon/H = quirk_holder
	H.grant_language(/datum/language/espanol)

/datum/quirk/chinese
	name = "Mandarin"
	desc = "You know Mandarin."
	value = 1

/datum/quirk/chinese/add()
	var/mob/living/carbon/H = quirk_holder
	H.grant_language(/datum/language/mandarin)

/datum/quirk/cantonese
	name = "Cantonese"
	desc = "You know Cantonese."
	value = 1

/datum/quirk/cantonese/add()
	var/mob/living/carbon/H = quirk_holder
	H.grant_language(/datum/language/cantonese)

/datum/quirk/russian
	name = "Russian"
	desc = "You know the Russian language."
	value = 1

/datum/quirk/russian/add()
	var/mob/living/carbon/H = quirk_holder
	H.grant_language(/datum/language/russian)

/datum/quirk/japanese
	name = "Japanese"
	desc = "You know the Japanese language."
	value = 1

/datum/quirk/japanese/add()
	var/mob/living/carbon/H = quirk_holder
	H.grant_language(/datum/language/japanese)

/datum/quirk/italian
	name = "Italian"
	desc = "You know the Italian language."
	value = 1

/datum/quirk/italian/add()
	var/mob/living/carbon/H = quirk_holder
	H.grant_language(/datum/language/italian)

/datum/quirk/german
	name = "German"
	desc = "You know the German language, FUR DAR FATERLAND!"
	value = 1

/datum/quirk/german/add()
	var/mob/living/carbon/H = quirk_holder
	H.grant_language(/datum/language/german)

/datum/quirk/latin
	name = "Latin"
	desc = "You know the ancient holy language OF THE ROMANS AND THE CLERGY!!"
	value = 2

/datum/quirk/latin/add()
	var/mob/living/carbon/H = quirk_holder
	H.grant_language(/datum/language/latin)

/datum/quirk/hebrew
	name = "Hebrew"
	desc = "You know the language of the ancient Hebrews!"
	value = 1

/datum/quirk/hebrew/add()
	var/mob/living/carbon/H = quirk_holder
	H.grant_language(/datum/language/hebrew)

/datum/quirk/french
	name = "French"
	desc = "You know the romantic language of the French."
	value = 1

/datum/quirk/french/add()
	var/mob/living/carbon/H = quirk_holder
	H.grant_language(/datum/language/french)

/datum/quirk/arabic
	name = "Arabic"
	desc = "You know the melodic language of the Middle East."
	value = 1

/datum/quirk/arabic/add()
	var/mob/living/carbon/H = quirk_holder
	H.grant_language(/datum/language/arabic)

/datum/quirk/greek
	name = "Greek"
	desc = "You know the romantic language of the Greeks."
	value = 1

/datum/quirk/greek/add()
	var/mob/living/carbon/H = quirk_holder
	H.grant_language(/datum/language/greek)


/datum/quirk/consumption
	name = "Consumption"
	desc = "Your blood is wrought with flesh eating bacteria that is literally eating you from inside out. You take some damage every random amount of time."
	value = -4
	gain_text = "<span class='danger'>You feel injured from inside.</span>"
	lose_text = "<span class='notice'>You feel healthy again.</span>"
	medical_record_text = "Patient has aggressive flesh eating bacteria in their boody."
	allowed_species = list("Vampire", "Ghoul", "Human", "Kuei-Jin")

/datum/quirk/consumption/on_process(delta_time)
	if(prob(5))
		quirk_holder.adjustBruteLoss(5, TRUE)

/datum/quirk/hunted
	name = "Sir You Are Being Hunted"
	desc = "You are in the Blood Hunt list from the start and can't leave it. Good luck!"
	value = -3
	mob_trait = TRAIT_HUNTED
	allowed_species = list("Vampire", "Ghoul")

/datum/quirk/hunted/on_spawn()
	if(iswerewolf(quirk_holder) || isgarou(quirk_holder))
		return
	if(isturf(quirk_holder.loc))
		SSbloodhunt.announce_hunted(quirk_holder, "Camarilla Wanted List")

/datum/quirk/badvision
	name = "Nearsighted"
	desc = "Your eye illness somehow did not become cured after the Embrace, and you need to wear perception glasses."
	value = -1
	gain_text = "<span class='danger'>Things far away from you start looking blurry.</span>"
	lose_text = "<span class='notice'>You start seeing faraway things normally again.</span>"
	medical_record_text = "Patient requires prescription glasses in order to counteract nearsightedness."

/datum/quirk/badvision/add()
	quirk_holder.become_nearsighted(ROUNDSTART_TRAIT)

/datum/quirk/badvision/on_spawn()
	if(iswerewolf(quirk_holder))
		return
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/glasses/vampire/perception/glasses = new(get_turf(H))
	if(!H.equip_to_slot_if_possible(glasses, ITEM_SLOT_EYES, bypass_equip_delay_self = TRUE))
		H.put_in_hands(glasses)

/datum/quirk/masquerade
	name = "Masquerade Violator"
	desc = "You can't recover your masquerade at all."
	value = -2
	mob_trait = TRAIT_VIOLATOR
	allowed_species = list("Vampire", "Ghoul", "Kuei-Jin")

/datum/quirk/irongullet
	name = "Iron Gullet"
	desc = "You don't mind sucking up cold blood from corpses. Though there's rarely that much left."
	value = 3
	mob_trait = TRAIT_GULLET
	gain_text = "<span class='notice'>You feel necroresistant.</span>"
	lose_text = "<span class='notice'>You don't want necrophilia anymore.</span>"
	allowed_species = list("Vampire")

/datum/quirk/charmer
	name = "Abnormal Charmer"
	desc = "You charm people around you."
	value = 2
	mob_trait = TRAIT_CHARMER
	gain_text = "<span class='notice'>You feel charismatic.</span>"
	lose_text = "<span class='notice'>You don't feel charismatic anymore.</span>"
	allowed_species = list("Vampire", "Kuei-Jin")

/datum/quirk/tower
	name = "Tower"
	desc = "You are tall."
	value = 0
	gain_text = "<span class='notice'>You feel tall.</span>"
	lose_text = "<span class='notice'>You don't feel tall anymore.</span>"

/datum/quirk/tower/add()
	if(iswerewolf(quirk_holder))
		return
	quirk_holder.AddElement(/datum/element/giantism, COMSIG_PARENT_PREQDELETED, src)

/datum/quirk/tower/remove()
	if (!quirk_holder)
		return
	quirk_holder.RemoveElement(/datum/element/giantism)

#define TALL 1.16
#define SHORT 0.86206896551

///Very similar to squish, but for dwarves and shorties
/datum/element/giantism
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2
	var/comsig
	var/list/attached_targets = list()

/datum/element/giantism/Attach(datum/target, comsig, comsig_target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE

	src.comsig = comsig

	var/mob/living/carbon/human/L = target
	if(L.lying_angle != 0)
		L.transform = L.transform.Scale(TALL, 1)
		L.transform = L.transform.Translate(L.lying_angle == 90 ? 16*(TALL-1) : -(16*(TALL-1)), 0) //Makes sure you stand on the tile no matter the size - sand
	else
		L.transform = L.transform.Scale(1, TALL)
		L.transform = L.transform.Translate(0, 16*(TALL-1)) //Makes sure you stand on the tile no matter the size - sand
	attached_targets[target] = comsig_target
	RegisterSignal(target, comsig, PROC_REF(check_loss)) //Second arg of the signal will be checked against the comsig_target.

/datum/element/giantism/proc/check_loss(mob/living/L, comsig_target)
	if(attached_targets[L] == comsig_target)
		Detach(L)

/datum/element/giantism/Detach(mob/living/L)
	. = ..()
	if(QDELETED(L))
		return
	if(L.lying_angle != 0)
		L.transform = L.transform.Scale(SHORT, 1)
		L.transform = L.transform.Translate(L.lying_angle == 90 ? 16*(SHORT-1) : -(16*(SHORT-1)), 0) //Makes sure you stand on the tile no matter the size - sand
	else
		L.transform = L.transform.Scale(1, SHORT)
		L.transform = L.transform.Translate(0, 16*(SHORT-1)) //Makes sure you stand on the tile no matter the size - sand
	UnregisterSignal(L, comsig)
	attached_targets -= L

#undef SHORT
#undef TALL

//flower languages
/datum/quirk/flower_language //sourced from Elizabeth Wirt's Flora's Dictionary for a Victorian era popular American perspective on Floriography to fit the setting.
	name = "Floriography" //available @ https://archive.org/details/florasdictionary00wirtrich/page/n35/mode/2up for future flora added to the project
	desc = "Learn the cryptology of victorian flower language."
	mob_trait = TRAIT_FLOWER_LANGUAGE
	value = 0
	gain_text = "<span class='notice'>You recall the Victorian language of flowers.</span>"
	lose_text = "<span class='warning'>Your knowledge of the Victorian language of flowers slips away.</span>"

/datum/quirk/flower_language_japanese //ideally this would be a subset of the above somehow but I lack the knowledge
	name = "Hanakotoba" //sourced from https://hananokotoba.com/sagisou/
	desc = "Learn the cryptology of japanese flower language."
	mob_trait = TRAIT_FLOWER_LANGUAGE_JAPANESE
	value = 0
	gain_text = "<span class='notice'>You recall the art of Hanakotoba.</span>"
	lose_text = "<span class='warning'>Your knowledge of Hanakotoba slips away.</span>"
