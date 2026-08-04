-- Core/Constants.lua
-- Shared layout constants
-- Author: I_AM_T3X | v1.0.0

-- Package for all constants
WSID = {
    ADDON_NAME = "WhatShouldIDo",
    STRING = "What Should I Do?",
    
    WIN_W  = 660,
    WIN_H  = 520,
    NAV_W  = 120,
    PAD    = 16,
    CONT_W = WSID.WIN_W - WSID.NAV_W - WSID.PAD * 2,  -- 508
    
    SET_W   = 700,
    SET_H   = 500,
    SET_NAV = 110,
    SET_PAD = 12,
    SET_CW  = WSID.SET_W - WSID.SET_NAV - WSID.SET_PAD * 2,  -- 566
    SET_COL = math.floor((WSID.SET_CW - 12) / 2),            -- 277
    
    IDENTITY = "player",
    
    EMPTY_STRING = "",
    DASH_DASH = "--",
    UNKNOWN = "??",

    FRAME = "Frame",
    EDIT_BOX = "EditBox",
    BACKDROP_TEMPLATE = "BackdropTemplate",
    UI_PANEL_CLOSE_BUTTON = "UIPanelCloseButton",
    LEFT_BUTTON = "LeftButton",
    RIGHT_BUTTON = "RightButton",
    BUTTON = "Button",

    ACTIVITY_LABEL = "Activity",
    CREATOR_LABEL = "Creator",
    LEVELING_LABEL = "Leveling",
    NAMES_LABEL = "Name Generator",
    PROFESSIONS_LABEL = "Professions",
    RAIDS_AND_DUNGEONS_LABEL = "Raids & Dungeons",
    SETTINGS_LABEL = "Settings",
    ABOUT_LABEL = "About",

    ARTWORK = "ARTWORK",
    DIALOG = "DIALOG",
    OVERLAY = "OVERLAY",
    BACKGROUND = "BACKGROUND",
    
    -- NINE SLICE
    TOPLEFT = "TOPLEFT",
    TOP = "TOP",
    TOPRIGHT = "TOPRIGHT",
    LEFT = "LEFT",
    CENTER = "CENTER",
    RIGHT = "RIGHT",
    BOTTOMLEFT = "BOTTOMLEFT",
    BOTTOM = "BOTTOM",
    BOTTOMRIGHT = "BOTTOMRIGHT",
    
    -- EVENTS
    OnChar = "OnChar",
    OnClick = "OnClick",
    OnDragStart = "OnDragStart",
    OnDragStop = "OnDragStop",
    OnEditFocusGained = "OnEditFocusGained",
    OnEditFocusLost = "OnEditFocusLost",
    OnEnter = "OnEnter",
    OnEnterPressed = "OnEnterPressed",
    OnEscapePressed = "OnEscapePressed",
    OnEvent = "OnEvent",
    OnLeave = "OnLeave",
    OnShow = "OnShow",
    OnTextChanged = "OnTextChanged",
    OnMouseWheel = "OnMouseWheel",
    
    ADDON_LOADED = "ADDON_LOADED",
    PLAYER_LOGIN = "PLAYER_LOGIN",
    
    -- FONTS
    GAME_FONT = "Fonts\\FRIZQT__.TTF",
    NORMAL = "GameFontNormal",
    NORMAL_SMALL = "GameFontNormalSmall",
    NORMAL_LARGE = "GameFontNormalLarge",
    
    BG_FILE = "Interface\\Buttons\\WHITE8x8",
    
    -- Common utility functions
    FilterFunction = function(arr, filter)
        local filtered = {}
        for _, value in ipairs(arr) do
            if not filter[value] then
                table.insert(filtered, value)
            end
        end
        return filtered
    end
}
