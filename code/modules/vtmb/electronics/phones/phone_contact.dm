
/datum/phonecontact
	var/name = "Unknown"
	var/number = ""
	var/name_check = ""

/datum/phonecontact/New()
	..()
	check_global_contacts()

/datum/phonecontact/proc/check_global_contacts()
	return FALSE
//Normal phones won't use check_global_contacts, they can't add any of GLOB contacts.
//Remember to set the job of the phone with "my_contact_is_important = TRUE", or the check_global_contacts proc won't get activate automatically


/datum/phonecontact/brujah
	name = "Primogen Brujah"

/datum/phonecontact/brujah/check_global_contacts()
	if(number != GLOB.brujahnumber && name_check != GLOB.brujahname)
		number = GLOB.brujahnumber
		name = GLOB.brujahname + " - " + name
		return TRUE
	..()

/datum/phonecontact/malkavian
	name = "Primogen Malkavian"

/datum/phonecontact/malkavian/check_global_contacts()
	if(number != GLOB.malkaviannumber  && name_check != GLOB.malkavianname)
		number = GLOB.malkaviannumber
		name = GLOB.malkavianname + " - " + name
		return TRUE
	..()

/datum/phonecontact/nosferatu
	name = "Primogen Nosferatu"

/datum/phonecontact/nosferatu/check_global_contacts()
	if(number != GLOB.toreadornumber && name_check != GLOB.toreadorname)
		number = GLOB.nosferatunumber
		name = GLOB.nosferatuname + " - " + name
		return TRUE
	..()

/datum/phonecontact/toreador
	name = "Primogen Toreador"

/datum/phonecontact/toreador/check_global_contacts()
	if(number != GLOB.toreadornumber && name_check != GLOB.toreadorname)
		number = GLOB.toreadornumber
		name = GLOB.toreadorname + " - " + name
		return TRUE
	..()

/datum/phonecontact/ventrue
	name = "Primogen Ventrue"

/datum/phonecontact/ventrue/check_global_contacts()
	if(number != GLOB.ventruenumber && name_check != GLOB.ventruename)
		number = GLOB.ventruenumber
		name = GLOB.ventruename + " - " + name
		return TRUE
	..()

/datum/phonecontact/prince
	name = "Prince"

/datum/phonecontact/prince/check_global_contacts()
	if(number != GLOB.princenumber && name_check != GLOB.princename)
		number = GLOB.princenumber
		name = GLOB.princename + " - " + name
		return TRUE
	..()

/datum/phonecontact/sheriff
	name = "Sheriff"

/datum/phonecontact/sheriff/check_global_contacts()
	if(number != GLOB.sheriffnumber && name_check != GLOB.sheriffname)
		number = GLOB.sheriffnumber
		name = GLOB.sheriffname + " - " + name
		return TRUE
	..()

/datum/phonecontact/clerk
	name = "Seneschal"

/datum/phonecontact/clerk/check_global_contacts()
	if(number != GLOB.clerknumber && name_check != GLOB.clerkname)
		number = GLOB.clerknumber
		name = GLOB.clerkname + " - " + name
		return TRUE
	..()

/datum/phonecontact/barkeeper
	name = "Baron"

/datum/phonecontact/barkeeper/check_global_contacts()
	if(number != GLOB.barkeepernumber && name_check != GLOB.barkeepername)
		number = GLOB.barkeepernumber
		name = GLOB.barkeepername + " - " + name
		return TRUE
	..()

/datum/phonecontact/dealer
	name = "Dealer"

/datum/phonecontact/dealer/check_global_contacts()
	if(number != GLOB.dealernumber && name_check != GLOB.dealername)
		number = GLOB.dealernumber
		name = GLOB.dealername + " - " + name
		return TRUE
	..()

/datum/phonecontact/tremere
	name = "Tremere Regent"

/datum/phonecontact/tremere/check_global_contacts()
	if(number != GLOB.tremerenumber && name_check != GLOB.tremerename)
		number = GLOB.tremerenumber
		name = GLOB.tremerename + " - " + name
		return TRUE
	..()


