/datum/relationship/proc/publish()
	GLOB.relationship_list += src
	generate_relationships()

/datum/relationship
	var/need_friend = FALSE
	var/need_enemy = FALSE
	var/need_lover = FALSE

	var/datum/relationship/Friend
	var/datum/relationship/Enemy
	var/datum/relationship/Lover

	var/friend_text
	var/enemy_text
	var/lover_text

	var/phone_number

	var/mob/living/carbon/human/owner

/datum/relationship/proc/generate_relationships()
	if(!owner)
		return
	if(need_friend)
		for(var/datum/relationship/R in GLOB.relationship_list)
			if(R)
				if(R != src)
					if(R.need_friend && need_friend && !R.Friend && !Friend && R.Enemy != src && Enemy != R && R.Lover != src && Lover != R)
						Friend = R
						R.Friend = src
						to_chat(owner, "Your friend, <b>[R.owner.real_name]</b>, is now in the city!")
						to_chat(R.owner, "Your friend, <b>[owner.real_name]</b>, is now in the city!")
						need_friend = FALSE
	if(need_enemy)
		for(var/datum/relationship/R in GLOB.relationship_list)
			if(R)
				if(R != src)
					if(R.need_enemy && need_enemy && !R.Enemy && !Enemy && R.Friend != src && Friend != R && R.Lover != src && Lover != R)
						Enemy = R
						R.Enemy = src
						to_chat(owner, "Your enemy, <b>[R.owner.real_name]</b>, is now in the city!")
						to_chat(R.owner, "Your enemy, <b>[owner.real_name]</b>, is now in the city!")
						need_enemy = FALSE
	if(need_lover)
		for(var/datum/relationship/R in GLOB.relationship_list)
			if(R)
				if(R != src)
					if(R.need_lover && need_lover && !R.Lover && !Lover && R.Friend != src && Friend != R && R.Enemy != src && Enemy != R)
						if((R.owner.gender == owner.gender) && HAS_TRAIT(R.owner, TRAIT_HOMOSEXUAL) && HAS_TRAIT(owner, TRAIT_HOMOSEXUAL))
							Lover = R
							R.Lover = src
							to_chat(owner, "Your lover, <b>[R.owner.real_name]</b>, is now in the city!")
							to_chat(R.owner, "Your lover, <b>[owner.real_name]</b>, is now in the city!")
							need_lover = FALSE
						else if(!HAS_TRAIT(R.owner, TRAIT_HOMOSEXUAL) && !HAS_TRAIT(owner, TRAIT_HOMOSEXUAL) && (R.owner.gender != owner.gender))
							Lover = R
							R.Lover = src
							to_chat(owner, "Your lover, <b>[R.owner.real_name]</b>, is now in the city!")
							to_chat(R.owner, "Your lover, <b>[owner.real_name]</b>, is now in the city!")
							need_lover = FALSE
