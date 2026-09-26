-- ArtisansCodex — Artisan's Progress (account heatmap)
-- Account-wide heatmap: rows = character + profession, columns = status fields

local _, private = ...
local addon = private.addon

private.Progress = private.Progress or {}
local Progress = private.Progress

local CLASS_COLORS = RAID_CLASS_COLORS or {}

local COLS = {
    { key = "character",     label = "Character",      width = 100 },
    { key = "realm",         label = "Realm",          width = 80 },
    { key = "profession",    label = "Profession",     width = 90 },
    { key = "skill",         label = "Skill",          width = 70 },
    { key = "concentration", label = "Conc",           width = 72 },
    { key = "knowledge",     label = "Knowledge",      width = 80 },
    { key = "notebook",      label = "Weekly",         width = 58 },
    { key = "zoneDrops",     label = "Drops",          width = 52 },
    { key = "treatise",      label = "Treatise",       width = 58 },
    { key = "treasures",     label = "Treasures",      width = 64 },
    { key = "firstCrafts",   label = "First",          width = 52 },
    { key = "catchUp",       label = "Catch-up",       width = 64 },
    { key = "gathering",     label = "Gather",         width = 56 },
    { key = "moxie",         label = "Moxie",          width = 60 },
    { key = "darkmoon",      label = "Darkmoon",       width = 60 }, -- last; only if active
}

local function ClassColor(classFile)
    local c = classFile and CLASS_COLORS[classFile]
    if c then return c.r, c.g, c.b end
    return 1, 0.82, 0.2
end

--- Darkmoon Faire open this week? (best-effort calendar scan)
local function IsDarkmoonActive()
    if Progress._darkmoonCached ~= nil and Progress._darkmoonCachedAt and (GetTime() - Progress._darkmoonCachedAt) < 300 then
        return Progress._darkmoonCached
    end
    local active = false
    if C_Calendar and C_Calendar.GetNumDayEvents and C_DateAndTime and C_DateAndTime.GetCurrentCalendarTime then
        local now = C_DateAndTime.GetCurrentCalendarTime()
        local month = now.month
        local year = now.year
        -- scan a few days around today
        for day = math.max(1, (now.monthDay or 1) - 3), math.min(31, (now.monthDay or 1) + 7) do
            local n = C_Calendar.GetNumDayEvents(0, day) -- 0 = current month offset
            if type(n) == "number" then
                for i = 1, n do
                    local info = C_Calendar.GetDayEvent and C_Calendar.GetDayEvent(0, day, i)
                    local title = info and (info.title or info.Title or "") or ""
                    if type(title) == "string" and title:lower():find("darkmoon") then
                        active = true
                        break
                    end
                end
            end
            if active then break end
        end
    end
    Progress._darkmoonCached = active
    Progress._darkmoonCachedAt = GetTime()
    return active
end

--- Weekly-style bucket as 0/1 or progress/max (never "open"/"done" words)
local function WeeklyBucket(prof, key)
    local w = prof and prof.weekly and prof.weekly[key]
    if not w then return "0/1", 0.4, 0.4, 0.4, 0.07, 0.07, 0.09 end
    if w.progress ~= nil and w.max ~= nil and w.max > 0 then
        local label = string.format("%d/%d", w.progress or 0, w.max)
        if (w.progress or 0) >= w.max or w.done then
            return label, 0.3, 1, 0.4, 0.06, 0.14, 0.08
        end
        if (w.progress or 0) > 0 then
            return label, 1, 0.8, 0.3, 0.14, 0.12, 0.05
        end
        return label, 1, 0.45, 0.35, 0.14, 0.07, 0.06
    end
    -- binary quest-style
    if w.done then
        return "1/1", 0.3, 1, 0.4, 0.06, 0.14, 0.08
    end
    return "0/1", 1, 0.45, 0.35, 0.14, 0.07, 0.06
end

--- Returns text, r, g, b, bgR, bgG, bgB for a cell
local function CellValue(key, char, prof)
    if key == "character" then
        local live = char.guid == addon:GetPlayerGUID()
        local name = (char.name or "?") .. (live and " *" or "")
        local r, g, b = ClassColor(char.classFile)
        return name, r, g, b, 0.08, 0.09, 0.12
    end
    if key == "realm" then
        return char.realm or "-", 0.65, 0.65, 0.65, 0.08, 0.09, 0.12
    end
    if key == "profession" then
        return prof.name or "-", 1, 0.85, 0.3, 0.08, 0.09, 0.12
    end
    if key == "skill" then
        if not prof.skillLevel then return "-", 0.4, 0.4, 0.4, 0.07, 0.07, 0.09 end
        local t = string.format("%d/%d", prof.skillLevel, prof.skillMaxLevel or 0)
        local full = (prof.skillMaxLevel or 0) > 0 and prof.skillLevel >= prof.skillMaxLevel
        if full then return t, 0.3, 1, 0.4, 0.06, 0.14, 0.08 end
        return t, 1, 0.9, 0.4, 0.12, 0.11, 0.06
    end
    if key == "concentration" then
        local c = prof.concentration
        if not c or not c.maxQuantity or c.maxQuantity == 0 then
            return "-", 0.4, 0.4, 0.4, 0.07, 0.07, 0.09
        end
        local t = string.format("%d/%d", c.quantity or 0, c.maxQuantity)
        local ratio = (c.quantity or 0) / math.max(1, c.maxQuantity)
        if ratio >= 0.9 then return t, 0.3, 1, 0.4, 0.06, 0.14, 0.08 end
        if ratio >= 0.4 then return t, 1, 0.8, 0.3, 0.14, 0.12, 0.05 end
        return t, 1, 0.45, 0.35, 0.14, 0.07, 0.06
    end
    if key == "knowledge" then
        local k = prof.knowledge
        if not k then return "-", 0.4, 0.4, 0.4, 0.07, 0.07, 0.09 end
        local spent = k.spent or 0
        local maxK = k.max or 0
        local unspent = k.unspent or 0
        if maxK > 0 then
            local label = string.format("%d/%d", spent, maxK)
            if unspent > 0 then
                label = string.format("%d(%d)/%d", spent, unspent, maxK)
            end
            local ratio = spent / math.max(1, maxK)
            if ratio >= 0.95 then return label, 0.3, 1, 0.4, 0.06, 0.14, 0.08 end
            if ratio >= 0.4 then return label, 1, 0.85, 0.35, 0.12, 0.11, 0.06 end
            return label, 1, 0.7, 0.3, 0.12, 0.10, 0.05
        end
        if unspent > 0 then
            return tostring(unspent), 1, 0.85, 0.35, 0.12, 0.11, 0.06
        end
        return "-", 0.4, 0.4, 0.4, 0.07, 0.07, 0.09
    end
    if key == "notebook" then
        return WeeklyBucket(prof, "notebook")
    end
    if key == "zoneDrops" then
        return WeeklyBucket(prof, "zoneDrops")
    end
    if key == "treatise" then
        return WeeklyBucket(prof, "treatise")
    end
    if key == "darkmoon" then
        return WeeklyBucket(prof, "darkmoon")
    end
    if key == "treasures" then
        local t = prof.treasures
        if not t or not t.total or t.total == 0 then return "-", 0.4, 0.4, 0.4, 0.07, 0.07, 0.09 end
        local label = string.format("%d/%d", t.collected or 0, t.total)
        if (t.collected or 0) >= t.total then return label, 0.3, 1, 0.4, 0.06, 0.14, 0.08 end
        if (t.collected or 0) > 0 then return label, 1, 0.8, 0.3, 0.14, 0.12, 0.05 end
        return label, 1, 0.45, 0.35, 0.14, 0.07, 0.06
    end
    if key == "firstCrafts" then
        local f = prof.firstCrafts
        if not f or not f.total or f.total == 0 then return "-", 0.4, 0.4, 0.4, 0.07, 0.07, 0.09 end
        local label = string.format("%d/%d", f.done or 0, f.total)
        if (f.available or 0) == 0 and (f.total or 0) > 0 then return label, 0.3, 1, 0.4, 0.06, 0.14, 0.08 end
        if (f.done or 0) > 0 then return label, 1, 0.8, 0.3, 0.14, 0.12, 0.05 end
        return label, 1, 0.55, 0.3, 0.14, 0.09, 0.05
    end
    if key == "catchUp" then
        local c = prof.catchUp
        if not c then return "-", 0.4, 0.4, 0.4, 0.07, 0.07, 0.09 end
        if (c.maxQuantity or 0) > 0 then
            local label = string.format("%d/%d", c.quantity or 0, c.maxQuantity)
            if (c.quantity or 0) >= c.maxQuantity then return label, 0.3, 1, 0.4, 0.06, 0.14, 0.08 end
            if (c.quantity or 0) > 0 then return label, 1, 0.8, 0.3, 0.14, 0.12, 0.05 end
            return label, 1, 0.45, 0.35, 0.14, 0.07, 0.06
        end
        if (c.itemCount or 0) > 0 then return tostring(c.itemCount), 1, 0.85, 0.35, 0.12, 0.11, 0.06 end
        return "-", 0.4, 0.4, 0.4, 0.07, 0.07, 0.09
    end
    if key == "gathering" then
        local g = prof.gathering
        if not g or not g.max or g.max == 0 then return "-", 0.4, 0.4, 0.4, 0.07, 0.07, 0.09 end
        local label = string.format("%d/%d", g.progress or 0, g.max)
        if g.done then return label, 0.3, 1, 0.4, 0.06, 0.14, 0.08 end
        if (g.progress or 0) > 0 then return label, 1, 0.8, 0.3, 0.14, 0.12, 0.05 end
        return label, 1, 0.45, 0.35, 0.14, 0.07, 0.06
    end
    if key == "moxie" then
        local m = prof.moxie
        if not m then return "-", 0.4, 0.4, 0.4, 0.07, 0.07, 0.09 end
        local qty = m.quantity or 0
        if qty <= 0 then return "0", 0.5, 0.5, 0.5, 0.07, 0.07, 0.09 end
        if qty >= 200 then return tostring(qty), 0.3, 1, 0.4, 0.06, 0.14, 0.08 end
        if qty >= 75 then return tostring(qty), 1, 0.85, 0.35, 0.12, 0.11, 0.06 end
        return tostring(qty), 1, 0.75, 0.3, 0.12, 0.10, 0.05
    end
    return "-", 0.4, 0.4, 0.4, 0.07, 0.07, 0.09
end


--- Rich tooltip body for a heatmap cell
local function CellTooltip(key, char, prof)
    local lines = {}
    local title = nil
    local live = char and char.guid == addon:GetPlayerGUID()

    local function add(text, r, g, b)
        lines[#lines + 1] = { text = text, r = r or 0.85, g = g or 0.85, b = b or 0.85 }
    end

    if key == "character" then
        title = (char.name or "?") .. (live and " (this character)" or "")
        add("Realm: " .. (char.realm or "?"))
        if char.level and char.level > 0 then add("Level " .. tostring(char.level)) end
        if char.lastUpdate and char.lastUpdate > 0 then
            add("Last scan: " .. date("%Y-%m-%d %H:%M", char.lastUpdate), 0.6, 0.6, 0.6)
        end
        return title, lines
    end
    if key == "realm" then
        return char.realm or "Realm", { { text = "Character realm", r = 0.7, g = 0.7, b = 0.7 } }
    end
    if key == "profession" then
        title = prof.name or "Profession"
        if prof.skillLevel then
            add(string.format("Skill %d / %d", prof.skillLevel or 0, prof.skillMaxLevel or 0))
        end
        return title, lines
    end
    if key == "skill" then
        title = "Profession skill"
        add(string.format("%d / %d", prof.skillLevel or 0, prof.skillMaxLevel or 0))
        return title, lines
    end
    if key == "concentration" then
        title = "Concentration"
        local c = prof.concentration
        if not c or not c.maxQuantity or c.maxQuantity == 0 then
            add("Not available for this profession", 0.6, 0.6, 0.6)
        else
            add(string.format("%d / %d", c.quantity or 0, c.maxQuantity))
            add("Recharges over time while logged in.", 0.6, 0.6, 0.6)
        end
        return title, lines
    end
    if key == "knowledge" then
        title = "Specialization knowledge"
        local k = prof.knowledge
        if not k then
            add("Open the profession once to scan the talent trees.", 0.6, 0.6, 0.6)
        else
            add(string.format("Spent: %d", k.spent or 0))
            add(string.format("Unspent: %d", k.unspent or 0))
            add(string.format("Max: %d", k.max or 0))
            if (k.max or 0) == 0 then
                add("Open profession specialization trees to load max KP.", 1, 0.75, 0.3)
            end
        end
        return title, lines
    end
    if key == "notebook" then
        title = "Weekly profession quest"
        local w = prof.weekly and prof.weekly.notebook
        if w and w.max and w.max > 0 then
            add(string.format("%d / %d completed", w.progress or 0, w.max))
        else
            add(w and w.done and "Completed this week" or "Not completed this week")
        end
        add("Trainer or Artisan's Consortium weekly quest.", 0.6, 0.6, 0.6)
        return title, lines
    end
    if key == "zoneDrops" then
        title = "Weekly zone / treasure drops"
        local w = prof.weekly and prof.weekly.zoneDrops
        if w and w.max and w.max > 0 then
            add(string.format("%d / %d this week", w.progress or 0, w.max))
        else
            add("No weekly drop tracker for this profession", 0.6, 0.6, 0.6)
        end
        add("Random KP items from treasures (weekly).", 0.6, 0.6, 0.6)
        return title, lines
    end
    if key == "treatise" then
        title = "Thalassian Treatise"
        local w = prof.weekly and prof.weekly.treatise
        add(w and w.done and "Used this week" or "Not used this week")
        add("Crafted via Inscription or public order. +1 KP weekly.", 0.6, 0.6, 0.6)
        return title, lines
    end
    if key == "darkmoon" then
        title = "Darkmoon Faire profession quest"
        local w = prof.weekly and prof.weekly.darkmoon
        add(w and w.done and "Completed this Faire" or "Not completed")
        add("Monthly when Darkmoon Faire is active.", 0.6, 0.6, 0.6)
        return title, lines
    end
    if key == "treasures" then
        title = "One-time knowledge treasures"
        local t = prof.treasures
        if not t or not t.total or t.total == 0 then
            add("No treasure data for this profession", 0.6, 0.6, 0.6)
        else
            add(string.format("%d / %d collected", t.collected or 0, t.total))
            add("Map treasures from the Knowledge guide.", 0.6, 0.6, 0.6)
        end
        return title, lines
    end
    if key == "firstCrafts" then
        title = "First-craft knowledge"
        local f = prof.firstCrafts
        if not f or not f.total or f.total == 0 then
            add("No first-craft catalog (or open the profession to scan).", 0.6, 0.6, 0.6)
        else
            add(string.format("Claimed: %d", f.done or 0))
            add(string.format("Remaining: %d", f.available or 0))
            add(string.format("Total in catalog: %d", f.total or 0))
            add("Open the profession once so recipe first-craft flags can update.", 0.6, 0.6, 0.6)
        end
        return title, lines
    end
    if key == "catchUp" then
        title = "Catch-up knowledge"
        local c = prof.catchUp
        if not c then
            add("No catch-up tracker", 0.6, 0.6, 0.6)
        elseif (c.maxQuantity or 0) > 0 then
            add(string.format("%d / %d earned toward catch-up cap", c.quantity or 0, c.maxQuantity))
            if (c.itemCount or 0) > 0 then
                add(string.format("Catch-up items in bags: %d", c.itemCount))
            end
        elseif (c.itemCount or 0) > 0 then
            add(string.format("Catch-up items in bags: %d", c.itemCount))
        else
            add("No catch-up progress yet", 0.6, 0.6, 0.6)
        end
        return title, lines
    end
    if key == "gathering" then
        title = "Weekly gathering / disenchant drops"
        local g = prof.gathering
        if not g or not g.max or g.max == 0 then
            add("Not a gathering-style source for this profession", 0.6, 0.6, 0.6)
        else
            add(string.format("%d / %d weekly drops flagged", g.progress or 0, g.max))
        end
        return title, lines
    end
    if key == "moxie" then
        title = "Artisan's Moxie"
        local m = prof.moxie
        add(string.format("%d on hand", m and m.quantity or 0))
        add("Spendable profession currency (discoveries / unlocks).", 0.6, 0.6, 0.6)
        return title, lines
    end
    return nil, lines
end

local HEADER_TIPS = {
    character = "Character name (* = currently logged in)",
    realm = "Realm",
    profession = "Learned profession",
    skill = "Profession skill level",
    concentration = "Concentration pool",
    knowledge = "Specialization KP spent (unspent) / max",
    notebook = "Weekly trainer / consortium quest",
    zoneDrops = "Weekly treasure-drop KP items",
    treatise = "Weekly treatise use",
    treasures = "One-time map knowledge treasures",
    firstCrafts = "First-craft KP from the Midnight recipe catalog",
    catchUp = "Catch-up KP currency progress",
    gathering = "Weekly gathering or disenchant drop flags",
    moxie = "Artisan's Moxie currency",
    darkmoon = "Darkmoon Faire profession quest",
}

local function ShowTip(owner, title, lines)
    GameTooltip:SetOwner(owner, "ANCHOR_CURSOR")
    if title then
        GameTooltip:AddLine(title, 1, 0.85, 0.2)
    end
    if lines then
        for _, line in ipairs(lines) do
            GameTooltip:AddLine(line.text, line.r, line.g, line.b, true)
        end
    end
    GameTooltip:Show()
end

local function VisibleCols()
    local out = {}
    local darkmoonOn = IsDarkmoonActive()
    for _, col in ipairs(COLS) do
        if col.key == "character" or col.key == "realm" or col.key == "profession" then
            out[#out + 1] = col
        elseif col.key == "darkmoon" then
            if darkmoonOn and addon:IsCardChipVisible("darkmoon") then
                out[#out + 1] = col
            end
        elseif addon:IsCardChipVisible(col.key) then
            out[#out + 1] = col
        end
    end
    return out
end

function Progress:Initialize()
    private:Print("Progress module loaded")
    self:RegisterAutoRefresh()
end

function Progress:RegisterAutoRefresh()
    if self.eventFrame then return end
    local ef = CreateFrame("Frame")
    self.eventFrame = ef
    self._pending = false

    local function schedule()
        if self._pending then return end
        self._pending = true
        C_Timer.After(0.75, function()
            self._pending = false
            if InCombatLockdown and InCombatLockdown() then return end
            addon:ScanCurrentCharacter()
            if self.frame and self.frame:IsShown() then
                self:Refresh()
            end
            if self.charPanel and self.charPanel:IsShown() then
                self:RefreshCharPanel()
            end
        end)
    end

    local events = {
        "QUEST_TURNED_IN", "QUEST_COMPLETE", "QUEST_LOG_UPDATE",
        "CURRENCY_DISPLAY_UPDATE", "BAG_UPDATE_DELAYED",
        "SKILL_LINES_CHANGED", "TRADE_SKILL_SHOW", "TRADE_SKILL_LIST_UPDATE",
        "TRADE_SKILL_DETAILS_UPDATE", "NEW_RECIPE_LEARNED",
        "PLAYER_LEVEL_CHANGED", "TRAIT_CONFIG_UPDATED",
    }
    for _, e in ipairs(events) do
        pcall(function() ef:RegisterEvent(e) end)
    end
    ef:SetScript("OnEvent", function() schedule() end)
end

function Progress:Toggle()
    if not self.frame then
        self:CreateFrame()
    end
    if self.frame:IsShown() then
        self.frame:Hide()
        if self.charPanel then self.charPanel:Hide() end
        if self.colPanel then self.colPanel:Hide() end
    else
        addon:ScanCurrentCharacter()
        self.frame:Show()
        -- Layout after Show so scroll:GetWidth() is the real viewport
        self:Refresh()
    end
end

local BTN_SIZE = 26
local BTN_GAP = 4

--- Uniform square toolbar button (same size for Characters / Columns / Close)
local function MakeToolbarButton(parent, opts)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(BTN_SIZE, BTN_SIZE)

    local bg = btn:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.10, 0.11, 0.15, 0.95)
    btn.bg = bg

    local border = btn:CreateTexture(nil, "BORDER")
    border:SetPoint("TOPLEFT", 0, 0)
    border:SetPoint("BOTTOMRIGHT", 0, 0)
    border:SetColorTexture(0.45, 0.38, 0.18, 0.85)
    btn.border = border

    local inner = btn:CreateTexture(nil, "ARTWORK")
    inner:SetPoint("TOPLEFT", 1, -1)
    inner:SetPoint("BOTTOMRIGHT", -1, 1)
    inner:SetColorTexture(0.10, 0.11, 0.15, 1)
    btn.inner = inner

    if opts.texture then
        local icon = btn:CreateTexture(nil, "OVERLAY")
        icon:SetSize(16, 16)
        icon:SetPoint("CENTER")
        icon:SetTexture(opts.texture)
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        btn.icon = icon
    elseif opts.label then
        local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        fs:SetPoint("CENTER", 0, 1)
        fs:SetText(opts.label)
        fs:SetTextColor(0.95, 0.85, 0.45)
        btn.label = fs
    end

    btn:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(0.22, 0.20, 0.12, 1)
        self.inner:SetColorTexture(0.18, 0.16, 0.10, 1)
        self.border:SetColorTexture(0.85, 0.70, 0.25, 1)
        if opts.tooltipTitle then
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
            GameTooltip:AddLine(opts.tooltipTitle, 1, 0.85, 0.2)
            if opts.tooltipBody then
                GameTooltip:AddLine(opts.tooltipBody, 0.8, 0.8, 0.8, true)
            end
            GameTooltip:Show()
        end
    end)
    btn:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(0.10, 0.11, 0.15, 0.95)
        self.inner:SetColorTexture(0.10, 0.11, 0.15, 1)
        self.border:SetColorTexture(0.45, 0.38, 0.18, 0.85)
        GameTooltip:Hide()
    end)
    if opts.onClick then
        btn:SetScript("OnClick", opts.onClick)
    end
    return btn
end

-- Backwards-compatible wrapper used nowhere else after toolbar rewrite
local function MakeIconButton(parent, texture, tooltipTitle, tooltipBody, onClick)
    return MakeToolbarButton(parent, {
        texture = texture,
        tooltipTitle = tooltipTitle,
        tooltipBody = tooltipBody,
        onClick = onClick,
    })
end

function Progress:CreateFrame()
    if self.frame then return self.frame end

    local f = CreateFrame("Frame", "ArtisansCodexProgressFrame", UIParent, "BackdropTemplate")
    f:SetSize(1100, 500)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 14,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    f:SetBackdropColor(0.05, 0.06, 0.10, 0.97)
    f:SetBackdropBorderColor(0.75, 0.60, 0.20, 1)
    f:Hide()
    tinsert(UISpecialFrames, "ArtisansCodexProgressFrame")

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -14)
    title:SetText("|cffFFD700Artisan's Progress|r")
    f.title = title

    local subtitle = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
    subtitle:SetTextColor(0.65, 0.65, 0.65)
    f.subtitle = subtitle

    -- Top-right toolbar bar: equal-sized buttons, aligned with title row
    local toolbar = CreateFrame("Frame", nil, f)
    toolbar:SetSize(BTN_SIZE * 3 + BTN_GAP * 2, BTN_SIZE)
    toolbar:SetPoint("TOPRIGHT", -10, -12)
    f.toolbar = toolbar

    local close = MakeToolbarButton(toolbar, {
        label = "×",
        tooltipTitle = "Close",
        tooltipBody = "Close Artisan's Progress.",
        onClick = function()
            f:Hide()
            if Progress.charPanel then Progress.charPanel:Hide() end
            if Progress.colPanel then Progress.colPanel:Hide() end
        end,
    })
    close:SetPoint("RIGHT", toolbar, "RIGHT", 0, 0)
    if close.label then
        close.label:SetTextColor(0.95, 0.55, 0.45)
    end
    f.closeBtn = close

    local colBtn = MakeToolbarButton(toolbar, {
        texture = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
        tooltipTitle = "Columns",
        tooltipBody = "Show or hide heatmap columns.",
        onClick = function() Progress:ToggleColPanel() end,
    })
    colBtn:SetPoint("RIGHT", close, "LEFT", -BTN_GAP, 0)
    f.colBtn = colBtn

    local charBtn = MakeToolbarButton(toolbar, {
        texture = "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend",
        tooltipTitle = "Characters",
        tooltipBody = "Choose which characters appear in the heatmap.",
        onClick = function() Progress:ToggleCharPanel() end,
    })
    charBtn:SetPoint("RIGHT", colBtn, "LEFT", -BTN_GAP, 0)
    f.charBtn = charBtn

    -- Header row (fixed under title)
    local header = CreateFrame("Frame", nil, f)
    header:SetPoint("TOPLEFT", 12, -48)
    header:SetPoint("TOPRIGHT", -28, -48)
    header:SetHeight(22)
    f.header = header

    local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 12, -72)
    scroll:SetPoint("BOTTOMRIGHT", -28, 12)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1, 1)
    scroll:SetScrollChild(content)
    f.scroll = scroll
    f.content = content

    local legend = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    legend:SetPoint("BOTTOMLEFT", 16, 8)
    legend:SetTextColor(0.5, 0.5, 0.5)
    legend:SetText("|cff33ee66complete|r  ·  |cffffcc44in progress|r  ·  |cffff6644incomplete|r  ·  * live character")
    f.legend = legend
    -- leave room for legend
    scroll:SetPoint("BOTTOMRIGHT", -28, 24)

    self.frame = f
    return f
end

local function BuildRows()
    local characters = addon:GetTrackedCharacters()
    local rows = {}
    for _, char in ipairs(characters) do
        local profs = {}
        for name, snap in pairs(char.professions or {}) do
            profs[#profs + 1] = snap
        end
        table.sort(profs, function(a, b) return (a.name or "") < (b.name or "") end)
        for _, snap in ipairs(profs) do
            rows[#rows + 1] = { character = char, snap = snap }
        end
    end
    return rows, characters
end

function Progress:Refresh()
    local f = self:CreateFrame()
    local content = f.content
    local header = f.header

    for _, child in ipairs({ content:GetChildren() }) do
        child:Hide()
        child:SetParent(nil)
    end
    for _, region in ipairs({ content:GetRegions() }) do
        region:Hide()
    end
    for _, child in ipairs({ header:GetChildren() }) do
        child:Hide()
        child:SetParent(nil)
    end
    for _, region in ipairs({ header:GetRegions() }) do
        region:Hide()
    end

    local cols = VisibleCols()
    local rows, characters = BuildRows()
    local charCount = #characters
    f.subtitle:SetText(charCount == 0
        and "No characters cached yet."
        or (charCount .. " character" .. (charCount == 1 and "" or "s") .. " · " .. #rows .. " row" .. (#rows == 1 and "" or "s")))

    -- Viewport width: scroll frame minus vertical scrollbar (~20px)
    local scrollW = f.scroll:GetWidth() or 0
    local frameW = f:GetWidth() or 1020
    -- left pad 12 + right pad 28 (scrollbar gutter) already in anchors;
    -- GetWidth on the scroll frame still includes the bar track, so subtract it.
    local scrollbarW = 20
    local availW = scrollW - scrollbarW
    if availW < 200 then
        availW = frameW - 12 - 28 - scrollbarW
    end
    if availW < 200 then
        availW = 900
    end

    -- Preferred widths from COLS; scale down so visible columns fit availW exactly
    local preferred = 0
    for _, col in ipairs(cols) do
        preferred = preferred + (col.width or 60)
    end
    preferred = math.max(preferred, 1)

    local scale = availW / preferred
    local widths = {}
    local totalW = 0
    for i, col in ipairs(cols) do
        local w = math.floor((col.width or 60) * scale)
        if w < 36 then w = 36 end
        widths[i] = w
        totalW = totalW + w
    end

    -- If mins pushed us over, shrink proportionally until we fit
    if totalW > availW and totalW > 0 then
        local shrink = availW / totalW
        totalW = 0
        for i = 1, #widths do
            widths[i] = math.max(28, math.floor(widths[i] * shrink))
            totalW = totalW + widths[i]
        end
    end

    -- Absorb remaining pixels into the last column (never exceed availW)
    if #widths > 0 then
        local drift = availW - totalW
        widths[#widths] = math.max(28, widths[#widths] + drift)
        totalW = availW
    end

    -- Header cells (clipped to header width)
    header:SetWidth(availW)
    local hx = 0
    for i, col in ipairs(cols) do
        local w = widths[i]
        local cell = CreateFrame("Frame", nil, header, "BackdropTemplate")
        cell:SetSize(w, 20)
        cell:SetPoint("TOPLEFT", hx, 0)
        cell:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        cell:SetBackdropColor(0.12, 0.11, 0.08, 0.95)
        cell:SetBackdropBorderColor(0.45, 0.38, 0.18, 0.8)
        local fs = cell:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("LEFT", 2, 0)
        fs:SetPoint("RIGHT", -2, 0)
        fs:SetJustifyH("CENTER")
        fs:SetWordWrap(false)
        fs:SetText("|cffFFD700" .. col.label .. "|r")
        cell:EnableMouse(true)
        local colKey = col.key
        cell:SetScript("OnEnter", function(self)
            local tip = HEADER_TIPS[colKey]
            if tip then
                ShowTip(self, col.label, { { text = tip, r = 0.75, g = 0.75, b = 0.75 } })
            end
        end)
        cell:SetScript("OnLeave", function() GameTooltip:Hide() end)
        hx = hx + w
    end

    if #rows == 0 then
        local hint = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        hint:SetPoint("TOPLEFT", 8, -8)
        hint:SetWidth(math.max(availW - 16, 200))
        hint:SetJustifyH("LEFT")
        hint:SetTextColor(0.7, 0.7, 0.7)
        hint:SetText("Log each character with the addon enabled. Heatmap rows appear automatically.")
        content:SetSize(totalW, 60)
        return
    end

    local ROW_H = 22
    local y = 0
    for i, row in ipairs(rows) do
        local char, prof = row.character, row.snap
        local x = 0
        local rowBg = (i % 2 == 0) and 0.02 or 0

        for ci, col in ipairs(cols) do
            local w = widths[ci]
            local text, r, g, b, br, bg, bb = CellValue(col.key, char, prof)
            local cell = CreateFrame("Frame", nil, content, "BackdropTemplate")
            cell:SetSize(w, ROW_H)
            cell:SetPoint("TOPLEFT", x, y)
            cell:SetBackdrop({
                bgFile = "Interface\\Buttons\\WHITE8x8",
                edgeFile = "Interface\\Buttons\\WHITE8x8",
                edgeSize = 1,
            })
            cell:SetBackdropColor(br + rowBg, bg + rowBg, bb + rowBg, 0.95)
            cell:SetBackdropBorderColor(0.2, 0.2, 0.22, 0.6)

            local fs = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            fs:SetPoint("LEFT", 2, 0)
            fs:SetPoint("RIGHT", -2, 0)
            fs:SetJustifyH("CENTER")
            fs:SetWordWrap(false)
            fs:SetTextColor(r, g, b)
            fs:SetText(text)

            cell:EnableMouse(true)
            local tipKey, tipChar, tipProf = col.key, char, prof
            cell:SetScript("OnEnter", function(self)
                local title, lines = CellTooltip(tipKey, tipChar, tipProf)
                if title or (lines and #lines > 0) then
                    ShowTip(self, title, lines)
                end
            end)
            cell:SetScript("OnLeave", function() GameTooltip:Hide() end)

            x = x + w
        end
        y = y - ROW_H
    end

    content:SetSize(totalW, math.abs(y) + 8)
end

-- ============================================================
-- CHARACTERS PANEL
-- ============================================================
function Progress:ToggleCharPanel()
    if self.charPanel and self.charPanel:IsShown() then
        self.charPanel:Hide()
        return
    end
    self:CreateCharPanel()
    self:RefreshCharPanel()
    self.charPanel:Show()
    if self.colPanel then self.colPanel:Hide() end
end

function Progress:CreateCharPanel()
    if self.charPanel then return self.charPanel end

    local p = CreateFrame("Frame", "ArtisansCodexProgressCharPanel", UIParent, "BackdropTemplate")
    p:SetSize(220, 320)
    p:SetFrameStrata("DIALOG")
    p:SetFrameLevel(20)
    p:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    p:SetBackdropColor(0.06, 0.07, 0.11, 0.98)
    p:SetBackdropBorderColor(0.75, 0.60, 0.20, 1)
    p:SetMovable(true)
    p:EnableMouse(true)
    p:RegisterForDrag("LeftButton")
    p:SetScript("OnDragStart", p.StartMoving)
    p:SetScript("OnDragStop", p.StopMovingOrSizing)
    p:Hide()
    tinsert(UISpecialFrames, "ArtisansCodexProgressCharPanel")

    local title = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", 12, -12)
    title:SetText("|cffFFD700Characters|r")

    local close = CreateFrame("Button", nil, p, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -2, -2)
    close:SetScript("OnClick", function() p:Hide() end)

    local scroll = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 8, -32)
    scroll:SetPoint("BOTTOMRIGHT", -28, 10)
    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1, 1)
    scroll:SetScrollChild(content)
    p.content = content

    self.charPanel = p
    return p
end

function Progress:RefreshCharPanel()
    local p = self:CreateCharPanel()
    if self.frame and self.frame:IsShown() then
        p:ClearAllPoints()
        p:SetPoint("TOPLEFT", self.frame, "TOPRIGHT", 4, 0)
    else
        p:ClearAllPoints()
        p:SetPoint("CENTER")
    end

    local content = p.content
    for _, child in ipairs({ content:GetChildren() }) do
        child:Hide()
        child:SetParent(nil)
    end

    local progress = addon:EnsureProgressDB()
    local list = {}
    for _, char in pairs(progress.characters or {}) do
        list[#list + 1] = char
    end
    table.sort(list, function(a, b)
        return (a.name or "") < (b.name or "")
    end)

    local y = -2
    if #list == 0 then
        local fs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fs:SetPoint("TOPLEFT", 4, y)
        fs:SetWidth(170)
        fs:SetText("No characters saved yet.")
        content:SetSize(180, 40)
        return
    end

    for _, char in ipairs(list) do
        local guid = char.guid
        local row = CreateFrame("Button", nil, content)
        row:SetSize(175, 22)
        row:SetPoint("TOPLEFT", 2, y)

        local cb = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
        cb:SetSize(20, 20)
        cb:SetPoint("LEFT", 0, 0)
        cb:SetChecked(addon:IsCharacterTracked(guid))
        cb:SetScript("OnClick", function(self)
            addon:SetCharacterTracked(guid, self:GetChecked())
            Progress:Refresh()
        end)

        local cr, cg, cbCol = ClassColor(char.classFile)
        local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        label:SetPoint("LEFT", cb, "RIGHT", 4, 0)
        label:SetWidth(140)
        label:SetJustifyH("LEFT")
        label:SetText(string.format("|cff%02x%02x%02x%s|r |cff888888%s|r",
            cr * 255, cg * 255, cbCol * 255, char.name or "?", char.realm or ""))

        y = y - 24
    end
    content:SetSize(180, math.abs(y) + 8)
end

-- ============================================================
-- COLUMNS PANEL
-- ============================================================
function Progress:ToggleColPanel()
    if self.colPanel and self.colPanel:IsShown() then
        self.colPanel:Hide()
        return
    end
    self:CreateColPanel()
    self:RefreshColPanel()
    self.colPanel:Show()
    if self.charPanel then self.charPanel:Hide() end
end

function Progress:CreateColPanel()
    if self.colPanel then return self.colPanel end

    local p = CreateFrame("Frame", "ArtisansCodexProgressColPanel", UIParent, "BackdropTemplate")
    p:SetSize(200, 260)
    p:SetFrameStrata("DIALOG")
    p:SetFrameLevel(20)
    p:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    p:SetBackdropColor(0.06, 0.07, 0.11, 0.98)
    p:SetBackdropBorderColor(0.75, 0.60, 0.20, 1)
    p:SetMovable(true)
    p:EnableMouse(true)
    p:RegisterForDrag("LeftButton")
    p:SetScript("OnDragStart", p.StartMoving)
    p:SetScript("OnDragStop", p.StopMovingOrSizing)
    p:Hide()
    tinsert(UISpecialFrames, "ArtisansCodexProgressColPanel")

    local title = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", 12, -12)
    title:SetText("|cffFFD700Columns|r")

    local close = CreateFrame("Button", nil, p, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -2, -2)
    close:SetScript("OnClick", function() p:Hide() end)

    local content = CreateFrame("Frame", nil, p)
    content:SetPoint("TOPLEFT", 10, -34)
    content:SetPoint("BOTTOMRIGHT", -10, 10)
    p.content = content

    self.colPanel = p
    return p
end

function Progress:RefreshColPanel()
    local p = self:CreateColPanel()
    if self.frame and self.frame:IsShown() then
        p:ClearAllPoints()
        p:SetPoint("TOPLEFT", self.frame, "TOPRIGHT", 4, 0)
    else
        p:ClearAllPoints()
        p:SetPoint("CENTER")
    end

    local content = p.content
    for _, child in ipairs({ content:GetChildren() }) do
        child:Hide()
        child:SetParent(nil)
    end

    -- Only toggle metric columns (not Character / Realm / Profession)
    local y = 0
    for _, col in ipairs(COLS) do
        if col.key ~= "character" and col.key ~= "realm" and col.key ~= "profession" then
            local key = col.key
            local row = CreateFrame("Frame", nil, content)
            row:SetSize(170, 22)
            row:SetPoint("TOPLEFT", 0, y)

            local cb = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
            cb:SetSize(20, 20)
            cb:SetPoint("LEFT", 0, 0)
            cb:SetChecked(addon:IsCardChipVisible(key))
            cb:SetScript("OnClick", function(self)
                addon:SetCardChipVisible(key, self:GetChecked())
                Progress:Refresh()
            end)

            local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            label:SetPoint("LEFT", cb, "RIGHT", 4, 0)
            label:SetText(col.label)

            y = y - 24
        end
    end
end

private.Progress.Toggle = Progress.Toggle
private.Progress.Refresh = Progress.Refresh
private.Progress.ToggleCharPanel = Progress.ToggleCharPanel
private.Progress.ToggleColPanel = Progress.ToggleColPanel