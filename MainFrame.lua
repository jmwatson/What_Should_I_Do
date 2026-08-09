-- MainFrame.lua
-- Main window, left nav, minimap button, init, slash commands
-- Author: I_AM_T3X | v1.0.0

WhatShouldIDoDB.MainFrame = nil
local MainPanels = {}
-- WSID.FRAME = "WhatShouldIDoFrame"

WSID["BuildMainFrame"] = function()
    local f=CreateFrame(WSID.FRAME,WSID.FRAME,UIParent,WSID.BACKDROP_TEMPLATE)
    f:SetSize(WSID.WIN_W,WSID.WIN_H)
    f:SetPoint(WSID.WSID.CENTER)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag(WSID.LEFT_BUTTON)
    f:SetScript(WSID.OnDragStart,f.StartMoving)
    f:SetScript(WSID.OnDragStop,f.StopMovingOrSizing)
    f:SetFrameStrata(WSID.DIALOG)
    f:SetBackdrop({bgFile=WSID.BG_FILE,edgeFile=WSID.BG_FILE,edgeSize=1})
    f:SetBackdropColor(WhatShouldIDoDB.COLOR_TABLE.bg[1],WhatShouldIDoDB.COLOR_TABLE.bg[2],WhatShouldIDoDB.COLOR_TABLE.bg[3],1)
    f:SetBackdropBorderColor(WhatShouldIDoDB.COLOR_TABLE.win_border[1],WhatShouldIDoDB.COLOR_TABLE.win_border[2],WhatShouldIDoDB.COLOR_TABLE.win_border[3],1)

    -- Title bar
    local tb=CreateFrame(WSID.FRAME,nil,f)
    tb:SetHeight(30)
    tb:SetPoint(WSID.TOPLEFT,f,WSID.TOPLEFT,0,0)
    tb:SetPoint(WSID.TOPRIGHT,f,WSID.TOPRIGHT,0,0)
    WSID.Tx(tb,WhatShouldIDoDB.COLOR_TABLE.sidebar[1],WhatShouldIDoDB.COLOR_TABLE.sidebar[2],WhatShouldIDoDB.COLOR_TABLE.sidebar[3])
    local tbb=tb:CreateTexture(nil,WSID.ARTWORK)
    tbb:SetColorTexture(WhatShouldIDoDB.COLOR_TABLE.divider[1],WhatShouldIDoDB.COLOR_TABLE.divider[2],WhatShouldIDoDB.COLOR_TABLE.divider[3],1)
    tbb:SetHeight(1)
    tbb:SetPoint(WSID.BOTTOMLEFT,tb,WSID.BOTTOMLEFT,0,0)
    tbb:SetPoint(WSID.BOTTOMRIGHT,tb,WSID.BOTTOMRIGHT,0,0)
    local titleLbl=tb:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_LARGE)
    titleLbl:SetPoint(WSID.CENTER,tb,WSID.CENTER,0,0)
    titleLbl:SetText(WSID.STRING)
    titleLbl:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.bright_text[1],WhatShouldIDoDB.COLOR_TABLE.bright_text[2],WhatShouldIDoDB.COLOR_TABLE.bright_text[3])
    local closeBtn=CreateFrame(WSID.BUTTON,nil,f,WSID.UI_PANEL_CLOSE_BUTTON)
    closeBtn:SetPoint(WSID.TOPRIGHT,f,WSID.TOPRIGHT,-2,-2)
    closeBtn:SetFrameStrata(f:GetFrameStrata())
    closeBtn:SetFrameLevel(f:GetFrameLevel() + 1)
    closeBtn:SetScript(WSID.OnClick,function()
        f:Hide()
        if WhatShouldIDoDB.SettingsFrame then WhatShouldIDoDB.SettingsFrame:Hide() end
    end)

    -- Content area
    local contentArea=CreateFrame(WSID.FRAME,nil,f)
    contentArea:SetPoint(WSID.TOPLEFT,f,WSID.TOPLEFT,WSID.NAV_W,-30)
    contentArea:SetPoint(WSID.BOTTOMRIGHT,f,WSID.BOTTOMRIGHT,0,0)
    WSID.Tx(contentArea,WhatShouldIDoDB.COLOR_TABLE.bg[1]+0.005,WhatShouldIDoDB.COLOR_TABLE.bg[2]+0.005,WhatShouldIDoDB.COLOR_TABLE.bg[3]+0.01)

    local actPanel  = WSID.BuildActivityPanel(contentArea)
    local crePanel  = WSID.BuildCreatorPanel(contentArea)
    local levPanel  = WSID.BuildLevelingPanel(contentArea)
    local namPanel  = WSID.BuildNamePanel(contentArea)
    local profPanel = WSID.BuildProfessionPanel(contentArea)
    local rdPanel   = WSID.BuildRaidDungeonPanel(contentArea)
    local abtPanel  = WSID.BuildAboutPanel(contentArea)
    MainPanels={activity=actPanel,creator=crePanel,leveling=levPanel,names=namPanel,professions=profPanel,raidsdungeons=rdPanel,about=abtPanel}

    local leveling_nav = "leveling"
    local settings_nav = "settings_nav"
    WSID.BuildLeftNav(f,
        {
            {name="activity",label=WSID.ACTIVITY_LABEL},
            {name="creator",label=WSID.CREATOR_LABEL},
            {name=leveling_nav,label=WSID.LEVELING_LABEL},
            {name="names",label=WSID.NAMES_LABEL},
            {name="professions",label=WSID.PROFESSIONS_LABEL},
            {name="raidsdungeons",label=WSID.RAIDS_AND_DUNGEONS_LABEL}
        },
        {
            {name=settings_nav,label=WSID.SETTINGS_LABEL},
            {name="about",label=WSID.ABOUT_LABEL}
        },
        function(name)
            if name==settings_nav then
                if WhatShouldIDoDB.SettingsFrame then
                    if WhatShouldIDoDB.SettingsFrame:IsShown() then WhatShouldIDoDB.SettingsFrame:Hide() else WhatShouldIDoDB.SettingsFrame:Show() end
                end
                return
            end
            -- Always refresh WSID_Roster when switching to leveling so imports show immediately
            if name==leveling_nav then WSID.BuildRoster() end
            for k,p in pairs(MainPanels) do if k==name then p:Show() else p:Hide() end end
        end
    )

    f:Hide()
    return f
end

------------------------------------------------------------------------
-- MINIMAP BUTTON
------------------------------------------------------------------------

WSID["RegisterMinimapButton"] = function()
    local LDB=LibStub("LibDataBroker-1.1")
    local LibDBIcon=LibStub("LibDBIcon-1.0")
    local broker=LDB:NewDataObject(WSID.ADDON_NAME,{
        type="launcher", icon="Interface\\Icons\\INV_Misc_QuestionMark", label=WSID.STRING,
        OnClick=function(_,btn)
            if btn==WSID.LEFT_BUTTON then
                if WhatShouldIDoDB.MainFrame:IsShown() then
                    WhatShouldIDoDB.MainFrame:Hide()
                    if WhatShouldIDoDB.SettingsFrame then WhatShouldIDoDB.SettingsFrame:Hide() end
                else
                    WSID.BuildRoster()
                    WhatShouldIDoDB.MainFrame:Show()
                end
            elseif btn==WSID.RIGHT_BUTTON then
                if WhatShouldIDoDB.SettingsFrame:IsShown() then WhatShouldIDoDB.SettingsFrame:Hide() else WhatShouldIDoDB.SettingsFrame:Show() end
            end
        end,
        OnTooltipShow=function(tt)
            tt:SetText(WSID.STRING,1,0.85,0.20)
            tt:AddLine("Left-click: open / close",0.8,0.8,0.8)
            tt:AddLine("Right-click: settings",   0.8,0.8,0.8)
        end,
    })
    LibDBIcon:Register(WSID.ADDON_NAME,broker,WhatShouldIDoDB.minimap)
end

------------------------------------------------------------------------
-- INIT
------------------------------------------------------------------------

local initFrame=CreateFrame(WSID.FRAME)
initFrame:RegisterEvent(WSID.ADDON_LOADED)
initFrame:RegisterEvent(WSID.PLAYER_LOGIN)
initFrame:SetScript(WSID.OnEvent,function(self,event,arg1)
    if event==WSID.ADDON_LOADED and arg1==WSID.ADDON_NAME then
        WSID.InitDB()
        -- Apply saved theme (must run after InitDB sets defaults and after ApplyTheme is defined)
        if WhatShouldIDoDB.colorTheme == WSID.CUSTOM_THEME and next(WhatShouldIDoDB.customColors) then
            WSID.ApplyTheme(WSID.CUSTOM_THEME, WhatShouldIDoDB.customColors)
        else
            WSID.ApplyTheme(WhatShouldIDoDB.colorTheme or WSID.DEFAULT_THEME)
        end

        -- Define StaticPopup dialogs at init time so they're registered before use
        StaticPopupDialogs["WSID_CONFIRM_THEME"] = StaticPopupDialogs["WSID_CONFIRM_THEME"] or {}
        StaticPopupDialogs["WSID_CONFIRM_WSID.CUSTOM_THEME"] = StaticPopupDialogs["WSID_CONFIRM_WSID.CUSTOM_THEME"] or {}
        WhatShouldIDoDB.MainFrame     = WSID.BuildMainFrame()
        WhatShouldIDoDB.SettingsFrame = WSID.BuildSettingsWindow()
        WSID.RegisterMinimapButton()
        -- ESC closes the windows
        tinsert(UISpecialFrames, WSID.FRAME)
        tinsert(UISpecialFrames, "WhatShouldIDoSettings")
        -- Apply saved UI scale
        local scale = WhatShouldIDoDB.uiScale or 1.0
        WhatShouldIDoDB.MainFrame:SetScale(scale)
        WhatShouldIDoDB.SettingsFrame:SetScale(scale)
    elseif event==WSID.PLAYER_LOGIN then
        if WhatShouldIDoDB then WSID.BuildRoster() end
    end
end)

SLASH_WSID1="/wsid"
SLASH_WSID2="/whatshouldido"
SlashCmdList["WSID"]=function(msg)
    msg=strtrim(msg)
    local msgL=msg:lower()
    if msgL=="WSID_Roster" then
        WSID.BuildRoster()
        print("|cffd5a742What Should I Do?:|r Roster refreshed -- "..#WSID_Roster.." character(s).")
        return
    end
    if msgL=="settings" then
        if WhatShouldIDoDB.SettingsFrame then
            if WhatShouldIDoDB.SettingsFrame:IsShown() then WhatShouldIDoDB.SettingsFrame:Hide() else WhatShouldIDoDB.SettingsFrame:Show() end
        end
        return
    end
    if WhatShouldIDoDB.MainFrame then
        if WhatShouldIDoDB.MainFrame:IsShown() then
            WhatShouldIDoDB.MainFrame:Hide()
            if WhatShouldIDoDB.SettingsFrame then WhatShouldIDoDB.SettingsFrame:Hide() end
        else WSID.BuildRoster()
            WhatShouldIDoDB.MainFrame:Show()
        end
    end
end

