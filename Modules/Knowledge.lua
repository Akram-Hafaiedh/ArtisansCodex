-- ArtisansCodex Knowledge module
-- Knowledge and Treasures tab UI

local _, private = ...
local addon = private.addon

private.Knowledge = private.Knowledge or {}
local Knowledge = private.Knowledge

function Knowledge:Initialize()
    private:Print("Knowledge module loaded")
end

local function IsQuestDone(questID)
    if not questID then return false end
    return C_QuestLog.IsQuestFlaggedCompleted(questID)
end

local function IsTreasureCollected(treasure)
    if not treasure or not treasure.questID then return false end
    return IsQuestDone(treasure.questID)
end

local function PinCoords(mapID, x, y, label)
    if not mapID or not x or not y then
        private:Print("No coordinates available" .. (label and (" for " .. label) or "") .. ".")
        return
    end
    C_Map.SetUserWaypoint({
        uiMapID = mapID,
        position = CreateVector2D(x / 100, y / 100)
    })
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    if label then
        private:Print("Pinned |cffFFD700" .. label .. "|r on the map.")
    end
end

local function PinTreasure(treasure)
    if treasure then
        PinCoords(treasure.mapID, treasure.x, treasure.y, treasure.name)
    end
end

local function ItemIconTexture(itemID)
    if not itemID then
        return 134400
    end
    local icon
    if C_Item and C_Item.GetItemIconByID then
        icon = C_Item.GetItemIconByID(itemID)
    end
    if (not icon or icon == 0) and GetItemIcon then
        icon = GetItemIcon(itemID)
    end
    if icon and icon ~= 0 then
        return icon
    end
    return 134400
end


local function GetItemQualityRGB(itemID)
    if not itemID then
        return 1, 1, 1
    end
    local quality
    if C_Item and C_Item.GetItemQualityByID then
        quality = C_Item.GetItemQualityByID(itemID)
    end
    if quality == nil and GetItemInfo then
        quality = select(3, GetItemInfo(itemID))
    end
    if quality == nil then
        return 1, 1, 1
    end
    if GetItemQualityColor then
        local r, g, b = GetItemQualityColor(quality)
        return r, g, b
    end
    if ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality] then
        local c = ITEM_QUALITY_COLORS[quality]
        return c.r, c.g, c.b
    end
    return 1, 1, 1
end

local function ApplyQualityColor(fs, itemID, dimmed)
    local r, g, b = GetItemQualityRGB(itemID)
    if dimmed then
        fs:SetTextColor(r * 0.55, g * 0.55, b * 0.55)
    else
        fs:SetTextColor(r, g, b)
    end
end

local function SetItemNameFontString(fs, name, itemID, dimmed)
    fs:SetText(name or "?")
    if not itemID then
        fs:SetTextColor(1, 1, 1)
        return
    end
    -- Request item data; quality is often nil on first open until cached
    if C_Item and C_Item.RequestLoadItemDataByID then
        C_Item.RequestLoadItemDataByID(itemID)
    end
    ApplyQualityColor(fs, itemID, dimmed)
    -- When client finishes loading the item, recolor (fixes white names until tab switch)
    if Item and Item.CreateFromItemID then
        local item = Item:CreateFromItemID(itemID)
        if item and item.ContinueOnItemLoad then
            item:ContinueOnItemLoad(function()
                if fs and fs.SetTextColor then
                    ApplyQualityColor(fs, itemID, dimmed)
                end
            end)
        end
    end
end

-- Pure item tooltip (do not mix with AddLine — that breaks layout)
local function ShowItemTooltip(owner, itemID)
    if not itemID then return end
    -- Anchor close to the hovered frame (icon/name area), not far across the UI
    GameTooltip:SetOwner(owner, "ANCHOR_RIGHT", 6, 0)
    GameTooltip:SetItemByID(itemID)
    GameTooltip:Show()
end

local function GroupTreasuresByZone(treasures)
    local groups, order = {}, {}
    for _, t in ipairs(treasures) do
        local zone = t.zone or "Unknown"
        if not groups[zone] then
            groups[zone] = {}
            order[#order + 1] = zone
        end
        groups[zone][#groups[zone] + 1] = t
    end
    for _, zone in ipairs(order) do
        table.sort(groups[zone], function(a, b)
            local aCol, bCol = IsTreasureCollected(a), IsTreasureCollected(b)
            if aCol ~= bCol then return not aCol end
            return (a.name or "") < (b.name or "")
        end)
    end
    return order, groups
end

function addon:BuildKnowledge()
    local page = self.mainFrame.tabContents["knowledge"]
    if not page then return end

    if type(self.BuildProfessionSidebar) ~= "function" then
        private:Print("|cffff4444ERROR:|r BuildProfessionSidebar missing from Core.")
        return
    end

    self:ClearPage(page)

    self.selectedKnowledgeProf = self:BuildProfessionSidebar(page, {
        selected    = self.selectedKnowledgeProf or "Alchemy",
        filter      = "treasures",
        showLearned = true,
        onSelect    = function(name)
            self.selectedKnowledgeProf = name
            self:BuildKnowledge()
        end,
    })

    local profData = private.Data[self.selectedKnowledgeProf] or {}
    local treasures = profData.treasures or {}
    local weekly = profData.weekly or {}
    local oneTime = profData.oneTime or {}
    local overview = profData.knowledgeOverview
    local catchUp = profData.knowledgeCatchUp
    local tips = profData.knowledgeTips or {}
    local unlock = profData.knowledgeUnlock
    local changes = profData.knowledgeChanges or {}

    local treasureCollected, treasureTotal = 0, #treasures
    local treasureKP, collectedKP = 0, 0
    for _, t in ipairs(treasures) do
        local kp = t.kp or 3
        treasureKP = treasureKP + kp
        if IsTreasureCollected(t) then
            treasureCollected = treasureCollected + 1
            collectedKP = collectedKP + kp
        end
    end
    local oneTimeKP = 0
    for _, o in ipairs(oneTime) do
        oneTimeKP = oneTimeKP + (o.kp or 0)
    end

    local right = CreateFrame("Frame", nil, page)
    right:SetPoint("TOPLEFT", 215, -12)
    right:SetPoint("BOTTOMRIGHT", -12, 12)

    local scroll = CreateFrame("ScrollFrame", nil, right, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 0, 0)
    scroll:SetPoint("BOTTOMRIGHT", -22, 0)

    local width = 720
    local content = CreateFrame("Frame", nil, scroll)
    content:SetWidth(width)
    content:SetHeight(1)
    scroll:SetScrollChild(content)

    local y = -4

    local function AddSection(title)
        local f = CreateFrame("Frame", nil, content, "BackdropTemplate")
        f:SetPoint("TOPLEFT", 0, y)
        f:SetSize(width, 26)
        f:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 10,
            insets = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        f:SetBackdropColor(0.12, 0.11, 0.08, 0.95)
        f:SetBackdropBorderColor(0.55, 0.45, 0.2, 0.9)
        local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fs:SetPoint("LEFT", 12, 0)
        fs:SetText("|cffFFD700" .. title .. "|r")
        y = y - 30
    end

    local function AddText(text, r, g, b, indent)
        local fs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fs:SetPoint("TOPLEFT", (indent or 8), y)
        fs:SetWidth(width - (indent or 8) - 8)
        fs:SetJustifyH("LEFT")
        fs:SetSpacing(2)
        fs:SetTextColor(r or 0.8, g or 0.8, b or 0.8)
        fs:SetText(text or "")
        y = y - (fs:GetStringHeight() or 14) - 6
    end

    local function AddRow(height)
        local row = CreateFrame("Frame", nil, content, "BackdropTemplate")
        row:SetPoint("TOPLEFT", 0, y)
        row:SetSize(width, height)
        row:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 10,
            insets = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        row:SetBackdropColor(0.11, 0.12, 0.18, 0.9)
        row:SetBackdropBorderColor(0.35, 0.30, 0.18, 0.7)
        y = y - height - 4
        return row
    end

    local function AddIcon(parent, itemID, size)
        size = size or 28
        local tex = parent:CreateTexture(nil, "ARTWORK")
        tex:SetSize(size, size)
        tex:SetTexture(ItemIconTexture(itemID))
        if itemID then
            parent:EnableMouse(true)
            parent:SetScript("OnEnter", function(self)
                ShowItemTooltip(self, itemID)
            end)
            parent:SetScript("OnLeave", function() GameTooltip:Hide() end)
        end
        return tex
    end

    -- ---------- HEADER + TAB LINKS ----------
    local header = CreateFrame("Frame", nil, content, "BackdropTemplate")
    header:SetPoint("TOPLEFT", 0, y)
    header:SetSize(width, 82)
    header:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    header:SetBackdropColor(0.10, 0.11, 0.17, 0.95)
    header:SetBackdropBorderColor(0.55, 0.45, 0.2, 0.9)

    local headerTitle = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    headerTitle:SetPoint("TOPLEFT", 16, -8)
    headerTitle:SetText("|cffFFD700" .. self.selectedKnowledgeProf .. " Knowledge|r")

    local headerSub = header:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    headerSub:SetPoint("TOPLEFT", 16, -28)
    headerSub:SetText(string.format(
        "Treasures %d/%d  ·  One-time KP %d/%d",
        treasureCollected, treasureTotal,
        collectedKP, treasureKP + oneTimeKP
    ))
    headerSub:SetTextColor(0.75, 0.75, 0.75)

    -- Live specialization KP from Artisan's Progress scan (this character)
    local snap = self.GetProfessionSnapshot and self:GetProfessionSnapshot(self.selectedKnowledgeProf)
    local kSpent = snap and snap.knowledge and snap.knowledge.spent or 0
    local kMax = snap and snap.knowledge and snap.knowledge.max or 0
    local kUnspent = snap and snap.knowledge and snap.knowledge.unspent or 0
    if self.CreateStatusMeter then
        local meter = self:CreateStatusMeter(header, {
            width = math.min(280, width - 32),
            height = 14,
            value = kSpent,
            maxValue = kMax,
            unspent = kUnspent,
            r = 0.45, g = 0.75, b = 1.0,
            emptyText = "Open profession to scan KP",
        })
        meter:SetPoint("TOPLEFT", 16, -52)
    end

    -- Cross-links
    local linkX = width - 16
    local function TabLink(label, tabKey)
        local btn = CreateFrame("Button", nil, header, "UIPanelButtonTemplate")
        btn:SetSize(90, 20)
        btn:SetPoint("TOPRIGHT", header, "TOPRIGHT", -(width - linkX), -8)
        linkX = linkX - 96
        btn:SetText(label)
        btn:SetScript("OnClick", function()
            if self.SelectTab then
                if tabKey == "specializations" then
                    self.selectedSpecProf = self.selectedKnowledgeProf
                elseif tabKey == "leveling" then
                    self.selectedLevelingProf = self.selectedKnowledgeProf
                end
                self:SelectTab(tabKey)
            end
        end)
    end
    TabLink("Leveling", "leveling")
    TabLink("Specs", "specializations")

    y = y - 92

    -- ---------- WHAT CHANGED ----------
    if #changes > 0 then
        AddSection("What changed in Midnight")
        for _, line in ipairs(changes) do
            AddText("• " .. line, 0.78, 0.78, 0.78, 10)
        end
    end

    -- ---------- OVERVIEW ----------
    if overview and overview ~= "" then
        AddSection("How Knowledge works")
        AddText(overview, 0.85, 0.85, 0.85, 10)
    end

    -- ---------- UNLOCK (compact, live-tracked) ----------
    if unlock and type(unlock) == "table" and unlock.questID then
        local done = IsQuestDone(unlock.questID)
        local row = CreateFrame("Frame", nil, content, "BackdropTemplate")
        row:SetPoint("TOPLEFT", 0, y)
        row:SetSize(width, 36)
        row:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 10,
            insets = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        if done then
            row:SetBackdropColor(0.08, 0.14, 0.10, 0.95)
            row:SetBackdropBorderColor(0.25, 0.55, 0.3, 0.8)
        else
            row:SetBackdropColor(0.16, 0.11, 0.06, 0.95)
            row:SetBackdropBorderColor(0.85, 0.55, 0.2, 0.9)
        end

        local status = done and "|cff1eff00Done|r" or "|cffff8844Not done|r"
        local bang = done and "" or "|cffffcc00!|r "
        local line = string.format(
            "%s|cffFFD700%s|r  from |cff66ccff%s|r  ·  %s",
            bang,
            unlock.questName or ("Quest " .. tostring(unlock.questID)),
            unlock.npcName or "NPC",
            status
        )
        local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fs:SetPoint("LEFT", 12, 0)
        fs:SetText(line)

        if unlock.mapID and unlock.x and unlock.y and not done then
            local pinBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            pinBtn:SetSize(60, 20)
            pinBtn:SetPoint("RIGHT", -8, 0)
            pinBtn:SetText("Pin")
            pinBtn:SetScript("OnClick", function()
                PinCoords(unlock.mapID, unlock.x, unlock.y, unlock.npcName or unlock.questName)
            end)
        end

        y = y - 42
        if unlock.note and not done then
            AddText(unlock.note, 0.7, 0.7, 0.7, 12)
        end
    elseif type(unlock) == "string" and unlock ~= "" then
        -- legacy string form
        AddText("|cffFFD700Unlock:|r " .. unlock, 0.85, 0.8, 0.7, 8)
    end

    -- ---------- ONE-TIME ----------
    AddSection("One-time sources")
    AddText(
        string.format(
            "Once per character. Treasures: %d×3 KP (%d). Extra one-time (renown books, etc.): +%d KP.",
            treasureTotal, treasureKP, oneTimeKP
        ),
        0.72, 0.72, 0.72, 10
    )

    for _, o in ipairs(oneTime) do
        local row = AddRow(44)
        local icon = row:CreateTexture(nil, "ARTWORK")
        icon:SetSize(28, 28)
        icon:SetPoint("LEFT", 10, 0)
        icon:SetTexture(ItemIconTexture(o.itemID))

        local nameFS = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameFS:SetPoint("TOPLEFT", 48, -8)
        SetItemNameFontString(nameFS, o.name or "One-time source", o.itemID, false)

        local noteFS = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        noteFS:SetPoint("TOPLEFT", 48, -24)
        noteFS:SetPoint("RIGHT", -70, -24)
        noteFS:SetJustifyH("LEFT")
        noteFS:SetText(o.note or "")
        noteFS:SetTextColor(0.68, 0.68, 0.68)

        local kpFS = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        kpFS:SetPoint("RIGHT", -12, 0)
        kpFS:SetText("+" .. tostring(o.kp or "?") .. " KP")
        kpFS:SetTextColor(1, 0.9, 0.5)

        -- Tight hit area over icon + name so tooltip sits next to the item
        if o.itemID then
            local hit = CreateFrame("Frame", nil, row)
            hit:SetPoint("TOPLEFT", icon, "TOPLEFT", -4, 4)
            hit:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT", -4, -4)
            hit:SetPoint("RIGHT", nameFS, "RIGHT", 12, 0)
            hit:EnableMouse(true)
            hit:SetScript("OnEnter", function(self)
                ShowItemTooltip(self, o.itemID)
            end)
            hit:SetScript("OnLeave", function() GameTooltip:Hide() end)
        end
    end

    -- Treasures actions
    local missingCount = treasureTotal - treasureCollected
    local actionRow = CreateFrame("Frame", nil, content)
    actionRow:SetPoint("TOPLEFT", 0, y)
    actionRow:SetSize(width, 26)

    local pinAll = CreateFrame("Button", nil, actionRow, "UIPanelButtonTemplate")
    pinAll:SetSize(120, 22)
    pinAll:SetPoint("LEFT", 0, 0)
    pinAll:SetText("Pin Missing")
    pinAll:SetScript("OnClick", function()
        local missing = {}
        for _, tr in ipairs(treasures) do
            if not IsTreasureCollected(tr) then missing[#missing + 1] = tr end
        end
        if #missing == 0 then
            private:Print("All treasures collected for " .. self.selectedKnowledgeProf .. ".")
            return
        end
        PinTreasure(missing[1])
        if #missing > 1 then
            private:Print(string.format("|cffFFD700%d|r more missing.", #missing - 1))
        end
    end)

    local missFS = actionRow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    missFS:SetPoint("LEFT", 130, 0)
    if missingCount == 0 and treasureTotal > 0 then
        missFS:SetText("|cff1eff00All treasures collected|r")
    else
        missFS:SetText(string.format("|cffff6666%d missing|r  (+%d KP)", missingCount, missingCount * 3))
    end
    y = y - 30

    if #treasures == 0 then
        AddText("No treasures recorded for this profession yet.", 0.6, 0.6, 0.6, 10)
    else
        local zoneOrder, zoneGroups = GroupTreasuresByZone(treasures)
        for _, zone in ipairs(zoneOrder) do
            local list = zoneGroups[zone]
            local zc = 0
            for _, tr in ipairs(list) do
                if IsTreasureCollected(tr) then zc = zc + 1 end
            end
            local zh = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            zh:SetPoint("TOPLEFT", 4, y)
            zh:SetText(string.format("|cffFFD700%s|r  |cff888888(%d/%d)|r", zone, zc, #list))
            y = y - 16

            for _, treasure in ipairs(list) do
                local isCollected = IsTreasureCollected(treasure)
                local row = AddRow(40)
                if isCollected then
                    row:SetBackdropColor(0.10, 0.14, 0.11, 0.9)
                    row:SetBackdropBorderColor(0.25, 0.55, 0.25, 0.55)
                end

                -- Treasure / chest icon (or item icon if itemID present)
                local icon = row:CreateTexture(nil, "ARTWORK")
                icon:SetSize(26, 26)
                icon:SetPoint("LEFT", 8, 0)
                if treasure.itemID then
                    icon:SetTexture(ItemIconTexture(treasure.itemID))
                else
                    icon:SetTexture("Interface\\Icons\\INV_Misc_Bag_01")
                end

                local nameFS = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                nameFS:SetPoint("LEFT", 42, 6)
                SetItemNameFontString(nameFS, treasure.name, treasure.itemID, isCollected)

                local descFS = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                descFS:SetPoint("LEFT", 42, -8)
                descFS:SetPoint("RIGHT", -100, -8)
                descFS:SetJustifyH("LEFT")
                descFS:SetText(treasure.description or "")
                descFS:SetTextColor(0.62, 0.62, 0.62)

                local statusFS = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                statusFS:SetPoint("TOPRIGHT", -10, -6)
                if isCollected then
                    statusFS:SetText("|cff1eff00Collected|r")
                else
                    statusFS:SetText("+" .. (treasure.kp or 3) .. " KP")
                    statusFS:SetTextColor(1, 0.9, 0.5)
                end

                if not isCollected then
                    local pinBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
                    pinBtn:SetSize(56, 18)
                    pinBtn:SetPoint("BOTTOMRIGHT", -8, 4)
                    pinBtn:SetText("Pin")
                    pinBtn:SetScript("OnClick", function() PinTreasure(treasure) end)
                end

                -- Tight hit area over icon + name so tooltip sits next to the item
                local hit = CreateFrame("Frame", nil, row)
                hit:SetPoint("TOPLEFT", icon, "TOPLEFT", -4, 4)
                hit:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT", -4, -4)
                hit:SetPoint("RIGHT", nameFS, "RIGHT", 12, 0)
                hit:EnableMouse(true)
                hit:SetScript("OnEnter", function(self)
                    if treasure.itemID then
                        ShowItemTooltip(self, treasure.itemID)
                    else
                        GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 6, 0)
                        GameTooltip:AddLine(treasure.name or "?", 1, 0.85, 0.2)
                        if treasure.description then
                            GameTooltip:AddLine(treasure.description, 0.9, 0.9, 0.9, true)
                        end
                        GameTooltip:Show()
                    end
                end)
                hit:SetScript("OnLeave", function() GameTooltip:Hide() end)
            end
            y = y - 4
        end
    end

    -- ---------- WEEKLY ----------
    AddSection("Weekly sources")
    AddText(
        "Most ongoing Knowledge comes from here. Patron Orders are the largest share. Darkmoon Faire is monthly.",
        0.72, 0.72, 0.72, 10
    )

    for _, src in ipairs(weekly) do
        local row = AddRow(48)

        local iconIDs = src.itemIDs or (src.itemID and { src.itemID }) or {}
        local iconX = 10
        local firstIcon = nil
        if #iconIDs == 0 then
            local icon = row:CreateTexture(nil, "ARTWORK")
            icon:SetSize(26, 26)
            icon:SetPoint("LEFT", iconX, 0)
            icon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
            firstIcon = icon
            iconX = iconX + 32
        else
            for _, id in ipairs(iconIDs) do
                local icon = row:CreateTexture(nil, "ARTWORK")
                icon:SetSize(26, 26)
                icon:SetPoint("LEFT", iconX, 0)
                icon:SetTexture(ItemIconTexture(id))
                if not firstIcon then firstIcon = icon end
                iconX = iconX + 30
            end
            iconX = iconX + 4
        end

        local nameFS = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameFS:SetPoint("TOPLEFT", iconX, -6)
        local nameText = src.name or "?"
        if src.unlockQuestID and not IsQuestDone(src.unlockQuestID) then
            nameText = nameText .. "  |cffff8844(locked)|r"
        end
        local primaryID = iconIDs[1]
        if primaryID then
            SetItemNameFontString(nameFS, nameText, primaryID, false)
            if src.unlockQuestID and not IsQuestDone(src.unlockQuestID) then
                nameFS:SetText(nameText)
            end
        else
            nameFS:SetText(nameText)
        end

        local noteFS = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        noteFS:SetPoint("TOPLEFT", iconX, -24)
        noteFS:SetPoint("RIGHT", -70, -24)
        noteFS:SetJustifyH("LEFT")
        noteFS:SetText(src.note or "")
        noteFS:SetTextColor(0.68, 0.68, 0.68)

        local kpFS = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        kpFS:SetPoint("TOPRIGHT", -12, -8)
        local kpLabel = src.kp
        if type(kpLabel) == "number" then
            kpLabel = "+" .. tostring(kpLabel) .. " KP"
        else
            kpLabel = tostring(kpLabel or "?") .. " KP"
        end
        kpFS:SetText(kpLabel)
        kpFS:SetTextColor(1, 0.9, 0.5)

        -- Tight hit area over icons + name so tooltip sits next to the item
        if primaryID and firstIcon then
            local hit = CreateFrame("Frame", nil, row)
            hit:SetPoint("TOPLEFT", firstIcon, "TOPLEFT", -4, 4)
            hit:SetPoint("BOTTOMLEFT", firstIcon, "BOTTOMLEFT", -4, -4)
            hit:SetPoint("RIGHT", nameFS, "RIGHT", 12, 0)
            hit:EnableMouse(true)
            hit:SetScript("OnEnter", function(self)
                ShowItemTooltip(self, primaryID)
            end)
            hit:SetScript("OnLeave", function() GameTooltip:Hide() end)
        end
    end

    if catchUp and catchUp ~= "" then
        local catchFrame = CreateFrame("Frame", nil, content, "BackdropTemplate")
        catchFrame:SetPoint("TOPLEFT", 0, y)
        catchFrame:SetSize(width, 36)
        catchFrame:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 10,
            insets = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        catchFrame:SetBackdropColor(0.08, 0.14, 0.12, 0.95)
        catchFrame:SetBackdropBorderColor(0.3, 0.6, 0.4, 0.8)
        local catchFS = catchFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        catchFS:SetPoint("LEFT", 12, 0)
        catchFS:SetPoint("RIGHT", -12, 0)
        catchFS:SetJustifyH("LEFT")
        catchFS:SetText("|cff1eff00Catch-up:|r " .. catchUp)
        y = y - 44
    end

    if tips and #tips > 0 then
        AddSection("Tips")
        for _, tip in ipairs(tips) do
            AddText("• " .. tip, 0.72, 0.72, 0.72, 10)
        end
    end

    content:SetHeight(math.abs(y) + 20)
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(sf, delta)
        local current = sf:GetVerticalScroll()
        local maxScroll = sf:GetVerticalScrollRange()
        sf:SetVerticalScroll(math.min(maxScroll, math.max(0, current - (delta * 36))))
    end)
end

if type(addon.BuildKnowledge) == "function" then
    private.Knowledge.BuildKnowledge = addon.BuildKnowledge
end