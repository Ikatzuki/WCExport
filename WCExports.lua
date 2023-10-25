-- Function to export mount and toy info
local function ExportCollectionInfo()
    -- Mounts
    local mountIDs = C_MountJournal.GetMountIDs()
    local collectedMounts = {}
    for i, mountID in ipairs(mountIDs) do
        local name, spellID, icon, isActive, isUsable = C_MountJournal.GetMountInfoByID(mountID)
        if isActive or isUsable then
            table.insert(collectedMounts, spellID)
        end
    end
    local mountString = "Mounts:" .. table.concat(collectedMounts, ",")

    -- Toys
    local collectedToys = {}
    for i = 1, 60 do
        local itemID = C_ToyBox.GetToyFromIndex(i)
        if PlayerHasToy(itemID) then
            table.insert(collectedToys, itemID)
        end
    end
    local toyString = "Toys:" .. table.concat(collectedToys, ",")

    -- Achievements
    local collectedAchievements = {}
    for _, achievementID in ipairs(WCExport_AchievementIDs) do
        local _, _, _, completed = GetAchievementInfo(achievementID)
        if completed then
            table.insert(collectedAchievements, achievementID)
        end
    end
    local achievementString = "Achievements:" .. table.concat(collectedAchievements, ",")

    -- Combine mount and toy strings
    local collectionString = mountString .. ";" .. toyString .. ";" .. achievementString

    return collectionString
end

-- Function to get the main frame
function WCExport_GetMainFrame(text)
    if not WCExportFrame then
        local f = CreateFrame("Frame", "WCExportFrame", UIParent, "DialogBoxFrame")
        f:SetPoint("CENTER")
        f:SetSize(500, 300)

        local sf = CreateFrame("ScrollFrame", "WCExportScrollFrame", f, "UIPanelScrollFrameTemplate")
        sf:SetPoint("LEFT", 16, 0)
        sf:SetPoint("RIGHT", -32, 0)
        sf:SetPoint("TOP", 0, -32)
        sf:SetPoint("BOTTOM", WCExportFrameButton, "TOP", 0, 0)

        local eb = CreateFrame("EditBox", "WCExportEditBox", WCExportScrollFrame)
        eb:SetSize(sf:GetSize())
        eb:SetMultiLine(true)
        eb:SetAutoFocus(true)
        eb:SetFontObject("ChatFontNormal")
        eb:SetScript("OnEscapePressed", function()
            f:Hide()
        end)
        sf:SetScrollChild(eb)

        WCExportFrame = f
    end
    WCExportEditBox:SetText(text)
    WCExportEditBox:HighlightText()
    return WCExportFrame
end

-- Register the /wcexport command
SLASH_WCEXPORT1 = "/wcexport"
SlashCmdList["WCEXPORT"] = function()
    local collectionInfo = ExportCollectionInfo()
    local frame = WCExport_GetMainFrame(collectionInfo)
    frame:Show()
end
