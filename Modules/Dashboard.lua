-- Artisan's Codex - Dashboard.lua
local addonName, private = ...
private.Dashboard = {}
local Dashboard = private.Dashboard

function Dashboard:Initialize()
    private:Print("Dashboard module loaded")
end

-- This function will later create the actual Dashboard content
function Dashboard:Show(parentFrame)
    -- parentFrame is the main window content area
    -- We will build the "What should I do right now?" screen here later
end