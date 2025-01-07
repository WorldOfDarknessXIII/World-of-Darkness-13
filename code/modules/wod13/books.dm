/obj/item/vampirebook
	name = "a book"
	desc = "So full of knowledge"
	icon_state = "book"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/quote = "Hm... This book is boring."
	COOLDOWN_DECLARE(read)

/obj/item/vampirebook/proc/read_book(mob/living/carbon/human/user)
	quote = "Hm... this book is boring."

/obj/item/vampirebook/attack_self(mob/living/carbon/human/user)
	if(!COOLDOWN_FINISHED(src, read))
		return
	read_book(user)
	user.say(quote)
	var/original_icon_state = icon_state
	icon_state = "[original_icon_state]-1"
	COOLDOWN_START(src, read, 10 SECONDS)
	spawn(10 SECONDS)
		icon_state = original_icon_state

/obj/item/vampirebook/lilith
	name = "dark mother's revelations"
	icon_state = "revelationsofdarkmother"

/obj/item/vampirebook/lilith/read_book(mob/living/carbon/human/user)
	quote = pick(GLOB.bahari_quotes)

/obj/item/vampirebook/noddist
	name = "book of Nod"
	icon_state = "bookofnod"

/obj/item/vampirebook/noddist/read_book(mob/living/carbon/human/user)
	quote = pick(GLOB.noddist_quotes)

/obj/item/vampirebook/quran
	name = "Quran"
	icon_state = "quran"
/obj/item/vampirebook/quran/read_book(mob/living/carbon/human/user)
	quote = pick(GLOB.quran_quotes)
