-- Midnight Herbalism — Knowledge
local _, private = ...
private.Data = private.Data or {}
private.Data.Herbalism = private.Data.Herbalism or {}
local P = private.Data.Herbalism

P.oneTime = {

        {

            id = "renown_book",

            name = "Traditions of the Haranir: Herbalism",

            itemID = 258410,

            kp = 10,

            kind = "renown_book",

            note = "Sold by Naynar in Harandar for 75 Artisan Herbalist's Moxie. Requires Renown 6 with Hara'ti.",

            vendor = "Naynar",

            zone = "Harandar",

        },

    }

P.weekly = {

        {

            name = "Trainer Quest",

            kp = 3,

            itemID = 263462,

            note = "Weekly quest from the Herbalism trainer. Rewards Thalassian Herbalist's Notes.",

        },

        {

            name = "Gathering Drops",

            kp = "~9",

            itemIDs = { 238467, 238466 },

            note = "Thalassian Phoenix Ember (1 KP, up to 5/week) then Thalassian Phoenix Tail while herbing.",

        },

        {

            name = "Thalassian Treatise on Herbalism",

            kp = 1,

            itemID = 245761,

            note = "BoP from Inscription. Public Crafting Order, or craft on an Inscription alt.",

        },

        {

            name = "Darkmoon Faire",

            kp = 3,

            note = "Monthly profession quest: +3 Knowledge and +2 Skill.",

        },

    }

P.treasures = {

        {

            id = "simple_leaf_pruners",

            name = "Simple Leaf Pruners",

            itemID = 238470,

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

            itemID = 238472,

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

            itemID = 238469,

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

            itemID = 238474,

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

            itemID = 238475,

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

            itemID = 238468,

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

            itemID = 238471,

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

            itemID = 238473,

            zone = "Harandar",

            mapID = 2413,

            x = 76.1,

            y = 51.1,

            questID = 89157,

            description = "Harandar.",

            kp = 3,

        },

    }

