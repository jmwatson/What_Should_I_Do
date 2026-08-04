-- Data/Activities.lua
-- Default activity categories and sub-activities

WSID_ACTIVITIES_INFO = {
    ["PvP"] = {"Random Battleground","Epic Battleground","Arena Skirmish","War Mode","World PvP","Brawl"},
    ["Housing"] = {"Work on House Layout","Gather Decor","Endeavor Tasks","Theme Room","Farm Housing Items","Decorate a Room"},
    ["Open World"] = {"World Quests","Weekly Quests","Reputation Grind","Renown Catch-up","Zone Completion","Public Events","Rituals","Void Assaults","Rare Hunting","Daily Objectives"},
    ["Rare Hunting"] = {"Current Expansion Rares","Old Expansion Rares","Mount Rare","Toy Rare","Pet Rare","Champion Rare"},
    ["Delves"] = {"Solo Delves","Group Delves","Bountiful Delves","Push Higher Tier","Farm Curios","Follower Leveling"},
    ["Gathering"] = {"Mining","Herbalism","Fishing","Skinning","Gather for 30 Min","Farm Reagents"},
    ["Crafting"] = {"Profession Orders","Crafting Knowledge","Cooldowns","Make Consumables","Craft for Gold","Clean Bags"},
    ["Collections"] = {"Mounts","Pets","Toys","Appearances","Achievements","Reputation","Random ATT Category","Transmog Farming","Old Raid for Transmog","Old Dungeon for Transmog","Achievement Hunting","Exploration Achieves","Legacy Achieves"},
    ["Gold Making"] = {"Auction House","Gathering Farm","Crafting Shuffle","Transmog Farm","Raw Gold Farm","Vendor Flip","Clean Bank"},
    ["Holiday Events / Trading Post"] = {"Holiday Boss","Holiday Achievements","Trading Post Tasks","Monthly Reward Progress","Event Toys/Pets"},
    ["Leveling"] = {"Alt Leveling","Dungeon Spam","Questing","Chromie Time","Follower Dungeons","Prof While Leveling"},
    ["Pet Battles"] = {"Pet Battle Dailies","Level Pets","Capture Pets","Family Battler","Pet Dungeon","Random Pet Team"},
    ["Anything Goes"] = {"Do the Weirdest Thing","Finish Something Half-Done","One Hour Chaos Mode","Pick Something from Your Backlog"},
}

local activities = {}
for activity, _ in WSID_ACTIVITIES_INFO do table.insert(activites, activity) end

WSID["GetActivities"] = function()
    local filteredActivities = {}
    if WhatShouldIDoDB and WhatShouldIDoDB.excludedActivities and #WhatShouldIDoDB.excludedActivities > 0 then
        filteredActivities = WSID.FilterFunction(activities, WhatShouldIDoDB.excludedActivities)
    end
    return filteredActivities
end

WSID["GetSubActivities"] = function()
    local filtered = {}
    if WhatShouldIDoDB and WhatShouldIDoDB.excludedSubActivities and #WhatShouldIDoDB.excludedSubActivities > 0 then
        filtered = WSID.FilterFunction(WSID_ACTIVITIES_INFO, WhatShouldIDoDB.excludedSubActivities)
    end
    return filtered
end
