-- Artisan's Codex - Core.lua
-- Main logic of the addon

-- luacheck: globals ArtisansCodexDB

local addonName, private = ...
local addon = private.addon

-- ============================================================
-- DEFAULT SETTINGS
-- ============================================================
local defaults = {
    minimap = {
        hide = false,
    },
    goal = "personal",          -- personal / gold / orders / balanced
    scale = 1.0,
    completedTreasures = {},
    lastSeenSkill = {},
    debug = true,

    -- Account Progress (multi-character card overview)
    -- characters[GUID] = snapshot written while that toon is logged in
    -- tracked[GUID] = false hides the character from the Progress panel
    -- cardChips controls which status chips appear on cards
    progress = {
        characters = {},
        tracked = {},
        cardChips = {
            skill = true,
            concentration = true,
            knowledge = true,
            notebook = true,   -- Weekly Quest
            zoneDrops = true,  -- Uniques
            treatise = true,
            treasures = true,
            firstCrafts = true,
            catchUp = true,
            gathering = true,
            moxie = true,
            darkmoon = true,   -- shown only when Faire is active
        },
        weeklyReset = 0, -- GetServerTime() of next weekly reset after last clear
    },

    -- Per-character learned recipe scans (filled automatically when profession opens)
    -- learnedRecipes[playerGUID][profName] = { bySpell={}, byItem={}, byName={}, scannedAt= }
    learnedRecipes = {},
}

-- Simple function to copy default settings
local function CopyDefaults(src, dest)
    if type(src) ~= "table" then return {} end
    dest = dest or {}
    for k, v in pairs(src) do
        if type(v) == "table" then
            dest[k] = CopyDefaults(v, dest[k])
        elseif dest[k] == nil then
            dest[k] = v
        end
    end
    return dest
end



-- ============================================================
-- ITEM HELPERS
-- ============================================================
function addon:GetItemCount(itemID)
    if not itemID then return 0 end
    -- includeBank = true, includeCharges = false, includeReagentBank = true, includeWarbandBank = true
    return C_Item.GetItemCount(itemID, true, false, true, true) or 0
end

function addon:GetItemIcon(itemID)
    if not itemID then return "Interface\\Icons\\INV_Misc_QuestionMark" end
    local icon = C_Item.GetItemIconByID(itemID)
    return icon or "Interface\\Icons\\INV_Misc_QuestionMark"
end

-- ============================================================
-- PROFESSION HELPERS
-- ============================================================
-- Checks whether the CURRENT character has actually trained the given
-- profession name (e.g. "Tailoring"), and if so returns its skillLineID.
-- GetProfessions() only reflects the logged-in character, so a profession
-- can be a valid guide topic in the addon's data without being learned.
function addon:GetLearnedSkillLineID(professionName)
    if type(professionName) ~= "string" or professionName == "" then
        return nil
    end
    -- GetProfessions() → primary1, primary2, archaeology, fishing, cooking
    -- IMPORTANT: do NOT ipairs() a list that may contain nil — ipairs stops at the
    -- first hole, so a missing Archaeology slot would skip Fishing and Cooking.
    local p1, p2, archaeology, fishing, cooking = GetProfessions()
    local indices = { p1, p2, archaeology, fishing, cooking }
    for i = 1, #indices do
        local idx = indices[i]
        if idx then
            local name, _, _, _, _, _, skillLine = GetProfessionInfo(idx)
            if type(name) ~= "string" then
                -- continue
            elseif name == professionName then
                return skillLine
            else
                -- Expansion-prefixed skill lines (e.g. "Midnight Cooking")
                local bare = name:match("Midnight%s+(.+)$")
                    or name:match("Khaz Algar%s+(.+)$")
                    or name:match("Dragon Isles%s+(.+)$")
                    or name:match("Shadowlands%s+(.+)$")
                    or name:match("Kul Tiran%s+(.+)$")
                    or name:match("Zandalari%s+(.+)$")
                    or name:match("Legion%s+(.+)$")
                if bare and bare == professionName then
                    return skillLine
                end
                -- Secondary professions: name often still contains the base word
                if (professionName == "Cooking"
                    or professionName == "Fishing"
                    or professionName == "Archaeology")
                    and name:find(professionName, 1, true)
                then
                    return skillLine
                end
            end
        end
    end
    return nil
end

function addon:IsProfessionLearned(professionName)
    return self:GetLearnedSkillLineID(professionName) ~= nil
end

-- ============================================================
-- DATABASE
-- ============================================================
function addon:InitDB()
    ArtisansCodexDB = ArtisansCodexDB or {}
    self.db = CopyDefaults(defaults, ArtisansCodexDB)
    private.debug = self.db.debug
    private:Print("Database initialized")
end

-- ============================================================
-- ACCOUNT PROGRESS — character cache schema & helpers
-- ============================================================
-- Per-character snapshot shape (written only while that toon is logged in):
-- {
--   guid, name, realm, classID, classFile, level, lastUpdate,
--   professions = {
--     [professionName] = {
--       name, skillLineID, skillLevel, skillMaxLevel,
--       concentration = { quantity, maxQuantity },  -- optional
--       weekly = {
--         patron    = { done, progress, max },
--         notebook  = { done },
--         zoneDrops = { done, progress, max },
--         treatise  = { done },
--         darkmoon  = { done },
--       },
--       treasures   = { collected, total },
--       firstCrafts = { done, total },
--       catchUp     = { quantity, maxQuantity },
--       gathering   = { done, progress, max },      -- gathering professions
--     },
--   },
--   completedQuests = { [questID] = true },  -- for weekly reset clearing
-- }

local function EmptyProfessionSnapshot(name, skillLineID)
    return {
        name = name or "?",
        skillLineID = skillLineID,
        skillLevel = 0,
        skillMaxLevel = 0,
        concentration = nil,
        weekly = {
            patron    = { done = false, progress = 0, max = nil },
            notebook  = { done = false },
            zoneDrops = { done = false, progress = 0, max = nil },
            treatise  = { done = false },
            darkmoon  = { done = false },
        },
        treasures   = { collected = 0, total = 0 },
        firstCrafts = { done = 0, total = 0 },
        catchUp     = { quantity = 0, maxQuantity = 0 },
        gathering   = { done = false, progress = 0, max = 0 },
        moxie       = { quantity = 0, maxQuantity = 0 },
    }
end

function addon:GetPlayerGUID()
    return UnitGUID("player")
end

--- Ensure progress tables exist (safe after old SV loads).
function addon:EnsureProgressDB()
    local db = self.db
    if type(db.progress) ~= "table" then
        db.progress = CopyDefaults(defaults.progress, {})
    end
    db.progress.characters = db.progress.characters or {}
    db.progress.tracked = db.progress.tracked or {}
    db.progress.cardChips = CopyDefaults(defaults.progress.cardChips, db.progress.cardChips or {})
    if type(db.progress.weeklyReset) ~= "number" then
        db.progress.weeklyReset = 0
    end
    return db.progress
end

--- Get or create the snapshot for a GUID (defaults to current player).
function addon:GetCharacterSnapshot(guid)
    local progress = self:EnsureProgressDB()
    guid = guid or self:GetPlayerGUID()
    if not guid then return nil end

    if not progress.characters[guid] then
        progress.characters[guid] = {
            guid = guid,
            name = "",
            realm = "",
            classID = 0,
            classFile = nil,
            level = 0,
            lastUpdate = 0,
            professions = {},
            completedQuests = {},
        }
    end
    local char = progress.characters[guid]
    char.professions = char.professions or {}
    char.completedQuests = char.completedQuests or {}
    return char
end

--- Whether this character should appear on the Progress panel.

--- Snapshot for one profession on a character (defaults to current player).
function addon:GetProfessionSnapshot(profName, guid)
    if not profName then return nil end
    local char = self:GetCharacterSnapshot(guid)
    if not char or type(char.professions) ~= "table" then return nil end
    return char.professions[profName]
end

--- Compact status bar used by Knowledge / Leveling (and future tabs).
--- opts: width, height, value, maxValue, label, r,g,b  (optional unspent for knowledge)
function addon:CreateStatusMeter(parent, opts)
    opts = opts or {}
    local width = opts.width or 200
    local height = opts.height or 16
    local value = tonumber(opts.value) or 0
    local maxValue = tonumber(opts.maxValue) or 0
    local r = opts.r or 0.85
    local g = opts.g or 0.70
    local b = opts.b or 0.20

    local f = CreateFrame("Frame", nil, parent)
    f:SetSize(width, height + (opts.label and 14 or 0))

    local yOff = 0
    if opts.label then
        local lab = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        lab:SetPoint("TOPLEFT", 0, 0)
        lab:SetText(opts.label)
        lab:SetTextColor(0.75, 0.75, 0.75)
        f.label = lab
        yOff = -14
    end

    local track = CreateFrame("Frame", nil, f, "BackdropTemplate")
    track:SetPoint("TOPLEFT", 0, yOff)
    track:SetSize(width, height)
    track:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    track:SetBackdropColor(0.08, 0.08, 0.10, 0.95)
    track:SetBackdropBorderColor(0.35, 0.32, 0.22, 0.8)
    f.track = track

    local fill = track:CreateTexture(nil, "ARTWORK")
    fill:SetPoint("TOPLEFT", 1, -1)
    fill:SetPoint("BOTTOMLEFT", 1, 1)
    fill:SetColorTexture(r, g, b, 0.85)
    f.fill = fill

    local text = track:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("CENTER")
    text:SetJustifyH("CENTER")
    f.text = text

    function f:SetValues(val, maxV, extra)
        val = tonumber(val) or 0
        maxV = tonumber(maxV) or 0
        local ratio = 0
        if maxV > 0 then
            ratio = math.min(1, math.max(0, val / maxV))
        end
        local innerW = math.max(0, width - 2)
        fill:SetWidth(math.max(1, innerW * ratio))
        if maxV > 0 then
            if extra and extra > 0 then
                text:SetText(string.format("%d(+%d) / %d", val, extra, maxV))
            else
                text:SetText(string.format("%d / %d", val, maxV))
            end
            text:SetTextColor(0.95, 0.95, 0.9)
        else
            text:SetText(opts.emptyText or "—")
            text:SetTextColor(0.5, 0.5, 0.5)
            fill:SetWidth(1)
        end
    end

    f:SetValues(value, maxValue, opts.unspent)
    return f
end

function addon:IsCharacterTracked(guid)
    local progress = self:EnsureProgressDB()
    if progress.tracked[guid] == false then
        return false
    end
    return true -- default: tracked once we have a snapshot
end

function addon:SetCharacterTracked(guid, tracked)
    local progress = self:EnsureProgressDB()
    progress.tracked[guid] = tracked and true or false
end

--- Sorted list of character snapshots (tracked only by default).
function addon:GetTrackedCharacters(includeUntracked)
    local progress = self:EnsureProgressDB()
    local list = {}
    for guid, char in pairs(progress.characters) do
        if includeUntracked or self:IsCharacterTracked(guid) then
            list[#list + 1] = char
        end
    end
    table.sort(list, function(a, b)
        local aT, bT = a.lastUpdate or 0, b.lastUpdate or 0
        if aT ~= bT then return aT > bT end
        return (a.name or "") < (b.name or "")
    end)
    return list
end

function addon:DeleteCharacterSnapshot(guid)
    local progress = self:EnsureProgressDB()
    if not guid then return end
    progress.characters[guid] = nil
    progress.tracked[guid] = nil
end

--- Card chip visibility (which stats show on character cards).
function addon:IsCardChipVisible(chipKey)
    local progress = self:EnsureProgressDB()
    return progress.cardChips[chipKey] ~= false
end

function addon:SetCardChipVisible(chipKey, visible)
    local progress = self:EnsureProgressDB()
    progress.cardChips[chipKey] = visible and true or false
end

--- Clear weekly-only quest flags after weekly reset (treasures / first crafts stay).
function addon:TaskWeeklyReset()
    local progress = self:EnsureProgressDB()
    local now = GetServerTime()
    local secondsUntil = C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset
        and C_DateAndTime.GetSecondsUntilWeeklyReset() or 0

    if type(progress.weeklyReset) == "number" and progress.weeklyReset > 0 and progress.weeklyReset <= now then
        -- Collect weekly quest IDs from ProgressMeta (aligned with WeeklyKnowledge)
        local weeklyQuestIDs = {}
        if private.ProgressMeta and private.ProgressMeta.GetAllWeeklyQuestIDs then
            weeklyQuestIDs = private.ProgressMeta:GetAllWeeklyQuestIDs()
        end
        -- Also pick up any questIDs still embedded in guide data weekly tables
        if private.Data then
            for _, profData in pairs(private.Data) do
                if type(profData) == "table" and type(profData.weekly) == "table" then
                    for _, src in ipairs(profData.weekly) do
                        if src.unlockQuestID then weeklyQuestIDs[src.unlockQuestID] = true end
                        if src.questID then weeklyQuestIDs[src.questID] = true end
                        if type(src.questIDs) == "table" then
                            for _, qid in ipairs(src.questIDs) do
                                weeklyQuestIDs[qid] = true
                            end
                        end
                    end
                end
            end
        end

        for _, char in pairs(progress.characters) do
            if type(char.completedQuests) == "table" then
                for qid in pairs(weeklyQuestIDs) do
                    char.completedQuests[qid] = nil
                end
            end
            if type(char.professions) == "table" then
                for _, prof in pairs(char.professions) do
                    if prof.weekly then
                        for _, key in ipairs({ "patron", "notebook", "zoneDrops", "treatise", "darkmoon" }) do
                            local w = prof.weekly[key]
                            if w then
                                w.done = false
                                if w.progress ~= nil then w.progress = 0 end
                            end
                        end
                    end
                    if prof.gathering then
                        prof.gathering.done = false
                        prof.gathering.progress = 0
                    end
                end
            end
        end
        private:Print("Weekly reset applied to cached character progress.")
    end

    progress.weeklyReset = now + secondsUntil
end

--- Identity fields for the logged-in character.
function addon:ScanCharacterInfo()
    local char = self:GetCharacterSnapshot()
    if not char then return end

    char.name = UnitName("player") or char.name
    char.realm = GetNormalizedRealmName and GetNormalizedRealmName() or (GetRealmName and GetRealmName()) or char.realm
    char.level = UnitLevel("player") or char.level
    local _, classFile, classID = UnitClass("player")
    char.classFile = classFile or char.classFile
    char.classID = classID or char.classID
    char.guid = self:GetPlayerGUID() or char.guid
    char.lastUpdate = GetServerTime()
end

local function EnsureProfSnap(char, name, skillLineID)
    local snap = char.professions[name]
    if not snap then
        snap = EmptyProfessionSnapshot(name, skillLineID)
        char.professions[name] = snap
    end
    return snap
end

local function IsQuestComplete(questID)
    if not questID or not C_QuestLog or not C_QuestLog.IsQuestFlaggedCompleted then
        return false
    end
    return C_QuestLog.IsQuestFlaggedCompleted(questID)
end

--- Profession skill levels for the logged-in character (names must match Data keys).
--- Includes secondary professions (Cooking, Fishing, Archaeology).
function addon:ScanProfessionSkills()
    local char = self:GetCharacterSnapshot()
    if not char then return end

    local function bareName(name)
        if type(name) ~= "string" then return name end
        return name:match("Midnight%s+(.+)$")
            or name:match("Khaz Algar%s+(.+)$")
            or name:match("Dragon Isles%s+(.+)$")
            or name:match("Shadowlands%s+(.+)$")
            or name:match("Kul Tiran%s+(.+)$")
            or name:match("Zandalari%s+(.+)$")
            or name:match("Legion%s+(.+)$")
            or name
    end

    -- Do not ipairs() over a table with nil holes (skips Fishing/Cooking if Archaeology is nil).
    local p1, p2, archaeology, fishing, cooking = GetProfessions()
    local indices = { p1, p2, archaeology, fishing, cooking }
    for i = 1, #indices do
        local idx = indices[i]
        if idx then
            local name, _, skillLevel, maxSkill, _, _, skillLine = GetProfessionInfo(idx)
            if name then
                local key = bareName(name)
                local snap = EnsureProfSnap(char, key, skillLine)
                snap.name = key
                snap.skillLineID = skillLine
                snap.skillLevel = skillLevel or 0
                snap.skillMaxLevel = maxSkill or 0
            end
        end
    end
    char.lastUpdate = GetServerTime()
end

--- Concentration + catch-up KP currencies (Blizzard hidden trackers).
function addon:ScanCurrencies()
    local char = self:GetCharacterSnapshot()
    if not char then return end
    char.currencies = char.currencies or {}

    local metaTable = private.ProgressMeta
    if not metaTable or not metaTable.professions then return end
    if not C_CurrencyInfo or not C_CurrencyInfo.GetCurrencyInfo then return end

    for profName, meta in pairs(metaTable.professions) do
        local snap = char.professions[profName]
        -- Only fill currency fields for professions this character has learned
        if snap then
            if meta.concentrationCurrencyID and meta.concentrationCurrencyID > 0 then
                local info = C_CurrencyInfo.GetCurrencyInfo(meta.concentrationCurrencyID)
                if info then
                    snap.concentration = {
                        currencyID = meta.concentrationCurrencyID,
                        quantity = info.quantity or 0,
                        maxQuantity = info.maxQuantity or 0,
                    }
                    char.currencies[meta.concentrationCurrencyID] = {
                        id = meta.concentrationCurrencyID,
                        quantity = info.quantity or 0,
                        maxQuantity = info.maxQuantity or 0,
                        lastUpdated = GetServerTime(),
                    }
                end
            end

            if meta.catchUpCurrencyID and meta.catchUpCurrencyID > 0 then
                local info = C_CurrencyInfo.GetCurrencyInfo(meta.catchUpCurrencyID)
                if info then
                    local qty = info.quantity or 0
                    local maxQ = info.maxQuantity or 0
                    snap.catchUp = {
                        currencyID = meta.catchUpCurrencyID,
                        quantity = qty,
                        maxQuantity = maxQ,
                    }
                    -- Patron / weekly KP progress is primarily this currency (earned vs weekly cap)
                    snap.weekly = snap.weekly or EmptyProfessionSnapshot(profName).weekly
                    snap.weekly.patron.progress = qty
                    snap.weekly.patron.max = maxQ > 0 and maxQ or nil
                    snap.weekly.patron.done = (maxQ > 0 and qty >= maxQ) or false

                    char.currencies[meta.catchUpCurrencyID] = {
                        id = meta.catchUpCurrencyID,
                        quantity = qty,
                        maxQuantity = maxQ,
                        lastUpdated = GetServerTime(),
                    }
                end
            end

            -- Artisan <Profession>'s Moxie (spendable profession currency)
            if meta.moxieCurrencyID and meta.moxieCurrencyID > 0 then
                local info = C_CurrencyInfo.GetCurrencyInfo(meta.moxieCurrencyID)
                if info then
                    snap.moxie = {
                        currencyID = meta.moxieCurrencyID,
                        quantity = info.quantity or 0,
                        maxQuantity = info.maxQuantity or 0,
                    }
                    char.currencies[meta.moxieCurrencyID] = {
                        id = meta.moxieCurrencyID,
                        quantity = info.quantity or 0,
                        maxQuantity = info.maxQuantity or 0,
                        lastUpdated = GetServerTime(),
                    }
                end
            end

            -- Knowledge points: unspent from specialization currency; spent/max by walking trait trees
            -- (same approach as WeeklyKnowledge — GetProfessionInfoBySkillLineID does not expose correct KP)
            snap.knowledge = snap.knowledge or { unspent = 0, spent = 0, max = 0 }
            if meta.variantID and C_ProfSpecs then
                if C_ProfSpecs.GetCurrencyInfoForSkillLine then
                    local ok, info = pcall(C_ProfSpecs.GetCurrencyInfoForSkillLine, meta.variantID)
                    if ok and info then
                        snap.knowledge.unspent = info.numAvailable or info.quantity or 0
                    end
                end

                local spent, maxK = 0, 0
                if C_ProfSpecs.GetConfigIDForSkillLine and C_Traits then
                    local okCfg, configID = pcall(C_ProfSpecs.GetConfigIDForSkillLine, meta.variantID)
                    if okCfg and configID and configID > 0 then
                        local okInfo, configInfo = pcall(C_Traits.GetConfigInfo, configID)
                        if okInfo and configInfo and configInfo.treeIDs then
                            for _, treeID in ipairs(configInfo.treeIDs) do
                                local okNodes, treeNodes = pcall(C_Traits.GetTreeNodes, treeID)
                                if okNodes and treeNodes then
                                    for _, nodeID in ipairs(treeNodes) do
                                        local okNode, nodeInfo = pcall(C_Traits.GetNodeInfo, configID, nodeID)
                                        if okNode and nodeInfo then
                                            local maxRanks = nodeInfo.maxRanks or 0
                                            if maxRanks > 1 then
                                                maxK = maxK + (maxRanks - 1)
                                            end
                                            -- Free rank 1 does not cost KP; only ranks beyond the first count
                                            local ranksPurchased = nodeInfo.ranksPurchased or 0
                                            local currentRank = nodeInfo.currentRank or 0
                                            if ranksPurchased > 1 and currentRank > 1 then
                                                spent = spent + (currentRank - 1)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                snap.knowledge.spent = spent
                snap.knowledge.max = maxK
            end
        end
    end
    char.lastUpdate = GetServerTime()
end

--- Catch-up items in bags (Flicker / gathering catch-up reagents).
function addon:ScanCatchUpItems()
    local char = self:GetCharacterSnapshot()
    if not char then return end
    char.items = char.items or {}

    local metaTable = private.ProgressMeta
    if not metaTable or not metaTable.professions then return end

    for profName, meta in pairs(metaTable.professions) do
        if meta.catchUpItemID and meta.catchUpItemID > 0 then
            local count = self:GetItemCount(meta.catchUpItemID) or 0
            char.items[meta.catchUpItemID] = count
            local snap = char.professions[profName]
            if snap then
                snap.catchUp = snap.catchUp or { quantity = 0, maxQuantity = 0 }
                snap.catchUp.itemID = meta.catchUpItemID
                snap.catchUp.itemCount = count
            end
        end
    end
    char.lastUpdate = GetServerTime()
end

--- Gathering / disenchant weekly knowledge drops (quest flags).
function addon:ScanGathering()
    local char = self:GetCharacterSnapshot()
    if not char then return end

    local metaTable = private.ProgressMeta
    if not metaTable or not metaTable.professions then return end

    for profName, meta in pairs(metaTable.professions) do
        local quests = meta.gatheringQuests
        if type(quests) == "table" and #quests > 0 then
            local snap = char.professions[profName]
            if snap then
                local doneCount = 0
                for _, qid in ipairs(quests) do
                    if IsQuestComplete(qid) then
                        doneCount = doneCount + 1
                        char.completedQuests[qid] = true
                    end
                end
                local total = #quests
                snap.gathering = {
                    done = doneCount >= total,
                    progress = doneCount,
                    max = total,
                }
            end
        end
    end
    char.lastUpdate = GetServerTime()
end

--- First-craft KP from curated Midnight recipe list (WeeklyKnowledge catalog).
--- Prefer quest flags when present; otherwise C_TradeSkillUI.IsRecipeFirstCraft(spellID).
--- done = KP already earned, total = catalog size for that profession.
function addon:ScanFirstCrafts()
    local char = self:GetCharacterSnapshot()
    if not char then return end
    char.firstCrafts = char.firstCrafts or {}

    local catalog = private.FirstCrafts and private.FirstCrafts.byProfession
    if type(catalog) ~= "table" then
        return
    end

    local canCheckSpell = C_TradeSkillUI and C_TradeSkillUI.IsRecipeFirstCraft

    for profName, list in pairs(catalog) do
        local snap = char.professions[profName]
        if snap and type(list) == "table" and #list > 0 then
            local done, total, available = 0, 0, 0
            for _, entry in ipairs(list) do
                local points = entry.points or 1
                total = total + points
                local claimed = false

                -- Quest flags are authoritative when the catalog provides them
                if type(entry.quests) == "table" and #entry.quests > 0 then
                    local allDone = true
                    local anyDone = false
                    for _, qid in ipairs(entry.quests) do
                        if IsQuestComplete(qid) then
                            anyDone = true
                            char.completedQuests[qid] = true
                        else
                            allDone = false
                        end
                    end
                    -- Most first-craft entries use a single quest; treat any completion as claimed
                    claimed = anyDone
                elseif entry.spellID and canCheckSpell then
                    local ok, stillFirst = pcall(C_TradeSkillUI.IsRecipeFirstCraft, entry.spellID)
                    if ok and stillFirst ~= nil then
                        -- stillFirst == true → bonus still available (not yet claimed)
                        char.firstCrafts[entry.spellID] = stillFirst and true or false
                        claimed = not stillFirst
                    elseif char.firstCrafts[entry.spellID] ~= nil then
                        -- Cached from a previous open of the profession
                        claimed = char.firstCrafts[entry.spellID] ~= true
                    end
                elseif entry.spellID and char.firstCrafts[entry.spellID] ~= nil then
                    claimed = char.firstCrafts[entry.spellID] ~= true
                end

                if claimed then
                    done = done + points
                else
                    available = available + points
                end
            end

            snap.firstCrafts = {
                done = done,
                total = total,
                available = available,
            }
        elseif snap then
            snap.firstCrafts = { done = 0, total = 0, available = 0 }
        end
    end
    char.lastUpdate = GetServerTime()
end

--- Treasure progress from guide data + quest flags (only for learned professions).
function addon:ScanTreasures()
    local char = self:GetCharacterSnapshot()
    if not char or not private.Data then return end

    for profName, snap in pairs(char.professions) do
        local profData = private.Data[profName]
        if type(profData) == "table" and type(profData.treasures) == "table" then
            local treasures = profData.treasures
            local total = #treasures
            local collected = 0
            for _, t in ipairs(treasures) do
                if t.questID and IsQuestComplete(t.questID) then
                    collected = collected + 1
                    char.completedQuests[t.questID] = true
                end
            end
            snap.treasures = { collected = collected, total = total }
        end
    end
    char.lastUpdate = GetServerTime()
end

--- Weekly sources from ProgressMeta quest flags (same IDs as WeeklyKnowledge).
--- notebook = trainer/consortium weekly quest
--- zoneDrops = weekly treasure-drop KP items
--- treatise / darkmoon = single quest flags
--- patron progress remains currency-driven (ScanCurrencies catch-up tracker)
function addon:ScanWeeklySources()
    local char = self:GetCharacterSnapshot()
    if not char then return end

    local metaTable = private.ProgressMeta
    if not metaTable or not metaTable.professions then return end

    local function countCompleted(questList)
        local doneCount, total = 0, 0
        if type(questList) ~= "table" then return 0, 0 end
        for _, qid in ipairs(questList) do
            total = total + 1
            if IsQuestComplete(qid) then
                doneCount = doneCount + 1
                char.completedQuests[qid] = true
            end
        end
        return doneCount, total
    end

    for profName, meta in pairs(metaTable.professions) do
        local snap = char.professions[profName]
        if snap then
            snap.weekly = snap.weekly or EmptyProfessionSnapshot(profName).weekly

            -- Weekly Quest (notebook) — limit means "any N of these IDs"
            local wq = meta.weeklyQuestIDs
            if type(wq) == "table" and #wq > 0 then
                local doneCount, total = countCompleted(wq)
                local limit = meta.weeklyQuestLimit or total
                local needed = math.min(limit, total)
                local w = snap.weekly.notebook
                w.done = doneCount >= needed and needed > 0
                w.progress = math.min(doneCount, needed)
                w.max = needed
            end

            -- Weekly zone treasure drops (WK "Treasure" category)
            local zd = meta.zoneDropQuests
            if type(zd) == "table" and #zd > 0 then
                local doneCount, total = countCompleted(zd)
                local w = snap.weekly.zoneDrops
                w.progress = doneCount
                w.max = total
                w.done = total > 0 and doneCount >= total
            end

            -- Treatise (weekly, single quest flag)
            if meta.treatiseQuestID and meta.treatiseQuestID > 0 then
                local done = IsQuestComplete(meta.treatiseQuestID)
                if done then char.completedQuests[meta.treatiseQuestID] = true end
                snap.weekly.treatise.done = done
            end

            -- Darkmoon Faire profession quest (monthly, single flag)
            if meta.darkmoonQuestID and meta.darkmoonQuestID > 0 then
                local done = IsQuestComplete(meta.darkmoonQuestID)
                if done then char.completedQuests[meta.darkmoonQuestID] = true end
                snap.weekly.darkmoon.done = done
            end
        end
    end
    char.lastUpdate = GetServerTime()
end

--- Full refresh for the logged-in character. Safe to call often.
function addon:ScanCurrentCharacter()
    if InCombatLockdown and InCombatLockdown() then return end
    self:EnsureProgressDB()
    self:ScanCharacterInfo()
    self:ScanProfessionSkills()
    self:ScanCurrencies()
    self:ScanCatchUpItems()
    self:ScanGathering()
    self:ScanTreasures()
    self:ScanWeeklySources()
    self:ScanFirstCrafts()
    private:Print("Progress snapshot updated for", UnitName("player") or "?")
end

-- ============================================================
-- EVENT HANDLING
-- ============================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonName then
        addon:InitDB()
        addon:EnsureProgressDB()
        addon:OnInitialize()
    elseif event == "PLAYER_LOGIN" then
        addon:OnEnable()
        addon:TaskWeeklyReset()
        addon:ScanCurrentCharacter()
    elseif event == "PLAYER_ENTERING_WORLD" then
        local isLogin, isReload = ...
        if (isLogin or isReload) and private.DataLoader then
            private.DataLoader:Load()
        end
        if isLogin or isReload then
            addon:ScanCurrentCharacter()
        end
    end
end)

-- ============================================================
-- LIFECYCLE FUNCTIONS
-- ============================================================
function addon:OnInitialize()
    -- Modules attach Build* methods when their files load (after Core in .toc).
    -- Call their Initialize hooks if present.
    for _, mod in ipairs({
        private.DataLoader,
        private.Dashboard,
        private.Leveling,
        private.Specializations,
        private.Knowledge,
        private.Progress,
        private.Recipes,
        private.Debug,
    }) do
        if mod and mod.Initialize then
            mod:Initialize()
        end
    end
    private:Print("OnInitialize completed")
end

function addon:OnEnable()
    self:CreateMinimapButton()

    -- Slash commands
    SLASH_ARTISANSCODEX1 = "/ac"
    SLASH_ARTISANSCODEX2 = "/codex"
    SLASH_ARTISANSCODEX3 = "/artisanscodex"
    SlashCmdList["ARTISANSCODEX"] = function(msg)
        addon:SlashCommand(msg)
    end

    -- Sanity-check that tab modules attached their builders
    local missing = {}
    for _, name in ipairs({ "BuildDashboard", "BuildLeveling", "BuildSpecializations", "BuildKnowledge", "BuildRecipes" }) do
        if type(self[name]) ~= "function" then
            missing[#missing + 1] = name
        end
    end
    if #missing > 0 then
        private:Print("|cffff4444ERROR:|r Tab modules missing:", table.concat(missing, ", "))
        private:Print("Expected files under |cffffff00Modules/|r — see ArtisansCodex.toc")
    else
        private:Print("Tab modules OK (Dashboard, Leveling, Specs, Knowledge, Recipes)")
    end

    private:Print("Addon enabled. Type |cffffff00/ac|r to open.")
end

-- ============================================================
-- SLASH COMMANDS
-- ============================================================
function addon:SlashCommand(input)
    input = strtrim(strlower(input or ""))

    if input == "" or input == "open" or input == "show" then
        self:ToggleMainFrame()
    elseif input == "progress" or input == "cards" then
        if private.Progress and private.Progress.Toggle then
            private.Progress:Toggle()
        else
            private:Print("Progress module not loaded.")
        end
    elseif input == "debug" then
        if private.Debug and private.Debug.Toggle then
            private.Debug:Toggle()
        else
            self.db.debug = not self.db.debug
            private.debug = self.db.debug
            private:Print("Debug mode:", self.db.debug and "|cff00ff00ON|r" or "|cffff0000OFF|r")
        end
    elseif input == "debug chat" or input == "debug toggle" then
        self.db.debug = not self.db.debug
        private.debug = self.db.debug
        private:Print("Chat debug mirror:", self.db.debug and "|cff00ff00ON|r" or "|cffff0000OFF|r")
    elseif input == "reset" or input == "reset all" then
        ArtisansCodexDB = nil
        ReloadUI()
    elseif input == "reset progress" then
        -- Wipe multi-character progress cache (first-craft flags, weekly snaps, etc.)
        self:EnsureProgressDB()
        self.db.progress.characters = {}
        self.db.progress.tracked = {}
        self.db.progress.weeklyReset = 0
        private:Print("Progress cache cleared. Rescanning this character…")
        self:ScanCurrentCharacter()
        if private.Progress and private.Progress.frame and private.Progress.frame:IsShown() then
            private.Progress:Refresh()
        end
        private:Print("Open each profession once so knowledge trees and first-crafts refresh.")
    elseif input == "scan" then
        self:ScanCurrentCharacter()
        if private.Progress and private.Progress.frame and private.Progress.frame:IsShown() then
            private.Progress:Refresh()
        end
    else
        print("|cff00ccffArtisan's Codex|r commands:")
        print("  |cffffff00/ac|r               - Open/Close main window")
        print("  |cffffff00/ac progress|r      - Account progress heatmap")
        print("  |cffffff00/ac scan|r          - Rescan this character's progress")
        print("  |cffffff00/ac debug|r         - Open debug panel (log + recipe audit)")
        print("  |cffffff00/ac debug chat|r    - Toggle chat debug messages")
        print("  |cffffff00/ac reset progress|r - Clear progress cache (keeps other settings)")
        print("  |cffffff00/ac reset|r         - Reset ALL settings + reload")
    end
end

-- ============================================================
-- MAIN WINDOW
-- ============================================================
function addon:ToggleMainFrame()
    if not self.mainFrame then
        self:CreateMainFrame()
    end

    if self.mainFrame:IsShown() then
        self.mainFrame:Hide()
    else
        self.mainFrame:Show()
    end
end

-- ============================================================
-- MAIN WINDOW + TABS
-- ============================================================
function addon:CreateMainFrame()
    local frame = CreateFrame("Frame", "ArtisansCodexMainFrame", UIParent, "BackdropTemplate")
    frame:SetSize(1000, 680)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetFrameStrata("HIGH")
    frame:SetToplevel(true)
    frame:SetClampedToScreen(true)

    -- Background
    frame:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets   = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    frame:SetBackdropColor(0.06, 0.07, 0.12, 0.97)
    frame:SetBackdropBorderColor(0.75, 0.60, 0.20, 1)

    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -14)
    title:SetText("|cffFFD700Artisan's Codex|r  |cff888888Midnight|r")
    frame.title = title

    -- Close button
    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -4, -4)

    -- Debug panel (log + recipe audit)
    local debugBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    debugBtn:SetSize(56, 22)
    debugBtn:SetPoint("TOPRIGHT", close, "TOPLEFT", -6, -6)
    debugBtn:SetText("Debug")
    debugBtn:SetScript("OnClick", function()
        if private.Debug and private.Debug.Toggle then
            private.Debug:Toggle()
        else
            private:Print("Debug module not loaded.")
        end
    end)
    debugBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("Debug", 1, 0.85, 0.2)
        GameTooltip:AddLine("Log console and live profession recipe audit.", 0.8, 0.8, 0.8, true)
        GameTooltip:AddLine("Also: /ac debug", 0.55, 0.55, 0.55)
        GameTooltip:Show()
    end)
    debugBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    frame.debugBtn = debugBtn

    -- Artisan's Progress (account heatmap) — related to all profession tabs
    local progressBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    progressBtn:SetSize(130, 22)
    progressBtn:SetPoint("TOPRIGHT", debugBtn, "TOPLEFT", -6, 0)
    progressBtn:SetText("Artisan's Progress")
    progressBtn:SetScript("OnClick", function()
        if private.Progress and private.Progress.Toggle then
            private.Progress:Toggle()
        end
    end)
    progressBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("Artisan's Progress", 1, 0.85, 0.2)
        GameTooltip:AddLine("Account-wide profession heatmap for all characters.", 0.8, 0.8, 0.8, true)
        GameTooltip:AddLine("Data from this scan also feeds meters on Leveling & Knowledge.", 0.65, 0.65, 0.65, true)
        GameTooltip:Show()
    end)
    progressBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    frame.progressBtn = progressBtn

    -- ============================================================
    -- TAB BUTTONS
    -- ============================================================
    local tabNames = {
        { key = "dashboard",       text = "Dashboard" },
        { key = "leveling",        text = "Leveling" },
        { key = "specializations", text = "Specializations" },
        { key = "knowledge",       text = "Knowledge" },
        { key = "recipes",         text = "Recipes" },
    }

    frame.tabs = {}
    frame.tabContents = {}

    local tabWidth = 118
    local startX = 20

    for i, tabInfo in ipairs(tabNames) do
        local tab = CreateFrame("Button", nil, frame, "BackdropTemplate")
        tab:SetSize(tabWidth, 28)
        tab:SetPoint("TOPLEFT", startX + (i-1) * (tabWidth + 6), -48)

        tab:SetBackdrop({
            bgFile   = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 12,
            insets   = { left = 2, right = 2, top = 2, bottom = 2 }
        })

        local label = tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        label:SetPoint("CENTER")
        label:SetText(tabInfo.text)
        tab.label = label

        tab.key = tabInfo.key

        tab:SetScript("OnClick", function(btn)
            addon:SelectTab(btn.key)
        end)

        frame.tabs[tabInfo.key] = tab
    end

    -- ============================================================
    -- CONTENT AREA (where each tab will show its content)
    -- ============================================================
    local content = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    content:SetPoint("TOPLEFT", 20, -90)
    content:SetPoint("BOTTOMRIGHT", -20, 20)
    content:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    content:SetBackdropColor(0.09, 0.10, 0.16, 0.9)
    content:SetBackdropBorderColor(0.4, 0.35, 0.2, 0.8)
    frame.content = content

    -- Create empty content frames for each tab
    for _, tabInfo in ipairs(tabNames) do
        local page = CreateFrame("Frame", nil, content)
        page:SetAllPoints()
        page:Hide()
        frame.tabContents[tabInfo.key] = page
    end

    -- Temporary placeholder text for each tab
    local function AddPlaceholder(page, text)
        local label = page:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        label:SetPoint("CENTER")
        label:SetText(text)
        label:SetJustifyH("CENTER")
    end

    AddPlaceholder(frame.tabContents["dashboard"],
        "|cffFFD700Dashboard|r\n\nComing soon...\n\nThis will show smart recommendations")
    AddPlaceholder(frame.tabContents["leveling"],
        "|cffFFD700Leveling Guide|r\n\nComing soon...\n\nStep-by-step profession leveling")
    AddPlaceholder(frame.tabContents["specializations"],
        "|cffFFD700Specializations|r\n\nComing soon...\n\nInteractive talent trees + builds")
    AddPlaceholder(frame.tabContents["knowledge"],
        "|cffFFD700Knowledge & Treasures|r\n\nComing soon...\n\nTreasures + weekly knowledge tracking")
    AddPlaceholder(frame.tabContents["recipes"],
        "|cffFFD700Recipes|r\n\nComing soon...\n\nBrowse profession recipes")

    frame:Hide()
    self.mainFrame = frame

    -- Select first tab by default
    self:SelectTab("dashboard")

    private:Print("Main window with tabs created")
end

function addon:SelectTab(tabKey)
    local frame = self.mainFrame
    if not frame then return end

    -- Update tab appearance
    for key, tab in pairs(frame.tabs) do
        if key == tabKey then
            tab:SetBackdropColor(0.35, 0.28, 0.10, 1)
            tab:SetBackdropBorderColor(0.9, 0.75, 0.25, 1)
            tab.label:SetTextColor(1, 0.9, 0.5)
        else
            tab:SetBackdropColor(0.12, 0.13, 0.18, 1)
            tab:SetBackdropBorderColor(0.4, 0.35, 0.2, 0.8)
            tab.label:SetTextColor(0.7, 0.7, 0.7)
        end
    end

    -- Show correct page
    for key, page in pairs(frame.tabContents) do
        if key == tabKey then
            page:Show()
        else
            page:Hide()
        end
    end

    frame.selectedTab = tabKey

    -- Build content (methods are attached by Modules/*.lua on load)
    local builders = {
        dashboard       = "BuildDashboard",
        leveling        = "BuildLeveling",
        specializations = "BuildSpecializations",
        knowledge       = "BuildKnowledge",
        recipes         = "BuildRecipes",
    }
    local methodName = builders[tabKey]
    if methodName then
        local fn = self[methodName]
        if type(fn) == "function" then
            fn(self)
        else
            private:Print("|cffff4444ERROR:|r", methodName, "is missing.",
                "Modules did not load — check that Modules/ exists and matches ArtisansCodex.toc")
        end
    end
end

-- ============================================================
-- MINIMAP BUTTON
-- ============================================================
function addon:CreateMinimapButton()
    if self.db.minimap.hide then return end

    local button = CreateFrame("Button", "ArtisansCodexMinimapButton", Minimap)
    button:SetSize(31, 31)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local overlay = button:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(53, 53)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    overlay:SetPoint("TOPLEFT")

    local background = button:CreateTexture(nil, "BACKGROUND")
    background:SetSize(20, 20)
    background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    background:SetPoint("TOPLEFT", 7, -5)

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    icon:SetPoint("TOPLEFT", 7, -6)

    -- Position on minimap
    local angle = 220
    local x = math.cos(math.rad(angle)) * 80
    local y = math.sin(math.rad(angle)) * 80
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)

    button:RegisterForClicks("AnyUp")
    button:SetScript("OnClick", function(_, mouseButton)
        if mouseButton == "RightButton" then
            if private.Debug and private.Debug.Toggle then
                private.Debug:Toggle()
            else
                private:Print("Debug module not loaded.")
            end
        else
            addon:ToggleMainFrame()
        end
    end)

    button:SetScript("OnEnter", function(btn)
        GameTooltip:SetOwner(btn, "ANCHOR_LEFT")
        GameTooltip:AddLine("|cffFFD700Artisan's Codex|r")
        GameTooltip:AddLine("Left-click: open main window", 1, 1, 1)
        GameTooltip:AddLine("Right-click: debug panel", 0.75, 0.85, 1)
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    self.minimapButton = button
end

-- ============================================================
-- SPEC REMINDER CARD
-- Small transient overlay shown after the user opens the spec
-- tree via a guide button. Auto-dismisses when the profession
-- window closes, or when the user clicks the close button.
-- ============================================================
function addon:ShowSpecReminder(targetName, targetIcon)
    if self.specReminder then
        self.specReminder:Hide()
        self.specReminder:SetParent(nil)
        self.specReminder = nil
    end

    local f = CreateFrame("Frame", "ArtisansCodexSpecReminder", UIParent, "BackdropTemplate")
    f:SetSize(300, 120)
    f:SetFrameStrata("DIALOG")
    f:SetToplevel(true)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)   -- temporary; re-anchored below
    f:Hide()

    f:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 14,
        insets   = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    f:SetBackdropColor(0.10, 0.11, 0.17, 0.97)
    f:SetBackdropBorderColor(0.90, 0.75, 0.25, 1)

    -- === Bolt icon (header badge) ===
    local bolt = f:CreateTexture(nil, "ARTWORK")
    bolt:SetSize(18, 18)
    bolt:SetPoint("TOPLEFT", 12, -10)
    bolt:SetTexture("Interface\\Icons\\spell_nature_lightning")
    bolt:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("LEFT", bolt, "RIGHT", 6, 0)
    title:SetText("|cffFFD700Artisan's Codex|r")

    -- === Sub-tree icon (large, next to the body text) ===
    local iconFrame = CreateFrame("Frame", nil, f, "BackdropTemplate")
    iconFrame:SetSize(48, 48)
    iconFrame:SetPoint("TOPLEFT", 14, -36)

    -- Border around the icon (thin gold ring)
    iconFrame:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 8,
        insets   = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    iconFrame:SetBackdropColor(0, 0, 0, 0.5)
    iconFrame:SetBackdropBorderColor(0.75, 0.60, 0.20, 1)

    local iconTex = iconFrame:CreateTexture(nil, "ARTWORK")
    iconTex:SetPoint("TOPLEFT", 3, -3)
    iconTex:SetPoint("BOTTOMRIGHT", -3, 3)
    iconTex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    iconTex:SetTexture(targetIcon or "Interface\\Icons\\INV_Misc_QuestionMark")

    -- === Body text (to the right of the icon) ===
    local body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT", iconFrame, "TOPRIGHT", 10, 0)
    body:SetPoint("TOPRIGHT", -14, -36)
    body:SetJustifyH("LEFT")
    body:SetText("Spend |cffFFD7005 KP|r on:\n|cffFFD700" .. (targetName or "the root node") .. "|r\n\n" ..
                 "|cff888888Look for the round icon in the center of the tree.|r")

    -- === Close button ===
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -4, -4)
    close:SetScript("OnClick", function() f:Hide() end)

    -- === Auto-dismiss on profession close ===
    f:RegisterEvent("TRADE_SKILL_CLOSE")
    f:SetScript("OnEvent", function(frame, event)
        if event == "TRADE_SKILL_CLOSE" then
            frame:Hide()
            frame:UnregisterAllEvents()
            if addon.specReminder == frame then
                addon.specReminder = nil
            end
        end
    end)

    -- === Deferred anchoring: wait for the profession frame, then snap next to it ===
    C_Timer.After(0.3, function()
        if not f or not f.SetPoint then return end
        f:ClearAllPoints()
        if _G.ProfessionsFrame and _G.ProfessionsFrame:IsShown() then
            f:SetPoint("TOPLEFT", _G.ProfessionsFrame, "TOPRIGHT", 10, -40)
        else
            f:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -40, -140)
        end
        f:Show()
    end)

    self.specReminder = f
end

-- Make the addon globally available
_G[addonName] = addon


-- ============================================================
-- PAGE HELPERS (used by tab modules)
-- ============================================================
function addon:ClearPage(page)
    if not page then return end
    for _, child in pairs({page:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
    for _, region in pairs({page:GetRegions()}) do
        if region.SetText then
            region:Hide()
        end
    end
end


-- ============================================================
-- SHARED PROFESSION SIDEBAR (used by Leveling / Knowledge / Specs)
-- ============================================================
local function SidebarGetProfessionNames(filter)
    local list = {}

    local function hasData(name, key)
        local data = private.Data and private.Data[name]
        return data and type(data[key]) == "table" and #data[key] > 0
    end

    local candidates = {}
    if private.DataLoader and private.DataLoader.GetAvailableProfessions then
        candidates = private.DataLoader:GetAvailableProfessions()
    else
        for name, data in pairs(private.Data or {}) do
            if type(data) == "table" and data.name then
                candidates[#candidates + 1] = name
            end
        end
        table.sort(candidates)
    end

    filter = filter or "all"

    for _, name in ipairs(candidates) do
        local include = false
        if filter == "all" then
            include = true
        elseif filter == "leveling" then
            include = hasData(name, "leveling")
        elseif filter == "treasures" then
            include = hasData(name, "treasures")
        elseif filter == "specializations" then
            local data = private.Data and private.Data[name]
            if data and not data.isGathering and name ~= "Cooking" and name ~= "Fishing" then
                include = true
            elseif hasData(name, "specializations") then
                include = true
            end
        else
            include = true
        end
        if include then
            list[#list + 1] = name
        end
    end

    if #list == 0 then
        list = { "Alchemy", "Tailoring" }
    end
    return list
end

function addon:BuildProfessionSidebar(parent, opts)
    opts = opts or {}
    local filter      = opts.filter or "all"
    local showLearned = (opts.showLearned ~= false)
    local width       = opts.width or 190
    local height      = opts.height or 540
    local onSelect    = opts.onSelect
    local selected    = opts.selected

    local available = SidebarGetProfessionNames(filter)

    local valid = false
    for _, name in ipairs(available) do
        if name == selected then valid = true; break end
    end
    if not valid then
        selected = available[1]
    end

    local leftPanel = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    leftPanel:SetPoint("TOPLEFT", 12, -12)
    leftPanel:SetSize(width, height)
    leftPanel:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    leftPanel:SetBackdropColor(0.08, 0.09, 0.14, 0.9)
    leftPanel:SetBackdropBorderColor(0.45, 0.38, 0.2, 0.9)

    local leftTitle = leftPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    leftTitle:SetPoint("TOP", 0, -12)
    leftTitle:SetText("|cffFFD700PROFESSIONS|r")

    local btnWidth = width - 20
    local btnHeight = 32
    local btnGap = 6
    local startY = -42

    for i, name in ipairs(available) do
        local btn = CreateFrame("Button", nil, leftPanel, "BackdropTemplate")
        btn:SetSize(btnWidth, btnHeight)
        btn:SetPoint("TOP", 0, startY - (i - 1) * (btnHeight + btnGap))

        btn:SetBackdrop({
            bgFile   = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 10,
            insets   = { left = 1, right = 1, top = 1, bottom = 1 }
        })

        local isSelected = (name == selected)
        local isLearned  = true
        if showLearned and self.IsProfessionLearned then
            isLearned = self:IsProfessionLearned(name)
        end

        if isSelected then
            btn:SetBackdropColor(0.35, 0.28, 0.10, 1)
            btn:SetBackdropBorderColor(0.9, 0.75, 0.25, 1)
        else
            btn:SetBackdropColor(0.12, 0.13, 0.19, 0.9)
            btn:SetBackdropBorderColor(0.35, 0.30, 0.18, 0.8)
        end

        -- Profession icon from base registry (Data/Midnight/Professions.lua)
        local iconPath
        if private.Professions and private.Professions.GetIcon then
            iconPath = private.Professions:GetIcon(name)
        end
        if not iconPath or iconPath == "" then
            iconPath = "Interface\\Icons\\INV_Misc_QuestionMark"
        end

        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetSize(20, 20)
        icon:SetPoint("LEFT", 8, 0)
        if iconPath then
            icon:SetTexture(iconPath)
            icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        else
            icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        end
        if showLearned and not isLearned then
            icon:SetDesaturated(true)
            icon:SetAlpha(0.55)
        end

        local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("LEFT", icon, "RIGHT", 8, (showLearned and not isLearned) and 5 or 0)
        text:SetPoint("RIGHT", -6, (showLearned and not isLearned) and 5 or 0)
        text:SetJustifyH("LEFT")
        text:SetText(name)
        if isSelected then
            text:SetTextColor(1, 0.9, 0.5)
        elseif showLearned and not isLearned then
            text:SetTextColor(0.6, 0.55, 0.55)
        end

        if showLearned and not isLearned then
            local tag = btn:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            tag:SetPoint("LEFT", icon, "RIGHT", 8, -8)
            tag:SetText("Not learned")
        end

        btn:SetScript("OnClick", function()
            if onSelect then
                onSelect(name)
            end
        end)
    end

    return selected, leftPanel
end

-- Tab UI is built by Modules/*:
--   Modules/Dashboard.lua      → addon:BuildDashboard()
--   Modules/Leveling.lua       → addon:BuildLeveling(), CollectAllMaterials, RenderShoppingListBody
--   Modules/Specializations.lua → addon:BuildSpecializations()
--   Modules/Knowledge.lua      → addon:BuildKnowledge()
--   Modules/Recipes.lua        → addon:BuildRecipes()
-- SelectTab() in this file still calls those methods; modules attach them on load.