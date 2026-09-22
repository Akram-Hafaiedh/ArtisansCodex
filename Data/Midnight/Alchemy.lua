-- Artisan's Codex - Midnight Alchemy Data
-- Source: wow-professions.com (accurate as of patch 12.1)

local _, private = ...

private.Data = private.Data or {}

private.Data.Alchemy = {
    name = "Alchemy",
    icon = "Interface\\Icons\\Trade_Alchemy",
    overview = "Midnight Alchemy uses a new deterministic discovery system called Camberon's Cauldron (no RNG). You unlock recipes by meeting simple requirements and spending Artisan Alchemist's Moxie. Best paired with Herbalism.",

    trainer = {
        name = "Camberon",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 47.0,
        y = 51.8,
        note = "Alchemy Supply vendor Melaris is right next to him (buys Sunglass Vials, Oil of Heartwood, etc.).",
    },

    -- =========================================================
    -- LEVELING GUIDE
    -- =========================================================
    leveling = {
        {
            range = "1-7",
            recipe = "Silvermoon Health Potion",
            quantity = 6,
            materials = {
                { name = "Tranquility Bloom", amount = 36, itemID = 236767 },
                { name = "Sunglass Vial", amount = 30, itemID = 240991 },
            },
            note = "Buy Sunglass Vials from Melaris next to the trainer.",
            difficulty = "orange",
        },
        {
            range = "7-20",
            recipe = "Recycle Potions",
            quantity = 10,
            materials = {
                { name = "Silvermoon Health Potion", amount = 10, itemID = 240980 },
                { name = "Oil of Heartwood", amount = 10, itemID = 241010 },
            },
            note = "Recycle the potions you just crafted. Oil of Heartwood is sold by Melaris.",
            difficulty = "orange",
        },
        {
            range = "20-27",
            recipe = "First Crafts + Cauldron Unlocks",
            quantity = 1,
            materials = {},
            note = "Important: Use Camberon's Cauldron (next to trainer) to unlock new recipes. Then do the first crafts below for Knowledge Points.",
            difficulty = "orange",
            isSpecial = true,
        },
        {
            range = "First Crafts",
            recipe = "Refreshing Serum",
            quantity = 1,
            materials = {
                { name = "Tranquility Bloom", amount = 8, itemID = 236767 },
                { name = "Sanguithorn", amount = 3, itemID = 236780 },
                { name = "Sunglass Vial", amount = 5, itemID = 240991 },
            },
            note = "First craft bonus.",
            difficulty = "orange",
        },
        {
            range = "First Crafts",
            recipe = "Lightfused Mana Potion",
            quantity = 1,
            materials = {
                { name = "Tranquility Bloom", amount = 8, itemID = 236767 },
                { name = "Mana Lily", amount = 3, itemID = 236785 },
                { name = "Sunglass Vial", amount = 5, itemID = 240991 },
            },
            note = "First craft bonus.",
            difficulty = "orange",
        },
        {
            range = "First Crafts",
            recipe = "Primal Philosopher's Stone",
            quantity = 1,
            materials = {
                { name = "Stabilized Derivate", amount = 2, itemID = 241020 },
                { name = "Mote of Light", amount = 2, itemID = 236949 },
                { name = "Refreshing Serum", amount = 5, itemID = 240985 },
            },
            note = "Required for transmutes. Previous expansion Philosopher's Stone also works.",
            difficulty = "orange",
        },
        {
            range = "27-32",
            recipe = "Entropic Extract",
            quantity = 8,
            materials = {
                { name = "Tranquility Bloom", amount = 24, itemID = 236767 },
                { name = "Sunglass Vial", amount = 40, itemID = 240991 },
            },
            note = "Reaching exactly 32 is not critical.",
            difficulty = "orange",
        },
        {
            range = "32-50",
            recipe = "Silvermoon Health Potion",
            quantity = 30,
            materials = {
                { name = "Tranquility Bloom", amount = 180, itemID = 236767 },
                { name = "Sunglass Vial", amount = 150, itemID = 240991 },
            },
            note = "Recipe will be yellow. You may need a few extra crafts.",
            difficulty = "yellow",
        },
        {
            range = "50-100",
            recipe = "Light's Potential",
            itemID = 241050,
            quantity = 80,
            materials = {
                { name = "Mote of Light", amount = 80, itemID = 236949 },
                { name = "Tranquility Bloom", amount = 640, itemID = 236767 },
                { name = "Azeroot", amount = 240, itemID = 236790 },
                { name = "Argentleaf", amount = 240, itemID = 236795 },
                { name = "Sunglass Vial", amount = 400, itemID = 240991 },
            },
            note = "Unlock from Camberon's Cauldron (50 Moxie). Gives 1 skill per craft all the way to 100. Turns yellow at 80, green at 90.",
            difficulty = "green",
            isRecommended = true,
        },
    },

    -- =========================================================
    -- KNOWLEDGE TREASURES
    -- =========================================================
    treasures = {
        {
            id = "pristine_potion",
            name = "Pristine Potion",
            zone = "Silvermoon City",
            mapID = 2393,
            x = 47.8,
            y = 51.8,
            questID = 89117,
            description = "Fly up. The treasure is on top of the building behind the Alchemy trainer.",
            kp = 3,
        },
        {
            id = "vial_eversong",
            name = "Vial of Eversong Oddities",
            zone = "Silvermoon City",
            mapID = 2393,
            x = 45.1,
            y = 44.7,
            questID = 89111,
            description = "Silvermoon City.",
            kp = 3,
        },
        {
            id = "freshly_plucked",
            name = "Freshly Plucked Peacebloom",
            zone = "Silvermoon City",
            mapID = 2393,
            x = 49.1,
            y = 75.8,
            questID = 89115,
            description = "Silvermoon City.",
            kp = 3,
        },
        {
            id = "vial_zulaman",
            name = "Vial of Zul'Aman Oddities",
            zone = "Zul'Aman",
            mapID = 2437,
            x = 40.4,
            y = 51.1,
            questID = 89114,
            description = "Zul'Aman.",
            kp = 3,
        },
        {
            id = "measured_ladle",
            name = "Measured Ladle",
            zone = "Zul'Aman (Atal'Aman)",
            mapID = 2536,
            x = 49.1,
            y = 23.6,
            questID = 89116,
            description = "This treasure is in Atal'Aman and may be phased. You might need to progress further in the campaign.",
            kp = 3,
        },
        {
            id = "vial_rootlands",
            name = "Vial of Rootlands Oddities",
            zone = "Harandar",
            mapID = 2413,
            x = 34.8,
            y = 24.7,
            questID = 89113,
            description = "Inside the building.",
            kp = 3,
        },
        {
            id = "failed_experiment",
            name = "Failed Experiment",
            zone = "Voidstorm",
            mapID = 2405,
            x = 32.8,
            y = 43.3,
            questID = 89118,
            description = "Voidstorm.",
            kp = 3,
        },
        {
            id = "vial_voidstorm",
            name = "Vial of Voidstorm Oddities",
            zone = "Voidstorm (Slayer's Rise)",
            mapID = 2444,
            x = 41.9,
            y = 40.6,
            questID = 89112,
            description = "Voidstorm, Slayer's Rise.",
            kp = 3,
        },
    },

    -- =========================================================
    -- WEEKLY KNOWLEDGE
    -- =========================================================
    weekly = {
        { name = "Patron Crafting Orders", kp = "~12", note = "Main source. Not all orders give knowledge." },
        { name = "Weekly Quest (Trainer)", kp = 1, note = "Complete 3 Crafting Orders. Unlocked after Crafters Needed questline." },
        { name = "Weekly Drops", kp = 4, note = "Lightbloomed Spore Sample + Aged Cruor (1 of each per week from treasures)." },
        { name = "Thalassian Treatise on Alchemy", kp = 1, note = "Crafted by Inscription (BoP). Can be ordered via Public Orders." },
        { name = "Darkmoon Faire", kp = 3, note = "Once per month. +3 Knowledge and +2 Skill." },
    },

    -- =========================================================
    -- SPECIALIZATION BUILDS
    -- =========================================================
    specializations = {
        {
            name = "Extra Flask Duration",
            goal = "Raiding / Mythic+",
            description = "Start here if you regularly use flasks. Gets the duration increase first.",
            steps = {
                "Put 15 points into Fluent in Flasks (root node)",
                "Duration increase unlocks at 5 and 15 points",
                "Then switch to the Flask Selling path",
            },
        },
        {
            name = "Selling Flasks (AH)",
            goal = "Auction House Gold",
            description = "Best for most players who want to sell consumables.",
            steps = {
                "10 points → Fluent in Flasks (root)",
                "10 points → Sin'dorei Specialist",
                "20 points → Flask Abundance (Multicraft)",
                "10 points → Alchemical Mastery",
                "20 points → Recycle (Resourcefulness)",
                "Then max the previous nodes for Gold quality + Cauldron",
            },
        },
        {
            name = "Selling Potions (AH)",
            goal = "Auction House Gold",
            description = "High demand alternative to flasks.",
            steps = {
                "10 points → Potion Prowess (root)",
                "10 points → Path of Void or Path of Light",
                "20 points → Prolific Potioneer (Multicraft)",
                "10 points → Alchemical Mastery",
                "20 points → Reuse (Resourcefulness)",
                "Then max nodes for Gold quality + Potion Cauldron",
            },
        },
        {
            name = "Transmutes",
            goal = "Daily CD + Mote Gold",
            description = "Focus on Wondrous Synergist daily and mote transmutes.",
            steps = {
                "10 points → Transmutation Authority root (unlock Metamorphic Mastery + Synthesis Synergy)",
                "20 points → Metamorphic Mastery",
                "20 points → Synthesis Synergy (reduces Wondrous Synergist CD)",
                "10 points → Alchemical Mastery",
                "20 points → Reduce (Resourcefulness)",
            },
        },
    },
}