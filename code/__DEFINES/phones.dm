#define COMSIG_PHONE_CALL_STARTED "phone_call_started"
#define COMSIG_PHONE_CALL_BUSY "phone_call_busy"
#define COMSIG_PHONE_CALL_ENDED "phone_call_ended"
#define COMSIG_PHONE_RING "phone_ring"

#define PHONE_IN_CALL (1<<0)
#define PHONE_NO_SIM (1<<1)
#define PHONE_OPEN (1<<2)
#define PHONE_USER_LASOMBRA (1<<3)

DEFINE_BITFIELD(phone_flags, list(
	"PHONE_IN_CALL" = PHONE_IN_CALL,
	"PHONE_NO_SIM" = PHONE_NO_SIM,
	"PHONE_OPEN" = PHONE_OPEN,
	"PHONE_USER_LASOMBRA" = PHONE_USER_LASOMBRA,
))
