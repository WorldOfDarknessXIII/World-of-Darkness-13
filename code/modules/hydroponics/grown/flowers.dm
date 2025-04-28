// Flower template originally created to facilitate different bouquet types with minimal overlap
/obj/item/food/grown/flower
	seed = /obj/item/seeds/template //seed the flower will grow from.
	name = "flower" //name of the flower
	desc = "you shouldn't be seeing this. please contact staff." //examine text
	icon_state = "poppy" //the sprite to render
	slot_flags = ITEM_SLOT_HEAD //Where you can equip it
	bite_consumption_mod = 3 //How many bites to eat it
	foodtypes = VEGETABLES | GROSS
	distill_reagent = /datum/reagent/consumable/ethanol

/obj/item/seeds/template //seed template to make the flower template work. you can't specify a seed that doesn't exist.
	name = "pack of testing seeds"
	desc = "These seeds grow into code testing flowers."
	icon_state = "seed-poppy"
	species = "flower"
	plantname = "flower"
	product = /obj/item/food/grown/flower
	endurance = 10
	maturation = 8
	yield = 6
	potency = 20
	instability = 1 //Flowers have 1 instability, if you want to breed out instability, crossbreed with flowers.
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	icon_grow = "poppy-grow"
	icon_dead = "poppy-dead"
	mutatelist = list(/obj/item/seeds/poppy/geranium, /obj/item/seeds/poppy/lily)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05)

// Poppy
/obj/item/seeds/poppy
	name = "pack of poppy seeds"
	desc = "These seeds grow into poppies."
	icon_state = "seed-poppy"
	species = "poppy"
	plantname = "Poppy Plants"
	product = /obj/item/food/grown/flower/poppy
	endurance = 10
	maturation = 8
	yield = 6
	potency = 20
	instability = 1 //Flowers have 1 instability, if you want to breed out instability, crossbreed with flowers.
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	icon_grow = "poppy-grow"
	icon_dead = "poppy-dead"
	mutatelist = list(/obj/item/seeds/poppy/geranium, /obj/item/seeds/poppy/lily)
	reagents_add = list(/datum/reagent/medicine/c2/libital = 0.2, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/flower/poppy
	seed = /obj/item/seeds/poppy
	name = "poppy"
	desc = "Long-used as a symbol of rest, peace, and death."
	icon_state = "poppy"
	slot_flags = ITEM_SLOT_HEAD
	bite_consumption_mod = 3
	foodtypes = VEGETABLES | GROSS
	distill_reagent = /datum/reagent/consumable/ethanol/vermouth

/obj/item/food/grown/flower/poppy/examine(mob/user) //when examined...
	. = ..() //makes current proc the parent proc and once it returns, return to this point and continues the lines below -XeonMations
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE)) //check if examiner has Floriography Quirk
		. += span_notice("Floriography speaks to you of Consolation, of Death.</span>") //output into examine description if has Floriography
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE_JAPANESE)) //checks if examiner has Hanakotoba Quirk
		. += span_notice("Hanakotoba expresses being Fun-loving.") //output into examine description if has Hanakotoba

// Lily
/obj/item/seeds/poppy/lily
	name = "pack of lily seeds"
	desc = "These seeds grow into lilies."
	icon_state = "seed-lily"
	species = "lily"
	plantname = "Lily Plants"
	product = /obj/item/food/grown/flower/lily
	mutatelist = list(/obj/item/seeds/poppy/lily/clusterlily)

/obj/item/food/grown/flower/lily
	seed = /obj/item/seeds/poppy/lily
	name = "lily"
	desc = "A beautiful orange flower."
	icon_state = "lily"

/obj/item/food/grown/flower/lily/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE))
		. += span_notice("Floriography speaks to you of Purity and sweetness.")
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE_JAPANESE))
		. += span_notice("Hanakotoba expresses Purity and chastity.")

//Elegant cluster-lily. Formerly Spacemans's Trumpet.
/obj/item/seeds/flower/lily/clusterlily

	name = "pack of elegant cluster-lily seeds"
	desc = "These seeds grow into brodiaea elegans."
	icon_state = "seed-clusterlily"
	species = "clusterlily"
	plantname = "Elegant Cluster-Lily Plant"
	product = /obj/item/food/grown/flower/clusterlily
	lifespan = 80
	production = 5
	endurance = 10
	maturation = 12
	yield = 4
	potency = 20
	growthstages = 4
	weed_rate = 2
	weed_chance = 10
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	icon_grow = "clusterlily-grow"
	icon_dead = "clusterlily-dead"
	mutatelist = list()
	genes = list(/datum/plant_gene/reagent/polypyr)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05)
	rarity = 30
	graft_gene = /datum/plant_gene/reagent/polypyr

/obj/item/seeds/poppy/lily/clusterlily/Initialize(mapload,nogenes)
	. = ..()
	if(!nogenes)
		unset_mutability(/datum/plant_gene/reagent/polypyr, PLANT_GENE_EXTRACTABLE)

/obj/item/food/grown/flower/clusterlily
	seed = /obj/item/seeds/poppy/lily/clusterlily
	name = "elegent cluster-lily"
	desc = "A beautiful cluster of purple flowers."
	icon_state = "clusterlily"
	bite_consumption_mod = 3
	foodtypes = VEGETABLES

/obj/item/food/grown/flower/clusterlily/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE))
		. += span_notice("Floriography speaks to you of Royalty, of Elegance.")
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE_JAPANESE))
		. += span_notice("Hanakotoba expresses being love-drunk.")

// Geranium
/obj/item/seeds/poppy/geranium
	name = "pack of geranium seeds"
	desc = "These seeds grow into geranium."
	icon_state = "seed-geranium"
	species = "geranium"
	plantname = "Geranium Plants"
	product = /obj/item/food/grown/flower/geranium
	mutatelist = list(/obj/item/seeds/poppy/geranium/fraxinella)

/obj/item/food/grown/flower/geranium
	seed = /obj/item/seeds/poppy/geranium
	name = "geranium"
	desc = "A beautiful blue flower."
	icon_state = "geranium"

/obj/item/food/grown/flower/geranium/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE))
		. += span_notice("Floriography speaks to you of Envy.")
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE_JAPANESE))
		. += span_notice("Hanakotoba expresses Friendship.")

///Fraxinella seeds.
/obj/item/seeds/poppy/geranium/fraxinella
	name = "pack of fraxinella seeds"
	desc = "These seeds grow into fraxinella."
	icon_state = "seed-fraxinella"
	species = "fraxinella"
	plantname = "Fraxinella Plants"
	product = /obj/item/food/grown/flower/geranium/fraxinella
	mutatelist = list()
	rarity = 15
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05, /datum/reagent/fuel/oil = 0.05)

///Fraxinella Flowers.
/obj/item/food/grown/flower/geranium/fraxinella //typically not found in America and thus lacks US Victorian Floriography. A modern subsitute was applied.
	seed = /obj/item/seeds/poppy/geranium/fraxinella
	name = "fraxinella"
	desc = "A beautiful light pink flower."
	icon_state = "fraxinella"
	distill_reagent = /datum/reagent/ash

/obj/item/food/grown/flower/fraxinella/examine(mob/user)
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE))
		. += span_notice("Floriography speaks to you of Fire.")
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE_JAPANESE))
		. += span_notice("You don't recall any expression from this flower in Hanakotoba.")

// Harebell
/obj/item/seeds/harebell
	name = "pack of harebell seeds"
	desc = "These seeds grow into pretty little flowers."
	icon_state = "seed-harebell"
	species = "harebell"
	plantname = "Harebells"
	product = /obj/item/food/grown/flower/harebell
	lifespan = 100
	endurance = 20
	maturation = 7
	production = 1
	yield = 2
	potency = 30
	instability = 1
	growthstages = 4
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy)
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.04)
	graft_gene = /datum/plant_gene/trait/plant_type/weed_hardy

/obj/item/food/grown/flower/harebell
	seed = /obj/item/seeds/harebell
	name = "harebell"
	desc = "\"I'll sweeten thy sad grave: thou shalt not lack the flower that's like thy face, pale primrose, nor the azured hare-bell, like thy veins; no, nor the leaf of eglantine, whom not to slander, out-sweeten'd not thy breath.\""
	icon_state = "harebell"
	slot_flags = ITEM_SLOT_HEAD
	bite_consumption_mod = 3
	distill_reagent = /datum/reagent/consumable/ethanol/vermouth

/obj/item/food/grown/flower/harebell/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE))
		. += span_notice("Floriography speaks to you of Humility.")
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE_JAPANESE))
		. += span_notice("Hanakotoba expresses Gratefulness.")

// Sunflower
/obj/item/seeds/poppy/sunflower
	name = "pack of sunflower seeds"
	desc = "These seeds grow into sunflowers."
	icon_state = "seed-sunflower"
	species = "sunflower"
	plantname = "Sunflowers"
	product = /obj/item/grown/flower/sunflower
	endurance = 20
	production = 2
	yield = 2
	instability = 1
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	icon_grow = "sunflower-grow"
	icon_dead = "sunflower-dead"
	mutatelist = list(/obj/item/seeds/sunflower/moonflower, /* /obj/item/seeds/sunflower/novaflower */)
	reagents_add = list(/datum/reagent/consumable/cornoil = 0.08, /datum/reagent/consumable/nutriment = 0.04)

/obj/item/grown/flower/sunflower // FLOWER POWER!
	seed = /obj/item/seeds/poppy/sunflower
	name = "sunflower"
	desc = "It's beautiful! A certain person might beat you to death if you trample these."
	icon_state = "sunflower"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	damtype = BURN
	force = 0
	slot_flags = ITEM_SLOT_HEAD
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/grown/flower/sunflower/attack(mob/M, mob/user)
	to_chat(M, "<font color='green'>[user] smacks you with a sunflower!<font color='orange'><b>FLOWER POWER!</b></font></font>")
	to_chat(user, "<font color='green'>Your sunflower's <font color='orange'><b>FLOWER POWER</b></font> strikes [M]!</font>")

/obj/item/grown/flower/sunflower/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE))
		. += span_notice("Floriography tells you, if short, this flower speaks of devout adoration. If notably tall, this flower speaks of Pride.</span>")
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE_JAPANESE))
		. += span_notice("Hanakotoba expresses Respect, passionate love, radiance.</span>")

// Moonflower
/obj/item/seeds/sunflower/moonflower
	name = "pack of moonflower seeds"
	desc = "These seeds grow into moonflowers."
	icon_state = "seed-moonflower"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	species = "moonflower"
	plantname = "Moonflowers"
	icon_grow = "moonflower-grow"
	icon_dead = "sunflower-dead"
	product = /obj/item/food/grown/flower/moonflower
	genes = list(/datum/plant_gene/trait/glow/purple)
	mutatelist = list()
	reagents_add = list(\
	/*/datum/reagent/consumable/ethanol/moonshine = 0.2,*/\
	/datum/reagent/consumable/nutriment/vitamin = 0.02, /datum/reagent/consumable/nutriment = 0.02)
	rarity = 15
	graft_gene = /datum/plant_gene/trait/glow/purple

/obj/item/food/grown/flower/moonflower //whoever made this doesn't know a moonflower is a real thing. Ipomoea alba.
	seed = /obj/item/seeds/sunflower/moonflower
	name = "moonflower"
	desc = "Store in a location at least 50 yards away from werewolves."
	icon_state = "moonflower"
	slot_flags = ITEM_SLOT_HEAD
	bite_consumption_mod = 2
	distill_reagent = /datum/reagent/consumable/ethanol/absinthe //It's made from flowers.

/obj/item/seeds/sunflower/moonflower/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE))
		. += span_notice("Floriography speaks to you of mortality, of love in vain.</span>")
	if(HAS_TRAIT(user, TRAIT_FLOWER_LANGUAGE_JAPANESE))
		. += span_notice("Hanakotoba expresses Willful promises.")

/* Commenting this out because regrettably, a pyro flower on the vampire server would be funny but OP.
Choosing not to delete it in case the example of its code is useful for something down the line.

// Novaflower
/obj/item/seeds/sunflower/novaflower
	name = "pack of novaflower seeds"
	desc = "These seeds grow into novaflowers."
	icon_state = "seed-novaflower"
	species = "novaflower"
	plantname = "Novaflowers"
	icon_grow = "novaflower-grow"
	icon_dead = "sunflower-dead"
	product = /obj/item/grown/flower/novaflower
	mutatelist = list()
	reagents_add = list(/datum/reagent/consumable/condensedcapsaicin = 0.25, /datum/reagent/consumable/capsaicin = 0.3, /datum/reagent/consumable/nutriment = 0)
	rarity = 20

/obj/item/grown/flower/novaflower
	seed = /obj/item/seeds/sunflower/novaflower
	name = "novaflower"
	desc = "These beautiful flowers have a crisp smokey scent, like a summer bonfire."
	icon_state = "novaflower"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	damtype = BURN
	force = 0
	slot_flags = ITEM_SLOT_HEAD
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	attack_verb_continuous = list("roasts", "scorches", "burns")
	attack_verb_simple = list("roast", "scorch", "burn")
	grind_results = list(/datum/reagent/consumable/capsaicin = 0, /datum/reagent/consumable/condensedcapsaicin = 0)

/obj/item/grown/flower/novaflower/add_juice()
	..()
	force = round((5 + seed.potency / 5), 1)

/obj/item/grown/novaflower/attack(mob/living/carbon/M, mob/user)
	if(!..())
		return
	if(isliving(M))
		to_chat(M, "<span class='danger'>You are lit on fire from the intense heat of the [name]!</span>")
		M.adjust_fire_stacks(seed.potency / 20)
		if(M.IgniteMob())
			message_admins("[ADMIN_LOOKUPFLW(user)] set [ADMIN_LOOKUPFLW(M)] on fire with [src] at [AREACOORD(user)]")
			log_game("[key_name(user)] set [key_name(M)] on fire with [src] at [AREACOORD(user)]")

/obj/item/grown/flower/novaflower/afterattack(atom/A as mob|obj, mob/user,proximity)
	. = ..()
	if(!proximity)
		return
	if(force > 0)
		force -= rand(1, (force / 3) + 1)
	else
		to_chat(usr, "<span class='warning'>All the petals have fallen off the [name] from violent whacking!</span>")
		qdel(src)

/obj/item/grown/flower/novaflower/pickup(mob/living/carbon/human/user)
	..()
	if(!user.gloves)
		to_chat(user, "<span class='danger'>The [name] burns your bare hand!</span>")
		user.adjustFireLoss(rand(1, 5))
*/

