-- Core/Constants.lua
-- Shared layout constants
-- Author: I_AM_T3X | v1.0.0

local _, addon = ...

-- Package for all constants
addon.ADDON_NAME = "WhatShouldIDo"
addon.STRING = "What Should I Do?"

addon.SET_W   = 700
addon.SET_H   = 500
addon.SET_NAV = 110
addon.SET_PAD = 12
addon.SET_CW  = addon.SET_W - addon.SET_NAV - addon.SET_PAD * 2  -- 566
addon.SET_COL = math.floor((addon.SET_W - addon.SET_NAV - addon.SET_PAD * 2 - addon.SET_PAD) / 2)  -- 277

addon.IDENTITY = "player"

addon.EMPTY_STRING = ""
addon.DASH_DASH = "--"
addon.UNKNOWN = "??"

addon.FRAME = "Frame"
addon.EDIT_BOX = "EditBox"
addon.BACKDROP_TEMPLATE = "BackdropTemplate"
addon.UI_PANEL_CLOSE_BUTTON = "UIPanelCloseButton"
addon.LEFT_BUTTON = "LeftButton"
addon.RIGHT_BUTTON = "RightButton"
addon.BUTTON = "Button"

addon.ACTIVITY_LABEL = "Activity"
addon.CREATOR_LABEL = "Creator"
addon.LEVELING_LABEL = "Leveling"
addon.NAMES_LABEL = "Name Generator"
addon.PROFESSIONS_LABEL = "Professions"
addon.RAIDS_AND_DUNGEONS_LABEL = "Raids & Dungeons"
addon.SETTINGS_LABEL = "Settings"
addon.ABOUT_LABEL = "About"

addon.ARTWORK = "ARTWORK"
addon.DIALOG = "DIALOG"
addon.OVERLAY = "OVERLAY"
addon.BACKGROUND = "BACKGROUND"

-- NINE SLICE
addon.TOPLEFT = "TOPLEFT"
addon.TOP = "TOP"
addon.TOPRIGHT = "TOPRIGHT"
addon.LEFT = "LEFT"
addon.CENTER = "CENTER"
addon.RIGHT = "RIGHT"
addon.BOTTOMLEFT = "BOTTOMLEFT"
addon.BOTTOM = "BOTTOM"
addon.BOTTOMRIGHT = "BOTTOMRIGHT"

-- EVENTS
addon.OnChar = "OnChar"
addon.OnClick = "OnClick"
addon.OnDragStart = "OnDragStart"
addon.OnDragStop = "OnDragStop"
addon.OnEditFocusGained = "OnEditFocusGained"
addon.OnEditFocusLost = "OnEditFocusLost"
addon.OnEnter = "OnEnter"
addon.OnEnterPressed = "OnEnterPressed"
addon.OnEscapePressed = "OnEscapePressed"
addon.OnEvent = "OnEvent"
addon.OnLeave = "OnLeave"
addon.OnShow = "OnShow"
addon.OnTextChanged = "OnTextChanged"
addon.OnMouseWheel = "OnMouseWheel"

addon.ADDON_LOADED = "ADDON_LOADED"
addon.PLAYER_LOGIN = "PLAYER_LOGIN"

-- FONTS
addon.GAME_FONT = "Fonts\\FRIZQT__.TTF"
addon.NORMAL = "GameFontNormal"
addon.NORMAL_SMALL = "GameFontNormalSmall"
addon.NORMAL_LARGE = "GameFontNormalLarge"

addon.BG_FILE = "Interface\\Buttons\\WHITE8x8"

-- Common utility functions
local function Intersect(arr1, arr2)
    local filtered = {};
    for _, v1 in ipairs(arr1) do
        for _, v2 in ipairs(arr2) do
            if v1 == v2 then
                table.insert(filtered, v1);
                break;
            end
        end
    end
    return filtered;
end
addon.Intersect = Intersect;

local function KeyedFilter(tbl, filter)
    local filtered = {};
    for k, _ in ipairs(tbl) do
        if not filter[k] then
            table.insert(filtered, k);
        end
    end
    return filtered;
end
addon.KeyedFilter = KeyedFilter;

local function Filter(tbl, filter)
    local filtered = {};
    for _, v in ipairs(tbl) do
        if not filter[v] then
            table.insert(filtered, v);
        end
    end
    return filtered;
end
addon.Filter = Filter;
