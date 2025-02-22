/datum/admins/proc/whitelist_panel(searchkey)
	var/ckey
	var/list/output = list("All whitelists<br>To edit, use the New/Delete Whitelist verbs.<br><a href='?_src_=holder;[HrefToken()];newwhitelist=1'>New Whitelist</a><a href='?_src_=holder;[HrefToken()];reloadwhitelists=1'>Reload Whitelists</a><hr>")
	output += {"
		<form method='get' action='?src=[REF(src)]'>[HrefTokenFormField()]
		<input type='hidden' name='src' value='[REF(src)]'>
		CKey:<input type='text' name='searchwhitelistckey' size='18' value='[ckey]'>
		<input type='submit' value='Search'>
		</form>
	"}
	for(var/datum/whitelist/current_whitelist in SSwhitelists.whitelist_entries)
		if (searchkey)
			if (!findtext(current_whitelist.ckey, searchkey))
				continue
		output += {"
			CKey: [current_whitelist.ckey]
			<br>Whitelist: [current_whitelist.whitelist]
			<br>Approver Ckey: [current_whitelist.approver_ckey]
			<br>Ticket Link: <a href='url'>[current_whitelist.ticket_link]</a>
			<br>Approval Reason: [current_whitelist.approval_reason]
			<br>Date Whitelisted: [current_whitelist.date_whitelisted]
		"}
		output += "<br><a href='?_src_=holder;[HrefToken()];deletewhitelist=[REF(current_whitelist)]'> Delete Whitelist</a>"
		output += "<hr style='background:#000000; border:0; height:3px'>"
	var/datum/browser/panel = new(usr, "wlpanel", "Whitelist Panel", 700, 400)
	panel.set_content(jointext(output, ""))
	panel.open()

/datum/admins/proc/whitelist_option_parse_href(list/href_list, datum/whitelist/whitelist)
	if (href_list["deletewhitelist"])
		message_admins("[key_name_admin(usr)] removed the [whitelist.whitelist] whitelist from [whitelist.ckey].")
		log_admin("[key_name(usr)] removed the [whitelist.whitelist] whitelist from [whitelist.ckey].")
		SSwhitelists.remove_whitelist(whitelist.ckey, whitelist.whitelist)
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Revoke Whitelist") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	whitelist_panel()
