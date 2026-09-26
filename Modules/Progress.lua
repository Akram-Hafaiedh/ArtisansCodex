-- ArtisansCodex Progress module
-- Account-wide heatmap: rows = character + profession, columns = status fields

local _, private = ...
local addon = private.addon

private.Progress = private.Progress or {}
local Progress = private.Progress

local CLASS_COLORS = RAID_CLASS_COLORS or {}

local COLS = {
    { key = "character",     label = "Character",      width = 110 },
    { key = "realm",         label = "Realm",          width = 90 },
    { key = "profession",    label = "Profession",     width = 100 },
    { key = "skill",         label = "Skill",          width = 70 },
    { key = "concentration", label = "Concentration",  width = 90 },
    { key = "knowledge",     label = "Knowledge",      width = 80 },
    { key = "notebook",      label = "Weekly Quest",   width = 80 },
    { key = "zoneDrops",     label = "Uniques",        width = 60 },
    { key = "treatise",      label = "Treatise",       width = 60 },
    { key = "treasures",     label = "Treasures",      width = 70 },
    { key = "firstCrafts",   label = "First Craft",    width = 70 },
    { key = "catchUp",       label = "Catch-up",       width = 70 },
    { key = "gathering",     label = "Gathering",      width = 70 },
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
        self:Refresh()
        self.frame:Show()
    end
end

local function MakeIconButton(parent, texture, tooltipTitle, tooltipBody, onClick)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(24, 24)
    local bg = btn:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.12, 0.13, 0.18, 0.95)
    btn.bg = bg
    local icon = btn:CreateTexture(nil, "ARTWORK")
    icon:SetSize(16, 16)
    icon:SetPoint("CENTER")
    icon:SetTexture(texture)
    btn:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(0.22, 0.20, 0.12, 1)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine(tooltipTitle, 1, 0.85, 0.2)
        if tooltipBody then GameTooltip:AddLine(tooltipBody, 0.8, 0.8, 0.8, true) end
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(0.12, 0.13, 0.18, 0.95)
        GameTooltip:Hide()
    end)
    btn:SetScript("OnClick", onClick)
    return btn
end

function Progress:CreateFrame()
    if self.frame then return self.frame end

    local f = CreateFrame("Frame", "ArtisansCodexProgressFrame", UIParent, "BackdropTemplate")
    f:SetSize(1020, 500)
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
    title:SetText("|cffFFD700Account Progress|r")
    f.title = title

    local subtitle = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
    subtitle:SetTextColor(0.65, 0.65, 0.65)
    f.subtitle = subtitle

    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -4, -4)
    close:SetScript("OnClick", function()
        f:Hide()
        if Progress.charPanel then Progress.charPanel:Hide() end
        if Progress.colPanel then Progress.colPanel:Hide() end
    end)

    local colBtn = MakeIconButton(
        f, "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
        "Columns", "Show or hide heatmap columns.",
        function() Progress:ToggleColPanel() end
    )
    colBtn:SetPoint("TOPRIGHT", close, "TOPLEFT", -6, -6)

    local charBtn = MakeIconButton(
        f, "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend",
        "Characters", "Choose which characters appear in the heatmap.",
        function() Progress:ToggleCharPanel() end
    )
    charBtn:SetPoint("TOPRIGHT", colBtn, "TOPLEFT", -6, 0)

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

    -- Column widths
    local totalW = 0
    for _, col in ipairs(cols) do
        totalW = totalW + col.width
    end

    -- Header cells
    local hx = 0
    for _, col in ipairs(cols) do
        local cell = CreateFrame("Frame", nil, header, "BackdropTemplate")
        cell:SetSize(col.width, 20)
        cell:SetPoint("TOPLEFT", hx, 0)
        cell:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        cell:SetBackdropColor(0.12, 0.11, 0.08, 0.95)
        cell:SetBackdropBorderColor(0.45, 0.38, 0.18, 0.8)
        local fs = cell:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("CENTER")
        fs:SetText("|cffFFD700" .. col.label .. "|r")
        hx = hx + col.width
    end

    if #rows == 0 then
        local hint = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        hint:SetPoint("TOPLEFT", 8, -8)
        hint:SetWidth(640)
        hint:SetJustifyH("LEFT")
        hint:SetTextColor(0.7, 0.7, 0.7)
        hint:SetText("Log each character with the addon enabled. Heatmap rows appear automatically.")
        content:SetSize(math.max(totalW, 660), 60)
        return
    end

    local ROW_H = 22
    local y = 0
    for i, row in ipairs(rows) do
        local char, prof = row.character, row.snap
        local x = 0
        local rowBg = (i % 2 == 0) and 0.02 or 0

        for _, col in ipairs(cols) do
            local text, r, g, b, br, bg, bb = CellValue(col.key, char, prof)
            local cell = CreateFrame("Frame", nil, content, "BackdropTemplate")
            cell:SetSize(col.width, ROW_H)
            cell:SetPoint("TOPLEFT", x, y)
            cell:SetBackdrop({
                bgFile = "Interface\\Buttons\\WHITE8x8",
                edgeFile = "Interface\\Buttons\\WHITE8x8",
                edgeSize = 1,
            })
            cell:SetBackdropColor(br + rowBg, bg + rowBg, bb + rowBg, 0.95)
            cell:SetBackdropBorderColor(0.2, 0.2, 0.22, 0.6)

            local fs = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            fs:SetPoint("CENTER")
            fs:SetTextColor(r, g, b)
            fs:SetText(text)

            x = x + col.width
        end
        y = y - ROW_H
    end

    content:SetSize(math.max(totalW, 100), math.abs(y) + 8)
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