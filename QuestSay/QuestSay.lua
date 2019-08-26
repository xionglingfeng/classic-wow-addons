--[[ 

	QuestSay
	author: carahuevo

	Prints out a quest objectives state in the selected output channel.

	"/qs <where> <Quest Title>" (where s,p,r,g for /say, /party, /guild, /raid).
	"/qs <Quest Title>"  (where auto-selected).
	"/qs <where>"  (quest auto-selected).
	"/qs"  (where and quest auto-selected).

HISTORY

version 2.0.1
- TOC updated

version 2.0
- WoW 2.0 secure hook.
- esEs localization added.

version 0.11
- Fixed output channel selecion.

version 0.1
- Initial release.

]]

QS_title = "QuestSay";
QS_version = "2.0.1";
QS_author = "carahuevo";

local WOW_QuestLogTitleButton_OnClick;

-- onload event handle
function QS_OnLoad()
	--register slash commands
	SLASH_QS1 = "/qs";
	SlashCmdList["QS"] = function(msg)
		QS_Command(msg);
	end

	--hooks QuestLogTitleButton click event to overwrite it
	hooksecurefunc("QuestLogTitleButton_OnClick" , QS_QuestLogTitleButton_OnClick)

	--prepare QS menu
	---UIDropDownMenu_Initialize(this, QS_ListDropDown_Initialize, "MENU");

	QS_Print("Version "..QS_version.." by "..QS_author.." loaded. Type \"/qs help\" for help.");
end

-- print function
function QS_Print (msg)
	DEFAULT_CHAT_FRAME:AddMessage(COLOR_RED..QS_title.."> "..COLOR_END..msg);
end

-- slash function handle
function QS_Command(msg)
	--cmd will contain the channel (s,p,r,g) and param the quest title
	local cmd, param = QS_ParamParser(msg);
	local channel;
	local quest;

	if ( cmd == "" ) then
		channel = nil;
	elseif (cmd=="help" and param==nil) then
		--help is default option
		QS_Print(QS_HELPLINE1);
		QS_Print(QS_HELPLINE2);
		QS_Print(QS_HELPLINE3);
		QS_Print(QS_HELPLINE4);
		return;
	elseif(cmd~="s" and cmd~="p" and cmd~="g" and cmd~="r") then
		channel = nil;
	else
		channel = cmd;
	end

	if( not channel ) then
		--no output, auto-choose one...
		if ( param ) then
			param = cmd.." "..param;
		end
		if (GetNumGroupMembers()>0) then
			channel = "p";
		elseif( UnitInRaid("player") ) then
			channel = "r";
		else
			channel = "s";
		end
	end

	if (param == nil) then
		if ( QuestLogFrame.selectedButtonID ) then
			quest = GetQuestLogTitle(QuestLogFrame.selectedButtonID);
		else
			QS_Print(COLOR_RED..QS_ERRNOQUEST..COLOR_END);
			return;
		end
	else
		quest = param;
	end
	QS_PrintObjectives(channel, quest);
end

-- Parse data after /qs command
function QS_ParamParser(msg)
 	if msg then
 		local a,b,c=strfind(msg, "(%S+)"); --contiguous string of non-space characters
 		if a then
 			return c, strsub(msg, b+2);
 		else	
 			return "";
 		end
 	end
end;

-- Returns quest index based on title
function QS_GetQuestIndexByTitle(title)
	local numEntries = GetNumQuestLogEntries();
	local questLogTitleText;
	for i=1, numEntries do
		questLogTitleText = GetQuestLogTitle(i);
		if ( questLogTitleText == title ) then
			return i;
		end
	end
	return nil;
end

-- Prints out a quest objectives 
function QS_PrintObjectives(output, questTitle)
	-- Checks level added in quest title by other addons i.e [45] ...
	local p = strfind(questTitle, "%]");
	if ( p ) then
		questTitle = strsub(questTitle, p+1);
	end

	local questIdx = QS_GetQuestIndexByTitle(questTitle);
	if ( not questIdx ) then
		QS_Print(COLOR_RED..string.format(QS_ERRQUESTNOTFOUND,questTitle)..COLOR_END);
		return;
	else
		local numObjectives = GetNumQuestLeaderBoards(questIdx);
		if (numObjectives == 0) then
			QS_Print(COLOR_RED..QS_ERRQUESTNOOBJ..COLOR_END);
		else
			QS_PrintOut(output, string.format(QS_PRINTTITLE,questTitle));
			for i=1, numObjectives do
				local text, type, finished = GetQuestLogLeaderBoard(i, questIdx);
				if (finished) then
					text = QS_PRINTDONEPRE..text..QS_PRINTDONESUF;
				else
					text = QS_PRINTNOTDONEPRE..text..QS_PRINTNOTDONESUF;
				end
				QS_PrintOut(output, " - "..text);
			end
		end
	end
end

function QS_PrintOut(outsystem, msg)
	msg = string.sub(msg, 1, 254);
	if ( outsystem == "p" and GetNumPartyMembers()>0 ) then
		SendChatMessage(msg, "PARTY");
	elseif ( outsystem == "r" and UnitInRaid("player") ) then
		SendChatMessage(msg, "RAID");
	elseif ( outsystem == "g" and IsInGuild() ) then
		SendChatMessage(msg, "GUILD");
	else
		SendChatMessage(msg, "SAY");
	end
end

--hooked QuestLog button event
function QS_QuestLogTitleButton_OnClick(button)
	--CTRL+Click=/qs
	if ( button=="LeftButton" ) then
		if ( IsControlKeyDown() ) then
			QS_Command(nil);
		end
	elseif ( button=="RightButton" ) then
		---ToggleDropDownMenu(1, nil, QuestSayFrame, "QuestLogTitle"..QuestLogFrame.selectedButtonID, 0, 0);
	end
end

function QS_ListDropDown_Initialize()
	--title
	--Objectives>
	--Description>
	--Text>
	  --party
	  --say
	  --raid
	  --guild
	if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
		if ( UIDROPDOWNMENU_MENU_VALUE == QS_LB_OBJECTIVES ) then
		
		end
		info = {};
		info.text = QS_LB_PARTY;
		info.value = QS_LB_PARTY;
		info.func = QS_DropDownAction;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		info = {};
		info.text = QS_LB_SAY;
		info.value = QS_LB_SAY;
		info.func = QS_DropDownAction;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		info = {};
		info.text = QS_LB_RAID;
		info.value = QS_LB_RAID;
		info.func = QS_DropDownAction;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		info = {};
		info.text = QS_LB_GUILD;
		info.value = QS_LB_GUILD;
		info.func = QS_DropDownAction;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		return;
	end

	info = {};
	info.text = QS_title.." "..QS_version;
	info.value = QS_title;
	info.isTitle = 1;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = QS_LB_OBJECTIVES;
	info.value = QS_LB_OBJECTIVES;
	info.hasArrow = 1;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = QS_LB_DESCRIPTION;
	info.value = QS_LB_DESCRIPTION;
	info.hasArrow = 1;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = QS_LB_TEXT;
	info.value = QS_LB_TEXT;
	info.hasArrow = 1;
	UIDropDownMenu_AddButton(info);
end

function QS_DropDownAction()
end