-- ArtisansCodex Specializations module
-- Specializations tab UI

local _, private = ...
local addon = private.addon

private.Specializations = private.Specializations or {}
local Specializations = private.Specializations

function Specializations:Initialize()
    private:Print("Specializations module loaded")
end

function addon:BuildSpecializations()
    local page = self.mainFrame.tabContents["specializations"]
    if not page then return end

    if type(self.BuildProfessionSidebar) ~= "function" then
        private:Print("|cffff4444ERROR:|r ProfessionSidebar not loaded. Ensure Modules/ProfessionSidebar.lua is present and listed in ArtisansCodex.toc before the tab modules.")
        return
    end

    for _, child in pairs({page:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
    for _, region in pairs({page:GetRegions()}) do
        if region.SetText then region:Hide() end
    end

    self.selectedSpecProf = self:BuildProfessionSidebar(page, {
        selected    = self.selectedSpecProf or "Alchemy",
        filter      = "specializations",
        showLearned = true,
        onSelect    = function(name)
            self.selectedSpecProf = name
            self:BuildSpecializations()
        end,
    })

    -- CENTER - Tree Placeholder
    local treeFrame = CreateFrame("Frame", nil, page, "BackdropTemplate")
    treeFrame:SetPoint("TOPLEFT", 215, -12)
    treeFrame:SetPoint("BOTTOMRIGHT", -280, 12)
    treeFrame:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    treeFrame:SetBackdropColor(0.07, 0.08, 0.13, 0.95)
    treeFrame:SetBackdropBorderColor(0.45, 0.38, 0.2, 0.9)

    local treeTitle = treeFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    treeTitle:SetPoint("TOP", 0, -20)
    treeTitle:SetText("|cffFFD700" .. self.selectedSpecProf .. " Specialization Tree|r")

    local treePlaceholder = treeFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    treePlaceholder:SetPoint("CENTER", 0, 20)
    treePlaceholder:SetText(
        "Interactive Specialization Tree\n\n" ..
        "Coming in a future update\n\n" ..
        "This area will show the full talent tree\n" ..
        "with recommended path highlighting,\n" ..
        "tooltips, and point spending helper."
    )
    treePlaceholder:SetJustifyH("CENTER")
    treePlaceholder:SetTextColor(0.7, 0.7, 0.7)

    -- RIGHT PANEL - Recommended Builds
    local rightPanel = CreateFrame("Frame", nil, page, "BackdropTemplate")
    rightPanel:SetPoint("TOPRIGHT", -12, -12)
    rightPanel:SetPoint("BOTTOMRIGHT", -12, 12)
    rightPanel:SetWidth(250)
    rightPanel:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    rightPanel:SetBackdropColor(0.09, 0.10, 0.15, 0.95)
    rightPanel:SetBackdropBorderColor(0.45, 0.38, 0.2, 0.9)

    local rightTitle = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rightTitle:SetPoint("TOP", 0, -14)
    rightTitle:SetText("|cffFFD700Recommended Builds|r")

    local builds = {
        { name = "Max Throughput", note = "Best for pure crafting volume" },
        { name = "Resourceful", note = "Multicraft + Resourcefulness focus" },
        { name = "Quality First", note = "Inspiration / quality path" },
    }

    for i, build in ipairs(builds) do
        local row = CreateFrame("Frame", nil, rightPanel, "BackdropTemplate")
        row:SetSize(220, 48)
        row:SetPoint("TOP", 0, -40 - (i - 1) * 56)
        row:SetBackdrop({
            bgFile   = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 10,
            insets   = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        row:SetBackdropColor(0.12, 0.13, 0.19, 0.9)
        row:SetBackdropBorderColor(0.35, 0.30, 0.18, 0.8)

        local n = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        n:SetPoint("TOPLEFT", 10, -8)
        n:SetText(build.name)

        local note = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        note:SetPoint("TOPLEFT", 10, -26)
        note:SetText(build.note)
        note:SetTextColor(0.7, 0.7, 0.7)
    end
end

if type(addon.BuildSpecializations) == "function" then
    private.Specializations.BuildSpecializations = addon.BuildSpecializations
    private:Print("Specializations module file loaded (BuildSpecializations ready)")
else
    private:Print("ERROR: Specializations failed to attach BuildSpecializations")
end