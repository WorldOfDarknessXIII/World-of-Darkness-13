/mob/living/carbon/human/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	. = ..()
	if(message)
//		if(istype(loc, /obj/effect/dummy/chameleon))
//			var/obj/effect/dummy/chameleon/C = loc
//			C.say("[message]")
//			return
		if(length(GLOB.auspex_list))
			for(var/mob/living/carbon/human/H in GLOB.auspex_list)
				if(H)
					to_chat(H, "<span class='scream_away'><b>[name]</b> says, \"[sanitize_text(message)]\"</span>")

		var/malkavian = FALSE
		if(iskindred(src))
			if(clane)
				if(clane.name == "Malkavian")
					malkavian = TRUE
					
		if(malkavian)
			
			var/dementation_level = src.client.prefs.discipline_levels[src.client.prefs.discipline_types.Find(/datum/discipline/dementation)]
			
			var/probability = max(0, 40 - (dementation_level * 5)) // Começa com 35% e reduz 5% por nível
			
			if(prob(probability))
				message_admins("[ADMIN_LOOKUPFLW(usr)] Dementation PROB PASSED: [probability]%")
				for(var/mob/living/carbon/human/H in GLOB.malkavian_list)
					if(H)
						var/datum/preferences/H_client = H.client.prefs
					
						var/H_generation = H_client.generation
					
						var/index = H_client.discipline_types.Find(/datum/discipline/auspex)
					
						var/font_size = 13 + (13 - H_generation)
						font_size = clamp(font_size, 13, 25) 
					
						var/base_message = message
						var/sanitized_message = sanitize_text(base_message) 
						
						if(index)
							var/auspex_level = H_client.discipline_levels[index]
					
							var/encrypted_message = encrypt_message(sanitized_message, auspex_level)
					
							
							var/styled_message = "<span style='font-size:[font_size]px;'>[encrypted_message]</span>"
							
							to_chat(H, "<span class='ghostalert'>AUSPEX LEVEL: [auspex_level]</span>")
							to_chat(H, "<span class='ghostalert'>[styled_message]</span>")

proc/encrypt_message(message, auspex_level)
	if(auspex_level == 1)
		return scramble_text(message, 50) // 50% of the text will be confusing
	else if(auspex_level == 2)
		return scramble_text(message, 40) // 40% of the text will be confusing
	else if(auspex_level == 3)
		return scramble_text(message, 30) // 30% of the text will be confusing
	else if(auspex_level == 4)
		return scramble_text(message, 20) // 20% of the text will be confusing
	else if(auspex_level == 5)
		return scramble_text(message, 10) // 10% of the text will be confusing
	else
		return message
		


proc/scramble_text(text, scramble_percentage)

	var/list/random_words = list(
		"HELP", "Help", "help",
		"HERE", "Here", "here",
		"CRAZY", "Crazy", "crazy",
		"RUN", "Run", "run",
		"STOP", "Stop", "stop",
		"GO", "Go", "go",
		"FAST", "Fast", "fast",
		"SLOW", "Slow", "slow",
		"NOW", "Now", "now",
		"YES", "Yes", "yes",
		"NO", "No", "no",
		"UP", "Up", "up",
		"DOWN", "Down", "down",
		"LEFT", "Left", "left",
		"RIGHT", "Right", "right",
		"OPEN", "Open", "open",
		"CLOSE", "Close", "close",
		"ON", "On", "on",
		"OFF", "Off", "off",
		"BIG", "Big", "big",
		"SMALL", "Small", "small",
		"HAPPY", "Happy", "happy",
		"SAD", "Sad", "sad",
		"ANGRY", "Angry", "angry",
		"FUNNY", "Funny", "funny",
		"BORING", "Boring", "boring",
		"QUIET", "Quiet", "quiet",
		"LOUD", "Loud", "loud",
		"HOT", "Hot", "hot",
		"COLD", "Cold", "cold",
		"SAFE", "Safe", "safe",
		"DANGER", "Danger", "danger",
		"HIGH", "High", "high",
		"LOW", "Low", "low",
		"EARLY", "Early", "early",
		"LATE", "Late", "late",
		"LIGHT", "Light", "light",
		"DARK", "Dark", "dark",
		"EMPTY", "Empty", "empty",
		"FULL", "Full", "full",
		"GOOD", "Good", "good",
		"BAD", "Bad", "bad",
		"EASY", "Easy", "easy",
		"HARD", "Hard", "hard",
		"NEW", "New", "new",
		"OLD", "Old", "old",
		"BRIGHT", "Bright", "bright",
		"DIM", "Dim", "dim",
		"SHARP", "Sharp", "sharp",
		"DULL", "Dull", "dull",
		"NEAR", "Near", "near",
		"FAR", "Far", "far",
		"CLEAR", "Clear", "clear",
		"BLURRY", "Blurry", "blurry",
		"TRUE", "True", "true",
		"FALSE", "False", "false",
		"WARM", "Warm", "warm",
		"COOL", "Cool", "cool",
		"DEEP", "Deep", "deep",
		"SHALLOW", "Shallow", "shallow",
		"CLEAN", "Clean", "clean",
		"DIRTY", "Dirty", "dirty",
		"THICK", "Thick", "thick",
		"THIN", "Thin", "thin",
		"STRONG", "Strong", "strong",
		"WEAK", "Weak", "weak",
		"RICH", "Rich", "rich",
		"POOR", "Poor", "poor",
		"SMART", "Smart", "smart",
		"DUMB", "Dumb", "dumb",
		"QUICK", "Quick", "quick",
		"SLOW", "Slow", "slow",
		"NICE", "Nice", "nice",
		"MEAN", "Mean", "mean",
		"HEAVY", "Heavy", "heavy",
		"LIGHTWEIGHT", "Lightweight", "lightweight",
		"SOFT", "Soft", "soft",
		"HARD", "Hard", "hard",
		"WET", "Wet", "wet",
		"DRY", "Dry", "dry",
		"TIGHT", "Tight", "tight",
		"LOOSE", "Loose", "loose",
		"SHINY", "Shiny", "shiny",
		"ROUGH", "Rough", "rough",
		"SMOOTH", "Smooth", "smooth",
		"LOUD", "Loud", "loud",
		"QUIET", "Quiet", "quiet",
		"BRIGHT", "Bright", "bright",
		"DIM", "Dim", "dim",
		"HARD", "Hard", "hard",
		"EASY", "Easy", "easy",
		"TRUE", "True", "true",
		"FALSE", "False", "false",
		"BIG", "Big", "big",
		"SMALL", "Small", "small",
		"HUGE", "Huge", "huge",
		"TINY", "Tiny", "tiny",
		"FAST", "Fast", "fast",
		"SLOW", "Slow", "slow",
		"HIGH", "High", "high",
		"LOW", "Low", "low",
		"LONG", "Long", "long",
		"SHORT", "Short", "short",
		"HARD", "Hard", "hard",
		"SOFT", "Soft", "soft",
		"OLD", "Old", "old",
		"NEW", "New", "new",
		"COOL", "Cool", "cool",
		"HOT", "Hot", "hot",
		"GOOD", "Good", "good",
		"BAD", "Bad", "bad",
		"HAPPY", "Happy", "happy",
		"SAD", "Sad", "sad",
		"SAFE", "Safe", "safe",
		"DANGEROUS", "Dangerous", "dangerous",
		"CLEAN", "Clean", "clean",
		"DIRTY", "Dirty", "dirty",
		"EARLY", "Early", "early",
		"LATE", "Late", "late",
		"DEEP", "Deep", "deep",
		"SHALLOW", "Shallow", "shallow",
		"SHARP", "Sharp", "sharp",
		"DULL", "Dull", "dull",
		"WARM", "Warm", "warm",
		"COLD", "Cold", "cold",
		"BRIGHT", "Bright", "bright",
		"DARK", "Dark", "dark",
		"LOUD", "Loud", "loud",
		"QUIET", "Quiet", "quiet",
		"THICK", "Thick", "thick",
		"THIN", "Thin", "thin",
		"SMOOTH", "Smooth", "smooth",
		"ROUGH", "Rough", "rough",
		"HUGE", "Huge", "huge",
		"TINY", "Tiny", "tiny",
		"SABBAT", "Sabbat", "sabbat",
		"ANARCH", "Anarch", "anarch",
		"CAMARILLA", "Camarilla", "camarilla",
		"SABBATS", "Sabbat", "sabbats",
		"ANARCHS", "Anarch", "anarch",
		"PRINCE", "Prince", "prince",
		"PRIMOGEN", "Primogen", "primogen",
		"SHERIFF", "Sheriff", "sheriff",
		"SENESCHAL", "Seneschal", "seneschal",
		"SCOURGE", "Scourge", "scourge",
		"BARON", "Baron", "baron",
		"KIN", "Kin", "kin",
		"KINDRED", "Kindred", "kin",
		"GAROU", "Garou", "garou",
		"CAITIFF", "Caitiff", "caitiff",
		"DISCIPLINES", "Disciplines", "disciplines",
		"MALK", "Malk", "malk",
		"US", "Us", "us",
		"WE", "We", "we",
		"CONTROL", "Control", "control",
		"I", "i", "I'am",
		"HE", "He", "he",
		"SHE", "She", "she",
		"IT", "It", "it",
		"THEY", "They", "they",
		"DID", "Did", "did",
		"DO", "Do", "do",
		"THEM", "Them", "them",
		"DIABLERIE", "Diablerie", "diablerie",
		"BLOOD", "Blood", "blood",
		"THEY", "They", "they",
		"ANTEDILUVIAN", "Antediluvian", "antediluvian",
		"METHUSELAH", "Methuselah", "methuselah",
		"ELDER", "Elder", "elder",
		"ANCILLA", "Ancilla", "ancilla",
		"NEONATE", "Neonate", "neonate",
		"ELYSIUM", "Elysium", "elysium",
		"MASQUERADE", "Masquerade", "masquerade",
		"GHOUL", "Ghoul", "ghoul",
		"BEHIND", "Behind", "behind",
		"YOU", "You", "you",
		"ARE", "Are", "are",
		"WERE", "Were", "were",
		"WAS", "Was", "was",
		"KILL", "Kill", "kill",
		"KILLED", "Killed", "killed",
		"MURDER", "Murder", "murder",
		"MURDER", "Murder", "murder",
		"MURDER", "Murder", "murder",
		"EMBRACE", "Embrace", "embrace",
		"DEAD", "Dead", "dead",
		"DEATH", "Death", "death",
		"FINAL", "Final", "final",
		"HAVEN", "Haven", "haven",
		"HUNTER", "Hunter", "hunter",
		"PRIEST", "Priest", "priest",
		"CAIN", "Cain", "cain",
		"TAXI", "Taxi", "taxi",
		"DRIVER", "Driver", "driver",
		"A", "a", "an",
		"AN", "The", "the",
		"THE", "The", "the",
		"IN", "In", "in",
		"ON", "On", "on",
		"AT", "At", "at",
		"HUNT", "Hunt", "hunt",
		"POLICE", "Police", "police",
		"NATIONAL", "National", "national",
		"SECURITY", "Security", "security",
		"HEIST", "Heist", "heist",
		"SWAT", "Swat", "swat",
		"DOCTOR", "Doctor", "doctor",
		"JANITOR", "Janitor", "janitor",
		"MAFIA", "Mafia", "mafia",
		"BANK", "Bank", "bank",
		"TOWER", "Tower", "tower",
		"THEATRE", "Theatre", "theatre",
		"SEWER", "Sewer", "sewer",
		"BEACH", "Beach", "beach",
		"BAR", "Bar", "bar",
		"MANSION", "Mansion", "mansion",
		"SHOP", "Shop", "shop",
		"WAREHOUSE", "Warehouse", "warehouse",
		"TOWN", "Town", "town",
		"HIDDEN", "Hidden", "hidden",
		"FRENZY", "Frenzy", "frenzy",
		"CHILDE", "Childe", "childe",
		"SIRE", "Sire", "sire",
		"CAINE", "Caine", "caine",
		"HUMANITY", "Humanity", "humanity",
		"ENLIGHTENMENT", "Enlightenment", "enlightenment",
		"VOICES", "Voices", "voices",
		"WHAT", "What", "what",
		"UNDEAD", "Undead", "undead",
		"FEED", "Feed", "feed",
		"BLOODLUST", "Bloodlust", "bloodlust",
		"SIREN", "Siren", "siren",
		"HEART", "Heart", "heart",
		"BLOODPOOL", "Bloodpool", "bloodpool",
		"VITAE", "Vitae", "vitae",
		"CLAN", "Clan", "clan",
		"CAINITE", "Cainite", "cainite",
		"COVENANT", "Covenant", "covenant",
		"HUNGER", "Hunger", "hunger",
		"MORTAL", "Mortal", "mortal",
		"WEREWOLF", "Werewolf", "werewolf",
		"SPIRIT", "Spirit", "spirit",
		"WALKER", "Walker", "walker",
		"MASTERY", "Mastery", "mastery",
		"VAMPIRES", "Vampires", "vampires",
		"HUNTING", "Hunting", "hunting",
		"HUNTERS", "Hunters", "hunters",
		"GHOULED", "Ghouled", "ghouled",
		"FEEDING", "Feeding", "feeding",
		"BLOODBOND", "Bloodbond", "bloodbond",
		"THIRST", "Thirst", "thirst",
		"DOMINATE", "Dominate", "dominate",
		"OBFUSCATE", "Obfuscate", "obfuscate",
		"PRESENCE", "Presence", "presence",
		"POTENCE", "Potence", "potence",
		"CELERITY", "Celerity", "celerity",
		"DEMENTATION", "Dementation", "dementation",
		"DOMINATE", "Dominate", "dominate",
		"AUSPEX", "Auspex", "auspex",
		"DOMINATE", "Dominate", "dominate",
		"DAIMONION", "Daimonion", "daimonion",
		"QUIETUS", "Quietus", "quietus",
		"MYTHERCERIA", "Mytherceria", "mytherceria",
		"FORTITUDE", "Fortitude", "fortitude",
		"NECROMANCY", "Necromancy", "necromancy",
		"ANIMALISM", "Animalism", "animalism",
		"NECROMANCY", "Necromancy", "necromancy",
		"PROTEAN", "Protean", "protean",
		"TEMPORIS", "Temporis", "temporis",
		"VICISSITUDE", "Vicissitude", "vicissitude",
		"THAUMATURGY", "Thaumaturgy", "thaumaturgy",
		"VALEREN", "Valeren", "valeren",
		"VALEREN", "Valeren", "valeren",
		"OBTENEBRATION", "Obtenebration", "obtenebration",
		"VISCERATIKA", "Visceratika", "visceratika",
		"BRUJAH", "Brujah", "brujah",
		"TREMERE", "Tremere", "tremere",
		"VENTRUE", "Ventrue", "ventrue",
		"TOREADOR", "Toreador", "toreador",
		"LASOMBRA", "Lasombra", "lasombra",
		"MALKAVIAN", "Malkavian", "malkavian",
		"TORPOR", "Torpor", "torpor",
		"MINISTRY", "Ministry", "ministry",
		"ASSAMITES", "Assamites", "assamites",
		"SALUBRI", "Salubri", "salubri",
		"GIOVANNI", "Giovanni", "giovanni",
		"GANGREL", "Gangrel", "gangrel",
		"GARGOYLE", "Gargoyle", "gargoyle",
		"KIASYD", "Kiasyd", "kiasyd",
		"VENTRUE", "Ventrue", "ventrue",
		"NOSFERATU", "Nosferatu", "nosferatu",
		"TZIMISCE", "Tzimisce", "tzimisce",
		"BAALI", "Baali", "baali",
		"CAPPADOCIAN", "Cappadocian", "cappadocian",
		"KUEI-JIN", "Kuei-jin", "kuei-jin",
		"FIRE", "Fire", "fire",
		"FBI", "Fbi", "fbi",
		"PACKS", "Pack", "pack",
		"SELL", "Sell", "sell",
		"BUY", "Buy", "buy",
		"SOLD", "Sold", "sold",
		"BOUGHT", "Bought", "bought",
		"GUN", "Gun", "gun",
		"SLASH", "Slash", "slash",
		"SWORD", "Sword", "sword",
		"PUNCH", "Punch", "punch",
		"SHOOT", "Shoot", "shoot",
		"HIT", "Hit", "hit",
		"ATTACK", "Attack", "attack",
		"USING", "using", "using",
		"USE", "Use", "use",
		"CLOAK", "Cloak", "cloak",
		"BLOODLINE", "Bloodline", "bloodline",
		"GLOW", "Glow", "glow",
		"NOCTURNAL", "Nocturnal", "nocturnal",
		"CROSS", "Cross", "cross",
		"EXILE", "Exile", "exile",
		"SHROUD", "Shroud", "shroud",
		"WRAITH", "Wraith", "wraith",
		"SOUL", "Soul", "soul",
		"PRETENSE", "Pretense", "pretense",
		"SURVIVAL", "Survival", "survival",
		"LEGACY", "Legacy", "legacy",
		"SOVEREIGN", "Sovereign", "sovereign",
		"MIND", "Mind", "mind",
		"CLOAKING", "Cloaking", "cloaking",
		"REMORSE", "Remorse", "remorse",
		"REDEMPTION", "Redemption", "redemption",
		"DREAD", "Dread", "dread",
		"AVENGER", "Avenger", "avenger",
		"ORACLES", "Oracles", "oracles",
		"SECRETS", "Secrets", "secrets",
		"DARKNESS", "Darkness", "darkness",
		"FEAR", "Fear", "fear",
		"GUILT", "Guilt", "guilt",
		"INSANITY", "Insanity", "insanity",
		"REBIRTH", "Rebirth", "rebirth",
		"HOLY", "Holy", "holy",
		"SACRED", "Sacred", "sacred",
		"DAMNED", "Damned", "damned",
		"NIGHT", "Night", "night",
		"ABYSS", "Abyss", "abyss",
		"BLOODRITUAL", "Bloodritual", "bloodritual",
		"CRIMSON", "Crimson", "crimson",
		"FANGS", "Fangs", "fangs",
		"VAMPIRIC", "Vampiric", "vampiric",
		"BROOD", "Brood", "brood",
		"BEAST", "Beast", "beast",
		"RITUAL", "Ritual", "ritual",
		"DEATH", "Death", "death",
		"HUNGERING", "Hungering", "hungering",
		"BLOODCRAFT", "Bloodcraft", "bloodcraft",
		"HEALING", "Healing", "healing",
		"FLAWED", "Flawed", "flawed",
		"STRENGTH", "Strength", "strength",
		"WEAKNESS", "Weakness", "weakness",
		"INFAMY", "Infamy", "infamy",
		"SHADOWS", "Shadows", "shadows",
		"BLOODLORD", "Bloodlord", "bloodlord",
		"FATE", "Fate", "fate",
		"GUILT", "Guilt", "guilt",
		"EXORCIST", "Exorcist", "exorcist",
		"DREAD", "Dread", "dread",
		"REGENERATION", "Regeneration", "regeneration",
		"WRETCHED", "Wretched", "wretched",
		"BLOODBROTHERS", "Bloodbrothers", "bloodbrothers",
		"ASHES", "Ashes", "ashes",
		"URGE", "Urge", "urge",
		"FAMISHED", "Famished", "famished",
		"RITES", "Rites", "rites",
		"REBIRTH", "Rebirth", "rebirth",
		"GRAVE", "Grave", "grave",
		"SPAWN", "Spawn", "spawn",
		"FIEND", "Fiend", "fiend",
		"CONQUEST", "Conquest", "conquest",
		"DOMINANCE", "Dominance", "dominance",
		"SATIATION", "Satiation", "satiation",
		"BLOODSWEAT", "Bloodsweat", "bloodsweat",
		"LORD", "Lord", "lord",
		"ALLEY", "Alley", "alley",
		"MORGUE", "Morgue", "morgue",
		"GRAVEYARD", "Graveyard", "graveyard",
		"PREDATOR", "Predator", "predator",
		"RITUALS", "Rituals", "rituals",
		"CRISIS", "Crisis", "crisis",
		"THEORY", "Theory", "theory",
		"SABBATISTS", "Sabbatists", "sabbatists"

	)
	
	
	var/list/words = split_text_into_words(text)
	var/scrambled = ""
	var/used_first_format = FALSE 
	var/first_replacement_done = FALSE 
	
	
	
	for(var/i = 1 to words.len)
		var/word = words[i]
		
		if(word in list(".", ",", "!", "?", ":", ";", "#"))
			scrambled += word 
		else if(prob(scramble_percentage))
			
			var/block_start = rand(1, floor(random_words.len / 3)) * 3 - 3
			var/replacement
			if(!first_replacement_done) 
				replacement = pick(random_words[block_start + 1], random_words[block_start + 2])
				first_replacement_done = TRUE
			else if(!used_first_format) 
				replacement = random_words[block_start + 3]
				used_first_format = TRUE
			else
				replacement = pick(random_words[block_start + 1], random_words[block_start + 3])

			
			if(word in list(".", ",", "!", "?", ":", ";", "#"))
				scrambled += replacement 
			else
				scrambled += replacement 
				if(i < words.len && !(words[i + 1] in list(".", ",", "!", "?", ":", ";", "#")))
					scrambled += " "

			
						
			
		else
			if(word in list(".", ",", "!", "?", ":", ";", "#"))
				scrambled += word 
			else
				scrambled += word
				if(i < words.len && !(words[i + 1] in list(".", ",", "!", "?", ":", ";", "#")))
					scrambled += " "
			
				
				
	return trim(scrambled) 





proc/split_text_into_words(text)
	var/list/words = list()  
	var/current_word = ""   
	var/length_text = length(text)
	var/position = 1         

	while(position <= length_text)
		var/char = text[position]  

		if(char in list(" ", ".", ",", "!", "?", ":", ";", "#"))
			if(current_word != "")
				words += current_word
				current_word = ""

			if(char != " ")
				words += char
		else
			current_word += char

		position += 1

	if(current_word != "")
		words += current_word

	
	return words

//		var/ending = copytext_char(message, -1)
//		var/list/message_mods = list()
//		message = get_message_mods(message, message_mods)
//		if(message_mods[WHISPER_MODE] != MODE_WHISPER)
//			if(ending == "?")
//				if(gender == FEMALE)
//					playsound(get_turf(src), pick('code/modules/wod13/sounds/female_ask1.ogg', 'code/modules/wod13/sounds/female_ask2.ogg'), 75, TRUE)
//				else
//					playsound(get_turf(src), pick('code/modules/wod13/sounds/male_ask1.ogg', 'code/modules/wod13/sounds/male_ask2.ogg'), 75, TRUE)
//			else if(ending == "!")
//				if(gender == FEMALE)
//					playsound(get_turf(src), pick('code/modules/wod13/sounds/female_yell1.ogg', 'code/modules/wod13/sounds/female_yell2.ogg'), 100, TRUE)
//				else
//					playsound(get_turf(src), pick('code/modules/wod13/sounds/male_yell1.ogg', 'code/modules/wod13/sounds/male_yell2.ogg'), 100, TRUE)
//			else
//				if(gender == FEMALE)
//					playsound(get_turf(src), 'code/modules/wod13/sounds/female_speak.ogg', 75, TRUE)
//				else
//					playsound(get_turf(src), 'code/modules/wod13/sounds/male_speak.ogg', 75, TRUE)

/obj/item/chameleon
	name = "Vicissitude Projector"
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "vicissitude"
	flags_1 = CONDUCT_1
	item_flags = ABSTRACT | NOBLUDGEON | DROPDEL
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	var/can_use = 1
	var/obj/effect/dummy/chameleon/active_dummy = null
	var/saved_appearance = null
	var/generated = FALSE

/obj/item/chameleon/Initialize()
	. = ..()

/obj/item/chameleon/dropped()
	..()
	disrupt()

/obj/item/chameleon/equipped()
	..()
	disrupt()

/obj/item/chameleon/attack_self(mob/user)
	if(!generated)
		saved_appearance = user.appearance
		generated = TRUE
	if (isturf(user.loc) || active_dummy)
		toggle(user)
	else
		to_chat(user, "<span class='warning'>You can't use [src] while inside something!</span>")

/obj/item/chameleon/afterattack(atom/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(active_dummy)//I now present you the blackli(f)st
		return
	if(!isliving(target))
		return
	if(target.alpha != 255)
		return
	if(target.invisibility != 0)
		return
	playsound(get_turf(src), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)
	to_chat(user, "<span class='notice'>Scanned [target].</span>")
	saved_appearance = target.appearance

/obj/item/chameleon/proc/toggle(mob/user)
	if(!can_use || !saved_appearance)
		return
	if(active_dummy)
		eject_all()
		playsound(get_turf(src), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)
		qdel(active_dummy)
		active_dummy = null
		to_chat(user, "<span class='notice'>You deactivate \the [src].</span>")
	else
		var/mob/living/L = user
		if(L.bloodpool < 1)
			to_chat(user, "<span class='warning'>You don't have enough <b>BLOOD</b> to activate \the [src].</span>")
			user.cancel_camera()
			return
		L.bloodpool = max(0, L.bloodpool-1)
		playsound(get_turf(src), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)
		var/obj/effect/dummy/chameleon/C = new/obj/effect/dummy/chameleon(user.drop_location())
		C.activate(user, saved_appearance, src)
		to_chat(user, "<span class='notice'>You activate \the [src].</span>")
	user.cancel_camera()

/obj/item/chameleon/proc/disrupt(delete_dummy = 1)
	if(active_dummy)
		for(var/mob/M in active_dummy)
			to_chat(M, "<span class='danger'>Your Vicissitude Projector deactivates.</span>")
		eject_all()
		if(delete_dummy)
			qdel(active_dummy)
		active_dummy = null
		can_use = FALSE
		addtimer(VARSET_CALLBACK(src, can_use, TRUE), 5 SECONDS)

/obj/item/chameleon/proc/eject_all()
	for(var/atom/movable/A in active_dummy)
		A.forceMove(active_dummy.loc)
		if(ismob(A))
			var/mob/M = A
			M.reset_perspective(null)

/obj/effect/dummy/chameleon
	name = ""
	desc = ""
	density = TRUE
	var/can_move = 0
	var/obj/item/chameleon/master = null

/obj/effect/dummy/chameleon/proc/activate(mob/M, saved_appearance, obj/item/chameleon/C)
	appearance = saved_appearance
	if(istype(M.buckled, /obj/vehicle))
		var/obj/vehicle/V = M.buckled
		V.unbuckle_mob(M, force = TRUE)
	M.forceMove(src)
	master = C
	master.active_dummy = src

/obj/effect/dummy/chameleon/attackby()
	master.disrupt()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/effect/dummy/chameleon/attack_hand()
	master.disrupt()

/obj/effect/dummy/chameleon/attack_animal()
	master.disrupt()

/obj/effect/dummy/chameleon/attack_slime()
	master.disrupt()

/obj/effect/dummy/chameleon/attack_alien()
	master.disrupt()

/obj/effect/dummy/chameleon/ex_act(S, T)
	contents_explosion(S, T)
	master.disrupt()

/obj/effect/dummy/chameleon/bullet_act()
	. = ..()
	master.disrupt()

/obj/effect/dummy/chameleon/relaymove(mob/living/user, direction)
	if(isspaceturf(loc) || !direction)
		return //No magical space movement!

	if(can_move < world.time)
		can_move = world.time + 10
		step(src, direction)
	return

/obj/effect/dummy/chameleon/Destroy()
	master.disrupt(0)
	return ..()
