-- Midnight Tailoring specialization guide

local _, private = ...
private.SpecGuideData = private.SpecGuideData or {}

private.SpecGuideData.Tailoring = {
    trees = {
        { key = "sindorei_finery", name = "Sin'dorei Finery", unlockSkill = 25,
          summary = "Cloth armor recipes (all slots) for crafting orders." },
        { key = "nimble_needlework", name = "Nimble Needlework", unlockSkill = 25,
          summary = "Arcanoweave / Sunfire bolts, embellished gear, rare cloth drops." },
        { key = "fabric_specialist", name = "Fabric Specialist", unlockSkill = 50,
          summary = "Cloth drop rates & quality by zone." },
        { key = "fiber_arts", name = "Fiber Arts", unlockSkill = 60,
          summary = "Global crafting stats (Skill, Multicraft, Resourcefulness, Concentration)." },
    },
    builds = {
        {
            key = "standard",
            name = "Standard",
            goal = "Armor + some bolt income",
            summary = "Versatile starter: Nimble for bolts, then Finery / Fiber for orders and stats.",
            steps = {
                { tree = "Nimble Needlework", node = "Nimble Needlework (root)", points = 20, note = "Open Arcanoweave / Sunfire branches" },
                { tree = "Nimble Needlework", node = "Arcanoweave or Sunfire", points = 15, note = "Daily bolt cooldown path" },
                { tree = "Fiber Arts", node = "Fiber Arts", points = 20, note = "Passive stats for all crafts" },
                { tree = "Sin'dorei Finery", node = "Sin'dorei Finery (root)", points = 20, note = "Start armor slot unlocks" },
            },
        },
        {
            key = "bolts",
            name = "Bolt Crafting",
            goal = "Max bolt cooldowns & multicraft",
            summary = "Best for alts / gold from Arcanoweave and Sunfire Silk bolts.",
            steps = {
                { tree = "Nimble Needlework", node = "Nimble Needlework (root)", points = 20, note = "Required gate for both bolt lines" },
                { tree = "Nimble Needlework", node = "Arcanoweave", points = 30, note = "Bolt charges & cooldown" },
                { tree = "Nimble Needlework", node = "Sunfire Silk", points = 30, note = "Second bolt line" },
                { tree = "Fiber Arts", node = "Creative Efficiency", points = 30, note = "Multicraft on bolts" },
            },
        },
        {
            key = "farming",
            name = "Cloth Farming",
            goal = "More / better cloth from mobs",
            summary = "Fabric Specialist zone branches + Nimble for rare cloth drops.",
            steps = {
                { tree = "Nimble Needlework", node = "Nimble Needlework (root)", points = 20, note = "Enable rare cloth drops" },
                { tree = "Fabric Specialist", node = "Fabric Specialist (root)", points = 25, note = "Drop rate & quality" },
                { tree = "Fabric Specialist", node = "Eastern Kingdoms or Otherworldly", points = 30, note = "Match the zones you farm" },
            },
        },
        {
            key = "armor_orders",
            name = "Armor Orders",
            goal = "Cloth gear for crafting orders",
            summary = "Sin'dorei Finery for slots; Fiber Arts for skill/stats.",
            steps = {
                { tree = "Fiber Arts", node = "Fiber Arts", points = 20, note = "Skill & secondaries" },
                { tree = "Sin'dorei Finery", node = "Sin'dorei Finery (root)", points = 30, note = "Unlock armor branches" },
                { tree = "Sin'dorei Finery", node = "Wrist / Belt / Boots first", points = 30, note = "Slots less contested by tier" },
            },
        },
    },
}
