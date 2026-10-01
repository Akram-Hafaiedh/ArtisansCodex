-- Midnight Herbalism specialization guide
-- Trees: live export 2026-10-01 (Debug -> Specs). Builds: guide-style defaults.
-- Profession: Herbalism  variantID=2912  configID=54470889

local _, private = ...
private.SpecGuideData = private.SpecGuideData or {}

private.SpecGuideData.Herbalism = {
    variantID = 2912,
    trees = {
        {
            key = "bountiful_harvests",
            name = "Bountiful Harvests",
            tabID = 1074,
            rootNodeID = 104481,
            maxKP = 240,
            unlockSkill = 25,
            summary = "All Midnight herbs; per-herb lines (Bloom, Thorn, Root, Silver, Lily).",
            paths = {
                { pathID = 104481, name = "Bountiful Harvests", maxKP = 40 },
                { pathID = 104480, name = "Bloom Bringer", maxKP = 40 },
                { pathID = 104479, name = "Thorn Thresher", maxKP = 40 },
                { pathID = 104478, name = "Root Rummager", maxKP = 40 },
                { pathID = 104477, name = "Silver Searcher", maxKP = 40 },
                { pathID = 104476, name = "Lily Looter", maxKP = 40 },
            },
        },
        {
            key = "botany",
            name = "Botany",
            tabID = 1073,
            rootNodeID = 104421,
            maxKP = 120,
            unlockSkill = 25,
            summary = "Skyriding charges, mounted gathering, mulch processing, seeds and Green Thumb.",
            paths = {
                { pathID = 104421, name = "Botany", maxKP = 40 },
                { pathID = 104420, name = "Mulching", maxKP = 40 },
                { pathID = 104419, name = "Cultivation", maxKP = 40 },
            },
            notableRecipes = {
                { name = "Magical Mulch", spellID = 1221179 },
                { name = "Imbued Mulch", spellID = 1221180 },
                { name = "Empowered Mulch", spellID = 1221181 },
                { name = "Green Thumb", spellID = 1221172 },
            },
        },
        {
            key = "midnight_overload",
            name = "Midnight Overload",
            tabID = 1080,
            rootNodeID = 104707,
            maxKP = 200,
            unlockSkill = 25,
            summary = "Overload Infused Herb and empowered types (Lightfused, Wild, Primal, Voidbound).",
            paths = {
                { pathID = 104707, name = "Midnight Overload", maxKP = 40 },
                { pathID = 104706, name = "Lightfused", maxKP = 40 },
                { pathID = 104705, name = "Wild", maxKP = 40 },
                { pathID = 104704, name = "Primal", maxKP = 40 },
                { pathID = 104703, name = "Voidbound", maxKP = 40 },
            },
            notableRecipes = {
                { name = "Overload Infused Herb", spellID = 1223014 },
            },
        },
    },
    builds = {
        {
            key = "general",
            name = "General Herbalist",
            goal = "All herbs + mounted gathering QoL",
            summary = "Bountiful Harvests root, Botany for mounted/skyriding, optional herb focus.",
            steps = {
                { tree = "Bountiful Harvests", node = "Bountiful Harvests", pathID = 104481, points = 20,
                  note = "Baseline skill and yield floors" },
                { tree = "Botany", node = "Botany", pathID = 104421, points = 15,
                  note = "Skyriding charges + path to mounted gather" },
                { tree = "Bountiful Harvests", node = "Bloom Bringer", pathID = 104480, points = 10,
                  note = "Example herb - swap Thorn/Root/Silver/Lily as needed" },
            },
        },
        {
            key = "herb_focus",
            name = "Single Herb Focus",
            goal = "Max one herb type + Nocturnal Lotus chance",
            summary = "Bountiful Harvests into one herb line.",
            steps = {
                { tree = "Bountiful Harvests", node = "Bountiful Harvests", pathID = 104481, points = 15,
                  note = "Baseline" },
                { tree = "Bountiful Harvests", node = "Thorn Thresher", pathID = 104479, points = 20,
                  note = "Example Sanguithorn - swap for preferred herb" },
                { tree = "Botany", node = "Botany", pathID = 104421, points = 10,
                  note = "General QoL" },
            },
        },
        {
            key = "overload",
            name = "Overload Specialist",
            goal = "Overload CD and empowered herbs",
            summary = "Midnight Overload root, then one empowered type.",
            steps = {
                { tree = "Midnight Overload", node = "Midnight Overload", pathID = 104707, points = 20,
                  note = "Overload Infused Herb + charges" },
                { tree = "Midnight Overload", node = "Lightfused", pathID = 104706, points = 15,
                  note = "Example type - swap Wild/Primal/Voidbound" },
                { tree = "Botany", node = "Botany", pathID = 104421, points = 10,
                  note = "Gathering skill support" },
            },
        },
        {
            key = "cultivation",
            name = "Mulch & Seeds",
            goal = "Mulch processing and cultivation",
            summary = "Botany into Mulching and Cultivation (Green Thumb).",
            steps = {
                { tree = "Botany", node = "Botany", pathID = 104421, points = 15,
                  note = "Open Botany" },
                { tree = "Botany", node = "Mulching", pathID = 104420, points = 15,
                  note = "Magical / Imbued / Empowered Mulch" },
                { tree = "Botany", node = "Cultivation", pathID = 104419, points = 15,
                  note = "Seeds + Green Thumb" },
            },
        },
    },
}