-- Artisan's Codex
-- Premium Profession Guides for World of Warcraft: Midnight
-- Init.lua - Bootstrap file

local addonName, private = ...

-- Create the main private table
private.addon = {}
private.addonName = addonName
private.version = "0.1.0-alpha"

-- Debug mode (set to true while developing)
private.debug = true

-- Print → always feed Debug log; mirror to chat when debug is on (and Debug.mirrorChat)
function private:Print(...)
    if private.Debug and private.Debug.CapturePrint then
        private.Debug:CapturePrint(...)
    end
    local mirror = true
    if private.Debug and private.Debug.mirrorChat == false then
        mirror = false
    end
    if private.debug and mirror then
        print("|cff00ccff[Artisan's Codex]|r", ...)
    end
end

private:Print("Init.lua loaded - Version " .. private.version)