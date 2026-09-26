-- Midnight Herbalism — Leveling (+ meta)
local _, private = ...
private.Data = private.Data or {}
private.Data.Herbalism = private.Data.Herbalism or {}
local P = private.Data.Herbalism

P.name = "Herbalism"

P.icon = "Interface\\Icons\\Trade_Herbalism"

P.isGathering = true

P.overview = "Herbalism now has only two quality tiers (Silver/Gold). Base herbs carry you to about skill 30, Lush/Infused herbs carry the rest. Pairs best with Alchemy or Inscription."

P.trainer = {

        name = "Botanist Nathera",

        zone = "Silvermoon City",

        mapID = 2393,

        x = 48.0,
        y = 53.0,

        note = "Artisan Herbalist's Moxie is the profession-specific currency for Herbalism unlocks.",

    }

P.leveling = {

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

    }

P.infusedTypes = {

        { type = "Lightfused", zone = "Eversong Woods", mote = "Mote of Light" },

        { type = "Wild", zone = "Zul'Aman", mote = "Mote of Wild Magic" },

        { type = "Primal", zone = "Harandar", mote = "Mote of Primal Energy" },

        { type = "Voidbound", zone = "Voidstorm", mote = "Mote of Pure Void" },

    }

P.equipment = {

        { name = "Bright Linen Herbalism Hat", craftedBy = "Tailoring" },

        { name = "Eversong Botanist's Satchel", craftedBy = "Leatherworking" },

        { name = "Thalassian Sickle", craftedBy = "Blacksmithing" },

        { name = "Sun-Blessed Sickle", craftedBy = "Blacksmithing" },

    }

P.consumables = {

        { name = "Azeroot Tea", effect = "+50 Deftness (+16.6%), 1 hour" },

        { name = "Darkmoon Firewater", effect = "+15% Deftness, 1 hour" },

        { name = "Argentleaf Tea", effect = "+50 Finesse (+5.0%), 1 hour" },

        { name = "Sanguithorn Tea", effect = "+50 Perception (+5.0%), 1 hour" },

        { name = "Haranir Phial of Finesse", effect = "+38 Finesse, +11 Deftness, 30 min" },

        { name = "Refulgent Razorstone", effect = "+43 Finesse for gathering tools, 2 hours" },

    }

P.zones = {

        { name = "Eversong Woods", note = "Easiest terrain, lowest mob density. Recommended starting zone." },

        { name = "Zul'Aman", note = "Not recommended for pure gathering leveling -- Wild infused herbs summon mobs that can be tough without gear." },

        { name = "Harandar", note = "Probably the most annoying zone to farm -- herbs on mushrooms and hidden in bushes, lots of vertical movement." },

        { name = "Voidstorm", note = "Highest mob density around nodes. High Deftness recommended." },

    }

