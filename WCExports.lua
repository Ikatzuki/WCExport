-- Function to export mount info
local function ExportMountInfo()
    local mountIDs = C_MountJournal.GetMountIDs()
    local collectedMounts = {}
    for i, mountID in ipairs(mountIDs) do
        local name, spellID, icon, isActive, isUsable = C_MountJournal.GetMountInfoByID(mountID)
        if isActive or isUsable then
            table.insert(collectedMounts, spellID)
        end
    end
    local mountString = "Mounts:" .. table.concat(collectedMounts, ",")
    return mountString
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
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
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
    local mountInfo = ExportMountInfo()
    local frame = WCExport_GetMainFrame(mountInfo)
    frame:Show()
end
