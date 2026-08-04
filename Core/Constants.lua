-- Core/Constants.lua
-- Shared layout constants
-- Author: I_AM_T3X | v1.0.0

WSID_ADDON_NAME = "WhatShouldIDo"
WSID_STRING = "What Should I Do?"

WSID_WIN_W  = 660
WSID_WIN_H  = 520
WSID_NAV_W  = 120
WSID_PAD    = 16
WSID_CONT_W = WSID_WIN_W - WSID_NAV_W - WSID_PAD * 2  -- 508

WSID_SET_W   = 700
WSID_SET_H   = 500
WSID_SET_NAV = 110
WSID_SET_PAD = 12
WSID_SET_CW  = WSID_SET_W - WSID_SET_NAV - WSID_SET_PAD * 2  -- 566
WSID_SET_COL = math.floor((WSID_SET_CW - 12) / 2)            -- 277

WSID_IDENTITY = "player"

WSID_EMPTY_STRING = ""
WSID_DASH_DASH = "--"
WSID_UNKNOWN = "??"

WSID_FRAME = "Frame"
WSID_EDIT_BOX = "EditBox"
WSID_BACKDROP_TEMPLATE = "BackdropTemplate"
WSID_UI_PANEL_CLOSE_BUTTON = "UIPanelCloseButton"
WSID_WSIDLEFT_BUTTON = "LeftButton"
WSID_RIGHT_BUTTON = "RightButton"
WSID_BUTTON = "Button"

WSID_ACTIVITY_LABEL = "Activity"
WSID_CREATOR_LABEL = "Creator"
WSID_LEVELING_LABEL = "Leveling"
WSID_NAMES_LABEL = "Name Generator"
WSID_PROFESSIONS_LABEL = "Professions"
WSID_RAIDS_AND_DUNGEONS_LABEL = "Raids & Dungeons"
WSID_SETTINGS_LABEL = "Settings"
WSID_ABOUT_LABEL = "About"

WSID_ARTWORK = "WSID_ARTWORK"
WSID_DIALOG = "WSID_DIALOG"
WSID_OVERLAY = "WSID_OVERLAY"
WSID_BACKGROUND = "WSID_BACKGROUND"

-- NINE SLICE
WSID_TOPLEFT = "TOPLEFT"
WSID_TOP = "TOP"
WSID_TOPRIGHT = "TOPRIGHT"
WSID_LEFT = "LEFT"
WSID_CENTER = "CENTER"
WSID_RIGHT = "RIGHT"
WSID_BOTTOMLEFT = "BOTTOMLEFT"
WSID_BOTTOM = "BOTTOM"
WSID_BOTTOMRIGHT = "BOTTOMRIGHT"

-- EVENTS
WSID_OnChar = "WSID_OnChar"
WSID_OnClick = "WSID_OnClick"
WSID_OnDragStart = "WSID_OnDragStart"
WSID_OnDragStop = "WSID_OnDragStop"
WSID_OnEditFocusGained = "WSID_OnEditFocusGained"
WSID_OnEditFocusLost = "WSID_OnEditFocusLost"
WSID_OnEnter = "WSID_OnEnter"
WSID_OnEnterPressed = "WSID_OnEnterPressed"
WSID_OnEscapePressed = "WSID_OnEscapePressed"
WSID_OnEvent = "WSID_OnEvent"
WSID_OnLeave = "WSID_OnLeave"
WSID_OnShow = "WSID_OnShow"
WSID_OnTextChanged = "WSID_OnTextChanged"
WSID_OnMouseWheel = "WSID_OnMouseWheel"

WSID_ADDON_LOADED = "WSID_ADDON_LOADED"
WSID_PLAYER_LOGIN = "WSID_PLAYER_LOGIN"

-- FONTS
WSID_GAME_FONT = "Fonts\\FRIZQT__.TTF"
WSID_NORMAL = "GameFontNormal"
WSID_NORMAL_SMALL = "GameFontNormalSmall"
WSID_NORMAL_LARGE = "GameFontNormalLarge"

WSID_BG_FILE = "Interface\\Buttons\\WHITE8x8"

-- Common utility functions
function FilterFunction(arr, filter)
    local filtered = {}
    for _, value in ipairs(arr) do
        if not filter[value] then
            table.insert(filtered, value)
        end
    end
    return filtered
end
