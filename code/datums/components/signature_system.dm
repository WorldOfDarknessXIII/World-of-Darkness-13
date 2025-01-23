// The signature system, attached to humans when spawning, currently used for handling letters
// See postal.dm and passport.dm for a use case
// For admins: This works based on real_name, if you edit eligible_signers, make sure to use a mob's real_name, not their name
/datum/component/signature_system
	///People who can sign documents in the name of this person, changeable through the fake passport
	var/list/eligible_signers = list()

/datum/component/signature_system/Initialize(person)
	add_signer(person)

/datum/component/signature_system/proc/add_signer(person)
	if(!ishuman(person))
		return
	var/mob/living/carbon/human/human = person
	var/name = human.real_name
	if(name in eligible_signers)
		return
	eligible_signers.Add(name)
	return name

/datum/component/signature_system/proc/remove_signer(name)
	// It got varedited out or you tried to remove things twice
	if(name in eligible_signers)
		eligible_signers.Remove(name)
		return name

/datum/component/signature_system/proc/is_eligible_signer(name)
	if(name in eligible_signers)
		return TRUE
