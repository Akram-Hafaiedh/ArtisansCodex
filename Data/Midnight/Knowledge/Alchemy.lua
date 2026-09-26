-- Midnight Alchemy — Knowledge
local _, private = ...
private.Data = private.Data or {}
private.Data.Alchemy = private.Data.Alchemy or {}
local P = private.Data.Alchemy

P.knowledgeOverview = "Alchemy Knowledge comes from one-time sources (8 treasures × 3 KP and a renown book for 10 KP) plus weekly sources. Patron Orders are the bulk of weekly KP (~12). Expect about 18 KP/week if you complete everything."

P.knowledgeCatchUp = "If you fall behind, Patron Orders grant Flicker of Midnight Alchemy Knowledge until you catch up."

P.oneTime = {

        {

            id = "renown_book",

            name = "Beyond the Event Horizon: Alchemy",

            itemID = 262645,

            kp = 10,

            kind = "renown_book",

            note = "Sold by Void Researcher Anomander in Voidstorm for 75 Artisan Alchemist's Moxie. Requires Renown 9 with The Singularity.",

            vendor = "Void Researcher Anomander",

            zone = "Voidstorm",

        },

    }

P.knowledgeTips = {

        "You only need Skill 1 in the Midnight profession tier to loot knowledge treasures.",

        "Treasures are character-specific — each alt can collect their own set.",

        "If you are on the coords but see nothing: check inside buildings/caves, fly up/down for vertical position, or finish campaign phasing (Atal'Aman).",

        "Trainer weekly quest unlocks after the Crafters Needed questline from Captain Flaresworn.",

    }

P.knowledgeUnlock = {

        questID = 93723,

        questName = "Crafters Needed",

        npcName = "Captain Flaresworn",

        note = "Required to unlock the trainer weekly Knowledge quest.",

    }

P.treasures = {

        {

            id = "pristine_potion",

            name = "Pristine Potion",

            itemID = 238538,

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

            itemID = 238532,

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

            itemID = 238536,

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

            itemID = 238535,

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

            itemID = 238537,

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

            itemID = 238534,

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

            itemID = 238539,

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

            itemID = 238533,

            zone = "Voidstorm (Slayer's Rise)",

            mapID = 2444,

            x = 41.9,

            y = 40.6,

            questID = 89112,

            description = "Voidstorm, Slayer's Rise.",

            kp = 3,

        },

    }

P.weekly = {

        {

            name = "Patron Crafting Orders",

            kp = "~12",

            itemID = 246321,

            note = "Main weekly source. Some orders award Glimmer of Midnight Alchemy Knowledge.",

        },

        {

            name = "Weekly Quest (Trainer)",

            kp = 1,

            itemID = 263454,

            note = "Complete 3 Crafting Orders for a Thalassian Alchemist's Notebook. Unlocked after Crafters Needed.",

        },

        {

            name = "Weekly Zone Drops",

            kp = 4,

            itemIDs = { 259188, 259189 },

            note = "Lightbloomed Spore Sample + Aged Cruor (1 of each per week from treasures).",

        },

        {

            name = "Thalassian Treatise on Alchemy",

            kp = 1,

            itemID = 245755,

            note = "BoP from Inscription. Public Crafting Order, or craft on an Inscription alt.",

        },

        {

            name = "Darkmoon Faire",

            kp = 3,

            note = "Monthly profession quest: +3 Knowledge and +2 Skill.",

        },

    }

