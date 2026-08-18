local _, addon = ...

WhatShouldIDoDB = WhatShouldIDoDB or {};
WhatShouldIDoDB.COLOR_TABLE = WhatShouldIDoDB.COLOR_TABLE or {};
WhatShouldIDoDB.customColors = WhatShouldIDoDB.customColors or {};
WhatShouldIDoDB.excludedActivities = WhatShouldIDoDB.excludedActivities or {};
WhatShouldIDoDB.excludedChars = WhatShouldIDoDB.excludedChars or {};
WhatShouldIDoDB.excludedExpansions = WhatShouldIDoDB.excludedExpansions or {};
WhatShouldIDoDB.excludeFarming = WhatShouldIDoDB.excludeFarming or false;
WhatShouldIDoDB.excludedSubActivities = WhatShouldIDoDB.excludedSubActivities or {};
WhatShouldIDoDB.minimap = WhatShouldIDoDB.minimap or {hide=false, minimapPos=45};
WhatShouldIDoDB.seenChars = WhatShouldIDoDB.seenChars or {};
WhatShouldIDoDB.uiScale = WhatShouldIDoDB.uiScale or 1.0;
addon.DB = WhatShouldIDoDB;

local function InitDB()
    WhatShouldIDoDB.colorTheme = WhatShouldIDoDB.colorTheme or addon.DEFAULT_THEME;
end
addon.InitDB = InitDB;
