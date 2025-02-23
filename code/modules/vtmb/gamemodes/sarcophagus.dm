GLOBAL_LIST_INIT(sarcophagus_passwords, list(
	"AMARANTH",
	"ANTEDILUVIAN",
	"PROMETHEAN",
	"NEMESIS",
	"GEHENNA",
	"JYHAD",
	"CARTHAGOS",
	"ENOCH",
	"IRAD",
	"ZILLAH",
	"CAPPADOCIAN",
	"NODDIST",
	"USURPERS",
	"DELUGE",
	"SHADOWLANDS",
	"LILITH",
	"FORGIVENESS",
	"DARKFATHER"
))
GLOBAL_LIST_INIT(caesar_cipher, list(
	"A" = 1,
	"B" = 2,
	"C" = 3,
	"D" = 4,
	"E" = 5,
	"F" = 6,
	"G" = 7,
	"H" = 8,
	"I" = 9,
	"J" = 10,
	"K" = 11,
	"L" = 12,
	"M" = 13,
	"N" = 14,
	"O" = 15,
	"P" = 16,
	"Q" = 17,
	"R" = 18,
	"S" = 19,
	"T" = 20,
	"U" = 21,
	"V" = 22,
	"W" = 23,
	"X" = 24,
	"Y" = 25,
	"Z" = 26
))

/proc/get_encipher_num(var/letter, var/password)
	var/num = GLOB.caesar_cipher[letter]
	var/enciphed = num+password
	if(num+password > 26)
		enciphed = (num+password)-26
	return GLOB.caesar_cipher[enciphed]

/proc/get_uncipher_num(var/letter, var/password)
	var/num = GLOB.caesar_cipher[letter]
	var/unciphed = num-password
	if(num-password < 0)
		unciphed = (num-password)+26
	return GLOB.caesar_cipher[unciphed]

/proc/encipher(var/message, var/password)
	if(message)
		message = uppertext(message)
		var/final_message = ""
		for(var/i in 1 to length_char(message))
			var/letter = message[i]
			final_message += "[get_encipher_num(letter, password)]"
		return final_message

/proc/uncipher(var/message, var/password)
	if(message)
		message = uppertext(message)
		var/final_message = ""
		for(var/i in 1 to length_char(message))
			var/letter = message[i]
			final_message += "[get_uncipher_num(letter, password)]"
		return final_message

/obj/sarcophagus/examine(mob/user)
	. = ..()
	. += "You see an engraved text on it: <b>[encipher(password, passkey)]<b>. You have no clue what that could possibly mean..."

/obj/sarcophagus
	name = "Unknown Sarcophagus"
	desc = "Contains elder devil..."
	icon = 'icons/wod13/48x32weapons.dmi'
	icon_state = "b_sarcophagus"
	plane = GAME_PLANE
	layer = CAR_LAYER
	density = TRUE
	pixel_w = -8
	var/password = "Brongus"
	var/passkey = 5

/obj/sarcophagus/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/sarcophagus_key))
		var/pass = input(user, "???") as text|null
		if(pass)
			if(password == uppertext(pass))
				icon_state = "b_sarcophagus-open1"
				to_chat(world, "<span class='userdanger'><b>UNKNOWN SARCOPHAGUS HAS BEEN OPENED</b></span>")
				SEND_SOUND(world, sound('code/modules/wod13/sounds/announce.ogg'))
				playsound(get_turf(src), 'code/modules/wod13/sounds/mp_hello.ogg', 100, TRUE)
				spawn(200)
					icon_state = "b_sarcophagus-open0"
					new /mob/living/simple_animal/hostile/megafauna/wendigo(loc)

/obj/sarcophagus/Initialize()
	. = ..()
	password = pick(GLOB.sarcophagus_passwords)
	if(prob(50))
		passkey = rand(5, 15)
	else
		passkey = rand(-15, -5)
	//to_chat(world, "<span class='userdanger'><b>UNKNOWN SARCOPHAGUS POSITION HAS BEEN LEAKED</b></span>")
	SEND_SOUND(world, sound('code/modules/wod13/sounds/announce.ogg'))

/obj/item/sarcophagus_key
	name = "sarcophagus key"
	desc = "The secrets of elder devil..."
	icon_state = "sarcophagus_key"
	icon = 'icons/wod13/icons.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/fake_sarcophagus
	name = "Voivode-in-Waiting's Sarcophagus"
	desc = "The Voivode-in-Waiting lies here."
	icon = 'icons/wod13/48x32weapons.dmi'
	icon_state = "b_sarcophagus"
	density = TRUE
	anchored = TRUE
	pixel_w = -8
