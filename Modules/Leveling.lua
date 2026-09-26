-- ArtisansCodex Leveling module
-- Leveling tab UI and shopping list

local _, private = ...
local addon = private.addon

private.Leveling = private.Leveling or {}
local Leveling = private.Leveling

function Leveling:Initialize()
    private:Print("Leveling module loaded")
end

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

    if type(self.BuildProfessionSidebar) ~= "function" then
        private:Print("|cffff4444ERROR:|r ProfessionSidebar not loaded. Ensure Modules/ProfessionSidebar.lua is present and listed in ArtisansCodex.toc before the tab modules.")
        return
    end

    self.selectedLevelingProf = self:BuildProfessionSidebar(page, {
        selected    = self.selectedLevelingProf or "Tailoring",
        filter      = "leveling",
        showLearned = true,
        onSelect    = function(name)
            if self.levelingScrollFrame then
                self.levelingSubTabOffsets[self.levelingSubTab] =
                    self.levelingScrollFrame:GetVerticalScroll() or 0
            end
            self.selectedLevelingProf = name
            self:BuildLeveling()
        end,
    })

    local profData = private.Data[self.selectedLevelingProf]
    -- Path selection (Slow / Rush) - global across professions for now
    self.selectedPath = self.selectedPath or "slow"
    if profData then
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

        -- Pin Trainer button - anchored to the bottom-right of the trainer column
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

    -- Skill meter from Artisan's Progress scan (this character)
    local snap = self.GetProfessionSnapshot and self:GetProfessionSnapshot(self.selectedLevelingProf)
    local skillCur = snap and snap.skillLevel or 0
    local skillMax = snap and snap.skillMaxLevel or 0
    if (skillMax or 0) == 0 and self.IsProfessionLearned and self:IsProfessionLearned(self.selectedLevelingProf) then
        -- fallback live API if snapshot empty
        local skillLineID = self.GetLearnedSkillLineID and self:GetLearnedSkillLineID(self.selectedLevelingProf)
        if skillLineID and GetProfessionInfo then
            -- skill levels already on snapshot after scan; leave zeros if unknown
        end
    end
    if self.CreateStatusMeter then
        local skillMeter = self:CreateStatusMeter(leftCol, {
            width = 220,
            height = 12,
            value = skillCur,
            maxValue = skillMax,
            r = 0.35, g = 0.85, b = 0.45,
            emptyText = "Not learned / not scanned",
        })
        skillMeter:SetPoint("TOPLEFT", 0, -32)
    end

    -- Row 2: Overview (full width of the LEFT column, with right inset)
    local overview = leftCol:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    overview:SetPoint("TOPLEFT", 0, -54)
    overview:SetPoint("TOPRIGHT", -10, -54)          -- ← 10px inset from divider
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
    knowledgeBtn:SetSize(172, 22)
    knowledgeBtn:SetPoint("LEFT", specBtn, "RIGHT", 8, 0)
    knowledgeBtn:SetText("Knowledge & Treasures")
    knowledgeBtn:SetScript("OnClick", function()
        self.selectedKnowledgeProf = self.selectedLevelingProf
        self:SelectTab("knowledge")
    end)


    -- ----------------------------------------------------------
    -- SUB-TAB BAR - Steps / Shopping List
    -- ----------------------------------------------------------
    self.levelingSubTab = self.levelingSubTab or "steps"
    self.levelingSubTabOffsets = self.levelingSubTabOffsets or { steps = 0, shopping = 0 }
    self.selectedAlternatives = self.selectedAlternatives or {}

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

    -- Measures how tall a wrapped FontString will render at a given width,
    -- using a throwaway probe. Used so row/container heights can grow to
    -- fit long notes instead of letting them overflow into whatever is
    -- anchored below (this is what was causing the overlapping text).
    local SINGLE_LINE_H = 14
    local function MeasureNoteHeight(text, width)
        if not text or text == "" then return 0 end
        local probe = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        probe:SetWidth(width)
        probe:SetJustifyH("LEFT")
        probe:SetText(text)
        local h = probe:GetStringHeight() or SINGLE_LINE_H
        probe:Hide()
        probe:SetParent(nil)
        return h
    end

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
        -- FORK ENTRY - a bounded section that wraps the tabs AND all
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
                    if s.alternatives and #s.alternatives > 0 then
                        rH = rH + 32   -- extra row for the pill selector
                    end
                    if s.specAction == "open_tree" then
                        rH = rH + 40
                    end
                    if s.note and s.note ~= "" then
                        local noteH = MeasureNoteHeight(s.note, 684 - 100)
                        rH = rH + math.max(0, noteH - SINGLE_LINE_H)
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

            -- Tabs - horizontally CENTERED within the container
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
                -- rowWidth only depends on whether this step lives inside an
                -- open path container, so resolve it before rowHeight (the
                -- note-height measurement below needs it).
                local rowWidth = (step.path and activeContainer) and 684 or 700

                local rowHeight = 106
                if step.crafts and #step.crafts > 0 then
                    rowHeight = 60 + math.ceil(#step.crafts / 3.5) * 22 + 30
                end

                if step.alternatives and #step.alternatives > 0 then
                    rowHeight = rowHeight + 32
                end

                -- Reserve extra vertical space for the spec footer if present
                if step.specAction == "open_tree" then
                    rowHeight = rowHeight + 40
                end

                -- Reserve extra vertical space for notes that wrap past one
                -- line, so the footer/next row don't overlap the note text.
                if step.note and step.note ~= "" then
                    local noteH = MeasureNoteHeight(step.note, rowWidth - 100)
                    rowHeight = rowHeight + math.max(0, noteH - SINGLE_LINE_H)
                end

                -- Choose parent + Y position:
                --   - if this step declares a path AND a container is open,
                --     it lives inside the container
                --   - otherwise it goes on the raw scroll content
                local parent, renderY
                if step.path and activeContainer then
                    parent    = activeContainer

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
                -- RECIPE + MATERIALS
                -- Two modes:
                --   1. Step has `alternatives` → render pill selector,
                --      then the selected alternative's materials.
                --   2. Normal step → recipe name + icon + materials.
                -- ============================================================
                local contentY = -50
                local hasContent = false

                if step.alternatives and #step.alternatives > 0 then
                    -- ---- Alternative selection state ----
                    local altKey = (profData.name or "?") .. "|" ..
                                   (step.path or "shared") .. "|" .. (step.range or "?")
                    local selectedKey = self.selectedAlternatives[altKey]
                    if not selectedKey then
                        selectedKey = step.alternatives[1].key
                        self.selectedAlternatives[altKey] = selectedKey
                    end

                    local selectedAlt
                    for _, alt in ipairs(step.alternatives) do
                        if alt.key == selectedKey then selectedAlt = alt; break end
                    end
                    if not selectedAlt then selectedAlt = step.alternatives[1] end

                    -- ---- Quantity ----
                    local altY = -28
                    local altX = 12
                    if step.quantity and step.quantity > 1 then
                        local quantityText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                        quantityText:SetPoint("TOPLEFT", altX, altY)
                        quantityText:SetText(step.quantity .. "x")
                        quantityText:SetTextColor(1, 1, 1)
                        altX = altX + quantityText:GetStringWidth() + 8
                    end

                    -- ---- Pills ----
                    local pillW, pillH, pillGap = 180, 26, 6
                    for _, alt in ipairs(step.alternatives) do
                        local pill = CreateFrame("Button", nil, row, "BackdropTemplate")
                        pill:SetSize(pillW, pillH)
                        pill:SetPoint("TOPLEFT", altX, altY - 2)
                        pill:SetBackdrop({
                            bgFile   = "Interface\\Buttons\\WHITE8x8",
                            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                            edgeSize = 10,
                            insets   = { left = 1, right = 1, top = 1, bottom = 1 }
                        })

                        local isActive = (alt.key == selectedKey)
                        if isActive then
                            pill:SetBackdropColor(0.35, 0.28, 0.10, 1)
                            pill:SetBackdropBorderColor(0.9, 0.75, 0.25, 1)
                        else
                            pill:SetBackdropColor(0.10, 0.11, 0.14, 1)
                            pill:SetBackdropBorderColor(0.35, 0.32, 0.22, 0.8)
                        end

                        local pillIcon = pill:CreateTexture(nil, "ARTWORK")
                        pillIcon:SetSize(16, 16)
                        pillIcon:SetPoint("LEFT", 8, 0)
                        pillIcon:SetTexture(addon:GetItemIcon(alt.itemID))
                        pillIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

                        local pillLbl = pill:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                        pillLbl:SetPoint("LEFT", pillIcon, "RIGHT", 6, 0)
                        pillLbl:SetPoint("RIGHT", -8, 0)
                        pillLbl:SetJustifyH("LEFT")
                        pillLbl:SetText(alt.label or alt.key)
                        if isActive then
                            pillLbl:SetTextColor(1, 0.9, 0.5)
                        else
                            pillLbl:SetTextColor(0.75, 0.75, 0.75)
                        end

                        pill:SetScript("OnClick", function()
                            if self.levelingScrollFrame then
                                self.levelingSubTabOffsets.steps =
                                    self.levelingScrollFrame:GetVerticalScroll() or 0
                            end
                            self.selectedAlternatives[altKey] = alt.key
                            self:BuildLeveling()
                        end)

                        altX = altX + pillW + pillGap
                    end

                    -- ---- Selected alternative's materials ----
                    if selectedAlt and selectedAlt.materials and #selectedAlt.materials > 0 then
                        hasContent = true
                        local matX = 12
                        -- Position below the actual bottom edge of the pill
                        -- buttons (altY - 2 - pillH), not a hardcoded offset,
                        -- so the label doesn't render on top of the pills.
                        local matY = altY - 2 - pillH - 8

                        local matsLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                        matsLabel:SetPoint("TOPLEFT", matX, matY)
                        matsLabel:SetText("|cff888888Mats:|r")
                        matX = matX + matsLabel:GetStringWidth() + 8

                        for _, mat in ipairs(selectedAlt.materials) do
                            local amountText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                            amountText:SetPoint("TOPLEFT", matX, matY)
                            amountText:SetText(mat.amount .. "x")
                            amountText:SetTextColor(0.9, 0.9, 0.9)
                            matX = matX + amountText:GetStringWidth() + 4

                            local matIcon = row:CreateTexture(nil, "ARTWORK")
                            matIcon:SetSize(16, 16)
                            matIcon:SetPoint("TOPLEFT", matX, matY + 1)
                            matIcon:SetTexture(addon:GetItemIcon(mat.itemID))
                            matIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                            matX = matX + 18

                            local matText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                            matText:SetPoint("TOPLEFT", matX, matY)
                            matText:SetText(mat.name)
                            matText:SetTextColor(0.75, 0.75, 0.75)
                            matX = matX + matText:GetStringWidth() + 14
                        end

                        contentY = matY
                    end

                else
                    -- ============================================================
                    -- NORMAL STEP - recipe name + icon + materials
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
                                sep:SetText("|cff666666-|r")
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
                    local footerDivider = row:CreateTexture(nil, "ARTWORK")
                    footerDivider:SetHeight(1)
                    footerDivider:SetColorTexture(0.4, 0.35, 0.2, 0.6)
                    footerDivider:SetPoint("BOTTOMLEFT", 12, 36)
                    footerDivider:SetPoint("BOTTOMRIGHT", -12, 36)

                    -- Left: short call to action
                    local specLbl = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                    specLbl:SetPoint("BOTTOMLEFT", 12, 18)
                    specLbl:SetText("|cff888888Open your spec tree to spend Knowledge Points here.|r")

                    -- Right: "Open Spec Tree" button
                    local openBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
                    openBtn:SetSize(140, 22)
                    openBtn:SetPoint("BOTTOMRIGHT", -12, 10)
                    openBtn:SetText("Open Spec Tree")

                    -- GetProfessions() only reflects the CURRENT character,
                    -- so someone browsing a guide for a profession they
                    -- haven't leveled yet would otherwise click this and
                    -- get nothing (see the "not learned" bug report). Grey
                    -- it out and say why instead of failing silently.
                    local targetProfession   = self.selectedLevelingProf or "Tailoring"
                    local learnedSkillLineID = self:GetLearnedSkillLineID(targetProfession)

                    if not learnedSkillLineID then
                        openBtn:Disable()
                        openBtn:SetScript("OnEnter", function(btn)
                            GameTooltip:SetOwner(btn, "ANCHOR_TOP")
                            GameTooltip:AddLine("Not learned on this character", 1, 0.4, 0.4)
                            GameTooltip:AddLine(
                                "Log in on a character with " .. targetProfession ..
                                " trained, or use |cffffff00Pin Trainer|r above to find where to learn it.",
                                0.9, 0.9, 0.9, true)
                            GameTooltip:Show()
                        end)
                        openBtn:SetScript("OnLeave", function()
                            GameTooltip:Hide()
                        end)
                    else
                        openBtn:SetScript("OnClick", function()
                            local targetSubTree = step.specTarget   -- e.g. "Nimble Needlework"

                            -- 1. Open the profession (this loads the spec config)
                            C_TradeSkillUI.OpenTradeSkill(learnedSkillLineID)

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
                            local specPage = _G.ProfessionsFrame and _G.ProfessionsFrame.SpecPage
                            if not specPage then return false end

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
                            walk(specPage, 0)
                            return found
                        end

                        -- Strategy B: use C_ProfSpecs to resolve the sub-tree ID, then SetSelectedTab
                        local function trySelectByID()
                            local ids = C_ProfSpecs.GetSpecTabIDsForSkillLine(learnedSkillLineID)
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

                            local specPage = _G.ProfessionsFrame and _G.ProfessionsFrame.SpecPage
                            if not specPage then return false end

                            -- Cache the choice so future opens remember it
                            local profID = specPage.GetProfessionID and specPage:GetProfessionID()
                            if profID and g_professionsSpecsSelectedTabs then
                                g_professionsSpecsSelectedTabs[profID] = targetID
                            end

                            if type(specPage.SetSelectedTab) == "function" then
                                pcall(specPage.SetSelectedTab, specPage, targetID)
                                return true
                            end
                            return false
                        end

                        -- Strategy C: use the SpecPage's own TabSystem, iterating by index
                        local function trySelectByTabSystem()
                            local specPage = _G.ProfessionsFrame and _G.ProfessionsFrame.SpecPage
                            if not specPage or not specPage.TabSystem then return false end
                            local ts = specPage.TabSystem
                            for tabIdx = 1, 10 do
                                local btn = ts.GetTabButton and ts:GetTabButton(tabIdx)
                                if not btn then break end
                                local txt = btn.GetText and btn:GetText()
                                        or (btn.Text and btn.Text.GetText and btn.Text:GetText())
                                if txt == targetSubTree and type(ts.SetTab) == "function" then
                                    pcall(ts.SetTab, ts, tabIdx)
                                    return true
                                end
                            end
                            return false
                        end

                        -- ============================================================
                        -- 4. Retry loop - the tabs load asynchronously after OpenTradeSkill
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
                    end

                    -- Optional hint icon next to the button
                    if step.hint and step.hint ~= "" then
                        local hintIcon = CreateFrame("Frame", nil, row)
                        hintIcon:SetSize(16, 16)
                        hintIcon:SetPoint("RIGHT", openBtn, "LEFT", -8, 0)

                        local iconTex = hintIcon:CreateTexture(nil, "ARTWORK")
                        iconTex:SetAllPoints()
                        iconTex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
                        iconTex:SetTexCoord(0.08, 0.92, 0.08, 0.92)

                        hintIcon:SetScript("OnEnter", function(icon)
                            GameTooltip:SetOwner(icon, "ANCHOR_RIGHT")
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
    scrollFrame:SetScript("OnMouseWheel", function(sf, delta)
        local current = sf:GetVerticalScroll()
        local maxScroll = sf:GetVerticalScrollRange()
        local newScroll = math.min(maxScroll, math.max(0, current - (delta * 30)))
        sf:SetVerticalScroll(newScroll)
    end)
end


-- ============================================================
-- SHOPPING LIST ENGINE
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
                if entry.alternatives and #entry.alternatives > 0 then
                    -- Only count the SELECTED alternative
                    local altKey = (profData.name or "?") .. "|" ..
                                   (entry.path or "shared") .. "|" .. (entry.range or "?")
                    local selectedKey = self.selectedAlternatives
                                        and self.selectedAlternatives[altKey]
                                        or entry.alternatives[1].key

                    local selectedAlt
                    for _, alt in ipairs(entry.alternatives) do
                        if alt.key == selectedKey then selectedAlt = alt; break end
                    end
                    if not selectedAlt then selectedAlt = entry.alternatives[1] end

                    for _, mat in ipairs(selectedAlt.materials or {}) do
                        addItem(mat.itemID, mat.name, mat.amount or 1)
                    end

                else
                    local hasStepMats = entry.materials and #entry.materials > 0
                    if hasStepMats then
                        for _, mat in ipairs(entry.materials) do
                            addItem(mat.itemID, mat.name, mat.amount or 1)
                        end
                    else
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
                needed:SetText("|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14:0:0|t |cff00ff00Have enough|r")
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
            "|cff888888%d missing · %d ready|r", missing, complete))

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

if type(addon.BuildLeveling) == "function" then
    private.Leveling.BuildLeveling = addon.BuildLeveling
    private:Print("Leveling module file loaded (BuildLeveling ready)")
else
    private:Print("ERROR: Leveling failed to attach BuildLeveling")
end