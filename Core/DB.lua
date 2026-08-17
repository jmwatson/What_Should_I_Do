local _, addon = ...

local function InitDB()
    WhatShouldIDoDB = WhatShouldIDoDB or {};
    WhatShouldIDoDB.colorTheme = WhatShouldIDoDB.colorTheme or addon.DEFAULT_THEME;
    WhatShouldIDoDB.customColors = WhatShouldIDoDB.customColors or {};
    WhatShouldIDoDB.excludedActivities = WhatShouldIDoDB.excludedActivities or {};
    WhatShouldIDoDB.excludedChars = WhatShouldIDoDB.excludedChars or {};
    WhatShouldIDoDB.excludedExpansions = WhatShouldIDoDB.excludedExpansions or {};
    WhatShouldIDoDB.excludeFarming = WhatShouldIDoDB.excludeFarming or false;
    WhatShouldIDoDB.excludedSubActivities = WhatShouldIDoDB.excludedSubActivities or {};
    WhatShouldIDoDB.minimap = WhatShouldIDoDB.minimap or {hide=false, minimapPos=45};
    WhatShouldIDoDB.seenChars = WhatShouldIDoDB.seenChars or {};
    WhatShouldIDoDB.uiScale = WhatShouldIDoDB.uiScale or 1.0;
end
addon.InitDB = InitDB;
