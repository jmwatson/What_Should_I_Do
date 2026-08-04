-- Core/DB.lua
-- SavedVariables initialization

function InitDB()
    if not WhatShouldIDoDB then WhatShouldIDoDB = {} end
    if not WhatShouldIDoDB.activities then
        WhatShouldIDoDB.activities = {}
        SetActivitiesDB() -- Populate default activities if empty
    end
    if not WhatShouldIDoDB.minimap then WhatShouldIDoDB.minimap = {hide=false, minimapPos=45} end
    if not WhatShouldIDoDB.subActivities then WhatShouldIDoDB.subActivities = {} end

    -- Clean up orphaned sub-activity keys
    if WhatShouldIDoDB.subActivities then
        local validKeys = {}
        for _, act in ipairs(WhatShouldIDoDB.activities) do validKeys[act] = true end
        for key in pairs(WhatShouldIDoDB.subActivities) do
            if not validKeys[key] then WhatShouldIDoDB.subActivities[key] = nil end
        end
    end
    
    if not WhatShouldIDoDB.seenChars then WhatShouldIDoDB.seenChars = {} end
    if not WhatShouldIDoDB.colorTheme then WhatShouldIDoDB.colorTheme = DEFAULT end
    if not WhatShouldIDoDB.uiScale then WhatShouldIDoDB.uiScale = 1.0 end
    if not WhatShouldIDoDB.customColors then WhatShouldIDoDB.customColors = {} end
    if not WhatShouldIDoDB.excludedChars then WhatShouldIDoDB.excludedChars = {} end
    if not WhatShouldIDoDB.excludedExpansions then WhatShouldIDoDB.excludedExpansions = {} end
    if WhatShouldIDoDB.excludeFarming == nil then WhatShouldIDoDB.excludeFarming = false end
    if not WhatShouldIDoDB.excludedActivities then WhatShouldIDoDB.excludedActivities = {} end
    if not WhatShouldIDoDB.excludedSubActivities then WhatShouldIDoDB.excludedSubActivities = {} end
end

function SetActivitiesDB()
    if WhatShouldIDoDB and WhatShouldIDoDB.activities and #WhatShouldIDoDB.activities == 0 then
        for activity, _ in ipairs(WSID_ACTIVITIES_INFO) do table.insert(WhatShouldIDoDB.activities, activity) end
    end
    return WhatShouldIDoDB.activities
end

function SetSubActivitiesDB(category)
    if WhatShouldIDoDB and WhatShouldIDoDB.subActivities and #WhatShouldIDoDB.subActivities == 0 then
        for activity, _ in ipairs(WSID_ACTIVITIES_INFO) do
            WhatShouldIDoDB.subActivities[activity] = WSID_ACTIVITIES_INFO[activity]
        end
    end
    return WhatShouldIDoDB.subActivities[category]
end
