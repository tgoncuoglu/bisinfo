

function GetSpecName()
	local currentSpec = GetSpecialization()
	local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"
	return currentSpecName
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

