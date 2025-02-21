
/obj/item/radio/cop
	name = "police radio"
	subspace_transmission = FALSE
	subspace_switchable = FALSE
	keyslot = new /obj/item/encryptionkey/headset_sec

/obj/item/radio/cop/Initialize()
	. = ..()
	set_frequency(FREQ_SECURITY)

/obj/item/radio/clinic
	name = "clinic radio"
	subspace_transmission = FALSE
	subspace_switchable = FALSE
	keyslot = new /obj/item/encryptionkey/headset_medsci

/obj/item/radio/clinic/Initialize()
	. = ..()
	set_frequency(FREQ_MEDICAL)

/obj/item/radio/military
	name = "military radio"
	subspace_transmission = FALSE
	subspace_switchable = FALSE
	syndie = TRUE
	keyslot = new /obj/item/encryptionkey/syndicate

/obj/item/radio/military/Initialize()
	. = ..()
	set_frequency(FREQ_SYNDICATE)
