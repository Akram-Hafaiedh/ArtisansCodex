-- Artisan's Codex - Midnight progress meta (currencies, weekly quests, gathering)
-- Currency / skill-line / quest IDs aligned with WeeklyKnowledge (DennisRas / Liquidor).
-- Used by Core progress scans for concentration, catch-up, gathering, weekly sources.

local _, private = ...

private.ProgressMeta = private.ProgressMeta or {}

-- skillLineID              = base profession line (GetProfessionInfo)
-- variantID                = Midnight expansion skill line variant (C_TradeSkillUI / C_ProfSpecs)
-- catchUpCurrencyID        = hidden catch-up KP tracker currency
-- concentrationCurrencyID  = concentration (0 = N/A for gathering)
-- catchUpItemID            = Flicker / gathering catch-up item
-- moxieCurrencyID          = Artisan <Profession>'s Moxie (spendable)
-- gatheringQuests          = weekly gathering / disenchant drop quest flags
-- zoneDropQuests           = weekly treasure-drop KP quest flags (WK "Treasure")
-- weeklyQuestIDs           = trainer / consortium weekly quest(s)
-- weeklyQuestLimit         = if set, complete when any `limit` of the IDs are done (WK limit)
-- treatiseQuestID          = weekly treatise use quest flag
-- darkmoonQuestID          = Darkmoon Faire profession quest

private.ProgressMeta.professions = {
    Alchemy = {
        skillLineID = 171,
        variantID = 2906,
        catchUpCurrencyID = 3189,
        concentrationCurrencyID = 3161,
        catchUpItemID = 246320,
        moxieCurrencyID = 3256,
        zoneDropQuests = { 93528, 93529 },
        weeklyQuestIDs = { 93690 },
        treatiseQuestID = 95127,
        darkmoonQuestID = 29506,
    },
    Blacksmithing = {
        skillLineID = 164,
        variantID = 2907,
        catchUpCurrencyID = 3199,
        concentrationCurrencyID = 3162,
        catchUpItemID = 246322,
        moxieCurrencyID = 3257,
        zoneDropQuests = { 93530, 93531 },
        weeklyQuestIDs = { 93691 },
        treatiseQuestID = 95128,
        darkmoonQuestID = 29508,
    },
    Enchanting = {
        skillLineID = 333,
        variantID = 2909,
        catchUpCurrencyID = 3198,
        concentrationCurrencyID = 3163,
        catchUpItemID = 267653,
        moxieCurrencyID = 3258,
        gatheringQuests = { 95048, 95049, 95050, 95051, 95052, 95053 },
        zoneDropQuests = { 93532, 93533 },
        weeklyQuestIDs = { 93697, 93698, 93699 },
        weeklyQuestLimit = 1,
        treatiseQuestID = 95129,
        darkmoonQuestID = 29510,
    },
    Engineering = {
        skillLineID = 202,
        variantID = 2910,
        catchUpCurrencyID = 3197,
        concentrationCurrencyID = 3164,
        catchUpItemID = 246326,
        moxieCurrencyID = 3259,
        zoneDropQuests = { 93534, 93535 },
        weeklyQuestIDs = { 93692 },
        treatiseQuestID = 95138,
        darkmoonQuestID = 29511,
    },
    Herbalism = {
        skillLineID = 182,
        variantID = 2912,
        catchUpCurrencyID = 3196,
        concentrationCurrencyID = 0,
        catchUpItemID = 238467,
        moxieCurrencyID = 3260,
        gatheringQuests = { 81425, 81426, 81427, 81428, 81429, 81430 },
        weeklyQuestIDs = { 93700, 93701, 93702, 93703, 93704 },
        weeklyQuestLimit = 1,
        treatiseQuestID = 95130,
        darkmoonQuestID = 29514,
    },
    Inscription = {
        skillLineID = 773,
        variantID = 2913,
        catchUpCurrencyID = 3195,
        concentrationCurrencyID = 3165,
        catchUpItemID = 246328,
        moxieCurrencyID = 3261,
        zoneDropQuests = { 93536, 93537 },
        weeklyQuestIDs = { 93693 },
        treatiseQuestID = 95131,
        darkmoonQuestID = 29515,
    },
    Jewelcrafting = {
        skillLineID = 755,
        variantID = 2914,
        catchUpCurrencyID = 3194,
        concentrationCurrencyID = 3166,
        catchUpItemID = 246330,
        moxieCurrencyID = 3262,
        zoneDropQuests = { 93538, 93539 },
        weeklyQuestIDs = { 93694 },
        treatiseQuestID = 95133,
        darkmoonQuestID = 29516,
    },
    Leatherworking = {
        skillLineID = 165,
        variantID = 2915,
        catchUpCurrencyID = 3193,
        concentrationCurrencyID = 3167,
        catchUpItemID = 246332,
        moxieCurrencyID = 3263,
        zoneDropQuests = { 93540, 93541 },
        weeklyQuestIDs = { 93695 },
        treatiseQuestID = 95134,
        darkmoonQuestID = 29517,
    },
    Mining = {
        skillLineID = 186,
        variantID = 2916,
        catchUpCurrencyID = 3192,
        concentrationCurrencyID = 0,
        catchUpItemID = 237507,
        moxieCurrencyID = 3264,
        gatheringQuests = { 88673, 88674, 88675, 88676, 88677, 88678 },
        weeklyQuestIDs = { 93705, 93706, 93707, 93708, 93709 },
        weeklyQuestLimit = 1,
        treatiseQuestID = 95135,
        darkmoonQuestID = 29518,
    },
    Skinning = {
        skillLineID = 393,
        variantID = 2917,
        catchUpCurrencyID = 3191,
        concentrationCurrencyID = 0,
        catchUpItemID = 238627,
        moxieCurrencyID = 3265,
        gatheringQuests = { 88534, 88549, 88537, 88536, 88530, 88529 },
        weeklyQuestIDs = { 93710, 93711, 93712, 93713, 93714 },
        weeklyQuestLimit = 1,
        treatiseQuestID = 95136,
        darkmoonQuestID = 29519,
    },
    Tailoring = {
        skillLineID = 197,
        variantID = 2918,
        catchUpCurrencyID = 3190,
        concentrationCurrencyID = 3168,
        catchUpItemID = 246334,
        moxieCurrencyID = 3266,
        zoneDropQuests = { 93542, 93543 },
        weeklyQuestIDs = { 93696 },
        treatiseQuestID = 95137,
        darkmoonQuestID = 29520,
    },
    -- Cooking / Fishing: no Midnight KP tracker currencies in the same system
    Cooking = {
        skillLineID = 185,
        variantID = nil,
        catchUpCurrencyID = 0,
        concentrationCurrencyID = 0,
        catchUpItemID = 0,
        moxieCurrencyID = 0,
    },
    Fishing = {
        skillLineID = 356,
        variantID = nil,
        catchUpCurrencyID = 0,
        concentrationCurrencyID = 0,
        catchUpItemID = 0,
        moxieCurrencyID = 0,
    },
}

-- Lookup by base skillLineID
private.ProgressMeta.bySkillLineID = {}
for name, meta in pairs(private.ProgressMeta.professions) do
    if meta.skillLineID then
        private.ProgressMeta.bySkillLineID[meta.skillLineID] = meta
        meta.name = name
    end
end

--- All catch-up + concentration currency IDs we care about
function private.ProgressMeta:GetTrackedCurrencyIDs()
    local ids = {}
    for _, meta in pairs(self.professions) do
        if meta.catchUpCurrencyID and meta.catchUpCurrencyID > 0 then
            ids[meta.catchUpCurrencyID] = meta
        end
        if meta.concentrationCurrencyID and meta.concentrationCurrencyID > 0 then
            ids[meta.concentrationCurrencyID] = meta
        end
    end
    return ids
end

--- Collect every weekly-resettable quest ID (for TaskWeeklyReset cache clears)
function private.ProgressMeta:GetAllWeeklyQuestIDs()
    local ids = {}
    for _, meta in pairs(self.professions) do
        local function add(qid)
            if type(qid) == "number" and qid > 0 then
                ids[qid] = true
            end
        end
        if type(meta.gatheringQuests) == "table" then
            for _, qid in ipairs(meta.gatheringQuests) do add(qid) end
        end
        if type(meta.zoneDropQuests) == "table" then
            for _, qid in ipairs(meta.zoneDropQuests) do add(qid) end
        end
        if type(meta.weeklyQuestIDs) == "table" then
            for _, qid in ipairs(meta.weeklyQuestIDs) do add(qid) end
        end
        add(meta.treatiseQuestID)
        -- darkmoon is monthly; still clear on weekly so a stale flag cannot stick across months
        add(meta.darkmoonQuestID)
    end
    return ids
end