////////////////////////////////
/proc/message_admins(msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message\">[msg]</span></span>"
	to_chat(GLOB.admins,
		type = MESSAGE_TYPE_ADMINLOG,
		html = msg,
		confidential = TRUE)

/proc/relay_msg_admins(msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">RELAY:</span> <span class=\"message\">[msg]</span></span>"
	to_chat(GLOB.admins,
		type = MESSAGE_TYPE_ADMINLOG,
		html = msg,
		confidential = TRUE)

///////////////////////////////////////////////////////////////////////////////////////////////Panels

ADMIN_VERB(show_player_panel, R_ADMIN, "Player Panel", "Show the player panel window.", ADMIN_CATEGORY_GAME, mob/M in GLOB.mob_list)
	log_admin("[key_name(usr)] checked the individual player panel for [key_name(M)][isobserver(usr)?"":" while in game"].")

	if(!M)
		to_chat(usr, "<span class='warning'>You seem to be selecting a mob that doesn't exist anymore.</span>", confidential = TRUE)
		return

	var/body = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>Options for [M.key]</title></head>"
	body += "<body>Options panel for <b>[M]</b>"
	if(M.client)
		body += " played by <b>[M.client]</b> "
		body += "\[<A href='?_src_=holder;[HrefToken()];editrights=[(GLOB.admin_datums[M.client.ckey] || GLOB.deadmins[M.client.ckey]) ? "rank" : "add"];key=[M.key]'>[M.client.holder ? M.client.holder.rank : "Player"]</A>\]"
		if(CONFIG_GET(flag/use_exp_tracking))
			body += "\[<A href='?_src_=holder;[HrefToken()];getplaytimewindow=[REF(M)]'>" + M.client.get_exp_living(FALSE) + "</a>\]"

	if(isnewplayer(M))
		body += " <B>Hasn't Entered Game</B> "
	else
		body += " \[<A href='?_src_=holder;[HrefToken()];revive=[REF(M)]'>Heal</A>\] "

	if(M.client)
		body += "<br>\[<b>First Seen:</b> [M.client.player_join_date]\]\[<b>Byond account registered on:</b> [M.client.account_join_date]\]"
		body += "<br><br><b>CentCom Galactic Ban DB: </b> "
		if(CONFIG_GET(string/centcom_ban_db))
			body += "<a href='?_src_=holder;[HrefToken()];centcomlookup=[M.client.ckey]'>Search</a>"
		else
			body += "<i>Disabled</i>"
		body += "<br><br><b>Show related accounts by:</b> "
		body += "\[ <a href='?_src_=holder;[HrefToken()];showrelatedacc=cid;client=[REF(M.client)]'>CID</a> | "
		body += "<a href='?_src_=holder;[HrefToken()];showrelatedacc=ip;client=[REF(M.client)]'>IP</a> \]"
		var/rep = 0
		rep += SSpersistence.antag_rep[M.ckey]
		body += "<br><br>Antagonist reputation: [rep]"
		body += "<br><a href='?_src_=holder;[HrefToken()];modantagrep=add;mob=[REF(M)]'>\[increase\]</a> "
		body += "<a href='?_src_=holder;[HrefToken()];modantagrep=subtract;mob=[REF(M)]'>\[decrease\]</a> "
		body += "<a href='?_src_=holder;[HrefToken()];modantagrep=set;mob=[REF(M)]'>\[set\]</a> "
		body += "<a href='?_src_=holder;[HrefToken()];modantagrep=zero;mob=[REF(M)]'>\[zero\]</a>"
		var/full_version = "Unknown"
		if(M.client.byond_version)
			full_version = "[M.client.byond_version].[M.client.byond_build ? M.client.byond_build : "xxx"]"
		body += "<br>\[<b>Byond version:</b> [full_version]\]<br>"


	body += "<br><br>\[ "
	body += "<a href='?_src_=vars;[HrefToken()];Vars=[REF(M)]'>VV</a> - "
	if(M.mind)
		body += "<a href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>TP</a> - "
		body += "<a href='?_src_=holder;[HrefToken()];skill=[REF(M)]'>SKILLS</a> - "
	else
		body += "<a href='?_src_=holder;[HrefToken()];initmind=[REF(M)]'>Init Mind</a> - "
	if (iscyborg(M))
		body += "<a href='?_src_=holder;[HrefToken()];borgpanel=[REF(M)]'>BP</a> - "
	body += "<a href='?priv_msg=[M.ckey]'>PM</a> - "
	body += "<a href='?_src_=holder;[HrefToken()];subtlemessage=[REF(M)]'>SM</a> - "
	if (ishuman(M) && M.mind)
		body += "<a href='?_src_=holder;[HrefToken()];HeadsetMessage=[REF(M)]'>HM</a> - "
	body += "<a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(M)]'>FLW</a> - "
	//Default to client logs if available
	var/source = LOGSRC_MOB
	if(M.client)
		source = LOGSRC_CLIENT
	body += "<a href='?_src_=holder;[HrefToken()];individuallog=[REF(M)];log_src=[source]'>LOGS</a>\] <br>"

	body += "<b>Mob type</b> = [M.type]<br><br>"

	body += "<A href='?_src_=holder;[HrefToken()];boot2=[REF(M)]'>Kick</A> | "
	if(M.client)
		body += "<A href='?_src_=holder;[HrefToken()];newbankey=[M.key];newbanip=[M.client.address];newbancid=[M.client.computer_id]'>Ban</A> | "
	else
		body += "<A href='?_src_=holder;[HrefToken()];newbankey=[M.key]'>Ban</A> | "

	body += "<A href='?_src_=holder;[HrefToken()];showmessageckey=[M.ckey]'>Notes | Messages | Watchlist</A> | "
	if(M.client)
		body += "| <A href='?_src_=holder;[HrefToken()];sendtoprison=[REF(M)]'>Prison</A> | "
		body += "\ <A href='?_src_=holder;[HrefToken()];sendbacktolobby=[REF(M)]'>Send back to Lobby</A> | "
		var/muted = M.client.prefs.muted
		body += "<br><b>Mute: </b> "
		body += "\[<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>PRAY</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>ADMINHELP</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>DEADCHAT</font></a>\]"
		body += "(<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>toggle all</font></a>)"

	body += "<br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];jumpto=[REF(M)]'><b>Jump to</b></A> | "
	body += "<A href='?_src_=holder;[HrefToken()];getmob=[REF(M)]'>Get</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];sendmob=[REF(M)]'>Send To</A>"

	body += "<br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>Traitor panel</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];narrateto=[REF(M)]'>Narrate to</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];subtlemessage=[REF(M)]'>Subtle message</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];adjustmasquerade=[REF(M)]'>Adjust masquerade</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];adjusthumanity=[REF(M)]'>Adjust humanity</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];playsoundto=[REF(M)]'>Play sound to</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];languagemenu=[REF(M)]'>Language Menu</A>"

	if (M.client)
		if(!isnewplayer(M))
			body += "<br><br>"
			body += "<b>Transformation:</b>"
			body += "<br>"

			//Human
			if(ishuman(M) && !ismonkey(M))
				body += "<B>Human</B> | "
			else
				body += "<A href='?_src_=holder;[HrefToken()];humanone=[REF(M)]'>Humanize</A> | "

			//Monkey
			if(ismonkey(M))
				body += "<B>Monkeyized</B> | "
			else
				body += "<A href='?_src_=holder;[HrefToken()];monkeyone=[REF(M)]'>Monkeyize</A> | "

			//Corgi
			if(iscorgi(M))
				body += "<B>Corgized</B> | "
			else
				body += "<A href='?_src_=holder;[HrefToken()];corgione=[REF(M)]'>Corgize</A> | "

			//AI / Cyborg
			if(isAI(M))
				body += "<B>Is an AI</B> "
			else if(ishuman(M))
				body += "<A href='?_src_=holder;[HrefToken()];makeai=[REF(M)]'>Make AI</A> | "
				body += "<A href='?_src_=holder;[HrefToken()];makerobot=[REF(M)]'>Make Robot</A> | "
				body += "<A href='?_src_=holder;[HrefToken()];makealien=[REF(M)]'>Make Alien</A> | "
				body += "<A href='?_src_=holder;[HrefToken()];makeslime=[REF(M)]'>Make Slime</A> | "
				body += "<A href='?_src_=holder;[HrefToken()];makeblob=[REF(M)]'>Make Blob</A> | "

			//Simple Animals
			if(isanimal(M))
				body += "<A href='?_src_=holder;[HrefToken()];makeanimal=[REF(M)]'>Re-Animalize</A> | "
			else
				body += "<A href='?_src_=holder;[HrefToken()];makeanimal=[REF(M)]'>Animalize</A> | "

			body += "<br><br>"
			body += "<b>Rudimentary transformation:</b><font size=2><br>These transformations only create a new mob type and copy stuff over. They do not take into account MMIs and similar mob-specific things. The buttons in 'Transformations' are preferred, when possible.</font><br>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=observer;mob=[REF(M)]'>Observer</A> | "
			body += "\[ Alien: <A href='?_src_=holder;[HrefToken()];simplemake=drone;mob=[REF(M)]'>Drone</A>, "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=hunter;mob=[REF(M)]'>Hunter</A>, "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=sentinel;mob=[REF(M)]'>Sentinel</A>, "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=praetorian;mob=[REF(M)]'>Praetorian</A>, "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=queen;mob=[REF(M)]'>Queen</A>, "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=larva;mob=[REF(M)]'>Larva</A> \] "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=human;mob=[REF(M)]'>Human</A> "
			body += "\[ slime: <A href='?_src_=holder;[HrefToken()];simplemake=slime;mob=[REF(M)]'>Baby</A>, "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=adultslime;mob=[REF(M)]'>Adult</A> \] "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=monkey;mob=[REF(M)]'>Monkey</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=robot;mob=[REF(M)]'>Cyborg</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=cat;mob=[REF(M)]'>Cat</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=runtime;mob=[REF(M)]'>Runtime</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=corgi;mob=[REF(M)]'>Corgi</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=ian;mob=[REF(M)]'>Ian</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=crab;mob=[REF(M)]'>Crab</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=coffee;mob=[REF(M)]'>Coffee</A> | "
			body += "\[ Construct: <A href='?_src_=holder;[HrefToken()];simplemake=constructarmored;mob=[REF(M)]'>Juggernaut</A> , "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=constructbuilder;mob=[REF(M)]'>Artificer</A> , "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=constructwraith;mob=[REF(M)]'>Wraith</A> \] "
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=shade;mob=[REF(M)]'>Shade</A>"
			body += "<br>"

	if (M.client)
		body += "<br><br>"
		body += "<b>Other actions:</b>"
		body += "<br>"
		body += "<A href='?_src_=holder;[HrefToken()];forcespeech=[REF(M)]'>Forcesay</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];tdome1=[REF(M)]'>Thunderdome 1</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];tdome2=[REF(M)]'>Thunderdome 2</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];tdomeadmin=[REF(M)]'>Thunderdome Admin</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];tdomeobserve=[REF(M)]'>Thunderdome Observer</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];admincommend=[REF(M)]'>Commend Behavior</A> | "

	body += "<br>"
	body += "</body></html>"

	usr << browse(body, "window=adminplayeropts-[REF(M)];size=550x515")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Player Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(show_player_panel, R_ADMIN, "Access Newscaster Network", "Allows you to view, add and edit news feeds.", ADMIN_CATEGORY_EVENTS)
	var/dat
	dat = text("<HEAD><TITLE>Admin Newscaster</TITLE></HEAD><H3>Admin Newscaster Unit</H3>")

	switch(admincaster_screen)
		if(0)
			dat += "Welcome to the admin newscaster.<BR> Here you can add, edit and censor every newspiece on the network."
			dat += "<BR>Feed channels and stories entered through here will be uneditable and handled as official news by the rest of the units."
			dat += "<BR>Note that this panel allows full freedom over the news network, there are no constrictions except the few basic ones. Don't break things!</FONT>"
			if(GLOB.news_network.wanted_issue.active)
				dat+= "<HR><A href='?src=[REF(src)];[HrefToken()];ac_view_wanted=1'>Read Wanted Issue</A>"
			dat+= "<HR><BR><A href='?src=[REF(src)];[HrefToken()];ac_create_channel=1'>Create Feed Channel</A>"
			dat+= "<BR><A href='?src=[REF(src)];[HrefToken()];ac_view=1'>View Feed Channels</A>"
			dat+= "<BR><A href='?src=[REF(src)];[HrefToken()];ac_create_feed_story=1'>Submit new Feed story</A>"
			dat+= "<BR><BR><A href='?src=[REF(usr)];[HrefToken()];mach_close=newscaster_main'>Exit</A>"
			var/wanted_already = 0
			if(GLOB.news_network.wanted_issue.active)
				wanted_already = 1
			dat+="<HR><B>Feed Security functions:</B><BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_menu_wanted=1'>[(wanted_already) ? ("Manage") : ("Publish")] \"Wanted\" Issue</A>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_menu_censor_story=1'>Censor Feed Stories</A>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_menu_censor_channel=1'>Mark Feed Channel with Nanotrasen D-Notice (disables and locks the channel).</A>"
			dat+="<BR><HR><A href='?src=[REF(src)];[HrefToken()];ac_set_signature=1'>The newscaster recognises you as:<BR> <FONT COLOR='green'>[src.admin_signature]</FONT></A>"
		if(1)
			dat+= "Station Feed Channels<HR>"
			if( !length(GLOB.news_network.network_channels) )
				dat+="<I>No active channels found...</I>"
			else
				for(var/datum/newscaster/feed_channel/CHANNEL in GLOB.news_network.network_channels)
					if(CHANNEL.is_admin_channel)
						dat+="<B><FONT style='BACKGROUND-COLOR: LightGreen'><A href='?src=[REF(src)];ac_show_channel=[REF(CHANNEL)]'>[CHANNEL.channel_name]</A></FONT></B><BR>"
					else
						dat+="<B><A href='?src=[REF(src)];[HrefToken()];ac_show_channel=[REF(CHANNEL)]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : ""]<BR></B>"
			dat+="<BR><HR><A href='?src=[REF(src)];[HrefToken()];ac_refresh=1'>Refresh</A>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Back</A>"
		if(2)
			dat+="Creating new Feed Channel..."
			dat+="<HR><B><A href='?src=[REF(src)];[HrefToken()];ac_set_channel_name=1'>Channel Name</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>"
			dat+="<B><A href='?src=[REF(src)];[HrefToken()];ac_set_signature=1'>Channel Author</A>:</B> <FONT COLOR='green'>[src.admin_signature]</FONT><BR>"
			dat+="<B><A href='?src=[REF(src)];[HrefToken()];ac_set_channel_lock=1'>Will Accept Public Feeds</A>:</B> [(src.admincaster_feed_channel.locked) ? ("NO") : ("YES")]<BR><BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_submit_new_channel=1'>Submit</A><BR><BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Cancel</A><BR>"
		if(3)
			dat+="Creating new Feed Message..."
			dat+="<HR><B><A href='?src=[REF(src)];[HrefToken()];ac_set_channel_receiving=1'>Receiving Channel</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>" //MARK
			dat+="<B>Message Author:</B> <FONT COLOR='green'>[src.admin_signature]</FONT><BR>"
			dat+="<B><A href='?src=[REF(src)];[HrefToken()];ac_set_new_message=1'>Message Body</A>:</B> [src.admincaster_feed_message.returnBody(-1)] <BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_submit_new_message=1'>Submit</A><BR><BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Cancel</A><BR>"
		if(4)
			dat+="Feed story successfully submitted to [src.admincaster_feed_channel.channel_name].<BR><BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Return</A><BR>"
		if(5)
			dat+="Feed Channel [src.admincaster_feed_channel.channel_name] created successfully.<BR><BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Return</A><BR>"
		if(6)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed story to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name=="")
				dat+="<FONT COLOR='maroon'>Invalid receiving channel name.</FONT><BR>"
			if(src.admincaster_feed_message.returnBody(-1) == "" || src.admincaster_feed_message.returnBody(-1) == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid message body.</FONT><BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[3]'>Return</A><BR>"
		if(7)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed Channel to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name =="" || src.admincaster_feed_channel.channel_name == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid channel name.</FONT><BR>"
			var/check = 0
			for(var/datum/newscaster/feed_channel/FC in GLOB.news_network.network_channels)
				if(FC.channel_name == src.admincaster_feed_channel.channel_name)
					check = 1
					break
			if(check)
				dat+="<FONT COLOR='maroon'>Channel name already in use.</FONT><BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[2]'>Return</A><BR>"
		if(9)
			dat+="<B>[admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[created by: <FONT COLOR='maroon'>[admincaster_feed_channel.returnAuthor(-1)]</FONT>\]</FONT><HR>"
			if(src.admincaster_feed_channel.censored)
				dat+="<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a Nanotrasen D-Notice.<BR>"
				dat+="No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>"
			else
				if( !length(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					var/i = 0
					for(var/datum/newscaster/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						i++
						dat+="-[MESSAGE.returnBody(-1)] <BR>"
						if(MESSAGE.img)
							usr << browse_rsc(MESSAGE.img, "tmp_photo[i].png")
							dat+="<img src='tmp_photo[i].png' width = '180'><BR><BR>"
						dat+="<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.returnAuthor(-1)]</FONT>\]</FONT><BR>"
						dat+="[MESSAGE.comments.len] comment[MESSAGE.comments.len > 1 ? "s" : ""]:<br>"
						for(var/datum/newscaster/feed_comment/comment in MESSAGE.comments)
							dat+="[comment.body]<br><font size=1>[comment.author] [comment.time_stamp]</font><br>"
						dat+="<br>"
			dat+="<BR><HR><A href='?src=[REF(src)];[HrefToken()];ac_refresh=1'>Refresh</A>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[1]'>Back</A>"
		if(10)
			dat+="<B>Nanotrasen Feed Censorship Tool</B><BR>"
			dat+="<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>"
			dat+="Keep in mind that users attempting to view a censored feed will instead see the \[REDACTED\] tag above it.</FONT>"
			dat+="<HR>Select Feed channel to get Stories from:<BR>"
			if(!length(GLOB.news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/newscaster/feed_channel/CHANNEL in GLOB.news_network.network_channels)
					dat+="<A href='?src=[REF(src)];[HrefToken()];ac_pick_censor_channel=[REF(CHANNEL)]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : ""]<BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Cancel</A>"
		if(11)
			dat+="<B>Nanotrasen D-Notice Handler</B><HR>"
			dat+="<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the station's"
			dat+="morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed"
			dat+="stories it might contain at the time. You can lift a D-Notice if you have the required access at any time.</FONT><HR>"
			if(!length(GLOB.news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/newscaster/feed_channel/CHANNEL in GLOB.news_network.network_channels)
					dat+="<A href='?src=[REF(src)];[HrefToken()];ac_pick_d_notice=[REF(CHANNEL)]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : ""]<BR>"

			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Back</A>"
		if(12)
			dat+="<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.returnAuthor(-1)]</FONT> \]</FONT><BR>"
			dat+="<FONT SIZE=2><A href='?src=[REF(src)];[HrefToken()];ac_censor_channel_author=[REF(src.admincaster_feed_channel)]'>[(src.admincaster_feed_channel.authorCensor) ? ("Undo Author censorship") : ("Censor channel Author")]</A></FONT><HR>"

			if( !length(src.admincaster_feed_channel.messages) )
				dat+="<I>No feed messages found in channel...</I><BR>"
			else
				for(var/datum/newscaster/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
					dat+="-[MESSAGE.returnBody(-1)] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.returnAuthor(-1)]</FONT>\]</FONT><BR>"
					dat+="<FONT SIZE=2><A href='?src=[REF(src)];[HrefToken()];ac_censor_channel_story_body=[REF(MESSAGE)]'>[(MESSAGE.bodyCensor) ? ("Undo story censorship") : ("Censor story")]</A>  -  <A href='?src=[REF(src)];[HrefToken()];ac_censor_channel_story_author=[REF(MESSAGE)]'>[(MESSAGE.authorCensor) ? ("Undo Author Censorship") : ("Censor message Author")]</A></FONT><BR>"
					dat+="[MESSAGE.comments.len] comment[MESSAGE.comments.len > 1 ? "s" : ""]: <a href='?src=[REF(src)];[HrefToken()];ac_lock_comment=[REF(MESSAGE)]'>[MESSAGE.locked ? "Unlock" : "Lock"]</a><br>"
					for(var/datum/newscaster/feed_comment/comment in MESSAGE.comments)
						dat+="[comment.body] <a href='?src=[REF(src)];[HrefToken()];ac_del_comment=[REF(comment)];ac_del_comment_msg=[REF(MESSAGE)]'>X</a><br><font size=1>[comment.author] [comment.time_stamp]</font><br>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[10]'>Back</A>"
		if(13)
			dat+="<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.returnAuthor(-1)]</FONT> \]</FONT><BR>"
			dat+="Channel messages listed below. If you deem them dangerous to the station, you can <A href='?src=[REF(src)];[HrefToken()];ac_toggle_d_notice=[REF(src.admincaster_feed_channel)]'>Bestow a D-Notice upon the channel</A>.<HR>"
			if(src.admincaster_feed_channel.censored)
				dat+="<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a Nanotrasen D-Notice.<BR>"
				dat+="No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>"
			else
				if( !length(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					for(var/datum/newscaster/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						dat+="-[MESSAGE.returnBody(-1)] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.returnAuthor(-1)]</FONT>\]</FONT><BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[11]'>Back</A>"
		if(14)
			dat+="<B>Wanted Issue Handler:</B>"
			var/wanted_already = 0
			var/end_param = 1
			if(GLOB.news_network.wanted_issue.active)
				wanted_already = 1
				end_param = 2
			if(wanted_already)
				dat+="<FONT SIZE=2><BR><I>A wanted issue is already in Feed Circulation. You can edit or cancel it below.</FONT></I>"
			dat+="<HR>"
			dat+="<A href='?src=[REF(src)];[HrefToken()];ac_set_wanted_name=1'>Criminal Name</A>: [src.admincaster_wanted_message.criminal] <BR>"
			dat+="<A href='?src=[REF(src)];[HrefToken()];ac_set_wanted_desc=1'>Description</A>: [src.admincaster_wanted_message.body] <BR>"
			if(wanted_already)
				dat+="<B>Wanted Issue created by:</B><FONT COLOR='green'>[GLOB.news_network.wanted_issue.scannedUser]</FONT><BR>"
			else
				dat+="<B>Wanted Issue will be created under prosecutor:</B><FONT COLOR='green'>[src.admin_signature]</FONT><BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_submit_wanted=[end_param]'>[(wanted_already) ? ("Edit Issue") : ("Submit")]</A>"
			if(wanted_already)
				dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_cancel_wanted=1'>Take down Issue</A>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Cancel</A>"
		if(15)
			dat+="<FONT COLOR='green'>Wanted issue for [src.admincaster_wanted_message.criminal] is now in Network Circulation.</FONT><BR><BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Return</A><BR>"
		if(16)
			dat+="<B><FONT COLOR='maroon'>ERROR: Wanted Issue rejected by Network.</B></FONT><HR><BR>"
			if(src.admincaster_wanted_message.criminal =="" || src.admincaster_wanted_message.criminal == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid name for person wanted.</FONT><BR>"
			if(src.admincaster_wanted_message.body == "" || src.admincaster_wanted_message.body == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid description.</FONT><BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Return</A><BR>"
		if(17)
			dat+="<B>Wanted Issue successfully deleted from Circulation</B><BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Return</A><BR>"
		if(18)
			dat+="<B><FONT COLOR ='maroon'>-- STATIONWIDE WANTED ISSUE --</B></FONT><BR><FONT SIZE=2>\[Submitted by: <FONT COLOR='green'>[GLOB.news_network.wanted_issue.scannedUser]</FONT>\]</FONT><HR>"
			dat+="<B>Criminal</B>: [GLOB.news_network.wanted_issue.criminal]<BR>"
			dat+="<B>Description</B>: [GLOB.news_network.wanted_issue.body]<BR>"
			dat+="<B>Photo:</B>: "
			if(GLOB.news_network.wanted_issue.img)
				usr << browse_rsc(GLOB.news_network.wanted_issue.img, "tmp_photow.png")
				dat+="<BR><img src='tmp_photow.png' width = '180'>"
			else
				dat+="None"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Back</A><BR>"
		if(19)
			dat+="<FONT COLOR='green'>Wanted issue for [src.admincaster_wanted_message.criminal] successfully edited.</FONT><BR><BR>"
			dat+="<BR><A href='?src=[REF(src)];[HrefToken()];ac_setScreen=[0]'>Return</A><BR>"
		else
			dat+="I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

	usr << browse(dat, "window=admincaster_main;size=400x600")
	onclose(usr, "admincaster_main")


/datum/admins/proc/Game()
	if(!check_rights(0))
		return

	var/dat = "<center><B>Game Panel</B></center><hr>"
	if(SSticker.current_state <= GAME_STATE_PREGAME)
		dat += "<A href='?src=[REF(src)];[HrefToken()];f_dynamic_ruleset_manage=1'>(Manage Dynamic Rulesets)</A><br>"
		dat += "<A href='?src=[REF(src)];[HrefToken()];f_dynamic_roundstart=1'>(Force Roundstart Rulesets)</A><br>"
		if (GLOB.dynamic_forced_roundstart_ruleset.len > 0)
			for(var/datum/dynamic_ruleset/roundstart/rule in GLOB.dynamic_forced_roundstart_ruleset)
				dat += {"<A href='?src=[REF(src)];[HrefToken()];f_dynamic_roundstart_remove=[text_ref(rule)]'>-> [rule.name] <-</A><br>"}
			dat += "<A href='?src=[REF(src)];[HrefToken()];f_dynamic_roundstart_clear=1'>(Clear Rulesets)</A><br>"
		dat += "<A href='?src=[REF(src)];[HrefToken()];f_dynamic_options=1'>(Dynamic mode options)</A><br>"
	dat += "<hr/>"
	if(SSticker.IsRoundInProgress())
		dat += "<a href='?src=[REF(src)];[HrefToken()];gamemode_panel=1'>(Game Mode Panel)</a><BR>"
		dat += "<A href='?src=[REF(src)];[HrefToken()];f_dynamic_ruleset_manage=1'>(Manage Dynamic Rulesets)</A><br>"
	dat += {"
		<BR>
		<A href='?src=[REF(src)];[HrefToken()];create_object=1'>Create Object</A><br>
		<A href='?src=[REF(src)];[HrefToken()];quick_create_object=1'>Quick Create Object</A><br>
		<A href='?src=[REF(src)];[HrefToken()];create_turf=1'>Create Turf</A><br>
		<A href='?src=[REF(src)];[HrefToken()];create_mob=1'>Create Mob</A><br>
		"}

	if(marked_datum && istype(marked_datum, /atom))
		dat += "<A href='?src=[REF(src)];[HrefToken()];dupe_marked_datum=1'>Duplicate Marked Datum</A><br>"

	usr << browse(dat, "window=admin2;size=240x280")
	return

////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

ADMIN_VERB(spawn_atom, R_SPAWN, "Spawn", "Spawn an atom.", ADMIN_CATEGORY_DEBUG, object as text)
	if(!object)
		return
	var/list/preparsed = splittext(object,":")
	var/path = preparsed[1]
	var/amount = 1
	if(preparsed.len > 1)
		amount = clamp(text2num(preparsed[2]),1,ADMIN_SPAWN_CAP)

	var/chosen = pick_closest_path(path)
	if(!chosen)
		return
	var/turf/T = get_turf(user.mob)

	if(ispath(chosen, /turf))
		T.ChangeTurf(chosen)
	else
		for(var/i in 1 to amount)
			var/atom/A = new chosen(T)
			A.flags_1 |= ADMIN_SPAWNED_1

	log_admin("[key_name(user)] spawned [amount] x [chosen] at [AREACOORD(user.mob)]")
	BLACKBOX_LOG_ADMIN_VERB("Spawn Atom")

ADMIN_VERB(spawn_atom_pod, R_SPAWN, "PodSpawn", "Spawn an atom via supply drop.", ADMIN_CATEGORY_DEBUG, object as text)
	var/chosen = pick_closest_path(object)
	if(!chosen)
		return
	var/turf/target_turf = get_turf(user.mob)

	if(ispath(chosen, /turf))
		target_turf.ChangeTurf(chosen)
	else
		var/obj/structure/closet/supplypod/pod = podspawn(list(
			"target" = target_turf,
			"path" = /obj/structure/closet/supplypod/centcompod,
		))
		//we need to set the admin spawn flag for the spawned items so we do it outside of the podspawn proc
		var/atom/A = new chosen(pod)
		A.flags_1 |= ADMIN_SPAWNED_1

	log_admin("[key_name(user)] pod-spawned [chosen] at [AREACOORD(user.mob)]")
	BLACKBOX_LOG_ADMIN_VERB("Podspawn Atom")

ADMIN_VERB(spawn_cargo, R_SPAWN, "Spawn Cargo", "Spawn a cargo crate.", ADMIN_CATEGORY_DEBUG, object as text)
	var/chosen = pick_closest_path(object, make_types_fancy(subtypesof(/datum/supply_pack)))
	if(!chosen)
		return
	var/datum/supply_pack/S = new chosen
	S.admin_spawned = TRUE
	S.generate(get_turf(user.mob))

	log_admin("[key_name(user)] spawned cargo pack [chosen] at [AREACOORD(user.mob)]")
	BLACKBOX_LOG_ADMIN_VERB("Spawn Cargo")

/datum/admins/proc/dynamic_mode_options(mob/user)
	var/dat = {"
		<center><B><h2>Dynamic Mode Options</h2></B></center><hr>
		<br/>
		<h3>Common options</h3>
		<i>All these options can be changed midround.</i> <br/>
		<br/>
		<b>Force extended:</b> - Option is <a href='?src=[REF(src)];[HrefToken()];f_dynamic_force_extended=1'> <b>[GLOB.dynamic_forced_extended ? "ON" : "OFF"]</a></b>.
		<br/>This will force the round to be extended. No rulesets will be drafted. <br/>
		<br/>
		<b>No stacking:</b> - Option is <a href='?src=[REF(src)];[HrefToken()];f_dynamic_no_stacking=1'> <b>[GLOB.dynamic_no_stacking ? "ON" : "OFF"]</b></a>.
		<br/>Unless the threat goes above [GLOB.dynamic_stacking_limit], only one "round-ender" ruleset will be drafted. <br/>
		<br/>
		<b>Forced threat level:</b> Current value : <a href='?src=[REF(src)];[HrefToken()];f_dynamic_forced_threat=1'><b>[GLOB.dynamic_forced_threat_level]</b></a>.
		<br/>The value threat is set to if it is higher than -1.<br/>
		<br/>
		<br/>
		<b>Stacking threeshold:</b> Current value : <a href='?src=[REF(src)];[HrefToken()];f_dynamic_stacking_limit=1'><b>[GLOB.dynamic_stacking_limit]</b></a>.
		<br/>The threshold at which "round-ender" rulesets will stack. A value higher than 100 ensure this never happens. <br/>
		"}

	user << browse(dat, "window=dyn_mode_options;size=900x650")

/datum/admins/proc/dynamic_ruleset_manager(mob/user)
	var/dat = "<center><B><h2>Dynamic Ruleset Management</h2></B></center><hr>\
		Change these options to forcibly enable or disable dynamic rulesets.<br/>\
		Disabled rulesets will never run, even if they would otherwise be valid.<br/>\
		Enabled rulesets will run even if the qualifying minimum of threat or player count is not present, this does not guarantee that they will necessarily be chosen (for example their weight may be set to 0 in config).<br/>\
		\[<A href='?src=[REF(src)];[HrefToken()];f_dynamic_ruleset_force_all_on=1'>force enable all</A> / \
		<A href='?src=[REF(src)];[HrefToken()];f_dynamic_ruleset_force_all_off=1'>force disable all</A> / \
		<A href='?src=[REF(src)];[HrefToken()];f_dynamic_ruleset_force_all_reset=1'>reset all</A>\]"

	if (SSticker.current_state <= GAME_STATE_PREGAME) // Don't bother displaying after the round has started
		var/static/list/rulesets_by_context = list()
		if (!length(rulesets_by_context))
			for (var/datum/dynamic_ruleset/rule as anything in subtypesof(/datum/dynamic_ruleset))
				if (initial(rule.name) == "")
					continue
				LAZYADD(rulesets_by_context[initial(rule.ruletype)], rule)

		dat += dynamic_ruleset_category_pre_start_display("Roundstart", rulesets_by_context[ROUNDSTART_RULESET])
		dat += dynamic_ruleset_category_pre_start_display("Latejoin", rulesets_by_context[LATEJOIN_RULESET])
		dat += dynamic_ruleset_category_pre_start_display("Midround", rulesets_by_context[MIDROUND_RULESET])
		user << browse(dat, "window=dyn_mode_options;size=900x650")
		return

	var/pop_count = length(GLOB.alive_player_list)
	var/threat_level = SSdynamic.threat_level
	dat += dynamic_ruleset_category_during_round_display("Latejoin", SSdynamic.latejoin_rules, pop_count, threat_level)
	dat += dynamic_ruleset_category_during_round_display("Midround", SSdynamic.midround_rules, pop_count, threat_level)
	user << browse(dat, "window=dyn_mode_options;size=900x650")

/datum/admins/proc/dynamic_ruleset_category_pre_start_display(title, list/rules)
	var/dat = "<B><h3>[title]</h3></B><table class='ml-2'>"
	for (var/datum/dynamic_ruleset/rule as anything in rules)
		var/forced = GLOB.dynamic_forced_rulesets[rule] || RULESET_NOT_FORCED
		var/color = COLOR_BLACK
		switch (forced)
			if (RULESET_FORCE_ENABLED)
				color = COLOR_GREEN
			if (RULESET_FORCE_DISABLED)
				color = COLOR_RED
		dat += "<tr><td><b>[initial(rule.name)]</b></td><td>\[<font color=[color]>[forced]</font>\]</td><td>\[\
			<A href='?src=[REF(src)];[HrefToken()];f_dynamic_ruleset_force_on=[text_ref(rule)]'>force enabled</A> /\
			<A href='?src=[REF(src)];[HrefToken()];f_dynamic_ruleset_force_off=[text_ref(rule)]'>force disabled</A> /\
			<A href='?src=[REF(src)];[HrefToken()];f_dynamic_ruleset_force_reset=[text_ref(rule)]'>reset</A>\]</td></tr>"
	dat += "</table>"
	return dat

/datum/admins/proc/dynamic_ruleset_category_during_round_display(title, list/rules, pop_count, threat_level)
	var/dat = "<B><h3>[title]</h3></B><table class='ml-2'>"
	for (var/datum/dynamic_ruleset/rule as anything in rules)
		var/active = rule.acceptable(population = pop_count, threat_level = threat_level) && rule.weight > 0
		var/forced = GLOB.dynamic_forced_rulesets[rule.type] || RULESET_NOT_FORCED
		var/color = (active) ? COLOR_GREEN : COLOR_RED
		var/explanation = ""
		if (!active)
			if (rule.weight <= 0)
				explanation = " - Weight is zero"
			else if (forced == RULESET_FORCE_DISABLED)
				explanation = " - Forcibly disabled"
			else if (forced == RULESET_FORCE_ENABLED)
				explanation = " - Failed spawn conditions"
			else if (!rule.is_valid_population(pop_count))
				explanation = " - Invalid player count"
			else if (!rule.is_valid_threat(pop_count, threat_level))
				explanation = " - Insufficient threat"
			else
				explanation = " - Failed spawn conditions"
		else if (forced == RULESET_FORCE_ENABLED)
			explanation = " - Forcibly enabled"
		active = active ? "Active" : "Inactive"

		dat += "<tr><td><b>[rule.name]</b></td>\
			<td>\[Weight : [rule.weight]\]\
			<td>\[<font color=[color]>[active][explanation]</font>\]</td><td>\[\
			<A href='?src=[REF(src)];[HrefToken()];f_dynamic_ruleset_force_on=[text_ref(rule.type)]'>force enabled</A> /\
			<A href='?src=[REF(src)];[HrefToken()];f_dynamic_ruleset_force_off=[text_ref(rule.type)]'>force disabled</A> /\
			<A href='?src=[REF(src)];[HrefToken()];f_dynamic_ruleset_force_reset=[text_ref(rule.type)]'>reset</A>\]</td>\
			<td>\[<A href='?src=[REF(src)];[HrefToken()];f_inspect_ruleset=[text_ref(rule)]'>VV</A>\]</td></tr>"
	dat += "</table>"
	return dat


/datum/admins/proc/force_all_rulesets(mob/user, force_value)
	if (force_value == RULESET_NOT_FORCED)
		GLOB.dynamic_forced_rulesets = list()
	else
		for (var/datum/dynamic_ruleset/rule as anything in subtypesof(/datum/dynamic_ruleset))
			GLOB.dynamic_forced_rulesets[rule] = force_value
	var/logged_message = "[key_name(user)] set all dynamic rulesets to [force_value]."
	log_admin(logged_message)
	message_admins(logged_message)
	dynamic_ruleset_manager(user)

/datum/admins/proc/set_dynamic_ruleset_forced(mob/user, datum/dynamic_ruleset/type, force_value)
	if (isnull(type))
		return
	GLOB.dynamic_forced_rulesets[type] = force_value
	dynamic_ruleset_manager(user)
	var/logged_message = "[key_name(user)] set '[initial(type.name)] ([initial(type.ruletype)])' to [GLOB.dynamic_forced_rulesets[type]]."
	log_admin(logged_message)
	message_admins(logged_message)

ADMIN_VERB(create_or_modify_area, R_DEBUG, "Create Or Modify Area", "Create of modify an area. wow.", ADMIN_CATEGORY_DEBUG)
	create_area(user.mob)

//Kicks all the clients currently in the lobby. The second parameter (kick_only_afk) determins if an is_afk() check is ran, or if all clients are kicked
//defaults to kicking everyone (afk + non afk clients in the lobby)
//returns a list of ckeys of the kicked clients
/proc/kick_clients_in_lobby(message, kick_only_afk = 0)
	var/list/kicked_client_names = list()
	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			if(kick_only_afk && !C.is_afk()) //Ignore clients who are not afk
				continue
			if(message)
				to_chat(C, message, confidential = TRUE)
			kicked_client_names.Add("[C.key]")
			qdel(C)
	return kicked_client_names

//returns TRUE to let the dragdrop code know we are trapping this event
//returns FALSE if we don't plan to trap the event
/datum/admins/proc/cmd_ghost_drag(mob/dead/observer/frommob, mob/tomob)

	//this is the exact two check rights checks required to edit a ckey with vv.
	if (!check_rights(R_VAREDIT,0) || !check_rights(R_SPAWN|R_DEBUG,0))
		return FALSE

	if (!frommob.ckey)
		return FALSE

	var/question = ""
	if (tomob.ckey)
		question = "This mob already has a user ([tomob.key]) in control of it! "
	question += "Are you sure you want to place [frommob.name]([frommob.key]) in control of [tomob.name]?"

	var/ask = tgui_alert(usr, question, "Place ghost in control of mob?", list("Yes", "No"))
	if (ask != "Yes")
		return TRUE

	if (!frommob || !tomob) //make sure the mobs don't go away while we waited for a response
		return TRUE

	// Disassociates observer mind from the body mind
	if(tomob.client)
		tomob.ghostize(FALSE)
	else
		for(var/mob/dead/observer/ghost in GLOB.dead_mob_list)
			if(tomob.mind == ghost.mind)
				ghost.mind = null

	message_admins(span_adminnotice("[key_name_admin(usr)] has put [frommob.key] in control of [tomob.name]."))
	log_admin("[key_name(usr)] stuffed [frommob.key] into [tomob.name].")
	BLACKBOX_LOG_ADMIN_VERB("Ghost Drag Control")

	tomob.key = frommob.key
	tomob.client?.init_verbs()
	qdel(frommob)

	return TRUE

/// Sends a message to adminchat when anyone with a holder logs in or logs out.
/// Is dependent on admin preferences and configuration settings, which means that this proc can fire without sending a message.
/client/proc/adminGreet(logout = FALSE)
	if(!SSticker.HasRoundStarted())
		return

	if(logout && CONFIG_GET(flag/announce_admin_logout))
		message_admins("Admin logout: [key_name(src)]")
		return

	if(!logout && CONFIG_GET(flag/announce_admin_login) && (prefs.toggles & ANNOUNCE_LOGIN))
		message_admins("Admin login: [key_name(src)]")
		return

