-- ArtisansCodex Specializations module
-- Guide-first: build cards + step tables (wow-professions style)
-- Live path progress + tree chips + Open Spec Tree (tab-aware)

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


local function ResolveRecipeEntry(profName, spellID, name)
    local catalog = private.RecipeData and private.RecipeData[profName]
    if type(catalog) ~= "table" then return nil end
    if spellID and spellID > 0 then
        for _, e in ipairs(catalog) do
            if e.spellID == spellID then return e end
        end
    end
    if name and name ~= "" then
        local lower = string.lower(name)
        for _, e in ipairs(catalog) do
            if e.name and string.lower(e.name) == lower then return e end
        end
    end
    return nil
end

local function GetTreeIcon(tree)
    if not tree then return nil end
    local iconID = tree.icon or tree.rootIcon
    if (not iconID or iconID == 0) and tree.tabID and tree.tabID > 0
        and C_ProfSpecs and C_ProfSpecs.GetTabInfo then
        local ok, info = pcall(C_ProfSpecs.GetTabInfo, tree.tabID)
        if ok and info then
            iconID = info.rootIconID or info.iconID or info.icon
        end
    end
    if iconID and iconID ~= 0 then return iconID end
    return nil
end

local function FindTree(guide, treeName)
    if not guide or not guide.trees or not treeName then return nil end
    for _, t in ipairs(guide.trees) do
        if t.name == treeName or t.key == treeName then
            return t
        end
    end
    return nil
end

--- Config ID for this profession's specialization trait tree (live).
local function GetSpecConfigID(profName)
    local meta = GetMeta(profName)
    if not meta or not meta.variantID or not C_ProfSpecs then return nil end
    local ok, configID = pcall(C_ProfSpecs.GetConfigIDForSkillLine, meta.variantID)
    if ok and configID and configID > 0 then return configID end
    return nil
end

--- Live KP spent / max on a path node (pathID from guide data).
--- Rank convention matches Debug: spent = max(0, currentRank - 1).
function addon:GetPathProgress(profName, pathID)
    if not pathID or pathID == 0 then return nil end
    local configID = GetSpecConfigID(profName)
    if not configID or not C_Traits then return nil end
    local ok, nodeInfo = pcall(C_Traits.GetNodeInfo, configID, pathID)
    if not ok or not nodeInfo then return nil end
    local cur = nodeInfo.currentRank or 0
    local maxR = nodeInfo.maxRanks or 0
    local spent = (cur > 1) and (cur - 1) or 0
    local maxKP = (maxR > 1) and (maxR - 1) or 0
    return {
        spent = spent,
        max = maxKP,
        currentRank = cur,
        maxRanks = maxR,
        isAvailable = nodeInfo.isAvailable,
        isLocked = nodeInfo.isLocked,
        canPurchase = nodeInfo.canPurchaseRank,
    }
end

--- Light live KP totals (whole profession).
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
        if specPage then
            if type(specPage.SetSelectedTab) == "function" then
                pcall(specPage.SetSelectedTab, specPage, tabID)
            end
            -- Prefer Spec tab if the frame supports it
            if type(specPage.Show) == "function" then
                pcall(specPage.Show, specPage)
            end
        end
        local frame = _G.ProfessionsFrame
        if frame and frame.SetTab and frame.specializationsTabID then
            pcall(frame.SetTab, frame, frame.specializationsTabID)
        end
    end)
end

-- ============================================================
-- UI - build cards + steps + live progress
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
    if #builds > 0 then
        local countFS = right:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        countFS:SetPoint("TOPRIGHT", -12, -14)
        countFS:SetText(string.format("%d", #builds))
        ry = -36
    end
    if #builds == 0 then
        local emptyR = right:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        emptyR:SetPoint("TOPLEFT", 12, ry)
        emptyR:SetPoint("RIGHT", -12, 0)
        emptyR:SetJustifyH("LEFT")
        emptyR:SetWordWrap(true)
        emptyR:SetTextColor(0.62, 0.62, 0.65)
        if not guide then
            emptyR:SetText("No specialization guide for this profession yet.\n\nData is still being added.")
        elseif not learned then
            emptyR:SetText("No recommended goals listed.\n\nYou can still browse once builds are added — learning the profession is not required to read the guide.")
        else
            emptyR:SetText("No recommended goals for this profession yet.\n\nTrees may still appear in the center panel.")
        end
        ry = ry - 72
    else
        for _, build in ipairs(builds) do
            -- Completion: every step with a target has live spent >= target
            local buildDone = false
            if learned and build.steps and #build.steps > 0 then
                buildDone = true
                for _, step in ipairs(build.steps) do
                    local target = step.points or 0
                    if target > 0 and step.pathID and step.pathID > 0 then
                        local prog = self:GetPathProgress(profName, step.pathID)
                        local spent = prog and prog.spent or 0
                        if spent < target then
                            buildDone = false
                            break
                        end
                    elseif target > 0 then
                        buildDone = false
                        break
                    end
                end
            end

            local card = CreateFrame("Button", nil, right, "BackdropTemplate")
            card:SetSize(226, 40)
            card:SetPoint("TOP", 0, ry)
            ry = ry - 42
            card:SetBackdrop({
                bgFile = "Interface\\Buttons\\WHITE8x8",
                edgeFile = "Interface\\Buttons\\WHITE8x8",
                edgeSize = 1,
            })
            local active = selectedBuild and selectedBuild.key == build.key
            if active and buildDone then
                card:SetBackdropColor(0.10, 0.20, 0.12, 1)
                card:SetBackdropBorderColor(0.35, 0.80, 0.45, 1)
            elseif active then
                card:SetBackdropColor(0.28, 0.22, 0.08, 1)
                card:SetBackdropBorderColor(0.95, 0.80, 0.25, 1)
            elseif buildDone then
                card:SetBackdropColor(0.08, 0.14, 0.10, 0.95)
                card:SetBackdropBorderColor(0.28, 0.50, 0.32, 0.9)
            else
                card:SetBackdropColor(0.11, 0.12, 0.16, 0.95)
                card:SetBackdropBorderColor(0.35, 0.35, 0.40, 0.8)
            end

            local nFS = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            nFS:SetPoint("TOPLEFT", 10, -6)
            nFS:SetPoint("RIGHT", buildDone and -52 or -8, 0)
            nFS:SetJustifyH("LEFT")
            nFS:SetText(build.name or build.key)
            if buildDone then
                nFS:SetTextColor(0.55, 0.85, 0.60)
            else
                nFS:SetTextColor(1, 0.9, 0.55)
            end

            if buildDone then
                local doneFS = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                doneFS:SetPoint("TOPRIGHT", -8, -6)
                doneFS:SetText("|cff55cc77Done|r")
            end

            -- Short goal on card; full summary in tooltip
            local gFS = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            gFS:SetPoint("TOPLEFT", 10, -22)
            gFS:SetPoint("RIGHT", -8, 0)
            gFS:SetJustifyH("LEFT")
            gFS:SetWordWrap(false)
            gFS:SetText(build.goal or "")
            if buildDone then
                gFS:SetTextColor(0.50, 0.62, 0.52)
            else
                gFS:SetTextColor(0.68, 0.68, 0.68)
            end

            card:SetScript("OnClick", function()
                self.selectedSpecBuildKey = build.key
                self:BuildSpecializations()
            end)
            card:SetScript("OnEnter", function(b)
                GameTooltip:SetOwner(b, "ANCHOR_LEFT")
                GameTooltip:AddLine(build.name or "Build", 1, 0.85, 0.2)
                if buildDone then
                    GameTooltip:AddLine("Completed on this character", 0.4, 0.9, 0.55)
                end
                if build.goal and build.goal ~= "" then
                    GameTooltip:AddLine(build.goal, 0.85, 0.85, 0.75, true)
                end
                if build.summary and build.summary ~= "" and build.summary ~= build.goal then
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine(build.summary, 0.75, 0.75, 0.75, true)
                end
                GameTooltip:Show()
            end)
            card:SetScript("OnLeave", function() GameTooltip:Hide() end)
        end
    end

    -- ========== Related crafts (reverse CraftSim: tree/goal -> recipes) ==========
    local related = {}
    local seenSpell = {}
    if selectedBuild and selectedBuild.steps and guide and guide.trees then
        local treeNames = {}
        for _, step in ipairs(selectedBuild.steps) do
            if step.tree then treeNames[step.tree] = true end
        end
        for _, tree in ipairs(guide.trees) do
            if treeNames[tree.name] or treeNames[tree.key] then
                if tree.notableRecipes then
                    for _, rec in ipairs(tree.notableRecipes) do
                        local sid = rec.spellID or 0
                        local key = sid > 0 and sid or (rec.name or "")
                        if key ~= "" and key ~= 0 and not seenSpell[key] then
                            seenSpell[key] = true
                            related[#related + 1] = {
                                name = rec.name or "?",
                                spellID = sid,
                                tree = tree.name,
                            }
                        end
                    end
                end
            end
        end
    end

    -- Divider under goals
    ry = ry - 6
    local divR = right:CreateTexture(nil, "ARTWORK")
    divR:SetColorTexture(0.40, 0.35, 0.22, 0.45)
    divR:SetHeight(1)
    divR:SetPoint("TOPLEFT", 12, ry)
    divR:SetPoint("TOPRIGHT", -12, ry)
    ry = ry - 12

    local relTitle = right:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    relTitle:SetPoint("TOPLEFT", 12, ry)
    if #related > 0 then
        relTitle:SetText(string.format("|cffFFD700Related crafts|r  |cff666666%d|r", #related))
    else
        relTitle:SetText("|cffFFD700Related crafts|r")
    end
    ry = ry - 16

    -- Avoid repeating the card goal; only show a distinct summary line
    if selectedBuild and selectedBuild.summary and selectedBuild.summary ~= ""
        and selectedBuild.summary ~= selectedBuild.goal then
        local relSum = right:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        relSum:SetPoint("TOPLEFT", 12, ry)
        relSum:SetPoint("RIGHT", -12, 0)
        relSum:SetJustifyH("LEFT")
        relSum:SetTextColor(0.58, 0.58, 0.60)
        relSum:SetWordWrap(true)
        local gtxt = selectedBuild.summary:gsub("→", "->"):gsub("—", "-"):gsub("–", "-")
        relSum:SetText(gtxt)
        ry = ry - 22
    end

    -- Scrollable related-crafts list (fills rest of right panel)
    local relScroll = CreateFrame("ScrollFrame", nil, right, "UIPanelScrollFrameTemplate")
    relScroll:SetPoint("TOPLEFT", 8, ry)
    relScroll:SetPoint("BOTTOMRIGHT", -28, 12)

    local relList = CreateFrame("Frame", nil, relScroll)
    relList:SetWidth(200)
    relList:SetHeight(1)
    relScroll:SetScrollChild(relList)

    local ly = -2
    if #related == 0 then
        local emptyRel = relList:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        emptyRel:SetPoint("TOPLEFT", 4, ly)
        emptyRel:SetPoint("RIGHT", -4, 0)
        emptyRel:SetJustifyH("LEFT")
        emptyRel:SetText("No linked recipes for this goal.\nTrees may still list notables after data updates.")
        ly = ly - 20
    else
        for _, rec in ipairs(related) do
            local entry = ResolveRecipeEntry(profName, rec.spellID, rec.name)
            local itemID = entry and entry.itemID or 0
            local displayName = (entry and entry.name) or rec.name

            local row = CreateFrame("Button", nil, relList, "BackdropTemplate")
            row:SetSize(196, 24)
            row:SetPoint("TOPLEFT", 2, ly)
            ly = ly - 26
            row:SetBackdrop({
                bgFile = "Interface\\Buttons\\WHITE8x8",
                edgeFile = "Interface\\Buttons\\WHITE8x8",
                edgeSize = 1,
            })
            row:SetBackdropColor(0.10, 0.11, 0.15, 0.9)
            row:SetBackdropBorderColor(0.28, 0.28, 0.32, 0.6)

            local textLeft = 6
            if itemID and itemID > 0 then
                local icon = row:CreateTexture(nil, "ARTWORK")
                icon:SetSize(18, 18)
                icon:SetPoint("LEFT", 4, 0)
                local tex = GetItemIcon and GetItemIcon(itemID)
                if (not tex) and C_Item and C_Item.GetItemIconByID then
                    tex = C_Item.GetItemIconByID(itemID)
                end
                if tex then
                    icon:SetTexture(tex)
                    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                    textLeft = 26
                end
            end

            local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            label:SetPoint("LEFT", textLeft, 0)
            label:SetPoint("RIGHT", -4, 0)
            label:SetJustifyH("LEFT")
            label:SetWordWrap(false)
            label:SetText(displayName)
            label:SetTextColor(0.85, 0.85, 0.9)

            row:SetScript("OnEnter", function(b)
                b:SetBackdropBorderColor(0.85, 0.70, 0.25, 1)
                GameTooltip:SetOwner(b, "ANCHOR_LEFT")
                if itemID and itemID > 0 and GameTooltip.SetItemByID then
                    GameTooltip:SetItemByID(itemID)
                    GameTooltip:AddLine(" ")
                else
                    GameTooltip:AddLine(displayName, 1, 0.85, 0.2)
                end
                if rec.tree then
                    GameTooltip:AddLine("Spec tree: " .. rec.tree, 0.6, 0.75, 0.9)
                end
                if entry and entry.category then
                    GameTooltip:AddLine("Category: " .. tostring(entry.category), 0.7, 0.7, 0.7)
                end
                if rec.spellID and rec.spellID > 0 then
                    GameTooltip:AddLine("Click to open in Recipes", 0.5, 0.7, 1)
                end
                GameTooltip:Show()
            end)
            row:SetScript("OnLeave", function(b)
                b:SetBackdropBorderColor(0.28, 0.28, 0.32, 0.6)
                GameTooltip:Hide()
            end)
            if rec.spellID and rec.spellID > 0 then
                row:SetScript("OnClick", function()
                    if type(self.OpenRecipesFocus) == "function" then
                        self:OpenRecipesFocus(profName, {
                            spellID = rec.spellID,
                            itemID = itemID,
                            name = displayName,
                        })
                    else
                        self.selectedRecipesProf = profName
                        self.recipesFocusSpellID = rec.spellID
                        if type(self.SelectTab) == "function" then
                            self:SelectTab("recipes")
                        end
                    end
                end)
            end
        end
    end
    relList:SetHeight(math.max(40, -ly + 4))
    relScroll:EnableMouseWheel(true)
    relScroll:SetScript("OnMouseWheel", function(f, delta)
        local current = f:GetVerticalScroll()
        local maxScroll = f:GetVerticalScrollRange()
        local newScroll = math.min(maxScroll, math.max(0, current - (delta * 28)))
        f:SetVerticalScroll(newScroll)
    end)

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
    if not guide then
        summary:SetText("|cffaaaaaaNo specialization data for this profession yet.|r")
    elseif not learned then
        summary:SetText("|cffff9966Not learned on this character.|r Browse goals and trees below — live progress needs the profession.")
    elseif kp then
        summary:SetText(string.format(
            "Knowledge spent |cffFFD700%d|r / |cffaaaaaa%d|r  ·  Unspent |cff66ccff%d|r",
            kp.spent or 0, kp.max or 0, kp.unspent or 0
        ))
    else
        summary:SetText("|cff88aaccOpen this profession once|r so live knowledge totals and path progress can load.")
    end

    local yTop = -52

    -- Empty / partial guide states (center)
    if not guide then
        local box = CreateFrame("Frame", nil, main, "BackdropTemplate")
        box:SetPoint("TOPLEFT", 20, yTop - 8)
        box:SetPoint("TOPRIGHT", -20, yTop - 8)
        box:SetHeight(88)
        box:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        box:SetBackdropColor(0.09, 0.10, 0.13, 0.95)
        box:SetBackdropBorderColor(0.35, 0.32, 0.28, 0.7)

        local h = box:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        h:SetPoint("TOPLEFT", 14, -14)
        h:SetText("|cffFFD700Guide not ready|r")

        local b = box:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        b:SetPoint("TOPLEFT", 14, -34)
        b:SetPoint("RIGHT", -14, 0)
        b:SetJustifyH("LEFT")
        b:SetTextColor(0.68, 0.68, 0.70)
        b:SetWordWrap(true)
        b:SetText("Specialization builds and trees for " .. (profName or "this profession") .. " are not in the addon yet. Pick another profession from the sidebar, or check back after a data update.")
        yTop = yTop - 104
    elseif #trees == 0 and #builds == 0 then
        local box = CreateFrame("Frame", nil, main, "BackdropTemplate")
        box:SetPoint("TOPLEFT", 20, yTop - 8)
        box:SetPoint("TOPRIGHT", -20, yTop - 8)
        box:SetHeight(72)
        box:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        box:SetBackdropColor(0.09, 0.10, 0.13, 0.95)
        box:SetBackdropBorderColor(0.35, 0.32, 0.28, 0.7)

        local h = box:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        h:SetPoint("TOPLEFT", 14, -12)
        h:SetText("|cffFFD700Nothing to show yet|r")

        local b = box:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        b:SetPoint("TOPLEFT", 14, -32)
        b:SetPoint("RIGHT", -14, 0)
        b:SetJustifyH("LEFT")
        b:SetTextColor(0.68, 0.68, 0.70)
        b:SetWordWrap(true)
        b:SetText("This profession has a data stub but no trees or recommended goals. Other professions in the sidebar may be complete.")
        yTop = yTop - 88
    elseif not learned then
        local note = main:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        note:SetPoint("TOPLEFT", 14, yTop)
        note:SetPoint("RIGHT", -14, 0)
        note:SetJustifyH("LEFT")
        note:SetTextColor(0.75, 0.72, 0.55)
        note:SetWordWrap(true)
        note:SetText("|cffffaa66Browse mode:|r goals and trees are visible. LIVE path progress and Open require learning " .. (profName or "this profession") .. " on this character.")
        yTop = yTop - 28
    end

    -- Section: Trees (full-width rows)
    if #trees > 0 then
        local secTrees = main:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        secTrees:SetPoint("TOPLEFT", 14, yTop)
        secTrees:SetText("|cff888888TREES|r")
        yTop = yTop - 16

        local rowH, gap = 26, 3
        for _, tree in ipairs(trees) do
            local row = CreateFrame("Button", nil, main, "BackdropTemplate")
            row:SetHeight(rowH)
            row:SetPoint("TOPLEFT", 14, yTop)
            row:SetPoint("TOPRIGHT", -14, yTop)
            row:SetBackdrop({
                bgFile = "Interface\\Buttons\\WHITE8x8",
                edgeFile = "Interface\\Buttons\\WHITE8x8",
                edgeSize = 1,
            })
            row:SetBackdropColor(0.10, 0.11, 0.15, 0.9)
            row:SetBackdropBorderColor(0.28, 0.28, 0.32, 0.7)

            local iconID = GetTreeIcon(tree)
            local textLeft = 8
            if iconID then
                local iconTex = row:CreateTexture(nil, "ARTWORK")
                iconTex:SetSize(18, 18)
                iconTex:SetPoint("LEFT", 6, 0)
                iconTex:SetTexture(iconID)
                iconTex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                textLeft = 30
            end

            local textRight = -8
            if learned and tree.tabID and tree.tabID > 0 then
                local openBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
                openBtn:SetSize(44, 18)
                openBtn:SetPoint("RIGHT", -4, 0)
                openBtn:SetText("Open")
                openBtn:SetScript("OnClick", function()
                    self:OpenProfessionSpecTree(profName, tree.tabID)
                end)
                textRight = -52
            end

            local liveStr = nil
            local rootSpent, rootMax = 0, tree.maxKP or 0
            if learned and tree.rootNodeID and tree.rootNodeID > 0 then
                local prog = self:GetPathProgress(profName, tree.rootNodeID)
                if prog then
                    rootSpent = prog.spent or 0
                    if (prog.max or 0) > 0 then
                        rootMax = prog.max
                    end
                end
            end
            if rootMax > 0 then
                liveStr = string.format("%d / %d", rootSpent, rootMax)
            elseif tree.maxKP then
                liveStr = tree.maxKP .. " KP"
            end

            local kpFS = nil
            if liveStr then
                kpFS = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                kpFS:SetPoint("RIGHT", textRight, 0)
                kpFS:SetJustifyH("RIGHT")
                kpFS:SetText(liveStr)
                if rootMax > 0 and rootSpent >= rootMax then
                    kpFS:SetTextColor(0.40, 0.85, 0.50)
                    row:SetBackdropBorderColor(0.25, 0.55, 0.32, 0.9)
                elseif rootSpent > 0 then
                    kpFS:SetTextColor(0.95, 0.82, 0.40)
                    row:SetBackdropBorderColor(0.70, 0.55, 0.22, 0.85)
                else
                    kpFS:SetTextColor(0.55, 0.55, 0.58)
                end
            end

            local tName = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            tName:SetPoint("LEFT", textLeft, 0)
            if kpFS then
                tName:SetPoint("RIGHT", kpFS, "LEFT", -10, 0)
            else
                tName:SetPoint("RIGHT", textRight, 0)
            end
            tName:SetJustifyH("LEFT")
            tName:SetWordWrap(false)
            tName:SetText(tree.name or "?")
            tName:SetTextColor(1, 0.90, 0.55)

            row:SetScript("OnEnter", function(b)
                b:SetBackdropColor(0.14, 0.15, 0.20, 0.95)
                GameTooltip:SetOwner(b, "ANCHOR_CURSOR")
                GameTooltip:AddLine(tree.name or "Tree", 1, 0.85, 0.2)
                if tree.summary then
                    GameTooltip:AddLine(tree.summary, 0.8, 0.8, 0.8, true)
                end
                if tree.maxKP then
                    GameTooltip:AddLine(string.format("Capacity: %d KP", tree.maxKP), 0.6, 0.75, 0.9)
                end
                if tree.unlockSkill then
                    GameTooltip:AddLine(string.format("Unlocks at profession skill %d", tree.unlockSkill), 0.65, 0.65, 0.65)
                end
                if learned and rootMax > 0 then
                    GameTooltip:AddLine(string.format("Root path: %d / %d", rootSpent, rootMax), 0.45, 0.85, 0.55)
                end
                if learned and tree.tabID and tree.tabID > 0 then
                    GameTooltip:AddLine("Open → profession UI", 0.5, 0.7, 1)
                end
                GameTooltip:Show()
            end)
            row:SetScript("OnLeave", function(b)
                b:SetBackdropColor(0.10, 0.11, 0.15, 0.9)
                GameTooltip:Hide()
            end)

            yTop = yTop - rowH - gap
        end
        yTop = yTop - 4
    end

    -- Divider between trees and build
    local div = main:CreateTexture(nil, "ARTWORK")
    div:SetColorTexture(0.40, 0.35, 0.22, 0.45)
    div:SetHeight(1)
    div:SetPoint("TOPLEFT", 14, yTop)
    div:SetPoint("TOPRIGHT", -14, yTop)
    yTop = yTop - 10

    -- Build progress: sum min(spent, target) over steps vs total target KP
    local buildSpent, buildTarget, buildStepsDone, buildStepsTotal = 0, 0, 0, 0
    if selectedBuild and selectedBuild.steps then
        for _, step in ipairs(selectedBuild.steps) do
            local target = step.points or 0
            buildTarget = buildTarget + target
            buildStepsTotal = buildStepsTotal + 1
            local spentHere = 0
            if learned and step.pathID and step.pathID > 0 then
                local prog = self:GetPathProgress(profName, step.pathID)
                if prog then
                    spentHere = prog.spent or 0
                end
            end
            local applied = target > 0 and math.min(spentHere, target) or 0
            buildSpent = buildSpent + applied
            if target > 0 and spentHere >= target then
                buildStepsDone = buildStepsDone + 1
            elseif target == 0 and spentHere > 0 then
                buildStepsDone = buildStepsDone + 1
            end
        end
    end

    local stepHdr = main:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    stepHdr:SetPoint("TOPLEFT", 14, yTop)
    if selectedBuild then
        stepHdr:SetText("|cffFFD700" .. (selectedBuild.name or "Build") .. "|r")
    else
        stepHdr:SetText("|cffFFD700Spend order|r")
    end

    local yAfterHdr = yTop - 18

    if selectedBuild and buildTarget > 0 then
        local frac = math.min(1, buildSpent / buildTarget)
        local progLabel = main:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        progLabel:SetPoint("TOPRIGHT", -14, yTop)
        if buildSpent >= buildTarget then
            progLabel:SetText(string.format("|cff55ee77%d / %d KP|r  ·  %d/%d steps",
                buildSpent, buildTarget, buildStepsDone, buildStepsTotal))
        else
            progLabel:SetText(string.format("|cffFFD700%d|r / %d KP  ·  %d/%d steps",
                buildSpent, buildTarget, buildStepsDone, buildStepsTotal))
        end

        -- Frame track: Textures cannot use OnSizeChanged / HookScript
        local barTrack = CreateFrame("Frame", nil, main)
        barTrack:SetHeight(5)
        barTrack:SetPoint("TOPLEFT", 14, yTop - 18)
        barTrack:SetPoint("TOPRIGHT", -14, yTop - 18)

        local barBg = barTrack:CreateTexture(nil, "ARTWORK")
        barBg:SetAllPoints()
        barBg:SetColorTexture(0.14, 0.14, 0.17, 0.95)

        local barFill = barTrack:CreateTexture(nil, "OVERLAY")
        if frac >= 1 then
            barFill:SetColorTexture(0.25, 0.75, 0.40, 0.95)
        else
            barFill:SetColorTexture(0.90, 0.72, 0.25, 0.95)
        end
        barFill:SetHeight(5)
        barFill:SetPoint("TOPLEFT", barTrack, "TOPLEFT", 0, 0)
        barFill:SetWidth(2)
        barTrack:SetScript("OnSizeChanged", function(f, w)
            barFill:SetWidth(math.max(2, (w or 0) * frac))
        end)
        C_Timer.After(0, function()
            local w = barTrack:GetWidth() or 0
            if w > 0 then barFill:SetWidth(math.max(2, w * frac)) end
        end)

        yAfterHdr = yTop - 30
    end

    -- Center blurb only when summary adds more than the card goal line
    if selectedBuild and selectedBuild.summary and selectedBuild.summary ~= ""
        and selectedBuild.summary ~= selectedBuild.goal then
        local sum = main:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        sum:SetPoint("TOPLEFT", 14, yAfterHdr)
        sum:SetPoint("RIGHT", -14, 0)
        sum:SetJustifyH("LEFT")
        sum:SetTextColor(0.62, 0.62, 0.65)
        local raw = selectedBuild.summary:gsub("→", "->"):gsub("—", "-"):gsub("–", "-")
        sum:SetText(raw)
        yAfterHdr = yAfterHdr - 16
    end

    local orderLbl = main:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    orderLbl:SetPoint("TOPLEFT", 14, yAfterHdr)
    orderLbl:SetText("|cff888888SPEND ORDER|r")
    yAfterHdr = yAfterHdr - 14

    -- Column headers: # | WHERE (flex) | LIVE | NEED
    local NEED_W, LIVE_W, COL_GAP = 48, 60, 10
    local colHdr = CreateFrame("Frame", nil, main)
    colHdr:SetPoint("TOPLEFT", 12, yAfterHdr)
    colHdr:SetPoint("TOPRIGHT", -28, yAfterHdr)
    colHdr:SetHeight(14)

    local colNum = colHdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    colNum:SetPoint("LEFT", 6, 0)
    colNum:SetText("|cff888888#|r")

    local colNeed = colHdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    colNeed:SetPoint("RIGHT", -4, 0)
    colNeed:SetWidth(NEED_W)
    colNeed:SetJustifyH("RIGHT")
    colNeed:SetText("|cff888888NEED|r")

    local colLive = colHdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    colLive:SetPoint("RIGHT", colNeed, "LEFT", -COL_GAP, 0)
    colLive:SetWidth(LIVE_W)
    colLive:SetJustifyH("RIGHT")
    colLive:SetText("|cff888888LIVE|r")

    local colWhere = colHdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    colWhere:SetPoint("LEFT", 28, 0)
    colWhere:SetPoint("RIGHT", colLive, "LEFT", -COL_GAP, 0)
    colWhere:SetJustifyH("LEFT")
    colWhere:SetText("|cff888888WHERE|r")

    yAfterHdr = yAfterHdr - 14

    local scroll = CreateFrame("ScrollFrame", nil, main, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 8, yAfterHdr)
    scroll:SetPoint("BOTTOMRIGHT", -28, 10)

    local list = CreateFrame("Frame", nil, scroll)
    list:SetWidth(1)
    list:SetHeight(1)
    scroll:SetScrollChild(list)

    local function SyncListWidth()
        local w = scroll:GetWidth() or 0
        if w > 16 then
            list:SetWidth(w - 8)
        end
    end
    scroll:HookScript("OnSizeChanged", SyncListWidth)
    C_Timer.After(0, SyncListWidth)

    local steps = selectedBuild and selectedBuild.steps or {}
    local y = -4

    local nextStepIndex = nil
    for i, step in ipairs(steps) do
        local target = step.points or 0
        local spent = 0
        if learned and step.pathID and step.pathID > 0 then
            local prog = self:GetPathProgress(profName, step.pathID)
            if prog then spent = prog.spent or 0 end
        end
        local done = (target > 0 and spent >= target) or (target == 0 and spent > 0)
        if not done then
            nextStepIndex = i
            break
        end
    end

    for i, step in ipairs(steps) do
        local row = CreateFrame("Button", nil, list, "BackdropTemplate")
        row:SetHeight(38)
        row:SetPoint("TOPLEFT", 4, y)
        row:SetPoint("TOPRIGHT", -4, y)
        row:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })

        local progress = nil
        if learned and step.pathID and step.pathID > 0 then
            progress = self:GetPathProgress(profName, step.pathID)
        end
        local target = step.points or 0
        local spent = progress and progress.spent or 0
        local done = (target > 0 and spent >= target) or (progress and progress.max > 0 and spent >= progress.max and target == 0)
        local partial = spent > 0 and not done
        local isNext = (nextStepIndex == i) and not done

        if done then
            row:SetBackdropColor(0.08, 0.16, 0.10, 0.95)
            row:SetBackdropBorderColor(0.25, 0.55, 0.30, 0.85)
        elseif isNext then
            row:SetBackdropColor(0.18, 0.15, 0.06, 0.98)
            row:SetBackdropBorderColor(1.0, 0.82, 0.25, 1)
        elseif partial then
            row:SetBackdropColor(0.16, 0.14, 0.08, 0.95)
            row:SetBackdropBorderColor(0.70, 0.55, 0.20, 0.85)
        else
            row:SetBackdropColor(0.10, 0.11, 0.15, 0.95)
            row:SetBackdropBorderColor(0.28, 0.28, 0.32, 0.7)
        end

        local num = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        num:SetPoint("LEFT", 8, 0)
        if isNext then
            num:SetText("|cffFFD700>|r")
            num:SetTextColor(1, 0.85, 0.3)
        else
            num:SetText(tostring(i))
            num:SetTextColor(0.85, 0.75, 0.4)
        end

        if isNext then
            local nextTag = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            nextTag:SetPoint("BOTTOMLEFT", 6, 3)
            nextTag:SetText("|cffFFD700NEXT|r")
        end

        local pts = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        pts:SetPoint("RIGHT", -8, 0)
        pts:SetWidth(NEED_W)
        pts:SetJustifyH("RIGHT")
        pts:SetText("+" .. tostring(target))
        pts:SetTextColor(0.45, 0.85, 0.55)

        local liveFS = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        liveFS:SetPoint("RIGHT", pts, "LEFT", -COL_GAP, 0)
        liveFS:SetWidth(LIVE_W)
        liveFS:SetJustifyH("RIGHT")
        if progress then
            local maxShow = progress.max or 0
            liveFS:SetText(string.format("%d/%d", spent, maxShow))
            if done then
                liveFS:SetTextColor(0.35, 0.90, 0.45)
            elseif partial then
                liveFS:SetTextColor(1.0, 0.85, 0.35)
            else
                liveFS:SetTextColor(0.65, 0.65, 0.65)
            end
        else
            liveFS:SetText(learned and "-" or ".")
            liveFS:SetTextColor(0.45, 0.45, 0.45)
        end

        local stepTree = FindTree(guide, step.tree)
        local stepIcon = GetTreeIcon(stepTree)
        local nameLeft = 28
        if stepIcon then
            local iconTex = row:CreateTexture(nil, "ARTWORK")
            iconTex:SetSize(18, 18)
            iconTex:SetPoint("LEFT", 26, 0)
            iconTex:SetTexture(stepIcon)
            iconTex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            nameLeft = 48
        end

        local where = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        where:SetPoint("LEFT", nameLeft, 0)
        where:SetPoint("RIGHT", liveFS, "LEFT", -COL_GAP, 0)
        where:SetJustifyH("LEFT")
        local whereText
        if step.tree and step.node and step.tree ~= step.node then
            whereText = step.node
        else
            whereText = step.node or step.tree or "?"
        end
        where:SetText(whereText)
        where:SetWordWrap(false)
        if done then
            where:SetTextColor(0.55, 0.75, 0.55)
        end

        if step.tree and step.node and step.tree ~= step.node then
            local treeTag = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            treeTag:SetPoint("TOPLEFT", where, "BOTTOMLEFT", 0, 0)
            treeTag:SetPoint("RIGHT", liveFS, "LEFT", -COL_GAP, 0)
            treeTag:SetJustifyH("LEFT")
            treeTag:SetText(step.tree)
        end

        local stepTab = stepTree and stepTree.tabID or 0

        row:SetScript("OnEnter", function(b)
            GameTooltip:SetOwner(b, "ANCHOR_CURSOR")
            GameTooltip:AddLine(whereText, 1, 0.85, 0.2)
            if isNext then
                GameTooltip:AddLine("Next spend", 1, 0.85, 0.3)
            end
            if progress then
                GameTooltip:AddDoubleLine(
                    "Live",
                    string.format("%d / %d", progress.spent or 0, progress.max or 0),
                    0.65, 0.75, 0.9, 0.9, 0.9, 0.9
                )
                GameTooltip:AddDoubleLine("Need", "+" .. tostring(target), 0.45, 0.85, 0.55, 0.45, 0.85, 0.55)
                if progress.isLocked then
                    GameTooltip:AddLine("Locked", 1, 0.4, 0.4)
                elseif progress.canPurchase then
                    GameTooltip:AddLine("Can spend here", 0.4, 0.9, 0.5)
                end
            else
                GameTooltip:AddLine("Need +" .. tostring(target), 0.45, 0.85, 0.55)
            end
            if step.note and step.note ~= "" then
                GameTooltip:AddLine(step.note, 0.75, 0.75, 0.75, true)
            end
            if learned and stepTab and stepTab > 0 then
                GameTooltip:AddLine("Click to open tree", 0.5, 0.7, 1)
            end
            GameTooltip:Show()
        end)
        row:SetScript("OnLeave", function() GameTooltip:Hide() end)
        if learned and stepTab and stepTab > 0 then
            row:SetScript("OnClick", function()
                self:OpenProfessionSpecTree(profName, stepTab)
            end)
        end

        y = y - 40
    end

    if #steps == 0 then
        local no = list:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        no:SetPoint("TOPLEFT", 8, y)
        no:SetTextColor(0.6, 0.6, 0.6)
        no:SetText("This goal has no spend order yet. Pick another goal, or check back after a data update.")
        y = y - 24
    end
    list:SetHeight(math.max(40, -y + 8))
    SyncListWidth()

    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(f, delta)
        local current = f:GetVerticalScroll()
        local maxScroll = f:GetVerticalScrollRange()
        local newScroll = math.min(maxScroll, math.max(0, current - (delta * 30)))
        f:SetVerticalScroll(newScroll)
    end)
end


if type(addon.BuildSpecializations) == "function" then
    private.Specializations.BuildSpecializations = addon.BuildSpecializations
    private:Print("Specializations module file loaded (BuildSpecializations ready)")
end