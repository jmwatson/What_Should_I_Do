-- Data/Activities.lua
-- Default activity categories and sub-activities

PVP = 0
HOUSING = 1
OPEN_WORLD = 2
RARE_HUNTING = 3
DELVE = 4
GATHERING = 5
CRAFTING = 6
COLLECTIONS = 7
GOLD_MAKING = 8
HOLIDAY_EVENTS = 9
LEVELING = 10
PET_BATTLES = 11
ANYTHING_GOES = 12

WSID_ACTIVITIES = {
    {name="PvP", options={"Random Battleground","Epic Battleground","Arena Skirmish","War Mode","World PvP","Brawl"},},
    {name="Housing", options={"Work on House Layout","Gather Decor","Endeavor Tasks","Theme Room","Farm Housing Items","Decorate a Room"},},
    {name="Open World", options={"World Quests","Weekly Quests","Reputation Grind","Renown Catch-up","Zone Completion","Public Events","Rituals","Void Assaults","Rare Hunting","Daily Objectives"},},
    {name="Rare Hunting", options={"Current Expansion Rares","Old Expansion Rares","Mount Rare","Toy Rare","Pet Rare","Champion Rare"},},
    {name="Delves", options={"Solo Delves","Group Delves","Bountiful Delves","Push Higher Tier","Farm Curios","Follower Leveling"},},
    {name="Gathering", options={"Mining","Herbalism","Fishing","Skinning","Gather for 30 Min","Farm Reagents"},},
    {name="Crafting", options={"Profession Orders","Crafting Knowledge","Cooldowns","Make Consumables","Craft for Gold","Clean Bags"},},
    {name="Collections", options={"Mounts","Pets","Toys","Appearances","Achievements","Reputation","Random ATT Category","Transmog Farming","Old Raid for Transmog","Old Dungeon for Transmog","Achievement Hunting","Exploration Achieves","Legacy Achieves"},},
    {name="Gold Making", options={"Auction House","Gathering Farm","Crafting Shuffle","Transmog Farm","Raw Gold Farm","Vendor Flip","Clean Bank"},},
    {name="Holiday Events / Trading Post", options={"Holiday Boss","Holiday Achievements","Trading Post Tasks","Monthly Reward Progress","Event Toys/Pets"},},
    {name="Leveling", options={"Alt Leveling","Dungeon Spam","Questing","Chromie Time","Follower Dungeons","Prof While Leveling"},},
    {name="Pet Battles", options={"Pet Battle Dailies","Level Pets","Capture Pets","Family Battler","Pet Dungeon","Random Pet Team"},},
    {name="Anything Goes", options={"Do the Weirdest Thing","Finish Something Half-Done","One Hour Chaos Mode","Pick Something from Your Backlog"},},
}

function GetSubPool(category)
    if WhatShouldIDoDB and WhatShouldIDoDB.subActivities
    and WhatShouldIDoDB.subActivities[category]
    and #WhatShouldIDoDB.subActivities[category] > 0 then
        return WhatShouldIDoDB.subActivities[category]
    end
    return WSID_ACTIVITIES[category]
end
