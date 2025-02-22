/datum/whitelist
	var/ckey
	var/whitelist
	var/approver_ckey
	var/ticket_link
	var/approval_reason
	var/date_whitelisted

/datum/whitelist/New(var/ckey, var/whitelist, var/approver_ckey, var/ticket_link, var/approval_reason, var/date_whitelisted)
	src.ckey = ckey
	src.whitelist = whitelist
	src.approver_ckey = approver_ckey
	src.ticket_link = ticket_link
	src.approval_reason = approval_reason
	if (date_whitelisted)
		src.date_whitelisted = date_whitelisted
	else
		src.date_whitelisted = SQLtime()

