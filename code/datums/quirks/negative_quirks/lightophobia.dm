/datum/quirk/lightophobia
	name = "Lightophobia"
	desc = "As far as you can remember, you've always been afraid of the light. While in the light without a shadow, you instinctually act careful, and constantly feel a sense of dread."
	value = -3
	medical_record_text = "Patient demonstrates a fear of the light."
	hardcore_value = 5

/datum/quirk/lightophobia/process()
	var/turf/T = get_turf(quirk_holder)
	if(T)
		var/lums = T.get_lumcount()
		if(lums > 0.5)
			if(quirk_holder.move_intent == MOVE_INTENT_RUN && prob(50))
				to_chat(quirk_holder, "<span class='warning'>Easy, easy, take it slow... you're in the light...</span>")
				quirk_holder.toggle_move_intent()
				if(prob(10))
					quirk_holder.apply_damage(5, BURN, BODY_ZONE_HEAD)
