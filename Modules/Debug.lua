-- ArtisansCodex Debug module
-- Log console + live profession recipe audit (import / diff / export)

local addonName, private = ...
private.Debug = private.Debug or {}
local Debug = private.Debug

local addon = private.addon

local LOG_MAX = 400
local FILTERS = { "All", "Missing", "Mismatch", "Extra", "NoID", "NoSource", "OK" }

-- Ring buffer of { t = time, cat = string, msg = string }
Debug.log = Debug.log or {}
Debug.mirrorChat = true -- when private.debug is on, also print to chat
Debug.recipeFilter = "All"
Debug.selectedDiffIndex = nil

-- ============================================================
-- LOG
-- ============================================================

local function PushLog(cat, msg)
    local entry = {
        t = time(),
        cat = cat or "info",
        msg = tostring(msg or ""),
    }
    local log = Debug.log
    log[#log + 1] = entry
    while #log > LOG_MAX do
        table.remove(log, 1)
    end
    if Debug.frame and Debug.frame:IsShown() and Debug.RefreshLog then
        Debug:RefreshLog()
    end
end

--- Called from private:Print — stores message; optional chat mirror
function Debug:CapturePrint(...)
    local parts = {}
    for i = 1, select("#", ...) do
        parts[#parts + 1] = tostring(select(i, ...))
    end
    local msg = table.concat(parts, " ")
    local cat = "info"
    local lower = strlower(msg)
    if lower:find("error", 1, true) or lower:find("|cffff4444", 1, true) then
        cat = "error"
    elseif lower:find("progress", 1, true) or lower:find("snapshot", 1, true) then
        cat = "progress"
    elseif lower:find("recipe", 1, true) or lower:find("import", 1, true) or lower:find("diff", 1, true) then
        cat = "recipes"
    end
    PushLog(cat, msg)
end

function Debug:ClearLog()
    wipe(self.log)
    if self.RefreshLog then self:RefreshLog() end
end

-- ============================================================
-- LIVE PROFESSION SCAN
-- ============================================================

local function GetOpenProfessionName()
    if not C_TradeSkillUI then return nil end
    if C_TradeSkillUI.IsTradeSkillReady and not C_TradeSkillUI.IsTradeSkillReady() then
        return nil
    end
    if C_TradeSkillUI.GetBaseProfessionInfo then
        local ok, info = pcall(C_TradeSkillUI.GetBaseProfessionInfo)
        if ok and type(info) == "table" then
            local name = info.parentProfessionName or info.professionName
            if name and name ~= "" then return name end
        end
    end
    local child = C_TradeSkillUI.GetChildProfessionInfo and C_TradeSkillUI.GetChildProfessionInfo()
    if child and (child.parentProfessionName or child.professionName) then
        return child.parentProfessionName or child.professionName
    end
    return nil
end

--- Normalize API profession name toward RecipeData keys (e.g. "Midnight Tailoring" → "Tailoring")
local function NormalizeProfName(name)
    if not name then return nil end
    local stripped = name:match("Midnight%s+(.+)")
        or name:match("Khaz Algar%s+(.+)")
        or name:match("Dragon Isles%s+(.+)")
        or name:match("^%S+%s+(.+)$")
        or name
    stripped = strtrim(stripped)
    if private.RecipeData and private.RecipeData[stripped] then
        return stripped
    end
    if private.RecipeData and private.RecipeData[name] then
        return name
    end
    if private.RecipeData then
        for key in pairs(private.RecipeData) do
            if strlower(key) == strlower(stripped) or strlower(key) == strlower(name) then
                return key
            end
        end
    end
    return stripped
end

--- Resolve which expansion skill-line to audit.
--- Prefer Midnight variantID from ProgressMeta (matches our RecipeData).
--- Fallback: currently selected child profession in the profession UI.
local function GetTargetSkillLine(profName)
    local meta = private.ProgressMeta
        and private.ProgressMeta.professions
        and private.ProgressMeta.professions[profName]
    if meta and meta.variantID then
        return meta.variantID, "Midnight"
    end
    if C_TradeSkillUI and C_TradeSkillUI.GetChildProfessionInfo then
        local ok, child = pcall(C_TradeSkillUI.GetChildProfessionInfo)
        if ok and type(child) == "table" and child.professionID then
            local label = child.expansionName or child.professionName or ("skillLine " .. child.professionID)
            return child.professionID, label
        end
    end
    return nil, nil
end

local function RecipeBelongsToSkillLine(recipeID, skillLineID)
    if not skillLineID then return true end
    if C_TradeSkillUI.IsRecipeInSkillLine then
        local ok, belongs = pcall(C_TradeSkillUI.IsRecipeInSkillLine, recipeID, skillLineID)
        if ok then return belongs and true or false end
    end
    if C_TradeSkillUI.GetTradeSkillLineForRecipe then
        local ok, tradeSkillID = pcall(C_TradeSkillUI.GetTradeSkillLineForRecipe, recipeID)
        if ok and tradeSkillID then
            return tradeSkillID == skillLineID
        end
    end
    -- Last resort: no filter API available
    return true
end

-- Item name cache + async load (fixes reagent name = "?" in exports)
local itemNameCache = {}

local function RequestItem(itemID)
    if not itemID or itemID <= 0 then return end
    if C_Item and C_Item.RequestLoadItemDataByID then
        pcall(C_Item.RequestLoadItemDataByID, itemID)
    end
end

local function ResolveItemName(itemID)
    if not itemID or itemID <= 0 then return "?" end
    if itemNameCache[itemID] then return itemNameCache[itemID] end

    local name
    if C_Item and C_Item.GetItemNameByID then
        name = C_Item.GetItemNameByID(itemID)
    end
    if (not name or name == "") and GetItemInfo then
        name = GetItemInfo(itemID)
    end
    if name and name ~= "" then
        itemNameCache[itemID] = name
        return name
    end
    RequestItem(itemID)
    return "?"
end

--- Fill in any still-missing reagent/output names on a live list. Returns count fixed.
local function ResolveLiveItemNames(liveList)
    if type(liveList) ~= "table" then return 0 end
    local fixed = 0
    for _, rec in ipairs(liveList) do
        if rec.itemID and rec.itemID > 0 then
            RequestItem(rec.itemID)
        end
        for _, r in ipairs(rec.reagents or {}) do
            if r.itemID and r.itemID > 0 then
                local prev = r.name
                local n = ResolveItemName(r.itemID)
                if n ~= "?" and prev ~= n then
                    r.name = n
                    fixed = fixed + 1
                elseif n ~= "?" then
                    r.name = n
                else
                    RequestItem(r.itemID)
                end
            end
        end
    end
    return fixed
end

local function ExtractSkill(info, recipeID)
    -- Retail RecipeInfo fields vary by patch; try several without trusting difficulty enums
    if type(info) ~= "table" then return 0 end
    for _, key in ipairs({ "skillLineLevel", "requiredSkillLevel", "learnedLevel", "minSkillLevel" }) do
        local v = info[key]
        if type(v) == "number" and v > 0 and v <= 200 then
            return v
        end
    end
    -- Some builds put orange/yellow/green/gray thresholds on the recipe
    if C_TradeSkillUI and C_TradeSkillUI.GetRecipeDifficultyInfo then
        local ok, diff = pcall(C_TradeSkillUI.GetRecipeDifficultyInfo, recipeID)
        if ok and type(diff) == "table" then
            local v = diff.orange or diff.yellow or diff.skillLineLevel
            if type(v) == "number" and v > 0 then return v end
        end
    end
    return 0
end

local function CollectReagents(recipeID)
    local reagents = {}
    if not (C_TradeSkillUI and C_TradeSkillUI.GetRecipeSchematic) then
        return reagents
    end
    local schematic = C_TradeSkillUI.GetRecipeSchematic(recipeID, false)
    if not (schematic and schematic.reagentSlotSchematics) then
        return reagents
    end
    for _, slot in ipairs(schematic.reagentSlotSchematics) do
        -- Prefer first basic reagent; still record itemID even if name pending
        local chosen = slot.reagents and slot.reagents[1]
        if chosen and (chosen.itemID or 0) > 0 then
            local rid = chosen.itemID
            RequestItem(rid)
            reagents[#reagents + 1] = {
                name = ResolveItemName(rid),
                itemID = rid,
                amount = slot.quantityRequired or 1,
            }
        elseif slot.dataSlotType and slot.slotInfo and slot.slotInfo.mcrSlotID then
            -- modified crafting slot — skip for catalog
        end
    end
    return reagents
end

local function CollectOutputItemID(recipeID, info)
    local itemID = 0
    if C_TradeSkillUI.GetRecipeSchematic then
        local schematic = C_TradeSkillUI.GetRecipeSchematic(recipeID, false)
        if schematic and schematic.outputItemID and schematic.outputItemID > 0 then
            itemID = schematic.outputItemID
        end
    end
    if itemID == 0 and C_TradeSkillUI.GetRecipeItemLink then
        local link = C_TradeSkillUI.GetRecipeItemLink(recipeID)
        if link then
            local id = link:match("item:(%d+)")
            if id then itemID = tonumber(id) or 0 end
        end
    end
    if itemID == 0 and info then
        if info.qualityItemIDs and info.qualityItemIDs[1] then
            itemID = info.qualityItemIDs[1]
        elseif info.itemID and info.itemID > 0 then
            itemID = info.itemID
        end
    end
    if itemID > 0 then RequestItem(itemID) end
    return itemID
end

--- Returns liveList, skillLineID, skillLineLabel, totalUnfiltered
local function ScanLiveRecipes(profName)
    local list = {}
    local totalUnfiltered = 0
    if not C_TradeSkillUI or not C_TradeSkillUI.GetAllRecipeIDs then
        return list, nil, nil, 0
    end

    local skillLineID, skillLineLabel = GetTargetSkillLine(profName)

    -- Ensure learned + unlearned are both visible to GetAllRecipeIDs consumers
    local prevLearned, prevUnlearned
    if C_TradeSkillUI.GetShowLearned then
        prevLearned = C_TradeSkillUI.GetShowLearned()
        prevUnlearned = C_TradeSkillUI.GetShowUnlearned and C_TradeSkillUI.GetShowUnlearned()
    end
    if C_TradeSkillUI.SetShowLearned then pcall(C_TradeSkillUI.SetShowLearned, true) end
    if C_TradeSkillUI.SetShowUnlearned then pcall(C_TradeSkillUI.SetShowUnlearned, true) end

    local ids = C_TradeSkillUI.GetAllRecipeIDs()
    local function restoreFilters()
        if prevLearned ~= nil and C_TradeSkillUI.SetShowLearned then
            pcall(C_TradeSkillUI.SetShowLearned, prevLearned)
        end
        if prevUnlearned ~= nil and C_TradeSkillUI.SetShowUnlearned then
            pcall(C_TradeSkillUI.SetShowUnlearned, prevUnlearned)
        end
    end

    if type(ids) ~= "table" then
        restoreFilters()
        return list, skillLineID, skillLineLabel, 0
    end

    for _, recipeID in ipairs(ids) do
        totalUnfiltered = totalUnfiltered + 1
        if RecipeBelongsToSkillLine(recipeID, skillLineID) then
            local info = C_TradeSkillUI.GetRecipeInfo(recipeID)
            if info and info.name and not info.isDummyRecipe and not info.isRecraft then
                local itemID = CollectOutputItemID(recipeID, info)
                local reagents = CollectReagents(recipeID)
                local skill = ExtractSkill(info, recipeID)
                local categoryName
                if info.categoryID and C_TradeSkillUI.GetCategoryInfo then
                    local ok, catInfo = pcall(C_TradeSkillUI.GetCategoryInfo, info.categoryID)
                    if ok and type(catInfo) == "table" and catInfo.name and catInfo.name ~= "" then
                        categoryName = catInfo.name
                    end
                end

                list[#list + 1] = {
                    recipeID = recipeID,
                    spellID = recipeID,
                    name = info.name,
                    itemID = itemID or 0,
                    skill = skill,
                    learned = info.learned and true or false,
                    categoryID = info.categoryID,
                    categoryName = categoryName,
                    reagents = reagents,
                }
            end
        end
    end

    restoreFilters()
    ResolveLiveItemNames(list)

    table.sort(list, function(a, b)
        return (a.name or "") < (b.name or "")
    end)
    return list, skillLineID, skillLineLabel, totalUnfiltered
end

-- ============================================================
-- DIFF
-- ============================================================

local function IndexCatalog(profName)
    local bySpell, byName, byItem = {}, {}, {}
    local data = private.RecipeData and private.RecipeData[profName]
    if type(data) ~= "table" then return bySpell, byName, byItem, {} end
    local rows = {}
    for i, entry in ipairs(data) do
        rows[i] = entry
        if entry.spellID and entry.spellID > 0 then
            bySpell[entry.spellID] = entry
        end
        if entry.name then
            byName[strlower(entry.name)] = entry
        end
        if entry.itemID and entry.itemID > 0 then
            byItem[entry.itemID] = entry
        end
    end
    return bySpell, byName, byItem, rows
end


-- Source is editorial (how the player learns the recipe). The live profession
-- API does not expose Trainer/Vendor/Spec, so we only validate catalog rows.
local PLACEHOLDER_SOURCES = {
    [""] = true,
    ["imported"] = true,
    ["guide"] = true,
    ["?"] = true,
    ["unknown"] = true,
}

local function NormalizeSource(src)
    if type(src) ~= "string" then return "" end
    return strtrim(src)
end

local function IsPlaceholderSource(src)
    src = NormalizeSource(src)
    if src == "" then return true end
    return PLACEHOLDER_SOURCES[strlower(src)] == true
end

-- Matches Recipes.lua ParseSource prefixes (+ Gather / Patch used in data)
-- Accepted prefixes (must match Recipes.lua ParseSource):
--   Trainer, Vendor[: name], Spec[: tree], Drop: x, Quest: x,
--   Discovery[: x], Gather[: x], Housing, PvP, Recycling, Patch
local function IsKnownSourceFormat(src)
    src = NormalizeSource(src)
    if src == "" then return false end
    if src:match("^[Tt]rainer") then return true end
    if src:match("^[Vv]endor") then return true end
    if src:match("^[Ss]pec") then return true end          -- Spec or Spec: Tree
    if src:match("^[Dd]rop:") then return true end
    if src:match("^[Qq]uest:") then return true end
    if src:match("^[Dd]iscovery") then return true end     -- Discovery or Discovery: x
    if src:match("^[Gg]ather") then return true end
    if src:match("^[Hh]ousing") then return true end
    if src:match("^[Pp]v[Pp]") then return true end
    if src:match("^[Rr]ecycling") then return true end
    if src:match("^[Pp]atch") then return true end
    return false
end

local function CollectSourceIssues(cat)
    local issues = {}
    if type(cat) ~= "table" then
        return issues
    end
    local src = NormalizeSource(cat.source)
    if src == "" then
        issues[#issues + 1] = "catalog missing source"
    elseif IsPlaceholderSource(src) then
        issues[#issues + 1] = "placeholder source: " .. src
    elseif not IsKnownSourceFormat(src) then
        issues[#issues + 1] = "source format: " .. src
    end
    return issues
end

function Debug:BuildDiff(profName, liveList)
    local bySpell, byName, byItem, catalogRows = IndexCatalog(profName)
    local matched = {}
    local diffs = {}

    for _, live in ipairs(liveList) do
        local cat = nil
        if live.spellID and bySpell[live.spellID] then
            cat = bySpell[live.spellID]
        elseif live.name and byName[strlower(live.name)] then
            cat = byName[strlower(live.name)]
        elseif live.itemID and live.itemID > 0 and byItem[live.itemID] then
            cat = byItem[live.itemID]
        end

        if cat then
            matched[cat] = true
            local issues = {}
            if (cat.itemID or 0) == 0 and (live.itemID or 0) > 0 then
                issues[#issues + 1] = "catalog missing itemID"
            elseif (cat.itemID or 0) > 0 and (live.itemID or 0) > 0 and cat.itemID ~= live.itemID then
                issues[#issues + 1] = string.format("itemID %s→%s", tostring(cat.itemID), tostring(live.itemID))
            end
            if cat.spellID and live.spellID and cat.spellID ~= live.spellID then
                issues[#issues + 1] = string.format("spellID %s→%s", tostring(cat.spellID), tostring(live.spellID))
            end
            if not cat.spellID or cat.spellID == 0 then
                issues[#issues + 1] = "catalog missing spellID"
            end
            -- Category name check: our editorial category vs live Blizzard category name
            -- Only flag when both exist and neither is a vague placeholder
            if cat.category and cat.category ~= "" and live.categoryName and live.categoryName ~= "" then
                local dataCat = strlower(cat.category)
                local liveCat = strlower(live.categoryName)
                if dataCat ~= liveCat
                    and not liveCat:find(dataCat, 1, true)
                    and not dataCat:find(liveCat, 1, true)
                then
                    -- Soft note — Blizzard names rarely match our buckets exactly
                    issues[#issues + 1] = string.format("category data=%s live=%s", cat.category, live.categoryName)
                end
            end
            -- Editorial learn-source (not available from live API)
            for _, siss in ipairs(CollectSourceIssues(cat)) do
                issues[#issues + 1] = siss
            end
            local status = (#issues == 0) and "OK" or "Mismatch"
            -- Soft-only notes (category / source) should not force hard Mismatch
            if status == "Mismatch" then
                local hard = 0
                local onlySource = true
                for _, iss in ipairs(issues) do
                    if iss:find("^category ", 1)
                        or iss:find("^catalog missing source", 1)
                        or iss:find("^placeholder source", 1)
                        or iss:find("^source format", 1)
                    then
                        -- soft
                    else
                        hard = hard + 1
                        onlySource = false
                    end
                end
                if hard == 0 then
                    -- Source problems get their own filterable status
                    local hasSourceIssue = false
                    for _, iss in ipairs(issues) do
                        if iss:find("^catalog missing source", 1)
                            or iss:find("^placeholder source", 1)
                            or iss:find("^source format", 1)
                        then
                            hasSourceIssue = true
                            break
                        end
                    end
                    if hasSourceIssue then
                        status = "NoSource"
                    else
                        status = "OK" -- category-only soft note
                    end
                end
            end
            if (cat.itemID or 0) == 0 and (live.itemID or 0) == 0 then
                -- enchants etc. — IDs OK if spell matches; keep source soft-status
                if cat.spellID and live.spellID and cat.spellID == live.spellID then
                    if status == "Mismatch" then
                        -- only drop hard ID issues; keep category/source notes
                        local soft = {}
                        local hasSourceIssue = false
                        for _, iss in ipairs(issues) do
                            if iss:find("^category ", 1)
                                or iss:find("^catalog missing source", 1)
                                or iss:find("^placeholder source", 1)
                                or iss:find("^source format", 1)
                            then
                                soft[#soft + 1] = iss
                                if not iss:find("^category ", 1) then
                                    hasSourceIssue = true
                                end
                            end
                        end
                        issues = soft
                        status = hasSourceIssue and "NoSource" or "OK"
                    end
                end
            end
            if (cat.itemID or 0) == 0 and (live.itemID or 0) > 0 then
                status = "NoID"
            end
            diffs[#diffs + 1] = {
                status = status,
                name = live.name,
                live = live,
                catalog = cat,
                issues = issues,
            }
        else
            diffs[#diffs + 1] = {
                status = "Missing",
                name = live.name,
                live = live,
                catalog = nil,
                issues = { "not in catalog" },
            }
        end
    end

    for _, entry in ipairs(catalogRows) do
        if not matched[entry] then
            local st = "Extra"
            if not entry.itemID or entry.itemID == 0 then
                if not entry.spellID or entry.spellID == 0 then
                    st = "NoID"
                end
            end
            diffs[#diffs + 1] = {
                status = st,
                name = entry.name or "?",
                live = nil,
                catalog = entry,
                issues = { "in catalog only" },
            }
        end
    end

    table.sort(diffs, function(a, b)
        local order = { Missing = 1, NoID = 2, Mismatch = 3, NoSource = 4, Extra = 5, OK = 6 }
        local oa, ob = order[a.status] or 9, order[b.status] or 9
        if oa ~= ob then return oa < ob end
        return (a.name or "") < (b.name or "")
    end)

    return diffs
end

local function FormatLuaEntry(live, catalog)
    -- Keep incomplete rows (name = ?) so nothing is silently dropped
    local name = (live and live.name and live.name ~= "" and live.name)
        or (catalog and catalog.name and catalog.name ~= "" and catalog.name)
        or "?"
    local spellID = (live and live.spellID) or (catalog and catalog.spellID) or 0
    local itemID = (live and live.itemID) or (catalog and catalog.itemID) or 0
    local skill = (catalog and catalog.skill) or (live and live.skill) or 0
    local source = (catalog and catalog.source and catalog.source ~= "" and catalog.source)
        or ""
    local category = (catalog and catalog.category and catalog.category ~= "")
        and catalog.category
        or (live and live.categoryName)
        or ""
    local reagents = (live and live.reagents and #live.reagents > 0) and live.reagents
        or (catalog and catalog.reagents) or {}

    local reagParts = {}
    for _, r in ipairs(reagents) do
        reagParts[#reagParts + 1] = string.format(
            '{name=%q,itemID=%d,amount=%d}',
            r.name or "?",
            r.itemID or 0,
            r.amount or 1
        )
    end
    local reagStr = #reagParts > 0 and ("{" .. table.concat(reagParts, ",") .. "}") or "{}"

    local flag = ""
    if name == "?" or spellID == 0 or source == "" or IsPlaceholderSource(source) then
        flag = " -- NEEDS REVIEW"
    end

    return string.format(
        "  { name = [[%s]], spellID = %d, itemID = %d, skill = %d, source = [[%s]], category = [[%s]], reagents = %s },%s",
        name, spellID, itemID, skill, source, category, reagStr, flag
    )
end

function Debug:ExportDiffs(diffs, onlyStatus)
    local lines = {
        "-- ArtisansCodex recipe export " .. date("%Y-%m-%d %H:%M"),
        "-- Review before pasting. Rows marked NEEDS REVIEW may have name=? or missing spellID.",
    }
    local n = 0
    local needsReview = 0
    for _, d in ipairs(diffs) do
        if not onlyStatus or d.status == onlyStatus or onlyStatus == "All" then
            if d.status == "Missing" or d.status == "NoID" or d.status == "Mismatch" or d.status == "NoSource" then
                local line = FormatLuaEntry(d.live, d.catalog)
                lines[#lines + 1] = line
                n = n + 1
                if line:find("NEEDS REVIEW", 1, true) then
                    needsReview = needsReview + 1
                end
            end
        end
    end
    lines[#lines + 1] = string.format("-- %d entries (%d need review)", n, needsReview)
    return table.concat(lines, "\n"), n
end

-- ============================================================
-- UI
-- ============================================================

local function Backdrop(frame, bg, border)
    frame:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    frame:SetBackdropColor(bg[1], bg[2], bg[3], bg[4] or 0.95)
    frame:SetBackdropBorderColor(border[1], border[2], border[3], border[4] or 0.9)
end

function Debug:Toggle()
    if not self.frame then
        self:CreateFrame()
    end
    if self.frame:IsShown() then
        self.frame:Hide()
    else
        self.frame:Show()
        self:ShowTab(self.activeTab or "log")
    end
end

function Debug:CreateFrame()
    local f = CreateFrame("Frame", "ArtisansCodexDebugFrame", UIParent, "BackdropTemplate")
    f:SetSize(720, 480)
    f:SetPoint("CENTER")
    Backdrop(f, { 0.07, 0.08, 0.12 }, { 0.55, 0.45, 0.20 })
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(true)
    f:Hide() -- must start hidden: Toggle() checks IsShown() right after create
    tinsert(UISpecialFrames, "ArtisansCodexDebugFrame")

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 14, -12)
    title:SetText("|cff00ccffArtisan's Codex|r  Debug")

    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -4, -4)

    -- Tab buttons
    local function MakeTab(label, key, x)
        local btn = CreateFrame("Button", nil, f, "BackdropTemplate")
        btn:SetSize(90, 22)
        btn:SetPoint("TOPLEFT", x, -36)
        Backdrop(btn, { 0.12, 0.13, 0.18 }, { 0.4, 0.35, 0.2 })
        local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fs:SetPoint("CENTER")
        fs:SetText(label)
        btn.fs = fs
        btn:SetScript("OnClick", function()
            self:ShowTab(key)
        end)
        return btn
    end
    f.tabLog = MakeTab("Log", "log", 14)
    f.tabRecipes = MakeTab("Recipes", "recipes", 110)

    -- Content hosts
    f.logPanel = CreateFrame("Frame", nil, f)
    f.logPanel:SetPoint("TOPLEFT", 10, -64)
    f.logPanel:SetPoint("BOTTOMRIGHT", -10, 10)

    f.recipesPanel = CreateFrame("Frame", nil, f)
    f.recipesPanel:SetPoint("TOPLEFT", 10, -64)
    f.recipesPanel:SetPoint("BOTTOMRIGHT", -10, 10)
    f.recipesPanel:Hide()

    self.frame = f
    self:BuildLogPanel()
    self:BuildRecipesPanel()
end

function Debug:ShowTab(key)
    self.activeTab = key
    local f = self.frame
    if not f then return end
    f.logPanel:SetShown(key == "log")
    f.recipesPanel:SetShown(key == "recipes")
    local function style(btn, active)
        if active then
            btn:SetBackdropColor(0.35, 0.28, 0.12, 0.95)
            btn.fs:SetTextColor(1, 0.9, 0.4)
        else
            btn:SetBackdropColor(0.12, 0.13, 0.18, 0.95)
            btn.fs:SetTextColor(0.75, 0.75, 0.75)
        end
    end
    style(f.tabLog, key == "log")
    style(f.tabRecipes, key == "recipes")
    if key == "log" then self:RefreshLog() end
    if key == "recipes" then self:RefreshRecipes() end
end

function Debug:BuildLogPanel()
    local p = self.frame.logPanel

    local toolbar = CreateFrame("Frame", nil, p)
    toolbar:SetPoint("TOPLEFT", 0, 0)
    toolbar:SetPoint("TOPRIGHT", 0, 0)
    toolbar:SetHeight(28)

    local clearBtn = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
    clearBtn:SetSize(70, 22)
    clearBtn:SetPoint("LEFT", 0, 0)
    clearBtn:SetText("Clear")
    clearBtn:SetScript("OnClick", function() self:ClearLog() end)

    local mirror = CreateFrame("CheckButton", nil, toolbar, "UICheckButtonTemplate")
    mirror:SetPoint("LEFT", clearBtn, "RIGHT", 12, 0)
    mirror:SetChecked(self.mirrorChat)
    mirror:SetScript("OnClick", function(btn)
        self.mirrorChat = btn:GetChecked()
    end)
    local mirrorLabel = toolbar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    mirrorLabel:SetPoint("LEFT", mirror, "RIGHT", 0, 0)
    mirrorLabel:SetText("Mirror to chat")

    local countFS = toolbar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    countFS:SetPoint("RIGHT", 0, 0)
    countFS:SetTextColor(0.6, 0.6, 0.6)
    self.logCountFS = countFS

    local scroll = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 0, -32)
    scroll:SetPoint("BOTTOMRIGHT", -28, 0)

    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(1, 1)
    scroll:SetScrollChild(child)
    self.logChild = child
    self.logScroll = scroll
end

function Debug:RefreshLog()
    if not self.logChild then return end
    local child = self.logChild
    for _, c in pairs({ child:GetChildren() }) do
        c:Hide()
        c:SetParent(nil)
    end
    for _, r in pairs({ child:GetRegions() }) do
        if r.SetText then r:Hide() end
    end

    local y = 0
    local width = (self.logScroll and self.logScroll:GetWidth() or 640) - 8
    -- Oldest at top, newest at bottom
    for i = 1, #self.log do
        local e = self.log[i]
        local fs = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fs:SetPoint("TOPLEFT", 4, y)
        fs:SetWidth(width)
        fs:SetJustifyH("LEFT")
        local col = "|cffaaaaaa"
        if e.cat == "error" then col = "|cffff6666"
        elseif e.cat == "progress" then col = "|cff66ccff"
        elseif e.cat == "recipes" then col = "|cff66ff99" end
        local ts = date("%H:%M:%S", e.t)
        fs:SetText(string.format("%s[%s]|r %s%s|r", col, ts, col, e.msg))
        y = y - (fs:GetStringHeight() + 4)
    end
    local height = math.max(40, math.abs(y) + 8)
    child:SetSize(width, height)
    if self.logScroll then
        self.logScroll:UpdateScrollChildRect()
        local maxScroll = math.max(0, height - self.logScroll:GetHeight())
        self.logScroll:SetVerticalScroll(maxScroll)
    end
    if self.logCountFS then
        self.logCountFS:SetText(#self.log .. " lines")
    end
end

function Debug:BuildRecipesPanel()
    local p = self.frame.recipesPanel

    local toolbar = CreateFrame("Frame", nil, p)
    toolbar:SetPoint("TOPLEFT", 0, 0)
    toolbar:SetPoint("TOPRIGHT", 0, 0)
    toolbar:SetHeight(52)

    local importBtn = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
    importBtn:SetSize(130, 22)
    importBtn:SetPoint("TOPLEFT", 0, 0)
    importBtn:SetText("Import live")
    importBtn:SetScript("OnClick", function()
        self:DoImport()
    end)

    local exportBtn = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
    exportBtn:SetSize(120, 22)
    exportBtn:SetPoint("LEFT", importBtn, "RIGHT", 6, 0)
    exportBtn:SetText("Export fixes")
    exportBtn:SetScript("OnClick", function()
        self:DoExport()
    end)

    local statusFS = toolbar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    statusFS:SetPoint("LEFT", exportBtn, "RIGHT", 10, 0)
    statusFS:SetTextColor(0.7, 0.7, 0.7)
    statusFS:SetText("Open a profession, then Import live.")
    self.recipeStatusFS = statusFS

    -- Filter chips
    local filterX = 0
    self.filterButtons = {}
    for _, fname in ipairs(FILTERS) do
        local btn = CreateFrame("Button", nil, toolbar, "BackdropTemplate")
        btn:SetSize(64, 18)
        btn:SetPoint("TOPLEFT", filterX, -28)
        filterX = filterX + 68
        Backdrop(btn, { 0.12, 0.12, 0.16 }, { 0.35, 0.35, 0.40 })
        local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fs:SetPoint("CENTER")
        fs:SetText(fname)
        btn.fs = fs
        btn:SetScript("OnClick", function()
            self.recipeFilter = fname
            self:RefreshRecipes()
        end)
        self.filterButtons[fname] = btn
    end

    local scroll = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 0, -58)
    scroll:SetPoint("BOTTOMRIGHT", -28, 0)
    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(1, 1)
    scroll:SetScrollChild(child)
    self.recipeChild = child
    self.recipeScroll = scroll
end

local function CountDiffs(diffs)
    local counts = { Missing = 0, Mismatch = 0, Extra = 0, NoID = 0, NoSource = 0, OK = 0 }
    for _, d in ipairs(diffs or {}) do
        counts[d.status] = (counts[d.status] or 0) + 1
    end
    return counts
end

local function CountUnresolvedReagents(liveList)
    local n = 0
    for _, rec in ipairs(liveList or {}) do
        for _, r in ipairs(rec.reagents or {}) do
            if r.itemID and r.itemID > 0 and (not r.name or r.name == "?") then
                n = n + 1
            end
        end
    end
    return n
end

function Debug:ApplyImportResult(profName, live, skillLineID, skillLineLabel, totalAll, note)
    self.lastProfName = profName
    self.lastLive = live
    self.lastSkillLineID = skillLineID
    self.lastDiffs = self:BuildDiff(profName, live)
    local counts = CountDiffs(self.lastDiffs)
    local unresolved = CountUnresolvedReagents(live)
    local lineNote = skillLineLabel
        and string.format(" |cffaaaaaa[%s · id %s]|r", skillLineLabel, tostring(skillLineID or "?"))
        or " |cffff6666[no skill-line filter]|r"
    local suffix = note and (" " .. note) or ""
    if unresolved > 0 then
        suffix = suffix .. string.format(" |cffffcc44(%d reagent names still loading)|r", unresolved)
    end
    private:Print(string.format(
        "Recipe audit |cffFFD700%s|r%s: filtered=%d / all=%d  missing=%d  mismatch=%d  noID=%d  noSrc=%d  extra=%d  ok=%d%s",
        profName, lineNote, #live, totalAll or 0,
        counts.Missing, counts.Mismatch, counts.NoID, counts.NoSource or 0, counts.Extra, counts.OK, suffix
    ))
    if self.recipeStatusFS then
        self.recipeStatusFS:SetText(string.format(
            "%s %s · %d/%d · |cffff8866%d miss|r · |cffffcc44%d mm|r · |cff88aaff%d noID|r · |cffffcc66%d src|r · |cff888888%d extra|r · |cff66ee88%d ok|r%s",
            profName, skillLineLabel or "?", #live, totalAll or 0,
            counts.Missing, counts.Mismatch, counts.NoID, counts.NoSource or 0, counts.Extra, counts.OK,
            unresolved > 0 and string.format(" · %d names…", unresolved) or ""
        ))
    end
    self:RefreshRecipes()
end

function Debug:DoImport()
    local rawName = GetOpenProfessionName()
    if not rawName then
        private:Print("|cffff6666Open a profession window first.|r")
        if self.recipeStatusFS then
            self.recipeStatusFS:SetText("|cffff6666No profession open.|r")
        end
        return
    end
    local profName = NormalizeProfName(rawName)
    local live, skillLineID, skillLineLabel, totalAll = ScanLiveRecipes(profName)
    self:ApplyImportResult(profName, live, skillLineID, skillLineLabel, totalAll, nil)

    -- Item names often arrive a moment later — re-resolve and refresh UI
    local function delayedResolve(pass, delay)
        if C_Timer and C_Timer.After then
            C_Timer.After(delay, function()
                if self.lastLive ~= live then return end -- newer import replaced this scan
                local fixed = ResolveLiveItemNames(live)
                if fixed > 0 or pass == 1 then
                    self:ApplyImportResult(
                        profName, live, skillLineID, skillLineLabel, totalAll,
                        fixed > 0 and string.format("|cff66ff99(+%d names)|r", fixed) or nil
                    )
                end
                if pass < 2 then
                    delayedResolve(pass + 1, 1.0)
                end
            end)
        end
    end
    delayedResolve(1, 0.4)
end

--- Simple selectable text box so you can Ctrl+A / Ctrl+C the export
function Debug:ShowExportBox(text)
    if not self.frame then return end
    if self.exportBox then
        self.exportBox:Hide()
        self.exportBox:SetParent(nil)
        self.exportBox = nil
    end

    local box = CreateFrame("Frame", "ArtisansCodexExportBox", self.frame, "BackdropTemplate")
    box:SetSize(560, 300)
    box:SetPoint("CENTER")
    box:SetFrameStrata("FULLSCREEN_DIALOG")
    Backdrop(box, { 0.06, 0.07, 0.10 }, { 0.75, 0.60, 0.20 })

    local titleFS = box:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleFS:SetPoint("TOPLEFT", 12, -10)
    titleFS:SetText("Export — Select all, then copy (Ctrl+C)")

    local close = CreateFrame("Button", nil, box, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -2, -2)
    close:SetScript("OnClick", function()
        box:Hide()
        box:SetParent(nil)
        if self.exportBox == box then self.exportBox = nil end
    end)

    local scroll = CreateFrame("ScrollFrame", nil, box, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 12, -32)
    scroll:SetPoint("BOTTOMRIGHT", -32, 40)

    local edit = CreateFrame("EditBox", nil, scroll)
    edit:SetMultiLine(true)
    edit:SetFontObject(GameFontHighlightSmall)
    edit:SetWidth(500)
    edit:SetAutoFocus(false)
    edit:SetScript("OnEscapePressed", function() box:Hide() end)
    scroll:SetScrollChild(edit)

    local body = text or ""
    edit:SetText(body)
    local lineCount = 1
    for _ in body:gmatch("\n") do lineCount = lineCount + 1 end
    edit:SetHeight(math.max(240, lineCount * 14))

    local selectBtn = CreateFrame("Button", nil, box, "UIPanelButtonTemplate")
    selectBtn:SetSize(100, 22)
    selectBtn:SetPoint("BOTTOMRIGHT", -12, 10)
    selectBtn:SetText("Select all")
    selectBtn:SetScript("OnClick", function()
        edit:SetFocus()
        edit:HighlightText()
    end)

    local hint = box:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    hint:SetPoint("BOTTOMLEFT", 12, 14)
    hint:SetTextColor(0.65, 0.65, 0.65)
    hint:SetText("Review lines before pasting into the recipe data file.")

    self.exportBox = box
    box:Show()
    edit:SetFocus()
    edit:HighlightText()
end

function Debug:DoExport()
    if not self.lastDiffs then
        private:Print("|cffff6666Import a profession first.|r")
        if self.recipeStatusFS then
            self.recipeStatusFS:SetText("|cffff6666Import first, then Export.|r")
        end
        return
    end

    -- Final pass on item names before building Lua text
    if self.lastLive then
        local fixed = ResolveLiveItemNames(self.lastLive)
        if fixed > 0 and self.lastProfName then
            self.lastDiffs = self:BuildDiff(self.lastProfName, self.lastLive)
            private:Print(string.format("Resolved |cff66ff99%d|r more item names before export.", fixed))
        end
    end

    local text, n = self:ExportDiffs(self.lastDiffs, "All")
    if n == 0 then
        private:Print("|cffffcc44Nothing to export|r (no Missing / Mismatch / NoID / NoSource rows).")
        if self.recipeStatusFS then
            self.recipeStatusFS:SetText("|cffffcc44Nothing to export.|r")
        end
        return
    end

    local unresolved = CountUnresolvedReagents(self.lastLive)
    if unresolved > 0 then
        private:Print(string.format(
            "|cffffcc44Warning:|r %d reagent(s) still have name=? (item data not cached). IDs are still valid.",
            unresolved
        ))
    end

    private:Print(string.format("Export ready: %d lines — use the box to copy.", n))
    if self.recipeStatusFS then
        self.recipeStatusFS:SetText(string.format("|cff66ff99%d lines — Select all → Ctrl+C|r", n))
    end
    self:ShowExportBox(text)
end

local STATUS_COLOR = {
    Missing  = { 1.0, 0.45, 0.35 },
    Mismatch = { 1.0, 0.75, 0.30 },
    Extra    = { 0.55, 0.55, 0.60 },
    NoID     = { 0.50, 0.70, 1.0 },
    NoSource = { 1.00, 0.75, 0.35 },
    OK       = { 0.35, 0.85, 0.45 },
}

function Debug:RefreshRecipes()
    if not self.recipeChild then return end
    local child = self.recipeChild
    for _, c in pairs({ child:GetChildren() }) do
        c:Hide()
        c:SetParent(nil)
    end
    for _, r in pairs({ child:GetRegions() }) do
        if r.SetText then r:Hide() end
    end

    for name, btn in pairs(self.filterButtons or {}) do
        local active = self.recipeFilter == name
        if active then
            btn:SetBackdropColor(0.35, 0.28, 0.12, 0.95)
            btn.fs:SetTextColor(1, 0.9, 0.4)
        else
            btn:SetBackdropColor(0.12, 0.12, 0.16, 0.95)
            btn.fs:SetTextColor(0.75, 0.75, 0.75)
        end
    end

    local diffs = self.lastDiffs
    if not diffs then
        local fs = child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        fs:SetPoint("TOPLEFT", 8, -8)
        fs:SetTextColor(0.65, 0.65, 0.65)
        fs:SetText("Open a profession window and click |cffFFD700Import live|r.\nDiffs compare live API recipes to Data/Midnight/Recipes/<Prof>.lua")
        child:SetSize(500, 60)
        return
    end

    local filter = self.recipeFilter or "All"
    local y = 0
    local width = (self.recipeScroll and self.recipeScroll:GetWidth() or 640) - 8
    local shown = 0

    for _, d in ipairs(diffs) do
        if filter == "All" or d.status == filter then
            shown = shown + 1
            local row = CreateFrame("Button", nil, child, "BackdropTemplate")
            row:SetSize(width, 36)
            row:SetPoint("TOPLEFT", 0, y)
            Backdrop(row, { 0.09, 0.10, 0.14 }, { 0.25, 0.25, 0.28 })

            local live = d.live
            local cat = d.catalog
            local col = STATUS_COLOR[d.status] or { 0.8, 0.8, 0.8 }

            -- Icon (left)
            local itemID = (live and live.itemID and live.itemID > 0 and live.itemID)
                or (cat and cat.itemID and cat.itemID > 0 and cat.itemID)
                or 0
            local iconTex = row:CreateTexture(nil, "ARTWORK")
            iconTex:SetSize(28, 28)
            iconTex:SetPoint("LEFT", 6, 0)
            iconTex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            local iconPath = "Interface\\Icons\\INV_Misc_QuestionMark"
            if itemID > 0 and addon and addon.GetItemIcon then
                iconPath = addon:GetItemIcon(itemID) or iconPath
            elseif itemID > 0 and C_Item and C_Item.GetItemIconByID then
                iconPath = C_Item.GetItemIconByID(itemID) or iconPath
            end
            iconTex:SetTexture(iconPath)

            -- Status (right)
            local badge = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            badge:SetPoint("RIGHT", -8, 0)
            badge:SetWidth(64)
            badge:SetJustifyH("RIGHT")
            badge:SetTextColor(col[1], col[2], col[3])
            badge:SetText(d.status)

            -- Name + meta (middle)
            local nameFS = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            nameFS:SetPoint("LEFT", iconTex, "RIGHT", 8, 6)
            nameFS:SetPoint("RIGHT", badge, "LEFT", -8, 6)
            nameFS:SetJustifyH("LEFT")
            nameFS:SetWordWrap(false)
            nameFS:SetText(d.name or "?")

            local meta = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            meta:SetPoint("LEFT", iconTex, "RIGHT", 8, -8)
            meta:SetPoint("RIGHT", badge, "LEFT", -8, -8)
            meta:SetJustifyH("LEFT")
            meta:SetTextColor(0.6, 0.6, 0.6)
            local bits = {}
            if live then
                bits[#bits + 1] = "live spell " .. tostring(live.spellID or "?")
                bits[#bits + 1] = "item " .. tostring(live.itemID or 0)
            end
            if cat then
                bits[#bits + 1] = "data spell " .. tostring(cat.spellID or 0)
                bits[#bits + 1] = "item " .. tostring(cat.itemID or 0)
            end
            if d.issues and #d.issues > 0 then
                bits[#bits + 1] = table.concat(d.issues, "; ")
            end
            meta:SetText(table.concat(bits, " · "))

            row:SetScript("OnEnter", function(selfBtn)
                GameTooltip:SetOwner(selfBtn, "ANCHOR_RIGHT")
                GameTooltip:AddLine(d.name or "?", 1, 0.85, 0.2)
                GameTooltip:AddLine("Status: " .. d.status, col[1], col[2], col[3])
                if live then
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine("Live", 0.4, 0.8, 1)
                    GameTooltip:AddDoubleLine("spellID", tostring(live.spellID), 0.8, 0.8, 0.8, 1, 1, 1)
                    GameTooltip:AddDoubleLine("itemID", tostring(live.itemID), 0.8, 0.8, 0.8, 1, 1, 1)
                    if live.categoryName then
                        GameTooltip:AddDoubleLine("category", live.categoryName, 0.8, 0.8, 0.8, 0.7, 0.85, 1)
                    end
                    if live.reagents then
                        for _, r in ipairs(live.reagents) do
                            GameTooltip:AddDoubleLine(r.name or "?", (r.amount or 1) .. "  id=" .. (r.itemID or 0), 0.7, 0.7, 0.7, 0.6, 0.6, 0.6)
                        end
                    end
                end
                if cat then
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine("Catalog", 1, 0.8, 0.3)
                    GameTooltip:AddDoubleLine("spellID", tostring(cat.spellID or 0), 0.8, 0.8, 0.8, 1, 1, 1)
                    GameTooltip:AddDoubleLine("itemID", tostring(cat.itemID or 0), 0.8, 0.8, 0.8, 1, 1, 1)
                    GameTooltip:AddDoubleLine("category", tostring(cat.category or ""), 0.8, 0.8, 0.8, 1, 0.9, 0.5)
                    GameTooltip:AddDoubleLine("source", tostring(cat.source or ""), 0.8, 0.8, 0.8, 0.7, 0.7, 0.7)
                end
                GameTooltip:Show()
            end)
            row:SetScript("OnLeave", function() GameTooltip:Hide() end)

            y = y - 40
        end
    end

    if shown == 0 then
        local fs = child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        fs:SetPoint("TOPLEFT", 8, -8)
        fs:SetTextColor(0.65, 0.65, 0.65)
        fs:SetText("No rows for filter: " .. filter)
        y = -40
    end
    child:SetSize(width, math.max(40, math.abs(y) + 8))
end

-- Module init hook from Core
function Debug:Initialize()
    private:Print("Debug module loaded (/ac debug)")
end