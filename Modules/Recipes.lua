-- ArtisansCodex Recipes module
-- In-game recipe browser (search, filters, reagents, learned/missing)

local addonName, private = ...
private.Recipes = private.Recipes or {}
local Recipes = private.Recipes

local addon = private.addon

local FILTERS = { "All", "Learned", "Missing" }

local function GetRecipeList(profName)
    local data = private.RecipeData and private.RecipeData[profName]
    if type(data) ~= "table" then return {} end
    return data
end

-- Category tips live in each profession's recipe data file:
--   private.RecipeCategoryTips[profName] = { ["Armor"] = "…", … }
local function GetCategoryTip(profName, category)
    if not profName or not category then return nil end
    local byProf = private.RecipeCategoryTips and private.RecipeCategoryTips[profName]
    if type(byProf) ~= "table" then return nil end
    local tip = byProf[category]
    if type(tip) == "string" and tip ~= "" then return tip end
    return nil
end

-- ============================================================
-- Source actions: Spec → Specializations tab, Vendor/Trainer → map pin
-- ============================================================

local function PinCoords(mapID, x, y, label)
    if not mapID or not x or not y then
        private:Print("No coordinates available" .. (label and (" for " .. label) or "") .. ".")
        return
    end
    C_Map.SetUserWaypoint({
        uiMapID = mapID,
        position = CreateVector2D(x / 100, y / 100),
    })
    if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    end
    if label then
        private:Print("Pinned |cffFFD700" .. label .. "|r on the map.")
    end
end

-- Parse free-form source strings used in recipe data.
-- Returns: sourceType ("spec"|"vendor"|"trainer"|"drop"|"quest"|"other"), detail
local function ParseSource(source)
    if type(source) ~= "string" or source == "" then
        return "other", nil
    end
    local spec = source:match("^[Ss]pec:%s*(.+)$")
    if spec then return "spec", strtrim(spec) end
    local vendor = source:match("^[Vv]endor:%s*(.+)$")
    if vendor then
        -- "Deynna (150 Moxie)" → "Deynna"
        local name = vendor:match("^([^(]+)")
        return "vendor", strtrim(name or vendor)
    end
    if source:match("^[Tt]rainer") then
        return "trainer", source:match("^[Tt]rainer:%s*(.+)$") or source
    end
    local drop = source:match("^[Dd]rop:%s*(.+)$")
    if drop then return "drop", strtrim(drop) end
    local quest = source:match("^[Qq]uest:%s*(.+)$")
    if quest then return "quest", strtrim(quest) end
    return "other", source
end

-- Resolve pin target for a recipe entry.
-- Priority: entry.mapID/x/y → leveling trainer coords (for Trainer sources).
local function GetPinTarget(entry, profName, sourceType)
    if entry.mapID and entry.x and entry.y then
        local label = entry.pinLabel
            or (entry.source and entry.source:match("^[Vv]endor:%s*([^(]+)") and strtrim(entry.source:match("^[Vv]endor:%s*([^(]+)")))
            or entry.name
            or "Location"
        return entry.mapID, entry.x, entry.y, strtrim(label)
    end
    if sourceType == "trainer" and profName then
        local pdata = private.Data and private.Data[profName]
        local trainer = pdata and pdata.trainer
        if trainer and trainer.mapID and trainer.x and trainer.y then
            return trainer.mapID, trainer.x, trainer.y, trainer.name or (profName .. " Trainer")
        end
    end
    return nil
end

local function OpenSpecializations(profName)
    if not addon or not addon.SelectTab then return end
    addon.selectedSpecProf = profName
    addon:SelectTab("specializations")
end

-- ============================================================
-- Learned tracking (persisted to ArtisansCodexDB)
-- Scans automatically whenever the profession window opens / updates.
-- Status stays available after the window is closed and across reloads.
-- ============================================================

-- Session cache (filled by ScanOpenProfession)
local learnedCacheBySpell = {}
local learnedCacheByItem = {}
local learnedCacheByName = {}
local learnedCacheReady = false
local learnedCacheProfName = nil

local function GetPlayerGUID()
    return UnitGUID and UnitGUID("player") or "unknown"
end

-- SavedVariables: db.learnedRecipes[guid][profName] = {
--   bySpell = { [spellID] = true/false },
--   byItem  = { [itemID]  = true/false },
--   byName  = { [lowerName] = true/false },
--   scannedAt = unix time,
-- }
local function GetPersistedProf(profName)
    if not addon or not addon.db or not profName then return nil end
    local db = addon.db
    db.learnedRecipes = db.learnedRecipes or {}
    local guid = GetPlayerGUID()
    db.learnedRecipes[guid] = db.learnedRecipes[guid] or {}
    local slot = db.learnedRecipes[guid][profName]
    if type(slot) ~= "table" then
        slot = { bySpell = {}, byItem = {}, byName = {}, scannedAt = 0 }
        db.learnedRecipes[guid][profName] = slot
    end
    slot.bySpell = slot.bySpell or {}
    slot.byItem = slot.byItem or {}
    slot.byName = slot.byName or {}
    return slot
end

local function NormalizeProfName(name)
    if type(name) ~= "string" or name == "" then return nil end
    -- "Midnight Tailoring" / "Kul Tiran Tailoring" → "Tailoring"
    local bare = name:match("Midnight%s+(.+)$")
        or name:match("Khaz Algar%s+(.+)$")
        or name:match("Dragon Isles%s+(.+)$")
        or name:match("^%S+%s+(.+)$")
        or name
    return bare
end

local function GetOpenProfessionName()
    if not C_TradeSkillUI then return nil end
    if C_TradeSkillUI.GetBaseProfessionInfo then
        local ok, info = pcall(C_TradeSkillUI.GetBaseProfessionInfo)
        if ok and type(info) == "table" then
            local name = info.parentProfessionName or info.professionName
            return NormalizeProfName(name)
        end
    end
    return nil
end

-- Scan the currently open profession and persist results
local function ScanOpenProfession()
    wipe(learnedCacheBySpell)
    wipe(learnedCacheByItem)
    wipe(learnedCacheByName)
    learnedCacheReady = false
    learnedCacheProfName = nil

    if not (C_TradeSkillUI and C_TradeSkillUI.GetAllRecipeIDs and C_TradeSkillUI.GetRecipeInfo) then
        return false
    end

    local prevLearned, prevUnlearned
    if C_TradeSkillUI.GetShowLearned then
        prevLearned = C_TradeSkillUI.GetShowLearned()
        prevUnlearned = C_TradeSkillUI.GetShowUnlearned and C_TradeSkillUI.GetShowUnlearned()
    end
    if C_TradeSkillUI.SetShowLearned then
        pcall(C_TradeSkillUI.SetShowLearned, true)
    end
    if C_TradeSkillUI.SetShowUnlearned then
        pcall(C_TradeSkillUI.SetShowUnlearned, true)
    end

    local ids = C_TradeSkillUI.GetAllRecipeIDs()
    local restore = function()
        if prevLearned ~= nil and C_TradeSkillUI.SetShowLearned then
            pcall(C_TradeSkillUI.SetShowLearned, prevLearned)
        end
        if prevUnlearned ~= nil and C_TradeSkillUI.SetShowUnlearned then
            pcall(C_TradeSkillUI.SetShowUnlearned, prevUnlearned)
        end
    end

    if type(ids) ~= "table" or #ids == 0 then
        restore()
        return false
    end

    local profName = GetOpenProfessionName()
    local persist = profName and GetPersistedProf(profName) or nil
    if persist then
        wipe(persist.bySpell)
        wipe(persist.byItem)
        wipe(persist.byName)
    end

    local count = 0
    for _, rid in ipairs(ids) do
        local info = C_TradeSkillUI.GetRecipeInfo(rid)
        if info and info.name then
            local isLearned = info.learned == true
            learnedCacheBySpell[rid] = isLearned
            learnedCacheByName[strlower(info.name)] = isLearned
            if persist then
                persist.bySpell[rid] = isLearned
                persist.byName[strlower(info.name)] = isLearned
            end

            local schematic = C_TradeSkillUI.GetRecipeSchematic and C_TradeSkillUI.GetRecipeSchematic(rid, false)
            local outID = schematic and schematic.outputItemID
            if outID and outID > 0 then
                learnedCacheByItem[outID] = isLearned
                if persist then
                    persist.byItem[outID] = isLearned
                end
            end
            count = count + 1
        end
    end

    restore()

    if persist then
        persist.scannedAt = (GetServerTime and GetServerTime()) or time()
    end

    learnedCacheProfName = profName
    learnedCacheReady = count > 0
    return learnedCacheReady
end

-- true / false / nil (never scanned for this profession)
local function IsRecipeLearned(entry, viewingProf)
    if not entry then return nil end

    -- 1) Live API (works while that profession is open)
    if entry.spellID and C_TradeSkillUI and C_TradeSkillUI.GetRecipeInfo then
        local ok, info = pcall(C_TradeSkillUI.GetRecipeInfo, entry.spellID)
        if ok and info and info.learned ~= nil then
            return info.learned and true or false
        end
    end

    -- 2) Session cache from last scan of matching profession
    if learnedCacheReady and learnedCacheProfName and viewingProf
        and strlower(learnedCacheProfName) == strlower(viewingProf) then
        if entry.spellID and learnedCacheBySpell[entry.spellID] ~= nil then
            return learnedCacheBySpell[entry.spellID]
        end
        if entry.itemID and entry.itemID > 0 and learnedCacheByItem[entry.itemID] ~= nil then
            return learnedCacheByItem[entry.itemID]
        end
        if entry.name and learnedCacheByName[strlower(entry.name)] ~= nil then
            return learnedCacheByName[strlower(entry.name)]
        end
        if entry.itemID and entry.itemID > 0 then
            local liveName = C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(entry.itemID)
            if liveName and learnedCacheByName[strlower(liveName)] ~= nil then
                return learnedCacheByName[strlower(liveName)]
            end
        end
        -- Profession was scanned; recipe not in list → missing
        return false
    end

    -- 3) Persisted SavedVariables from a previous scan of this profession
    if viewingProf then
        local persist = GetPersistedProf(viewingProf)
        if persist and persist.scannedAt and persist.scannedAt > 0 then
            if entry.spellID and persist.bySpell[entry.spellID] ~= nil then
                return persist.bySpell[entry.spellID]
            end
            if entry.itemID and entry.itemID > 0 and persist.byItem[entry.itemID] ~= nil then
                return persist.byItem[entry.itemID]
            end
            if entry.name and persist.byName[strlower(entry.name)] ~= nil then
                return persist.byName[strlower(entry.name)]
            end
            if entry.itemID and entry.itemID > 0 then
                local liveName = C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(entry.itemID)
                if liveName and persist.byName[strlower(liveName)] ~= nil then
                    return persist.byName[strlower(liveName)]
                end
            end
            -- Scanned before; not found → missing
            return false
        end
    end

    -- 4) Never scanned this profession on this character
    return nil
end

local function RecipeMatchesFilter(entry, filter, learned)
    if filter == "All" then return true end
    if filter == "Learned" then return learned == true end
    if filter == "Missing" then return learned == false end
    return true
end

local function HasPersistedScan(profName)
    local persist = GetPersistedProf(profName)
    return persist and persist.scannedAt and persist.scannedAt > 0
end

-- Auto-scan when profession UI opens / updates / a recipe is learned
local scanPending = false
local function ScheduleProfessionScan()
    if scanPending then return end
    scanPending = true
    C_Timer.After(0.4, function()
        scanPending = false
        local ok = ScanOpenProfession()
        if ok and addon and addon.mainFrame and addon.mainFrame:IsShown() then
            -- Refresh recipes tab if visible so status updates live
            local tab = addon.mainFrame.tabContents and addon.mainFrame.tabContents["recipes"]
            if tab and tab:IsShown() and type(addon.BuildRecipes) == "function" then
                addon:BuildRecipes()
            end
        end
    end)
end

function Recipes:Initialize()
    private:Print("Recipes module loaded")

    local ef = CreateFrame("Frame")
    local events = {
        "TRADE_SKILL_SHOW",
        "TRADE_SKILL_LIST_UPDATE",
        "TRADE_SKILL_DETAILS_UPDATE",
        "NEW_RECIPE_LEARNED",
    }
    for _, e in ipairs(events) do
        pcall(function() ef:RegisterEvent(e) end)
    end
    ef:SetScript("OnEvent", function(_, event, ...)
        if event == "NEW_RECIPE_LEARNED" then
            -- Mark the specific recipe learned immediately in session + DB if we know the prof
            local spellID = ...
            if type(spellID) == "number" and spellID > 0 then
                learnedCacheBySpell[spellID] = true
                local prof = learnedCacheProfName or GetOpenProfessionName()
                if prof then
                    local persist = GetPersistedProf(prof)
                    if persist then
                        persist.bySpell[spellID] = true
                    end
                end
            end
        end
        ScheduleProfessionScan()
    end)
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

    -- If the matching profession is currently open, rescan so status is fresh
    local openProf = GetOpenProfessionName()
    if openProf and self.selectedRecipesProf
        and strlower(openProf) == strlower(self.selectedRecipesProf) then
        ScanOpenProfession()
    end

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
    sub:SetText("Data: wow-professions.com · wowhead.com")

    -- Search box (debounced live filter, ~300ms after typing stops)
    local search = CreateFrame("EditBox", nil, header, "InputBoxTemplate")
    search:SetSize(180, 20)
    search:SetPoint("TOPRIGHT", -14, -12)
    search:SetAutoFocus(false)
    search:SetText(self.recipesSearch or "")
    local searchTimer
    local function ApplySearch(box)
        local text = box:GetText() or ""
        if text == (self.recipesSearch or "") then return end
        self.recipesSearch = text
        self:BuildRecipes()
        -- Restore focus after rebuild (frame is recreated)
        C_Timer.After(0.05, function()
            if self.recipesSearchBox and self.recipesSearchBox:IsShown() then
                self.recipesSearchBox:SetFocus()
                self.recipesSearchBox:SetCursorPosition(#(self.recipesSearch or ""))
            end
        end)
    end
    search:SetScript("OnTextChanged", function(box, userInput)
        if not userInput then return end
        if searchTimer then
            searchTimer:Cancel()
            searchTimer = nil
        end
        searchTimer = C_Timer.NewTimer(0.3, function()
            searchTimer = nil
            ApplySearch(box)
        end)
    end)
    search:SetScript("OnEnterPressed", function(box)
        if searchTimer then
            searchTimer:Cancel()
            searchTimer = nil
        end
        ApplySearch(box)
        box:ClearFocus()
    end)
    search:SetScript("OnEscapePressed", function(box)
        box:SetText("")
        if searchTimer then
            searchTimer:Cancel()
            searchTimer = nil
        end
        ApplySearch(box)
        box:ClearFocus()
    end)
    self.recipesSearchBox = search
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
        local learned = IsRecipeLearned(entry, profName)
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
            y = y - 16
            local tip = GetCategoryTip(profName, lastCat)
            if tip then
                local tipFS = list:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                tipFS:SetPoint("TOPLEFT", 6, y)
                tipFS:SetPoint("RIGHT", list, "RIGHT", -8, 0)
                tipFS:SetJustifyH("LEFT")
                tipFS:SetTextColor(0.55, 0.55, 0.58)
                tipFS:SetText(tip)
                y = y - 14
            end
            y = y - 4
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
        elseif entry.spellID and entry.spellID > 0 then
            -- Enchant/spell recipes: use the spell's own icon (varies per enchant)
            local tex
            if C_Spell and C_Spell.GetSpellTexture then
                tex = C_Spell.GetSpellTexture(entry.spellID)
            elseif GetSpellTexture then
                tex = GetSpellTexture(entry.spellID)
            end
            if tex then
                icon:SetTexture(tex)
            else
                icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            end
        else
            icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        end

        local nameFS = cell:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameFS:SetPoint("TOPLEFT", 48, -6)
        nameFS:SetPoint("RIGHT", -130, 0)
        nameFS:SetJustifyH("LEFT")

        -- Display name: ALWAYS use data-file name when present.
        -- itemID is icon + quality only (never overwrites the label).
        local displayName = (entry.name and entry.name ~= "" and entry.name) or nil
        if not displayName then
            if entry.itemID and entry.itemID > 0 then
                local liveName = C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(entry.itemID)
                if (not liveName or liveName == "") and GetItemInfo then
                    liveName = GetItemInfo(entry.itemID)
                end
                displayName = (liveName and liveName ~= "" and liveName) or "?"
            elseif entry.spellID and entry.spellID > 0 then
                local liveName
                if C_Spell and C_Spell.GetSpellName then
                    liveName = C_Spell.GetSpellName(entry.spellID)
                elseif GetSpellInfo then
                    liveName = GetSpellInfo(entry.spellID)
                end
                displayName = (liveName and liveName ~= "" and liveName) or "?"
            else
                displayName = "?"
            end
        end
        nameFS:SetText(displayName)
        -- Lock the label so async item-load callbacks cannot replace it.
        nameFS._acLockedName = displayName

        -- Quality color via SetTextColor (no |c escapes). Live API only — no quality in data.
        -- Fallback tint: learned green / missing gold / unscanned gray.
        local function ApplyNameColor(quality)
            if type(quality) == "number" then
                local r, g, b
                if GetItemQualityColor then
                    r, g, b = GetItemQualityColor(quality)
                elseif ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality] then
                    local c = ITEM_QUALITY_COLORS[quality]
                    r, g, b = c.r, c.g, c.b
                end
                if r then
                    nameFS:SetTextColor(r, g, b)
                    return
                end
            end
            if learned == true then
                nameFS:SetTextColor(0.20, 0.93, 0.40)
            elseif learned == false then
                nameFS:SetTextColor(1.00, 0.80, 0.40)
            else
                nameFS:SetTextColor(0.67, 0.67, 0.67)
            end
        end

        local quality
        if entry.itemID and entry.itemID > 0 then
            if C_Item and C_Item.GetItemQualityByID then
                quality = C_Item.GetItemQualityByID(entry.itemID)
            end
            if quality == nil and GetItemInfo then
                quality = select(3, GetItemInfo(entry.itemID))
            end
            -- Kick the item into cache; recolor when the client finishes loading it
            if C_Item and C_Item.RequestLoadItemDataByID then
                C_Item.RequestLoadItemDataByID(entry.itemID)
            end
            if Item and Item.CreateFromItemID then
                local itemObj = Item:CreateFromItemID(entry.itemID)
                if itemObj and itemObj.ContinueOnItemLoad then
                    itemObj:ContinueOnItemLoad(function()
                        if not nameFS or not nameFS.SetTextColor then return end
                        -- Keep locked data-file name (Inscribe/Transcribe etc.)
                        if nameFS._acLockedName then
                            nameFS:SetText(nameFS._acLockedName)
                        end
                        local q = itemObj.GetItemQuality and itemObj:GetItemQuality() or nil
                        if q == nil and C_Item and C_Item.GetItemQualityByID then
                            q = C_Item.GetItemQualityByID(entry.itemID)
                        end
                        ApplyNameColor(q)
                    end)
                end
            end
        end
        ApplyNameColor(quality)

        local meta = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        meta:SetPoint("TOPLEFT", 48, -22)
        meta:SetPoint("RIGHT", -130, 0)
        meta:SetJustifyH("LEFT")
        meta:SetTextColor(0.65, 0.65, 0.65)
        local bits = {}
        if entry.skill and entry.skill > 0 then
            local skillBit = "Skill " .. entry.skill
            if entry.trainCost and entry.trainCost > 0 then
                local costStr
                if GetCoinTextureString then
                    costStr = GetCoinTextureString(entry.trainCost)
                else
                    local g = math.floor(entry.trainCost / 10000)
                    local s = math.floor((entry.trainCost % 10000) / 100)
                    local c = entry.trainCost % 100
                    if g > 0 then
                        costStr = string.format("%dg %ds %dc", g, s, c)
                    elseif s > 0 then
                        costStr = string.format("%ds %dc", s, c)
                    else
                        costStr = string.format("%dc", c)
                    end
                end
                skillBit = skillBit .. "  ·  Train " .. costStr
            end
            bits[#bits + 1] = skillBit
        end
        if learned == true then
            bits[#bits + 1] = "|cff33ee66Learned|r"
        elseif learned == false then
            bits[#bits + 1] = "|cffff6644Missing|r"
        else
            bits[#bits + 1] = "|cff888888Not scanned yet|r"
        end
        meta:SetText(table.concat(bits, "  ·  "))

        -- Source + action buttons (Specs / Pin) on the right
        local sourceType, sourceDetail = ParseSource(entry.source)
        local pinMapID, pinX, pinY, pinLabel = GetPinTarget(entry, profName, sourceType)
        local canPin = pinMapID ~= nil
        local isSpec = sourceType == "spec"

        local actionX = -8
        if canPin then
            local pinBtn = CreateFrame("Button", nil, cell, "UIPanelButtonTemplate")
            pinBtn:SetSize(40, 18)
            pinBtn:SetPoint("TOPRIGHT", actionX, -4)
            pinBtn:SetText("Pin")
            pinBtn:SetScript("OnClick", function()
                PinCoords(pinMapID, pinX, pinY, pinLabel)
            end)
            pinBtn:SetScript("OnEnter", function(btn)
                GameTooltip:SetOwner(btn, "ANCHOR_LEFT")
                GameTooltip:AddLine("Pin on map", 1, 0.85, 0.2)
                if pinLabel then
                    GameTooltip:AddLine(pinLabel, 0.8, 0.8, 0.8)
                end
                GameTooltip:Show()
            end)
            pinBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
            actionX = actionX - 44
        end
        if isSpec then
            local specBtn = CreateFrame("Button", nil, cell, "UIPanelButtonTemplate")
            specBtn:SetSize(48, 18)
            specBtn:SetPoint("TOPRIGHT", actionX, -4)
            specBtn:SetText("Specs")
            specBtn:SetScript("OnClick", function()
                OpenSpecializations(profName)
            end)
            specBtn:SetScript("OnEnter", function(btn)
                GameTooltip:SetOwner(btn, "ANCHOR_LEFT")
                GameTooltip:AddLine("Open Specializations", 1, 0.85, 0.2)
                if sourceDetail then
                    GameTooltip:AddLine(sourceDetail, 0.8, 0.8, 0.8)
                end
                GameTooltip:Show()
            end)
            specBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
            actionX = actionX - 52
        end

        local srcFS = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        srcFS:SetPoint("TOPRIGHT", actionX - 4, -6)
        srcFS:SetJustifyH("RIGHT")
        srcFS:SetTextColor(0.75, 0.72, 0.55)
        if entry.source and entry.source ~= "" then
            srcFS:SetText(entry.source)
        else
            srcFS:SetText("")
        end
        -- Keep name/meta from overlapping action buttons
        nameFS:SetPoint("RIGHT", srcFS, "LEFT", -8, 0)
        meta:SetPoint("RIGHT", srcFS, "LEFT", -8, 0)

        cell:EnableMouse(true)
        cell:SetScript("OnEnter", function(selfBtn)
            GameTooltip:SetOwner(selfBtn, "ANCHOR_RIGHT")
            if entry.itemID and entry.itemID > 0 then
                GameTooltip:SetItemByID(entry.itemID)
            elseif entry.spellID and entry.spellID > 0 then
                GameTooltip:SetSpellByID(entry.spellID)
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
            if isSpec then
                GameTooltip:AddLine(" ", 1, 1, 1)
                GameTooltip:AddLine("Click Specs to open Specializations for " .. (profName or "?"), 0.5, 0.75, 1)
            end
            if canPin then
                GameTooltip:AddLine("Click Pin to mark " .. (pinLabel or "location") .. " on the map", 0.5, 0.75, 1)
            end
            GameTooltip:Show()
        end)
        cell:SetScript("OnLeave", function() GameTooltip:Hide() end)

        y = y - (ROW_H + 4)
    end

    list:SetSize(520, math.abs(y) + 8)

    local statusNote
    if HasPersistedScan(profName)
        or (learnedCacheReady and learnedCacheProfName
            and strlower(learnedCacheProfName) == strlower(profName)) then
        statusNote = "status saved for this character"
    else
        statusNote = "open " .. profName .. " once to scan learned recipes"
    end
    sub:SetText(string.format(
        "%d shown / %d in catalog  ·  %s",
        #rows, #all, statusNote
    ))
end

if type(addon.BuildRecipes) == "function" then
    private.Recipes.BuildRecipes = addon.BuildRecipes
end