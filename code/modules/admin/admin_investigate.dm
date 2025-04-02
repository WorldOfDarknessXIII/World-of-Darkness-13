/atom/proc/investigate_log(message, subject)
	if(!message || !subject)
		return
	var/F = file("[GLOB.log_directory]/[subject].html")
	WRITE_FILE(F, "[time_stamp()] [REF(src)] ([x],[y],[z]) || [src] [message]<br>")

/client/proc/investigate_show()
	set name = "Investigate"
	set category = "Admin.Game"
	if(!holder)
		return

	var/list/investigates = list(INVESTIGATE_RESEARCH, INVESTIGATE_EXONET, INVESTIGATE_PORTAL, INVESTIGATE_SINGULO, INVESTIGATE_WIRES, INVESTIGATE_TELESCI, INVESTIGATE_GRAVITY, INVESTIGATE_RECORDS, INVESTIGATE_CARGO, INVESTIGATE_SUPERMATTER, INVESTIGATE_ATMOS, INVESTIGATE_EXPERIMENTOR, INVESTIGATE_BOTANY, INVESTIGATE_HALLUCINATIONS, INVESTIGATE_RADIATION, INVESTIGATE_NANITES, INVESTIGATE_PRESENTS, INVESTIGATE_HYPERTORUS, INVESTIGATE_ACCESSCHANGES)

	var/list/logs_present = list("notes, memos, watchlist")
	var/list/logs_missing = list("---")

	for(var/subject in investigates)
		var/temp_file = file("[GLOB.log_directory]/[subject].html")
		if(fexists(temp_file))
			logs_present += subject
		else
			logs_missing += "[subject] (empty)"

	var/list/combined = sortList(logs_present) + sortList(logs_missing)

	var/selected = input("Investigate what?", "Investigate") as null|anything in combined

	if(!(selected in combined) || selected == "---")
		return

	selected = replacetext(selected, " (empty)", "")

	if(selected == "notes, memos, watchlist" && check_rights(R_ADMIN))
		browse_messages()
		return

	var/filepath = "[GLOB.log_directory]/[selected].html"
	var/F = file(filepath)
	if(!fexists(F))
		to_chat(src, "<span class='danger'>No [selected] logfile was found.</span>", confidential = TRUE)
		return
	var/datum/browser/browser = new(usr, "investigate[selected]", "Investigation of [selected]", 800, 300)
	browser.set_content(rustg_file_read(filepath))
	browser.open()
