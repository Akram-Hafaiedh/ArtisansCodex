-- ArtisansCodex Dashboard
-- Face of the addon: "What should I do right now?"
-- Layout: shared profession sidebar | hero + action chips | context rail
-- Data: live skill / KP / treasures / weekly — same sources as Progress & guide tabs

local _, private = ...
local addon = private.addon

private.Dashboard = private.Dashboard or {}
local Dashboard = private.Dashboard

function Dashboard:Initialize()
    private:Print("Dashboard module loaded")
end

-- ---------------------------------------------------------------------------
-- Data helpers (live only — no marketing numbers)
-- ---------------------------------------------------------------------------

local function QuestDone(questID)
    if not questID then return false end
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(questID)
    end
    return false
end

local function PinMap(mapID, x, y, label)
    if not mapID or not x or not y or not C_Map or not C_Map.SetUserWaypoint then
        return
    end
    C_Map.SetUserWaypoint({
        uiMapID = mapID,
        position = CreateVector2D(x / 100, y / 100),
    })
    if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    end
    if label and private.Print then
        private:Print("Pinned |cffFFD700" .. label .. "|r on the map.")
    end
end

local function GuideData(profName)
    return private.Data and private.Data[profName]
end

local function SpecGuide(profName)
    return private.SpecGuideData and private.SpecGuideData[profName]
end

local function GetKP(profName)
    if type(addon.GetProfessionKnowledgeTotals) == "function" then
        local ok, kp = pcall(addon.GetProfessionKnowledgeTotals, addon, profName)
        if ok and type(kp) == "table" then return kp end
    end
    return nil
end

local function GetSkill(profName)
    if type(addon.GetProfessionSnapshot) == "function" then
        local snap = addon:GetProfessionSnapshot(profName)
        if snap then
            return snap.skillLevel or 0, snap.skillMaxLevel or 0
        end
    end
    return 0, 0
end

local function CountTreasures(profName)
    if type(addon.GetProfessionSnapshot) == "function" then
        local snap = addon:GetProfessionSnapshot(profName)
        if snap and type(snap.treasures) == "table" and (snap.treasures.total or 0) > 0 then
            return snap.treasures.collected or 0, snap.treasures.total or 0
        end
    end
    local data = GuideData(profName)
    local list = data and data.treasures
    if type(list) ~= "table" then return 0, 0 end
    local total, collected = #list, 0
    for _, t in ipairs(list) do
        if t.questID and QuestDone(t.questID) then
            collected = collected + 1
        end
    end
    return collected, total
end

local function FirstMissingTreasure(profName)
    local data = GuideData(profName)
    local list = data and data.treasures
    if type(list) ~= "table" then return nil end
    local tDone, tTotal = CountTreasures(profName)
    if tTotal > 0 and tDone >= tTotal then return nil end
    for _, t in ipairs(list) do
        if not (t.questID and QuestDone(t.questID)) then
            return t
        end
    end
    return nil
end

local function NextLevelingStep(profName, skill)
    local data = GuideData(profName)
    local steps = data and data.leveling
    if type(steps) ~= "table" then return nil end
    skill = skill or 0
    for _, step in ipairs(steps) do
        if step.type == "fork" then
            -- skip path forks for hero
        else
            local range = step.range or ""
            local _, hi = range:match("(%d+)%s*%-%s*(%d+)")
            hi = tonumber(hi)
            if hi and skill < hi then
                return step
            end
            if not hi and step.recipe then
                return step
            end
        end
    end
    return nil
end

local function NextSpecStep(profName)
    local guide = SpecGuide(profName)
    if not guide or type(guide.builds) ~= "table" or #guide.builds == 0 then
        return nil, nil, 0, 0
    end
    local build = guide.builds[1]
    local key = addon.selectedSpecBuildKey
    if key then
        for _, b in ipairs(guide.builds) do
            if b.key == key then build = b break end
        end
    end
    if not build or type(build.steps) ~= "table" then return build, nil, 0, 0 end
    for _, step in ipairs(build.steps) do
        local target = step.points or 0
        local spent = 0
        if step.pathID and step.pathID > 0 and type(addon.GetPathProgress) == "function" then
            local prog = addon:GetPathProgress(profName, step.pathID)
            if prog then spent = prog.spent or 0 end
        end
        local done = (target > 0 and spent >= target) or (target == 0 and spent > 0)
        if not done then
            return build, step, spent, target
        end
    end
    return build, nil, 0, 0
end

local function WeeklyItems(profName)
    local items = {}
    local snap = type(addon.GetProfessionSnapshot) == "function" and addon:GetProfessionSnapshot(profName)
    local w = snap and snap.weekly
    local labels = {
        { key = "patron", name = "Patron orders" },
        { key = "notebook", name = "Trainer weekly" },
        { key = "zoneDrops", name = "Zone drops" },
        { key = "treatise", name = "Treatise" },
        { key = "darkmoon", name = "Darkmoon" },
    }
    if w then
        for _, L in ipairs(labels) do
            local cell = w[L.key]
            if cell then
                local done = cell.done and true or false
                local detail
                if cell.max and cell.max > 0 then
                    detail = string.format("%d/%d", cell.progress or 0, cell.max)
                    if not done then done = (cell.progress or 0) >= cell.max end
                end
                items[#items + 1] = { name = L.name, done = done, detail = detail }
            end
        end
    end
    if #items == 0 then
        local data = GuideData(profName)
        if data and type(data.weekly) == "table" then
            for _, src in ipairs(data.weekly) do
                local done = src.questID and QuestDone(src.questID) or false
                items[#items + 1] = {
                    name = src.name or "Weekly",
                    done = done,
                    detail = src.kp and ("+" .. tostring(src.kp)) or nil,
                }
            end
        end
    end
    return items
end

local function Jump(tab, prof)
    if tab == "leveling" then addon.selectedLevelingProf = prof
    elseif tab == "knowledge" then addon.selectedKnowledgeProf = prof
    elseif tab == "specializations" then
        addon.selectedSpecProf = prof
        addon.selectedSpecBuildKey = nil
    elseif tab == "recipes" then addon.selectedRecipesProf = prof
    end
    if type(addon.SelectTab) == "function" then addon:SelectTab(tab) end
end

local function PanelBG()
    return {
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    }
end

local function CardBG()
    return {
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    }
end

local function ProfessionIcon(name)
    if private.Professions and private.Professions.GetIcon then
        local icon = private.Professions:GetIcon(name)
        if icon and icon ~= "" then return icon end
    end
    return "Interface\\Icons\\INV_Misc_QuestionMark"
end

local function Truncate(str, maxLen)
    if not str then return "" end
    str = tostring(str)
    if #str <= maxLen then return str end
    return str:sub(1, maxLen - 1) .. "…"
end

--- Prefer a learned profession for first open; keep user choice after that.
local function ResolveDefaultProfession(current)
    -- Keep selection only if this character actually knows it
    if current and addon.IsProfessionLearned and addon:IsProfessionLearned(current) then
        return current
    end
    local names = {}
    if private.DataLoader and private.DataLoader.GetAvailableProfessions then
        names = private.DataLoader:GetAvailableProfessions() or {}
    elseif private.Professions and private.Professions.orderedNames then
        names = private.Professions.orderedNames
    end
    if addon.IsProfessionLearned then
        for _, name in ipairs(names) do
            if addon:IsProfessionLearned(name) then
                return name
            end
        end
    end
    if current then return current end
    return names[1]
end

-- ---------------------------------------------------------------------------
-- Rank next actions for hero + chips
-- ---------------------------------------------------------------------------

local function BuildActions(profName, skill, skillMax, kp)
    local actions = {}
    local unspent = kp and (kp.unspent or 0) or 0
    local maxed = skillMax > 0 and skill >= skillMax
    local build, specStep, specSpent, specTarget = NextSpecStep(profName)
    local missing = FirstMissingTreasure(profName)
    local tDone, tTotal = CountTreasures(profName)
    local nextLevel = (not maxed) and NextLevelingStep(profName, skill) or nil
    local weekly = WeeklyItems(profName)

    if unspent > 0 and specStep then
        actions[#actions + 1] = {
            priority = 100 + unspent,
            kind = "spec",
            title = "Spend knowledge points",
            detail = string.format(
                "%s · %s%s",
                (build and build.name) or "Recommended build",
                specStep.node or specStep.tree or "next path",
                (specTarget and specTarget > 0) and string.format(" · need +%d KP", specTarget) or ""
            ),
            cta = "View in specialization tree",
            tab = "specializations",
            icon = ProfessionIcon(profName),
        }
    elseif unspent > 0 then
        actions[#actions + 1] = {
            priority = 90 + unspent,
            kind = "spec",
            title = string.format("%d unspent knowledge points", unspent),
            detail = "Open Specializations for a recommended spend order.",
            cta = "View specializations",
            tab = "specializations",
            icon = ProfessionIcon(profName),
        }
    end

    if missing then
        actions[#actions + 1] = {
            priority = 80,
            kind = "treasure",
            title = missing.name or "Profession treasure",
            detail = string.format(
                "%s%s",
                missing.zone or "Unknown zone",
                (tTotal > 0) and string.format(" · %d remaining", tTotal - tDone) or ""
            ),
            cta = "Open knowledge",
            tab = "knowledge",
            icon = (missing.itemID and GetItemIcon and GetItemIcon(missing.itemID)) or ProfessionIcon(profName),
            pin = (missing.mapID and missing.x and missing.y) and missing or nil,
        }
    end

    if nextLevel then
        actions[#actions + 1] = {
            priority = 70,
            kind = "level",
            title = nextLevel.recipe or "Next leveling step",
            detail = string.format(
                "Skill %d / %d · range %s",
                skill, skillMax, nextLevel.range or "?"
            ),
            cta = "Open leveling guide",
            tab = "leveling",
            icon = ProfessionIcon(profName),
        }
    end

    local weeklyMissing = 0
    for _, w in ipairs(weekly) do
        if not w.done then weeklyMissing = weeklyMissing + 1 end
    end
    if weeklyMissing > 0 then
        actions[#actions + 1] = {
            priority = 60 + weeklyMissing,
            kind = "weekly",
            title = "Weekly knowledge sources",
            detail = string.format("%d still available this week", weeklyMissing),
            cta = "Open knowledge",
            tab = "knowledge",
            icon = ProfessionIcon(profName),
        }
    end

    table.sort(actions, function(a, b)
        if a.priority ~= b.priority then return a.priority > b.priority end
        return (a.title or "") < (b.title or "")
    end)
    return actions, weekly, tDone, tTotal, build, specStep
end

-- ---------------------------------------------------------------------------
-- UI
-- ---------------------------------------------------------------------------

function addon:BuildDashboard()
    local page = self.mainFrame and self.mainFrame.tabContents and self.mainFrame.tabContents["dashboard"]
    if not page then return end

    if type(self.ClearPage) == "function" then
        self:ClearPage(page)
    else
        for _, child in pairs({ page:GetChildren() }) do
            child:Hide()
            child:SetParent(nil)
        end
    end

    pcall(function()
        if self.ScanProfessionSkills then self:ScanProfessionSkills() end
        if self.ScanTreasures then self:ScanTreasures() end
        if self.ScanWeeklySources then self:ScanWeeklySources() end
    end)

    if type(self.BuildProfessionSidebar) ~= "function" then
        private:Print("|cffff4444ERROR:|r BuildProfessionSidebar missing.")
        return
    end

    -- First open: pick a learned profession (not Alchemy just because it is first in the list)
    self.selectedDashboardProf = ResolveDefaultProfession(self.selectedDashboardProf)

    self.selectedDashboardProf = self:BuildProfessionSidebar(page, {
        selected    = self.selectedDashboardProf,
        filter      = "all",
        showLearned = true,
        onSelect    = function(name)
            self.selectedDashboardProf = name
            self:BuildDashboard()
        end,
    })

    local profName = self.selectedDashboardProf
    if not profName then
        local msg = page:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        msg:SetPoint("CENTER", 80, 0)
        msg:SetTextColor(0.65, 0.65, 0.68)
        msg:SetText("No professions available.")
        return
    end

    local skill, skillMax = GetSkill(profName)
    local kp = GetKP(profName)
    local actions, weekly, tDone, tTotal = BuildActions(profName, skill, skillMax, kp)
    local hero = actions[1]
    local playerName = UnitName("player") or "You"

    -- Content origin (right of sidebar): 12 + 190 + 14 = 216
    local contentLeft = 216
    local railWidth = 200
    local gap = 12

    -- ========== RIGHT CONTEXT RAIL ==========
    local rail = CreateFrame("Frame", nil, page, "BackdropTemplate")
    rail:SetPoint("TOPRIGHT", -12, -12)
    rail:SetPoint("BOTTOMRIGHT", -12, 12)
    rail:SetWidth(railWidth)
    rail:SetBackdrop(PanelBG())
    rail:SetBackdropColor(0.07, 0.08, 0.12, 0.96)
    rail:SetBackdropBorderColor(0.42, 0.36, 0.20, 0.9)

    local ry = -14

    -- Character
    local who = rail:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    who:SetPoint("TOPLEFT", 12, ry)
    who:SetPoint("RIGHT", -12, 0)
    who:SetJustifyH("LEFT")
    who:SetText("|cffFFD700" .. playerName .. "|r")
    ry = ry - 18
    local whoSub = rail:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    whoSub:SetPoint("TOPLEFT", 12, ry)
    whoSub:SetText(profName)
    ry = ry - 28

    -- Knowledge points card
    local kpCard = CreateFrame("Frame", nil, rail, "BackdropTemplate")
    kpCard:SetPoint("TOPLEFT", 10, ry)
    kpCard:SetPoint("TOPRIGHT", -10, ry)
    kpCard:SetHeight(64)
    kpCard:SetBackdrop(CardBG())
    kpCard:SetBackdropColor(0.10, 0.11, 0.16, 0.95)
    kpCard:SetBackdropBorderColor(0.35, 0.30, 0.20, 0.85)

    local kpLbl = kpCard:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    kpLbl:SetPoint("TOPLEFT", 10, -8)
    kpLbl:SetText("KNOWLEDGE POINTS")

    local kpVal = kpCard:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    kpVal:SetPoint("TOPLEFT", 10, -26)
    if kp and (kp.max or 0) > 0 then
        local un = kp.unspent or 0
        if un > 0 then
            kpVal:SetText(string.format("|cffFFD700%d|r / %d", kp.spent or 0, kp.max or 0))
        else
            kpVal:SetText(string.format("%d / %d", kp.spent or 0, kp.max or 0))
        end
    else
        kpVal:SetText("|cff666666—|r")
    end

    local kpSub = kpCard:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    kpSub:SetPoint("TOPLEFT", 10, -46)
    if kp and (kp.unspent or 0) > 0 then
        kpSub:SetText(string.format("|cff66ccff%d ready to spend|r", kp.unspent))
    elseif kp and (kp.max or 0) > 0 then
        kpSub:SetText("|cff55cc77All spent|r")
    else
        kpSub:SetText("|cff666666Open profession once|r")
    end
    ry = ry - 76

    -- Missing treasures card
    local trCard = CreateFrame("Frame", nil, rail, "BackdropTemplate")
    trCard:SetPoint("TOPLEFT", 10, ry)
    trCard:SetPoint("TOPRIGHT", -10, ry)
    trCard:SetHeight(72)
    trCard:SetBackdrop(CardBG())
    trCard:SetBackdropColor(0.10, 0.11, 0.16, 0.95)
    trCard:SetBackdropBorderColor(0.35, 0.30, 0.20, 0.85)

    local trLbl = trCard:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    trLbl:SetPoint("TOPLEFT", 10, -8)
    trLbl:SetText("TREASURES")

    local trVal = trCard:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    trVal:SetPoint("TOPLEFT", 10, -26)
    if tTotal > 0 then
        local missingN = tTotal - tDone
        if missingN <= 0 then
            trVal:SetText("|cff55cc77Complete|r")
        else
            trVal:SetText(string.format("|cffFFD700%d|r missing", missingN))
        end
    else
        trVal:SetText("|cff666666—|r")
    end

    local trSub = trCard:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    trSub:SetPoint("TOPLEFT", 10, -48)
    if tTotal > 0 then
        trSub:SetText(string.format("%d / %d collected", tDone, tTotal))
    else
        trSub:SetText("No treasure data")
    end
    ry = ry - 84

    -- Weekly card
    local wkCard = CreateFrame("Frame", nil, rail, "BackdropTemplate")
    wkCard:SetPoint("TOPLEFT", 10, ry)
    wkCard:SetPoint("TOPRIGHT", -10, ry)
    wkCard:SetHeight(math.min(170, 28 + math.max(1, #weekly) * 16))
    wkCard:SetBackdrop(CardBG())
    wkCard:SetBackdropColor(0.10, 0.11, 0.16, 0.95)
    wkCard:SetBackdropBorderColor(0.35, 0.30, 0.20, 0.85)

    local wkLbl = wkCard:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    wkLbl:SetPoint("TOPLEFT", 10, -8)
    wkLbl:SetText("THIS WEEK")

    local wy = -24
    if #weekly == 0 then
        local none = wkCard:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        none:SetPoint("TOPLEFT", 10, wy)
        none:SetTextColor(0.55, 0.55, 0.58)
        none:SetText("No weekly data yet")
    else
        for _, item in ipairs(weekly) do
            local line = wkCard:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line:SetPoint("TOPLEFT", 10, wy)
            line:SetPoint("RIGHT", -10, 0)
            line:SetJustifyH("LEFT")
            line:SetWordWrap(false)
            local name = Truncate(item.name or "", 18)
            if item.done then
                line:SetText("|cff55cc77✓|r  " .. name)
            else
                local extra = item.detail and (" |cff888888" .. tostring(item.detail) .. "|r") or ""
                line:SetText("|cffFFD700•|r  " .. name .. extra)
            end
            wy = wy - 15
        end
    end
    ry = ry - (wkCard:GetHeight() or 80) - 12

    local railBtn = CreateFrame("Button", nil, rail, "UIPanelButtonTemplate")
    railBtn:SetSize(railWidth - 24, 24)
    railBtn:SetPoint("BOTTOM", 0, 14)
    railBtn:SetText("Knowledge tracker")
    railBtn:SetScript("OnClick", function() Jump("knowledge", profName) end)

    -- ========== CENTER COLUMN ==========
    local center = CreateFrame("Frame", nil, page)
    center:SetPoint("TOPLEFT", contentLeft, -12)
    center:SetPoint("BOTTOMRIGHT", rail, "BOTTOMLEFT", -gap, 0)

    -- Header line
    local head = center:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    head:SetPoint("TOPLEFT", 4, -4)
    head:SetText("SMART RECOMMENDATION")

    local question = center:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    question:SetPoint("TOPLEFT", 4, -22)
    question:SetText("|cffFFD700What should I do right now?|r")

    -- Hero card
    local heroCard = CreateFrame("Frame", nil, center, "BackdropTemplate")
    heroCard:SetPoint("TOPLEFT", 0, -50)
    heroCard:SetPoint("TOPRIGHT", 0, -50)
    heroCard:SetHeight(150)
    heroCard:SetBackdrop(PanelBG())
    if hero and hero.kind ~= "done" then
        heroCard:SetBackdropColor(0.12, 0.11, 0.07, 0.98)
        heroCard:SetBackdropBorderColor(0.92, 0.78, 0.28, 1)
    else
        heroCard:SetBackdropColor(0.08, 0.12, 0.10, 0.96)
        heroCard:SetBackdropBorderColor(0.30, 0.55, 0.35, 0.85)
    end

    if hero then
        local icon = heroCard:CreateTexture(nil, "ARTWORK")
        icon:SetSize(42, 42)
        icon:SetPoint("TOPLEFT", 18, -20)
        icon:SetTexture(hero.icon or ProfessionIcon(profName))
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        local badge = heroCard:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        badge:SetPoint("TOPLEFT", 72, -16)
        if hero.kind == "spec" then
            badge:SetText("|cff66ccffKNOWLEDGE|r")
        elseif hero.kind == "treasure" then
            badge:SetText("|cffFFD700TREASURE|r")
        elseif hero.kind == "level" then
            badge:SetText("|cff88cc66LEVELING|r")
        elseif hero.kind == "weekly" then
            badge:SetText("|cffccaa66WEEKLY|r")
        else
            badge:SetText("|cff55cc77UP TO DATE|r")
        end

        local hTitle = heroCard:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        hTitle:SetPoint("TOPLEFT", 72, -32)
        hTitle:SetPoint("RIGHT", -16, 0)
        hTitle:SetJustifyH("LEFT")
        hTitle:SetWordWrap(true)
        hTitle:SetNonSpaceWrap(false)
        hTitle:SetText(Truncate(hero.title or "", 56))
        hTitle:SetTextColor(1, 0.92, 0.55)

        local hDetail = heroCard:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        hDetail:SetPoint("TOPLEFT", 72, -62)
        hDetail:SetPoint("RIGHT", -16, 0)
        hDetail:SetJustifyH("LEFT")
        hDetail:SetWordWrap(true)
        hDetail:SetTextColor(0.72, 0.72, 0.70)
        hDetail:SetText(Truncate(hero.detail or "", 90))

        local btnX = -16
        local goBtn = CreateFrame("Button", nil, heroCard, "UIPanelButtonTemplate")
        goBtn:SetSize(168, 24)
        goBtn:SetPoint("BOTTOMRIGHT", btnX, 16)
        goBtn:SetText(hero.cta or "Open")
        goBtn:SetScript("OnClick", function()
            Jump(hero.tab, profName)
        end)

        if hero.pin then
            local pinBtn = CreateFrame("Button", nil, heroCard, "UIPanelButtonTemplate")
            pinBtn:SetSize(64, 24)
            pinBtn:SetPoint("RIGHT", goBtn, "LEFT", -8, 0)
            pinBtn:SetText("Pin")
            pinBtn:SetScript("OnClick", function()
                PinMap(hero.pin.mapID, hero.pin.x, hero.pin.y, hero.pin.name)
            end)
        end
    else
        local clear = heroCard:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        clear:SetPoint("TOPLEFT", 20, -28)
        clear:SetPoint("RIGHT", -20, 0)
        clear:SetJustifyH("LEFT")
        clear:SetText("|cff55cc77You're clear on " .. profName .. " for now|r")

        local clearSub = heroCard:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        clearSub:SetPoint("TOPLEFT", 20, -54)
        clearSub:SetPoint("RIGHT", -20, 0)
        clearSub:SetJustifyH("LEFT")
        clearSub:SetTextColor(0.68, 0.72, 0.68)
        clearSub:SetText("Skill, knowledge spends, and treasures look fine. Browse recipes or check another profession.")

        local recipesBtn = CreateFrame("Button", nil, heroCard, "UIPanelButtonTemplate")
        recipesBtn:SetSize(120, 24)
        recipesBtn:SetPoint("BOTTOMRIGHT", -16, 16)
        recipesBtn:SetText("Recipes")
        recipesBtn:SetScript("OnClick", function() Jump("recipes", profName) end)
    end

    -- Status line under hero
    local status = center:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    status:SetPoint("TOPLEFT", 4, -212)
    status:SetTextColor(0.60, 0.60, 0.62)
    local statusBits = {}
    if skillMax > 0 then
        statusBits[#statusBits + 1] = string.format("Skill %d/%d", skill, skillMax)
    end
    if kp and (kp.max or 0) > 0 then
        local un = kp.unspent or 0
        if un > 0 then
            statusBits[#statusBits + 1] = string.format("|cff66ccff%d KP ready|r", un)
        else
            statusBits[#statusBits + 1] = string.format("KP %d/%d", kp.spent or 0, kp.max or 0)
        end
    end
    if tTotal > 0 then
        statusBits[#statusBits + 1] = string.format("Treasures %d/%d", tDone, tTotal)
    end
    status:SetText(table.concat(statusBits, "   ·   "))

    -- Recommended next actions (chips)
    local chipTitle = center:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    chipTitle:SetPoint("TOPLEFT", 4, -240)
    chipTitle:SetText("RECOMMENDED NEXT ACTIONS")

    local chipY = -260
    local chipList = {}
    for i = 2, math.min(4, #actions) do
        chipList[#chipList + 1] = actions[i]
    end
    -- If hero was the only action, still show deep links
    if #chipList == 0 then
        chipList = {
            { title = "Leveling guide", detail = "Step-by-step crafts", tab = "leveling", kind = "level" },
            { title = "Specialization builds", detail = "Spend order & trees", tab = "specializations", kind = "spec" },
            { title = "Knowledge & treasures", detail = "Weekly & one-time KP", tab = "knowledge", kind = "treasure" },
            { title = "Recipe browser", detail = "Sources & reagents", tab = "recipes", kind = "other" },
        }
    end

    local chipW = 0
    C_Timer.After(0, function()
        -- width available for chips
    end)

    local chipsPerRow = 2
    for i, a in ipairs(chipList) do
        local col = (i - 1) % chipsPerRow
        local row = math.floor((i - 1) / chipsPerRow)
        local chip = CreateFrame("Button", nil, center, "BackdropTemplate")
        chip:SetHeight(56)
        chip:SetPoint("TOPLEFT", col == 0 and 0 or 8, chipY - row * 64)
        if col == 0 then
            chip:SetPoint("RIGHT", center, "CENTER", -6, 0)
        else
            chip:SetPoint("LEFT", center, "CENTER", 6, 0)
            chip:SetPoint("RIGHT", 0, 0)
        end
        -- Re-anchor properly without depending on CENTER split mid-build
        chip:ClearAllPoints()
        local top = chipY - row * 64
        if col == 0 then
            chip:SetPoint("TOPLEFT", 0, top)
            chip:SetPoint("TOPRIGHT", center, "TOP", -6, top)
        else
            chip:SetPoint("TOPLEFT", center, "TOP", 6, top)
            chip:SetPoint("TOPRIGHT", 0, top)
        end
        chip:SetBackdrop(CardBG())
        chip:SetBackdropColor(0.10, 0.11, 0.15, 0.95)
        chip:SetBackdropBorderColor(0.32, 0.28, 0.20, 0.9)

        local ct = chip:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        ct:SetPoint("TOPLEFT", 12, -10)
        ct:SetPoint("RIGHT", -10, 0)
        ct:SetJustifyH("LEFT")
        ct:SetText(Truncate(a.title or "", 28))
        ct:SetTextColor(1, 0.90, 0.55)

        local cd = chip:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        cd:SetPoint("TOPLEFT", 12, -30)
        cd:SetPoint("RIGHT", -10, 0)
        cd:SetJustifyH("LEFT")
        cd:SetText(Truncate(a.detail or a.cta or "", 36))

        chip:SetScript("OnEnter", function(b)
            b:SetBackdropBorderColor(0.90, 0.75, 0.30, 1)
            b:SetBackdropColor(0.14, 0.13, 0.10, 1)
        end)
        chip:SetScript("OnLeave", function(b)
            b:SetBackdropBorderColor(0.32, 0.28, 0.20, 0.9)
            b:SetBackdropColor(0.10, 0.11, 0.15, 0.95)
        end)
        chip:SetScript("OnClick", function()
            Jump(a.tab or "leveling", profName)
        end)
    end
end

if type(addon.BuildDashboard) == "function" then
    private.Dashboard.BuildDashboard = addon.BuildDashboard
    private:Print("Dashboard module file loaded (BuildDashboard ready)")
end