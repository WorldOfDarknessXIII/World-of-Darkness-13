#define ALCOHOL_THRESHOLD_MODIFIER 1 //Greater numbers mean that less alcohol has greater intoxication potential
#define ALCOHOL_RATE 0.005 //The rate at which alcohol affects you
#define ALCOHOL_EXPONENT 1.6 //The exponent applied to boozepwr to make higher volume alcohol at least a little bit damaging to the liver

////////////// I don't know who made this header before I refactored alcohols but I'm going to fucking strangle them because it was so ugly, holy Christ
// ALCOHOLS //
//////////////

/datum/reagent/consumable/ethanol
	name = "Ethanol"
	description = "A well-known alcohol with a variety of applications."
	color = "#404030" // rgb: 64, 64, 48
	nutriment_factor = 0
	taste_description = "alcohol"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	var/boozepwr = 65 //Higher numbers equal higher hardness, higher hardness equals more intense alcohol poisoning
/*
Boozepwr Chart
Note that all higher effects of alcohol poisoning will inherit effects for smaller amounts (i.e. light poisoning inherts from slight poisoning)
In addition, severe effects won't always trigger unless the drink is poisonously strong
All effects don't start immediately, but rather get worse over time; the rate is affected by the imbiber's alcohol tolerance

0: Non-alcoholic
1-10: Barely classifiable as alcohol - occassional slurring
11-20: Slight alcohol content - slurring
21-30: Below average - imbiber begins to look slightly drunk
31-40: Just below average - no unique effects
41-50: Average - mild disorientation, imbiber begins to look drunk
51-60: Just above average - disorientation, vomiting, imbiber begins to look heavily drunk
61-70: Above average - small chance of blurry vision, imbiber begins to look smashed
71-80: High alcohol content - blurry vision, imbiber completely shitfaced
81-90: Extremely high alcohol content - heavy toxin damage, passing out
91-100: Dangerously toxic - swift death
*/

/datum/reagent/consumable/ethanol/on_mob_life(mob/living/carbon/C)
	if(C.drunkenness < volume * boozepwr * ALCOHOL_THRESHOLD_MODIFIER || boozepwr < 0)
		var/booze_power = boozepwr
		if(HAS_TRAIT(C, TRAIT_ALCOHOL_TOLERANCE)) //we're an accomplished drinker
			booze_power *= 0.7
		if(HAS_TRAIT(C, TRAIT_LIGHT_DRINKER))
			booze_power *= 2
		C.drunkenness = max((C.drunkenness + (sqrt(volume) * booze_power * ALCOHOL_RATE)), 0) //Volume, power, and server alcohol rate effect how quickly one gets drunk
		if(boozepwr > 0)
			var/obj/item/organ/liver/L = C.getorganslot(ORGAN_SLOT_LIVER)
			if (istype(L))
				L.applyOrganDamage(((max(sqrt(volume) * (boozepwr ** ALCOHOL_EXPONENT) * L.alcohol_tolerance, 0))/150))
	return ..()

/datum/reagent/consumable/ethanol/expose_obj(obj/exposed_obj, reac_volume)
	if(istype(exposed_obj, /obj/item/paper))
		var/obj/item/paper/paperaffected = exposed_obj
		paperaffected.clearpaper()
		to_chat(usr, "<span class='notice'>[paperaffected]'s ink washes away.</span>")
	if(istype(exposed_obj, /obj/item/book))
		if(reac_volume >= 5)
			var/obj/item/book/affectedbook = exposed_obj
			affectedbook.dat = null
			exposed_obj.visible_message("<span class='notice'>[exposed_obj]'s writing is washed away by [name]!</span>")
		else
			exposed_obj.visible_message("<span class='warning'>[exposed_obj]'s ink is smeared by [name], but doesn't wash away!</span>")
	return ..()

/datum/reagent/consumable/ethanol/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with ethanol isn't quite as good as fuel.
	. = ..()
	if(!(methods & (TOUCH|VAPOR|PATCH)))
		return

	exposed_mob.adjust_fire_stacks(reac_volume / 15)

	if(!iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	var/power_multiplier = boozepwr / 65 // Weak alcohol has less sterilizing power

	for(var/s in exposed_carbon.surgeries)
		var/datum/surgery/surgery = s
		surgery.speed_modifier = max(0.1*power_multiplier, surgery.speed_modifier)

/datum/reagent/consumable/ethanol/beer
	name = "Beer"
	description = "An alcoholic beverage brewed since ancient times on Old Earth. Still popular today."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 25
	taste_description = "piss water"
	glass_name = "glass of beer"
	glass_desc = "A freezing pint of beer."


	// Beer is a chemical composition of alcohol and various other things. It's a garbage nutrient but hey, it's still one. Also alcohol is bad, mmmkay?
/datum/reagent/consumable/ethanol/beer/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(src, 1))
		mytray.adjustHealth(-round(chems.get_reagent_amount(src.type) * 0.05))
		mytray.adjustWater(round(chems.get_reagent_amount(src.type) * 0.7))

/datum/reagent/consumable/ethanol/beer/light
	name = "Light Beer"
	color = "#FFDB1A" // rgb: 255, 219, 026
	description = "An alcoholic beverage brewed since ancient times on Old Earth. This variety has reduced calorie and alcohol content."
	boozepwr = 5 //Space Europeans hate it
	taste_description = "dish water"
	glass_name = "glass of light beer"
	glass_desc = "A freezing pint of watery light beer."

/datum/reagent/consumable/ethanol/beer/maltliquor
	name = "Malt Liquor"
	description = "An alcoholic beverage brewed since ancient times on Old Earth. This variety is stronger than usual, super cheap, and super terrible."
	boozepwr = 35
	taste_description = "sweet corn beer and the hood life"
	glass_name = "glass of malt liquor"
	glass_desc = "A freezing pint of malt liquor."

/datum/reagent/consumable/ethanol/beer/beer_pint
	name = "bitter dark beer"
	glass_icon_state = "dark_beer"
	empty_glass_icon_state = "pint"

/datum/reagent/consumable/ethanol/beer/light/beer_pint
	name = "refreshing light beer"
	glass_icon_state = "beer"
	empty_glass_icon_state = "pint"

/datum/reagent/consumable/ethanol/kahlua
	name = "Kahlua"
	description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	glass_icon_state = "kahluaglass"
	glass_name = "glass of RR coffee liquor"
	glass_desc = "DAMN, THIS THING LOOKS ROBUST!"
	shot_glass_icon_state = "shotglasscream"

/datum/reagent/consumable/ethanol/kahlua/on_mob_life(mob/living/carbon/M)
	M.dizziness = max(0,M.dizziness-5)
	M.drowsyness = max(0,M.drowsyness-3)
	M.AdjustSleeping(-40)
	if(!HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		M.Jitter(5)
	..()
	. = 1

/datum/reagent/consumable/ethanol/whiskey
	name = "Whiskey"
	description = "A superb and well-aged single-malt whiskey. Damn."
	color = "#8C5930" // rgb: 140, 89, 048
	boozepwr = 75
	taste_description = "molasses"
	glass_icon_state = "whiskeyglass"
	glass_name = "glass of whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."
	//shot_glass_icon_state = "shotglassbrown"

/datum/reagent/consumable/ethanol/whiskey/whiskey_shot
	name = "aged whiskey"
	glass_icon_state = "whiskey"
	glass_name = "glass of whiskey"
	glass_desc = "The shot contain whiskey"

/datum/reagent/consumable/ethanol/whiskey/kong
	name = "Kong"
	description = "Makes You Go Ape!&#174;"
	color = "#332100" // rgb: 51, 33, 0
	addiction_threshold = 15
	taste_description = "the grip of a giant ape"
	glass_name = "glass of Kong"
	glass_desc = "Makes You Go Ape!&#174;"

/datum/reagent/consumable/ethanol/whiskey/kong/addiction_act_stage1(mob/living/M)
	if(prob(5))
		to_chat(M, "<span class='notice'>You've made so many mistakes.</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "depression_minimal", /datum/mood_event/depression_minimal)
	..()

/datum/reagent/consumable/ethanol/whiskey/kong/addiction_act_stage2(mob/living/M)
	if(prob(5))
		to_chat(M, "<span class='notice'>No matter what you do, people will always get hurt.</span>")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "depression_minimal", /datum/mood_event/depression_minimal)
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "depression_mild", /datum/mood_event/depression_mild)
	..()

/datum/reagent/consumable/ethanol/whiskey/kong/addiction_act_stage3(mob/living/M)
	if(prob(5))
		to_chat(M, "<span class='notice'>You've lost so many people.</span>")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "depression_mild", /datum/mood_event/depression_mild)
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "depression_moderate", /datum/mood_event/depression_moderate)
	..()

/datum/reagent/consumable/ethanol/whiskey/kong/addiction_act_stage4(mob/living/M)
	if(prob(5))
		to_chat(M, "<span class='notice'>Just lie down and die.</span>")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "depression_moderate", /datum/mood_event/depression_moderate)
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "depression_severe", /datum/mood_event/depression_severe)
	..()

/datum/reagent/consumable/ethanol/whiskey/candycorn
	name = "candy corn liquor"
	description = "Like they drank in 2D speakeasies."
	color = "#ccb800" // rgb: 204, 184, 0
	taste_description = "pancake syrup"
	glass_name = "glass of candy corn liquor"
	glass_desc = "Good for your Imagination."
	var/hal_amt = 4

/datum/reagent/consumable/ethanol/whiskey/candycorn/on_mob_life(mob/living/carbon/M)
	if(prob(10))
		M.hallucination += hal_amt //conscious dreamers can be treasurers to their own currency
	..()

/datum/reagent/consumable/ethanol/vodka
	name = "Vodka"
	description = "Number one drink AND fueling choice for Russians worldwide."
	color = "#CDE8F0" // rgb: 205, 232, 240
	boozepwr = 65
	taste_description = "grain alcohol"
	glass_name = "glass of vodka"
	glass_desc = "The glass contain vodka"
	shot_glass_icon_state = "shotglassclear"

/datum/reagent/consumable/ethanol/vodka/vodka_shot
	name = "clear vodka"
	glass_icon_state = "vodka"
	glass_name = "shot of vodka"
	glass_desc = "The shot contain vodka"
	empty_glass_icon_state = "vodka_shot"

/datum/reagent/consumable/ethanol/vodka/on_mob_life(mob/living/carbon/M)
	M.radiation = max(M.radiation-2,0)
	return ..()

/datum/reagent/consumable/ethanol/bilk/on_mob_life(mob/living/carbon/M)
	if(M.getBruteLoss() && prob(10))
		M.heal_bodypart_damage(brute = 1)
		. = 1
	return ..() || .

/datum/reagent/consumable/ethanol/gin
	name = "Gin"
	description = "It's gin. In space. I say, good sir."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	taste_description = "an alcoholic christmas tree"
	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of gin"
	glass_desc = "A crystal clear glass of Griffeater gin."

/datum/reagent/consumable/ethanol/rum
	name = "Rum"
	description = "Yohoho and all that."
	color = "#5C3C19" // rgb: 092, 060, 025
	boozepwr = 60
	taste_description = "spiked butterscotch"
	glass_icon_state = "rumglass"
	glass_name = "glass of rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	shot_glass_icon_state = "shotglassbrown"

/datum/reagent/consumable/ethanol/rum/rum_shot
	name = "sweet rum"
	glass_icon_state = "rum"
	glass_name = "shot of rum"
	glass_desc = "The shot contain rum"
	empty_glass_icon_state = "whiskey_shot"

/datum/reagent/consumable/ethanol/tequila
	name = "Tequila"
	description = "A strong and mildly flavoured, Mexican produced spirit. Feeling thirsty, hombre?"
	color = "#EFF0CD" // rgb: 239, 240, 205
	boozepwr = 70
	taste_description = "paint stripper"
	glass_icon_state = "tequilaglass"
	glass_name = "glass of tequila"
	glass_desc = "Now all that's missing is the weird colored shades!"
	shot_glass_icon_state = "shotglassgold"

/datum/reagent/consumable/ethanol/tequila/tequila_shot
	name = "golden tequila"
	glass_icon_state = "tequilla"
	glass_name = "shot of tequila"
	glass_desc = "The shot contain tequila"
	empty_glass_icon_state = "vodka_shot"

/datum/reagent/consumable/ethanol/vermouth
	name = "Vermouth"
	description = "You suddenly feel a craving for a martini..."
	color = "#CBC4B1" // rgb: 203, 196, 177
	boozepwr = 45
	taste_description = "dry alcohol"
	glass_icon_state = "vermouthglass"
	glass_name = "glass of vermouth"
	glass_desc = "You wonder why you're even drinking this straight."
	shot_glass_icon_state = "shotglassclear"

/datum/reagent/consumable/ethanol/wine
	name = "Wine"
	description = "A premium alcoholic beverage made from distilled grape juice."
	color = "#8C2A2A" // rgb: 140, 042, 042
	boozepwr = 35
	taste_description = "bitter sweetness"
	glass_icon_state = "wineglass"
	glass_name = "glass of wine"
	glass_desc = "A very classy looking drink."
	shot_glass_icon_state = "shotglassred"
	empty_glass_icon_state = "wine_glass"

/datum/reagent/consumable/ethanol/wine/wine_glass
	name = "red wine"
	glass_icon_state = "wine"
	glass_name = "glass of wine"
	glass_desc = "The glass contain wine"

/datum/reagent/consumable/ethanol/wine/on_merge(data)
	. = ..()
	if(src.data && data && data["vintage"] != src.data["vintage"])
		src.data["vintage"] = "mixed wine"

/datum/reagent/consumable/ethanol/wine/get_taste_description(mob/living/taster)
	if(HAS_TRAIT(taster,TRAIT_WINE_TASTER))
		if(data && data["vintage"])
			return list("[data["vintage"]]" = 1)
		else
			return list("synthetic wine"=1)
	return ..()

/datum/reagent/consumable/ethanol/lizardwine
	name = "Lizard wine"
	description = "An alcoholic beverage from Space China, made by infusing lizard tails in ethanol."
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 45
	quality = DRINK_FANTASTIC
	taste_description = "scaley sweetness"

/datum/reagent/consumable/ethanol/grappa
	name = "Grappa"
	description = "A fine Italian brandy, for when regular wine just isn't alcoholic enough for you."
	color = "#F8EBF1"
	boozepwr = 60
	taste_description = "classy bitter sweetness"
	glass_icon_state = "grappa"
	glass_name = "glass of grappa"
	glass_desc = "A fine drink originally made to prevent waste by using the leftovers from winemaking."

/datum/reagent/consumable/ethanol/amaretto
	name = "Amaretto"
	description = "A gentle drink that carries a sweet aroma."
	color = "#E17600"
	boozepwr = 25
	taste_description = "fruity and nutty sweetness"
	glass_icon_state = "amarettoglass"
	glass_name = "glass of amaretto"
	glass_desc = "A sweet and syrupy looking drink."
	shot_glass_icon_state = "shotglassgold"

/datum/reagent/consumable/ethanol/cognac
	name = "Cognac"
	description = "A sweet and strongly alcoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	color = "#AB3C05" // rgb: 171, 60, 5
	boozepwr = 75
	taste_description = "angry and irish"
	glass_icon_state = "cognacglass"
	glass_name = "glass of cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."
	shot_glass_icon_state = "shotglassbrown"

/datum/reagent/consumable/ethanol/absinthe
	name = "Absinthe"
	description = "A powerful alcoholic drink. Rumored to cause hallucinations but does not."
	color = "#72B27C" //rgb : 114, 178, 124
	boozepwr = 80 //Very strong even by default
	taste_description = "death and licorice"
	glass_icon_state = "absinthe"
	glass_name = "glass of absinthe"
	glass_desc = "It's as strong as it smells."
	shot_glass_icon_state = "shotglassgreen"
	empty_glass_icon_state = "wine_glass"

/datum/reagent/consumable/ethanol/absinthe/absinthe_glass
	name = "aromatic absinthe"
	glass_icon_state = "abcent"
	glass_name = "glass of absinthe"
	glass_desc = "The glass contain absinthe"

/datum/reagent/consumable/ethanol/absinthe/on_mob_life(mob/living/carbon/M)
	if(prob(10) && !HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		M.hallucination += 4 //Reference to the urban myth
	..()

/datum/reagent/consumable/ethanol/ale
	name = "Ale"
	description = "A dark alcoholic beverage made with malted barley and yeast."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 65
	taste_description = "hearty barley ale"
	glass_icon_state = "aleglass"
	glass_name = "glass of ale"
	glass_desc = "A freezing pint of delicious Ale."

/datum/reagent/consumable/ethanol/gintonic
	name = "Gin and Tonic"
	description = "An all time classic, mild cocktail."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "mild and tart"
	glass_icon_state = "gintonicglass"
	glass_name = "Gin and Tonic"
	glass_desc = "A mild but still great cocktail. Drink up, like a true Englishman."

/datum/reagent/consumable/ethanol/rum_coke
	name = "Rum and Coke"
	description = "Rum, mixed with cola."
	taste_description = "cola"
	boozepwr = 40
	quality = DRINK_NICE
	color = "#3E1B00"
	glass_icon_state = "whiskeycolaglass"
	glass_name = "Rum and Coke"
	glass_desc = "The classic go-to of space-fratboys."

/datum/reagent/consumable/ethanol/cuba_libre
	name = "Cuba Libre"
	description = "Viva la Revolucion! Viva Cuba Libre!"
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "a refreshing marriage of citrus and rum"
	glass_icon_state = "cubalibreglass"
	glass_name = "Cuba Libre"
	glass_desc = "A classic mix of rum, cola, and lime. A favorite of revolutionaries everywhere!"

/datum/reagent/consumable/ethanol/cuba_libre/on_mob_life(mob/living/carbon/M)
	if(M.mind && M.mind.has_antag_datum(/datum/antagonist/rev)) //Cuba Libre, the traditional drink of revolutions! Heals revolutionaries.
		M.adjustBruteLoss(-1, 0)
		M.adjustFireLoss(-1, 0)
		M.adjustToxLoss(-1, 0)
		M.adjustOxyLoss(-5, 0)
		. = 1
	return ..() || .

/datum/reagent/consumable/ethanol/whiskey_cola
	name = "Whiskey Cola"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "cola"
	glass_icon_state = "whiskeycolaglass"
	glass_name = "whiskey cola"
	glass_desc = "An innocent-looking mixture of cola and whiskey. Delicious."


/datum/reagent/consumable/ethanol/martini
	name = "Classic Martini"
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "dry class"
	glass_icon_state = "martini"
	glass_name = "Classic Martini"
	glass_desc = "Damn, the bartender even stirred it, not shook it."
	empty_glass_icon_state = "martini_glass"

/datum/reagent/consumable/ethanol/white_russian
	name = "White Russian"
	description = "That's just, like, your opinion, man..."
	color = "#A68340" // rgb: 166, 131, 64
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "bitter cream"
	glass_icon_state = "whiterussianglass"
	glass_name = "White Russian"
	glass_desc = "A very nice looking drink. But that's just, like, your opinion, man."

/datum/reagent/consumable/ethanol/screwdrivercocktail
	name = "Screwdriver"
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 55
	quality = DRINK_NICE
	taste_description = "oranges"
	//glass_icon_state = "screwdriverglass"
	glass_name = "Screwdriver"
	glass_desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."

/datum/reagent/consumable/ethanol/screwdrivercocktail/on_mob_life(mob/living/carbon/M)
	var/obj/item/organ/liver/liver = M.getorganslot(ORGAN_SLOT_LIVER)
	if(HAS_TRAIT(liver, TRAIT_ENGINEER_METABOLISM))
		// Engineers lose radiation poisoning at a massive rate.
		M.radiation = max(M.radiation - 25, 0)
	return ..()

/datum/reagent/consumable/ethanol/bloody_mary
	name = "Bloody Mary"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 55
	quality = DRINK_GOOD
	taste_description = "tomatoes with a hint of lime"
	glass_icon_state = "bloodymaryglass"
	glass_name = "Bloody Mary"
	glass_desc = "Tomato juice, mixed with Vodka and a li'l bit of lime. Tastes like liquid murder."

/datum/reagent/consumable/ethanol/negrino
	name = "Negrino"
	description = "Brilliant crimson hue and harmonious blend of gin's botanical elegance, bittersweet campari and luscious vermouth"
	color = "#b42121" // rgb: 180, 033, 033
	boozepwr = 40
	quality = DRINK_VERYGOOD
	taste_description = "Bittersweet harmony."
	glass_icon_state = "negrino"
	glass_name = "Negroni"
	glass_desc = "Tomato juice, mixed with Vodka and a li'l bit of lime. Tastes like liquid murder."
	empty_glass_icon_state = "whiskey_shot"

/datum/reagent/consumable/ethanol/cosmopolitan
	name = "Cosmopolitan"
	description = ""
	color = "#C03519" // rgb: 192, 053, 025
	boozepwr = 50
	quality = DRINK_VERYGOOD
	taste_description = ""
	glass_icon_state = "cosmopolitan"
	glass_name = "Cosmopolitan"
	glass_desc = ""
	empty_glass_icon_state = "martini_glass"

/datum/reagent/consumable/ethanol/old_fashioned
	name = "Old fashioned"
	description = ""
	color = "#EE7A3F" // rgb: 238, 122, 063
	boozepwr = 40
	quality = DRINK_GOOD
	taste_description = ""
	glass_icon_state = "old_fasioned"
	glass_name = "Old fashioned"
	glass_desc = ""
	empty_glass_icon_state = "vodka_shot"

/datum/reagent/consumable/ethanol/french_75
	name = "French 75"
	description = ""
	color = "#979B86" // rgb: 151, 155, 134
	boozepwr = 30
	quality = DRINK_VERYGOOD
	taste_description = ""
	glass_icon_state = "french_75"
	glass_name = "French 75"
	glass_desc = ""
	empty_glass_icon_state = "wine_glass"

/datum/reagent/consumable/ethanol/bloody_mary/on_mob_life(mob/living/carbon/C)
	if(C.blood_volume < BLOOD_VOLUME_NORMAL)
		C.blood_volume = min(BLOOD_VOLUME_NORMAL, C.blood_volume + 3) //Bloody Mary quickly restores blood loss.
	..()

/datum/reagent/consumable/ethanol/brave_bull
	name = "Brave Bull"
	description = "It's just as effective as Dutch-Courage!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "alcoholic bravery"
	glass_icon_state = "bravebullglass"
	glass_name = "Brave Bull"
	glass_desc = "Tequila and Coffee liqueur, brought together in a mouthwatering mixture. Drink up."
	var/tough_text

/datum/reagent/consumable/ethanol/brave_bull/on_mob_metabolize(mob/living/M)
	tough_text = pick("brawny", "tenacious", "tough", "hardy", "sturdy") //Tuff stuff
	to_chat(M, "<span class='notice'>You feel [tough_text]!</span>")
	M.maxHealth += 10 //Brave Bull makes you sturdier, and thus capable of withstanding a tiny bit more punishment.
	M.health += 10

/datum/reagent/consumable/ethanol/brave_bull/on_mob_end_metabolize(mob/living/M)
	to_chat(M, "<span class='notice'>You no longer feel [tough_text].</span>")
	M.maxHealth -= 10
	M.health = min(M.health - 10, M.maxHealth) //This can indeed crit you if you're alive solely based on alchol ingestion

/datum/reagent/consumable/ethanol/tequila_sunrise
	name = "Tequila Sunrise"
	description = "Tequila, Grenadine, and Orange Juice."
	color = "#FFE48C" // rgb: 255, 228, 140
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "oranges with a hint of pomegranate"
	glass_icon_state = "tequilasunriseglass"
	glass_name = "tequila Sunrise"
	glass_desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."
	var/obj/effect/light_holder

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_metabolize(mob/living/M)
	to_chat(M, "<span class='notice'>You feel gentle warmth spread through your body!</span>")
	light_holder = new(M)
	light_holder.set_light(3, 0.7, "#FFCC00") //Tequila Sunrise makes you radiate dim light, like a sunrise!

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_life(mob/living/carbon/M)
	if(QDELETED(light_holder))
		holder.del_reagent(type) //If we lost our light object somehow, remove the reagent
	else if(light_holder.loc != M)
		light_holder.forceMove(M)
	return ..()

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_end_metabolize(mob/living/M)
	to_chat(M, "<span class='notice'>The warmth in your body fades.</span>")
	QDEL_NULL(light_holder)

/datum/reagent/consumable/ethanol/irish_cream
	name = "Irish Cream"
	description = "Whiskey-imbued cream, what else would you expect from the Irish?"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 50
	quality = DRINK_NICE
	taste_description = "creamy alcohol"
	glass_icon_state = "irishcreamglass"
	glass_name = "Irish Cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"

/datum/reagent/consumable/ethanol/irishcoffee
	name = "Irish Coffee"
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "giving up on the day"
	glass_icon_state = "irishcoffeeglass"
	glass_name = "Irish Coffee"
	glass_desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."

/datum/reagent/consumable/ethanol/margarita
	name = "Margarita"
	description = "On the rocks with salt on the rim. Arriba~!"
	color = "#BEC0B4" // rgb: 190, 192, 180
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "dry and salty"
	glass_icon_state = "margarita"
	glass_name = "Margarita"
	glass_desc = "On the rocks with salt on the rim. Arriba~!"
	empty_glass_icon_state = "whiskey_shot"

/datum/reagent/consumable/ethanol/black_russian
	name = "Black Russian"
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	color = "#360000" // rgb: 54, 0, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "bitterness"
	glass_icon_state = "blackrussianglass"
	glass_name = "Black Russian"
	glass_desc = "For the lactose-intolerant. Still as classy as a White Russian."


/datum/reagent/consumable/ethanol/manhattan
	name = "Manhattan"
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "mild dryness"
	glass_icon_state = "manhattanglass"
	glass_name = "Manhattan"
	glass_desc = "The Detective's undercover drink of choice. He never could stomach gin..."

/datum/reagent/consumable/ethanol/whiskeysoda
	name = "Whiskey Soda"
	description = "For the more refined griffon."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 70
	quality = DRINK_NICE
	taste_description = "soda"
	glass_icon_state = "whiskeysodaglass2"
	glass_name = "whiskey soda"
	glass_desc = "Ultimate refreshment."

/datum/reagent/consumable/ethanol/barefoot
	name = "Barefoot"
	description = "Barefoot and pregnant."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_VERYGOOD
	taste_description = "creamy berries"
	glass_icon_state = "b&p"
	glass_name = "Barefoot"
	glass_desc = "Barefoot and pregnant."

/datum/reagent/consumable/ethanol/barefoot/on_mob_life(mob/living/carbon/M)
	if(ishuman(M)) //Barefoot causes the imbiber to quickly regenerate brute trauma if they're not wearing shoes.
		var/mob/living/carbon/human/H = M
		if(!H.shoes)
			H.adjustBruteLoss(-3, 0)
			. = 1
	return ..() || .

/datum/reagent/consumable/ethanol/snowwhite
	name = "Snow White"
	description = "A cold refreshment."
	color = "#FFFFFF" // rgb: 255, 255, 255
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "refreshing cold"
	glass_icon_state = "snowwhite"
	glass_name = "Snow White"
	glass_desc = "A cold refreshment."

/datum/reagent/consumable/ethanol/demonsblood //Prevents the imbiber from being dragged into a pool of blood by a slaughter demon.
	name = "Demon's Blood"
	description = "AHHHH!!!!"
	color = "#820000" // rgb: 130, 0, 0
	boozepwr = 75
	quality = DRINK_VERYGOOD
	taste_description = "sweet tasting iron"
	glass_icon_state = "demonsblood"
	glass_name = "Demons Blood"
	glass_desc = "Just looking at this thing makes the hair at the back of your neck stand up."

/datum/reagent/consumable/ethanol/devilskiss //If eaten by a slaughter demon, the demon will regret it.
	name = "Devil's Kiss"
	description = "Creepy time!"
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 70
	quality = DRINK_VERYGOOD
	taste_description = "bitter iron"
	glass_icon_state = "devilskiss"
	glass_name = "Devils Kiss"
	glass_desc = "Creepy time!"

/datum/reagent/consumable/ethanol/iced_beer
	name = "Iced Beer"
	description = "A beer which is so cold the air around it freezes."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 15
	taste_description = "refreshingly cold"
	glass_icon_state = "iced_beerglass"
	glass_name = "iced beer"
	glass_desc = "A beer so frosty, the air around it freezes."

/datum/reagent/consumable/ethanol/iced_beer/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-20 * TEMPERATURE_DAMAGE_COEFFICIENT, T0C) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/grog
	name = "Grog"
	description = "Watered-down rum, Nanotrasen approves!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1 //Basically nothing
	taste_description = "a poor excuse for alcohol"
	glass_icon_state = "grogglass"
	glass_name = "Grog"
	glass_desc = "A fine and cepa drink for Space."

/datum/reagent/consumable/ethanol/andalusia
	name = "Andalusia"
	description = "A nice, strangely named drink."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 40
	quality = DRINK_GOOD
	taste_description = "lemons"
	glass_icon_state = "andalusia"
	glass_name = "Andalusia"
	glass_desc = "A nice, strangely named drink."

/datum/reagent/consumable/ethanol/alliescocktail
	name = "Allies Cocktail"
	description = "A drink made from your allies. Not as sweet as those made from your enemies."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 45
	quality = DRINK_NICE
	taste_description = "bitter yet free"
	glass_icon_state = "alliescocktail"
	glass_name = "Allies cocktail"
	glass_desc = "A drink made from your allies."

/datum/reagent/consumable/ethanol/hcider
	name = "Hard Cider"
	description = "Apple juice, for adults."
	color = "#CD6839"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 25
	taste_description = "the season that <i>falls</i> between summer and winter"
	glass_icon_state = "whiskeyglass"
	glass_name = "hard cider"
	glass_desc = "Tastes like autumn... no wait, fall!"
	shot_glass_icon_state = "shotglassbrown"

//Another reference. Heals those in critical condition extremely quickly.

/datum/reagent/consumable/ethanol/neurotoxin
	name = "Neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	color = "#2E2E61" // rgb: 46, 46, 97
	boozepwr = 50
	quality = DRINK_VERYGOOD
	taste_description = "a numbing sensation"
	metabolization_rate = 1 * REAGENTS_METABOLISM
	glass_icon_state = "neurotoxinglass"
	glass_name = "Neurotoxin"
	glass_desc = "A drink that is guaranteed to knock you silly."

/datum/reagent/consumable/ethanol/neurotoxin/proc/pickt()
	return (pick(TRAIT_PARALYSIS_L_ARM,TRAIT_PARALYSIS_R_ARM,TRAIT_PARALYSIS_R_LEG,TRAIT_PARALYSIS_L_LEG))

/datum/reagent/consumable/ethanol/neurotoxin/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(50)
	M.dizziness +=2
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1*REM, 150)
	if(prob(20))
		M.adjustStaminaLoss(10)
		M.drop_all_held_items()
		to_chat(M, "<span class='notice'>You cant feel your hands!</span>")
	if(current_cycle > 5)
		if(prob(20))
			var/t = pickt()
			ADD_TRAIT(M, t, type)
			M.adjustStaminaLoss(10)
		if(current_cycle > 30)
			M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2*REM)
			if(current_cycle > 50 && prob(15))
				if(!M.undergoing_cardiac_arrest() && M.can_heartattack())
					M.set_heartattack(TRUE)
					if(M.stat == CONSCIOUS)
						M.visible_message("<span class='userdanger'>[M] clutches at [M.p_their()] chest as if [M.p_their()] heart stopped!</span>")
	. = 1
	..()

/datum/reagent/consumable/ethanol/neurotoxin/on_mob_end_metabolize(mob/living/carbon/M)
	REMOVE_TRAIT(M, TRAIT_PARALYSIS_L_ARM, type)
	REMOVE_TRAIT(M, TRAIT_PARALYSIS_R_ARM, type)
	REMOVE_TRAIT(M, TRAIT_PARALYSIS_R_LEG, type)
	REMOVE_TRAIT(M, TRAIT_PARALYSIS_L_LEG, type)
	M.adjustStaminaLoss(10)
	..()

/datum/reagent/consumable/ethanol/triple_sec
	name = "Triple Sec"
	description = "A sweet and vibrant orange liqueur."
	color = "#ffcc66"
	boozepwr = 30
	taste_description = "a warm flowery orange taste which recalls the ocean air and summer wind of the caribbean"
	glass_icon_state = "glass_orange"
	glass_name = "Triple Sec"
	glass_desc = "A glass of straight Triple Sec."

/datum/reagent/consumable/ethanol/creme_de_menthe
	name = "Creme de Menthe"
	description = "A minty liqueur excellent for refreshing, cool drinks."
	color = "#00cc00"
	boozepwr = 20
	taste_description = "a minty, cool, and invigorating splash of cold streamwater"
	glass_icon_state = "glass_green"
	glass_name = "Creme de Menthe"
	glass_desc = "You can almost feel the first breath of spring just looking at it."

/datum/reagent/consumable/ethanol/creme_de_cacao
	name = "Creme de Cacao"
	description = "A chocolatey liqueur excellent for adding dessert notes to beverages and bribing sororities."
	color = "#996633"
	boozepwr = 20
	taste_description = "a slick and aromatic hint of chocolates swirling in a bite of alcohol"
	glass_icon_state = "glass_brown"
	glass_name = "Creme de Cacao"
	glass_desc = "A million hazing lawsuits and alcohol poisonings have started with this humble ingredient."

/datum/reagent/consumable/ethanol/creme_de_coconut
	name = "Creme de Coconut"
	description = "A coconut liqueur for smooth, creamy, tropical drinks."
	color = "#F7F0D0"
	boozepwr = 20
	taste_description = "a sweet milky flavor with notes of toasted sugar"
	glass_icon_state = "glass_white"
	glass_name = "Creme de Coconut"
	glass_desc = "An unintimidating glass of coconut liqueur."

/datum/reagent/consumable/ethanol/grasshopper
	name = "Grasshopper"
	description = "A fresh and sweet dessert shooter. Difficult to look manly while drinking this."
	color = "#00ff00"
	boozepwr = 25
	quality = DRINK_GOOD
	taste_description = "chocolate and mint dancing around your mouth"
	glass_icon_state = "grasshopper"
	glass_name = "Grasshopper"
	glass_desc = "You weren't aware edible beverages could be that green."

/datum/reagent/consumable/ethanol/stinger
	name = "Stinger"
	description = "A snappy way to end the day."
	color = "#ccff99"
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "a slap on the face in the best possible way"
	glass_icon_state = "stinger"
	glass_name = "Stinger"
	glass_desc = "You wonder what would happen if you pointed this at a heat source..."

/datum/reagent/consumable/ethanol/sugar_rush
	name = "Sugar Rush"
	description = "Sweet, light, and fruity - as girly as it gets."
	color = "#FF226C"
	boozepwr = 10
	quality = DRINK_GOOD
	taste_description = "your arteries clogging with sugar"
	nutriment_factor = 2 * REAGENTS_METABOLISM
	glass_icon_state = "sugar_rush"
	glass_name = "Sugar Rush"
	glass_desc = "If you can't mix a Sugar Rush, you can't tend bar."

/datum/reagent/consumable/ethanol/sugar_rush/on_mob_life(mob/living/carbon/M)
	M.satiety -= 10 //junky as hell! a whole glass will keep you from being able to eat junk food
	..()
	. = TRUE

/datum/reagent/consumable/ethanol/sake
	name = "Sake"
	description = "A sweet rice wine of questionable legality and extreme potency."
	color = "#C05067" // rgb : 192, 080, 103
	boozepwr = 70
	taste_description = "sweet rice wine"
	glass_icon_state = "sakecup"
	glass_name = "cup of sake"
	glass_desc = "A traditional cup of sake."

/datum/reagent/consumable/ethanol/alexander
	name = "Alexander"
	description = "Named after a Greek hero, this mix is said to embolden a user's shield as if they were in a phalanx."
	color = "#F5E9D3"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "bitter, creamy cacao"
	glass_icon_state = "alexander"
	glass_name = "Alexander"
	glass_desc = "A creamy, indulgent delight that is stronger than it seems."
	var/obj/item/shield/mighty_shield

/datum/reagent/consumable/ethanol/alexander/on_mob_metabolize(mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/thehuman = L
		for(var/obj/item/shield/theshield in thehuman.contents)
			mighty_shield = theshield
			mighty_shield.block_chance += 10
			to_chat(thehuman, "<span class='notice'>[theshield] appears polished, although you don't recall polishing it.</span>")
			return TRUE

/datum/reagent/consumable/ethanol/alexander/on_mob_life(mob/living/L)
	..()
	if(mighty_shield && !(mighty_shield in L.contents)) //If you had a shield and lose it, you lose the reagent as well. Otherwise this is just a normal drink.
		holder.remove_reagent(type)

/datum/reagent/consumable/ethanol/alexander/on_mob_end_metabolize(mob/living/L)
	if(mighty_shield)
		mighty_shield.block_chance -= 10
		to_chat(L,"<span class='notice'>You notice [mighty_shield] looks worn again. Weird.</span>")
	..()

/datum/reagent/consumable/ethanol/sidecar
	name = "Sidecar"
	description = "The one ride you'll gladly give up the wheel for."
	color = "#FFC55B"
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "delicious freedom"
	glass_icon_state = "sidecar"
	glass_name = "Sidecar"
	glass_desc = "The one ride you'll gladly give up the wheel for."

/datum/reagent/consumable/ethanol/between_the_sheets
	name = "Between the Sheets"
	description = "A provocatively named classic. Funny enough, doctors recommend drinking it before taking a nap."
	color = "#F4C35A"
	boozepwr = 55
	quality = DRINK_GOOD
	taste_description = "seduction"
	glass_icon_state = "between_the_sheets"
	glass_name = "Between the Sheets"
	glass_desc = "The only drink that comes with a label reminding you of Nanotrasen's zero-tolerance promiscuity policy."

/datum/reagent/consumable/ethanol/between_the_sheets/on_mob_life(mob/living/L)
	..()
	if(L.IsSleeping())
		if(L.getBruteLoss() && L.getFireLoss()) //If you are damaged by both types, slightly increased healing but it only heals one. The more the merrier wink wink.
			if(prob(50))
				L.adjustBruteLoss(-0.25)
			else
				L.adjustFireLoss(-0.25)
		else if(L.getBruteLoss()) //If you have only one, it still heals but not as well.
			L.adjustBruteLoss(-0.2)
		else if(L.getFireLoss())
			L.adjustFireLoss(-0.2)

/datum/reagent/consumable/ethanol/kamikaze
	name = "Kamikaze"
	description = "Divinely windy."
	color = "#EEF191"
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "divine windiness"
	glass_icon_state = "kamikaze"
	glass_name = "Kamikaze"
	glass_desc = "Divinely windy."

/datum/reagent/consumable/ethanol/mojito
	name = "Mojito"
	description = "A drink that looks as refreshing as it tastes."
	color = "#77C942" // rgb: 119, 201, 067
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "refreshing mint"
	glass_icon_state = "mojito"
	glass_name = "Mojito"
	glass_desc = "A drink that looks as refreshing as it tastes."
	empty_glass_icon_state = "collins_glass"

/datum/reagent/consumable/ethanol/moscow_mule
	name = "Moscow Mule"
	description = "A chilly drink that reminds you of the Derelict."
	color = "#EEF1AA"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "refreshing spiciness"
	glass_icon_state = "moscow_mule"
	glass_name = "Moscow Mule"
	glass_desc = "A chilly drink that reminds you of the Derelict."

/datum/reagent/consumable/ethanol/fernet
	name = "Fernet"
	description = "An incredibly bitter herbal liqueur used as a digestif."
	color = "#1B2E24" // rgb: 27, 46, 36
	boozepwr = 80
	taste_description = "utter bitterness"
	glass_name = "glass of fernet"
	glass_desc = "A glass of pure Fernet. Only an absolute madman would drink this alone." //Hi Kevum

/datum/reagent/consumable/ethanol/fernet/on_mob_life(mob/living/carbon/M)
	if(M.nutrition <= NUTRITION_LEVEL_STARVING)
		M.adjustToxLoss(1*REM, 0)
	M.adjust_nutrition(-5)
	M.overeatduration = 0
	return ..()

/datum/reagent/consumable/ethanol/fernet_cola
	name = "Fernet Cola"
	description = "A very popular and bittersweet digestif, ideal after a heavy meal. Best served on a sawed-off cola bottle as per tradition."
	color = "#390600" // rgb: 57, 6,
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "sweet relief"
	glass_icon_state = "godlyblend"
	glass_name = "glass of fernet cola"
	glass_desc = "A sawed-off cola bottle filled with Fernet Cola. Nothing better after eating like a lardass."

/datum/reagent/consumable/ethanol/fernet_cola/on_mob_life(mob/living/carbon/M)
	if(M.nutrition <= NUTRITION_LEVEL_STARVING)
		M.adjustToxLoss(0.5*REM, 0)
	M.adjust_nutrition(- 3)
	M.overeatduration = 0
	return ..()

/datum/reagent/consumable/ethanol/fanciulli

	name = "Fanciulli"
	description = "What if the Manhattan cocktail ACTUALLY used a bitter herb liquour? Helps you sober up." //also causes a bit of stamina damage to symbolize the afterdrink lazyness
	color = "#CA933F" // rgb: 202, 147, 63
	boozepwr = -10
	quality = DRINK_NICE
	taste_description = "a sweet sobering mix"
	glass_icon_state = "fanciulli"
	glass_name = "glass of fanciulli"
	glass_desc = "A glass of Fanciulli. It's just Manhattan with Fernet."

/datum/reagent/consumable/ethanol/fanciulli/on_mob_life(mob/living/carbon/M)
	M.adjust_nutrition(-5)
	M.overeatduration = 0
	return ..()

/datum/reagent/consumable/ethanol/fanciulli/on_mob_metabolize(mob/living/M)
	if(M.health > 0)
		M.adjustStaminaLoss(20)
		. = TRUE
	..()

/datum/reagent/consumable/ethanol/fruit_wine
	name = "Fruit Wine"
	description = "A wine made from grown plants."
	color = "#FFFFFF"
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "bad coding"
	can_synth = FALSE
	var/list/names = list("null fruit" = 1) //Names of the fruits used. Associative list where name is key, value is the percentage of that fruit.
	var/list/tastes = list("bad coding" = 1) //List of tastes. See above.

/datum/reagent/consumable/ethanol/fruit_wine/on_new(list/data)
	names = data["names"]
	tastes = data["tastes"]
	boozepwr = data["boozepwr"]
	color = data["color"]
	generate_data_info(data)

/datum/reagent/consumable/ethanol/fruit_wine/on_merge(list/data, amount)
	var/diff = (amount/volume)
	if(diff < 1)
		color = BlendRGB(color, data["color"], diff/2) //The percentage difference over two, so that they take average if equal.
	else
		color = BlendRGB(color, data["color"], (1/diff)/2) //Adjust so it's always blending properly.
	var/oldvolume = volume-amount

	var/list/cachednames = data["names"]
	for(var/name in names | cachednames)
		names[name] = ((names[name] * oldvolume) + (cachednames[name] * amount)) / volume

	var/list/cachedtastes = data["tastes"]
	for(var/taste in tastes | cachedtastes)
		tastes[taste] = ((tastes[taste] * oldvolume) + (cachedtastes[taste] * amount)) / volume

	boozepwr *= oldvolume
	var/newzepwr = data["boozepwr"] * amount
	boozepwr += newzepwr
	boozepwr /= volume //Blending boozepwr to volume.
	generate_data_info(data)

/datum/reagent/consumable/ethanol/fruit_wine/proc/generate_data_info(list/data)
	var/minimum_percent = 0.15 //Percentages measured between 0 and 1.
	var/list/primary_tastes = list()
	var/list/secondary_tastes = list()
	glass_name = "glass of [name]"
	glass_desc = description
	for(var/taste in tastes)
		if(tastes[taste] >= minimum_percent*2)
			primary_tastes += taste
		else if(tastes[taste] >= minimum_percent && tastes[taste] < minimum_percent*2)
			secondary_tastes += taste

	var/minimum_name_percent = 0.35
	name = ""
	var/list/names_in_order = sortTim(names, GLOBAL_PROC_REF(cmp_numeric_dsc), TRUE)
	var/named = FALSE
	for(var/fruit_name in names)
		if(names[fruit_name] >= minimum_name_percent)
			name += "[fruit_name] "
			named = TRUE
	if(named)
		name += "wine"
	else
		name = "mixed [names_in_order[1]] wine"

	var/alcohol_description
	switch(boozepwr)
		if(120 to INFINITY)
			alcohol_description = "suicidally strong"
		if(90 to 120)
			alcohol_description = "rather strong"
		if(70 to 90)
			alcohol_description = "strong"
		if(40 to 70)
			alcohol_description = "rich"
		if(20 to 40)
			alcohol_description = "mild"
		if(0 to 20)
			alcohol_description = "sweet"
		else
			alcohol_description = "watery" //How the hell did you get negative boozepwr?

	var/list/fruits = list()
	if(names_in_order.len <= 3)
		fruits = names_in_order
	else
		for(var/i in 1 to 3)
			fruits += names_in_order[i]
		fruits += "other plants"
	var/fruit_list = english_list(fruits)
	description = "A [alcohol_description] wine brewed from [fruit_list]."

	var/flavor = ""
	if(!primary_tastes.len)
		primary_tastes = list("[alcohol_description] alcohol")
	flavor += english_list(primary_tastes)
	if(secondary_tastes.len)
		flavor += ", with a hint of "
		flavor += english_list(secondary_tastes)
	taste_description = flavor


/datum/reagent/consumable/ethanol/champagne //How the hell did we not have champagne already!?
	name = "Champagne"
	description = "A sparkling wine known for its ability to strike fast and hard."
	color = "#ffffc1"
	boozepwr = 40
	taste_description = "auspicious occasions and bad decisions"
	glass_icon_state = "champagne_glass"
	glass_name = "Champagne"
	glass_desc = "The flute clearly displays the slowly rising bubbles."


/datum/reagent/consumable/ethanol/applejack
	name = "Applejack"
	description = "The perfect beverage for when you feel the need to horse around."
	color = "#ff6633"
	boozepwr = 20
	taste_description = "an honest day's work at the orchard"
	glass_icon_state = "applejack_glass"
	glass_name = "Applejack"
	glass_desc = "You feel like you could drink this all neight."

/datum/reagent/consumable/ethanol/painkiller
	name = "Painkiller"
	description = "Dulls your pain. Your emotional pain, that is."
	boozepwr = 20
	color = "#EAD677"
	quality = DRINK_NICE
	taste_description = "sugary tartness"
	glass_icon_state = "painkiller"
	glass_name = "Painkiller"
	glass_desc = "A combination of tropical juices and rum. Surely this will make you feel better."

/datum/reagent/consumable/ethanol/pina_colada
	name = "Pina Colada"
	description = "A fresh pineapple drink with coconut rum. Yum."
	boozepwr = 40
	color = "#FFF1B2"
	quality = DRINK_FANTASTIC
	taste_description = "pineapple, coconut, and a hint of the ocean"
	glass_icon_state = "pina_colada"
	glass_name = "Pina Colada"
	glass_desc = "If you like pina coladas, and getting caught in the rain... well, you'll like this drink."


/datum/reagent/consumable/ethanol/pruno // pruno mix is in drink_reagents
	name = "pruno"
	color = "#E78108"
	description = "Fermented prison wine made from fruit, sugar, and despair. Security loves to confiscate this, which is the only kind thing Security has ever done."
	boozepwr = 85
	taste_description = "your tastebuds being individually shanked"
	glass_icon_state = "glass_orange"
	glass_name = "glass of pruno"
	glass_desc = "Fermented prison wine made from fruit, sugar, and despair. Security loves to confiscate this, which is the only kind thing Security has ever done."

/datum/reagent/consumable/ethanol/pruno/on_mob_life(mob/living/carbon/M)
	M.adjust_disgust(5)
	..()
