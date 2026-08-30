local _, addon = ...;

local defaults = {
    colorTheme = addon.DEFAULT_THEME,
    COLOR_TABLE = {},
    customColors = {},
    excludedActivities = {},
    excludedChars = {},
    excludedExpansions = {},
    excludeFarming = false,
    excludedSubActivities = {},
    minimap = {
        hide = false,
        minimapPos = 45,
    },
    seenChars = {},
    uiScale = 1.0,
};

WhatShouldIDoDB = WhatShouldIDoDB or {};

for key, value in pairs(defaults) do
    if WhatShouldIDoDB[key] == nil then
        WhatShouldIDoDB[key] = value;
    end
end

addon.DB = WhatShouldIDoDB;

local function InitDB()
    WhatShouldIDoDB.colorTheme = WhatShouldIDoDB.colorTheme or addon.DEFAULT_THEME;
end
addon.InitDB = InitDB;
