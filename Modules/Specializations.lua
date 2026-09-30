-- ArtisansCodex Specializations module
-- Guide-first: build cards + step tables (wow-professions style)
-- Live KP strip + Open Spec Tree; raw node dumps are Debug → Specs only

local _, private = ...
local addon = private.addon

private.Specializations = private.Specializations or {}
local Specializations = private.Specializations

function Specializations:Initialize()
    private:Print("Specializations module loaded")
end

local function GetMeta(profName)
    local metaTable = private.ProgressMeta
    if not metaTable or not metaTable.professions then return nil end
    return metaTable.professions[profName]
end

local function GetGuide(profName)
    local data = private.SpecGuideData
    if type(data) ~= "table" then return nil end
    return data[profName]
end

--- Light live KP totals (Progress-style walk). Optional.
function addon:GetProfessionKnowledgeTotals(profName)
    local meta = GetMeta(profName)
    if not meta or not meta.variantID or not C_ProfSpecs or not C_Traits then
        return nil
    end
    local unspent = 0
    if C_ProfSpecs.GetCurrencyInfoForSkillLine then
        local ok, info = pcall(C_ProfSpecs.GetCurrencyInfoForSkillLine, meta.variantID)
        if ok and info then unspent = info.numAvailable or info.quantity or 0 end
    end
    local spent, maxK = 0, 0
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
                            if maxRanks > 1 then maxK = maxK + (maxRanks - 1) end
                            local cur = nodeInfo.currentRank or 0
                            if cur > 1 then spent = spent + (cur - 1) end
                        end
                    end
                end
            end
        end
    end
    return { spent = spent, max = maxK, unspent = unspent }
end

function addon:OpenProfessionSpecTree(profName, tabID)
    local skillLineID = self:GetLearnedSkillLineID(profName)
    if not skillLineID then
        private:Print("|cffff6666" .. (profName or "?") .. " is not learned on this character.|r")
        return
    end
    if C_TradeSkillUI and C_TradeSkillUI.OpenTradeSkill then
        C_TradeSkillUI.OpenTradeSkill(skillLineID)
    end
    if self.mainFrame then self.mainFrame:Hide() end
    if not tabID or tabID == 0 then return end
    C_Timer.After(0.35, function()
        local specPage = _G.ProfessionsFrame and _G.ProfessionsFrame.SpecPage
        if specPage and type(specPage.SetSelectedTab) == "function" then
            pcall(specPage.SetSelectedTab, specPage, tabID)
        end
    end)
end

-- ============================================================
-- UI — build cards + steps
-- ============================================================

function addon:BuildSpecializations()
    local page = self.mainFrame and self.mainFrame.tabContents and self.mainFrame.tabContents["specializations"]
    if not page then return end

    if type(self.ClearPage) == "function" then
        self:ClearPage(page)
    else
        for _, child in pairs({ page:GetChildren() }) do
            child:Hide()
            child:SetParent(nil)
        end
    end

    self.selectedSpecProf = self:BuildProfessionSidebar(page, {
        selected = self.selectedSpecProf or "Tailoring",
        filter = "specializations",
        showLearned = true,
        onSelect = function(name)
            self.selectedSpecProf = name
            self.selectedSpecBuildKey = nil
            self:BuildSpecializations()
        end,
    })

    local profName = self.selectedSpecProf or "Tailoring"
    local learned = self:IsProfessionLearned(profName)
    local guide = GetGuide(profName)
    local kp = learned and self:GetProfessionKnowledgeTotals(profName) or nil
    local builds = guide and guide.builds or {}
    local trees = guide and guide.trees or {}

    if self.selectedSpecBuildKey == nil and builds[1] then
        self.selectedSpecBuildKey = builds[1].key
    end
    local selectedBuild
    for _, b in ipairs(builds) do
        if b.key == self.selectedSpecBuildKey then
            selectedBuild = b
            break
        end
    end
    if not selectedBuild and builds[1] then
        selectedBuild = builds[1]
        self.selectedSpecBuildKey = selectedBuild.key
    end

    -- ========== RIGHT: goals + actions ==========
    local right = CreateFrame("Frame", nil, page, "BackdropTemplate")
    right:SetPoint("TOPRIGHT", -12, -12)
    right:SetPoint("BOTTOMRIGHT", -12, 12)
    right:SetWidth(250)
    right:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    right:SetBackdropColor(0.09, 0.10, 0.15, 0.95)
    right:SetBackdropBorderColor(0.45, 0.38, 0.2, 0.9)

    local rightTitle = right:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rightTitle:SetPoint("TOPLEFT", 12, -12)
    rightTitle:SetText("|cffFFD700Choose a goal|r")

    local ry = -34
    if #builds == 0 then
        local emptyR = right:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        emptyR:SetPoint("TOPLEFT", 12, ry)
        emptyR:SetPoint("RIGHT", -12, 0)
        emptyR:SetJustifyH("LEFT")
        emptyR:SetTextColor(0.6, 0.6, 0.6)
        emptyR:SetText("No builds yet.\nUse Debug → Specs\nto export trees, then\nadd builds in data.")
        ry = ry - 60
    else
        for _, build in ipairs(builds) do
            local card = CreateFrame("Button", nil, right, "BackdropTemplate")
            card:SetSize(226, 48)
            card:SetPoint("TOP", 0, ry)
            ry = ry - 54
            card:SetBackdrop({
                bgFile = "Interface\\Buttons\\WHITE8x8",
                edgeFile = "Interface\\Buttons\\WHITE8x8",
                edgeSize = 1,
            })
            local active = selectedBuild and selectedBuild.key == build.key
            if active then
                card:SetBackdropColor(0.28, 0.22, 0.08, 1)
                card:SetBackdropBorderColor(0.95, 0.80, 0.25, 1)
            else
                card:SetBackdropColor(0.11, 0.12, 0.16, 0.95)
                card:SetBackdropBorderColor(0.35, 0.35, 0.40, 0.8)
            end
            local nFS = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            nFS:SetPoint("TOPLEFT", 8, -6)
            nFS:SetPoint("RIGHT", -6, 0)
            nFS:SetJustifyH("LEFT")
            nFS:SetText(build.name or build.key)
            nFS:SetTextColor(1, 0.9, 0.55)
            local gFS = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            gFS:SetPoint("TOPLEFT", 8, -24)
            gFS:SetPoint("RIGHT", -6, 0)
            gFS:SetJustifyH("LEFT")
            gFS:SetText(build.goal or "")
            gFS:SetTextColor(0.7, 0.7, 0.7)
            card:SetScript("OnClick", function()
                self.selectedSpecBuildKey = build.key
                self:BuildSpecializations()
            end)
            card:SetScript("OnEnter", function(b)
                GameTooltip:SetOwner(b, "ANCHOR_LEFT")
                GameTooltip:AddLine(build.name or "Build", 1, 0.85, 0.2)
                if build.summary then
                    GameTooltip:AddLine(build.summary, 0.8, 0.8, 0.8, true)
                end
                GameTooltip:Show()
            end)
            card:SetScript("OnLeave", function() GameTooltip:Hide() end)
        end
    end

    local openBtn = CreateFrame("Button", nil, right, "UIPanelButtonTemplate")
    openBtn:SetSize(226, 26)
    openBtn:SetPoint("BOTTOM", 0, 16)
    openBtn:SetText("Open Spec Tree")
    if not learned then
        openBtn:Disable()
    else
        openBtn:SetScript("OnClick", function()
            self:OpenProfessionSpecTree(profName, nil)
        end)
    end

    -- ========== CENTER: KP + trees + spend details ==========
    local main = CreateFrame("Frame", nil, page, "BackdropTemplate")
    main:SetPoint("TOPLEFT", 215, -12)
    main:SetPoint("BOTTOMRIGHT", -280, 12)
    main:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    main:SetBackdropColor(0.07, 0.08, 0.13, 0.95)
    main:SetBackdropBorderColor(0.45, 0.38, 0.2, 0.9)

    local title = main:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 14, -12)
    title:SetText("|cffFFD700" .. profName .. " Specializations|r")

    local summary = main:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    summary:SetPoint("TOPLEFT", 14, -32)
    summary:SetTextColor(0.7, 0.7, 0.7)
    if not learned then
        summary:SetText("|cffff8866Not learned on this character.|r You can still browse recommended builds.")
    elseif kp then
        summary:SetText(string.format(
            "Knowledge spent |cffFFD700%d|r / |cffaaaaaa%d|r  ·  Unspent |cff66ccff%d|r",
            kp.spent or 0, kp.max or 0, kp.unspent or 0
        ))
    else
        summary:SetText("Open this profession once to load live knowledge totals.")
    end

    local yTop = -52


    -- Divider
    local div = main:CreateTexture(nil, "ARTWORK")
    div:SetHeight(1)
    div:SetPoint("TOPLEFT", 14, yTop)
    div:SetPoint("TOPRIGHT", -14, yTop)
    div:SetColorTexture(0.4, 0.35, 0.22, 0.55)
    yTop = yTop - 12

    -- Build detail header
    local stepHdr = main:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    stepHdr:SetPoint("TOPLEFT", 14, yTop)
    if selectedBuild then
        stepHdr:SetText("|cffFFD700" .. (selectedBuild.name or "Build") .. "|r")
    else
        stepHdr:SetText("|cffFFD700Spend order|r")
    end
    yTop = yTop - 18

    if selectedBuild and (selectedBuild.summary or selectedBuild.goal) then
        local sum = main:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        sum:SetPoint("TOPLEFT", 14, yTop)
        sum:SetPoint("RIGHT", -14, 0)
        sum:SetJustifyH("LEFT")
        sum:SetTextColor(0.7, 0.7, 0.7)
        sum:SetText(selectedBuild.summary or selectedBuild.goal or "")
        yTop = yTop - 20
    end

    if #builds == 0 then
        local empty = main:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        empty:SetPoint("TOPLEFT", 14, yTop)
        empty:SetPoint("RIGHT", -14, 0)
        empty:SetJustifyH("LEFT")
        empty:SetTextColor(0.7, 0.7, 0.7)
        empty:SetText(
            "No guide builds for " .. profName .. " yet.\n\n" ..
            "1. Open the profession Spec page\n" ..
            "2. Debug → Specs → Scan → Export\n" ..
            "3. Add builds under Data/Midnight/Specializations/"
        )
        return
    end

    -- Column headers
    local hY = yTop
    local h1 = main:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    h1:SetPoint("TOPLEFT", 22, hY)
    h1:SetText("#")
    local h2 = main:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    h2:SetPoint("TOPLEFT", 48, hY)
    h2:SetText("WHERE")
    local h3 = main:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    h3:SetPoint("TOPLEFT", 300, hY)
    h3:SetText("PTS")
    local h4 = main:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    h4:SetPoint("TOPLEFT", 340, hY)
    h4:SetText("WHY")
    yTop = yTop - 16

    local scroll = CreateFrame("ScrollFrame", nil, main, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 10, yTop)
    scroll:SetPoint("BOTTOMRIGHT", -28, 12)

    local list = CreateFrame("Frame", nil, scroll)
    list:SetSize(1, 1)
    scroll:SetScrollChild(list)

    local steps = selectedBuild and selectedBuild.steps or {}
    local y = 0
    local rowW = math.max(420, (main:GetWidth() or 500) - 50)

    for i, step in ipairs(steps) do
        local row = CreateFrame("Frame", nil, list, "BackdropTemplate")
        row:SetSize(rowW, 40)
        row:SetPoint("TOPLEFT", 4, y)
        row:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        row:SetBackdropColor(0.10, 0.11, 0.15, 0.95)
        row:SetBackdropBorderColor(0.28, 0.28, 0.32, 0.7)

        local num = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        num:SetPoint("LEFT", 8, 0)
        num:SetText(tostring(i))
        num:SetTextColor(0.85, 0.75, 0.4)

        local where = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        where:SetPoint("LEFT", 32, 0)
        where:SetWidth(250)
        where:SetJustifyH("LEFT")
        local whereText = step.node or step.tree or "?"
        if step.tree and step.node and step.tree ~= step.node then
            whereText = (step.tree or "") .. "  →  " .. (step.node or "")
        end
        where:SetText(whereText)
        where:SetWordWrap(false)

        local pts = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        pts:SetPoint("LEFT", 290, 0)
        pts:SetText("+" .. tostring(step.points or 0))
        pts:SetTextColor(0.45, 0.85, 0.55)

        local why = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        why:SetPoint("LEFT", 330, 0)
        why:SetPoint("RIGHT", -10, 0)
        why:SetJustifyH("LEFT")
        why:SetText(step.note or "")
        why:SetTextColor(0.65, 0.65, 0.65)
        why:SetWordWrap(false)

        row:SetScript("OnEnter", function(b)
            if step.note and step.note ~= "" then
                GameTooltip:SetOwner(b, "ANCHOR_CURSOR")
                GameTooltip:AddLine(whereText, 1, 0.85, 0.2)
                GameTooltip:AddLine("+" .. tostring(step.points or 0) .. " knowledge", 0.45, 0.85, 0.55)
                GameTooltip:AddLine(step.note, 0.8, 0.8, 0.8, true)
                GameTooltip:Show()
            end
        end)
        row:SetScript("OnLeave", function() GameTooltip:Hide() end)

        y = y - 44
    end

    if #steps == 0 then
        local no = list:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        no:SetPoint("TOPLEFT", 8, y)
        no:SetTextColor(0.6, 0.6, 0.6)
        no:SetText("No steps defined for this build yet.")
        y = y - 24
    end
    list:SetSize(rowW, math.max(40, -y + 8))
end

if type(addon.BuildSpecializations) == "function" then
    private.Specializations.BuildSpecializations = addon.BuildSpecializations
    private:Print("Specializations module file loaded (BuildSpecializations ready)")
end