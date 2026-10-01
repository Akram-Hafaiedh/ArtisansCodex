-- Midnight Mining specialization guide
-- Trees: live export 2026-10-01 (Debug -> Specs). Builds: guide-style defaults.
-- Profession: Mining  variantID=2916  configID=54470859

local _, private = ...
private.SpecGuideData = private.SpecGuideData or {}

private.SpecGuideData.Mining = {
    variantID = 2916,
    trees = {
        {
            key = "plentiful_ores",
            name = "Plentiful Ores",
            tabID = 1107,
            rootNodeID = 105568,
            maxKP = 170,
            unlockSkill = 25,
            summary = "All Midnight ores; per-ore lines for Copper, Tin, and Silver.",
            paths = {
                { pathID = 105568, name = "Plentiful Ores", maxKP = 50 },
                { pathID = 105567, name = "Refulgent Copper", maxKP = 40 },
                { pathID = 105566, name = "Umbral Tin", maxKP = 40 },
                { pathID = 105565, name = "Brilliant Silver", maxKP = 40 },
            },
        },
        {
            key = "meticulous_mining",
            name = "Meticulous Mining",
            tabID = 1105,
            rootNodeID = 105475,
            maxKP = 110,
            unlockSkill = 25,
            summary = "Rich deposits, seams, skyriding charges, and mining while mounted.",
            paths = {
                { pathID = 105475, name = "Meticulous Mining", maxKP = 40 },
                { pathID = 105474, name = "Rich Deposits", maxKP = 35 },
                { pathID = 105473, name = "Seams", maxKP = 35 },
            },
        },
        {
            key = "over_loded",
            name = "Over-LODED",
            tabID = 1106,
            rootNodeID = 105526,
            maxKP = 200,
            unlockSkill = 25,
            summary = "Overload Infused Deposit and empowered node types (Lightfused, Wild, Primal, Voidbound).",
            paths = {
                { pathID = 105526, name = "Over-LODED", maxKP = 40 },
                { pathID = 105525, name = "Lightfused", maxKP = 40 },
                { pathID = 105524, name = "Wild", maxKP = 40 },
                { pathID = 105523, name = "Primal", maxKP = 40 },
                { pathID = 105522, name = "Voidbound", maxKP = 40 },
            },
            notableRecipes = {
                { name = "Overload Infused Deposit", spellID = 1225392 },
            },
        },
    },
    builds = {
        {
            key = "general",
            name = "General Miner",
            goal = "All ores + rich/seams QoL",
            summary = "Plentiful Ores root, then Meticulous for rich deposits and mounted mining.",
            steps = {
                { tree = "Plentiful Ores", node = "Plentiful Ores", pathID = 105568, points = 20,
                  note = "Baseline skill on all Midnight ores" },
                { tree = "Meticulous Mining", node = "Meticulous Mining", pathID = 105475, points = 15,
                  note = "Skyriding charges + path to mounted mining" },
                { tree = "Meticulous Mining", node = "Rich Deposits", pathID = 105474, points = 10,
                  note = "Rich node skill" },
                { tree = "Plentiful Ores", node = "Refulgent Copper", pathID = 105567, points = 10,
                  note = "Example ore focus - swap Tin/Silver as needed" },
            },
        },
        {
            key = "overload",
            name = "Overload Specialist",
            goal = "Overload CD and empowered deposits",
            summary = "Over-LODED root, then one empowered type (Lightfused / Wild / Primal / Voidbound).",
            steps = {
                { tree = "Over-LODED", node = "Over-LODED", pathID = 105526, points = 20,
                  note = "Overload Infused Deposit + charges" },
                { tree = "Over-LODED", node = "Lightfused", pathID = 105525, points = 15,
                  note = "Example empowered type - swap as preferred" },
                { tree = "Meticulous Mining", node = "Meticulous Mining", pathID = 105475, points = 10,
                  note = "General deposit skill" },
            },
        },
        {
            key = "rich_seams",
            name = "Rich & Seams",
            goal = "Maximize rich deposits and ore seams",
            summary = "Meticulous Mining into Rich Deposits and Seams.",
            steps = {
                { tree = "Meticulous Mining", node = "Meticulous Mining", pathID = 105475, points = 20,
                  note = "Open tree (includes mounted mining perk path)" },
                { tree = "Meticulous Mining", node = "Rich Deposits", pathID = 105474, points = 15,
                  note = "Rich node yields" },
                { tree = "Meticulous Mining", node = "Seams", pathID = 105473, points = 15,
                  note = "Seam skill + post-mine speed" },
            },
        },
        {
            key = "ore_focus",
            name = "Single Ore Focus",
            goal = "Max one ore type (Copper / Tin / Silver)",
            summary = "Plentiful Ores into one ore line for Finesse and Thorium chance.",
            steps = {
                { tree = "Plentiful Ores", node = "Plentiful Ores", pathID = 105568, points = 15,
                  note = "Baseline" },
                { tree = "Plentiful Ores", node = "Umbral Tin", pathID = 105566, points = 20,
                  note = "Example - swap Copper or Silver" },
                { tree = "Meticulous Mining", node = "Meticulous Mining", pathID = 105475, points = 10,
                  note = "General QoL" },
            },
        },
    },
}