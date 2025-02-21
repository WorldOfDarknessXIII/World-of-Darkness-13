/obj/phonevoice
	name = "unknown voice"
	speech_span = SPAN_ROBOT
	anchored = FALSE
	density = FALSE
	opacity = FALSE

var/list/zalgo_letters = list(
    "̨a", "̡b", "̢c", "̷d", "̶e", "̸f", "̹g", "̺h", "̻i",
    "̼j", "̽k", "̾l", "̿m", "͈n", "͍o", "͎p", "q", "͕r",
    "͓s", "͒t", "̱u", "̲v", "̳w", "͡x", "̨y", "̨z", "̨A",
    "̨B", "̨C", "̨D", "̨E", "̨F", "̨G", "̨H", "̨I", "̨J",
    "̨K", "̨L", "̨M", "̨N", "̨O", "̨P", "̨Q", "̨R", "̨S",
    "̨T", "̨U", "̨V", "̨W", "̨X", "̨Y", "̨Z"
)

/obj/phonevoice/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_selected_language()
	send_speech(message, 2, src, , spans, message_language=language)
//	speech_span = initial(speech_span)

/proc/scramble_lasombra_message(var/message)
	var/gibberish_message = ""
	for(var/i = 1 to length(message))
		var/char = message[i]
		// Randomize or replace characters with gibberish
		if(prob(30)) // 30% chance to keep the original character
			gibberish_message += char
		else
			gibberish_message += pick(zalgo_letters) // Replace with random gibberish letters
	return gibberish_message
