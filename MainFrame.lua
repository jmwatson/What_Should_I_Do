-- MainFrame.lua
-- Main window, left nav, minimap button, init, slash commands
-- Author: I_AM_T3X | v1.0.0

MainFrame = nil
MainPanels = {}
WSID_FRAME = "WhatShouldIDoFrame"

function BuildMainFrame()
    local f=CreateFrame(WSID_FRAME,WSID_FRAME,UIParent,WSID_BACKDROP_TEMPLATE)
    f:SetSize(WSID_WIN_W,WSID_WIN_H)
    f:SetPoint(WSID_CENTER)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag(WSID_WSIDLEFT_BUTTON)
    f:SetScript(WSID_OnDragStart,f.StartMoving)
    f:SetScript(WSID_OnDragStop,f.StopMovingOrSizing)
    f:SetFrameStrata(WSID_DIALOG)
    f:SetBackdrop({bgFile=WSID_BG_FILE,edgeFile=WSID_BG_FILE,edgeSize=1})
    f:SetBackdropColor(COLOR_TABLE.bg[1],COLOR_TABLE.bg[2],COLOR_TABLE.bg[3],1)
    f:SetBackdropBorderColor(COLOR_TABLE.win_border[1],COLOR_TABLE.win_border[2],COLOR_TABLE.win_border[3],1)

    -- Title bar
    local tb=CreateFrame(WSID_FRAME,nil,f)
    tb:SetHeight(30)
    tb:SetPoint(WSID_TOPLEFT,f,WSID_TOPLEFT,0,0)
    tb:SetPoint(WSID_TOPRIGHT,f,WSID_TOPRIGHT,0,0)
    Tx(tb,COLOR_TABLE.sidebar[1],COLOR_TABLE.sidebar[2],COLOR_TABLE.sidebar[3])
    local tbb=tb:CreateTexture(nil,WSID_ARTWORK)
    tbb:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    tbb:SetHeight(1)
    tbb:SetPoint(WSID_BOTTOMLEFT,tb,WSID_BOTTOMLEFT,0,0)
    tbb:SetPoint(WSID_BOTTOMRIGHT,tb,WSID_BOTTOMRIGHT,0,0)
    local titleLbl=tb:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_LARGE)
    titleLbl:SetPoint(WSID_CENTER,tb,WSID_CENTER,0,0)
    titleLbl:SetText(WSID_STRING)
    titleLbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
    local closeBtn=CreateFrame(WSID_BUTTON,nil,f,WSID_UI_PANEL_CLOSE_BUTTON)
    closeBtn:SetPoint(WSID_TOPRIGHT,f,WSID_TOPRIGHT,-2,-2)
    closeBtn:SetFrameStrata(f:GetFrameStrata())
    closeBtn:SetFrameLevel(f:GetFrameLevel() + 1)
    closeBtn:SetScript(WSID_OnClick,function()
        f:Hide()
        if SettingsFrame then SettingsFrame:Hide() end
    end)

    -- Content area
    local contentArea=CreateFrame(WSID_FRAME,nil,f)
    contentArea:SetPoint(WSID_TOPLEFT,f,WSID_TOPLEFT,WSID_NAV_W,-30)
    contentArea:SetPoint(WSID_BOTTOMRIGHT,f,WSID_BOTTOMRIGHT,0,0)
    Tx(contentArea,COLOR_TABLE.bg[1]+0.005,COLOR_TABLE.bg[2]+0.005,COLOR_TABLE.bg[3]+0.01)

    local actPanel  = BuildActivityPanel(contentArea)
    local crePanel  = BuildCreatorPanel(contentArea)
    local levPanel  = BuildLevelingPanel(contentArea)
    local namPanel  = BuildNamePanel(contentArea)
    local profPanel = BuildProfessionPanel(contentArea)
    local rdPanel   = BuildRaidDungeonPanel(contentArea)
    local abtPanel  = BuildAboutPanel(contentArea)
    MainPanels={activity=actPanel,creator=crePanel,leveling=levPanel,names=namPanel,professions=profPanel,raidsdungeons=rdPanel,about=abtPanel}

    local leveling_nav = "leveling"
    local settings_nav = "settings_nav"
    BuildLeftNav(f,
        {
            {name="activity",label=WSID_ACTIVITY_LABEL},
            {name="creator",label=WSID_CREATOR_LABEL},
            {name=leveling_nav,label=WSID_LEVELING_LABEL},
            {name="names",label=WSID_NAMES_LABEL},
            {name="professions",label=WSID_PROFESSIONS_LABEL},
            {name="raidsdungeons",label=WSID_RAIDS_AND_DUNGEONS_LABEL}
        },
        {
            {name=settings_nav,label=WSID_SETTINGS_LABEL},
            {name="about",label=WSID_ABOUT_LABEL}
        },
        function(name)
            if name==settings_nav then
                if SettingsFrame then
                    if SettingsFrame:IsShown() then SettingsFrame:Hide() else SettingsFrame:Show() end
                end
                return
            end
            -- Always refresh WSID_Roster when switching to leveling so imports show immediately
            if name==leveling_nav then BuildRoster() end
            for k,p in pairs(MainPanels) do if k==name then p:Show() else p:Hide() end end
        end
    )

    f:Hide()
    return f
end

------------------------------------------------------------------------
-- MINIMAP BUTTON
------------------------------------------------------------------------

function RegisterMinimapButton()
    local LDB=LibStub("LibDataBroker-1.1")
    local LibDBIcon=LibStub("LibDBIcon-1.0")
    local broker=LDB:NewDataObject(WSID_ADDON_NAME,{
        type="launcher", icon="Interface\\Icons\\INV_Misc_QuestionMark", label=WSID_STRING,
        OnClick=function(_,btn)
            if btn==WSID_WSIDLEFT_BUTTON then
                if MainFrame:IsShown() then
                    MainFrame:Hide()
                    if SettingsFrame then SettingsFrame:Hide() end
                else
                    BuildRoster()
                    MainFrame:Show()
                end
            elseif btn==WSID_RIGHT_BUTTON then
                if SettingsFrame:IsShown() then SettingsFrame:Hide() else SettingsFrame:Show() end
            end
        end,
        OnTooltipShow=function(tt)
            tt:SetText(WSID_STRING,1,0.85,0.20)
            tt:AddLine("Left-click: open / close",0.8,0.8,0.8)
            tt:AddLine("Right-click: settings",   0.8,0.8,0.8)
        end,
    })
    LibDBIcon:Register(WSID_ADDON_NAME,broker,WhatShouldIDoDB.minimap)
end

------------------------------------------------------------------------
-- INIT
------------------------------------------------------------------------

local initFrame=CreateFrame(WSID_FRAME)
initFrame:RegisterEvent(WSID_ADDON_LOADED)
initFrame:RegisterEvent(WSID_PLAYER_LOGIN)
initFrame:SetScript(WSID_OnEvent,function(self,event,arg1)
    if event==WSID_ADDON_LOADED and arg1==WSID_ADDON_NAME then
        InitDB()
        -- Apply saved theme (must run after InitDB sets defaults and after ApplyTheme is defined)
        if WhatShouldIDoDB.colorTheme == CUSTOM and next(WhatShouldIDoDB.customColors) then
            ApplyTheme(CUSTOM, WhatShouldIDoDB.customColors)
        else
            ApplyTheme(WhatShouldIDoDB.colorTheme or DEFAULT)
        end

        -- Define StaticPopup dialogs at init time so they're registered before use
        StaticPopupDialogs["WSID_CONFIRM_THEME"] = StaticPopupDialogs["WSID_CONFIRM_THEME"] or {}
        StaticPopupDialogs["WSID_CONFIRM_CUSTOM"] = StaticPopupDialogs["WSID_CONFIRM_CUSTOM"] or {}
        MainFrame     = BuildMainFrame()
        SettingsFrame = BuildSettingsWindow()
        RegisterMinimapButton()
        -- ESC closes the windows
        tinsert(UISpecialFrames, WSID_FRAME)
        tinsert(UISpecialFrames, "WhatShouldIDoSettings")
        -- Apply saved UI scale
        local scale = WhatShouldIDoDB.uiScale or 1.0
        MainFrame:SetScale(scale)
        SettingsFrame:SetScale(scale)
    elseif event==WSID_PLAYER_LOGIN then
        if WhatShouldIDoDB then BuildRoster() end
    end
end)

SLASH_WSID1="/wsid"
SLASH_WSID2="/whatshouldido"
SlashCmdList["WSID"]=function(msg)
    msg=strtrim(msg)
    local msgL=msg:lower()
    if msgL=="WSID_Roster" then
        BuildRoster()
        print("|cffd5a742What Should I Do?:|r Roster refreshed -- "..#WSID_Roster.." character(s).")
        return
    end
    if msgL=="settings" then
        if SettingsFrame then
            if SettingsFrame:IsShown() then SettingsFrame:Hide() else SettingsFrame:Show() end
        end
        return
    end
    if MainFrame then
        if MainFrame:IsShown() then
            MainFrame:Hide()
            if SettingsFrame then SettingsFrame:Hide() end
        else BuildRoster()
            MainFrame:Show()
        end
    end
end

