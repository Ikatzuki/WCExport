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

    -- Pets
    local collectedPets = {}
    for petName, petID in pairs(WCExport_PetNameIds) do
        local id, customName = C_PetJournal.FindPetIDByName(petName)
        if id then
            table.insert(collectedPets, petID)
        end
    end
    local petString = "Pets:" .. table.concat(collectedPets, ",")

    -- Factions
    local collectedFactions = {}
    for factionName, factionID in pairs(WCExport_FactionNameIds) do -- Assuming your table is named WCExport_FactionNameIds
        for i = 1, GetNumFactions() do
            local name, _, standingID = GetFactionInfo(i)
            if name == factionName and standingID == 8 then
                table.insert(collectedFactions, factionID)
                break -- break early if the faction is found and meets the criteria
            end
        end
    end
    local factionString = "Factions:" .. table.concat(collectedFactions, ",")

    -- Titles
    local faction = UnitFactionGroup("player")
    local titleTables = {WCExport_NeutralTitleNameIDs}
    if faction == "Alliance" then
        table.insert(titleTables, WCExport_AllianceTitleNameIDs)
    elseif faction == "Horde" then
        table.insert(titleTables, WCExport_HordeTitleNameIDs)
    end

    local collectedTitles = {}
    for i = 1, 150 do
        if IsTitleKnown(i) == true then
            for _, titleTable in ipairs(titleTables) do
                for titleName, titleID in pairs(titleTable) do
                    local titleInfo = GetTitleName(i)
                    if titleInfo and titleInfo:find(titleName) then
                        table.insert(collectedTitles, titleID)
                        break
                    end
                end
            end
        end
    end
    local titleString = "Titles:" .. table.concat(collectedTitles, ",")

    -- Combine strings
    local collectionString = mountString .. ";" .. toyString .. ";" .. achievementString .. ";" .. petString .. ";" ..
                                 factionString .. ";" .. titleString

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
