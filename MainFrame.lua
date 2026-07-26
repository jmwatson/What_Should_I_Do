-- MainFrame.lua
-- Main window, left nav, minimap button, init, slash commands
-- Author: I_AM_T3X | v1.0.0

MainFrame = nil
MainPanels = {}
WSID_FRAME = "WhatShouldIDoFrame"

function BuildMainFrame()
    local f=CreateFrame(FRAME,WSID_FRAME,UIParent,BACKDROP_TEMPLATE)
    f:SetSize(WSID_WIN_W,WSID_WIN_H)
    f:SetPoint(CENTER)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag(LEFT_BUTTON)
    f:SetScript(ONDRAGSTART,f.StartMoving)
    f:SetScript(ONDRAGSTOP,f.StopMovingOrSizing)
    f:SetFrameStrata(DIALOG)
    f:SetBackdrop({bgFile=BG_FILE,edgeFile=BG_FILE,edgeSize=1})
    f:SetBackdropColor(C.bg[1],C.bg[2],C.bg[3],1)
    f:SetBackdropBorderColor(C.win_border[1],C.win_border[2],C.win_border[3],1)

    -- Title bar
    local tb=CreateFrame(FRAME,nil,f)
    tb:SetHeight(30)
    tb:SetPoint(TOPLEFT,f,TOPLEFT,0,0)
    tb:SetPoint(TOPRIGHT,f,TOPRIGHT,0,0)
    Tx(tb,C.sidebar[1],C.sidebar[2],C.sidebar[3])
    local tbb=tb:CreateTexture(nil,ARTWORK)
    tbb:SetColorTexture(C.divider[1],C.divider[2],C.divider[3],1)
    tbb:SetHeight(1)
    tbb:SetPoint(BOTTOMLEFT,tb,BOTTOMLEFT,0,0)
    tbb:SetPoint(BOTTOMRIGHT,tb,BOTTOMRIGHT,0,0)
    local titleLbl=tb:CreateFontString(nil,OVERLAY,NORMAL_LARGE)
    titleLbl:SetPoint(CENTER,tb,CENTER,0,0)
    titleLbl:SetText(WSID_STRING)
    titleLbl:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
    local closeBtn=CreateFrame(BUTTON,nil,f,UI_PANEL_CLOSE_BUTTON)
    closeBtn:SetPoint(TOPRIGHT,f,TOPRIGHT,-2,-2)
    closeBtn:SetFrameStrata(f:GetFrameStrata())
    closeBtn:SetFrameLevel(f:GetFrameLevel() + 1)
    closeBtn:SetScript(ONCLICK,function()
        f:Hide()
        if SettingsFrame then SettingsFrame:Hide() end
    end)

    -- Content area
    local contentArea=CreateFrame(FRAME,nil,f)
    contentArea:SetPoint(TOPLEFT,f,TOPLEFT,WSID_NAV_W,-30)
    contentArea:SetPoint(BOTTOMRIGHT,f,BOTTOMRIGHT,0,0)
    Tx(contentArea,C.bg[1]+0.005,C.bg[2]+0.005,C.bg[3]+0.01)

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
            {name="activity",label=ACTIVITY_LABEL},
            {name="creator",label=CREATOR_LABEL},
            {name=leveling_nav,label=LEVELING_LABEL},
            {name="names",label=NAMES_LABEL},
            {name="professions",label=PROFESSIONS_LABEL},
            {name="raidsdungeons",label=RAIDS_AND_DUNGEONS_LABEL}
        },
        {
            {name=settings_nav,label=SETTINGS_LABEL},
            {name="about",label=ABOUT_LABEL}
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
            if btn==LEFT_BUTTON then
                if MainFrame:IsShown() then
                    MainFrame:Hide()
                    if SettingsFrame then SettingsFrame:Hide() end
                else
                    BuildRoster()
                    MainFrame:Show()
                end
            elseif btn==RIGHT_BUTTON then
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

local initFrame=CreateFrame(FRAME)
initFrame:RegisterEvent(ADDON_LOADED)
initFrame:RegisterEvent(PLAYER_LOGIN)
initFrame:SetScript(ONEVENT,function(self,event,arg1)
    if event==ADDON_LOADED and arg1==WSID_ADDON_NAME then
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
    elseif event==PLAYER_LOGIN then
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

