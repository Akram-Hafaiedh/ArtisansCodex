-- ArtisansCodex Dashboard module
-- Dashboard tab UI

local _, private = ...
local addon = private.addon

private.Dashboard = private.Dashboard or {}
local Dashboard = private.Dashboard

function Dashboard:Initialize()
    private:Print("Dashboard module loaded")
end

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
    recText:SetText("You have 14 unspent Knowledge Points in Alchemy.\n\nRecommended next node:\n" ..
        "|cffFFD700Elixir Experimentation|r\n\nThis node greatly improves potion and flask efficiency.")

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

if type(addon.BuildDashboard) == "function" then
    private.Dashboard.BuildDashboard = addon.BuildDashboard
    private:Print("Dashboard module file loaded (BuildDashboard ready)")
else
    private:Print("ERROR: Dashboard failed to attach BuildDashboard")
end