local f = CreateFrame("Frame")

function f:OnEvent(event, ...)
	self[event](self, event, ...)
end

function f:ADDON_LOADED(event, addOnName)
	print("BIS Info loaded. To check your gear use: /bis")
	-- print(event, addOnName) -- ADDON_LOADED  Blizzard_MajorFactions
end

function f:PLAYER_ENTERING_WORLD(event, isLogin, isReload)
	-- print(event, isLogin, isReload)      -- PLAYER_ENTERING_WORLD false true
end

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", f.OnEvent)

