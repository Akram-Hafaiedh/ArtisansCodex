-- Artisan's Codex - Midnight Alchemy Data
-- Source: wow-professions.com/guides/wow-alchemy-leveling-guide (accurate as of patch 12.1)
-- Rewritten to correct item IDs and match the current leveling path.

local _, private = ...

private.Data = private.Data or {}

private.Data.Alchemy = {
    name = "Alchemy",
    icon = "Interface\\Icons\\Trade_Alchemy",
    overview = "Midnight Alchemy uses Camberon's Cauldron, a deterministic (no-RNG) discovery system. You unlock recipes by meeting simple requirements and spending Artisan Alchemist's Moxie. Pairs best with Herbalism.",

    trainer = {
        name = "Camberon",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 47.0,          -- approximate, refine if needed
        y = 51.8,
        note = "Alchemy Supply vendor Melaris is right next to him (buys/sells Sunglass Vial, Oil of Heartwood, etc.).",
    },

    -- =========================================================
    -- SHOPPING LIST (1-50, approximate)
    -- =========================================================
    shoppingList = {
        { name = "Tranquility Bloom", amount = 300, itemID = 236761 },
        { name = "Sanguithorn", amount = 15, itemID = 236770 },
        { name = "Mote of Light", amount = 12, itemID = 236949 },
        { name = "Argentleaf", amount = 4, itemID = 236776 },
        { name = "Mote of Primal Energy", amount = 4, itemID = 236950 },
        { name = "Mana Lily", amount = 3, itemID = 236778 },
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
                { name = "Tranquility Bloom", amount = 36, itemID = 236761 },
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
                { name = "Oil of Heartwood", amount = 10, itemID = 247811 },
            },
            note = "Recycle the Silvermoon Health Potions you just made. Oil of Heartwood is sold by Melaris next to the trainer.",
            difficulty = "orange",
        },
        {
            range = "20-27",
            recipe = "Camberon's Cauldron Discovery",
            quantity = 1,
            materials = {},
            note = "Important, don't skip: interact with Camberon's Cauldron next to the trainer and research Primal Philosopher's Stone and Lightfused Mana Potion. It's not RNG, you just pick what to learn and spend Moxie.",
            difficulty = "orange",
            isSpecial = true,
        },
        {
            range = "First Crafts",
            recipe = "Refreshing Serum",
            quantity = 1,
            materials = {
                { name = "Tranquility Bloom", amount = 8, itemID = 236761 },
                { name = "Sanguithorn", amount = 3, itemID = 236770 },
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
                { name = "Tranquility Bloom", amount = 8, itemID = 236761 },
                { name = "Mana Lily", amount = 3, itemID = 236778 },
                { name = "Sunglass Vial", amount = 5, itemID = 240991 },
            },
            note = "First craft bonus. Unlocked from Camberon's Cauldron.",
            difficulty = "orange",
        },
        {
            range = "First Crafts",
            recipe = "Primal Philosopher's Stone",
            quantity = 1,
            materials = {
                { name = "Stabilized Derivate", amount = 2, itemID = 242651 },
                { name = "Mote of Light", amount = 2, itemID = 236949 },
                { name = "Refreshing Serum", amount = 5, itemID = 0 },
            },
            note = "Required for transmutes -- craft it before the Mote of Wild Magic transmute below. A Philosopher's Stone from a previous expansion also works. Unlocked from Camberon's Cauldron.",
            difficulty = "orange",
        },
        {
            range = "First Crafts",
            recipe = "Transmute: Mote of Wild Magic",
            quantity = 1,
            materials = {
                { name = "Mote of Light", amount = 10, itemID = 236949 },
                { name = "Stabilized Derivate", amount = 1, itemID = 242651 },
            },
            note = "First craft bonus.",
            difficulty = "orange",
        },
        {
            range = "First Crafts",
            recipe = "Composite Flora",
            quantity = 1,
            materials = {
                { name = "Mote of Wild Magic", amount = 4, itemID = 236951 },
                { name = "Mote of Primal Energy", amount = 4, itemID = 236950 },
                { name = "Tranquility Bloom", amount = 6, itemID = 236761 },
                { name = "Argentleaf", amount = 4, itemID = 236776 },
            },
            note = "First craft bonus.",
            difficulty = "orange",
        },
        {
            range = "First Crafts",
            recipe = "Enlightenment Tonic",
            quantity = 1,
            materials = {
                { name = "Tranquility Bloom", amount = 3, itemID = 236761 },
                { name = "Sunglass Vial", amount = 5, itemID = 240991 },
            },
            note = "First craft bonus.",
            difficulty = "orange",
        },
        {
            range = "First Crafts",
            recipe = "Entropic Extract",
            quantity = 1,
            materials = {
                { name = "Tranquility Bloom", amount = 3, itemID = 236761 },
                { name = "Sunglass Vial", amount = 5, itemID = 240991 },
            },
            note = "First craft bonus. You'll craft a lot more of this in the 27-32 step below.",
            difficulty = "orange",
        },
        {
            range = "25",
            recipe = "Unlock Specializations",
            quantity = 0,
            materials = {},
            note = "You unlock your first Alchemy specialization at skill 25.",
            difficulty = "orange",
            isSpecial = true,
        },
        {
            range = "27-32",
            recipe = "Entropic Extract",
            quantity = 8,
            materials = {
                { name = "Tranquility Bloom", amount = 24, itemID = 236761 },
                { name = "Sunglass Vial", amount = 40, itemID = 240991 },
            },
            note = "Reaching exactly 32 is not important, this is just an estimate.",
            difficulty = "orange",
        },
        {
            range = "32-50",
            recipe = "Silvermoon Health Potion",
            quantity = 30,
            materials = {
                { name = "Tranquility Bloom", amount = 180, itemID = 236761 },
                { name = "Sunglass Vial", amount = 150, itemID = 240991 },
            },
            note = "Recipe will be yellow, so you may not reach exactly 50 -- that's fine unless you need it for a recipe or spec unlock.",
            difficulty = "yellow",
        },

        -- =========================================================
        -- FORK
        -- =========================================================
        {
            type = "fork",
            range = "50-100",
            paths = {
                {
                    key = "potions",
                    label = "Light's Potential (Potions)",
                    description = "Cheapest, no spec needed",
                    intro = "Unlock Light's Potential from Camberon's Cauldron (50 Moxie) and spam craft it all the way to 100. Cheap and gives a useful potion to sell.",
                },
                {
                    key = "flasks",
                    label = "Sin'dorei Flasks",
                    description = "2 skill/craft until 90, needs Fluent in Flasks spec",
                    intro = "If you have the Flask specialization unlocked, craft Sin'dorei flasks instead. More expensive but gives usable/sellable flasks.",
                },
            },
        },

        -- Potions path
        {
            range = "50-100",
            path = "potions",
            recipe = "Light's Potential",
            itemID = 0,
            quantity = 80,
            materials = {
                { name = "Mote of Light", amount = 80, itemID = 236949 },
                { name = "Tranquility Bloom", amount = 640, itemID = 236761 },
                { name = "Azeroot", amount = 240, itemID = 236774 },
                { name = "Argentleaf", amount = 240, itemID = 236776 },
                { name = "Sunglass Vial", amount = 400, itemID = 240991 },
            },
            note = "Unlock from Camberon's Cauldron (50x Artisan Alchemist's Moxie). Gives 1 skill point per craft, turning yellow at 80 and green at 90.",
            difficulty = "green",
            isRecommended = true,
        },

        -- Flasks path
        {
            range = "50-100",
            path = "flasks",
            recipe = "Sin'dorei Flasks (Magisters / Blood Knights / Shattered Sun)",
            quantity = 45,
            materials = {
                { name = "Nocturnal Lotus", amount = 45, itemID = 236780 },
                { name = "Sanguithorn", amount = 360, itemID = 236770 },
                { name = "Mana Lily", amount = 270, itemID = 236778 },
                { name = "Mote of Pure Void / Mote of Wild Magic / Mote of Primal Energy", amount = 90, itemID = 0 },
            },
            note = "Flask of the Magisters, Flask of the Blood Knights, and Flask of the Shattered Sun each need ~45 crafts. Give 2 skill per craft until 90, yellow to 95, green after. Blood Knights/Shattered Sun flasks unlock from Camberon's Cauldron after crafting 10 Sin'dorei flasks (50 Moxie each).",
            difficulty = "yellow",
        },
    },

    -- =========================================================
    -- KNOWLEDGE TREASURES
    -- =========================================================
    knowledgeOverview = "Alchemy Knowledge comes from one-time sources (8 treasures × 3 KP and a renown book for 10 KP) plus weekly sources. Patron Orders are the bulk of weekly KP (~12). Expect about 18 KP/week if you complete everything.",

    knowledgeCatchUp = "If you fall behind, Patron Orders grant Flicker of Midnight Alchemy Knowledge until you catch up.",

    oneTime = {
        {
            id = "renown_book",
            name = "Beyond the Event Horizon: Alchemy",
            kp = 10,
            kind = "renown_book",
            note = "Sold by Void Researcher Anomander in Voidstorm for 75 Artisan Alchemist's Moxie. Requires Renown 9 with The Singularity.",
            vendor = "Void Researcher Anomander",
            zone = "Voidstorm",
        },
    },

    knowledgeTips = {
        "You only need Skill 1 in the Midnight profession tier to loot knowledge treasures.",
        "Treasures are character-specific — each alt can collect their own set.",
        "If you are on the coords but see nothing: check inside buildings/caves, fly up/down for vertical position, or finish campaign phasing (Atal'Aman).",
        "Trainer weekly quest unlocks after the Crafters Needed questline from Captain Flaresworn.",
    },

    knowledgeUnlock = {
        questID = 93723,
        questName = "Crafters Needed",
        npcName = "Captain Flaresworn",
        note = "Required to unlock the trainer weekly Knowledge quest.",
    },

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