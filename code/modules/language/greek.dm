/datum/language/greek
	name = "Greek"
	desc = "The language from the land of marble and philosophy."
	key = "k"
	flags = TONGUELESS_SPEECH
	space_chance = 40
	syllables = list("αι","αν","απ","ας","εί","ει","ης","ια","κα","να","ου","πο","στ","τα","τη","το","ου","αι","τα","κα","να", "στ","σε","από","και","δ","γ","φ","ψ","του","προ","μέν",
					"δεν","της","από","ρα","ά","έ","ε","ο","ρ","τ","ά","κ","ή", "α","σ","ε","ζ","τ","τ","ικ","χ","α","π","δ","β","τής","θα")
	icon_state = "greek" //Courtesy of Agate. I had made my own but lost it while shuffling files around. F
	default_priority = 90
	//But Mci, why do you have some letters in here more than once? Becuase they have a frequency level of fucking /ten/ percent across the /whole/ language. It's gonna be a common letter.
	//Or, you know. I pasted it more than once by accident and since I'm dumb and doing this in DM I can't tell.
	//Seriously it looks like a barcode.

	//On the upside, it's all in lowercase now so it shouldn't look like greek people are always SCREAMING AT THE TOP OF THEIR LUNGS