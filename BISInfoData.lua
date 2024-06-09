slots = {"Head", "Neck", "Shoulder", "Back", "Chest",
			   "Wrist", "Waist", "Legs", "Feet", "Hands", "Finger0", "Finger1",
			   "Trinket0", "Trinket1", "MainHand", "SecondaryHand"}

BiSData = {}


function getBISItemForSpec(className, specName, slotName)
	className = string.lower(className)
	specName = string.lower(specName)
	return BiSData[className][specName][slotName]
end

function BISGetItemInfo(id)
	itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,
	itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
	expacID, setID, isCraftingReagent = GetItemInfo(id)	
	result = {
		name = itemName,
		link = itemLink,
		quality = itemQuality,
		level = itemLevel,
		minlevel = itemMinLevel,
		itemtype = itemType,
		subtype = itemSubType,
		stackcount = itemStackCount,
		equiploc = itemEquipLoc,
		texture = itemTexture,
		price = sellPrice,
		classid = classID,
		subclassid = subclassID,
		bindtype = bindType,
		expansion = expacID,
		setid = setID,
		isCraftingReagent = isCraftingReagent
	}
	return result
end

function getItemIdFromLink(itemLink)
	local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4,
    Suffix, Unique, LinkLvl, Name = string.find(itemLink,
    "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
	return Id
end

function displayBiS(slotName, bisitem)
	local item = Item:CreateFromItemID(bisitem.id)

	item:ContinueOnItemLoad(function()
		-- local name = item:GetItemName() 
		-- local icon = item:GetItemIcon()
		local link = item:GetItemLink()
		local currentUpgradeLevel, maxUpgradeLevel = GetItemUpgradeLevel(link)

		print(slotName .. ": ", link, currentUpgradeLevel, maxUpgradeLevel, "Source:", bisitem.dropsfrom)		
	end)
end




