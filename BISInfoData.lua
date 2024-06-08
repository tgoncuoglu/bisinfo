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
