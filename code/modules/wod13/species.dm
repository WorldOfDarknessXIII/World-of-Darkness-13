/datum/species/proc/GiveSpeciesFlight(mob/living/carbon/human/H)
	if(flying_species) //species that already have flying traits should not work with this proc
		return
	flying_species = TRUE
	if(isnull(fly))
		fly = new
		fly.Grant(H)
	if(H.dna.features["wings"] != wings_icon)
		mutant_bodyparts["wings"] = wings_icon
		H.dna.features["wings"] = wings_icon
		H.update_body()
	var/datum/action/fly_upper/A = locate() in H.actions
	if(A)
		return
	var/datum/action/fly_upper/DA = new()
	DA.Grant(H)

/datum/species/proc/RemoveSpeciesFlight(mob/living/carbon/human/H)
	if(flying_species)
		flying_species = FALSE
		fly.Remove(H)
		QDEL_NULL(fly)
		if(H.movement_type & FLYING)
			ToggleFlight(H)
		var/datum/action/fly_upper/A = locate() in H.actions
		if(A)
			qdel(A)
		if(H.dna && H.dna.species && (H.dna.features["wings"] == wings_icon))
			H.dna.species.mutant_bodyparts -= "wings"
			H.dna.features["wings"] = "None"
			H.update_body()
