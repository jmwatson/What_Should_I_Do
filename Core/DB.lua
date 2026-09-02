local _, addon = ...;

-- Persistent data
addon.DB = {};
addon.SCHEMA_VERSION = 2;

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

local function RunMigrations(DB)
    local from = DB.schemaVersion or 1;

    if from >= addon.SCHEMA_VERSION then return; end

    for version = from + 1, addon.SCHEMA_VERSION do
        for _, migrator in ipairs(addon._MIGRATORS[version] or {}) do
            print("|cffd5a742What Should I Do?:|r Updating "..migrator.label.."...");
            local ok, err = pcall(migrator.fn, DB);

            -- Error happened, don't save changes to disk so migration can re-run in the future
            if not ok then
                print("|cffff4444What Should I Do?:|r Migration '"..migrator.label.."' failed");
                return;
            end

            DB.schemaVersion = version;
        end
    end
end

-- Populates the shared DB table
local function InitDB()
    local DB = addon.DB;
    local isFreshInstall = WhatShouldIDoDB == nil;
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

    if isFreshInstall then
        DB.schemaVersion = addon.SCHEMA_VERSION;
    else
        RunMigrations(DB);
    end

    -- Store our saved data into persistent storage
    WhatShouldIDoDB = DB;
end
addon.InitDB = InitDB;
