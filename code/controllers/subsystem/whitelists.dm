SUBSYSTEM_DEF(whitelists)
	name = "Whitelists"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_WHITELISTS
	var/whitelists_enabled = FALSE

	///All whitelists possible to have, corresponding to everything that's whitelisted.
	var/list/possible_whitelists = list()
	///All whitelist entries found in the database. Format: "CKEY" = list("whitelist1", "whitelist2", ...)
	var/list/datum/whitelist/whitelist_entries = list()

/datum/controller/subsystem/whitelists/Initialize(timeofday)
	if(!SSdbcore.Connect())
		return ..()
	if(!CONFIG_GET(flag/whitelists_enabled))
		return ..()
	whitelists_enabled = TRUE

	for (var/key in subtypesof(/datum/vampireclan))
		var/datum/vampireclan/clan = new key
		if (clan.whitelisted)
			possible_whitelists += clan.name
		qdel(clan)

	for (var/key in subtypesof(/datum/species))
		var/datum/species/species = new key
		if (species.selectable && species.whitelisted)
			possible_whitelists += species.id
		qdel(species)

	//placeholder until a proper morality system is added
	//possible_whitelists += "enlightenment"

	update_from_database()

	return ..()

/datum/controller/subsystem/whitelists/proc/is_whitelisted(checked_ckey, checked_whitelist)
	if (!initialized)
		return FALSE
	if (!whitelists_enabled)
		return TRUE

	//enable all whitelists for admins
	for (var/client/admin in GLOB.admins)
		if (admin.ckey == checked_ckey)
			return TRUE

	//return as whitelisted if the given whitelist doesn't exist
	if (!possible_whitelists.Find(checked_whitelist))
		return TRUE

	for (var/datum/whitelist/current_whitelist in whitelist_entries)
		if ((current_whitelist.ckey == checked_ckey) && (current_whitelist.whitelist == checked_whitelist))
			return TRUE

	return FALSE

/datum/controller/subsystem/whitelists/proc/add_whitelist(var/ckey, var/whitelist, var/approver_ckey, var/ticket_link, var/approval_reason)
	if (!whitelists_enabled || !SSdbcore.Connect())
		return FALSE
	if (is_whitelisted(ckey, whitelist))
		return FALSE

	var/datum/whitelist/new_entry = new(ckey, whitelist, approver_ckey, ticket_link, approval_reason)
	whitelist_entries += new_entry

	var/datum/db_query/query = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("whitelist")] (ckey, whitelist, approver_ckey, ticket_link, approval_reason)
			VALUES (:ckey, :whitelist, :approver_ckey, :ticket_link, :approval_reason)
		"},
		list(
			"ckey" = ckey,
			"whitelist" = whitelist,
			"approver_ckey" = approver_ckey,
			"ticket_link" = ticket_link,
			"approval_reason" = approval_reason
		)
	)
	if (query.Execute())
		qdel(query)
		return TRUE
	else
		qdel(query)
		return FALSE

/datum/controller/subsystem/whitelists/proc/remove_whitelist(var/ckey, var/whitelist)
	if (!whitelists_enabled || !SSdbcore.Connect())
		return FALSE
	if (!is_whitelisted(ckey, whitelist))
		return FALSE

	for (var/datum/whitelist/current_whitelist in whitelist_entries)
		if ((current_whitelist.ckey == ckey) && (current_whitelist.whitelist == whitelist))
			whitelist_entries.Remove(current_whitelist)

	var/datum/db_query/query = SSdbcore.NewQuery({"
			DELETE FROM [format_table_name("whitelist")]
			WHERE (ckey LIKE :ckey) AND (whitelist LIKE :whitelist)
		"},
		list(
			"ckey" = ckey,
			"whitelist" = whitelist
		)
	)
	if (query.Execute())
		qdel(query)
		return TRUE
	else
		qdel(query)
		return FALSE

/datum/controller/subsystem/whitelists/proc/update_from_database()
	if (!whitelists_enabled || !SSdbcore.Connect())
		return

	whitelist_entries = list()
	var/datum/db_query/query = SSdbcore.NewQuery("SELECT ckey,whitelist,approver_ckey,ticket_link,approval_reason,date_whitelisted FROM [format_table_name("whitelist")]")
	if(!query.Execute(async = TRUE))
		qdel(query)
	else
		while(query.NextRow())
			var/datum/whitelist/entry = new(query.item[1], query.item[2], query.item[3], query.item[4], query.item[5], query.item[6])
			whitelist_entries += entry
		qdel(query)

/datum/controller/subsystem/whitelists/proc/get_user_whitelists(var/ckey)
	if (!whitelists_enabled)
		return

	var/list/datum/whitelist/user_whitelists = list()
	for (var/datum/whitelist/current_whitelist in whitelist_entries)
		if (current_whitelist.ckey == ckey)
			user_whitelists += current_whitelist.whitelist

	return user_whitelists
