-- Midnight Fishing — Leveling (+ meta)
local _, private = ...
private.Data = private.Data or {}
private.Data.Fishing = private.Data.Fishing or {}
local P = private.Data.Fishing

P.name = "Fishing"


P.isGathering = true

P.maxSkill = 300

P.overview = "Midnight Fishing levels to 300, same cap as The War Within. Any zone works, but sticking to the recommended zone avoids grey trash. Buy an Angler's Guide from the supply vendor to track fishing pools on the minimap."

P.trainer = {

        name = "Drathen",

        zone = "Silvermoon City",

        mapID = 2393,

        x = 47.0,
        y = 60.0,

        note = "The Fishing Supply vendor sits by the water near the trainer and sells the Angler's Guide (teaches fishing pool tracking).",

    }

P.leveling = {

        {

            range = "1-75",

            recipe = "Eversong Woods, Silvermoon City, or Pool Fishing anywhere",

            quantity = 0,

            reagents = {},

            note = "Pool fishing works at any skill but is slower than open water.",

            difficulty = "orange",

        },

        {

            range = "75-150",

            recipe = "Eversong Woods, Silvermoon City",

            quantity = 0,

            reagents = {},

            note = "The 'recommended' zone skill level is when you stop getting grey trash from the previous zone -- don't switch too early.",

            difficulty = "yellow",

        },

        {

            range = "150-225",

            recipe = "Zul'Aman, or any earlier zone",

            quantity = 0,

            reagents = {},

            note = "",

            difficulty = "yellow",

        },

        {

            range = "225-300",

            recipe = "Harandar, or any earlier zone",

            quantity = 0,

            reagents = {},

            note = "Voidstorm has very little fishable water -- only two known open-water spots, plus rare Oceanic Vortex bubbles.",

            difficulty = "green",

            isRecommended = true,

        },

    }

P.equipment = {

        { name = "Farstrider Hobbyist Rod", craftedBy = "Engineering" },

        { name = "Sin'dorei Angler's Rod", craftedBy = "Engineering" },

        { name = "Sin'dorei Reeler's Rod", craftedBy = "Engineering" },

    }

P.notableFish = {

        { name = "Blood Hunter", note = "Spawns a hostile spirit when fished up; kill it for an extra Blood Hunter. Craft an Amani Angler's Ward to stop spirits from spawning for 30 min." },

        { name = "Warping Wise", note = "Using this fish teleports you to a random location in a random Midnight zone." },

    }

P.tips = {

        "Buy the Angler's Guide from the Fishing supply vendor to track pools on the minimap.",

        "The Better Fishing addon lets you bind Cast and Interact to one key so you can fish while watching something else.",

        "Fishing recipes (lures, Amani Angler's Ward) are BoP and drop from Careless Cargo / Lost Treasures pools, not taught by the trainer.",

        "The Midnight Angler's Grand Line (doubles treasure drops) is built by combining fished-up line fragments -- no profession skill required.",

    }

