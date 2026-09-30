-- Artisan's Codex - Base profession registry (Midnight)
-- Canonical list of professions: name, icon, skill line IDs.
-- Everything else (Leveling, Recipes, Specs, Knowledge, ProgressMeta) keys off these names.
-- Do NOT put guide content here — only identity + display basics.

local _, private = ...

private.Professions = private.Professions or {}

-- Ordered list (sidebar / DataLoader order)
private.Professions.list = {
    "Alchemy",
    "Blacksmithing",
    "Enchanting",
    "Engineering",
    "Herbalism",
    "Inscription",
    "Jewelcrafting",
    "Leatherworking",
    "Mining",
    "Skinning",
    "Tailoring",
    "Cooking",
    "Fishing",
}

-- Per-profession identity
-- skillLineID = base profession line (GetProfessionInfo)
-- variantID   = Midnight expansion skill line (C_TradeSkillUI / C_ProfSpecs); nil for Cooking/Fishing
-- icon        = sidebar / header texture
private.Professions.byName = {
    Alchemy = {
        name = "Alchemy",
        icon = "Interface\\Icons\\Trade_Alchemy",
        skillLineID = 171,
        variantID = 2906,
    },
    Blacksmithing = {
        name = "Blacksmithing",
        icon = "Interface\\Icons\\Trade_BlackSmithing",
        skillLineID = 164,
        variantID = 2907,
    },
    Enchanting = {
        name = "Enchanting",
        icon = "Interface\\Icons\\Trade_Engraving",
        skillLineID = 333,
        variantID = 2909,
    },
    Engineering = {
        name = "Engineering",
        icon = "Interface\\Icons\\Trade_Engineering",
        skillLineID = 202,
        variantID = 2910,
    },
    Herbalism = {
        name = "Herbalism",
        gathering = true,
        icon = "Interface\\Icons\\Trade_Herbalism",
        skillLineID = 182,
        variantID = 2912,
    },
    Inscription = {
        name = "Inscription",
        icon = "Interface\\Icons\\INV_Inscription_Tradeskill01",
        skillLineID = 773,
        variantID = 2913,
    },
    Jewelcrafting = {
        name = "Jewelcrafting",
        icon = "Interface\\Icons\\INV_Misc_Gem_01",
        skillLineID = 755,
        variantID = 2914,
    },
    Leatherworking = {
        name = "Leatherworking",
        icon = "Interface\\Icons\\INV_Misc_ArmorKit_17",
        skillLineID = 165,
        variantID = 2915,
    },
    Mining = {
        name = "Mining",
        gathering = true,
        icon = "Interface\\Icons\\Trade_Mining",
        skillLineID = 186,
        variantID = 2916,
    },
    Skinning = {
        name = "Skinning",
        gathering = true,
        icon = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01",
        skillLineID = 393,
        variantID = 2917,
    },
    Tailoring = {
        name = "Tailoring",
        icon = "Interface\\Icons\\Trade_Tailoring",
        skillLineID = 197,
        variantID = 2918,
    },
    Cooking = {
        name = "Cooking",
        icon = "Interface\\Icons\\INV_Misc_Food_15",
        skillLineID = 185,
        variantID = nil,
        secondary = true,
    },
    Fishing = {
        name = "Fishing",
        gathering = true,
        icon = "Interface\\Icons\\Trade_Fishing",
        skillLineID = 356,
        variantID = nil,
        secondary = true,
    },
}

--- Look up by display name (e.g. "Inscription")
function private.Professions:Get(name)
    if not name then return nil end
    return self.byName[name]
end

--- Texture path for sidebar / headers
function private.Professions:GetIcon(name)
    local p = self:Get(name)
    return p and p.icon or "Interface\\Icons\\INV_Misc_QuestionMark"
end

--- Ordered name list
function private.Professions:GetList()
    return self.list
end

--- True for Herbalism / Mining / Skinning / Fishing (no crafting shopping list)
function private.Professions:IsGathering(name)
    local p = self:Get(name)
    return p and p.gathering == true
end