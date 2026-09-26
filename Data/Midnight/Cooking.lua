-- Artisan's Codex - Midnight Cooking Data
-- Source: wow-professions.com/guides/wow-cooking-leveling-guide (accurate as of patch 12.1)

local _, private = ...

private.Data = private.Data or {}

private.Data.Cooking = {
    name = "Cooking",
    icon = "Interface\\Icons\\INV_Misc_Food_15",
    overview = "Midnight Cooking can be leveled 1-100 almost entirely with vendor materials near the trainer in Silvermoon City. No gathering profession needed.",

    trainer = {
        name = "Sylann",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 47.0,          -- approximate, inside the inn
        y = 53.0,
        note = "Sylann is inside the inn in Silvermoon City. The Cooking supply vendor sits nearby.",
    },

    leveling = {
        {
            range = "1-25",
            recipe = "Spiced Biscuits",
            quantity = 50,
            materials = {
                { name = "A Big Ol' Stick of Butter", amount = 50, itemID = 242643 },
                { name = "Pouch of Spices", amount = 150, itemID = 242646 },
            },
            note = "Both materials are sold by the Cooking supply vendor near the trainer -- do not buy them from the AH. Craft until it turns grey.",
            difficulty = "orange",
        },
        {
            range = "25-35",
            recipe = "Felberry Figs",
            quantity = 10,
            materials = {
                { name = "Plant Protein", amount = 100, itemID = 242640 },
                { name = "Ripened Vegetable Assortment", amount = 40, itemID = 242645 },
                { name = "A Big Ol' Stick of Butter", amount = 10, itemID = 242643 },
                { name = "Mana-Wyrm Essence", amount = 10, itemID = 242644 },
            },
            note = "Buy Plant Protein from the Auction House; everything else is sold by the vendor near the trainer.",
            difficulty = "orange",
        },
        {
            range = "35-100",
            recipe = "Spiced Biscuits + Hearty Food",
            quantity = 100,
            materials = {
                { name = "A Big Ol' Stick of Butter", amount = 200, itemID = 242643 },
                { name = "Pouch of Spices", amount = 600, itemID = 242646 },
            },
            note = "At 35 you unlock Hearty Food, which consumes your own crafted food (including Spiced Biscuits) as a reagent. Alternate crafting 100x Spiced Biscuits and then using Hearty Food on them, repeating to 100. All vendor materials, very cheap. Green for the last 25 points, so you'll need a lot of biscuits, but it's still fast.",
            difficulty = "yellow",
            isRecommended = true,
        },
    },

    -- =========================================================
    -- BEST FOOD / FEAST BUFFS (reference, not part of the leveling path)
    -- =========================================================
    bestBuffs = {
        feasts = {
            { name = "Blooming Feast", buff = "+65 Highest Secondary Stat, +98 Stamina" },
            { name = "Harandar Celebration", buff = "+50 Primary Stat, +98 Stamina" },
            { name = "Quel'dorei Medley", buff = "+65 Highest Secondary Stat, +98 Stamina (uses fish)" },
            { name = "Silvermoon Parade", buff = "+50 Primary Stat, +98 Stamina (uses fish)" },
        },
        food = {
            { name = "Champion's Bento", buff = "+65 Highest Secondary Stat" },
            { name = "Flora Frenzy", buff = "+65 Highest Secondary Stat" },
            { name = "Impossibly Royal Roast", buff = "+65 Primary Stat" },
            { name = "Royal Roast", buff = "+65 Primary Stat" },
        },
    },

    -- =========================================================
    -- PROFESSION EQUIPMENT (crafted by other professions)
    -- =========================================================
    equipment = {
        { name = "Hobbyist Rolling Pin", craftedBy = "Inscription" },
        { name = "Chef's Bright Linen Cooking Chapeau", craftedBy = "Tailoring" },
        { name = "Sin'dorei Rolling Pin", craftedBy = "Inscription" },
        { name = "Elegant Artisan's Cooking Hat", craftedBy = "Tailoring" },
    },
}
