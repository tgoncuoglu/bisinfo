local S_UPGRADE_LEVEL   = "^" .. gsub(ITEM_UPGRADE_TOOLTIP_FORMAT, "%%d", "(%%d+)")

local scantip = CreateFrame("GameTooltip", "MyScanningTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

function GetItemUpgradeLevel(itemLink)
    scantip:SetHyperlink(itemLink)

    for i = 2, scantip:NumLines() do -- Line 1 is always the name so you can skip it.
        local text = _G["MyScanningTooltipTextLeft"..i]:GetText()
        if text and text ~= "" then
            local currentUpgradeLevel, maxUpgradeLevel = strmatch(text, S_UPGRADE_LEVEL)
            if currentUpgradeLevel then
                return currentUpgradeLevel, maxUpgradeLevel
            end
        end
    end
end
