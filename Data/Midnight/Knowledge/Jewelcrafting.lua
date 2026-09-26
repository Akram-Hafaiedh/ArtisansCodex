-- Midnight Jewelcrafting — Knowledge
local _, private = ...
private.Data = private.Data or {}
private.Data.Jewelcrafting = private.Data.Jewelcrafting or {}
local P = private.Data.Jewelcrafting

P.knowledgeOverview = "Jewelcrafting Knowledge comes from one-time treasures (usually 8×3 KP) and weekly sources such as Patron Orders, a trainer quest, zone drops, an Inscription treatise, and the monthly Darkmoon Faire. Check each row below for details."

P.knowledgeCatchUp = "If you start late or miss weeks, Patron Orders can grant catch-up knowledge until you are back on pace."

P.oneTime = {

        {

            id = "renown_book",

            name = "Skill Issue: Jewelcrafting",

            itemID = 257599,

            kp = 10,

            kind = "renown_book",

            note = "Sold by Caeris Fairdawn in Eversong Woods for 75 Artisan Jewelcrafter's Moxie. Requires Renown 6 with Silvermoon Court.",

            vendor = "Caeris Fairdawn",

            zone = "Eversong Woods",

        },

    }

P.weekly = {

        {

            name = "Patron Crafting Orders",

            kp = "~12",

            itemID = 246331,

            note = "Main weekly source. Some orders award Glimmer of Midnight Jewelcrafting Knowledge.",

        },

        {

            name = "Weekly Quest (Trainer)",

            kp = 1,

            itemID = 263458,

            note = "Complete 3 Crafting Orders for a Thalassian Jewelcrafter's Notebook.",

        },

        {

            name = "Weekly Zone Drops",

            kp = 2,

            itemID = 259198,

            note = "Void-Touched Eversong Diamond Fragments from zone treasures.",

        },

        {

            name = "Thalassian Treatise on Jewelcrafting",

            kp = 1,

            itemID = 245760,

            note = "BoP from Inscription. Public Crafting Order, or craft on an Inscription alt.",

        },

        {

            name = "Darkmoon Faire",

            kp = 3,

            note = "Monthly profession quest: +3 Knowledge and +2 Skill.",

        },

    }

P.treasures = {

        { id = "sindorei_masterwork_chisel", name = "Sin'dorei Masterwork Chisel",

            itemID = 238580, zone = "Silvermoon City", mapID = 2393, x = 50.6, y = 56.6, questID = 89122, description = "Silvermoon City.", kp = 3 },

        { id = "vintage_soul_gem", name = "Vintage Soul Gem",

            itemID = 238585, zone = "Silvermoon City", mapID = 2393, x = 55.4, y = 48.0, questID = 89127, description = "Silvermoon City.", kp = 3 },

        { id = "dual_function_magnifiers", name = "Dual-Function Magnifiers",

            itemID = 238582, zone = "Silvermoon City", mapID = 2393, x = 28.6, y = 46.5, questID = 89124, description = "Silvermoon City.", kp = 3 },

        { id = "poorly_rounded_vial", name = "Poorly Rounded Vial",

            itemID = 238583, zone = "Eversong Woods", mapID = 2395, x = 56.6, y = 40.9, questID = 89125, description = "Eversong Woods.", kp = 3 },

        { id = "sindorei_gem_faceters", name = "Sin'dorei Gem Faceters",

            itemID = 238587, zone = "Eversong Woods", mapID = 2395, x = 39.6, y = 38.9, questID = 89129, description = "Eversong Woods.", kp = 3 },

        { id = "speculative_voidstorm_crystal", name = "Speculative Voidstorm Crystal",

            itemID = 238581, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 30.5, y = 69.1, questID = 89123, description = "Voidstorm, Slaver's Rise.", kp = 3 },

        { id = "ethereal_gem_pliers", name = "Ethereal Gem Pliers",

            itemID = 238586, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 54.2, y = 51.2, questID = 89128, description = "Voidstorm, Slaver's Rise.", kp = 3 },

        { id = "shattered_glass", name = "Shattered Glass",

            itemID = 238584, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 62.7, y = 53.4, questID = 89126, description = "Voidstorm, Slaver's Rise.", kp = 3 },

    }

