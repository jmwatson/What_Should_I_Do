-- Data/Expansions.lua
-- Expansion list and level-gated pool logic
-- Author: I_AM_T3X | v1.0.0

CLASSIC = "Classic"
TBC = "The Burning Crusade"
WRATH = "Wrath of the Lich King"
CATA = "Cataclysm"
MISTS = "Mists of Pandaria"
WOD = "Warlords of Draenor"
LEGION = "Legion"
BFA = "Battle for Azeroth"
SL = "Shadowlands"
DF = "Dragonflight"
TWW = "The War Within"
MIDNIGHT = "Midnight"

WSID_EXPANSIONS = {
    CLASSIC,
    TBC,
    WRATH,
    CATA,
    MISTS,
    WOD,
    LEGION,
    BFA,
    SL,
    DF,
    TWW,
    MIDNIGHT,
}

function GetExpansionPool(level)
    if level >= 80 then
        return {MIDNIGHT}
    elseif level >= 70 then
        return {TWW}
    elseif level >= 10 then
        local pool = {}
        for _, e in ipairs(WSID_EXPANSIONS) do
            if e ~= TWW and e ~= MIDNIGHT then
                table.insert(pool, e)
            end
        end
        return pool
    else
        return {"Finish your starting zone and reroll!"}
    end
end

-- Helper: map expansion name -> chronological index
WSID_EXPANSION_INDEX = {}
for i, name in ipairs(WSID_EXPANSIONS) do WSID_EXPANSION_INDEX[name] = i end
