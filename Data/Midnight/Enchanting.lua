-- Artisan's Codex - Midnight Enchanting Data
-- Source: wow-professions.com/guides/wow-enchanting-leveling-guide (accurate as of patch 12.1)

local _, private = ...

private.Data = private.Data or {}

private.Data.Enchanting = {
    name = "Enchanting",
    icon = "Interface\\Icons\\Trade_Engraving",
    overview = "Midnight Enchanting doesn't need a gathering profession, so it pairs with anything. Put everything on an Enchanting Vellum and sell on the AH. Disenchant leftover gear before you start for free skill points up to 25.",

    trainer = {
        name = "Dolothos",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 45.0,          -- approximate, refine if needed
        y = 54.5,
        note = "Enchanting Supply vendor Lyna is next to him (sells Enchanting Vellum, Refulgent Copper Rod). Gleeful Glamours are taught separately by Jennara Sunglow, in the tower behind the trainer.",
    },

    shoppingList = {
        { name = "Eversinging Dust", amount = 412, itemID = 243599 },
        { name = "Radiant Shard", amount = 27, itemID = 243602 },
        { name = "Mote of Light", amount = 6, itemID = 236949 },
    },

    leveling = {
        {
            range = "1-25",
            recipe = "Runed Refulgent Copper Rod (craft + disenchant)",
            quantity = 30,
            materials = {
                { name = "Refulgent Copper Rod", amount = 30, itemID = 244174 },
                { name = "Eversinging Dust", amount = 150, itemID = 243599 },
            },
            note = "Craft 30x Runed Refulgent Copper Rod, then disenchant all of them for skill points up to 25 (you get about half your dust back). Buy the rods from Lyna near the trainer. If unlucky, craft one Enchant Helm - Rune of Avoidance or Thalassian Phoenix Oil to finish off 25.",
            difficulty = "orange",
        },
        {
            range = "25",
            recipe = "Unlock Specializations",
            quantity = 0,
            materials = {},
            note = "You unlock Enchanting specializations at skill 25. Don't rush picking one, just keep leveling to ~60 first.",
            difficulty = "orange",
            isSpecial = true,
        },
        {
            range = "25-27",
            recipe = "Enchant Helm - Rune of Avoidance / Thalassian Phoenix Oil",
            quantity = 1,
            materials = {
                { name = "Eversinging Dust", amount = 20, itemID = 243599 },
                { name = "Radiant Shard", amount = 3, itemID = 243602 },
                { name = "Mote of Light", amount = 5, itemID = 236949 },
                { name = "Sunglass Vial", amount = 1, itemID = 240991 },
            },
            note = "Craft one of each for the First Craft Bonuses, in this order.",
            difficulty = "orange",
        },
        {
            range = "27-38",
            recipe = "Enchant Ring - Nature's Wrath / Illusory Adornment - Blooming Light",
            quantity = 14,
            materials = {
                { name = "Eversinging Dust", amount = 70, itemID = 243599 },
                { name = "Mote of Light", amount = 14, itemID = 236949 },
            },
            note = "Craft one of each for the First Craft bonus, then craft ~13 more of the cheaper one (Enchant Ring - Nature's Wrath) to finish the range.",
            difficulty = "orange",
        },
        {
            range = "38-40",
            recipe = "Enchant Shoulders - Flight of the Eagle / Enchant Helm - Hex of Leeching",
            quantity = 1,
            materials = {
                { name = "Eversinging Dust", amount = 30, itemID = 243599 },
                { name = "Radiant Shard", amount = 6, itemID = 243602 },
            },
            note = "One of each for the First Craft Bonus.",
            difficulty = "orange",
        },
        {
            range = "40-52",
            recipe = "Thalassian Spellweaver's Wand",
            quantity = 4,
            materials = {
                { name = "Eversinging Dust", amount = 60, itemID = 243599 },
                { name = "Radiant Shard", amount = 12, itemID = 243602 },
            },
            note = "Gives 3 skill points per craft.",
            difficulty = "orange",
        },
        {
            range = "52-55",
            recipe = "Enchant Ring - Amani Mastery / Enchant Helm - Blessing of Speed / Enchant Shoulders - Thalassian Recovery",
            quantity = 1,
            materials = {
                { name = "Eversinging Dust", amount = 35, itemID = 243599 },
                { name = "Radiant Shard", amount = 6, itemID = 243602 },
            },
            note = "One of each for the First Craft Bonus.",
            difficulty = "orange",
            isSpecial = true,
        },
        {
            range = "Gleeful Glamours",
            recipe = "All 24 Gleeful Glamours (First Craft sweep)",
            quantity = 24,
            materials = {
                { name = "Eversinging Dust", amount = 48, itemID = 243599 },
                { name = "Mote of Wild Magic", amount = 10, itemID = 236951 },
                { name = "Mote of Primal Energy", amount = 8, itemID = 236950 },
                { name = "Mote of Light", amount = 4, itemID = 236949 },
                { name = "Mote of Pure Void", amount = 2, itemID = 236952 },
            },
            note = "Worth +24 Knowledge Points. Taught by Jennara Sunglow, on the second floor of the tower behind the Enchanting trainer in Silvermoon City -- not the main trainer.",
            difficulty = "orange",
            isSpecial = true,
        },
        {
            range = "55-62",
            recipe = "Enchant Ring - Amani Mastery",
            quantity = 9,
            materials = {
                { name = "Eversinging Dust", amount = 45, itemID = 243599 },
            },
            note = "Will be yellow so you might need a few extra. Gives skill up to 70 if you want to keep spamming it and don't care about selling the rings.",
            difficulty = "yellow",
        },
        {
            range = "62-90",
            recipe = "Ring / Helm / Shoulder / Chest / Weapon enchants (mixed)",
            quantity = 1,
            materials = {
                { name = "Mote of Light / Wild Magic / Primal Energy / Pure Void", amount = 15, itemID = 0 },
                { name = "Petrified Root", amount = 2, itemID = 251285 },
                { name = "Eversinging Dust", amount = 15, itemID = 243599 },
                { name = "Radiant Shard", amount = 3, itemID = 243602 },
                { name = "Dawn Crystal", amount = 1, itemID = 243605 },
            },
            note = "Craft at least 1 of every enchant you have unlocked, then sell and craft more of whichever sells best -- this recoups cost better than spamming one recipe. Rings turn yellow around 80, chests are only good to ~85, helm/weapon/shoulder stay orange to 90. Enchant Weapon - Worldsoul Aegis stays orange all the way to 100 as a fallback.",
            difficulty = "yellow",
        },
        {
            range = "90-100",
            recipe = "Enchant Weapon - Worldsoul Aegis (or other weapon enchant)",
            quantity = 1,
            materials = {
                { name = "Mote of Primal Energy", amount = 4, itemID = 236950 },
                { name = "Petrified Root", amount = 4, itemID = 251285 },
                { name = "Flawless Harandar Peridot", amount = 1, itemID = 242610 },
                { name = "Eversinging Dust", amount = 20, itemID = 243599 },
                { name = "Radiant Shard", amount = 10, itemID = 243602 },
                { name = "Dawn Crystal", amount = 2, itemID = 243605 },
            },
            note = "Only weapon enchants remain orange this late. Worldsoul Aegis is from the trainer (55) so you can always craft it for pure leveling.",
            difficulty = "orange",
            isRecommended = true,
        },
    },

    knowledgeOverview = "Enchanting Knowledge comes from one-time treasures (usually 8×3 KP) and weekly sources such as Patron Orders, a trainer quest, zone drops, an Inscription treatise, and the monthly Darkmoon Faire. Check each row below for details.",

    knowledgeCatchUp = "If you start late or miss weeks, Patron Orders can grant catch-up knowledge until you are back on pace.",

    treasures = {
        { id = "sindorei_enchanting_rod", name = "Sin'dorei Enchanting Rod", zone = "Eversong Woods", mapID = 2395, x = 63.5, y = 32.6, questID = 89107, description = "Eversong Woods.", kp = 3 },
        { id = "everblazing_sunmote", name = "Everblazing Sunmote", zone = "Eversong Woods", mapID = 2395, x = 60.8, y = 53.0, questID = 89103, description = "Eversong Woods.", kp = 3 },
        { id = "enchanted_sunfire_silk", name = "Enchanted Sunfire Silk", zone = "Eversong Woods", mapID = 2395, x = 40.2, y = 61.2, questID = 89101, description = "Eversong Woods.", kp = 3 },
        { id = "loa_blessed_dust", name = "Loa-Blessed Dust", zone = "Zul'Aman", mapID = 2437, x = 40.4, y = 51.1, questID = 89106, description = "Zul'Aman.", kp = 3 },
        { id = "enchanted_amani_mask", name = "Enchanted Amani Mask", zone = "Zul'Aman (Atal'Aman)", mapID = 2536, x = 48.4, y = 22.9, questID = 89100, description = "Atal'Aman - may be phased.", kp = 3 },
        { id = "primal_essence_orb", name = "Primal Essence Orb", zone = "Harandar", mapID = 2413, x = 65.8, y = 50.2, questID = 89105, description = "On giant mushroom trees.", kp = 3 },
        { id = "entropic_shard", name = "Entropic Shard", zone = "Harandar", mapID = 2413, x = 37.7, y = 65.3, questID = 89104, description = "Harandar.", kp = 3 },
        { id = "pure_void_crystal", name = "Pure Void Crystal", zone = "Voidstorm", mapID = 2405, x = 35.5, y = 58.8, questID = 89102, description = "Voidstorm.", kp = 3 },
    },

}