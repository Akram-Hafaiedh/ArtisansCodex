-- Artisan's Codex - Specializations.lua
local addonName, private = ...
private.Specializations = {}
local Specializations = private.Specializations

function Specializations:Initialize()
    private:Print("Specializations module loaded")
end

function Specializations:Show(parentFrame, profession)
    -- Will show the specialization tree + recommended builds
end