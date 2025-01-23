// The signature system, attached to humans when spawning, currently used for handling letters
// See postal.dm and passport.dm for a use case
// For admins: If you want to add a person, mark the mob itself and add it to eligible_signers
/datum/component/signature_system
	///People who can sign documents in the name of this person, changeable through the fake passport
	var/list/eligible_signers = list()

/datum/component/signature_system/Initialize(person)
	add_signer(person)

/datum/component/signature_system/proc/add_signer(person)
	if(person in eligible_signers)
		return
	eligible_signers.Add(person)
	return person

/datum/component/signature_system/proc/remove_signer(person)
	if(person in eligible_signers)
		eligible_signers.Remove(person)
		return person

/datum/component/signature_system/proc/is_eligible_signer(person)
	if(person in eligible_signers)
		return TRUE
