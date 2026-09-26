-- ArtisansCodex Recipes module
-- In-game recipe browser (search, filters, reagents, learned/missing)

local addonName, private = ...
private.Recipes = private.Recipes or {}
local Recipes = private.Recipes

local addon = private.addon

local FILTERS = { "All", "Learned", "Missing" }

function Recipes:Initialize()
    private:Print("Recipes module loaded")
end

local function GetRecipeList(profName)
    local data = private.RecipeData and private.RecipeData[profName]
    if type(data) ~= "table" then return {} end
    return data
end

local function IsRecipeLearned(entry)
    if not entry then return false end
    -- Prefer first-craft catalog / cached flags
    if entry.spellID and C_TradeSkillUI and C_TradeSkillUI.IsRecipeFirstCraft then
        -- If first-craft API returns non-nil for this spell, recipe data is loaded
        local ok, stillFirst = pcall(C_TradeSkillUI.IsRecipeFirstCraft, entry.spellID)
        if ok and stillFirst ~= nil then
            return true -- known to the client (whether or not first-craft remains)
        end
    end
    -- Fallback: item known / profession open with matching recipe name is hard without full IDs
    if entry.itemID and entry.itemID > 0 and C_TradeSkillUI and C_TradeSkillUI.GetAllRecipeIDs then
        local ids = C_TradeSkillUI.GetAllRecipeIDs()
        if type(ids) == "table" then
            for _, rid in ipairs(ids) do
                local info = C_TradeSkillUI.GetRecipeInfo and C_TradeSkillUI.GetRecipeInfo(rid)
                if info and info.name and entry.name and info.name == entry.name then
                    return true
                end
            end
        end
    end
    return false
end

local function RecipeMatchesFilter(entry, filter, learned)
    if filter == "All" then return true end
    if filter == "Learned" then return learned end
    if filter == "Missing" then return not learned end
    return true
end

local function RecipeMatchesSearch(entry, q)
    if not q or q == "" then return true end
    q = strlower(q)
    if entry.name and strlower(entry.name):find(q, 1, true) then return true end
    if entry.category and strlower(entry.category):find(q, 1, true) then return true end
    if entry.source and strlower(entry.source):find(q, 1, true) then return true end
    if type(entry.reagents) == "table" then
        for _, r in ipairs(entry.reagents) do
            if r.name and strlower(r.name):find(q, 1, true) then return true end
        end
    end
    return false
end

function addon:BuildRecipes()
    local page = self.mainFrame and self.mainFrame.tabContents and self.mainFrame.tabContents["recipes"]
    if not page then return end

    if type(self.ClearPage) == "function" then
        self:ClearPage(page)
    end

    self.selectedRecipesProf = self:BuildProfessionSidebar(page, {
        selected = self.selectedRecipesProf or self.selectedKnowledgeProf or "Tailoring",
        onSelect = function(name)
            self.selectedRecipesProf = name
            self:BuildRecipes()
        end,
    })

    local profName = self.selectedRecipesProf or "Tailoring"
    self.recipesFilter = self.recipesFilter or "All"
    self.recipesSearch = self.recipesSearch or ""

    local content = CreateFrame("Frame", nil, page)
    content:SetPoint("TOPLEFT", 215, -12)
    content:SetPoint("BOTTOMRIGHT", -12, 12)

    -- Header
    local header = CreateFrame("Frame", nil, content, "BackdropTemplate")
    header:SetPoint("TOPLEFT", 0, 0)
    header:SetPoint("TOPRIGHT", 0, 0)
    header:SetHeight(72)
    header:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 10,
        insets   = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    header:SetBackdropColor(0.08, 0.09, 0.14, 0.95)
    header:SetBackdropBorderColor(0.55, 0.45, 0.20, 0.85)

    local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 14, -10)
    title:SetText("|cffFFD700" .. profName .. " Recipes|r")

    local sub = header:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", 14, -30)
    sub:SetTextColor(0.65, 0.65, 0.65)
    sub:SetText("Data: wow-professions.com · wowhead.com  ·  Open profession to refresh Learned")

    -- Search box
    local search = CreateFrame("EditBox", nil, header, "InputBoxTemplate")
    search:SetSize(180, 20)
    search:SetPoint("TOPRIGHT", -14, -12)
    search:SetAutoFocus(false)
    search:SetText(self.recipesSearch or "")
    search:SetScript("OnEnterPressed", function(box)
        self.recipesSearch = box:GetText() or ""
        self:BuildRecipes()
    end)
    search:SetScript("OnEscapePressed", function(box)
        box:ClearFocus()
    end)
    local searchLabel = header:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    searchLabel:SetPoint("RIGHT", search, "LEFT", -6, 0)
    searchLabel:SetText("Search")
    searchLabel:SetTextColor(0.7, 0.7, 0.7)

    -- Filter chips
    local filterX = 14
    for _, fname in ipairs(FILTERS) do
        local btn = CreateFrame("Button", nil, header, "BackdropTemplate")
        btn:SetSize(70, 18)
        btn:SetPoint("BOTTOMLEFT", filterX, 8)
        filterX = filterX + 76
        btn:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        local active = self.recipesFilter == fname
        if active then
            btn:SetBackdropColor(0.35, 0.28, 0.12, 0.95)
            btn:SetBackdropBorderColor(0.85, 0.70, 0.25, 1)
        else
            btn:SetBackdropColor(0.12, 0.12, 0.16, 0.95)
            btn:SetBackdropBorderColor(0.35, 0.35, 0.40, 0.8)
        end
        local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fs:SetPoint("CENTER")
        fs:SetText(fname)
        fs:SetTextColor(active and 1 or 0.75, active and 0.9 or 0.75, active and 0.4 or 0.75)
        btn:SetScript("OnClick", function()
            self.recipesFilter = fname
            self:BuildRecipes()
        end)
    end

    -- List
    local scroll = CreateFrame("ScrollFrame", nil, content, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 0, -84)
    scroll:SetPoint("BOTTOMRIGHT", -28, 0)

    local list = CreateFrame("Frame", nil, scroll)
    list:SetSize(1, 1)
    scroll:SetScrollChild(list)

    local all = GetRecipeList(profName)
    local rows = {}
    for _, entry in ipairs(all) do
        local learned = IsRecipeLearned(entry)
        if RecipeMatchesFilter(entry, self.recipesFilter, learned)
            and RecipeMatchesSearch(entry, self.recipesSearch) then
            rows[#rows + 1] = { entry = entry, learned = learned }
        end
    end

    table.sort(rows, function(a, b)
        local ca = a.entry.category or ""
        local cb = b.entry.category or ""
        if ca ~= cb then return ca < cb end
        return (a.entry.name or "") < (b.entry.name or "")
    end)

    if #all == 0 then
        local empty = list:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        empty:SetPoint("TOPLEFT", 8, -8)
        empty:SetWidth(500)
        empty:SetJustifyH("LEFT")
        empty:SetTextColor(0.7, 0.7, 0.7)
        empty:SetText("No recipe data for " .. profName .. " yet.\nTailoring is the reference set; other professions are being filled from guide data.")
        list:SetSize(520, 60)
        return
    end

    if #rows == 0 then
        local empty = list:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        empty:SetPoint("TOPLEFT", 8, -8)
        empty:SetTextColor(0.7, 0.7, 0.7)
        empty:SetText("No recipes match this filter / search.")
        list:SetSize(400, 40)
        return
    end

    local y = 0
    local lastCat = nil
    local ROW_H = 44

    for _, row in ipairs(rows) do
        local entry = row.entry
        local learned = row.learned

        if entry.category and entry.category ~= lastCat then
            lastCat = entry.category
            local catFS = list:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            catFS:SetPoint("TOPLEFT", 4, y)
            catFS:SetText("|cffFFD700" .. lastCat .. "|r")
            y = y - 18
        end

        local cell = CreateFrame("Button", nil, list, "BackdropTemplate")
        cell:SetSize(math.max(480, (content:GetWidth() or 600) - 40), ROW_H)
        cell:SetPoint("TOPLEFT", 0, y)
        cell:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        cell:SetBackdropColor(0.09, 0.10, 0.14, 0.95)
        cell:SetBackdropBorderColor(0.25, 0.25, 0.28, 0.7)

        local icon = cell:CreateTexture(nil, "ARTWORK")
        icon:SetSize(32, 32)
        icon:SetPoint("LEFT", 8, 0)
        if entry.itemID and entry.itemID > 0 then
            icon:SetTexture(addon:GetItemIcon(entry.itemID))
        else
            icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        end

        local nameFS = cell:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameFS:SetPoint("TOPLEFT", 48, -6)
        nameFS:SetPoint("RIGHT", -120, 0)
        nameFS:SetJustifyH("LEFT")
        local nameColor = learned and "|cff33ee66" or "|cffffcc66"
        nameFS:SetText(nameColor .. (entry.name or "?") .. "|r")

        local meta = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        meta:SetPoint("TOPLEFT", 48, -22)
        meta:SetPoint("RIGHT", -8, 0)
        meta:SetJustifyH("LEFT")
        meta:SetTextColor(0.65, 0.65, 0.65)
        local bits = {}
        if entry.skill and entry.skill > 0 then bits[#bits + 1] = "Skill " .. entry.skill end
        if entry.source then bits[#bits + 1] = entry.source end
        if learned then bits[#bits + 1] = "|cff33ee66Learned|r" else bits[#bits + 1] = "|cff888888Unknown / open profession|r" end
        meta:SetText(table.concat(bits, "  ·  "))

        -- Reagent have/need summary on the right
        local reagFS = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        reagFS:SetPoint("TOPRIGHT", -8, -6)
        reagFS:SetJustifyH("RIGHT")
        if type(entry.reagents) == "table" and #entry.reagents > 0 then
            local parts = {}
            local allHave = true
            for _, r in ipairs(entry.reagents) do
                if r.itemID and r.itemID > 0 then
                    local have = addon:GetItemCount(r.itemID) or 0
                    local need = r.amount or 1
                    if have < need then allHave = false end
                    local col = have >= need and "33ee66" or "ff6644"
                    parts[#parts + 1] = string.format("|cff%s%d/%d|r", col, have, need)
                end
            end
            reagFS:SetText(table.concat(parts, " "))
        else
            reagFS:SetText("")
        end

        cell:EnableMouse(true)
        cell:SetScript("OnEnter", function(selfBtn)
            GameTooltip:SetOwner(selfBtn, "ANCHOR_RIGHT")
            if entry.itemID and entry.itemID > 0 then
                GameTooltip:SetItemByID(entry.itemID)
            else
                GameTooltip:AddLine(entry.name or "Recipe", 1, 0.85, 0.2)
            end
            if entry.note then
                GameTooltip:AddLine(entry.note, 0.75, 0.75, 0.75, true)
            end
            if type(entry.reagents) == "table" and #entry.reagents > 0 then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("Reagents (have / need)", 1, 0.85, 0.2)
                for _, r in ipairs(entry.reagents) do
                    local have = (r.itemID and r.itemID > 0) and (addon:GetItemCount(r.itemID) or 0) or 0
                    local need = r.amount or 1
                    local col = have >= need and {0.3, 1, 0.4} or {1, 0.45, 0.35}
                    GameTooltip:AddDoubleLine(
                        r.name or "?",
                        string.format("%d / %d", have, need),
                        0.85, 0.85, 0.85, col[1], col[2], col[3]
                    )
                end
            end
            if entry.source then
                GameTooltip:AddLine("Source: " .. entry.source, 0.6, 0.6, 0.6)
            end
            GameTooltip:Show()
        end)
        cell:SetScript("OnLeave", function() GameTooltip:Hide() end)

        y = y - (ROW_H + 4)
    end

    list:SetSize(520, math.abs(y) + 8)
    sub:SetText(string.format(
        "%d shown / %d in catalog  ·  wow-professions.com · wowhead.com",
        #rows, #all
    ))
end

if type(addon.BuildRecipes) == "function" then
    private.Recipes.BuildRecipes = addon.BuildRecipes
end