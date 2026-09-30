-- Midnight Alchemy — Leveling (+ meta)
local _, private = ...
private.Data = private.Data or {}
private.Data.Alchemy = private.Data.Alchemy or {}
local P = private.Data.Alchemy

P.name = "Alchemy"


P.overview = "Midnight Alchemy uses Camberon's Cauldron, a deterministic (no-RNG) discovery system. You unlock recipes by meeting simple requirements and spending Artisan Alchemist's Moxie. Pairs best with Herbalism."

P.trainer = {

        name = "Camberon",

        zone = "Silvermoon City",

        mapID = 2393,

        x = 47.0,
        y = 51.8,

        note = "Alchemy Supply vendor Melaris is right next to him (buys/sells Sunglass Vial, Oil of Heartwood, etc.).",

    }

P.shoppingList = {

        { name = "Tranquility Bloom", amount = 300, itemID = 236761 },

        { name = "Sanguithorn", amount = 15, itemID = 236770 },

        { name = "Mote of Light", amount = 12, itemID = 236949 },

        { name = "Argentleaf", amount = 4, itemID = 236776 },

        { name = "Mote of Primal Energy", amount = 4, itemID = 236950 },

        { name = "Mana Lily", amount = 3, itemID = 236778 },

    }

P.leveling = {

        {

            range = "1-7",

            recipe = "Silvermoon Health Potion",
            spellID = 1230866,

            quantity = 6,

            reagents = {

                { name = "Tranquility Bloom", amount = 36, itemID = 236761 },

                { name = "Sunglass Vial", amount = 30, itemID = 240991 },

            },

            note = "Buy Sunglass Vials from Melaris next to the trainer.",

            difficulty = "orange",

        },

        {

            range = "7-20",

            recipe = "Recycle Potions",
            spellID = 1233129,

            quantity = 10,

            reagents = {

                { name = "Silvermoon Health Potion", amount = 10, itemID = 241305 },

                { name = "Oil of Heartwood", amount = 10, itemID = 247811 },

            },

            note = "Recycle the Silvermoon Health Potions you just made. Oil of Heartwood is sold by Melaris next to the trainer.",

            difficulty = "orange",

        },

        {

            range = "20-27",

            recipe = "Camberon's Cauldron Discovery",

            quantity = 1,

            reagents = {},

            note = "Important, don't skip: interact with Camberon's Cauldron next to the trainer and research Primal Philosopher's Stone and Lightfused Mana Potion. It's not RNG, you just pick what to learn and spend Moxie.",

            difficulty = "orange",

            isSpecial = true,

        },

        {

            range = "First Crafts",

            recipe = "Refreshing Serum",
            spellID = 1230868,

            quantity = 1,

            reagents = {

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
            spellID = 1230865,

            quantity = 1,

            reagents = {

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
            spellID = 1230861,

            quantity = 1,

            reagents = {

                { name = "Stabilized Derivate", amount = 2, itemID = 242651 },

                { name = "Mote of Light", amount = 2, itemID = 236949 },

                { name = "Refreshing Serum", amount = 5, itemID = 241307 },

            },

            note = "Required for transmutes -- craft it before the Mote of Wild Magic transmute below. A Philosopher's Stone from a previous expansion also works. Unlocked from Camberon's Cauldron.",

            difficulty = "orange",

        },

        {

            range = "First Crafts",

            recipe = "Transmute: Mote of Wild Magic",
            spellID = 1230887,

            quantity = 1,

            reagents = {

                { name = "Mote of Light", amount = 10, itemID = 236949 },

                { name = "Stabilized Derivate", amount = 1, itemID = 242651 },

            },

            note = "First craft bonus.",

            difficulty = "orange",

        },

        {

            range = "First Crafts",

            recipe = "Composite Flora",
            spellID = 1230855,

            quantity = 1,

            reagents = {

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
            spellID = 1230886,

            quantity = 1,

            reagents = {

                { name = "Tranquility Bloom", amount = 3, itemID = 236761 },

                { name = "Sunglass Vial", amount = 5, itemID = 240991 },

            },

            note = "First craft bonus.",

            difficulty = "orange",

        },

        {

            range = "First Crafts",

            recipe = "Entropic Extract",
            spellID = 1230854,

            quantity = 1,

            reagents = {

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

            reagents = {},

            note = "You unlock your first Alchemy specialization at skill 25.",

            difficulty = "orange",

            isSpecial = true,

        },

        {

            range = "27-32",

            recipe = "Entropic Extract",
            spellID = 1230854,

            quantity = 8,

            reagents = {

                { name = "Tranquility Bloom", amount = 24, itemID = 236761 },

                { name = "Sunglass Vial", amount = 40, itemID = 240991 },

            },

            note = "Reaching exactly 32 is not important, this is just an estimate.",

            difficulty = "orange",

        },

        {

            range = "32-50",

            recipe = "Silvermoon Health Potion",
            spellID = 1230866,

            quantity = 30,

            reagents = {

                { name = "Tranquility Bloom", amount = 180, itemID = 236761 },

                { name = "Sunglass Vial", amount = 150, itemID = 240991 },

            },

            note = "Recipe will be yellow, so you may not reach exactly 50 -- that's fine unless you need it for a recipe or spec unlock.",

            difficulty = "yellow",

        },

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

        {

            range = "50-100",

            path = "potions",

            recipe = "Light's Potential",
            spellID = 1230869,

            itemID = 0,

            quantity = 80,

            reagents = {

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

        {

            range = "50-100",

            path = "flasks",

            recipe = "Sin'dorei Flasks (Magisters / Blood Knights / Shattered Sun)",

            quantity = 45,

            reagents = {

                { name = "Nocturnal Lotus", amount = 45, itemID = 236780 },

                { name = "Sanguithorn", amount = 360, itemID = 236770 },

                { name = "Mana Lily", amount = 270, itemID = 236778 },

                { name = "Mote of Pure Void / Mote of Wild Magic / Mote of Primal Energy", amount = 90, itemID = 0 },

            },

            note = "Flask of the Magisters, Flask of the Blood Knights, and Flask of the Shattered Sun each need ~45 crafts. Give 2 skill per craft until 90, yellow to 95, green after. Blood Knights/Shattered Sun flasks unlock from Camberon's Cauldron after crafting 10 Sin'dorei flasks (50 Moxie each).",

            difficulty = "yellow",

        },

    }

P.specializations = {

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

    }

