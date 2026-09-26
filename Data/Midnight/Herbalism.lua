-- Artisan's Codex - Midnight Herbalism Data
-- Source: wow-professions.com/guides/wow-herbalism-leveling-guide (accurate as of patch 12.1)
-- Herbalism is a gathering profession: no recipes, so "leveling" describes skill ranges instead of crafts.

local _, private = ...

private.Data = private.Data or {}

private.Data.Herbalism = {
    name = "Herbalism",
    icon = "Interface\\Icons\\Trade_Herbalism",
    isGathering = true,
    overview = "Herbalism now has only two quality tiers (Silver/Gold). Base herbs carry you to about skill 30, Lush/Infused herbs carry the rest. Pairs best with Alchemy or Inscription.",

    trainer = {
        name = "Botanist Nathera",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 48.0,          -- approximate, refine if needed
        y = 53.0,
        note = "Artisan Herbalist's Moxie is the profession-specific currency for Herbalism unlocks.",
    },

    -- =========================================================
    -- SKILL RANGES (gathering profession -- no crafting steps)
    -- =========================================================
    leveling = {
        {
            range = "1-30",
            recipe = "Gather anything",
            quantity = 0,
            materials = {},
            note = "Pretty much everything gives skill points. Tranquility Bloom stops giving skill at 30, the rest carry you further.",
            difficulty = "orange",
        },
        {
            range = "30-60",
            recipe = "Base + Lush/Infused herbs",
            quantity = 0,
            materials = {},
            note = "Sanguithorn, Azeroot, Argentleaf, and Mana Lily go yellow at 30 and grey at 60. Lush and Infused variants also give skill here.",
            difficulty = "yellow",
        },
        {
            range = "60-100",
            recipe = "Lush/Infused herbs only",
            quantity = 0,
            materials = {},
            note = "All base herbs are grey now. Only Lush and Infused variants give skill (yellow at 60, grey at 100). They spawn randomly in place of normal herbs.",
            difficulty = "green",
            isRecommended = true,
        },
    },

    -- =========================================================
    -- INFUSED HERBS BY ZONE
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
        { name = "Bright Linen Herbalism Hat", craftedBy = "Tailoring" },
        { name = "Eversong Botanist's Satchel", craftedBy = "Leatherworking" },
        { name = "Thalassian Sickle", craftedBy = "Blacksmithing" },
        { name = "Sun-Blessed Sickle", craftedBy = "Blacksmithing" },
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
        { name = "Zul'Aman", note = "Not recommended for pure gathering leveling -- Wild infused herbs summon mobs that can be tough without gear." },
        { name = "Harandar", note = "Probably the most annoying zone to farm -- herbs on mushrooms and hidden in bushes, lots of vertical movement." },
        { name = "Voidstorm", note = "Highest mob density around nodes. High Deftness recommended." },
    },

    -- =========================================================
    -- KNOWLEDGE TREASURES
    -- =========================================================
    treasures = {
        {
            id = "simple_leaf_pruners",
            name = "Simple Leaf Pruners",
            zone = "Silvermoon City",
            mapID = 2393,
            x = 49.0,
            y = 75.9,
            questID = 89160,
            description = "Silvermoon City.",
            kp = 3,
        },
        {
            id = "a_spade",
            name = "A Spade",
            zone = "Eversong Woods",
            mapID = 2395,
            x = 64.2,
            y = 30.5,
            questID = 89158,
            description = "Eversong Woods.",
            kp = 3,
        },
        {
            id = "sweeping_harvesters_scythe",
            name = "Sweeping Harvester's Scythe",
            zone = "Zul'Aman",
            mapID = 2437,
            x = 41.9,
            y = 45.9,
            questID = 89161,
            description = "Zul'Aman.",
            kp = 3,
        },
        {
            id = "peculiar_lotus",
            name = "Peculiar Lotus",
            zone = "Voidstorm",
            mapID = 2405,
            x = 34.7,
            y = 57.0,
            questID = 89156,
            description = "Voidstorm.",
            kp = 3,
        },
        {
            id = "planting_shovel",
            name = "Planting Shovel",
            zone = "Harandar",
            mapID = 2413,
            x = 51.1,
            y = 55.7,
            questID = 89155,
            description = "Harandar.",
            kp = 3,
        },
        {
            id = "bloomed_bud",
            name = "Bloomed Bud",
            zone = "Harandar",
            mapID = 2413,
            x = 38.3,
            y = 66.9,
            questID = 89162,
            description = "Harandar.",
            kp = 3,
        },
        {
            id = "lightbloom_root",
            name = "Lightbloom Root",
            zone = "Harandar",
            mapID = 2413,
            x = 36.6,
            y = 25.1,
            questID = 89159,
            description = "Harandar.",
            kp = 3,
        },
        {
            id = "harvesters_sickle",
            name = "Harvester's Sickle",
            zone = "Harandar",
            mapID = 2413,
            x = 76.1,
            y = 51.1,
            questID = 89157,
            description = "Harandar.",
            kp = 3,
        },
    },
}