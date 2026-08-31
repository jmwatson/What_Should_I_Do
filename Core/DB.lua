local _, addon = ...;

-- Persistent data
addon.DB = {};

-- Mutable runtime data
addon.Runtime = {
    COLOR_TABLE = {},
    MainFrame = nil,
    SettingsFrame = nil,
};

local defaults = {
    colorTheme = nil,
    COLOR_TABLE = {},
    customColors = {},
    excludedActivities = {},
    excludedChars = {},
    excludedExpansions = {},
    excludeFarming = false,
    excludedSubActivities = {},
    seenChars = {},
    uiScale = 1.0,
};

-- Populates the shared DB table
local function InitDB()
    local DB = addon.DB;
    WhatShouldIDoDB = WhatShouldIDoDB or {};

    -- Load saved values into the DB
    for key, value in pairs(WhatShouldIDoDB) do
        DB[key] = value;
    end

    -- Load any missing defaults
    for key, value in pairs(defaults) do
        if DB[key] == nil then
            DB[key] = value;
        end
    end

    if DB.colorTheme == nil then
        DB.colorTheme = addon.DEFAULT_THEME;
    end

    -- Store our saved data into persistent storage
    WhatShouldIDoDB = DB;
end
addon.InitDB = InitDB;
