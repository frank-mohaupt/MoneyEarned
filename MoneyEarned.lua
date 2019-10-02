local _, ns = ...;

ns.strName = "|cff628ea5MoneyEarned|r";

ns.blnDebug = false;
ns.tblFrame = CreateFrame("Frame");
ns.intMyMoney = 0;
ns.blnPrinted = false;

function ns.debug(strDebugMessage)
	local strDebugPrefix = ns.strName .. " DEBUG: ";
	if ns.blnDebug then
		print(strDebugPrefix .. strDebugMessage);
	end
end

function ns:SlashHandler(msg, editBox)
	if string.find(msg, "-debug") then
		ns.blnDebug = not ns.blnDebug;
		print("Debugging " .. (ns.blnDebug and "ON" or "OFF"));
	end
end

function ns.frameOnEventScript(self, strEvent)
	ns.debug("frameOnEventScript()");
	ns.debug("strEvent: " .. strEvent);
	ns.intMoneyEarned = 0;
	if string.find(strEvent, "_SHOW") then
		ns.blnPrinted = false;
		ns.intMyMoney = GetMoney();
	elseif string.find(strEvent, "_CLOSED") and ns.blnPrinted == false then
		ns.intMoneyEarned = GetMoney() - ns.intMyMoney;
		ns.strSign = ns.intMoneyEarned < 0 and "-" or "+";
		if ns.intMoneyEarned ~= 0 then
			ns.printToChatFrame(ns.strSign .. GetCoinTextureString(math.abs(ns.intMoneyEarned)), "Money");
		end
		ns.blnPrinted = true;
	end
	ns.debug("Money on " .. strEvent .. ": " .. GetCoinTextureString(GetMoney()));
end

function ns.registerEvents()
	ns.debug("registerEvents()");
	for _, strEventPrefix in pairs({"AUCTION_HOUSE", "MAIL", "MERCHANT", "TRADE", "TRAINER"}) do
		for _, strEventSuffix in pairs({"_SHOW", "_CLOSED"}) do
			local strEventName = strEventPrefix .. strEventSuffix;
			ns.tblFrame:RegisterEvent(strEventName);
			ns.debug(strEventName);
		end
	end
end

function ns.printToChatFrame(strMessage, strName)
	ns.debug("printToChatFrame()");
	ns.debug("strMessage: " .. strMessage);
	ns.debug("strName: " .. strName);
	
	local intChatTab = 1;
	local strChatFrameName = "";
	
	for i = 1, NUM_CHAT_WINDOWS do
		strChatFrameName = GetChatWindowInfo(i);
		
		ns.debug("ChatFrameName: " .. strChatFrameName);
		
		if strChatFrameName == strName then
			ns.debug("Set intChatTab to :" .. i);
			intChatTab = i;
			break;
		end
	end
	
	ns.debug("Print to ChatFrame" .. intChatTab);
	_G["ChatFrame".. intChatTab]:AddMessage(strMessage);
end

function ns.init()
	ns.printToChatFrame(ns.strName .. " loaded!", "Money");
	ns.tblFrame:SetScript("OnEvent", ns.frameOnEventScript);
	ns.registerEvents();
	SLASH_MONEYEARNED1 = "/me"
	SlashCmdList["MONEYEARNED"] = function(msg, editBox)
		ns:SlashHandler(msg, editBox);
	end
end

ns.init();
