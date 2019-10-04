local _, ns = ...;


ns.blnDebug = false;
ns.blnPrinted = false;
ns.intMyMoney = 0;
ns.strChatFrame = "";
ns.strName = "|cff628ea5MoneyEarned|r";
ns.tblFrame = CreateFrame("Frame");

--[[
-- Can be used to print out debugging information
-- Switch ON/OFF with "-debug"
]]
function ns.debug(strDebugMessage)
	local strDebugPrefix = ns.strName .. " DEBUG: ";
	if ns.blnDebug then
		print(strDebugPrefix .. strDebugMessage);
	end
end

--[[
-- Calls different functions on different events
]]
function ns.frameOnEventScript(self, strEvent)
	ns.debug("frameOnEventScript()");
	ns.debug("strEvent: " .. strEvent);

	if string.find(strEvent, "_SHOW") then
		ns.onShow();
	elseif string.find(strEvent, "_CLOSED") then
		ns.onClosed();
	end
end

--[[
-- Get the Chat Frame or default Chat Frame
]]
function ns.getChatFrame()
	ns.debug("getChatFrame()");
	return ns.strChatFrame or DEFAULT_CHAT_FRAME;
end

--[[
-- Get the Events or empty table
]]
function ns.getEvents()
	ns.debug("getEvents()");
	return ns.tblEvents or {};
end

--[[
-- on show
]]
function ns.onShow()
	ns.debug("onShow()");
	ns.blnPrinted = false;
	ns.intMyMoney = GetMoney();
end

--[[
-- on closed
]]
function ns.onClosed()
	ns.debug("onClosed()");
	ns.intMoneyEarned = GetMoney() - ns.intMyMoney;
	ns.strSign = ns.intMoneyEarned < 0 and "-" or "+";
	if ns.intMoneyEarned ~= 0 and ns.blnPrinted == false then
		ns.printToChatFrame(ns.strSign .. GetCoinTextureString(math.abs(ns.intMoneyEarned)), "Money");
		ns.blnPrinted = true;
	end
end

--[[
-- Send Message to Chat Frame
]]
function ns.printToChatFrame(strMessage)
	ns.debug("printToChatFrame()");
	ns.debug("strMessage: " .. strMessage);

	ns.debug("Print to " .. ns.getChatFrame());
	_G[ns.getChatFrame()]:AddMessage(strMessage);
end

--[[
-- Register the events
]]
function ns.registerEvents()
	ns.debug("registerEvents()");
	local tblEvents = ns.getEvents();
	for _, strEvent in pairs(tblEvents) do
			ns.tblFrame:RegisterEvent(strEvent);
			ns.debug(strEvent);
	end
end

--[[
-- Set the Chat Frame
]]
function ns.setChatFrame(strName)
	ns.debug("setChatFrame()");
	ns.debug("strName: " .. strName);
	local intChatTab = 1;
	local strChatFrameName = "";
	
	for intTab = 1, NUM_CHAT_WINDOWS do
		strChatFrameName = GetChatWindowInfo(intTab);
		
		ns.debug("ChatFrameName: " .. strChatFrameName);
		
		if strChatFrameName == strName then
			intChatTab = intTab;
			break;
		end
	end
	ns.strChatFrame = "ChatFrame" .. intChatTab;
	ns.debug("Set ChatFrame to " .. ns.strChatFrame);
end

--[[
-- Set the Events
]]
function ns.setEvents()
	ns.debug("setEvents()");
	ns.tblEvents = {};
	
	for _, strSubject in pairs({"AUCTION_HOUSE", "MAIL", "MERCHANT", "TRADE", "TRAINER"}) do
		for _, strAction in pairs({"_SHOW", "_CLOSED"}) do
			table.insert(ns.tblEvents, strSubject .. strAction);
		end
	end
end

--[[
-- Set Slash commands that can be used in-game to interact with the addon
]]
function ns.setSlashCommands()
	ns.debug("setSlashCommands()");
	SLASH_MONEYEARNED1 = "/me"
	SlashCmdList["MONEYEARNED"] = function(msg, editBox)
		ns:slashHandler(msg, editBox);
	end
end

--[[
-- Handles the slash commands
]]
function ns:slashHandler(msg, editBox)
	ns.debug("slashHandler()");
	if string.find(msg, "debug") then
		ns.blnDebug = not ns.blnDebug;
		print("Debugging " .. (ns.blnDebug and "ON" or "OFF"));
	end
end

--[[
-- Sets different initial values
]]
function ns.init()
	ns.debug("init()");
	ns.setChatFrame("Money");
	ns.setEvents();
	ns.setSlashCommands();
	ns.registerEvents();

	ns.tblFrame:SetScript("OnEvent", ns.frameOnEventScript);
	
	ns.printToChatFrame(ns.strName .. " loaded!");
end

ns.init();
