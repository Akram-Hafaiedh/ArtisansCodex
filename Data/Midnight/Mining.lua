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

    knowledgeOverview = "Mining Knowledge comes from one-time treasures (usually 8×3 KP) and weekly sources such as Patron Orders, a trainer quest, zone drops, an Inscription treatise, and the monthly Darkmoon Faire. Check each row below for details.",

    knowledgeCatchUp = "If you start late or miss weeks, Patron Orders can grant catch-up knowledge until you are back on pace.",

    oneTime = {
        {
            id = "renown_book",
            name = "Whisper of the Loa: Mining",
            itemID = 250924,
            kp = 10,
            kind = "renown_book",
            note = "Sold by Magovu in Zul'Aman for 75 Artisan Miner's Moxie. Requires Renown 6 with Amani Tribe.",
            vendor = "Magovu",
            zone = "Zul'Aman",
        },
    },

    weekly = {
        {
            name = "Trainer Quest",
            kp = 3,
            itemID = 263463,
            note = "Weekly quest from the Mining trainer. Rewards Thalassian Miner's Notes.",
        },
        {
            name = "Gathering Drops",
            kp = "~8",
            itemIDs = { 237496, 237506 },
            note = "Igneous Rock Specimen (1 KP, up to 5/week) then Septarian Nodule (3 KP) while mining.",
        },
        {
            name = "Thalassian Treatise on Mining",
            kp = 1,
            itemID = 245762,
            note = "BoP from Inscription. Public Crafting Order, or craft on an Inscription alt.",
        },
        {
            name = "Darkmoon Faire",
            kp = 3,
            note = "Monthly profession quest: +3 Knowledge and +2 Skill.",
        },
    },

    treasures = {
        { id = "solid_ore_punchers", name = "Solid Ore Punchers",
            itemID = 238599, zone = "Eversong Woods", mapID = 2395, x = 38.0, y = 45.4, questID = 89147, description = "Eversong Woods.", kp = 3 },
        { id = "amani_experts_chisel", name = "Amani Expert's Chisel",
            itemID = 238601, zone = "Zul'Aman (Atal'Aman)", mapID = 2536, x = 33.4, y = 65.9, questID = 89149, description = "Atal'Aman - may be phased.", kp = 3 },
        { id = "spelunkers_lucky_charm", name = "Spelunker's Lucky Charm",
            itemID = 238597, zone = "Zul'Aman", mapID = 2437, x = 42.0, y = 46.5, questID = 89145, description = "Zul'Aman.", kp = 3 },
        { id = "spare_expedition_torch", name = "Spare Expedition Torch",
            itemID = 238603, zone = "Harandar", mapID = 2413, x = 38.8, y = 65.9, questID = 89151, description = "Harandar.", kp = 3 },
        { id = "star_metal_deposit", name = "Star Metal Deposit",
            itemID = 238602, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 34.2, y = 76.0, questID = 89150, description = "Voidstorm, Slaver's Rise.", kp = 3 },
        { id = "miners_guide_to_voidstorm", name = "Miner's Guide to Voidstorm",
            itemID = 238596, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 30.5, y = 69.1, questID = 89144, description = "Voidstorm, Slaver's Rise.", kp = 3 },
        { id = "glimmering_void_pearl", name = "Glimmering Void Pearl",
            itemID = 238600, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 28.7, y = 38.5, questID = 89148, description = "Voidstorm, Slaver's Rise.", kp = 3 },
        { id = "lost_voidstorm_satchel", name = "Lost Voidstorm Satchel",
            itemID = 238598, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 54.2, y = 51.5, questID = 89146, description = "Voidstorm, Slaver's Rise.", kp = 3 },
    },

}