-- Midnight Enchanting — Leveling (+ meta)
local _, private = ...
private.Data = private.Data or {}
private.Data.Enchanting = private.Data.Enchanting or {}
local P = private.Data.Enchanting

P.name = "Enchanting"

P.icon = "Interface\\Icons\\Trade_Engraving"

P.overview = "Midnight Enchanting doesn't need a gathering profession, so it pairs with anything. Put everything on an Enchanting Vellum and sell on the AH. Disenchant leftover gear before you start for free skill points up to 25."

P.trainer = {

        name = "Dolothos",

        zone = "Silvermoon City",

        mapID = 2393,

        x = 45.0,
        y = 54.5,

        note = "Enchanting Supply vendor Lyna is next to him (sells Enchanting Vellum, Refulgent Copper Rod). Gleeful Glamours are taught separately by Jennara Sunglow, in the tower behind the trainer.",

    }

P.shoppingList = {

        { name = "Eversinging Dust", amount = 412, itemID = 243599 },

        { name = "Radiant Shard", amount = 27, itemID = 243602 },

        { name = "Mote of Light", amount = 6, itemID = 236949 },

    }

P.leveling = {

        {

            range = "1-25",

            recipe = "Runed Refulgent Copper Rod (craft + disenchant)",

            quantity = 30,

            reagents = {

                { name = "Refulgent Copper Rod", amount = 30, itemID = 244174 },

                { name = "Eversinging Dust", amount = 150, itemID = 243599 },

            },

            note = "Craft 30x Runed Refulgent Copper Rod, then disenchant all of them for skill points up to 25 (you get about half your dust back). Buy the rods from Lyna near the trainer. If unlucky, craft one Enchant Helm - Rune of Avoidance or Thalassian Phoenix Oil to finish off 25.",

            difficulty = "orange",

        },

        {

            range = "25",

            recipe = "Unlock Specializations",

            quantity = 0,

            reagents = {},

            note = "You unlock Enchanting specializations at skill 25. Don't rush picking one, just keep leveling to ~60 first.",

            difficulty = "orange",

            isSpecial = true,

        },

        {

            range = "25-27",

            recipe = "Enchant Helm - Rune of Avoidance / Thalassian Phoenix Oil",

            quantity = 1,

            reagents = {

                { name = "Eversinging Dust", amount = 20, itemID = 243599 },

                { name = "Radiant Shard", amount = 3, itemID = 243602 },

                { name = "Mote of Light", amount = 5, itemID = 236949 },

                { name = "Sunglass Vial", amount = 1, itemID = 240991 },

            },

            note = "Craft one of each for the First Craft Bonuses, in this order.",

            difficulty = "orange",

        },

        {

            range = "27-38",

            recipe = "Enchant Ring - Nature's Wrath / Illusory Adornment - Blooming Light",

            quantity = 14,

            reagents = {

                { name = "Eversinging Dust", amount = 70, itemID = 243599 },

                { name = "Mote of Light", amount = 14, itemID = 236949 },

            },

            note = "Craft one of each for the First Craft bonus, then craft ~13 more of the cheaper one (Enchant Ring - Nature's Wrath) to finish the range.",

            difficulty = "orange",

        },

        {

            range = "38-40",

            recipe = "Enchant Shoulders - Flight of the Eagle / Enchant Helm - Hex of Leeching",

            quantity = 1,

            reagents = {

                { name = "Eversinging Dust", amount = 30, itemID = 243599 },

                { name = "Radiant Shard", amount = 6, itemID = 243602 },

            },

            note = "One of each for the First Craft Bonus.",

            difficulty = "orange",

        },

        {

            range = "40-52",

            recipe = "Thalassian Spellweaver's Wand",
            spellID = 1236489,

            quantity = 4,

            reagents = {

                { name = "Eversinging Dust", amount = 60, itemID = 243599 },

                { name = "Radiant Shard", amount = 12, itemID = 243602 },

            },

            note = "Gives 3 skill points per craft.",

            difficulty = "orange",

        },

        {

            range = "52-55",

            recipe = "Enchant Ring - Amani Mastery / Enchant Helm - Blessing of Speed / Enchant Shoulders - Thalassian Recovery",

            quantity = 1,

            reagents = {

                { name = "Eversinging Dust", amount = 35, itemID = 243599 },

                { name = "Radiant Shard", amount = 6, itemID = 243602 },

            },

            note = "One of each for the First Craft Bonus.",

            difficulty = "orange",

            isSpecial = true,

        },

        {

            range = "Gleeful Glamours",

            recipe = "All 24 Gleeful Glamours (First Craft sweep)",

            quantity = 24,

            reagents = {

                { name = "Eversinging Dust", amount = 48, itemID = 243599 },

                { name = "Mote of Wild Magic", amount = 10, itemID = 236951 },

                { name = "Mote of Primal Energy", amount = 8, itemID = 236950 },

                { name = "Mote of Light", amount = 4, itemID = 236949 },

                { name = "Mote of Pure Void", amount = 2, itemID = 236952 },

            },

            note = "Worth +24 Knowledge Points. Taught by Jennara Sunglow, on the second floor of the tower behind the Enchanting trainer in Silvermoon City -- not the main trainer.",

            difficulty = "orange",

            isSpecial = true,

        },

        {

            range = "55-62",

            recipe = "Enchant Ring - Amani Mastery",
            spellID = 1236058,

            quantity = 9,

            reagents = {

                { name = "Eversinging Dust", amount = 45, itemID = 243599 },

            },

            note = "Will be yellow so you might need a few extra. Gives skill up to 70 if you want to keep spamming it and don't care about selling the rings.",

            difficulty = "yellow",

        },

        {

            range = "62-90",

            recipe = "Ring / Helm / Shoulder / Chest / Weapon enchants (mixed)",

            quantity = 1,

            reagents = {

                { name = "Mote of Light / Wild Magic / Primal Energy / Pure Void", amount = 15, itemID = 0 },

                { name = "Petrified Root", amount = 2, itemID = 251285 },

                { name = "Eversinging Dust", amount = 15, itemID = 243599 },

                { name = "Radiant Shard", amount = 3, itemID = 243602 },

                { name = "Dawn Crystal", amount = 1, itemID = 243605 },

            },

            note = "Craft at least 1 of every enchant you have unlocked, then sell and craft more of whichever sells best -- this recoups cost better than spamming one recipe. Rings turn yellow around 80, chests are only good to ~85, helm/weapon/shoulder stay orange to 90. Enchant Weapon - Worldsoul Aegis stays orange all the way to 100 as a fallback.",

            difficulty = "yellow",

        },

        {

            range = "90-100",

            recipe = "Enchant Weapon - Worldsoul Aegis (or other weapon enchant)",

            quantity = 1,

            reagents = {

                { name = "Mote of Primal Energy", amount = 4, itemID = 236950 },

                { name = "Petrified Root", amount = 4, itemID = 251285 },

                { name = "Flawless Harandar Peridot", amount = 1, itemID = 242610 },

                { name = "Eversinging Dust", amount = 20, itemID = 243599 },

                { name = "Radiant Shard", amount = 10, itemID = 243602 },

                { name = "Dawn Crystal", amount = 2, itemID = 243605 },

            },

            note = "Only weapon enchants remain orange this late. Worldsoul Aegis is from the trainer (55) so you can always craft it for pure leveling.",

            difficulty = "orange",

            isRecommended = true,

        },

    }

