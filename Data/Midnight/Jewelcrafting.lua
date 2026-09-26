-- Artisan's Codex - Midnight Jewelcrafting Data
-- Source: wow-professions.com/guides/wow-jewelcrafting-leveling-guide (accurate as of patch 12.1)

local _, private = ...

private.Data = private.Data or {}

private.Data.Jewelcrafting = {
    name = "Jewelcrafting",
    icon = "Interface\\Icons\\Trade_Jewelcrafting",
    overview = "Midnight Jewelcrafting pairs best with Mining so you can prospect your own ore and gems. Leveling to 65 is cheap and linear; 65-100 is optional unless you want guaranteed gold-quality jewelry without Concentration.",

    trainer = {
        name = "Amin",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 47.0,          -- approximate, refine if needed
        y = 52.0,
        note = "Buy a Jeweler's Toolset from the supply vendor near the trainer if you don't have profession equipment yet.",
    },

    shoppingList = {
        { name = "Cheap ore (Refulgent Copper / Umbral Tin / Brilliant Silver)", amount = 60, itemID = 237359 },
        { name = "Refulgent Copper Ore", amount = 5, itemID = 237359 },
        { name = "Umbral Tin Ore", amount = 5, itemID = 237362 },
        { name = "Glimmering Gemdust", amount = 31, itemID = 242620 },
        { name = "Crystalline Glass", amount = 100, itemID = 242786 },
        { name = "Duskshrouded Stone", amount = 7, itemID = 242788 },
        { name = "Sanguine Garnet", amount = 5, itemID = 242553 },
        { name = "Tenebrous Amethyst / Harandar Peridot / Amani Lapis", amount = 4, itemID = 242606 },
        { name = "Flawless Sanguine Garnet / Tenebrous Amethyst / Harandar Peridot / Amani Lapis", amount = 1, itemID = 242613 },
    },

    leveling = {
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
    },

    knowledgeOverview = "Jewelcrafting Knowledge comes from one-time treasures (usually 8×3 KP) and weekly sources such as Patron Orders, a trainer quest, zone drops, an Inscription treatise, and the monthly Darkmoon Faire. Check each row below for details.",

    knowledgeCatchUp = "If you start late or miss weeks, Patron Orders can grant catch-up knowledge until you are back on pace.",

    oneTime = {
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
    },

    weekly = {
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
    },

    treasures = {
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
    },

}