-- Midnight Skinning — Knowledge
local _, private = ...
private.Data = private.Data or {}
private.Data.Skinning = private.Data.Skinning or {}
local P = private.Data.Skinning

P.knowledgeOverview = "Skinning Knowledge comes from one-time treasures (usually 8×3 KP) and weekly sources such as Patron Orders, a trainer quest, zone drops, an Inscription treatise, and the monthly Darkmoon Faire. Check each row below for details."

P.knowledgeCatchUp = "If you start late or miss weeks, Patron Orders can grant catch-up knowledge until you are back on pace."

P.oneTime = {

        {

            id = "renown_book",

            name = "Whisper of the Loa: Skinning",

            itemID = 250923,

            kp = 10,

            kind = "renown_book",

            note = "Sold by Magovu in Zul'Aman for 75 Artisan Skinner's Moxie. Requires Renown 6 with Amani Tribe.",

            vendor = "Magovu",

            zone = "Zul'Aman",

        },

    }

P.treasures = {

        { id = "sindorei_tanning_oil", name = "Sin'dorei Tanning Oil",

            itemID = 238633, zone = "Silvermoon City", mapID = 2393, x = 43.2, y = 55.7, questID = 89171, kp = 3 },

        { id = "thalassian_skinning_knife", name = "Thalassian Skinning Knife",

            itemID = 238635, zone = "Eversong Woods", mapID = 2395, x = 48.4, y = 76.3, questID = 89173, kp = 3 },

        { id = "cadre_skinning_knife", name = "Cadre Skinning Knife",

            itemID = 238629, zone = "Zul'Aman (Atal'Aman)", mapID = 2536, x = 44.9, y = 45.2, questID = 89167, description = "May be phased -- progress the campaign further if it doesn't show.", kp = 3 },

        { id = "amani_skinning_knife", name = "Amani Skinning Knife",

            itemID = 238634, zone = "Zul'Aman", mapID = 2437, x = 33.1, y = 79.1, questID = 89172, kp = 3 },

        { id = "amani_tanning_oil", name = "Amani Tanning Oil",

            itemID = 238632, zone = "Zul'Aman", mapID = 2437, x = 40.4, y = 36.0, questID = 89170, kp = 3 },

        { id = "primal_hide", name = "Primal Hide",

            itemID = 238630, zone = "Harandar", mapID = 2413, x = 69.5, y = 49.2, questID = 89168, kp = 3 },

        { id = "lightbloom_afflicted_hide", name = "Lightbloom Afflicted Hide",

            itemID = 238628, zone = "Harandar", mapID = 2413, x = 76.0, y = 51.0, questID = 89166, kp = 3 },

        { id = "voidstorm_leather_sample", name = "Voidstorm Leather Sample",

            itemID = 238631, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 45.5, y = 42.3, questID = 89169, kp = 3 },

    }

P.weekly = {

        {

            name = "Trainer Quest",

            kp = 3,

            itemID = 263461,

            note = "Weekly quest from the Skinning trainer. Rewards Thalassian Skinner's Notes.",

        },

        {

            name = "Gathering Drops",

            kp = "~8",

            itemIDs = { 238625, 238626 },

            note = "Fine Void-Tempered Hide (1 KP, up to 5/week) then Mana-Infused Bone (3 KP) while skinning.",

        },

        {

            name = "Thalassian Treatise on Skinning",

            kp = 1,

            itemID = 245828,

            note = "BoP from Inscription. Public Crafting Order, or craft on an Inscription alt.",

        },

        {

            name = "Darkmoon Faire",

            kp = 3,

            note = "Monthly profession quest: +3 Knowledge and +2 Skill.",

        },

    }

