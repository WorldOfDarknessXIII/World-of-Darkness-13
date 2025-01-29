// Stuff that is relatively "core" and is used in other defines/helpers

//Returns the hex value of a decimal number
//len == length of returned string
#define num2hex(X, len) num2text(X, len, 16)

//Returns an integer given a hex input, supports negative values "-ff"
//skips preceding invalid characters
#define hex2num(X) text2num(X, 16)

/// Takes a datum as input, returns its ref string
#define text_ref(datum) ref(datum)

#define span_notice(str) ("<span class='notice'>" + str + "</span>")
#define span_warning(str) ("<span class='warning'>" + str + "</span>")
#define span_boldannounce(str) ("<span class='boldannounce'>" + str + "</span>")
#define span_hear(str) ("<span class='hear'>" + str + "</span>")

/// A null statement to guard against EmptyBlock lint without necessitating the use of pass()
/// Used to avoid proc-call overhead. But use sparingly. Probably pointless in most places.
#define EMPTY_BLOCK_GUARD ;
