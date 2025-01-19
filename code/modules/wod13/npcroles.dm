
/datum/socialrole/bandit
	s_tones = list("caucasian3",
								"latino",
								"mediterranean",
								"asian1",
								"asian2",
								"arab",
								"indian",
								"african1",
								"african2")

	min_age = 18
	max_age = 45
	preferedgender = MALE
	male_names = null
	surnames = null

	hair_colors = list("040404",	//Black
											"120b05",	//Dark Brown
											"342414",	//Brown
											"554433")	//Light Brown
	male_hair = list("Balding Hair",
										"Bedhead",
										"Bedhead 2",
										"Bedhead 3",
										"Boddicker",
										"Business Hair",
										"Business Hair 2",
										"Business Hair 3",
										"Business Hair 4",
										"Coffee House",
										"Combover",
										"Crewcut",
										"Father",
										"Flat Top",
										"Gelled Back",
										"Joestar",
										"Keanu Hair",
										"Oxton",
										"Volaju")
	male_facial = list("Beard (Abraham Lincoln)",
											"Beard (Chinstrap)",
											"Beard (Full)",
											"Beard (Cropped Fullbeard)",
											"Beard (Hipster)",
											"Beard (Neckbeard)",
											"Beard (Three o Clock Shadow)",
											"Beard (Five o Clock Shadow)",
											"Beard (Seven o Clock Shadow)",
											"Moustache (Hulk Hogan)",
											"Moustache (Watson)",
											"Sideburns (Elvis)",
											"Sideburns",
											"Shaved")

	shoes = list(
		/obj/item/clothing/shoes/vampire/sneakers,
		/obj/item/clothing/shoes/vampire/sneakers/red,
		/obj/item/clothing/shoes/vampire/jackboots
	)
	uniforms = list(
		/obj/item/clothing/under/vampire/larry,
		/obj/item/clothing/under/vampire/bandit,
		/obj/item/clothing/under/vampire/biker
	)
	hats = list(
		/obj/item/clothing/head/vampire/bandana,
		/obj/item/clothing/head/vampire/bandana/red,
		/obj/item/clothing/head/vampire/bandana/black,
		/obj/item/clothing/head/vampire/beanie,
		/obj/item/clothing/head/vampire/beanie/black
	)
	pockets = list(
		/obj/item/stack/dollar/rand,
		/obj/item/vamp/keys/hack
	)

	//[Lucia] - this has been edited to have better English because it included slurs, but none of the others have yet
	male_phrases = list(
		"На шо это ты смотришь?",
		"Пытаешься напугать меня?",
		"Те чето нужно?",
		"Будь уверен, яйца то у меня есть.",
		"Ты хоть знаешь на кого я работаю?",
		"Пшел отсюда, пока моя банда не надрала тебе зад.",
		"Чето нужно, фрик?",
		"Уйди, либераха.",
		"Уходи с нашего района.",
		"Думаешь напугал меня? Знаешь на кого работаю?",
		"Думаешь ты крепкий орешек?"
	)
	neutral_phrases = list(
		"Че ты пялишься на меня?",
		"Еще один идиот, пытающийся выглядеть угрожающе.",
		"Скоро нужно будет возвращаться домой, семья ждет.",
		"Ушел с пути, либераха.",
		"Я думаю... скучаю по жене.",
		"Че? Те надо чето?",
		"Пшол с дороги.",
		"Пшел нахуй, не в настроении.",
		"Отъебись."
	)
	random_phrases = list(
		"Гнида.",
		"Я потерял мою девочку...",
		"Что случилось братан?",
		"ЕБАННЫЙ. ДОБРЫЙ. ВЕЧЕР.",
		"Доброго.",
		"Безумный город...",
		"Мы всё потеряли, всё...",
		"Эххх..."
	)
	answer_phrases = list(
		"У меня все получилось...",
		"Чертова дыра... весь этот город.",
		"Чувак, это дерьмо.",
		"Ты выглядишь так, будто я тебя знаю...",
		"Хорошо.",
		"Эмм... думаю... классно?",
		"Поел я значит в забегаловке, так до сих пор мутит..."
	)
	help_phrases = list(
		"Боже, вот опять!!",
		"ЕБНУТЫЙ!",
		"Че ты творишь!?",
		"Ты проебался!",
		"Проверься, идиот!",
		"У нас есть кое-что, что заставит тебя замолчать навсегда!",
		"Бейте его!",
		"Мочите суку!"
	)

/datum/socialrole/usualmale
	s_tones = list(
		"albino",
		"caucasian1",
		"caucasian2",
		"caucasian3"
	)

	min_age = 18
	max_age = 85
	preferedgender = MALE
	male_names = null
	surnames = null

	hair_colors = list(
		"040404",	//Black
		"120b05",	//Dark Brown
		"342414",	//Brown
		"554433",	//Light Brown
		"695c3b",	//Dark Blond
		"ad924e",	//Blond
		"dac07f",	//Light Blond
		"802400",	//Ginger
		"a5380e",	//Ginger alt
		"ffeace",	//Albino
		"650b0b",	//Punk Red
		"14350e",	//Punk Green
		"080918"    //Punk Blue
	)
	male_hair = list(
		"Balding Hair",
		"Bedhead",
		"Bedhead 2",
		"Bedhead 3",
		"Boddicker",
		"Business Hair",
		"Business Hair 2",
		"Business Hair 3",
		"Business Hair 4",
		"Coffee House",
		"Combover",
		"Crewcut",
		"Father",
		"Flat Top",
		"Gelled Back",
		"Joestar",
		"Keanu Hair",
		"Oxton",
		"Volaju"
	)
	male_facial = list(
		"Beard (Abraham Lincoln)",
		"Beard (Chinstrap)",
		"Beard (Full)",
		"Beard (Cropped Fullbeard)",
		"Beard (Hipster)",
		"Beard (Neckbeard)",
		"Beard (Three o Clock Shadow)",
		"Beard (Five o Clock Shadow)",
		"Beard (Seven o Clock Shadow)",
		"Moustache (Hulk Hogan)",
		"Moustache (Watson)",
		"Sideburns (Elvis)",
		"Sideburns",
		"Shaved"
	)

	shoes = list(
		/obj/item/clothing/shoes/vampire/sneakers,
		/obj/item/clothing/shoes/vampire,
		/obj/item/clothing/shoes/vampire/brown
	)
	uniforms = list(
		/obj/item/clothing/under/vampire/mechanic,
		/obj/item/clothing/under/vampire/sport,
		/obj/item/clothing/under/vampire/office,
		/obj/item/clothing/under/vampire/sexy,
		/obj/item/clothing/under/vampire/slickback,
		/obj/item/clothing/under/vampire/emo
	)
	pockets = list(
		/obj/item/vamp/keys/npc,
		/obj/item/stack/dollar/rand
	)

	male_phrases = list(
		"Что-то нужно? Или пытаешься потратить моё время?",
		"Как дела?",
		"Что ты сказал?",
		"Я опаздываю, жена убьет меня.",
		"Слышал о новом заведении в городе..?",
		"Не могу сейчас говорить.",
		"Хорошая ночка, не так ли?",
		"Эхх...",
		"Я не знаю, что сказать.",
		"Вот и все, ребята."
	)
	neutral_phrases = list(
		"Что тебе нужно, приятель?",
		"Что-то нужно?",
		"Можешь повторить, что ты только что сказал?",
		"Я опаздываю, не мешай..",
		"Люблю гулять ночью.",
		"Найди себе другую компанию...",
		"Не могу говорить.",
		"Теплая ночка?",
		"Ухх...",
		"Даже не знаю что сказать.",
		"На этом всё."
	)
	random_phrases = list(
		"Эй, приятель!",
		"Я потерял моё пиво...",
		"Всё в порядке?",
		"Привет.",
		"Я тебя не встречал?",
		"Здесь что-то не так.",
		"Охх, чувак..."
	)
	answer_phrases = list(
		"Пытаюсь...",
		"Стараюсь...",
		"Великолепно.",
		"Плохо, чувак.",
		"Ты выбрал не того.",
		"Да, верно.",
		"Хоро-о-ошо...",
		"Класс."
	)
	help_phrases = list(
		"О Боже!",
		"Иди прочь!!",
		"Что за хуйня?!",
		"Помилуй, я многодетный отец!",
		"Остановись!",
		"Кто-нибудь, ПОМОГИТЕ!!",
		"Мамочка!"
	)

/datum/socialrole/usualfemale
	s_tones = list("albino",
								"caucasian1",
								"caucasian2",
								"caucasian3")

	min_age = 18
	max_age = 85
	preferedgender = FEMALE
	female_names = null
	surnames = null
// [dentbrain] man... actually coming up with shit for people to say is HARD work........
	hair_colors = list("040404",	//Black
										"120b05",	//Dark Brown
										"342414",	//Brown
										"554433",	//Light Brown
										"695c3b",	//Dark Blond
										"ad924e",	//Blond
										"dac07f",	//Light Blond
										"802400",	//Ginger
										"a5380e",	//Ginger alt
										"ffeace",	//Albino
										"650b0b",	//Punk Red
										"14350e",	//Punk Green
										"080918")	//Punk Blue
	female_hair = list("Ahoge",
										"Long Bedhead",
										"Beehive",
										"Beehive 2",
										"Bob Hair",
										"Bob Hair 2",
										"Bob Hair 3",
										"Bob Hair 4",
										"Bobcurl",
										"Braided",
										"Braided Front",
										"Braid (Short)",
										"Braid (Low)",
										"Bun Head",
										"Bun Head 2",
										"Bun Head 3",
										"Bun (Large)",
										"Bun (Tight)",
										"Double Bun",
										"Emo",
										"Emo Fringe",
										"Feather",
										"Gentle",
										"Long Hair 1",
										"Long Hair 2",
										"Long Hair 3",
										"Long Over Eye",
										"Long Emo",
										"Long Fringe",
										"Ponytail",
										"Ponytail 2",
										"Ponytail 3",
										"Ponytail 4",
										"Ponytail 5",
										"Ponytail 6",
										"Ponytail 7",
										"Ponytail (High)",
										"Ponytail (Short)",
										"Ponytail (Long)",
										"Ponytail (Country)",
										"Ponytail (Fringe)",
										"Poofy",
										"Short Hair Rosa",
										"Shoulder-length Hair",
										"Volaju")

	shoes = list(/obj/item/clothing/shoes/vampire/heels,
								/obj/item/clothing/shoes/vampire/sneakers,
								/obj/item/clothing/shoes/vampire/jackboots)
	uniforms = list(/obj/item/clothing/under/vampire/black,
									/obj/item/clothing/under/vampire/red,
									/obj/item/clothing/under/vampire/gothic)
	pockets = list(/obj/item/vamp/keys/npc,
					/obj/item/stack/dollar/rand)

	female_phrases = list(
		"Что-то нужно?",
		"Вам нужно что-нибудь?",
		"Мне действительно нужно отвечать?",
		"Я опаздываю.",
		"Изврат...",
		"Не могу щас говорить.",
		"Мне нужно взять отпуск...",
		"Эй!",
		"Уйди."
	)
	neutral_phrases = list(
		"Что-то нужно?",
		"Вам нужно что-нибудь?",
		"Мне действительно нужно отвечать?",
		"Я спешу.",
		"Развратник!",
		"Бегу...",
		"Не могу щас говорить.",
		"Найди себе другую подружку",
		"Эй!",
		"Уйди."
	)
	random_phrases = list(
		"Я потеряла пиво...",
		"Прохладная ночка, правда?",
		"Хээээй.",
		"Я тебя знаю?",
		"Что-то с этим городом не так, понимаешь?",
		"Вау."
	)
	answer_phrases = list(
		"Пытаюсь...",
		"Безумие.",
		"Дела идут не очень хорошо.",
		"Ты перепутал меня с кем-то другим.",
		"Да, точно.",
		"Ладно...",
		"Хорошо."
	)
	help_phrases = list(
		"Господи!",
		"УЙДИ!!",
		"ЧТО, БЛЯТЬ, ПРОИСХОДИТ?!",
		"Прекрати!",
		"Помогите!!",
		"Мамочка!"
	)

/datum/socialrole/poormale
	s_tones = list(
		"albino",
		"caucasian1",
		"caucasian2",
		"caucasian3"
	)

	min_age = 45
	max_age = 85
	preferedgender = MALE
	male_names = null
	surnames = null

	hair_colors = list("040404",	//Black
										"120b05",	//Dark Brown
										"342414",	//Brown
										"554433",	//Light Brown
										"695c3b",	//Dark Blond
										"ad924e",	//Blond
										"dac07f",	//Light Blond
										"802400",	//Ginger
										"a5380e",	//Ginger alt
										"ffeace",	//Albino
										"650b0b",	//Punk Red
										"14350e",	//Punk Green
										"080918")	//Punk Blue
	male_hair = list("Balding Hair",
										"Bedhead",
										"Bedhead 2",
										"Bedhead 3",
										"Boddicker",
										"Business Hair",
										"Business Hair 2",
										"Business Hair 3",
										"Business Hair 4",
										"Coffee House",
										"Combover",
										"Crewcut",
										"Father",
										"Flat Top",
										"Gelled Back",
										"Joestar",
										"Keanu Hair",
										"Oxton",
										"Volaju")
	male_facial = list("Beard (Abraham Lincoln)",
											"Beard (Chinstrap)",
											"Beard (Full)",
											"Beard (Cropped Fullbeard)",
											"Beard (Hipster)",
											"Beard (Neckbeard)",
											"Beard (Three o Clock Shadow)",
											"Beard (Five o Clock Shadow)",
											"Beard (Seven o Clock Shadow)",
											"Moustache (Hulk Hogan)",
											"Moustache (Watson)",
											"Sideburns (Elvis)",
											"Sideburns")

	shoes = list(/obj/item/clothing/shoes/vampire/jackboots/work)
	uniforms = list(/obj/item/clothing/under/vampire/homeless)
	suits = list(/obj/item/clothing/suit/vampire/coat)
	hats = list(/obj/item/clothing/head/vampire/beanie/black)
	gloves = list(/obj/item/clothing/gloves/vampire/work)
	neck = list(/obj/item/clothing/neck/vampire/scarf/red,
							/obj/item/clothing/neck/vampire/scarf,
							/obj/item/clothing/neck/vampire/scarf/blue,
							/obj/item/clothing/neck/vampire/scarf/green,
							/obj/item/clothing/neck/vampire/scarf/white)

	male_phrases = list("Страна мудаков...",
											"Мы живем в мире полной тьмы!",
											"Грубгхснат...",
											"Брр..",
											"Бахнуть бы сто грамчиков...")
	neutral_phrases = list("Мужик...",
											"Мы в дерьме!",
											"Абырвагл...",
											"Пожрать бы.",
											"Холодно.",
											"Бахнуть бы сто грамчиков...")
	random_phrases = list("Понять и простить, понять и простить...",
											"Я вижу тьму...!",
											"Абырвагл...",
											"Я отдал лучшие годы этой стране.",
											"Скиб-бип.",
											"Буээ!",
											"Бахнуть бы сто грамчиков...")
	answer_phrases = list("Бля, мужи-и-ик...",
											"Нам пиздец!",
											"Лю-лю-лю...",
											"Бррр.",
											"Бахнуть бы сто грамчиков...")
	help_phrases = list("АЙ!",
											"АААААААААА!!",
											"ЩТО ЗА НАХЕР?!",
											"ДЕРЬМО!",
											"ЖОПА!",
											"ХУЙ!")

/datum/socialrole/poorfemale
	s_tones = list("albino",
								"caucasian1",
								"caucasian2",
								"caucasian3")

	min_age = 45
	max_age = 85
	preferedgender = FEMALE
	female_names = null
	surnames = null

	hair_colors = list("040404",	//Black
										"120b05",	//Dark Brown
										"342414",	//Brown
										"554433",	//Light Brown
										"695c3b",	//Dark Blond
										"ad924e",	//Blond
										"dac07f",	//Light Blond
										"802400",	//Ginger
										"a5380e",	//Ginger alt
										"ffeace",	//Albino
										"650b0b",	//Punk Red
										"14350e",	//Punk Green
										"080918")	//Punk Blue
	female_hair = list("Ahoge",
										"Long Bedhead",
										"Beehive",
										"Beehive 2",
										"Bob Hair",
										"Bob Hair 2",
										"Bob Hair 3",
										"Bob Hair 4",
										"Bobcurl",
										"Braided",
										"Braided Front",
										"Braid (Short)",
										"Braid (Low)",
										"Bun Head",
										"Bun Head 2",
										"Bun Head 3",
										"Bun (Large)",
										"Bun (Tight)",
										"Double Bun",
										"Emo",
										"Emo Fringe",
										"Feather",
										"Gentle",
										"Long Hair 1",
										"Long Hair 2",
										"Long Hair 3",
										"Long Over Eye",
										"Long Emo",
										"Long Fringe",
										"Ponytail",
										"Ponytail 2",
										"Ponytail 3",
										"Ponytail 4",
										"Ponytail 5",
										"Ponytail 6",
										"Ponytail 7",
										"Ponytail (High)",
										"Ponytail (Short)",
										"Ponytail (Long)",
										"Ponytail (Country)",
										"Ponytail (Fringe)",
										"Poofy",
										"Short Hair Rosa",
										"Shoulder-length Hair",
										"Volaju")

	shoes = list(/obj/item/clothing/shoes/vampire/brown)
	uniforms = list(/obj/item/clothing/under/vampire/homeless/female)
	suits = list(/obj/item/clothing/suit/vampire/coat/alt)
	hats = list(/obj/item/clothing/head/vampire/beanie/homeless)

	male_phrases = list("Хуйня...",
											"Мы в мире смерти!",
											"Где мой ребенок...",
											"Брр..",
											"Бахнуть бы сто грамчиков...")
	neutral_phrases = list("Мужик...",
											"Мы в дерьме!",
											"Бедность не порок...",
											"Прохладно.",
											"Прожить бы ещё один вечер",
											"Бахнуть бы сто грамчиков...")
	random_phrases = list("Когда я была молода...",
											"Снова шапка на глаза налезла..",
											"Абырвагл...",
											"Хлеба бы.",
											"Доп-оп...",
											"Бахнуть бы сто грамчиков...")
	answer_phrases = list("Дитя моё...",
											"Нам пиздец!",
											"Хи-хо-хи...",
											"Бррр.",
											"Бахнуть бы сто грамчиков...")
	help_phrases = list("ААААЙ!",
											"АААААААААА!!",
											"ЩТО ЗА НАХЕР?!",
											"ДЕРЬМО!",
											"ЖОПА!",
											"ПИЗДА!")


/datum/socialrole/richmale
	s_tones = list("albino")

	min_age = 18
	max_age = 85
	preferedgender = MALE
	male_names = null
	surnames = null

	hair_colors = list("040404",	//Black
										"120b05",	//Dark Brown
										"342414",	//Brown
										"554433",	//Light Brown
										"695c3b",	//Dark Blond
										"ad924e",	//Blond
										"dac07f",	//Light Blond
										"802400",	//Ginger
										"a5380e",	//Ginger alt
										"ffeace",	//Albino
										"650b0b",	//Punk Red
										"14350e",	//Punk Green
										"080918")	//Punk Blue
	male_hair = list("Business Hair",
										"Business Hair 2",
										"Business Hair 3",
										"Business Hair 4",
										"Coffee House",
										"Combover",
										"Crewcut",
										"Father",
										"Flat Top",
										"Gelled Back",
										"Joestar",
										"Keanu Hair",
										"Oxton",
										"Volaju")
	male_facial = list("Beard (Neckbeard)",
											"Beard (Three o Clock Shadow)",
											"Sideburns (Elvis)",
											"Sideburns",
											"Shaved")

	shoes = list(/obj/item/clothing/shoes/vampire,
								/obj/item/clothing/shoes/vampire/white)
	uniforms = list(/obj/item/clothing/under/vampire/rich)
	inhand_items = list(/obj/item/storage/briefcase)
	pockets = list(/obj/item/vamp/keys/npc,
					/obj/item/stack/dollar/fifty,
					/obj/item/stack/dollar/hundred)

	male_phrases = list("Ты что-то спросил?",
										"Я иду по важным делам, не мешай.",
										"С дороги, чернь...",
										"Из-за работы я так поздно встаю, что лучше бы мне платили больше....",
										"Наконец-то я ушел с этой тупой работы... рад, что переехал сюда.")
	neutral_phrases = list("Ты что-то сказал..?",
										"Извините?",
										"Каждый вечер одно и то же...",
										"Хм, что это?",
										"Ещё один простофиля.",
										"Мне нужно идти, у меня важное дело..",
										"Проваливай, придурок, найди работу или еще что-нибудь",
										"Потеряйся, бедность...",
										"А? Извините, кофе еще не успел подействовать.",
										"Сейчас середина ночи, я не хочу разбираться с твоим дерьмом прямо сейчас.")
	help_phrases = list("Что происходит?!",
										"Я вызываю ментов!",
										"О НЕТ, ЧЕРТ ВОЗЬМИ, НЕТ!",
										"Прошу не убивайте, у меня жена и дети!!",
										"Этого не может происходить со мною!",
										"Вызывайте полицию!")

/datum/socialrole/richfemale
	s_tones = list("albino")

	min_age = 18
	max_age = 85
	preferedgender = FEMALE
	female_names = null
	surnames = null

	hair_colors = list("040404",	//Black
										"120b05",	//Dark Brown
										"342414",	//Brown
										"554433",	//Light Brown
										"695c3b",	//Dark Blond
										"ad924e",	//Blond
										"dac07f",	//Light Blond
										"802400",	//Ginger
										"a5380e",	//Ginger alt
										"ffeace",	//Albino
										"650b0b",	//Punk Red
										"14350e",	//Punk Green
										"080918")	//Punk Blue
	female_hair = list("Ahoge",
										"Bob Hair",
										"Bob Hair 2",
										"Bob Hair 3",
										"Bob Hair 4",
										"Bobcurl",
										"Braided",
										"Braided Front",
										"Braid (Short)",
										"Braid (Low)",
										"Bun Head",
										"Bun Head 2",
										"Bun Head 3",
										"Bun (Large)",
										"Bun (Tight)",
										"Gentle",
										"Long Hair 1",
										"Long Hair 2",
										"Long Hair 3",
										"Short Hair Rosa",
										"Shoulder-length Hair",
										"Volaju")

	shoes = list(/obj/item/clothing/shoes/vampire/heels,
								/obj/item/clothing/shoes/vampire/heels/red)
	uniforms = list(/obj/item/clothing/under/vampire/business)
	pockets = list(/obj/item/vamp/keys/npc,
					/obj/item/stack/dollar/fifty,
					/obj/item/stack/dollar/hundred)

	female_phrases = list("Че те надо, я занята!",
											"Извините, вы знаете путь к  казино?",
											"...Что?",
											"Я спешу по важному делу.",
											"Не мешай, бомжара...",
											"Уйди с дороги, мелочь...",
											"Вы были в баре? Люди сидят там всю ночь, это безумие...",
											"Остановись , идиот.")
	neutral_phrases = list("Вы что-то спросили?",
											"Извините?",
											"Что?",
											"Прошу, не задерживайте меня.",
											"Я иду по делам.",
											"Потеряйся, бедность...",
											"Чего...",
											"Хочешь жить - умей вертеться.",
											"День прошел незаметно..",
											"Прекрати делать это, дебил.")
	help_phrases = list("Что за черт?!",
											"Уйди или я позвоню копам!!",
											"Что происходит?!",
											"Прекрати!",
											"Не трогайте меня, у меня дети!",
											"Кто-то, позвоните в скорую!")

/mob/living/carbon/human/npc/bandit
	vampire_faction = "City"
	max_stat = 3

/mob/living/carbon/human/npc/bandit/Initialize()
	..()
	if(prob(33))
		base_body_mod = "f"
	if(prob(33))
		my_weapon = new /obj/item/gun/ballistic/automatic/vampire/deagle(src)
	else
		if(prob(50))
			my_weapon = new /obj/item/gun/ballistic/vampire/revolver/snub(src)
		if(prob(50))
			my_weapon = new /obj/item/melee/vampirearms/baseball(src)
		else
			my_weapon = new /obj/item/melee/vampirearms/knife(src)
	AssignSocialRole(/datum/socialrole/bandit)

/mob/living/carbon/human/npc/walkby
	vampire_faction = "City"

/mob/living/carbon/human/npc/walkby/Initialize()
	..()
	if(prob(50))
		base_body_mod = pick("s", "f")
	AssignSocialRole(pick(/datum/socialrole/usualmale, /datum/socialrole/usualfemale))

/mob/living/carbon/human/npc/hobo
	vampire_faction = "City"
	bloodquality = BLOOD_QUALITY_LOW
	old_movement = TRUE

/mob/living/carbon/human/npc/hobo/Initialize()
	..()
	if(prob(33))
		base_body_mod = "s"
	AssignSocialRole(pick(/datum/socialrole/poormale, /datum/socialrole/poorfemale))

/mob/living/carbon/human/npc/business
	vampire_faction = "City"
	bloodquality = BLOOD_QUALITY_HIGH

/mob/living/carbon/human/npc/business/Initialize()
	..()
	if(prob(66))
		base_body_mod = "s"
	AssignSocialRole(pick(/datum/socialrole/richmale, /datum/socialrole/richfemale))

/mob/living/simple_animal/pet/rat
	name = "rat"
	desc = "It's a rat."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "rat"
	icon_living = "rat"
	icon_dead = "rat_dead"
	emote_hear = list("squeeks.")
	emote_see = list("shakes its head.", "shivers.")
	speak_chance = 0
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/food/meat/slab = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	can_be_held = TRUE
	density = FALSE
	anchored = FALSE
	footstep_type = FOOTSTEP_MOB_CLAW
	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 1
	maxbloodpool = 1
	del_on_death = 1
	maxHealth = 5
	health = 5

/mob/living/simple_animal/pet/rat/Initialize()
	. = ..()
	pixel_w = rand(-8, 8)
	pixel_z = rand(-8, 8)

/mob/living/simple_animal/pet/rat/Life()
	. = ..()
	var/delete_me = TRUE
	for(var/mob/living/carbon/human/H in oviewers(5, src))
		if(H)
			delete_me = FALSE
	if(delete_me)
		death()

/mob/living/simple_animal/hostile/beastmaster/rat
	name = "rat"
	desc = "It's a rat."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "rat"
	icon_living = "rat"
	icon_dead = "rat_dead"
	emote_hear = list("squeeks.")
	emote_see = list("shakes its head.", "shivers.")
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'code/modules/wod13/sounds/rat.ogg'
	speak_chance = 0
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/food/meat/slab = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	can_be_held = TRUE
	density = FALSE
	anchored = FALSE
	footstep_type = FOOTSTEP_MOB_CLAW
	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 1
	maxbloodpool = 1
	del_on_death = 1
	maxHealth = 20
	health = 20
	harm_intent_damage = 10
	melee_damage_lower = 5
	melee_damage_upper = 10
	speed = 0
	dodging = TRUE

/mob/living/simple_animal/hostile/beastmaster/rat/Initialize()
	. = ..()
	pixel_w = rand(-8, 8)
	pixel_z = rand(-8, 8)

/mob/living/simple_animal/hostile/beastmaster/rat/flying
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	name = "bat"
	desc = "It's a bat."
	is_flying_animal = TRUE
	maxHealth = 10
	health = 10
	speed = -0.8

/mob/living/simple_animal/hostile/beastmaster/rat/flying/UnarmedAttack(atom/A)
	. = ..()
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.bloodpool)
			if(prob(10))
				H.bloodpool = max(0, H.bloodpool-1)
				beastmaster.bloodpool = min(beastmaster.maxbloodpool, beastmaster.bloodpool+1)

/datum/socialrole/shop
	s_tones = list("albino",
								"caucasian1",
								"caucasian2",
								"caucasian3")

	min_age = 18
	max_age = 45
	preferedgender = MALE
	male_names = null
	surnames = null

	hair_colors = list("040404",	//Black
										"120b05",	//Dark Brown
										"342414",	//Brown
										"554433",	//Light Brown
										"695c3b",	//Dark Blond
										"ad924e",	//Blond
										"dac07f",	//Light Blond
										"802400",	//Ginger
										"a5380e",	//Ginger alt
										"ffeace",	//Albino
										"650b0b",	//Punk Red
										"14350e",	//Punk Green
										"080918")	//Punk Blue
	male_hair = list("Balding Hair",
										"Bedhead",
										"Bedhead 2",
										"Bedhead 3",
										"Boddicker",
										"Business Hair",
										"Business Hair 2",
										"Business Hair 3",
										"Business Hair 4",
										"Coffee House",
										"Combover",
										"Crewcut",
										"Father",
										"Flat Top",
										"Gelled Back",
										"Joestar",
										"Keanu Hair",
										"Oxton",
										"Volaju")
	male_facial = list("Beard (Abraham Lincoln)",
											"Beard (Chinstrap)",
											"Beard (Full)",
											"Beard (Cropped Fullbeard)",
											"Beard (Hipster)",
											"Beard (Neckbeard)",
											"Beard (Three o Clock Shadow)",
											"Beard (Five o Clock Shadow)",
											"Beard (Seven o Clock Shadow)",
											"Moustache (Hulk Hogan)",
											"Moustache (Watson)",
											"Sideburns (Elvis)",
											"Sideburns",
											"Shaved")

	shoes = list(/obj/item/clothing/shoes/vampire/sneakers,
								/obj/item/clothing/shoes/vampire,
								/obj/item/clothing/shoes/vampire/brown)
	uniforms = list(/obj/item/clothing/under/vampire/mechanic)
	pockets = list(/obj/item/vamp/keys/npc,
					/obj/item/stack/dollar/rand)

	male_phrases = list("Хочешь купить что-нибудь?",
											"Могу я помочь?",
											"У нас большой ассортимент!")
	neutral_phrases = list("Хочешь купить это самое?",
											"Могу я помочь?",
											"И чего это я вышел в ночную смену..?")
	random_phrases = list("Посмотри на эту вещицу!",
												"Помочь?",
												"Нету денег - нет конфетки.")
	answer_phrases = list("Я просто работаю...",
									"Не часто ночью увидишь клиентов",
									"Всего хорошего!")
	help_phrases = list("Что за пиздец?!",
											"Уйди прочь или вызову копов!!",
											"Че происходит?!",
											"Прекрати это делать!",
											"ПОЗВОНИТЕ В СКОРУЮ!")

/mob/living/carbon/human/npc/shop
	vampire_faction = "City"
	staying = TRUE
	is_talking = TRUE

/mob/living/carbon/human/npc/shop/Initialize()
	..()
	if(prob(66))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/shop)

/datum/socialrole/shop/bacotell
	uniforms = list(/obj/item/clothing/under/vampire/bacotell)

/mob/living/carbon/human/npc/bacotell
	vampire_faction = "City"
	staying = TRUE

/mob/living/carbon/human/npc/bacotell/Initialize()
	..()
	if(prob(66))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/shop/bacotell)

/datum/socialrole/shop/bubway
	uniforms = list(/obj/item/clothing/under/vampire/bubway)

/mob/living/carbon/human/npc/bubway
	vampire_faction = "City"
	staying = TRUE

/mob/living/carbon/human/npc/bubway/Initialize()
	..()
	if(prob(66))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/shop/bubway)

/datum/socialrole/shop/gummaguts
	uniforms = list(/obj/item/clothing/under/vampire/gummaguts)

/mob/living/carbon/human/npc/gummaguts
	vampire_faction = "City"
	staying = TRUE

/mob/living/carbon/human/npc/gummaguts/Initialize()
	..()
	if(prob(66))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/shop/gummaguts)

/datum/socialrole/police
	s_tones = list("albino",
								"caucasian1",
								"caucasian2",
								"caucasian3")

	min_age = 18
	max_age = 45
	preferedgender = MALE
	male_names = null
	surnames = null

	hair_colors = list("040404",	//Black
										"120b05",	//Dark Brown
										"342414",	//Brown
										"554433",	//Light Brown
										"695c3b",	//Dark Blond
										"ad924e",	//Blond
										"dac07f",	//Light Blond
										"802400",	//Ginger
										"a5380e",	//Ginger alt
										"ffeace",	//Albino
										"650b0b",	//Punk Red
										"14350e",	//Punk Green
										"080918")	//Punk Blue
	male_hair = list("Balding Hair",
										"Bedhead",
										"Bedhead 2",
										"Bedhead 3",
										"Boddicker",
										"Business Hair",
										"Business Hair 2",
										"Business Hair 3",
										"Business Hair 4",
										"Coffee House",
										"Combover",
										"Crewcut",
										"Father",
										"Flat Top",
										"Gelled Back",
										"Joestar",
										"Keanu Hair",
										"Oxton",
										"Volaju")
	male_facial = list("Beard (Abraham Lincoln)",
											"Beard (Chinstrap)",
											"Beard (Full)",
											"Beard (Cropped Fullbeard)",
											"Beard (Hipster)",
											"Beard (Neckbeard)",
											"Beard (Three o Clock Shadow)",
											"Beard (Five o Clock Shadow)",
											"Beard (Seven o Clock Shadow)",
											"Moustache (Hulk Hogan)",
											"Moustache (Watson)",
											"Sideburns (Elvis)",
											"Sideburns",
											"Shaved")

	shoes = list(/obj/item/clothing/shoes/vampire/jackboots)
	uniforms = list(/obj/item/clothing/under/vampire/police)
	hats = list(/obj/item/clothing/head/vampire/police)
	suits = list(/obj/item/clothing/suit/vampire/vest/police)
	pockets = list(/obj/item/stack/dollar/rand)

	male_phrases = list("Я наблюдаю за тобой.",
											"Выглядишь подозрительно...",
											"Для тебя есть несколько пуль, если ты подашься в криминал.",
											"Я - закон.",
											"Вы видели мужика в черном плаще и черными волосами?")
	neutral_phrases = list("Я наблюдаю за тобой.",
											"Выглядишь странно...",
											"Хороший бандит - мертвый бандит.",
											"Я здесь закон.",
											"Вы видели карлика в коричневом пальто и маске?")
	random_phrases = list("Я наблюдаю за тобой.",
											"Выглядишь опасно...",
											"У меня есть несколько пуль для окончания твоей криминальной карьеры.",
											"Закон - мое второе имя.",
											"Не видели никого подозрительного?")
	answer_phrases = list("Я здесь, чтобы защищать вас.")
	help_phrases = list("ЛОЖИСЬ НА ЗЕМЛЮ!",
											"Остановись!!",
											"Ни шагу!",
											"Брось своё оружие!",
											"Прекрати это сейчас же!!",
											"Это полиция Сан-Франциско, лечь на землю!")

/mob/living/carbon/human/npc/police
	vampire_faction = "City"
	fights_anyway = TRUE
	max_stat = 4

/mob/living/carbon/human/npc/police/Initialize()
	..()
	if(prob(66))
		base_body_mod = "f"
	if(prob(66))
		my_weapon = new /obj/item/gun/ballistic/vampire/revolver(src)
	else
		my_weapon = new /obj/item/gun/ballistic/automatic/vampire/ar15(src)
	ignores_warrant = TRUE
	AssignSocialRole(/datum/socialrole/police)

/mob/living/carbon/human/npc/police/Life()
	. = ..()
	if(stat < 1)
		if(prob(10))
			for(var/mob/living/carbon/human/H in oviewers(4, src))
				if(H)
					if(H.warrant)
						Aggro(H, FALSE)

/datum/socialrole/guard
	s_tones = list(
		"albino",
		"caucasian1",
		"caucasian2",
		"caucasian3"
	)

	min_age = 18
	max_age = 85
	preferedgender = MALE
	male_names = null
	surnames = null

	hair_colors = list(
		"040404",	//Black
		"120b05",	//Dark Brown
		"342414",	//Brown
		"554433",	//Light Brown
		"695c3b",	//Dark Blond
		"ad924e",	//Blond
		"dac07f",	//Light Blond
		"802400",	//Ginger
		"a5380e",	//Ginger alt
		"ffeace",	//Albino
		"650b0b",	//Punk Red
		"14350e",	//Punk Green
		"080918"	//Punk Blue
	)
	male_hair = list(
		"Balding Hair",
		"Bedhead",
		"Bedhead 2",
		"Bedhead 3",
		"Boddicker",
		"Business Hair",
		"Business Hair 2",
		"Business Hair 3",
		"Business Hair 4",
		"Coffee House",
		"Combover",
		"Crewcut",
		"Father",
		"Flat Top",
		"Gelled Back",
		"Joestar",
		"Keanu Hair",
		"Oxton",
		"Volaju"
	)
	male_facial = list(
		"Beard (Abraham Lincoln)",
		"Beard (Chinstrap)",
		"Beard (Full)",
		"Beard (Cropped Fullbeard)",
		"Beard (Hipster)",
		"Beard (Neckbeard)",
		"Beard (Three o Clock Shadow)",
		"Beard (Five o Clock Shadow)",
		"Beard (Seven o Clock Shadow)",
		"Moustache (Hulk Hogan)",
		"Moustache (Watson)",
		"Sideburns (Elvis)",
		"Sideburns",
		"Shaved"
	)

	shoes = list(/obj/item/clothing/shoes/vampire)
	uniforms = list(/obj/item/clothing/under/vampire/guard)
	pockets = list(/obj/item/vamp/keys/npc, /obj/item/stack/dollar/rand)

	neutral_phrases = list(
		"Нечего здесь слоняться.",
		"Я почти как коп.",
		"Щас бы пропустить рюмочку другую.",
		"Хорошая форма, правда?",
		"Встретимся позже, с меня пиво."
	)
	neutral_phrases = list(
		"Не околачивайтесь здесь.",
		"Я полицейский на полставки.",
		"Пиво - от слова пить.",
		"Скоро будет отпуск!",
		"Правда красивая форма?",
		"Встретимся позже, с меня пивко."
	)
	random_phrases = list(
		"Сегодня тихая ночка....",
		"Мой брат и папа тоже охранники.",
		"Вот бы мне телик сюда подогнали!"
	)
	answer_phrases = list("Мне нужно немного кофе.")
	help_phrases = list(
		"Пришло время бежать!",
		"Стой прямо там!!",
		"Брось своё оружие!",
		"Замри!!",
		"Я не просто пугало!"
	)

/mob/living/carbon/human/npc/guard
	vampire_faction = "City"
	staying = TRUE
	fights_anyway = TRUE
	max_stat = 4

/mob/living/carbon/human/npc/guard/Initialize()
	..()
	if(prob(66))
		base_body_mod = "f"
	my_weapon = new /obj/item/gun/ballistic/automatic/vampire/m1911(src)
	AssignSocialRole(/datum/socialrole/guard)

/mob/living/carbon/human/npc/walkby/club/Life()
	. = ..()
	if(staying && stat < 2)
		if(prob(5))
			var/hasjukebox = FALSE
			for(var/obj/machinery/jukebox/J in range(5, src))
				if(J)
					hasjukebox = TRUE
					if(J.active)
						if(prob(50))
							dancefirst(src)
						else
							dancesecond(src)
			if(!hasjukebox)
				staying = FALSE

/mob/living/carbon/human/npc/walkby/club
	vampire_faction = "City"
	staying = TRUE

/datum/socialrole/stripfemale
	s_tones = list("albino",
								"caucasian1",
								"caucasian2",
								"caucasian3")

	min_age = 18
	max_age = 30
	preferedgender = FEMALE
	female_names = null
	surnames = null

	hair_colors = list("040404",	//Black
										"120b05",	//Dark Brown
										"342414",	//Brown
										"554433",	//Light Brown
										"695c3b",	//Dark Blond
										"ad924e",	//Blond
										"dac07f",	//Light Blond
										"802400",	//Ginger
										"a5380e",	//Ginger alt
										"ffeace",	//Albino
										"650b0b",	//Punk Red
										"14350e",	//Punk Green
										"080918")	//Punk Blue
	female_hair = list("Ahoge",
										"Long Bedhead",
										"Beehive",
										"Beehive 2",
										"Bob Hair",
										"Bob Hair 2",
										"Bob Hair 3",
										"Bob Hair 4",
										"Bobcurl",
										"Braided",
										"Braided Front",
										"Braid (Short)",
										"Braid (Low)",
										"Bun Head",
										"Bun Head 2",
										"Bun Head 3",
										"Bun (Large)",
										"Bun (Tight)",
										"Double Bun",
										"Emo",
										"Emo Fringe",
										"Feather",
										"Gentle",
										"Long Hair 1",
										"Long Hair 2",
										"Long Hair 3",
										"Long Over Eye",
										"Long Emo",
										"Long Fringe",
										"Ponytail",
										"Ponytail 2",
										"Ponytail 3",
										"Ponytail 4",
										"Ponytail 5",
										"Ponytail 6",
										"Ponytail 7",
										"Ponytail (High)",
										"Ponytail (Short)",
										"Ponytail (Long)",
										"Ponytail (Country)",
										"Ponytail (Fringe)",
										"Poofy",
										"Short Hair Rosa",
										"Shoulder-length Hair",
										"Volaju")

	shoes = list(/obj/item/clothing/shoes/vampire/heels)
	uniforms = list(/obj/item/clothing/under/vampire/burlesque)
	backpacks = list()

	female_phrases = list("Хочешь потрогать мои титечки?",
											"Тебе нравится моя попка?",
											"Будем играть?",
											"Ухх-ахх...",
											"Всё, что ты пожелаешь...",
											"Садись и отдохни~.",
											"Нравица~?",
											"Аххх...")
	neutral_phrases = list("Хорошие буфера, да?",
											"Тебе нравится моя жопка?",
											"Я хочу сыграть с тобой в игру",
											"Хе-хе.",
											"Любой танец для тебя...",
											"Отдохни, пирожочек~.",
											"Нравится?",
											"Ухххх~...")
	random_phrases = list("Хочешь мои дыньки?",
											"Тебе нравится моя задница?",
											"Хочешь поиграть?",
											"Хи-хи.",
											"Любой танец для тебя...",
											"Сиди и наслаждайся.",
											"Тебе нравится это?",
											"Ахх~...")
	answer_phrases = list("Это будет стоить...",
												"Хи-хи-хи.",
												"Двадцать баксов.",
												"Уверена, ты сделаешь...")
	help_phrases = list("О Боже!",
											"АААХХХ!!",
											"Я просто стриптизерша!",
											"Прекрати!",
											"ПОМОГИТЕ МНЕ!",
											"ПОМОГИТЕ!")

/mob/living/carbon/human/npc/stripper
	vampire_faction = "City"
	staying = TRUE

/mob/living/carbon/human/npc/stripper/Initialize()
	..()
	base_body_mod = "s"
	AssignSocialRole(/datum/socialrole/stripfemale)
	underwear = "Nude"
	undershirt = "Nude"
	socks = "Nude"
	update_body()

/mob/living/carbon/human/npc/stripper/Life()
	. = ..()
	if(stat < 2)
		if(prob(20))
			for(var/obj/structure/pole/P in range(1, src))
				if(P)
					drop_all_held_items()
					ClickOn(P)

/mob/living/carbon/human/npc/incel
	vampire_faction = "City"
	staying = TRUE

/mob/living/carbon/human/npc/incel/Initialize()
	..()
	if(prob(50))
		base_body_mod = "f"
	AssignSocialRole(/datum/socialrole/usualmale)

/datum/socialrole/shop/illegal
	masks = list(/obj/item/clothing/mask/vampire/balaclava)
	shoes = list(/obj/item/clothing/shoes/vampire/sneakers)
	uniforms = list(/obj/item/clothing/under/vampire/emo)
	pockets = list(/obj/item/stack/dollar/rand)

	male_phrases = list("Псс... хочешь немного травки?",
											"Эй, бродяга...",
											"Проверить бы это дерьмо...")
	neutral_phrases = list("Первая доза бесплатно!",
											"Скиталец...",
											"Что я вообще продаю...")
	random_phrases = list("Псс... у меня есть кое-что для тебя",
											"Бродяга, дуй сюда...",
											"Мой товар не из лучших, но лучше здесь не найти")
	answer_phrases = list("Ничего личного...")
	help_phrases = list("КОПЫ!!",
											"Блять, мусора!!",
											"МЕНТЫ?!!")

/mob/living/carbon/human/npc/illegal
	vampire_faction = "City"
	staying = TRUE
	is_talking = TRUE

/mob/living/carbon/human/npc/illegal/Initialize()
	..()
	AssignSocialRole(/datum/socialrole/shop/illegal)
