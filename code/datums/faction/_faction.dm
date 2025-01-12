// This file is in mainly in charge of vampire faction & vampire_faction related datums
// for the defines heavily related to it, look at code/_DEFINES/factions.dm
/datum/faction

	/// Name of faction
	var/name
	/// Faction bitfield from factions.dm is applied here
	var/faction

/datum/faction/proc/Initialize()
	attach_signals()

/datum/faction/proc/attach_signals()
	SIGNAL_HANDLER
	RegisterSignal(src, COMSIG_FACTION_FACTION_CHECKED, PROC_REF(on_faction_check))

/datum/faction/proc/on_faction_check()
	return faction

/datum/faction/anarchs
	name = "Anarchs"
	faction = FACTION_ANARCHS

/datum/faction/camarilla
	name = "Camarilla"
	faction = FACTION_CAMARILLA

/datum/faction/sabbat
	name = "Sabbat"
	faction = FACTION_SABBAT

/datum/faction/nosferatu
	name = "Nosferatu"
	faction = FACTION_NOSFERATU

/datum/faction/giovanni
	name = "Giovanni"
	faction = FACTION_GIOVANNI

/datum/faction/tremere
	name = "Tremere"
	faction = FACTION_TREMERE

/datum/faction/city
	name = "City"
	faction = FACTION_CITY
