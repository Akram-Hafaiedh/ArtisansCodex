-- Artisan's Codex - Core.lua
-- Main logic of the addon

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

        tab:SetScript("OnClick", function(self)
            addon:SelectTab(self.key)
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

    AddPlaceholder(frame.tabContents["dashboard"],      "|cffFFD700Dashboard|r\n\nComing soon...\n\nThis will show smart recommendations")
    AddPlaceholder(frame.tabContents["leveling"],       "|cffFFD700Leveling Guide|r\n\nComing soon...\n\nStep-by-step profession leveling")
    AddPlaceholder(frame.tabContents["specializations"], "|cffFFD700Specializations|r\n\nComing soon...\n\nInteractive talent trees + builds")
    AddPlaceholder(frame.tabContents["knowledge"],      "|cffFFD700Knowledge & Treasures|r\n\nComing soon...\n\nTreasures + weekly knowledge tracking")

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

    -- Build content
    if tabKey == "dashboard" then
        self:BuildDashboard()
    elseif tabKey == "leveling" then
        self:BuildLeveling()
    elseif tabKey == "specializations" then
        self:BuildSpecializations()
    elseif tabKey == "knowledge" then
        self:BuildKnowledge()
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

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
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
    f:SetScript("OnEvent", function(self, event)
        if event == "TRADE_SKILL_CLOSE" then
            self:Hide()
            self:UnregisterAllEvents()
            if addon.specReminder == self then
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
-- DASHBOARD CONTENT
-- ============================================================
function addon:BuildDashboard()
    local page = self.mainFrame.tabContents["dashboard"]
    if not page then return end

    -- Clear previous content if we rebuild
    for _, child in pairs({page:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
    for _, region in pairs({page:GetRegions()}) do
        if region.SetText then
            region:Hide()
        end
    end

    -- ----------------------------------------------------------
    -- LEFT SIDE - Profession List
    -- ----------------------------------------------------------
    local leftPanel = CreateFrame("Frame", nil, page, "BackdropTemplate")
    leftPanel:SetPoint("TOPLEFT", 15, -15)
    leftPanel:SetSize(210, 520)
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

    -- Temporary profession list (we will make this dynamic later)
    local professions = {
        { name = "Alchemy",       skill = "75 / 100",  kp = "14 KP" },
        { name = "Blacksmithing", skill = "62 / 100",  kp = "9 KP" },
        { name = "Enchanting",    skill = "58 / 100",  kp = "7 KP" },
        { name = "Engineering",   skill = "41 / 100",  kp = "5 KP" },
        { name = "Herbalism",     skill = "80 / 100",  kp = "11 KP" },
        { name = "Inscription",   skill = "39 / 100",  kp = "4 KP" },
        { name = "Jewelcrafting", skill = "66 / 100",  kp = "8 KP" },
        { name = "Leatherworking",skill = "53 / 100",  kp = "6 KP" },
        { name = "Mining",        skill = "71 / 100",  kp = "10 KP" },
        { name = "Tailoring",     skill = "47 / 100",  kp = "5 KP" },
    }

    for i, prof in ipairs(professions) do
        local row = CreateFrame("Button", nil, leftPanel, "BackdropTemplate")
        row:SetSize(190, 38)
        row:SetPoint("TOP", 0, -40 - (i-1) * 42)

        row:SetBackdrop({
            bgFile   = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 10,
            insets   = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        row:SetBackdropColor(0.12, 0.13, 0.19, 0.9)
        row:SetBackdropBorderColor(0.35, 0.30, 0.18, 0.8)

        local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameText:SetPoint("TOPLEFT", 10, -6)
        nameText:SetText(prof.name)

        local skillText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        skillText:SetPoint("BOTTOMLEFT", 10, 6)
        skillText:SetText(prof.skill .. "   " .. prof.kp)
        skillText:SetTextColor(0.7, 0.7, 0.7)
    end

    -- ----------------------------------------------------------
    -- CENTER - Recommendation Card
    -- ----------------------------------------------------------
    local centerCard = CreateFrame("Frame", nil, page, "BackdropTemplate")
    centerCard:SetPoint("TOPLEFT", 240, -15)
    centerCard:SetSize(480, 280)
    centerCard:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 14,
        insets   = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    centerCard:SetBackdropColor(0.10, 0.11, 0.18, 0.95)
    centerCard:SetBackdropBorderColor(0.85, 0.70, 0.25, 1)

    local cardTitle = centerCard:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    cardTitle:SetPoint("TOP", 0, -18)
    cardTitle:SetText("|cffFFD700What should I do right now?|r")

    local cardSubtitle = centerCard:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    cardSubtitle:SetPoint("TOP", 0, -42)
    cardSubtitle:SetText("Smart recommendation based on your goal")
    cardSubtitle:SetTextColor(0.75, 0.75, 0.75)

    -- Recommendation content
    local recTitle = centerCard:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    recTitle:SetPoint("TOPLEFT", 25, -90)
    recTitle:SetText("|cff00ccffAlchemy|r - Free Knowledge Available!")

    local recText = centerCard:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    recText:SetPoint("TOPLEFT", 25, -120)
    recText:SetWidth(430)
    recText:SetJustifyH("LEFT")
    recText:SetText("You have 14 unspent Knowledge Points in Alchemy.\n\nRecommended next node:\n|cffFFD700Elixir Experimentation|r\n\nThis node greatly improves potion and flask efficiency.")

    local viewTreeBtn = CreateFrame("Button", nil, centerCard, "UIPanelButtonTemplate")
    viewTreeBtn:SetSize(180, 28)
    viewTreeBtn:SetPoint("BOTTOM", 0, 25)
    viewTreeBtn:SetText("View in Alchemy Tree")
    viewTreeBtn:SetScript("OnClick", function()
        addon:SelectTab("specializations")
        -- Later we will also select Alchemy automatically
    end)

    -- ----------------------------------------------------------
    -- RIGHT SIDE - Stats
    -- ----------------------------------------------------------
    local rightPanel = CreateFrame("Frame", nil, page, "BackdropTemplate")
    rightPanel:SetPoint("TOPRIGHT", -15, -15)
    rightPanel:SetSize(220, 280)
    rightPanel:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    rightPanel:SetBackdropColor(0.08, 0.09, 0.14, 0.9)
    rightPanel:SetBackdropBorderColor(0.45, 0.38, 0.2, 0.9)

    local statsTitle = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    statsTitle:SetPoint("TOP", 0, -12)
    statsTitle:SetText("|cffFFD700QUICK STATS|r")

    local function CreateStat(y, label, value)
        local l = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        l:SetPoint("TOPLEFT", 15, y)
        l:SetText(label)

        local v = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        v:SetPoint("TOPRIGHT", -15, y)
        v:SetText(value)
        v:SetTextColor(1, 0.9, 0.5)
    end

    CreateStat(-50,  "Total Knowledge:", "312 / 450")
    CreateStat(-80,  "Missing Treasures:", "7")
    CreateStat(-110, "Weekly KP:", "18 / 25")
    CreateStat(-140, "Crafting Orders:", "4 available")

    -- ----------------------------------------------------------
    -- BOTTOM - Recommended Actions
    -- ----------------------------------------------------------
    local bottomTitle = page:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    bottomTitle:SetPoint("TOPLEFT", 240, -310)
    bottomTitle:SetText("|cffFFD700RECOMMENDED NEXT ACTIONS|r")

    local actions = {
        { title = "Claim Free KP",        desc = "Alchemy - Elixir Experimentation" },
        { title = "Hunt Treasures",       desc = "3 treasures nearby" },
        { title = "Efficient Leveling",   desc = "+15 Knowledge this week" },
        { title = "High Value Orders",    desc = "4 profitable orders available" },
    }

    for i, action in ipairs(actions) do
        local btn = CreateFrame("Button", nil, page, "BackdropTemplate")
        btn:SetSize(175, 70)
        btn:SetPoint("TOPLEFT", 240 + (i-1) * 185, -340)

        btn:SetBackdrop({
            bgFile   = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 12,
            insets   = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        btn:SetBackdropColor(0.12, 0.13, 0.19, 0.95)
        btn:SetBackdropBorderColor(0.5, 0.42, 0.2, 0.9)

        local t = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -12)
        t:SetText(action.title)

        local d = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        d:SetPoint("TOP", 0, -32)
        d:SetWidth(160)
        d:SetText(action.desc)
        d:SetTextColor(0.75, 0.75, 0.75)
    end
end

-- ============================================================
-- LEVELING GUIDE CONTENT (Real Data + Scroll + Clean Header)
-- ============================================================
function addon:BuildLeveling()
    local page = self.mainFrame.tabContents["leveling"]
    if not page then return end

    -- Clear old content
    for _, child in pairs({page:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
    for _, region in pairs({page:GetRegions()}) do
        if region.SetText then region:Hide() end
    end

    -- Get available professions that have real data
    local available = {}
    if private.DataLoader and private.DataLoader.GetAvailableProfessions then
        available = private.DataLoader:GetAvailableProfessions()
    end
    if #available == 0 then
        available = {"Alchemy", "Tailoring"}
    end

    self.selectedLevelingProf = self.selectedLevelingProf or "Tailoring"
    if not private.Data[self.selectedLevelingProf] then
        self.selectedLevelingProf = available[1]
    end

    local profData = private.Data[self.selectedLevelingProf]
    -- Path selection (Slow / Rush) — global across professions for now
    self.selectedPath = self.selectedPath or "slow"
    -- If a fork exists but the current path isn't one of its keys, snap to
    -- the first declared path. If the profession has no fork, leave as-is.
    for _, entry in ipairs(profData.leveling or {}) do
        if entry.type == "fork" and entry.paths and #entry.paths > 0 then
            local valid = false
            for _, p in ipairs(entry.paths) do
                if p.key == self.selectedPath then valid = true; break end
            end
            if not valid then
                self.selectedPath = entry.paths[1].key
            end
            break
        end
    end

    -- ----------------------------------------------------------
    -- LEFT PANEL - Profession Selector
    -- ----------------------------------------------------------
    local leftPanel = CreateFrame("Frame", nil, page, "BackdropTemplate")
    leftPanel:SetPoint("TOPLEFT", 12, -12)
    leftPanel:SetSize(190, 540)
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

    for i, name in ipairs(available) do
        local btn = CreateFrame("Button", nil, leftPanel, "BackdropTemplate")
        btn:SetSize(170, 32)
        btn:SetPoint("TOP", 0, -42 - (i-1) * 38)

        btn:SetBackdrop({
            bgFile   = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 10,
            insets   = { left = 1, right = 1, top = 1, bottom = 1 }
        })

        local isSelected = (name == self.selectedLevelingProf)
        if isSelected then
            btn:SetBackdropColor(0.35, 0.28, 0.10, 1)
            btn:SetBackdropBorderColor(0.9, 0.75, 0.25, 1)
        else
            btn:SetBackdropColor(0.12, 0.13, 0.19, 0.9)
            btn:SetBackdropBorderColor(0.35, 0.30, 0.18, 0.8)
        end

        local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("CENTER")
        text:SetText(name)
        if isSelected then
            text:SetTextColor(1, 0.9, 0.5)
        end

        btn:SetScript("OnClick", function()
            if self.levelingScrollFrame then
                self.levelingSubTabOffsets[self.levelingSubTab] =
                    self.levelingScrollFrame:GetVerticalScroll() or 0
            end
            self.selectedLevelingProf = name
            self:BuildLeveling()
        end)
    end

    -- ----------------------------------------------------------
    -- TOP HEADER (2 columns: 70% left / 30% right, 160px tall)
    --   LEFT  : [Icon] Title + Overview + [Spec] [Knowledge] buttons
    --   RIGHT : [Pin Trainer] + Trainer name/zone/note
    -- ----------------------------------------------------------
    local header = CreateFrame("Frame", nil, page, "BackdropTemplate")
    header:SetPoint("TOPLEFT", 215, -12)
    header:SetPoint("TOPRIGHT", -12, -12)
    header:SetHeight(140)
    header:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    header:SetBackdropColor(0.10, 0.11, 0.17, 0.95)
    header:SetBackdropBorderColor(0.55, 0.45, 0.2, 0.9)

        -- ============================================================
    -- RIGHT COLUMN (~30%): Trainer block
    -- Layout:  [Book] Name
    --          (Zone)
    --          Note wrapping in column
    --          [Pin Trainer] (bottom-right)
    -- ============================================================
    local rightCol = CreateFrame("Frame", nil, header)
    rightCol:SetPoint("TOPRIGHT", -14, -14)
    rightCol:SetPoint("BOTTOMRIGHT", -14, 14)
    rightCol:SetWidth(230)

    -- Subtle vertical divider between the two columns
    local divider = header:CreateTexture(nil, "ARTWORK")
    divider:SetWidth(1)
    divider:SetColorTexture(0.55, 0.45, 0.2, 0.35)
    divider:SetPoint("TOPRIGHT", rightCol, "TOPLEFT", -14, 0)
    divider:SetPoint("BOTTOMRIGHT", rightCol, "BOTTOMLEFT", -14, 0)

    if profData and profData.trainer then
        local t = profData.trainer

        -- Book icon + trainer name (top-left of the column)
        local trainerIcon = rightCol:CreateTexture(nil, "ARTWORK")
        trainerIcon:SetSize(16, 16)
        trainerIcon:SetPoint("TOPLEFT", 0, -2)
        trainerIcon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
        trainerIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        local trainerName = rightCol:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        trainerName:SetPoint("LEFT", trainerIcon, "RIGHT", 6, 0)
        trainerName:SetText("|cffFFD700" .. t.name .. "|r  |cff888888(Trainer)|r")

        -- Zone (below name)
        local trainerZone = rightCol:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        trainerZone:SetPoint("TOPLEFT", 0, -24)
        trainerZone:SetPoint("TOPRIGHT", 0, -24)
        trainerZone:SetJustifyH("LEFT")
        trainerZone:SetText("(" .. t.zone .. ")")
        trainerZone:SetTextColor(0.80, 0.80, 0.80)

        -- Note (below zone, wraps inside the 230px column)
        if t.note and t.note ~= "" then
            local trainerNote = rightCol:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            trainerNote:SetPoint("TOPLEFT", 0, -44)
            trainerNote:SetPoint("TOPRIGHT", 0, -44)
            trainerNote:SetJustifyH("LEFT")
            trainerNote:SetText(t.note)
            trainerNote:SetTextColor(0.65, 0.65, 0.65)
        end

        -- Pin Trainer button — anchored to the bottom-right of the trainer column
        local pinBtn = CreateFrame("Button", nil, rightCol, "UIPanelButtonTemplate")
        pinBtn:SetSize(130, 22)
        pinBtn:SetPoint("BOTTOMRIGHT", 0, 0)
        pinBtn:SetText("Pin Trainer")
        pinBtn:SetScript("OnClick", function()
            if t.mapID and t.x and t.y then
                local point = {
                    uiMapID = t.mapID,
                    position = CreateVector2D(t.x / 100, t.y / 100)
                }
                C_Map.SetUserWaypoint(point)
                C_SuperTrack.SetSuperTrackedUserWaypoint(true)
                private:Print("Pinned " .. t.name .. " on the map.")
            else
                private:Print("No coordinates available for this trainer.")
            end
        end)
    end

    -- ============================================================
    -- LEFT COLUMN (~70%): Title + Overview + Nav buttons
    -- Stretches from header's left edge to the right column
    -- ============================================================
    local leftCol = CreateFrame("Frame", nil, header)
    leftCol:SetPoint("TOPLEFT", 14, -14)
    leftCol:SetPoint("BOTTOMLEFT", 14, 14)
    leftCol:SetPoint("RIGHT", rightCol, "LEFT", -14, 0)

    -- Row 1: Icon + Title (both anchored to the TOP of the left column)
    if profData and profData.icon then
        local icon = leftCol:CreateTexture(nil, "ARTWORK")
        icon:SetSize(28, 28)
        icon:SetPoint("TOPLEFT", 0, 0)                 -- unchanged
        icon:SetTexture(profData.icon)
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    end

    local headerTitle = leftCol:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    headerTitle:SetPoint("TOPLEFT", 34, -4)           -- 6px gap after the 28px icon
    headerTitle:SetPoint("RIGHT", -10, 0)
    headerTitle:SetJustifyH("LEFT")                   -- ← the actual fix
    headerTitle:SetText("|cffFFD700" ..
        (profData and profData.name or self.selectedLevelingProf) ..
        " Leveling Guide|r")

    -- Row 2: Overview (full width of the LEFT column, with right inset)
    local overview = leftCol:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    overview:SetPoint("TOPLEFT", 0, -40)
    overview:SetPoint("TOPRIGHT", -10, -40)          -- ← 10px inset from divider
    overview:SetJustifyH("LEFT")
    overview:SetText((profData and profData.overview) or "")
    overview:SetTextColor(0.80, 0.80, 0.80)

    -- Row 3: Nav buttons (bottom of the left column)
    local specBtn = CreateFrame("Button", nil, leftCol, "UIPanelButtonTemplate")
    specBtn:SetSize(130, 22)
    specBtn:SetPoint("BOTTOMLEFT", 0, 0)
    specBtn:SetText("Specializations")
    specBtn:SetScript("OnClick", function()
        self.selectedSpecProf = self.selectedLevelingProf
        self:SelectTab("specializations")
    end)

    local knowledgeBtn = CreateFrame("Button", nil, leftCol, "UIPanelButtonTemplate")
    knowledgeBtn:SetSize(172, 22)                      -- was 150
    knowledgeBtn:SetPoint("LEFT", specBtn, "RIGHT", 8, 0)
    knowledgeBtn:SetText("Knowledge & Treasures")
    knowledgeBtn:SetScript("OnClick", function()
        self.selectedKnowledgeProf = self.selectedLevelingProf
        self:SelectTab("knowledge")
    end)


    -- ----------------------------------------------------------
    -- SUB-TAB BAR — Steps / Shopping List
    -- ----------------------------------------------------------
    self.levelingSubTab = self.levelingSubTab or "steps"
    self.levelingSubTabOffsets = self.levelingSubTabOffsets or { steps = 0, shopping = 0 }

    local subTabBar = CreateFrame("Frame", nil, page)
    subTabBar:SetPoint("TOPLEFT", 215, -158)
    subTabBar:SetSize(400, 28)

    local function MakeSubTab(key, text, xOff)
        local btn = CreateFrame("Button", nil, subTabBar, "BackdropTemplate")
        btn:SetSize(130, 28)
        btn:SetPoint("LEFT", xOff, 0)
        btn:SetBackdrop({
            bgFile   = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 12,
            insets   = { left = 2, right = 2, top = 2, bottom = 2 }
        })

        local lbl = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        lbl:SetPoint("CENTER")
        lbl:SetText(text)
        btn.label = lbl

        local isActive = (key == self.levelingSubTab)
        if isActive then
            btn:SetBackdropColor(0.35, 0.28, 0.10, 1)
            btn:SetBackdropBorderColor(0.9, 0.75, 0.25, 1)
            lbl:SetTextColor(1, 0.9, 0.5)
        else
            btn:SetBackdropColor(0.12, 0.13, 0.18, 1)
            btn:SetBackdropBorderColor(0.4, 0.35, 0.2, 0.8)
            lbl:SetTextColor(0.7, 0.7, 0.7)
        end

        btn:SetScript("OnClick", function()
            if self.levelingSubTab == key then return end
            -- Save the current view's scroll offset
            if self.levelingScrollFrame then
                self.levelingSubTabOffsets[self.levelingSubTab] =
                    self.levelingScrollFrame:GetVerticalScroll() or 0
            end
            self.levelingSubTab = key
            self:BuildLeveling()
        end)

        return btn
    end

    MakeSubTab("steps",    "Steps",         0)
    MakeSubTab("shopping", "Shopping List", 136)

    -- ---- Branch: render shopping list OR steps ----
    if self.levelingSubTab == "shopping" then
        self:RenderShoppingListBody(page, profData, -192)
        return
    end

    -- ----------------------------------------------------------
    -- SCROLLABLE STEPS AREA
    -- ----------------------------------------------------------
    local scrollFrame = CreateFrame("ScrollFrame", nil, page, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 215, -192)
    scrollFrame:SetPoint("BOTTOMRIGHT", -35, 15)
    self.levelingScrollFrame = scrollFrame

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetWidth(scrollFrame:GetWidth() - 10)
    content:SetHeight(1)
    scrollFrame:SetScrollChild(content)

    if not profData or not profData.leveling then
        local noData = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        noData:SetPoint("TOPLEFT", 20, -20)
        noData:SetText("No leveling data found for this profession.")
        content:SetHeight(100)
        return
    end

    local yOffset = -8

    -- State for the fork container (a step with a `path` field renders into
    -- the currently-active container instead of onto the raw scroll content).
    local activeContainer = nil
    local containerY = 0

    for i, entry in ipairs(profData.leveling) do
        -- ============================================================
        -- FORK ENTRY — a bounded section that wraps the tabs AND all
        -- subsequent path steps. Its position and `range` are declared
        -- in the data.
        -- ============================================================
        if entry.type == "fork" then
            -- Pre-scan: total height = header + tabs + visible path steps + padding
            local headerH  = 30
            local tabsH    = 50
            local topPad   = 10
            local botPad   = 20
            local stepGap  = 6
            local hdrStrip = 22   -- divider strip rendered above a step with .header

            -- Find the selected path object so we can read its `intro`
            local selPathObj = nil
            for _, p in ipairs(entry.paths or {}) do
                if p.key == self.selectedPath then selPathObj = p; break end
            end

            -- Measure intro height dynamically (0 if this path has no intro)
            local introH = 0
            if selPathObj and selPathObj.intro and selPathObj.intro ~= "" then
                local probe = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                probe:SetWidth(640)
                probe:SetJustifyH("LEFT")
                probe:SetText(selPathObj.intro)
                introH = (probe:GetStringHeight() or 30)
                probe:Hide()
                probe:SetParent(nil)
            end

            local containerHeight = topPad + headerH + tabsH + stepGap
                                  + (introH > 0 and (introH + stepGap) or 0)
                                  + botPad

            local j = i + 1
            while j <= #profData.leveling and profData.leveling[j].path do
                local s = profData.leveling[j]
                if s.path == self.selectedPath then
                    local rH = 106
                    if s.crafts and #s.crafts > 0 then
                        rH = 60 + math.ceil(#s.crafts / 3.5) * 22 + 30
                    end
                    -- Must match the row-height bump in the render code
                    if s.specAction == "open_tree" then
                        rH = rH + 40
                    end
                    local hdrExtra = (s.header and s.header ~= "") and hdrStrip or 0
                    containerHeight = containerHeight + rH + hdrExtra + stepGap
                end
                j = j + 1
            end

            -- The container frame itself
            local container = CreateFrame("Frame", nil, content, "BackdropTemplate")
            container:SetPoint("TOPLEFT", 8, yOffset)
            container:SetSize(700, containerHeight)
            container:SetBackdrop({
                bgFile   = "Interface\\Buttons\\WHITE8x8",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                edgeSize = 12,
                insets   = { left = 3, right = 3, top = 3, bottom = 3 }
            })
            -- Darker gold wash, distinct from the step rows
            container:SetBackdropColor(0.16, 0.12, 0.04, 0.85)
            container:SetBackdropBorderColor(0.55, 0.45, 0.2, 0.9)

            -- Header label with the range, so the reader knows WHERE the fork applies
            local headerLbl = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            headerLbl:SetPoint("TOPLEFT", 14, -10)
            headerLbl:SetText("|cffFFD700Leveling Path|r  |cffBBBBBB·|r  |cffFFD700" ..
                (entry.range or "") .. "|r")

            -- Tabs — horizontally CENTERED within the container
            local paths = entry.paths or {}
            local tabW, tabH, tabGap = 230, 50, 10
            local totalTabsW = (#paths * tabW) + ((#paths - 1) * tabGap)
            local startX = math.floor((700 - totalTabsW) / 2)
            local tabsY  = -(topPad + headerH)

            for idx, p in ipairs(paths) do
                local btn = CreateFrame("Button", nil, container, "BackdropTemplate")
                btn:SetSize(tabW, tabH)
                btn:SetPoint("TOPLEFT", startX + (idx - 1) * (tabW + tabGap), tabsY)
                btn:SetBackdrop({
                    bgFile   = "Interface\\Buttons\\WHITE8x8",
                    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                    edgeSize = 12,
                    insets   = { left = 2, right = 2, top = 2, bottom = 2 }
                })

                local isSelected = (p.key == self.selectedPath)
                if isSelected then
                    btn:SetBackdropColor(0.35, 0.28, 0.10, 1)
                    btn:SetBackdropBorderColor(0.9, 0.75, 0.25, 1)
                else
                    btn:SetBackdropColor(0.10, 0.11, 0.14, 1)
                    btn:SetBackdropBorderColor(0.35, 0.32, 0.22, 0.8)
                end

                local mainLbl = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                mainLbl:SetPoint("TOP", 0, -8)
                mainLbl:SetText(p.label or "")
                if isSelected then
                    mainLbl:SetTextColor(1, 0.9, 0.5)
                else
                    mainLbl:SetTextColor(0.85, 0.85, 0.85)
                end

                local desc = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                desc:SetPoint("TOP", mainLbl, "BOTTOM", 0, -3)
                desc:SetText(p.description or "")
                desc:SetTextColor(0.68, 0.68, 0.68)

                btn:SetScript("OnClick", function()
                    if self.levelingScrollFrame then
                        self.levelingSubTabOffsets.steps = self.levelingScrollFrame:GetVerticalScroll() or 0
                    end
                    self.selectedPath = p.key
                    self:BuildLeveling()
                end)
            end

            -- Render intro paragraph for the currently selected path
            containerY = tabsY - tabH - stepGap
            if introH > 0 then
                local intro = container:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                intro:SetPoint("TOPLEFT", 20, containerY)
                intro:SetPoint("TOPRIGHT", -20, containerY)
                intro:SetJustifyH("LEFT")
                intro:SetText(selPathObj.intro)
                intro:SetTextColor(0.78, 0.78, 0.78)
                containerY = containerY - introH - stepGap
            end

            activeContainer = container

            yOffset = yOffset - containerHeight - stepGap
        else
            -- ============================================================
            -- NORMAL STEP ENTRY
            -- ============================================================
            local step = entry

            local showStep = true
            if step.path and step.path ~= self.selectedPath then
                showStep = false
            end

            if showStep then
                local rowHeight = 106
                if step.crafts and #step.crafts > 0 then
                    rowHeight = 60 + math.ceil(#step.crafts / 3.5) * 22 + 30
                end

                -- Reserve extra vertical space for the spec footer if present
                if step.specAction == "open_tree" then
                    rowHeight = rowHeight + 40
                end

                -- Choose parent + Y position:
                --   - if this step declares a path AND a container is open,
                --     it lives inside the container
                --   - otherwise it goes on the raw scroll content
                local parent, renderY, rowWidth
                if step.path and activeContainer then
                    parent    = activeContainer
                    rowWidth  = 684

                    -- Optional sub-header divider above this step
                    if step.header and step.header ~= "" then
                        local hLbl = activeContainer:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                        hLbl:SetPoint("TOPLEFT", 14, containerY)
                        hLbl:SetText("|cffFFD700" .. step.header .. "|r")

                        local line = activeContainer:CreateTexture(nil, "ARTWORK")
                        line:SetHeight(1)
                        line:SetColorTexture(0.55, 0.45, 0.2, 0.5)
                        line:SetPoint("TOPLEFT", 14, containerY - 17)
                        line:SetPoint("TOPRIGHT", -14, containerY - 17)

                        containerY = containerY - 22
                    end

                    renderY = containerY
                else
                    parent    = content
                    renderY   = yOffset
                    rowWidth  = 700
                end

                local row = CreateFrame("Frame", nil, parent, "BackdropTemplate")
                row:SetSize(rowWidth, rowHeight)
                row:SetPoint("TOPLEFT", 8, renderY)
                row:SetBackdrop({
                    bgFile   = "Interface\\Buttons\\WHITE8x8",
                    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                    edgeSize = 10,
                    insets   = { left = 2, right = 2, top = 2, bottom = 2 }
                })
                row:SetBackdropColor(0.11, 0.12, 0.18, 0.95)
                row:SetBackdropBorderColor(0.4, 0.35, 0.2, 0.8)

                -- Range
                local range = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                range:SetPoint("TOPLEFT", 12, -8)
                range:SetText("|cffFFD700" .. (step.range or "") .. "|r")

                -- ============================================================
                -- RECIPE NAME + CRAFTED ITEM ICON(S)
                -- ============================================================
                local recipeY = -28
                local recipeX = 12

                if step.quantity and step.quantity > 1 then
                    local quantityText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    quantityText:SetPoint("TOPLEFT", recipeX, recipeY)
                    quantityText:SetText(step.quantity .. "x")
                    quantityText:SetTextColor(1, 1, 1)
                    recipeX = recipeX + quantityText:GetStringWidth() + 5
                end

                local function AddRecipeEntry(name, itemID)
                    if itemID then
                        local icon = row:CreateTexture(nil, "ARTWORK")
                        icon:SetSize(16, 16)
                        icon:SetPoint("TOPLEFT", recipeX, recipeY + 1)
                        icon:SetTexture(addon:GetItemIcon(itemID))
                        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                        recipeX = recipeX + 20
                    end
                    local txt = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    txt:SetPoint("TOPLEFT", recipeX, recipeY)
                    txt:SetText(name or "")
                    recipeX = recipeX + txt:GetStringWidth() + 16
                end

                if step.recipes and #step.recipes > 0 then
                    for idx, r in ipairs(step.recipes) do
                        if idx > 1 then
                            local sep = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                            sep:SetPoint("TOPLEFT", recipeX - 12, recipeY)
                            sep:SetText("|cff666666•|r")
                        end
                        AddRecipeEntry(r.name, r.itemID)
                    end
                else
                    AddRecipeEntry(step.recipe, step.itemID)
                    if not step.itemID and step.itemIDs then
                        for _, id in ipairs(step.itemIDs) do
                            local icon = row:CreateTexture(nil, "ARTWORK")
                            icon:SetSize(16, 16)
                            icon:SetPoint("TOPLEFT", recipeX, recipeY + 1)
                            icon:SetTexture(addon:GetItemIcon(id))
                            icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                            recipeX = recipeX + 18
                        end
                    end
                end

                -- ============================================================
                -- MATERIALS or DETAILED CRAFTS
                -- ============================================================
                local contentY = -50
                local hasContent = false

                if step.crafts and #step.crafts > 0 then
                    hasContent = true
                    local startX = 12
                    local wrapX = startX
                    local wrapY = contentY
                    local maxWidth = rowWidth - 20

                    for _, craft in ipairs(step.crafts) do
                        local amountText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                        amountText:SetText((craft.quantity or 1) .. "x")
                        amountText:SetTextColor(0.9, 0.9, 0.9)

                        local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                        nameText:SetText(craft.name)
                        nameText:SetTextColor(0.75, 0.75, 0.75)

                        local neededWidth = amountText:GetStringWidth() + 22 + nameText:GetStringWidth() + 12

                        if wrapX + neededWidth > maxWidth then
                            wrapX = startX
                            wrapY = wrapY - 20
                        end

                        amountText:SetPoint("TOPLEFT", wrapX, wrapY)
                        wrapX = wrapX + amountText:GetStringWidth() + 4

                        local icon = row:CreateTexture(nil, "ARTWORK")
                        icon:SetSize(16, 16)
                        icon:SetPoint("TOPLEFT", wrapX, wrapY + 1)
                        icon:SetTexture(addon:GetItemIcon(craft.itemID))
                        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                        wrapX = wrapX + 18

                        nameText:SetPoint("TOPLEFT", wrapX, wrapY)
                        wrapX = wrapX + nameText:GetStringWidth() + 12
                    end

                    contentY = wrapY
                elseif step.materials and #step.materials > 0 then
                    hasContent = true
                    local xOffset = 12

                    local matsLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                    matsLabel:SetPoint("TOPLEFT", xOffset, contentY)
                    matsLabel:SetText("|cff888888Mats:|r")
                    xOffset = xOffset + matsLabel:GetStringWidth() + 8

                    for _, mat in ipairs(step.materials) do
                        local amountText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                        amountText:SetPoint("TOPLEFT", xOffset, contentY)
                        amountText:SetText(mat.amount .. "x")
                        amountText:SetTextColor(0.9, 0.9, 0.9)
                        xOffset = xOffset + amountText:GetStringWidth() + 4

                        local icon = row:CreateTexture(nil, "ARTWORK")
                        icon:SetSize(16, 16)
                        icon:SetPoint("TOPLEFT", xOffset, contentY + 1)
                        icon:SetTexture(addon:GetItemIcon(mat.itemID))
                        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                        xOffset = xOffset + 18

                        local matText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                        matText:SetPoint("TOPLEFT", xOffset, contentY)
                        matText:SetText(mat.name)
                        matText:SetTextColor(0.75, 0.75, 0.75)
                        xOffset = xOffset + matText:GetStringWidth() + 14
                    end
                end

                -- NOTE
                if step.note and step.note ~= "" then
                    local noteY = hasContent and (contentY - 20) or -50
                    local note = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                    note:SetPoint("TOPLEFT", 12, noteY)
                    note:SetWidth(rowWidth - 100)
                    note:SetJustifyH("LEFT")
                    note:SetText(step.note)
                    note:SetTextColor(0.60, 0.60, 0.60)
                end

                -- Difficulty
                local diff = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                diff:SetPoint("TOPRIGHT", -12, -7)
                if step.difficulty == "orange" then
                    diff:SetText("|cffff7f00Orange|r")
                elseif step.difficulty == "yellow" then
                    diff:SetText("|cffffff00Yellow|r")
                else
                    diff:SetText("|cff1eff00Green|r")
                end

                -- Recommended
                if step.isRecommended then
                    local rec = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                    rec:SetPoint("TOPRIGHT", -12, -25)
                    rec:SetText("|cff00ff00Recommended|r")
                end

                -- ============================================================
                -- SPEC ACTION FOOTER (only if step.specAction is set)
                -- Button + optional hint icon. No live data lookup.
                -- ============================================================
                if step.specAction == "open_tree" then
                    -- Divider line above the footer
                    local divider = row:CreateTexture(nil, "ARTWORK")
                    divider:SetHeight(1)
                    divider:SetColorTexture(0.4, 0.35, 0.2, 0.6)
                    divider:SetPoint("BOTTOMLEFT", 12, 36)
                    divider:SetPoint("BOTTOMRIGHT", -12, 36)

                    -- Left: short call to action
                    local specLbl = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                    specLbl:SetPoint("BOTTOMLEFT", 12, 18)
                    specLbl:SetText("|cff888888Open your spec tree to spend Knowledge Points here.|r")

                    -- Right: "Open Spec Tree" button
                    local openBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
                    openBtn:SetSize(140, 22)
                    openBtn:SetPoint("BOTTOMRIGHT", -12, 10)
                    openBtn:SetText("Open Spec Tree")
                    openBtn:SetScript("OnClick", function()
                        local targetProfession = self.selectedLevelingProf or "Tailoring"
                        local targetSubTree = step.specTarget   -- e.g. "Nimble Needlework"

                        -- 1. Resolve skillLineID for the current guide profession
                        local skillLineID
                        local prof1, prof2 = GetProfessions()
                        for _, idx in ipairs({ prof1, prof2 }) do
                            if idx then
                                local name, _, _, _, _, _, skillLine = GetProfessionInfo(idx)
                                if name == targetProfession then
                                    skillLineID = skillLine
                                    break
                                end
                            end
                        end

                        if not skillLineID then
                            private:Print("Could not find skill line for " .. targetProfession ..
                                        ". Press |cffffff00K|r and pick the Specializations tab.")
                            return
                        end

                        -- 2. Open the profession (this loads the spec config)
                        C_TradeSkillUI.OpenTradeSkill(skillLineID)

                        self.mainFrame:Hide()

                        if not targetSubTree then return end

                        local reminderIcon = step.specTargetIcon
                        pcall(function()
                            self:ShowSpecReminder(targetSubTree, reminderIcon)
                        end)

                        -- ============================================================
                        -- 3. Navigation strategies
                        -- ============================================================

                        -- Strategy A: walk the button hierarchy and click the tab whose text matches
                        local function trySelectByText()
                            local page = _G.ProfessionsFrame and _G.ProfessionsFrame.SpecPage
                            if not page then return false end

                            local found = false
                            local function walk(frame, depth)
                                if found or depth > 6 then return end
                                for _, child in ipairs({ frame:GetChildren() }) do
                                    -- Match by GetText if it's a plain Button
                                    if child.GetText then
                                        local txt = child:GetText()
                                        if txt == targetSubTree and child.Click then
                                            child:Click()
                                            found = true
                                            return
                                        end
                                    end
                                    -- Also match by a .Text FontString (some tab templates do this)
                                    if child.Text and child.Text.GetText then
                                        local txt = child.Text:GetText()
                                        if txt == targetSubTree and child.Click then
                                            child:Click()
                                            found = true
                                            return
                                        end
                                    end
                                    walk(child, depth + 1)
                                    if found then return end
                                end
                            end
                            walk(page, 0)
                            return found
                        end

                        -- Strategy B: use C_ProfSpecs to resolve the sub-tree ID, then SetSelectedTab
                        local function trySelectByID()
                            local ids = C_ProfSpecs.GetSpecTabIDsForSkillLine(skillLineID)
                            if not ids then return false end

                            local function nameOf(id)
                                -- Both functions exist in the namespace; try both
                                if C_ProfSpecs.GetSpecTabInfo then
                                    local info = C_ProfSpecs.GetSpecTabInfo(id)
                                    if info and info.name then return info.name end
                                end
                                if C_ProfSpecs.GetTabInfo then
                                    local info = C_ProfSpecs.GetTabInfo(id)
                                    if info and info.name then return info.name end
                                end
                                return nil
                            end

                            -- Gather IDs from both array and dictionary shapes
                            local flat = {}
                            for _, id in ipairs(ids)   do flat[#flat + 1] = id end
                            for _, id in pairs(ids)    do
                                -- avoid duplicating array entries
                                local dup = false
                                for _, existing in ipairs(flat) do
                                    if existing == id then dup = true; break end
                                end
                                if not dup then flat[#flat + 1] = id end
                            end

                            local targetID
                            for _, id in ipairs(flat) do
                                if nameOf(id) == targetSubTree then
                                    targetID = id
                                    break
                                end
                            end
                            if not targetID then return false end

                            local page = _G.ProfessionsFrame and _G.ProfessionsFrame.SpecPage
                            if not page then return false end

                            -- Cache the choice so future opens remember it
                            local profID = page.GetProfessionID and page:GetProfessionID()
                            if profID and g_professionsSpecsSelectedTabs then
                                g_professionsSpecsSelectedTabs[profID] = targetID
                            end

                            if type(page.SetSelectedTab) == "function" then
                                pcall(page.SetSelectedTab, page, targetID)
                                return true
                            end
                            return false
                        end

                        -- Strategy C: use the SpecPage's own TabSystem, iterating by index
                        local function trySelectByTabSystem()
                            local page = _G.ProfessionsFrame and _G.ProfessionsFrame.SpecPage
                            if not page or not page.TabSystem then return false end
                            local ts = page.TabSystem
                            for i = 1, 10 do
                                local btn = ts.GetTabButton and ts:GetTabButton(i)
                                if not btn then break end
                                local txt = btn.GetText and btn:GetText()
                                        or (btn.Text and btn.Text.GetText and btn.Text:GetText())
                                if txt == targetSubTree and type(ts.SetTab) == "function" then
                                    pcall(ts.SetTab, ts, i)
                                    return true
                                end
                            end
                            return false
                        end

                        -- ============================================================
                        -- 4. Retry loop — the tabs load asynchronously after OpenTradeSkill
                        -- ============================================================
                        local function navigate(attemptsLeft)
                            if attemptsLeft <= 0 then
                                private:Print("Couldn't auto-select the '" .. targetSubTree ..
                                            "' sub-tab. Please click it manually.")
                                return
                            end

                            local frame = _G.ProfessionsFrame
                            if not frame then
                                C_Timer.After(0.1, function() navigate(attemptsLeft - 1) end)
                                return
                            end

                            -- Make sure we're on the Specializations tab of the book
                            local ts = frame.TabSystem
                            if ts and type(ts.SetTab) == "function" then
                                pcall(ts.SetTab, ts, 2)
                            end

                            -- Try each strategy; stop as soon as one works
                            if trySelectByID()        then return end
                            if trySelectByTabSystem() then return end
                            if trySelectByText()      then return end

                            C_Timer.After(0.1, function() navigate(attemptsLeft - 1) end)
                        end

                        C_Timer.After(0.2, function() navigate(12) end)
                    end)

                    -- Optional hint icon next to the button
                    if step.hint and step.hint ~= "" then
                        local hintIcon = CreateFrame("Frame", nil, row)
                        hintIcon:SetSize(16, 16)
                        hintIcon:SetPoint("RIGHT", openBtn, "LEFT", -8, 0)

                        local iconTex = hintIcon:CreateTexture(nil, "ARTWORK")
                        iconTex:SetAllPoints()
                        iconTex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
                        iconTex:SetTexCoord(0.08, 0.92, 0.08, 0.92)

                        hintIcon:SetScript("OnEnter", function(self)
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                            GameTooltip:AddLine("What is this?")
                            GameTooltip:AddLine(step.hint, 1, 1, 1, true)
                            GameTooltip:Show()
                        end)
                        hintIcon:SetScript("OnLeave", function()
                            GameTooltip:Hide()
                        end)
                    end
                end

                -- Advance the correct cursor
                if step.path and activeContainer then
                    containerY = containerY - rowHeight - 6
                else
                    yOffset = yOffset - rowHeight - 6
                end
            end

            -- Close the container as soon as we hit a step that isn't a path step
            if not step.path and activeContainer then
                activeContainer = nil
            end
        end
    end

    content:SetHeight(math.abs(yOffset) + 20)

    -- Restore scroll position for the steps sub-tab
    local offset = self.levelingSubTabOffsets and self.levelingSubTabOffsets.steps or 0
    if offset > 0 then
        scrollFrame:SetVerticalScroll(offset)
    end

    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local current = self:GetVerticalScroll()
        local maxScroll = self:GetVerticalScrollRange()
        local newScroll = math.min(maxScroll, math.max(0, current - (delta * 30)))
        self:SetVerticalScroll(newScroll)
    end)
end

-- ============================================================
-- KNOWLEDGE & TREASURES CONTENT (Clean Version)
-- ============================================================
function addon:BuildKnowledge()
    local page = self.mainFrame.tabContents["knowledge"]
    if not page then return end

    -- Clear old content
    for _, child in pairs({page:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
    for _, region in pairs({page:GetRegions()}) do
        if region.SetText then region:Hide() end
    end

    self.selectedKnowledgeProf = self.selectedKnowledgeProf or "Alchemy"

    -- ----------------------------------------------------------
    -- HEADER
    -- ----------------------------------------------------------
    local header = CreateFrame("Frame", nil, page, "BackdropTemplate")
    header:SetPoint("TOPLEFT", 12, -12)
    header:SetPoint("TOPRIGHT", -12, -12)
    header:SetHeight(50)
    header:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    header:SetBackdropColor(0.10, 0.11, 0.17, 0.95)
    header:SetBackdropBorderColor(0.55, 0.45, 0.2, 0.9)

    local headerTitle = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    headerTitle:SetPoint("LEFT", 18, 0)
    headerTitle:SetText("|cffFFD700Knowledge & Treasures|r")

    -- ----------------------------------------------------------
    -- FILTER BAR
    -- ----------------------------------------------------------
    local filterBar = CreateFrame("Frame", nil, page)
    filterBar:SetPoint("TOPLEFT", 12, -72)
    filterBar:SetPoint("TOPRIGHT", -12, -72)
    filterBar:SetHeight(32)

    local profLabel = filterBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    profLabel:SetPoint("LEFT", 0, 0)
    profLabel:SetText("Profession:")

    local profs = {"Alchemy", "Blacksmithing", "Enchanting", "Herbalism", "Tailoring"}
    local xOffset = 90

    for i, name in ipairs(profs) do
        local btn = CreateFrame("Button", nil, filterBar, "UIPanelButtonTemplate")
        btn:SetSize(95, 26)
        btn:SetPoint("LEFT", xOffset, 0)
        btn:SetText(name)

        if name == self.selectedKnowledgeProf then
            btn:Disable()
        end

        btn:SetScript("OnClick", function()
            self.selectedKnowledgeProf = name
            self:BuildKnowledge()
        end)

        xOffset = xOffset + 100
    end

    local pinAllBtn = CreateFrame("Button", nil, filterBar, "UIPanelButtonTemplate")
    pinAllBtn:SetSize(160, 26)
    pinAllBtn:SetPoint("RIGHT", 0, 0)
    pinAllBtn:SetText("Pin All Missing")
    pinAllBtn:SetScript("OnClick", function()
        private:Print("Pinning all missing treasures for " .. self.selectedKnowledgeProf)
    end)

    -- ----------------------------------------------------------
    -- TREASURE LIST (shorter height to avoid overlap)
    -- ----------------------------------------------------------
    local listFrame = CreateFrame("Frame", nil, page, "BackdropTemplate")
    listFrame:SetPoint("TOPLEFT", 12, -115)
    listFrame:SetPoint("BOTTOMRIGHT", -12, 145)   -- <-- important: leaves space for bottom panel
    listFrame:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    listFrame:SetBackdropColor(0.07, 0.08, 0.13, 0.9)
    listFrame:SetBackdropBorderColor(0.4, 0.35, 0.2, 0.8)

    -- Only 6 items so everything fits cleanly for now
    local treasures = {
        { name = "Alchemical Insights",      zone = "Duskholme",           status = "Collected" },
        { name = "Herbalist's Bounty",       zone = "Starfall Vale",       status = "Missing" },
        { name = "Forged in Eternity",       zone = "The Shattered Weald", status = "Missing" },
        { name = "Tome of Ancient Insights", zone = "Veil of Echoes",      status = "Collected" },
        { name = "Threads of Fate",          zone = "The Weave",           status = "Missing" },
        { name = "Essence of Wonder",        zone = "Ethereal Expanse",    status = "Missing" },
    }

    for i, treasure in ipairs(treasures) do
        local row = CreateFrame("Frame", nil, listFrame, "BackdropTemplate")
        row:SetSize(920, 38)
        row:SetPoint("TOPLEFT", 10, -10 - (i-1) * 44)

        row:SetBackdrop({
            bgFile   = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 10,
            insets   = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        row:SetBackdropColor(0.11, 0.12, 0.18, 0.9)
        row:SetBackdropBorderColor(0.35, 0.30, 0.18, 0.7)

        local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameText:SetPoint("LEFT", 12, 0)
        nameText:SetText(treasure.name)

        local zoneText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        zoneText:SetPoint("LEFT", 300, 0)
        zoneText:SetText(treasure.zone)
        zoneText:SetTextColor(0.75, 0.75, 0.75)

        local statusText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        statusText:SetPoint("LEFT", 580, 0)
        if treasure.status == "Collected" then
            statusText:SetText("|cff1eff00Collected|r")
        else
            statusText:SetText("|cffff4444Missing|r")
        end

        if treasure.status == "Missing" then
            local pinBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            pinBtn:SetSize(110, 22)
            pinBtn:SetPoint("RIGHT", -10, 0)
            pinBtn:SetText("Pin Treasure")
            pinBtn:SetScript("OnClick", function()
                private:Print("Pinning: " .. treasure.name)
            end)
        end
    end

    -- ----------------------------------------------------------
    -- BOTTOM PANEL (Weekly + First Crafts)
    -- ----------------------------------------------------------
    local bottomPanel = CreateFrame("Frame", nil, page, "BackdropTemplate")
    bottomPanel:SetPoint("BOTTOMLEFT", 12, 12)
    bottomPanel:SetPoint("BOTTOMRIGHT", -12, 12)
    bottomPanel:SetHeight(120)
    bottomPanel:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    bottomPanel:SetBackdropColor(0.09, 0.10, 0.15, 0.95)
    bottomPanel:SetBackdropBorderColor(0.45, 0.38, 0.2, 0.9)

    local weeklyTitle = bottomPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    weeklyTitle:SetPoint("TOPLEFT", 15, -12)
    weeklyTitle:SetText("|cffFFD700Weekly Knowledge|r  |cff888888(Resets in 3d 14h)|r")

    local weeklyText = bottomPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    weeklyText:SetPoint("TOPLEFT", 15, -34)
    weeklyText:SetText("Trainer Quest: 1/1   •   Treatise: 0/1   •   Treasure Drops: 2/3   •   Darkmoon Faire: Available")

    local firstTitle = bottomPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    firstTitle:SetPoint("TOPLEFT", 15, -65)
    firstTitle:SetText("|cffFFD700First Crafts (" .. self.selectedKnowledgeProf .. ")|r")

    local firstText = bottomPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    firstText:SetPoint("TOPLEFT", 15, -87)
    firstText:SetText("First Crafts: 12/40   •   Knowledge gained: 12 KP   •   Next important: Elixir Experimentation")
end


-- ============================================================
-- SPECIALIZATIONS CONTENT
-- ============================================================
function addon:BuildSpecializations()
    local page = self.mainFrame.tabContents["specializations"]
    if not page then return end

    -- Clear old content
    for _, child in pairs({page:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
    for _, region in pairs({page:GetRegions()}) do
        if region.SetText then region:Hide() end
    end

    self.selectedSpecProf = self.selectedSpecProf or "Alchemy"

    -- ----------------------------------------------------------
    -- LEFT PANEL - Profession Selector
    -- ----------------------------------------------------------
    local leftPanel = CreateFrame("Frame", nil, page, "BackdropTemplate")
    leftPanel:SetPoint("TOPLEFT", 12, -12)
    leftPanel:SetSize(180, 540)
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

    local professions = {
        "Alchemy", "Blacksmithing", "Enchanting", "Engineering",
        "Herbalism", "Inscription", "Jewelcrafting", "Leatherworking",
        "Mining", "Skinning", "Tailoring"
    }

    for i, name in ipairs(professions) do
        local btn = CreateFrame("Button", nil, leftPanel, "BackdropTemplate")
        btn:SetSize(160, 32)
        btn:SetPoint("TOP", 0, -42 - (i-1) * 36)

        btn:SetBackdrop({
            bgFile   = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 10,
            insets   = { left = 1, right = 1, top = 1, bottom = 1 }
        })

        local isSelected = (name == self.selectedSpecProf)
        if isSelected then
            btn:SetBackdropColor(0.35, 0.28, 0.10, 1)
            btn:SetBackdropBorderColor(0.9, 0.75, 0.25, 1)
        else
            btn:SetBackdropColor(0.12, 0.13, 0.19, 0.9)
            btn:SetBackdropBorderColor(0.35, 0.30, 0.18, 0.8)
        end

        local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("CENTER")
        text:SetText(name)
        if isSelected then
            text:SetTextColor(1, 0.9, 0.5)
        end

        btn:SetScript("OnClick", function()
            self.selectedSpecProf = name
            self:BuildSpecializations()
        end)
    end

    -- ----------------------------------------------------------
    -- CENTER - Tree Placeholder
    -- ----------------------------------------------------------
    local treeFrame = CreateFrame("Frame", nil, page, "BackdropTemplate")
    treeFrame:SetPoint("TOPLEFT", 205, -12)
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

    -- ----------------------------------------------------------
    -- RIGHT PANEL - Recommended Builds
    -- ----------------------------------------------------------
    local rightPanel = CreateFrame("Frame", nil, page, "BackdropTemplate")
    rightPanel:SetPoint("TOPRIGHT", -12, -12)
    rightPanel:SetSize(255, 540)
    rightPanel:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    rightPanel:SetBackdropColor(0.08, 0.09, 0.14, 0.9)
    rightPanel:SetBackdropBorderColor(0.45, 0.38, 0.2, 0.9)

    local rightTitle = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rightTitle:SetPoint("TOP", 0, -14)
    rightTitle:SetText("|cffFFD700RECOMMENDED BUILDS|r")

    -- Example builds
    local builds = {
        {
            name = "Potion Master",
            desc = "Best for raiding & M+",
            points = "30 points",
            focus = "Elixir • Alchemical Mastery"
        },
        {
            name = "Flask Specialist",
            desc = "High demand crafts",
            points = "28 points",
            focus = "Flask • Batch Production"
        },
        {
            name = "Transmutation",
            desc = "Long-term gold making",
            points = "25 points",
            focus = "Transmutation • Efficiency"
        },
    }

    for i, build in ipairs(builds) do
        local card = CreateFrame("Frame", nil, rightPanel, "BackdropTemplate")
        card:SetSize(230, 110)
        card:SetPoint("TOP", 0, -45 - (i-1) * 125)

        card:SetBackdrop({
            bgFile   = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 12,
            insets   = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        card:SetBackdropColor(0.12, 0.13, 0.19, 0.95)
        card:SetBackdropBorderColor(0.5, 0.42, 0.2, 0.9)

        local bName = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        bName:SetPoint("TOPLEFT", 12, -10)
        bName:SetText(build.name)

        local bDesc = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        bDesc:SetPoint("TOPLEFT", 12, -28)
        bDesc:SetText(build.desc)
        bDesc:SetTextColor(0.75, 0.75, 0.75)

        local bPoints = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        bPoints:SetPoint("TOPLEFT", 12, -48)
        bPoints:SetText(build.points)
        bPoints:SetTextColor(1, 0.9, 0.5)

        local bFocus = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        bFocus:SetPoint("TOPLEFT", 12, -68)
        bFocus:SetText(build.focus)
        bFocus:SetTextColor(0.65, 0.65, 0.65)

        local applyBtn = CreateFrame("Button", nil, card, "UIPanelButtonTemplate")
        applyBtn:SetSize(100, 22)
        applyBtn:SetPoint("BOTTOMLEFT", 12, 10)
        applyBtn:SetText("View Path")
    end
end

-- ============================================================
-- SHOPPING LIST ENGINE
-- Aggregates materials across the whole guide, respecting the
-- currently selected fork path. Subtracts items already owned
-- (bags, bank, reagent bank, warband bank).
-- ============================================================
function addon:CollectAllMaterials(profData)
    local totals = {}
    local order  = {}

    local function addItem(itemID, name, amount)
        if not name or not amount or amount <= 0 then return end
        local key = (itemID and itemID ~= 0) and itemID or name
        if not totals[key] then
            totals[key] = { itemID = itemID, name = name, required = 0 }
            order[#order + 1] = key
        end
        totals[key].required = totals[key].required + amount
    end

    for _, entry in ipairs(profData.leveling or {}) do
        -- Skip fork containers (they hold no materials of their own)
        if entry.type ~= "fork" then
            -- Respect the currently selected path
            local include = true
            if entry.path and entry.path ~= self.selectedPath then
                include = false
            end

            if include then
                local hasStepMats = entry.materials and #entry.materials > 0
                if hasStepMats then
                    -- Step-level materials take priority (used for ranges
                    -- where the guide gives you one total per material)
                    for _, mat in ipairs(entry.materials) do
                        addItem(mat.itemID, mat.name, mat.amount or 1)
                    end
                else
                    -- Fall back to summing craft materials (used for
                    -- First-Crafts steps and other multi-craft lists)
                    for _, craft in ipairs(entry.crafts or {}) do
                        local q = craft.quantity or 1
                        for _, mat in ipairs(craft.materials or {}) do
                            addItem(mat.itemID, mat.name, (mat.amount or 1) * q)
                        end
                    end
                end
            end
        end
    end

    -- Subtract owned; build final list
    local list = {}
    for _, key in ipairs(order) do
        local e = totals[key]
        e.owned     = self:GetItemCount(e.itemID)
        e.remaining = math.max(0, e.required - e.owned)
        list[#list + 1] = e
    end

    -- Sort: still-needed first (by descending remaining), then complete
    table.sort(list, function(a, b)
        local aMiss = a.remaining > 0
        local bMiss = b.remaining > 0
        if aMiss ~= bMiss then return aMiss end
        if aMiss and a.remaining ~= b.remaining then
            return a.remaining > b.remaining
        end
        return (a.name or "") < (b.name or "")
    end)

    return list
end

-- ============================================================
-- SHOPPING LIST VIEW
-- ============================================================
function addon:RenderShoppingListBody(page, profData, topY)
    local scrollFrame = CreateFrame("ScrollFrame", nil, page, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 215, topY)
    scrollFrame:SetPoint("BOTTOMRIGHT", -35, 15)
    self.levelingScrollFrame = scrollFrame

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetWidth(scrollFrame:GetWidth() - 10)
    content:SetHeight(1)
    scrollFrame:SetScrollChild(content)

    local list = self:CollectAllMaterials(profData)

    if #list == 0 then
        local empty = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        empty:SetPoint("TOPLEFT", 20, -20)
        empty:SetText("No materials found for this guide.")
        content:SetHeight(60)
    else
        -- Column headers
        local header = CreateFrame("Frame", nil, content)
        header:SetPoint("TOPLEFT", 8, -8)
        header:SetSize(700, 24)

        local hName = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        hName:SetPoint("LEFT", 34, 0)
        hName:SetText("|cff888888MATERIAL|r")

        local hHave = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        hHave:SetPoint("RIGHT", -190, 0)
        hHave:SetText("|cff888888HAVE|r")

        local hNeed = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        hNeed:SetPoint("RIGHT", -12, 0)
        hNeed:SetText("|cff888888NEEDED|r")

        local y          = -40
        local rowHeight  = 32
        local rowGap     = 4
        local missing    = 0
        local complete   = 0

        for _, mat in ipairs(list) do
            local row = CreateFrame("Frame", nil, content, "BackdropTemplate")
            row:SetSize(700, rowHeight)
            row:SetPoint("TOPLEFT", 8, y)
            row:SetBackdrop({
                bgFile   = "Interface\\Buttons\\WHITE8x8",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                edgeSize = 10,
                insets   = { left = 2, right = 2, top = 2, bottom = 2 }
            })

            local isComplete = (mat.remaining == 0)
            if isComplete then
                row:SetBackdropColor(0.10, 0.14, 0.11, 0.9)
                row:SetBackdropBorderColor(0.25, 0.55, 0.25, 0.7)
                complete = complete + 1
            else
                row:SetBackdropColor(0.11, 0.12, 0.18, 0.95)
                row:SetBackdropBorderColor(0.4, 0.35, 0.2, 0.8)
                missing = missing + 1
            end

            -- Item icon
            local icon = row:CreateTexture(nil, "ARTWORK")
            icon:SetSize(20, 20)
            icon:SetPoint("LEFT", 10, 0)
            icon:SetTexture(self:GetItemIcon(mat.itemID))
            icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

            -- Name
            local name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            name:SetPoint("LEFT", icon, "RIGHT", 8, 0)
            name:SetText(mat.name or "?")
            if isComplete then
                name:SetTextColor(0.55, 0.55, 0.55)
            end

            -- HAVE (owned / required)
            local have = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            have:SetPoint("RIGHT", -190, 0)
            have:SetText(string.format("%d / %d", mat.owned, mat.required))
            have:SetTextColor(0.7, 0.7, 0.7)

            -- NEEDED (highlighted)
            local needed = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            needed:SetPoint("RIGHT", -12, 0)
            if isComplete then
                needed:SetText("|cff00ff00✓ Complete|r")
            else
                needed:SetText("|cffffd700×" .. mat.remaining .. "|r")
            end

            -- Hover tooltip on the row
            row:EnableMouse(true)
            if mat.itemID and mat.itemID ~= 0 then
                row:SetScript("OnEnter", function(selfRow)
                    GameTooltip:SetOwner(selfRow, "ANCHOR_RIGHT")
                    GameTooltip:SetItemByID(mat.itemID)
                    GameTooltip:Show()
                end)
                row:SetScript("OnLeave", function()
                    GameTooltip:Hide()
                end)
            end

            y = y - rowHeight - rowGap
        end

        -- Summary line
        local summary = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        summary:SetPoint("TOPLEFT", 8, y - 8)
        summary:SetText(string.format(
            "|cff888888%d missing · %d complete|r", missing, complete))

        content:SetHeight(math.abs(y) + 40)
    end

    -- Restore the shopping sub-tab's last scroll offset
    local offset = self.levelingSubTabOffsets and self.levelingSubTabOffsets.shopping or 0
    if offset > 0 then
        scrollFrame:SetVerticalScroll(offset)
    end

    -- Mouse-wheel scroll speed
    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(f, delta)
        local current   = f:GetVerticalScroll()
        local maxScroll = f:GetVerticalScrollRange()
        local newScroll = math.min(maxScroll, math.max(0, current - (delta * 30)))
        f:SetVerticalScroll(newScroll)
    end)
end