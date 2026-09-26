-- ArtisansCodex Recipes module
-- Dedicated recipe browser tab

local addonName, private = ...
private.Recipes = private.Recipes or {}
local Recipes = private.Recipes

local addon = private.addon

function Recipes:Initialize()
    private:Print("Recipes module loaded")
end

function addon:BuildRecipes()
    local page = self.mainFrame and self.mainFrame.tabContents and self.mainFrame.tabContents["recipes"]
    if not page then return end

    if type(self.ClearPage) == "function" then
        self:ClearPage(page)
    end

    self.selectedRecipesProf = self:BuildProfessionSidebar(page, {
        selected = self.selectedRecipesProf or self.selectedKnowledgeProf or "Alchemy",
        onSelect = function(name)
            self.selectedRecipesProf = name
            self:BuildRecipes()
        end,
    })

    local profName = self.selectedRecipesProf or "Alchemy"
    -- Match Knowledge / Leveling: sidebar is 190px at x=12 → right column at 215
    local content = CreateFrame("Frame", nil, page)
    content:SetPoint("TOPLEFT", 215, -12)
    content:SetPoint("BOTTOMRIGHT", -12, 12)

    -- Header
    local header = CreateFrame("Frame", nil, content, "BackdropTemplate")
    header:SetPoint("TOPLEFT", 0, 0)
    header:SetPoint("TOPRIGHT", 0, 0)
    header:SetHeight(52)
    header:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 10,
        insets   = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    header:SetBackdropColor(0.08, 0.09, 0.14, 0.95)
    header:SetBackdropBorderColor(0.55, 0.45, 0.20, 0.85)

    local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", 14, 6)
    title:SetText("|cffFFD700" .. profName .. " Recipes|r")

    local status = header:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    status:SetPoint("LEFT", 14, -12)
    status:SetText("|cff888888Coming in a future update|r")

    -- Empty-state card
    local card = CreateFrame("Frame", nil, content, "BackdropTemplate")
    card:SetPoint("TOPLEFT", 0, -64)
    card:SetPoint("TOPRIGHT", 0, -64)
    card:SetHeight(220)
    card:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    card:SetBackdropColor(0.07, 0.08, 0.12, 0.95)
    card:SetBackdropBorderColor(0.40, 0.35, 0.20, 0.80)

    local cardTitle = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    cardTitle:SetPoint("TOPLEFT", 18, -16)
    cardTitle:SetText("|cffFFD700Recipe browser — not ready yet|r")

    local body = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT", 18, -42)
    body:SetPoint("RIGHT", -18, 0)
    body:SetJustifyH("LEFT")
    body:SetSpacing(3)
    body:SetText(
        "This tab will list profession recipes with icons, quality colors, tooltips,\n" ..
        "reagent have/need counts, and search filters.\n\n" ..
        "|cffaaaaaaPlanned for a later release:|r\n" ..
        "  • Search + filters (All / Learned / Missing)\n" ..
        "  • Quality-colored item names + icons + tooltips\n" ..
        "  • Reagent lists with have/need counts\n" ..
        "  • Cross-links from Leveling and Knowledge\n\n" ..
        "|cff888888Data will ship profession-by-profession, starting with Tailoring.|r"
    )
    body:SetTextColor(0.78, 0.78, 0.78)

    -- Footer hint
    local hint = content:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hint:SetPoint("BOTTOMLEFT", 4, 4)
    hint:SetText("Use Knowledge for treasures & weekly KP · Leveling for craft order")
end

if type(addon.BuildRecipes) == "function" then
    private.Recipes.BuildRecipes = addon.BuildRecipes
end