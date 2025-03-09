/datum/action/gift
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	button_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS
	var/rage_req = 0
	var/gnosis_req = 0

/datum/action/gift/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	button_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	. = ..()

/datum/action/gift/Trigger()
	. = ..()
	to_chat(owner, "<span class='notice'>You activate the [name]...</span>")

/datum/action/gift/falling_touch
	name = "Falling Touch"
	desc = "This Gift allows the Garou to send her foe sprawling with but a touch."
	button_icon_state = "falling_touch"
	rage_req = 1

/datum/action/gift/falling_touch/Trigger()
	. = ..()
	if(allowed_to_proceed)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/falling_touch.ogg', 75, FALSE)

/datum/action/gift/inspiration
	name = "Inspiration"
	desc = "The Garou with this Gift lends new resolve and righteous anger to his brethren."
	button_icon_state = "inspiration"
	rage_req = 1

/datum/action/gift/inspiration/Trigger()
	. = ..()
	//PSEUDO_M make datum process

/datum/action/gift/razor_claws
	name = "Razor Claws"
	desc = "By raking his claws over stone, steel, or another hard surface, the Ahroun hones them to razor sharpness."
	button_icon_state = "razor_claws"
	rage_req = 1

/datum/action/gift/razor_claws/Trigger()
	. = ..()
	//PSEUDO_M +dam +agg

/datum/action/gift/beast_speech
	name = "Beast Speech"
	desc = "The werewolf with this Gift may communicate with any animals from fish to mammals."
	button_icon_state = "beast_speech"

/datum/action/gift/beast_speech/Trigger()
	. = ..()
	//PSEUDO_M make this a passive gift instead of needing to be trigger

/datum/action/gift/call_of_the_wyld
	name = "Call Of The Wyld"
	desc = "The werewolf may send her howl far beyond the normal range of hearing and imbue it with great emotion, stirring the hearts of fellow Garou and chilling the bones of all others."
	button_icon_state = "call_of_the_wyld"
	//PSEUDO_M shouldn't need to have a cost

/datum/action/gift/call_of_the_wyld/Trigger()
	. = ..()


/datum/action/gift/mindspeak
	name = "Mindspeak"
	desc = "By invoking the power of waking dreams, the Garou can place any chosen characters into silent communion."
	button_icon_state = "mindspeak"

/datum/action/gift/mindspeak/Trigger()
	. = ..()
	//PSEUDO_M slimelink?

/datum/action/gift/resist_pain
	name = "Resist Pain"
	desc = "Through force of will, the Philodox is able to ignore the pain of his wounds and continue acting normally."
	button_icon_state = "resist_pain"

/datum/action/gift/resist_pain/Trigger()
	. = ..()
	//PSEUDO_M status and TRAITs

/datum/action/gift/scent_of_the_true_form
	name = "Scent Of The True Form"
	desc = "This Gift allows the Garou to determine the true nature of a person."
	button_icon_state = "scent_of_the_true_form"

/datum/action/gift/scent_of_the_true_form/Trigger()
	. = ..()
	//PSEUDO_M shouldn't this just be always on for garou

/datum/action/gift/truth_of_gaia
	name = "Truth Of Gaia"
	desc = "As judges of the Litany, Philodox have the ability to sense whether others have spoken truth or falsehood."
	button_icon_state = "truth_of_gaia"

/datum/action/gift/mothers_touch
	name = "Mother's Touch"
	desc = "The Garou is able to heal the wounds of any living creature, aggravated or otherwise, simply by laying hands over the afflicted area."
	button_icon_state = "mothers_touch"

/datum/action/gift/mothers_touch/Trigger()
	. = ..()
	//PSEUDO_M healing touch

/datum/action/gift/spirit_speech
	name = "Spirit Speech"
	desc = "This Gift allows the Garou to communicate with encountered spirits."
	button_icon_state = "spirit_speech"

/datum/action/gift/spirit_speech/Trigger()
	. = ..()


/datum/action/gift/blur_of_the_milky_eye
	name = "Blur Of The Milky Eye"
	desc = "The Garou's form becomes a shimmering blur, allowing him to pass unnoticed among others."
	button_icon_state = "blur_of_the_milky_eye"

/datum/action/gift/blur_of_the_milky_eye/Trigger()
	. = ..()
	//PSEUDO_M wolf obfuscate

/datum/action/gift/open_seal
	name = "Open Seal"
	desc = "With this Gift, the Garou can open nearly any sort of closed or locked physical device."
	button_icon_state = "open_seal"
	//PSEUDO_M wolf knock

/datum/action/gift/open_seal/Trigger()
	. = ..()


/datum/action/gift/infectious_laughter
	name = "Infectious Laughter"
	desc = "When the Ragabash laughs, those around her are compelled to follow along, forgetting their grievances."
	button_icon_state = "infectious_laughter"

/datum/action/gift/infectious_laughter/Trigger()
	. = ..()
	//PSEUDO_M trigger stun roll on laugh

/datum/action/gift/rage_heal
	name = "Rage Heal"
	desc = "This Gift allows the Garou to heal severe injuries with rage."
	button_icon_state = "rage_heal"
	//PSEUDO_M wolf bloodheal...

/datum/action/gift/rage_heal/Trigger()
	. = ..()


/datum/action/change_apparel
	name = "Change Apparel"
	desc = "Choose the clothes of your Crinos form."
	button_icon_state = "choose_apparel"
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS

/datum/action/change_apparel/Trigger()
	. = ..()

/datum/action/gift/hispo
	name = "Hispo Form"
	desc = "Change your Lupus form into Hispo and backwards."
	button_icon_state = "hispo"

/datum/action/gift/hispo/Trigger()
	. = ..()


/datum/action/gift/glabro
	name = "Glabro Form"
	desc = "Change your Homid form into Glabro and backwards."
	button_icon_state = "glabro"

/datum/action/gift/glabro/Trigger()
	. = ..()
