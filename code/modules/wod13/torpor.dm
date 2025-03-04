/atom/movable/screen/alert/untorpor
	name = "Awaken"
	desc = "Free yourself of your Torpor."
	icon_state = "awaken"

/atom/movable/screen/alert/untorpor/Click()
	if(isobserver(usr))
		return
	var/mob/living/living_owner = owner
	if (iskindred(living_owner))
		var/mob/living/carbon/human/vampire = living_owner
		var/datum/species/kindred/kindred_species = vampire.dna.species
		if (COOLDOWN_FINISHED(kindred_species, torpor_timer) && (vampire.bloodpool > 0))
			vampire.untorpor()
			spawn()
				vampire.clear_alert("succumb")
		else
			to_chat(usr, "<span class='purple'><i>You are in Torpor, the sleep of death that vampires go into when injured, starved, or exhausted.</i></span>")
			if (vampire.bloodpool > 0)
				to_chat(usr, "<span class='purple'><i>You will be able to awaken in <b>[DisplayTimeText(COOLDOWN_TIMELEFT(kindred_species, torpor_timer))]</b>.</i></span>")
				to_chat(usr, "<span class='purple'><i>The time to re-awaken depends on your [(vampire.humanity > 5) ? "high" : "low"] [vampire.client.prefs.enlightenment ? "Enlightenment" : "Humanity"] rating of [vampire.humanity].</i></span>")
			else
				to_chat(usr, "<span class='danger'><i>You will not be able to re-awaken, because you have no blood available to do so.</i></span>")
	if(iscathayan(living_owner))
		var/mob/living/carbon/human/vampire = living_owner
		var/datum/dharma/dharma = vampire.mind.dharma
		if (COOLDOWN_FINISHED(dharma, torpor_timer) && (vampire.yang_chi > 0 || vampire.yin_chi > 0))
			vampire.untorpor()
			spawn()
				vampire.clear_alert("succumb")
		else
			to_chat(usr, "<span class='purple'><i>You are in the Little Death, the state that Kuei-Jin go into when injured or exhausted.</i></span>")
			if (vampire.yang_chi > 0 || vampire.yin_chi > 0)
				to_chat(usr, "<span class='purple'><i>You will be able to awaken in <b>[DisplayTimeText(COOLDOWN_TIMELEFT(dharma, torpor_timer))]</b>.</i></span>")
				to_chat(usr, "<span class='purple'><i>The time to re-awaken depends on your [vampire.max_yin_chi <= 4 ? "low" : "high"] permanent Yin Chi rating of [vampire.max_yin_chi].</i></span>")
			else
				to_chat(usr, "<span class='danger'><i>You will not be able to re-awaken, because you have no Chi available to do so.</i></span>")
