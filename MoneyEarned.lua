local frame, myMoney, printed = CreateFrame("Frame"), 0, false;
local events = {"AUCTION_HOUSE", "MAIL", "MERCHANT", "TRADE", "TRAINER"};

frame:SetScript("OnEvent",
	function(self, event, ...)
		if string.find(event, "_SHOW") ~= nil then
			printed = false;
			myMoney = GetMoney();
		elseif string.find(event, "_CLOSED") ~= nil and printed ~= true then
			moneyEarned = GetMoney() - myMoney;
			sign = moneyEarned < 0 and "-" or "+";
			if moneyEarned ~= 0 then
				print(sign .. GetCoinTextureString(math.abs(moneyEarned)));
			end
			printed = true;
		end
	end
);

for _, event in pairs(events) do
	frame:RegisterEvent(event .. "_SHOW");
	frame:RegisterEvent(event .. "_CLOSED");
end
