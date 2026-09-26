-- Artisan's Codex - Midnight Mining Data
-- Source: wow-professions.com/guides/wow-mining-leveling-guide (accurate as of patch 12.1)
-- Mining is a gathering profession: no recipes, so "leveling" describes skill ranges instead of crafts.

local _, private = ...

private.Data = private.Data or {}

private.Data.Mining = {
    name = "Mining",
    icon = "Interface\\Icons\\Trade_Mining",
    isGathering = true,
    overview = "Mining now has only two quality tiers (Silver/Gold). Normal deposits carry you to about skill 30, Rich/Seam/Infused deposits carry the rest. Pairs best with Blacksmithing, Jewelcrafting, or Engineering.",

    trainer = {
        name = "Belil",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 46.0,          -- approximate, refine if needed
        y = 55.0,
        note = "Artisan Miner's Moxie is the profession-specific currency for Mining unlocks.",
    },

    -- =========================================================
    -- SKILL RANGES (gathering profession -- no crafting steps)
    -- =========================================================
    leveling = {
        {
            range = "1-30",
            recipe = "Mine anything",
            quantity = 0,
            materials = {},
            note = "Pretty much every deposit gives skill points. You'll reach 30 fast just mining whatever you find.",
            difficulty = "orange",
        },
        {
            range = "30-60",
            recipe = "Base + Rich/Seam/Infused deposits",
            quantity = 0,
            materials = {},
            note = "Base deposits go yellow at 30 and grey at 60. Rich deposits, Seams, and Infused variants keep giving skill through this range.",
            difficulty = "yellow",
        },
        {
            range = "60-100",
            recipe = "Rich/Seam/Infused deposits only",
            quantity = 0,
            materials = {},
            note = "All base deposits are grey now. Only Rich deposits, Seams, and Infused variants give skill (yellow at 60, grey at 100). They spawn randomly in place of normal deposits.",
            difficulty = "green",
            isRecommended = true,
        },
    },

    -- =========================================================
    -- INFUSED DEPOSITS BY ZONE
    -- =========================================================
    infusedTypes = {
        { type = "Lightfused", zone = "Eversong Woods", mote = "Mote of Light" },
        { type = "Wild", zone = "Zul'Aman", mote = "Mote of Wild Magic" },
        { type = "Primal", zone = "Harandar", mote = "Mote of Primal Energy" },
        { type = "Voidbound", zone = "Voidstorm", mote = "Mote of Pure Void" },
    },

    -- =========================================================
    -- PROFESSION EQUIPMENT
    -- =========================================================
    equipment = {
        { name = "Farstrider Hardhat", craftedBy = "Engineering" },
        { name = "Farstrider Rock Satchel", craftedBy = "Engineering" },
        { name = "Thalassian Pickaxe", craftedBy = "Blacksmithing" },
        { name = "Sun-Blessed Pickaxe", craftedBy = "Blacksmithing" },
    },

    -- =========================================================
    -- CONSUMABLES
    -- =========================================================
    consumables = {
        { name = "Azeroot Tea", effect = "+50 Deftness (+16.6%), 1 hour" },
        { name = "Darkmoon Firewater", effect = "+15% Deftness, 1 hour" },
        { name = "Argentleaf Tea", effect = "+50 Finesse (+5.0%), 1 hour" },
        { name = "Sanguithorn Tea", effect = "+50 Perception (+5.0%), 1 hour" },
        { name = "Haranir Phial of Finesse", effect = "+38 Finesse, +11 Deftness, 30 min" },
        { name = "Refulgent Razorstone", effect = "+43 Finesse for gathering tools, 2 hours" },
    },

    -- =========================================================
    -- FARMING ZONES
    -- =========================================================
    zones = {
        { name = "Eversong Woods", note = "Easiest terrain, lowest mob density. Recommended starting zone." },
        { name = "Zul'Aman", note = "Not recommended for pure gathering leveling -- Wild infused deposits summon mobs that can be tough without gear." },
        { name = "Harandar", note = "Lots of vertical movement and mobs. High Deftness recommended." },
        { name = "Voidstorm", note = "Highest mob density around nodes. High Deftness recommended." },
    },
}