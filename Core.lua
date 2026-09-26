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
    local prof1, prof2 = GetProfessions()
    for _, idx in ipairs({ prof1, prof2 }) do
        if idx then
            local name, _, _, _, _, _, skillLine = GetProfessionInfo(idx)
            if name == professionName then
                return skillLine
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
-- EVENT HANDLING
-- ============================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonName then
        addon:InitDB()
        addon:OnInitialize()
    elseif event == "PLAYER_LOGIN" then
        addon:OnEnable()
    elseif event == "PLAYER_ENTERING_WORLD" then
        local isLogin, isReload = ...
        if (isLogin or isReload) and private.DataLoader then
            private.DataLoader:Load()
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
    for _, name in ipairs({ "BuildDashboard", "BuildLeveling", "BuildSpecializations", "BuildKnowledge" }) do
        if type(self[name]) ~= "function" then
            missing[#missing + 1] = name
        end
    end
    if #missing > 0 then
        private:Print("|cffff4444ERROR:|r Tab modules missing:", table.concat(missing, ", "))
        private:Print("Expected files under |cffffff00Modules/|r — see ArtisansCodex.toc")
    else
        private:Print("Tab modules OK (Dashboard, Leveling, Specs, Knowledge)")
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
    elseif input == "debug" then
        self.db.debug = not self.db.debug
        private.debug = self.db.debug
        private:Print("Debug mode:", self.db.debug and "|cff00ff00ON|r" or "|cffff0000OFF|r")
    elseif input == "reset" then
        ArtisansCodexDB = nil
        ReloadUI()
    else
        print("|cff00ccffArtisan's Codex|r commands:")
        print("  |cffffff00/ac|r         - Open/Close main window")
        print("  |cffffff00/ac debug|r   - Toggle debug messages")
        print("  |cffffff00/ac reset|r   - Reset all settings")
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

    -- ============================================================
    -- TAB BUTTONS
    -- ============================================================
    local tabNames = {
        { key = "dashboard",      text = "Dashboard" },
        { key = "leveling",       text = "Leveling" },
        { key = "specializations", text = "Specializations" },
        { key = "knowledge",      text = "Knowledge" },
    }

    frame.tabs = {}
    frame.tabContents = {}

    local tabWidth = 140
    local startX = 30

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

    button:SetScript("OnClick", function()
        addon:ToggleMainFrame()
    end)

    button:SetScript("OnEnter", function(btn)
        GameTooltip:SetOwner(btn, "ANCHOR_LEFT")
        GameTooltip:AddLine("|cffFFD700Artisan's Codex|r")
        GameTooltip:AddLine("Click to open", 1, 1, 1)
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

        local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("CENTER", 0, (showLearned and not isLearned) and 5 or 0)
        text:SetText(name)
        if isSelected then
            text:SetTextColor(1, 0.9, 0.5)
        elseif showLearned and not isLearned then
            text:SetTextColor(0.6, 0.55, 0.55)
        end

        if showLearned and not isLearned then
            local tag = btn:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            tag:SetPoint("TOP", text, "BOTTOM", 0, -2)
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
-- SelectTab() in this file still calls those methods; modules attach them on load.