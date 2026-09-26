-- Midnight Jewelcrafting — Leveling (+ meta)
local _, private = ...
private.Data = private.Data or {}
private.Data.Jewelcrafting = private.Data.Jewelcrafting or {}
local P = private.Data.Jewelcrafting

P.name = "Jewelcrafting"

P.icon = "Interface\\Icons\\Trade_Jewelcrafting"

P.overview = "Midnight Jewelcrafting pairs best with Mining so you can prospect your own ore and gems. Leveling to 65 is cheap and linear; 65-100 is optional unless you want guaranteed gold-quality jewelry without Concentration."

P.trainer = {

        name = "Amin",

        zone = "Silvermoon City",

        mapID = 2393,

        x = 47.0,
        y = 52.0,

        note = "Buy a Jeweler's Toolset from the supply vendor near the trainer if you don't have profession equipment yet.",

    }

P.shoppingList = {

        { name = "Cheap ore (Refulgent Copper / Umbral Tin / Brilliant Silver)", amount = 60, itemID = 237359 },

        { name = "Refulgent Copper Ore", amount = 5, itemID = 237359 },

        { name = "Umbral Tin Ore", amount = 5, itemID = 237362 },

        { name = "Glimmering Gemdust", amount = 31, itemID = 242620 },

        { name = "Crystalline Glass", amount = 100, itemID = 242786 },

        { name = "Duskshrouded Stone", amount = 7, itemID = 242788 },

        { name = "Sanguine Garnet", amount = 5, itemID = 242553 },

        { name = "Tenebrous Amethyst / Harandar Peridot / Amani Lapis", amount = 4, itemID = 242606 },

        { name = "Flawless Sanguine Garnet / Tenebrous Amethyst / Harandar Peridot / Amani Lapis", amount = 1, itemID = 242613 },

    }

P.leveling = {

        {

            range = "1-14",

            recipe = "Midnight Prospecting + Sin'dorei Lens",

            quantity = 4,

            materials = {

                { name = "Cheap ore", amount = 60, itemID = 237359 },

                { name = "Glimmering Gemdust", amount = 4, itemID = 242620 },

                { name = "Crystalline Glass", amount = 12, itemID = 242786 },

            },

            note = "Prospect 12x Midnight Prospecting with 60x cheap ore, then craft 4x Sin'dorei Lens.",

            difficulty = "orange",

        },

        {

            range = "14-50",

            recipe = "First Craft Sweep (trainer recipes)",

            quantity = 1,

            materials = {},

            note = "New recipes unlock every 5 skill points. Filter by First Craft Bonus, craft each recipe once, then check the trainer for the next batch. Repeat until the skill 50 trainer batch is done.",

            difficulty = "orange",

            isSpecial = true,

        },

        {

            range = "25",

            recipe = "Unlock Specializations",

            quantity = 0,

            materials = {},

            note = "You unlock your first Jewelcrafting specialization at skill 25.",

            difficulty = "orange",

            isSpecial = true,

        },

        {

            range = "50-65",

            recipe = "Monologuer's Chalice",

            quantity = 40,

            materials = {

                { name = "Crystalline Glass", amount = 80, itemID = 242786 },

            },

            note = "Turn off your First Craft filter first. Very cheap, craft it until it turns grey.",

            difficulty = "orange",

        },

        {

            range = "65-80",

            recipe = "Cut Eversong Diamonds",

            quantity = 1,

            materials = {},

            note = "Each diamond cut gives 2 skill points, orange to 80, yellow after. The recipes drop in Midnight dungeons or can be bought on the Auction House. Optional -- only needed for guaranteed gold-quality jewelry without Concentration.",

            difficulty = "orange",

        },

        {

            range = "80-100",

            recipe = "Rare/Epic Profession Equipment or Crafting Orders",

            quantity = 1,

            materials = {},

            note = "Rare profession equipment (bought from Gelanthis in Silvermoon City) has no time-gated materials, so spam craft it or fill Crafting Orders for other players. Epic profession equipment gives 3 skill/craft and stays orange to 100 but costs more. Ring/necklace specialization jewelry also gives skill via Crafting Orders but needs Sparks.",

            difficulty = "green",

            isRecommended = true,

        },

    }

