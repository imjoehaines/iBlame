-- You can edit this bit vv
-- $RandomGroupMember will be replaced by the name of a random group member using normal caps
-- -- eg. Bob, Jim, Mike, Susan
-- $RandomGroupMemberUPPER will be replaced by the name of a random group member using all caps
-- -- eg. BOB, JIM, MIKE, SUSAN
-- $RandomGroupMemberLOWER will be replaced by the name of a random group member using no caps
-- -- eg. bob, jim, mike, susan

-- rndFriendlyMessages are messages used when 'friendly mode' is active
-- (for raids and such)
rndFriendlyMessages = {
	"Hey, $RandomGroupMember, you killed me!",
	"$RandomGroupMember made me die!",
	"$RandomGroupMember why did you do that!? You got me killed!!",
	"You aren't a very good friend, $RandomGroupMember, you got me killed!",
	"I hope you're happy, $RandomGroupMember, you killed me!",
	"I died because of $RandomGroupMember!",
	"Thanks, $RandomGroupMember, you did a really good job killing me.",
	"Wow, $RandomGroupMember, you totally got me killed!",
	"I died and it was $RandomGroupMember's fault!"
}

-- rndRandomMessages are used when 'friendly mode' is NOT active
-- (for trollin')
rndRandomMessages = {
	"OMFG $RandomGroupMemberUPPER U GOT ME KILLED!!!!!!!!1",
	"omg i blame $RandomGroupMemberLOWER",
	"NICE JOB $RandomGroupMemberUPPER",
	"$RandomGroupMemberUPPER WTF DUDE Y DID U DO THAT!?!??!?!",
	"wow nice one $RandomGroupMemberLOWER",
	"ffs $RandomGroupMemberLOWER",
	"fucks sake $RandomGroupMemberLOWER wtf r u doing!???",
	"omg nice job $RandomGroupMemberLOWER",
	"$RandomGroupMemberLOWER ffs dude come on...",
	"jeez $RandomGroupMemberLOWER way to go...",
	"oh wow $RandomGroupMemberLOWER nice one"
}

-- Don't edit this bit vv --
local chatType = ""
local numMembers = 0
local rndMember = 0
local roll = 0
local rndMember = ""
local iBlameLoadMessage = ""
iBlame_level = 60
iBlame_friendly_mode = true
iBlame_debug_mode = false

local frame = CreateFrame("FRAME")
frame:RegisterEvent("PLAYER_DEAD")
frame:RegisterEvent("ADDON_LOADED")

SLASH_IBLAME1, SLASH_IBLAME2 = '/ib', '/iblame';
function SlashCmdList.IBLAME(msg)
	msg = strlower(msg)
	local command, rest = msg:match("^(%S*)%s*(.-)$");
	if msg == "fm" or msg == "friend mode" then
		if iBlame_friendly_mode then
			iBlame_friendly_mode = false
			print("|cff69CCF0iBlame|r: Friend mode is now |cffff0000OFF|r")
		else
			iBlame_friendly_mode = true
			print("|cff69CCF0iBlame|r: Friend mode is now |cff00ff00ON|r")
		end
	elseif (command == 'level' or command == 'lvl') then
		rest = string.gsub(rest, "%a+", "")
		if strlen(rest) == 0 then
			print("|cff69CCF0iBlame|r: Error, the level threshold must be a number above 0 and less than or equal to 80.")
		else
			rest = tonumber(rest)
			if (rest > 0 and rest <= 80) then
				iBlame_level = rest
				print("|cff69CCF0iBlame|r: The level threshold is now |cff69CCF0".. iBlame_level .."|r")
			else
				print("|cff69CCF0iBlame|r: Error, invalid level \"|cff69CCF0" ..rest.. "|r\". The level threshold must be above 0 and less than or equal to 80.")
			end
		end
	elseif msg == "debug" then
		if iBlame_debug_mode then
			iBlame_debug_mode = false
			print("|cff69CCF0iBlame|r: Debug mode is now |cffff0000OFF|r")
		else
			iBlame_debug_mode = true
			print("|cff69CCF0iBlame|r: Debug mode is now |cff00ff00ON|r")
		end
	elseif msg == "" then
		if iBlame_friendly_mode then fm = "|cff00ff00ON|r" else fm = "|cffff0000OFF|r" end
		print("|cff69CCF0iBlame|r Help")
		print("Friend mode is currently " .. fm .. ". Level threshold is |cff69CCF0" .. iBlame_level .. "|r")
		print("\"|cff69CCF0/iblame friend mode|r\" (or \"|cff69CCF0/ib fm|r\") to toggle friend mode")
		print("\"|cff69CCF0/iblame level <number>\"|r (or \"|cff69CCF0/ib lvl <number>|r\") to set the level threshold")
	else
		print("|cff69CCF0iBlame|r: Error, unrecognised command \"|cff69CCF0" ..msg.. "|r\". Accepted commands:")
		print("\"|cff69CCF0/iblame friend mode\"|r (or \"|cff69CCF0/ib fm|r\") to toggle friend mode")
		print("\"|cff69CCF0/iblame level <number>\"|r (or \"|cff69CCF0/ib lvl <number>|r\") to set the level threshold")
	end
end

local function eventHandler(self, event, ...)
if event == "ADDON_LOADED" then
	if arg1 == "_iBlame" then
		iBlameLoadMessage = "|cff69CCF0iBlame|r loaded. "
		
		if iBlame_debug_mode then
			iBlameLoadMessage = iBlameLoadMessage .. "Debug mode is |cff00ff00ON|r. "
		end
		
		if iBlame_friendly_mode then
			iBlameLoadMessage = iBlameLoadMessage .. "Friend mode is |cff00ff00ON|r. "
		else
			iBlameLoadMessage = iBlameLoadMessage .. "Friend mode is |cffff0000OFF|r. "
		end
		
		iBlameLoadMessage = iBlameLoadMessage .. "Level threshold is: |cff69CCF0" .. iBlame_level .. "|r"
		
		print(iBlameLoadMessage)
	end
elseif event == "PLAYER_DEAD" then
	if UnitLevel("player") > iBlame_level then 
		print("|cff69CCF0iBlame|r: You died but you are over the level threshold of |cff69CCF0".. iBlame_level .."|r")
		return
	end

	if GetNumRaidMembers() > 0 then
		chatType = "RAID"
		numMembers = GetNumRaidMembers()
	elseif GetNumPartyMembers() > 0 then
		chatType = "PARTY"
		numMembers = GetNumPartyMembers()
	else
		print("Looks like you died!")
		return
	end
	
	repeat
		roll = math.random(1,numMembers)
		
		if chatType == "RAID" then
			rndMember = UnitName("raid"..roll)
		elseif chatType == "PARTY" then
			rndMember = UnitName("party"..roll)
		end
	until rndMember ~= UnitName("player")
	
	if iBlame_friendly_mode then
		roll = math.random(1,#rndFriendlyMessages)
		rndMessage = rndFriendlyMessages[roll]
	else
		roll = math.random(1,#rndRandomMessages)
		rndMessage = rndRandomMessages[roll]
	end
	
	rndMessage = string.gsub(rndMessage, "$RandomGroupMemberUPPER", strupper(rndMember))
	rndMessage = string.gsub(rndMessage, "$RandomGroupMemberLOWER", strlower(rndMember))
	rndMessage = string.gsub(rndMessage, "$RandomGroupMember", rndMember)
	if iBlame_debug_mode then print(rndMessage) else SendChatMessage(rndMessage,chatType) end
end
end
frame:SetScript("OnEvent", eventHandler)
