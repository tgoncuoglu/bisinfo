

function getItemIdFromLink(itemLink)
	local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4,
    Suffix, Unique, LinkLvl, Name = string.find(itemLink,
    "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
	return Id
end

function GetSpecName()
	local currentSpec = GetSpecialization()
	local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"
	return currentSpecName
end

function displayBiS(slotName, bisitem)
	local item = Item:CreateFromItemID(bisitem.id)

	item:ContinueOnItemLoad(function()
		-- local name = item:GetItemName() 
		-- local icon = item:GetItemIcon()
		local link = item:GetItemLink()
		print(slotName .. ": ", link, "Source:", bisitem.dropsfrom)		
	end)
end

SLASH_BISINFO1 = "/bis"

SlashCmdList.BISINFO = function(msg, editBox)
	local myguid = UnitGUID("player") 
	local mylevel = UnitLevel("player")
	local myspec = string.lower(GetSpecName())
	local _, myclass, _, myRace, mysex, myname, _ = GetPlayerInfoByGUID(myguid)
	myclass = string.lower(myclass)
	print(myname, myRace, myspec, myclass)
	
	for i,slotName in ipairs(slots) do
	    local slotID = GetInventorySlotInfo(slotName .. "Slot")
	    local itemLink = GetInventoryItemLink("player", slotID)
		if itemLink then
			-- local equippeditem = Item:CreateFromItemLink(itemLink)
			local equipped = BISGetItemInfo(getItemIdFromLink(itemLink))
			if equipped then
				if equipped.name ~= "" then
					local bisItem = getBISItemForSpec(myclass, myspec, slotName)
					if bisItem then 
						if bisItem.id > 0 then
							bis = BISGetItemInfo(bisItem.id)
							if equipped.name ~= bis.name then
								displayBiS(slotName, bisItem)
							end
						end
					end
				end
			end
		end
	end
end

