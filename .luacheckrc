-- Artisan's Codex — luacheck configuration
std = "lua51"
max_line_length = 500

-- One-line recipe tables (Windows + Unix path forms)
files["Data/Midnight/Recipes"] = { max_line_length = false }
files["Data/Midnight/Recipes/"] = { max_line_length = false }
files["Data\\Midnight\\Recipes"] = { max_line_length = false }
files["Data\\Midnight\\Recipes\\"] = { max_line_length = false }

ignore = {
    "212", -- unused argument
    "213", -- unused loop variable
}

exclude_files = {
    "Libs/",
    "Libs",
}

globals = {
    "ArtisansCodex",
    "SLASH_ARTISANSCODEX1",
    "SLASH_ARTISANSCODEX2",
    "SLASH_ARTISANSCODEX3",
    "SlashCmdList",
    "g_professionsSpecsSelectedTabs",
    "UISpecialFrames",
}

read_globals = {
    "ArtisansCodexDB",
    "CreateFrame",
    "CreateVector2D",
    "UIParent",
    "Minimap",
    "GameTooltip",
    "WorldFrame",
    "UISpecialFrames",
    "GameFontHighlightSmall",
    "GameFontNormal",
    "GameFontNormalLarge",
    "GameFontNormalSmall",
    "GameFontHighlight",
    "GameFontDisableSmall",
    "UIPanelButtonTemplate",
    "UIPanelScrollFrameTemplate",
    "BackdropTemplate",
    "C_AddOns",
    "C_Calendar",
    "C_CraftingOrders",
    "C_CurrencyInfo",
    "C_DateAndTime",
    "C_Item",
    "C_Map",
    "C_Professions",
    "C_ProfSpecs",
    "C_QuestLog",
    "C_Spell",
    "C_SuperTrack",
    "C_Timer",
    "C_TradeSkillUI",
    "C_Traits",
    "UnitGUID",
    "UnitName",
    "UnitLevel",
    "UnitClass",
    "GetNormalizedRealmName",
    "GetRealmName",
    "InCombatLockdown",
    "GetServerTime",
    "GetTime",
    "time",
    "date",
    "GetProfessions",
    "GetProfessionInfo",
    "GetItemInfo",
    "GetItemIcon",
    "GetItemQualityColor",
    "ITEM_QUALITY_COLORS",
    "GetSpellInfo",
    "GetSpellTexture",
    "GetCoinTextureString",
    "Item",
    "RAID_CLASS_COLORS",
    "GetLocale",
    "ReloadUI",
    "strtrim",
    "strlower",
    "strupper",
    "strsplit",
    "tinsert",
    "tremove",
    "wipe",
    "print",
    "DEFAULT_CHAT_FRAME",
}