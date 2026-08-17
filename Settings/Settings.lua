local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

DB.SettingsFrame = nil;
DB.RefreshActivities = nil;
DB.RefreshRoster = nil;
DB.RefreshActivities = nil;
DB.RefreshRoster = nil;

local navActive = nil;
local navBtns = {};
local PANELS = {};

-----------------
--- Callbacks ---
-----------------

local function SetNavActive(name)
    local function _SetNavActive()
        navActive = name;
        for key,button in pairs(navBtns) do
            if key == name then
                button.bg:SetColorTexture(CT.nav_active[1],CT.nav_active[2],CT.nav_active[3],1);
                button.stripe:Show();
                button.lbl:SetTextColor(1,1,1);
            else
                button.bg:SetColorTexture(0,0,0,0);
                button.stripe:Hide();
                button.lbl:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
            end
        end
        for key, panel in pairs(PANELS) do
            if key == name then
                panel:Show();
            else
                panel:Hide();
            end
        end
        if name == "activities" and DB.RefreshActivities then
            DB.RefreshActivities();
        end
        if name == "roster" and DB.RefreshRoster then
            DB.RefreshRoster();
        end
    end
    return _SetNavActive;
end

local function ConditionalOnEnter(name, bg, lbl)
    local function _ConditionalOnEnter()
        if navActive~=name then
            bg:SetColorTexture(CT.nav_hover[1],CT.nav_hover[2],CT.nav_hover[3],1);
            lbl:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);
        end
    end
    return _ConditionalOnEnter;
end

local function ConditionalOnLeave(name, bg, lbl)
    local function _ConditionalOnLeave()
        if navActive~=name then
            bg:SetColorTexture(0,0,0,0);
            lbl:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
        end
    end
    return _ConditionalOnLeave;
end

local function OnEnter(bg, lbl)
    local function _OnEnter()
        bg:SetColorTexture(CT.nav_hover[1],CT.nav_hover[2],CT.nav_hover[3],1);
        lbl:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);
    end
    return _OnEnter;
end

local function OnLeave(bg, lbl)
    local function _OnLeave()
        bg:SetColorTexture(0,0,0,0);
        lbl:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
    end
    return _OnLeave;
end

local function ResetSize()
    DB.uiScale = 1.0;
    DB.uiScale = 1.0;
    if DB.MainFrame then
        DB.MainFrame:SetScale(1.0);
    end
    if DB.SettingsFrame then
        DB.SettingsFrame:SetScale(1.0);
    end
    UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r UI scale reset to 100%%.", 1, 0.85, 0.2);
end

----------------
--- Builders ---
----------------

local function BuildMainFrame(parent)
    local frame = CreateFrame(addon.FRAME, "WhatShouldIDoSettings", parent, addon.BACKDROP_TEMPLATE);
    frame:SetSize(addon.SET_W, addon.SET_H);
    frame:SetPoint(addon.CENTER, parent, addon.CENTER, 280, 0);
    frame:SetMovable(true);
    frame:EnableMouse(true);
    frame:RegisterForDrag(addon.LEFT_BUTTON);
    frame:SetScript(addon.OnDragStart, frame.StartMoving);
    frame:SetScript(addon.OnDragStop, frame.StopMovingOrSizing);
    frame:SetFrameStrata(addon.DIALOG);
    frame:SetFrameLevel(20);
    frame:SetBackdrop({bgFile=addon.BG_FILE, edgeFile=addon.BG_FILE, edgeSize=1});
    frame:SetBackdropColor(CT.bg[1], CT.bg[2], CT.bg[3], 1);
    frame:SetBackdropBorderColor(CT.win_border[1], CT.win_border[2], CT.win_border[3], 1);
    frame:Hide();

    return frame;
end

local function BuildTitleBar(parent)
    local frame = CreateFrame(addon.FRAME, nil, parent);
    frame:SetHeight(30);
    frame:SetPoint(addon.TOPLEFT, parent, addon.TOPLEFT, 0, 0);
    frame:SetPoint(addon.TOPRIGHT, parent, addon.TOPRIGHT, 0, 0);
    addon.Tx(frame, CT.sidebar[1], CT.sidebar[2], CT.sidebar[3]);

    local border=frame:CreateTexture(nil, addon.ARTWORK);
    border:SetColorTexture(CT.divider[1], CT.divider[2], CT.divider[3], 1);
    border:SetHeight(1);
    border:SetPoint(addon.BOTTOMLEFT, frame, addon.BOTTOMLEFT, 0, 0);
    border:SetPoint(addon.BOTTOMRIGHT, frame, addon.BOTTOMRIGHT, 0, 0);

    local label=frame:CreateFontString(nil, addon.OVERLAY, addon.NORMAL);
    label:SetPoint(addon.LEFT, frame, addon.LEFT, 10, 0);
    label:SetText("What Should I Do?  --  Settings");
    label:SetTextColor(CT.header_txt[1], CT.header_txt[2], CT.header_txt[3]);

    local closeBtn=CreateFrame(addon.BUTTON, nil, parent, addon.UI_PANEL_CLOSE_BUTTON);
    closeBtn:SetPoint(addon.TOPRIGHT, parent, addon.TOPRIGHT, -2, -2);
    closeBtn:SetFrameStrata(parent:GetFrameStrata());
    closeBtn:SetFrameLevel(parent:GetFrameLevel() + 1);

    return frame;
end

local function BuildLeftNav(parent)
    local frame = CreateFrame(addon.FRAME, nil, parent);
    frame:SetPoint(addon.TOPLEFT, parent, addon.TOPLEFT, 0, -30);
    frame:SetPoint(addon.BOTTOMLEFT, parent, addon.BOTTOMLEFT, 0, 0);
    frame:SetWidth(addon.SET_NAV);
    addon.Tx(frame, CT.sidebar[1], CT.sidebar[2], CT.sidebar[3]);

    local texture = frame:CreateTexture(nil, addon.ARTWORK);
    texture:SetColorTexture(CT.divider[1], CT.divider[2], CT.divider[3], 1);
    texture:SetWidth(1);
    texture:SetPoint(addon.TOPRIGHT, frame, addon.TOPRIGHT, 0, 0);
    texture:SetPoint(addon.BOTTOMRIGHT, frame, addon.BOTTOMRIGHT, 0, 0);

    return frame;
end

local function BuildPanel(parent)
    local frame = CreateFrame(addon.FRAME, nil, parent);
    frame:SetAllPoints(parent);
    frame:Hide();

    return frame;
end

local function BuildNavButton(parent, i, def)
    local row = CreateFrame(addon.BUTTON, nil, parent);
    row:SetSize(addon.SET_NAV, 36);
    row:SetPoint(addon.TOPLEFT, parent, addon.TOPLEFT, 0, -(i-1)*36);

    local background = row:CreateTexture(nil, addon.BACKGROUND);
    background:SetAllPoints();
    background:SetColorTexture(0, 0, 0, 0);

    local stripe = row:CreateTexture(nil, addon.ARTWORK);
    stripe:SetColorTexture(CT.nav_border[1], CT.nav_border[2], CT.nav_border[3], 1);
    stripe:SetSize(3, 36);
    stripe:SetPoint(addon.LEFT, row, addon.LEFT, 0, 0);
    stripe:Hide();

    local label = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    label:SetPoint(addon.LEFT, row, addon.LEFT, 12, 0);
    label:SetText(def.label);
    label:SetTextColor(CT.dim_text[1], CT.dim_text[2], CT.dim_text[3]);

    local name = def.name;
    row:SetScript(addon.OnClick, SetNavActive(name));
    row:SetScript(addon.OnEnter, ConditionalOnEnter(name,  background,  label));
    row:SetScript(addon.OnLeave, ConditionalOnLeave(name,  background,  label));

    navBtns[def.name] = {bg = background, stripe = stripe, lbl = label};
end

local function BuildChangeListButton(parent)
    local frame = CreateFrame(addon.BUTTON, nil, parent);
    frame:SetSize(addon.SET_NAV, 36);
    frame:SetPoint(addon.BOTTOMLEFT, parent, addon.BOTTOMLEFT, 0, 36);

    local background = frame:CreateTexture(nil, addon.BACKGROUND);
    background:SetAllPoints();
    background:SetColorTexture(0, 0, 0, 0);

    local artwork = frame:CreateTexture(nil, addon.ARTWORK);
    artwork:SetColorTexture(CT.nav_border[1], CT.nav_border[2], CT.nav_border[3], 1);
    artwork:SetSize(3, 36);
    artwork:SetPoint(addon.LEFT, frame, addon.LEFT, 0, 0);
    artwork:Hide();

    local label = frame:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    label:SetPoint(addon.LEFT, frame, addon.LEFT, 12, 0);
    label:SetText("Changelog");
    label:SetTextColor(CT.dim_text[1], CT.dim_text[2], CT.dim_text[3]);

    frame:SetScript(addon.OnClick, SetNavActive("changelog"));
    frame:SetScript(addon.OnEnter, ConditionalOnEnter("changelog", background, label));
    frame:SetScript(addon.OnLeave, ConditionalOnLeave("changelog", background, label));

    navBtns["changelog"] = {bg=background, stripe=artwork, lbl=label};

    return frame;
end

local function BuildSeperator(parent, y_offset)
    local rule = parent:CreateTexture(nil, addon.ARTWORK);
    rule:SetColorTexture(CT.divider[1], CT.divider[2], CT.divider[3], 1);
    rule:SetHeight(1);
    rule:SetPoint(addon.BOTTOMLEFT, parent, addon.BOTTOMLEFT, 0, y_offset);
    rule:SetPoint(addon.BOTTOMRIGHT, parent, addon.BOTTOMRIGHT, 0, y_offset);
end

local function BuildResetSizeButton(parent)
    local frame = CreateFrame(addon.BUTTON, nil, parent);
    frame:SetSize(addon.SET_NAV, 36);
    frame:SetPoint(addon.BOTTOMLEFT, parent, addon.BOTTOMLEFT, 0, 0);

    local background = frame:CreateTexture(nil,addon.BACKGROUND);
    background:SetAllPoints();
    background:SetColorTexture(0, 0, 0, 0);

    local label = frame:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    label:SetPoint(addon.LEFT, frame, addon.LEFT, 12, 0);
    label:SetText("Reset Size");
    label:SetTextColor(CT.dim_text[1], CT.dim_text[2], CT.dim_text[3]);

    frame:SetScript(addon.OnEnter, OnEnter(background, label));
    frame:SetScript(addon.OnLeave, OnLeave(background, label));
    frame:SetScript(addon.OnClick, ResetSize);
end

local function BuildActivitiesPanel(activitiesPanel, BTN_H, SCRL_H, GAP)
    -- Left column: Categories
    local activitiesHeader = addon.MakeHeader(activitiesPanel, "Categories", addon.SET_COL);
    local activitiesCount=activitiesPanel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    local activitiesBG,catContent,catReset=addon.MakeScrollBox(activitiesPanel,addon.SET_COL,SCRL_H);
    local resetBtn=addon.MakeBtn(activitiesPanel,"Reset All Defaults",addon.SET_COL,BTN_H);
    -- Right column: Sub-Activities
    local subHeader=addon.MakeHeader(activitiesPanel,"Sub-Activities",addon.SET_COL);
    local subCount=activitiesPanel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    local subSelectLabel=activitiesPanel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    -- Sub scroll must align vertically with cat scroll despite the extra label line
    local subBG,subContent,subReset=addon.MakeScrollBox(activitiesPanel,addon.SET_COL,SCRL_H);
    -- State
    local selectedActivity=nil;
    local activitiesRows={};
    local subRows={};

    activitiesHeader:SetPoint(addon.TOPLEFT, activitiesPanel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD);
    activitiesCount:SetPoint(addon.RIGHT,activitiesHeader,addon.RIGHT,-6,0);
    activitiesCount:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
    activitiesBG:SetPoint(addon.TOPLEFT,activitiesHeader,addon.BOTTOMLEFT,0,-4);
    resetBtn:SetPoint(addon.TOPLEFT,activitiesBG,addon.BOTTOMLEFT,0,-GAP);
    subHeader:SetPoint(addon.TOPLEFT,activitiesHeader,addon.TOPRIGHT,12,0);
    subCount:SetPoint(addon.RIGHT,subHeader,addon.RIGHT,-6,0);
    subCount:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
    subSelectLabel:SetPoint(addon.TOPLEFT,subHeader,addon.BOTTOMLEFT,4,-4);
    subSelectLabel:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
    subSelectLabel:SetText("(click a category to edit its sub-activities)");
    subSelectLabel:SetWidth(addon.SET_COL);
    subBG:SetPoint(addon.TOPLEFT,subHeader,addon.BOTTOMLEFT,0,-28);

    local function PaintCheckbox(box, check, lbl, checked)
        if checked then
            box:SetBackdropColor(CT.result_bg[1],CT.result_bg[2],CT.result_bg[3],1);
            box:SetBackdropBorderColor(CT.nav_border[1],CT.nav_border[2],CT.nav_border[3],1);
            check:SetVertexColor(CT.nav_border[1],CT.nav_border[2],CT.nav_border[3],1);
            check:Show();
            lbl:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);
        else
            box:SetBackdropColor(0.05,0.03,0.08,1);
            box:SetBackdropBorderColor(CT.divider[1],CT.divider[2],CT.divider[3],1);
            check:Hide();
            lbl:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
        end
    end

    local function MakeCheckboxRow(parent, i, name)
        local even=(i%2==0);
        local row=CreateFrame(addon.BUTTON,nil,parent,addon.BACKDROP_TEMPLATE);
        local re,rg,rb = even and CT.row_even[1] or CT.row_odd[1], even and CT.row_even[2] or CT.row_odd[2], even and CT.row_even[3] or CT.row_odd[3];
        local box=CreateFrame(addon.FRAME,nil,row,addon.BACKDROP_TEMPLATE);
        local check=box:CreateTexture(nil,addon.OVERLAY);
        local lbl=row:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);

        row:SetSize(addon.SET_COL-2,22);
        row:SetPoint(addon.TOPLEFT,parent,addon.TOPLEFT,0,-(i-1)*22);
        row:SetBackdrop({bgFile=addon.BG_FILE});
        row:SetBackdropColor(re,rg,rb,1);
        box:SetSize(14,14);
        box:SetPoint(addon.LEFT,row,addon.LEFT,6,0);
        box:SetBackdrop({bgFile=addon.BG_FILE,edgeFile=addon.BG_FILE,edgeSize=1});
        check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check");
        check:SetSize(16,16);
        check:SetPoint(addon.CENTER,box,addon.CENTER,0,0);
        lbl:SetPoint(addon.LEFT,box,addon.RIGHT,6,0);
        lbl:SetJustifyH(addon.LEFT);
        lbl:SetText(name);
        lbl:SetWidth(addon.SET_COL-32);

        row._even=even;
        return row, box, check, lbl, re, rg, rb;
    end

    local function RefreshSubList()
        for _,r in ipairs(subRows) do
            r:Hide();
        end
        subRows={};
        if not selectedActivity then
            subCount:SetText(addon.EMPTY_STRING);
            subContent:SetHeight(22);
            subReset();
            return;
        end
        if not DB.excludedSubActivities then
            DB.excludedSubActivities = {};
        end
        local subs = addon.GetAllSubActivities(selectedActivity);
        subCount:SetText("["..#subs.."]");
        for i,sub in ipairs(subs) do
            local row, box, check, lbl = MakeCheckboxRow(subContent, i, sub);
            local subName=sub;
            local checked = not DB.excludedSubActivities[subName];
            PaintCheckbox(box, check, lbl, checked);

            row:SetScript(addon.OnClick,function()
                checked = not checked;
                DB.excludedSubActivities[subName] = checked and nil or true;
                PaintCheckbox(box, check, lbl, checked);
            end);
            row:SetScript(addon.OnEnter,function()
                row:SetBackdropColor(CT.row_hover[1],CT.row_hover[2],CT.row_hover[3],1);
            end);
            row:SetScript(addon.OnLeave,function()
                local re,rg,rb = row._even and CT.row_even[1] or CT.row_odd[1], row._even and CT.row_even[2] or CT.row_odd[2], row._even and CT.row_even[3] or CT.row_odd[3];
                row:SetBackdropColor(re,rg,rb,1);
            end);

            table.insert(subRows,row);
        end
        subContent:SetHeight(math.max(22,#subs*22+2));
        subReset();
    end

    local function SelectCat(name)
        selectedActivity=name
        for _,r in ipairs(activitiesRows) do
            if r._name==name then
                r:SetBackdropColor(CT.row_select[1],CT.row_select[2],CT.row_select[3],1)
            else
                local re,rg,rb = r._even and CT.row_even[1] or CT.row_odd[1], r._even and CT.row_even[2] or CT.row_odd[2], r._even and CT.row_even[3] or CT.row_odd[3]
                r:SetBackdropColor(re,rg,rb,1)
            end
        end
        subSelectLabel:SetTextColor(CT.spin_text[1],CT.spin_text[2],CT.spin_text[3])
        subSelectLabel:SetText(name)
        RefreshSubList()
    end

    local function RefreshActivities()
        for _,r in ipairs(activitiesRows) do r:Hide() end
        activitiesRows={}
        if not DB.excludedActivities then DB.excludedActivities = {} end
        local acts = addon.GetAllActivities()
        activitiesCount:SetText("["..#acts.."]")
        for i,act in ipairs(acts) do
            local row, box, check, lbl, re, rg, rb = MakeCheckboxRow(catContent, i, act)
            local actName=act
            row._name=actName
            local checked = not DB.excludedActivities[actName]
            PaintCheckbox(box, check, lbl, checked)

            row:SetScript(addon.OnClick,function()
                checked = not checked
                DB.excludedActivities[actName] = checked and nil or true
                PaintCheckbox(box, check, lbl, checked)
                SelectCat(actName)
            end)
            row:SetScript(addon.OnEnter,function() if selectedActivity~=actName then row:SetBackdropColor(CT.row_hover[1],CT.row_hover[2],CT.row_hover[3],1) end end)
            row:SetScript(addon.OnLeave,function() if selectedActivity~=actName then row:SetBackdropColor(re,rg,rb,1) end end)

            table.insert(activitiesRows,row)
        end
        catContent:SetHeight(math.max(22,#acts*22+2))
        catReset()
    end
    DB.RefreshActivities = RefreshActivities;

    resetBtn:SetScript(addon.OnClick,function()
        addon.ResetActivities()
        addon.ResetSubActivities()
        selectedActivity=nil
        subSelectLabel:SetText("(click a category to edit its sub-activities)")
        subSelectLabel:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
        DB.RefreshActivities()
        RefreshSubList()
    end)
end

local function BuildSettingsWindow()
    local SCRL_H = 280  -- scroll list height
    local BTN_H  = 26
    local GAP    = 10

    local mainFrame = BuildMainFrame(UIParent);

    BuildTitleBar(mainFrame);

    -- Left nav
    local navBg = BuildLeftNav(mainFrame);

    local content = CreateFrame(addon.FRAME, nil, mainFrame);
    content:SetPoint(addon.TOPLEFT, mainFrame, addon.TOPLEFT, addon.SET_NAV, -30);
    content:SetPoint(addon.BOTTOMRIGHT, mainFrame, addon.BOTTOMRIGHT, 0, 0);

    local activitiesPanel = BuildPanel(content);
    local rosterPanel = BuildPanel(content);
    local importExportPanel = BuildPanel(content);
    local colorsPanel = BuildPanel(content);
    local scalePanel = BuildPanel(content);
    local expansionsPanel = BuildPanel(content);
    local changelogPanel = BuildPanel(content);

    PANELS.activities = activitiesPanel;
    PANELS.roster = rosterPanel;
    PANELS.importexport = importExportPanel;
    PANELS.expansions = expansionsPanel;
    PANELS.colors = colorsPanel;
    PANELS.uiscale = scalePanel;
    PANELS.changelog = changelogPanel;

    local panelStrings = {
        {name="activities",label="Activities"},
        {name="roster",label="Roster"},
        {name="importexport",label="Import/Export"},
        {name="expansions",label="Expansions"},
        {name="colors",label="Colors"},
        {name="uiscale",label="UI Scale"}
    };

    for i,def in ipairs(panelStrings) do
        BuildNavButton(navBg, i, def);
    end
    BuildChangeListButton(navBg);
    BuildSeperator(navBg, 72);
    BuildResetSizeButton(navBg);

    --------------------------------------------------------------------
    -- ACTIVITIES PANEL: two columns
    --------------------------------------------------------------------

    BuildActivitiesPanel(activitiesPanel, BTN_H, SCRL_H, GAP);

    --------------------------------------------------------------------
    -- ROSTER PANEL
    --------------------------------------------------------------------

    local rostHdr=addon.MakeHeader(rosterPanel,"Seen Characters",addon.SET_CW)
    rostHdr:SetPoint(addon.TOPLEFT,rosterPanel,addon.TOPLEFT,addon.SET_PAD,-addon.SET_PAD)
    local rostCount=rosterPanel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    rostCount:SetPoint(addon.RIGHT,rostHdr,addon.RIGHT,-6,0)
    rostCount:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
    local rostNote=rosterPanel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    rostNote:SetPoint(addon.TOPLEFT,rostHdr,addon.BOTTOMLEFT,4,-6)
    rostNote:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
    rostNote:SetText("Log into each alt to add it. Levels update on every login.")
    rostNote:SetWidth(addon.SET_CW)

    local rostBG,rostContent,rostReset=addon.MakeScrollBox(rosterPanel,addon.SET_CW,addon.SET_H-30-addon.SET_PAD*2-80)
    rostBG:SetPoint(addon.TOPLEFT,rostNote,addon.BOTTOMLEFT,0,-8)

    local rostRows={}
    DB.RefreshRoster=function()
        for _,r in ipairs(rostRows) do r:Hide() end
        rostRows={}
        local chars=DB.seenChars
        rostCount:SetText("["..#chars.."]")
        if not DB.excludedChars then DB.excludedChars = {} end
        for i,ch in ipairs(chars) do
            local even=(i%2==0)
            local row=CreateFrame(addon.FRAME,nil,rostContent)
            row:SetSize(addon.SET_CW-2,24)
            row:SetPoint(addon.TOPLEFT,rostContent,addon.TOPLEFT,0,-(i-1)*24)
            local rb=row:CreateTexture(nil,addon.BACKGROUND)
            rb:SetAllPoints()
            rb:SetColorTexture(even and CT.row_even[1] or CT.row_odd[1],even and CT.row_even[2] or CT.row_odd[2],even and CT.row_even[3] or CT.row_odd[3],1)
            local cc=addon.CLASS_INFO[ch.class] or {r=0.8,g=0.8,b=0.8}
            local isExcluded = DB.excludedChars[ch.name] == true
            local fs=row:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
            fs:SetPoint(addon.LEFT,row,addon.LEFT,10,0)
            fs:SetJustifyH(addon.LEFT)
            fs:SetText(string.format("|cff%02x%02x%02x%s|r  |cffaaaaaa%s %s|r  |cffffcc00Lv %d|r%s",
                isExcluded and 80 or cc.r*255,
                isExcluded and 80 or cc.g*255,
                isExcluded and 80 or cc.b*255,
                ch.name, ch.race or addon.EMPTY_STRING, ch.class or addon.EMPTY_STRING, ch.level or 0,
                isExcluded and "  |cff888888[excluded]|r" or addon.EMPTY_STRING))
            local isCurrent=(ch.name==UnitName(addon.IDENTITY))
            -- Exclude toggle button (all chars including current)
            local exBtn=CreateFrame(addon.BUTTON,nil,row,addon.BACKDROP_TEMPLATE)
            exBtn:SetSize(58,18)
            exBtn:SetPoint(addon.RIGHT,row,addon.RIGHT, isCurrent and -4 or -26, 0)
            exBtn:SetBackdrop({bgFile=addon.BG_FILE,edgeFile=addon.BG_FILE,edgeSize=1})
            local function UpdateExBtn()
                local ex = DB.excludedChars[ch.name] == true
                exBtn:SetBackdropColor(ex and 0.25 or 0.08, ex and 0.08 or 0.18, ex and 0.08 or 0.08)
                exBtn:SetBackdropBorderColor(ex and 0.6 or 0.3, ex and 0.2 or 0.3, ex and 0.2 or 0.3, 1)
                local exL = exBtn._lbl
                if exL then exL:SetText(ex and "|cffff6666Excluded|r" or "|cff888888Exclude|r") end
            end
            local exL=exBtn:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
            exL:SetAllPoints()
            exL:SetJustifyH(addon.CENTER)
            exBtn._lbl = exL
            UpdateExBtn()
            local cn=ch.name
            exBtn:SetScript(addon.OnClick,function()
                if DB.excludedChars[cn] then
                    DB.excludedChars[cn] = nil
                else
                    DB.excludedChars[cn] = true
                end
                DB.RefreshRoster()
            end)
            if isCurrent then
                local yl=row:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
                yl:SetPoint(addon.RIGHT,exBtn,addon.LEFT,-4,0)
                yl:SetTextColor(0.30,0.75,0.30)
                yl:SetText("(you)")
            else
                local xBtn=CreateFrame(addon.BUTTON,nil,row)
                xBtn:SetSize(20,24)
                xBtn:SetPoint(addon.RIGHT,row,addon.RIGHT,0,0)
                local xL2=xBtn:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
                xL2:SetAllPoints()
                xL2:SetJustifyH(addon.CENTER)
                xL2:SetText("|cffcc3333x|r")
                xBtn:SetScript(addon.OnClick,function()
                    addon.RemoveCharFromRoster(cn)
                    DB.RefreshRoster()
                end)
                xBtn:SetScript(addon.OnEnter,function() xL2:SetText("|cffff5555x|r") end)
                xBtn:SetScript(addon.OnLeave,function() xL2:SetText("|cffcc3333x|r") end)
            end
            table.insert(rostRows,row)
        end
        rostContent:SetHeight(math.max(24,#chars*24+2))
        rostReset()
    end

    local clearBtn=addon.MakeBtn(rosterPanel,"Clear All Others",addon.SET_CW,BTN_H)
    clearBtn:SetPoint(addon.TOPLEFT,rostBG,addon.BOTTOMLEFT,0,-10)
    clearBtn:SetScript(addon.OnClick,function()
        local cur=UnitName(addon.IDENTITY)
        local kept={}
        for _,ch in ipairs(DB.seenChars) do
            if ch.name==cur then table.insert(kept,ch) end
        end
        DB.seenChars=kept
        addon.BuildRoster()
        DB.RefreshRoster()
        print("|cffd5a742What Should I Do?:|r Roster cleared.")
    end)

    --------------------------------------------------------------------
    -- IMPORT / EXPORT PANEL
    --------------------------------------------------------------------

    local ioNoteBg = importExportPanel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    ioNoteBg:SetPoint(addon.TOPLEFT, importExportPanel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD)
    ioNoteBg:SetPoint(addon.RIGHT,   importExportPanel, addon.RIGHT,  -addon.SET_PAD, 0)
    ioNoteBg:SetJustifyH(addon.LEFT)
    ioNoteBg:SetWordWrap(true)
    ioNoteBg:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
    ioNoteBg:SetText("|cffd5a742For multi-account players:|r Export your roster on one account, then import it on another. This lets the Leveling wheel see characters from all your accounts in one place.")

    -- Encode tables (no collisions between CLASS/RACE/FACT within same field)
    local CLASS_ENC = {}
    local CLASS_DEC = {}
    for _, c in ipairs(addon.CLASS_INFO) do
        CLASS_ENC[c.name] = c.short_name
        CLASS_DEC[c.short_name] = c.name
    end

    local RACE_ENC = {}
    local RACE_DEC = {}
    for _, r in ipairs(addon.RACE_INFO) do
        if r then
            RACE_ENC[r.name] = r.short_name
            RACE_DEC[r.short_name] = r.name
        end
    end

    local FACT_ENC = {[addon.ALLIANCE]="Al",[addon.HORDE]="Ho",[addon.NEUTRAL]="Ne"}
    local FACT_DEC = {Al=addon.ALLIANCE,Ho=addon.HORDE,Ne=addon.NEUTRAL}

    local function BuildExportStr()
        local chars = DB and DB.seenChars
        if not chars or #chars == 0 then return nil end
        local excl = DB.excludedChars or {}
        local parts = {}
        for _, ch in ipairs(chars) do
            local cls  = addon.EncodeClass(ch.class)  or (ch.class   or "?")
            local race = addon.EncodeRace(ch.race)    or (ch.race    or "?")
            local fact = FACT_ENC[ch.faction] or (ch.faction or "?")
            table.insert(parts, (ch.name or "?")..":"..cls..":"..tostring(ch.level or 0)..":"..race..":"..fact..":".. (excl[ch.name] and "1" or "0"))
        end
        return "W2:" .. table.concat(parts, "|")
    end

    -- EXPORT section
    local expHdr = addon.MakeHeader(importExportPanel, "Export Roster", addon.SET_CW)
    expHdr:SetPoint(addon.TOPLEFT, ioNoteBg, addon.BOTTOMLEFT, -4, -10)

    local expBoxBg = CreateFrame(addon.FRAME, nil, importExportPanel, addon.BACKDROP_TEMPLATE)
    expBoxBg:SetSize(addon.SET_CW, 54)
    expBoxBg:SetPoint(addon.TOPLEFT, expHdr, addon.BOTTOMLEFT, 0, -6)
    expBoxBg:SetBackdrop({bgFile=addon.BG_FILE,edgeFile=addon.BG_FILE,edgeSize=1})
    expBoxBg:SetBackdropColor(0.06,0.04,0.10,1)
    expBoxBg:SetBackdropBorderColor(0.25,0.20,0.35,1)

    -- XOR encode/decode for opaque export strings
    local XOR_KEY = 42
    local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local function EncodeStr(str)
        -- XOR each byte then base64-encode
        local xored = {}
        for i = 1, #str do
            xored[i] = string.char(bit.bxor(str:byte(i), XOR_KEY))
        end
        local raw = table.concat(xored)
        -- simple base64
        local out = {}
        for i = 1, #raw, 3 do
            local a, b, c = raw:byte(i), raw:byte(i+1) or 0, raw:byte(i+2) or 0
            local n = a*65536 + b*256 + c
            out[#out+1] = B64:sub(math.floor(n/262144)%64+1,math.floor(n/262144)%64+1)
            out[#out+1] = B64:sub(math.floor(n/4096)%64+1,math.floor(n/4096)%64+1)
            out[#out+1] = (raw:byte(i+1) and B64:sub(math.floor(n/64)%64+1,math.floor(n/64)%64+1) or "=")
            out[#out+1] = (raw:byte(i+2) and B64:sub(n%64+1,n%64+1) or "=")
        end
        return "WX!" .. table.concat(out)
    end
    local function DecodeStr(enc)
        if enc:sub(1,3) ~= "WX!" then return nil end
        local b64 = enc:sub(4)
        local map = {}
        for i = 1, #B64 do map[B64:sub(i,i)] = i-1 end
        local raw = {}
        for i = 1, #b64, 4 do
            local a = map[b64:sub(i,i)] or 0
            local b = map[b64:sub(i+1,i+1)] or 0
            local c = map[b64:sub(i+2,i+2)]
            local d = map[b64:sub(i+3,i+3)]
            local n = a*262144 + b*4096 + (c or 0)*64 + (d or 0)
            raw[#raw+1] = string.char(math.floor(n/65536) % 256)
            if c then raw[#raw+1] = string.char(math.floor(n/256) % 256) end
            if d then raw[#raw+1] = string.char(n % 256) end
        end
        -- XOR decode
        local out = {}
        for _, ch in ipairs(raw) do
            out[#out+1] = string.char(bit.bxor(ch:byte(1), XOR_KEY))
        end
        return table.concat(out)
    end

    -- ScrollFrame inside expBoxBg so the multiline EditBox scrolls
    local expScroll = CreateFrame("ScrollFrame", nil, expBoxBg, "UIPanelScrollFrameTemplate")
    expScroll:SetPoint(addon.TOPLEFT,     expBoxBg, addon.TOPLEFT,     4,  -4)
    expScroll:SetPoint(addon.BOTTOMRIGHT, expBoxBg, addon.BOTTOMRIGHT, -24,  4)

    local expBox = CreateFrame(addon.EDIT_BOX, "WhatShouldIDoExportBox", expScroll, "InputBoxTemplate")
    expBox:SetWidth(expScroll:GetWidth() or (addon.SET_CW - 28))
    expBox:SetHeight(54)
    expBox:SetFontObject(GameFontNormalSmall)
    expBox:SetTextColor(0.85, 0.85, 0.85)
    expBox:SetMultiLine(true)
    expBox:SetAutoFocus(false)
    expBox:SetMaxLetters(0)
    expBox:SetText("-- click Export to generate --")
    expBox._last = addon.EMPTY_STRING
    expScroll:SetScrollChild(expBox)
    -- Hide InputBoxTemplate border textures
    if expBox.Left   then expBox.Left:SetAlpha(0) end
    if expBox.Middle then expBox.Middle:SetAlpha(0) end
    if expBox.Right  then expBox.Right:SetAlpha(0) end
    -- Sync scroll when text changes
    expBox:SetScript(addon.OnTextChanged, function(self)
        expScroll:UpdateScrollChildRect()
    end)
    -- Block typing but allow select/copy
    expBox:SetScript(addon.OnChar,            function(s) s:SetText(s._last or addon.EMPTY_STRING) end)
    expBox:SetScript(addon.OnEscapePressed,   function(s) s:ClearFocus() end)
    expBox:SetScript(addon.OnEnterPressed,    function(s) s:ClearFocus() end)
    expBox:SetScript(addon.OnEditFocusGained, function(s) s:HighlightText() end)

    local expGenBtn = addon.MakeBtn(importExportPanel, "Export", addon.SET_CW, 24)
    expGenBtn:SetPoint(addon.TOPLEFT, expBoxBg, addon.BOTTOMLEFT, 0, -4)

    expGenBtn:SetScript(addon.OnClick, function()
        local str = BuildExportStr()
        if not str then
            expBox._last = addon.EMPTY_STRING
            expBox:SetText("No characters in roster.")
            return
        end
        local encoded = EncodeStr(str)
        expBox._last = encoded
        expBox:SetText(encoded)
        expBox:SetFocus()
    end)

    local ioRule = importExportPanel:CreateTexture(nil,addon.ARTWORK)
    ioRule:SetColorTexture(CT.divider[1],CT.divider[2],CT.divider[3],1)
    ioRule:SetHeight(1)
    ioRule:SetPoint(addon.TOPLEFT,  expGenBtn, addon.BOTTOMLEFT,  0, -10)
    ioRule:SetPoint(addon.TOPRIGHT, expGenBtn, addon.BOTTOMRIGHT, 0, -10)

    -- IMPORT
    local impHdr = addon.MakeHeader(importExportPanel, "Import Roster", addon.SET_CW)
    impHdr:SetPoint(addon.TOPLEFT, ioRule, addon.BOTTOMLEFT, 0, -8)

    local impBoxBg = CreateFrame(addon.FRAME, nil, importExportPanel, addon.BACKDROP_TEMPLATE)
    impBoxBg:SetSize(addon.SET_CW, 26)
    impBoxBg:SetPoint(addon.TOPLEFT, impHdr, addon.BOTTOMLEFT, 0, -6)
    impBoxBg:SetBackdrop({bgFile=addon.BG_FILE,edgeFile=addon.BG_FILE,edgeSize=1})
    impBoxBg:SetBackdropColor(0.03,0.02,0.06,1)
    impBoxBg:SetBackdropBorderColor(CT.divider[1],CT.divider[2],CT.divider[3],1)

    local impBox = CreateFrame(addon.EDIT_BOX, "WhatShouldIDoImportBox", impBoxBg)
    impBox:SetPoint(addon.TOPLEFT,     impBoxBg, addon.TOPLEFT,     6, -4)
    impBox:SetPoint(addon.BOTTOMRIGHT, impBoxBg, addon.BOTTOMRIGHT, -6,  4)
    impBox:SetFontObject(ChatFontNormal)
    impBox:SetTextColor(1, 1, 1)
    impBox:SetAutoFocus(false)
    impBox:SetScript(addon.OnEscapePressed, function(s) s:ClearFocus() end)
    impBox:SetScript(addon.OnEditFocusGained, function()
        impBoxBg:SetBackdropBorderColor(CT.result_bdr[1],CT.result_bdr[2],CT.result_bdr[3],1)
    end)
    impBox:SetScript(addon.OnEditFocusLost, function()
        impBoxBg:SetBackdropBorderColor(CT.divider[1],CT.divider[2],CT.divider[3],1)
    end)

    local impBtn = addon.MakeBtn(importExportPanel, "Import Roster", addon.SET_CW, 24)
    impBtn:SetPoint(addon.TOPLEFT, impBoxBg, addon.BOTTOMLEFT, 0, -4)

    local impStatus = importExportPanel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    impStatus:SetPoint(addon.TOPLEFT, impBtn, addon.BOTTOMLEFT, 4, -6)
    impStatus:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
    impStatus:SetText(" ")
    impStatus:SetWidth(addon.SET_CW)

    WSID_DoImport = function(importStr)
        importStr = strtrim(importStr or addon.EMPTY_STRING)
        if importStr == addon.EMPTY_STRING then
            impStatus:SetText("Paste an export string first.")
            impStatus:SetTextColor(0.8,0.3,0.3)
            return
        end
        -- Decode WX! encoded strings first
        if importStr:sub(1,3) == "WX!" then
            local decoded = DecodeStr(importStr)
            if not decoded then
                impStatus:SetText("Failed to decode string.")
                impStatus:SetTextColor(0.8,0.3,0.3)
                return
            end
            importStr = decoded
        end
        local str, compressed
        if importStr:sub(1,3) == "W2:" then
            str = importStr:sub(4)
            compressed = true
        elseif importStr:sub(1,5) == "WSID:" then
            str = importStr:sub(6)
            compressed = false
        else
            impStatus:SetText("Invalid string format.")
            impStatus:SetTextColor(0.8,0.3,0.3)
            return
        end
        local imported, updated, excluded = 0, 0, 0
        if not DB.excludedChars then DB.excludedChars = {} end
        for entry in str:gmatch("[^|]+") do
            local name,cls,level,race,faction,excl = entry:match("^([^:]+):([^:]+):([^:]+):([^:]+):([^:]+):?([01]?)$")
            if name and name ~= addon.EMPTY_STRING then
                if compressed then
                    cls     = addon.DecodeClass(cls) or addon.NormalizeClass(cls)
                    race    = RACE_DEC[race]    or race
                    faction = FACT_DEC[faction] or faction
                else
                    cls = addon.NormalizeClass(cls)
                end
                local exists = false
                for _, ch in ipairs(DB.seenChars) do
                    if ch.name == name then
                        if tonumber(level) and tonumber(level) > (ch.level or 0) then
                            ch.level = tonumber(level)
                            updated = updated + 1
                        end
                        exists = true
                        break
                    end
                end
                if not exists then
                    table.insert(DB.seenChars, {
                        name=name, class=cls, level=tonumber(level) or 0, race=race, faction=faction,
                    })
                    imported = imported + 1
                end
                if excl == "1" then
                    DB.excludedChars[name] = true
                    excluded = excluded + 1
                end
            end
        end
        addon.BuildRoster()
        if DB.RefreshRoster then DB.RefreshRoster() end
        impBox:SetText(addon.EMPTY_STRING)
        impStatus:SetTextColor(0.3,0.8,0.3)
        impStatus:SetText(string.format("Done! %d added, %d levels updated, %d excluded.", imported, updated, excluded))
    end

    impBtn:SetScript(addon.OnClick, function()
        WSID_DoImport(impBox:GetText())
    end)
    impBox:SetScript(addon.OnEnterPressed, function(s)
        WSID_DoImport(s:GetText())
        s:ClearFocus()
    end)

    --------------------------------------------------------------------
    -- COLORS PANEL
    --------------------------------------------------------------------

    local colScrollBG, colScrollContent, _ = addon.MakeScrollBox(colorsPanel, addon.SET_CW, addon.SET_H - 30 - addon.SET_PAD * 2)
    colScrollBG:SetPoint(addon.TOPLEFT, colorsPanel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD)

    -- COLOR THEME
    local colHdr = addon.MakeHeader(colScrollContent, "Color Theme", addon.SET_CW - 4)
    colHdr:SetPoint(addon.TOPLEFT, colScrollContent, addon.TOPLEFT, 0, -4)

    local colDesc = colScrollContent:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    colDesc:SetPoint(addon.TOPLEFT, colHdr, addon.BOTTOMLEFT, 4, -6)
    colDesc:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
    colDesc:SetText("Select a theme. A UI reload is required to fully apply the new colors.")
    colDesc:SetWidth(addon.SET_CW - 8)

    local themeSep = colScrollContent:CreateTexture(nil,addon.ARTWORK)
    themeSep:SetColorTexture(CT.divider[1],CT.divider[2],CT.divider[3],1)
    themeSep:SetHeight(1)
    themeSep:SetPoint(addon.TOPLEFT,  colDesc, addon.BOTTOMLEFT,  0, -10)
    themeSep:SetPoint(addon.TOPRIGHT, colDesc, addon.BOTTOMRIGHT, 0, -10)

    local themeHdr = colScrollContent:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    themeHdr:SetPoint(addon.TOPLEFT, themeSep, addon.BOTTOMLEFT, 0, -8)
    themeHdr:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
    themeHdr:SetText("Preset Themes:")

    -- Confirm popup helper
    local function ConfirmAndReload(themeName, displayName, onConfirm)
        StaticPopupDialogs["WSID_CONFIRM_THEME"] = {
            text = "Apply the "..displayName.." theme?\n\nThe UI will reload to apply the new colors.",
            button1 = "Yes, Apply",
            button2 = "Cancel",
            OnAccept = function()
                if onConfirm then onConfirm() end
                DB.colorTheme = themeName
                ReloadUI()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
        }
        StaticPopup_Show("WSID_CONFIRM_THEME")
    end

    local THEME_DEFS = {
        {name=addon.DEFAULT_THEME,      label=addon.DEFAULT_THEME,      desc="The original purple theme."},
        {name=addon.DEUTERANOPIA, label=addon.DEUTERANOPIA, desc="Red-green colorblind. Blue/cyan accents."},
        {name=addon.PROTANOPIA,   label=addon.PROTANOPIA,   desc="Red blind. Deep blue accents."},
        {name=addon.TRITANOPIA,   label=addon.TRITANOPIA,   desc="Blue-yellow blind. Orange/amber accents."},
        {name=addon.HIGHCONTRAST, label="High Contrast",desc="Black background with yellow accents."},
    }

    local themeBtns = {}
    local function UpdateThemeBtns()
        local cur = DB.colorTheme or addon.DEFAULT_THEME
        for _, tb in ipairs(themeBtns) do
            if tb._theme == cur then
                tb:SetBackdropColor(CT.nav_active[1],CT.nav_active[2],CT.nav_active[3])
                tb:SetBackdropBorderColor(CT.nav_border[1],CT.nav_border[2],CT.nav_border[3],1)
                tb._lbl:SetTextColor(1,1,1)
            else
                tb:SetBackdropColor(CT.btn_bg[1],CT.btn_bg[2],CT.btn_bg[3])
                tb:SetBackdropBorderColor(CT.btn_bdr[1],CT.btn_bdr[2],CT.btn_bdr[3],1)
                tb._lbl:SetTextColor(CT.btn_text[1],CT.btn_text[2],CT.btn_text[3])
            end
        end
    end

    local prevRow = themeHdr
    for _, td in ipairs(THEME_DEFS) do
        local row = CreateFrame(addon.FRAME, nil, colScrollContent)
        row:SetSize(addon.SET_CW - 4, 28)
        row:SetPoint(addon.TOPLEFT, prevRow, addon.BOTTOMLEFT, 0, -6)

        local btn = addon.MakeBtn(row, td.label, 140, 26)
        btn:SetPoint(addon.TOPLEFT, row, addon.TOPLEFT, 0, 0)
        local tname = td.name
        local tlabel = td.label
        btn._theme = tname
        btn:SetScript(addon.OnClick, function()
            ConfirmAndReload(tname, tlabel)
        end)
        table.insert(themeBtns, btn)

        local dlbl = row:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
        dlbl:SetPoint(addon.LEFT, btn, addon.RIGHT, 10, 0)
        dlbl:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
        dlbl:SetText(td.desc)
        prevRow = row
    end

    UpdateThemeBtns()

    -- Custom section
    local customSep = colScrollContent:CreateTexture(nil,addon.ARTWORK)
    customSep:SetColorTexture(CT.divider[1],CT.divider[2],CT.divider[3],1)
    customSep:SetHeight(1)
    customSep:SetPoint(addon.TOPLEFT,  prevRow, addon.BOTTOMLEFT,  0, -12)
    customSep:SetPoint(addon.TOPRIGHT, prevRow, addon.BOTTOMRIGHT, 0, -12)

    local customHdr = colScrollContent:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    customHdr:SetPoint(addon.TOPLEFT, customSep, addon.BOTTOMLEFT, 0, -8)
    customHdr:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
    customHdr:SetText("Custom Colors -- click Edit to pick a color. Hit Apply when done.")

    local CUSTOM_KEYS = {
        {key="nav_border",  label="Accent / Border"},
        {key="btn_bdr",     label="Button Border"},
        {key="header_txt",  label="Header Text"},
        {key="spin_text",   label="Spin Result Text"},
        {key="bright_text", label="Bright Text"},
        {key="bg",          label="Background"},
    }

    local swatchRefs = {}  -- track swatches so we can update them after color pick

    local function OpenColorPicker(key, swatch)
        -- Auto-select Custom theme when editing colors
        DB.colorTheme = addon.CUSTOM_THEME
        UpdateThemeBtns()
        if not DB.customColors then DB.customColors = {} end
        -- Seed all keys from current C table if not yet set
        for k,v in pairs(CT) do
            if not DB.customColors[k] then
                DB.customColors[k] = {v[1],v[2],v[3]}
            end
        end
        local cur = DB.customColors[key] or CT[key]
        local info = {}
        info.r, info.g, info.b = cur[1], cur[2], cur[3]
        info.hasOpacity = false
        info.swatchFunc = function()
            local r,g,b = ColorPickerFrame:GetColorRGB()
            DB.customColors[key] = {r,g,b}
            -- Update the swatch preview
            if swatch then swatch:SetBackdropColor(r,g,b,1) end
        end
        info.cancelFunc = function(prev)
            DB.customColors[key] = {prev.r,prev.g,prev.b}
            if swatch then swatch:SetBackdropColor(prev.r,prev.g,prev.b,1) end
        end
        ColorPickerFrame:SetupColorPickerAndShow(info)
    end

    local prevCustom = customHdr
    for _, ck in ipairs(CUSTOM_KEYS) do
        local row = CreateFrame(addon.FRAME, nil, colScrollContent)
        row:SetSize(addon.SET_CW - 4, 26)
        row:SetPoint(addon.TOPLEFT, prevCustom, addon.BOTTOMLEFT, 0, -6)

        local swatch = CreateFrame(addon.BUTTON, nil, row, addon.BACKDROP_TEMPLATE)
        swatch:SetSize(22, 22)
        swatch:SetPoint(addon.TOPLEFT, row, addon.TOPLEFT, 0, -2)
        swatch:SetBackdrop({bgFile=addon.BG_FILE,edgeFile=addon.BG_FILE,edgeSize=1})
        local cv = CT[ck.key]
        swatch:SetBackdropColor(cv[1],cv[2],cv[3],1)
        swatch:SetBackdropBorderColor(0.4,0.4,0.4,1)
        table.insert(swatchRefs, {swatch=swatch, key=ck.key})

        local rlbl = row:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
        rlbl:SetPoint(addon.LEFT, swatch, addon.RIGHT, 8, 0)
        rlbl:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3])
        rlbl:SetText(ck.label)

        local editBtn = addon.MakeBtn(row, "Edit", 50, 22)
        editBtn:SetPoint(addon.LEFT, rlbl, addon.RIGHT, 10, 0)
        local k = ck.key
        editBtn:SetScript(addon.OnClick, function() OpenColorPicker(k, swatch) end)

        prevCustom = row
    end

    -- Apply Custom button with confirmation
    local applyCustomBtn = addon.MakeBtn(colScrollContent, "Apply Custom Theme", 220, 30)
    applyCustomBtn:SetPoint(addon.TOPLEFT, prevCustom, addon.BOTTOMLEFT, 0, -12)
    applyCustomBtn:SetScript(addon.OnClick, function()
        StaticPopupDialogs["WSID_CONFIRM_addon.CUSTOM_THEME"] = {
            text = "Apply your custom color theme?\n\nThe UI will reload to apply the new colors.",
            button1 = "Yes, Apply",
            button2 = "Cancel",
            OnAccept = function()
                DB.colorTheme = addon.CUSTOM_THEME
                -- Write custom colors into C so they survive the reload via DB
                if DB.customColors then
                    addon.ApplyTheme(addon.CUSTOM_THEME, DB.customColors)
                end
                ReloadUI()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
        }
        StaticPopup_Show("WSID_CONFIRM_addon.CUSTOM_THEME")
    end)

    -- Set scroll content height
    colScrollContent:SetHeight(680)

    --------------------------------------------------------------------
    -- EXPANSIONS PANEL
    --------------------------------------------------------------------

    local expExclHdr = addon.MakeHeader(expansionsPanel, "Raid & Dungeon Expansions", addon.SET_CW)
    expExclHdr:SetPoint(addon.TOPLEFT, expansionsPanel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD)

    local expExclDesc = expansionsPanel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    expExclDesc:SetPoint(addon.TOPLEFT, expExclHdr, addon.BOTTOMLEFT, 4, -6)
    expExclDesc:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
    expExclDesc:SetText("Uncheck an expansion to exclude it from the Raids & Dungeons spinner.")
    expExclDesc:SetWidth(addon.SET_CW - 8)

    local expExclScrollBG, expExclContent, _ = addon.MakeScrollBox(expansionsPanel, addon.SET_CW, addon.SET_H - 160)
    expExclScrollBG:SetPoint(addon.TOPLEFT, expExclDesc, addon.BOTTOMLEFT, -4, -8)

    local ORDER = addon.EXPANSIONS

    local ROW_H = 28

    local COL_W = math.floor(addon.SET_CW / 2) - 2

    local function MakeExpRow(i, exp)
        local col = (i-1) % 2        -- 0 = left, 1 = right
        local rowIdx = math.floor((i-1) / 2)
        local even = (rowIdx%2==0)
        local row = CreateFrame(addon.BUTTON, nil, expExclContent, addon.BACKDROP_TEMPLATE)
        row:SetSize(COL_W, ROW_H)
        row:SetPoint(addon.TOPLEFT, expExclContent, addon.TOPLEFT, col*(COL_W+4), -rowIdx*ROW_H)
        row:SetBackdrop({bgFile=addon.BG_FILE})
        row:SetBackdropColor(even and CT.row_even[1] or CT.row_odd[1],
                             even and CT.row_even[2] or CT.row_odd[2],
                             even and CT.row_even[3] or CT.row_odd[3], 1)

        -- Custom checkbox box
        local box = CreateFrame(addon.FRAME, nil, row, addon.BACKDROP_TEMPLATE)
        box:SetSize(14, 14)
        box:SetPoint(addon.LEFT, row, addon.LEFT, 10, 0)
        box:SetBackdrop({bgFile=addon.BG_FILE,edgeFile=addon.BG_FILE,edgeSize=1})

        -- Checkmark texture
        local check = box:CreateTexture(nil, addon.OVERLAY)
        check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
        check:SetSize(16, 16)
        check:SetPoint(addon.CENTER, box, addon.CENTER, 0, 0)

        -- Label
        local lbl = row:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
        lbl:SetPoint(addon.LEFT, box, addon.RIGHT, 8, 0)

        local expName = exp
        local checked = not (DB.excludedExpansions and DB.excludedExpansions[expName])

        local function SetState(isChecked)
            checked = isChecked
            -- Use C table if populated, else hardcoded defaults
            local ac1,ac2,ac3   = CT.accent     and CT.accent[1]      or 0.84, CT.accent     and CT.accent[2]      or 0.67, CT.accent     and CT.accent[3]      or 0.20
            local rb1,rb2,rb3   = CT.result_bg  and CT.result_bg[1]   or 0.06, CT.result_bg  and CT.result_bg[2]   or 0.04, CT.result_bg  and CT.result_bg[3]   or 0.10
            local di1,di2,di3   = CT.divider    and CT.divider[1]     or 0.25, CT.divider    and CT.divider[2]     or 0.20, CT.divider    and CT.divider[3]     or 0.35
            local br1,br2,br3   = CT.bright_text and CT.bright_text[1] or 1.00, CT.bright_text and CT.bright_text[2] or 0.90, CT.bright_text and CT.bright_text[3] or 0.40
            local dm1,dm2,dm3   = CT.dim_text   and CT.dim_text[1]    or 0.50, CT.dim_text   and CT.dim_text[2]    or 0.45, CT.dim_text   and CT.dim_text[3]    or 0.55
            if isChecked then
                box:SetBackdropColor(rb1,rb2,rb3,1)
                box:SetBackdropBorderColor(ac1,ac2,ac3,1)
                check:SetVertexColor(ac1,ac2,ac3,1)
                check:Show()
                lbl:SetTextColor(br1,br2,br3)
            else
                box:SetBackdropColor(0.05,0.03,0.08,1)
                box:SetBackdropBorderColor(di1,di2,di3,1)
                check:Hide()
                lbl:SetTextColor(dm1,dm2,dm3)
            end
        end

        lbl:SetText(expName)
        SetState(checked)

        row:SetScript(addon.OnClick, function()
            if not DB.excludedExpansions then DB.excludedExpansions = {} end
            checked = not checked
            if checked then
                DB.excludedExpansions[expName] = nil
            else
                DB.excludedExpansions[expName] = true
            end
            SetState(checked)
        end)
        row:SetScript(addon.OnEnter, function()
            row:SetBackdropColor(CT.row_hover[1],CT.row_hover[2],CT.row_hover[3],1)
        end)
        local re,rg,rb = even and CT.row_even[1] or CT.row_odd[1], even and CT.row_even[2] or CT.row_odd[2], even and CT.row_even[3] or CT.row_odd[3]
        row:SetBackdropColor(re,rg,rb,1)
        row:SetScript(addon.OnLeave, function() row:SetBackdropColor(re,rg,rb,1) end)

        return row, SetState
    end

    local expRows = {}
    for i, exp in ipairs(ORDER) do
        local row, setState = MakeExpRow(i, exp)
        expRows[exp] = setState
    end
    expExclContent:SetHeight(math.ceil(#ORDER / 2) * ROW_H)

    -- Enable All / Disable All buttons
    local expEnableAllBtn = addon.MakeBtn(expansionsPanel, "Enable All", math.floor(addon.SET_CW/2) - 3, 24)
    expEnableAllBtn:SetPoint(addon.BOTTOMLEFT, expansionsPanel, addon.BOTTOMLEFT, addon.SET_PAD, addon.SET_PAD)
    expEnableAllBtn:SetScript(addon.OnClick, function()
        if DB.excludedExpansions then wipe(DB.excludedExpansions) end
        for _, setState in pairs(expRows) do setState(true) end
    end)

    local expDisableAllBtn = addon.MakeBtn(expansionsPanel, "Disable All", math.floor(addon.SET_CW/2) - 3, 24)
    expDisableAllBtn:SetPoint(addon.BOTTOMRIGHT, expansionsPanel, addon.BOTTOMRIGHT, -addon.SET_PAD, addon.SET_PAD)
    expDisableAllBtn:SetScript(addon.OnClick, function()
        if not DB.excludedExpansions then DB.excludedExpansions = {} end
        for _, exp in ipairs(ORDER) do
            DB.excludedExpansions[exp] = true
            if expRows[exp] then expRows[exp](false) end
        end
    end)

    --------------------------------------------------------------------
    -- UI SCALE PANEL
    --------------------------------------------------------------------

    local scaleHdr = addon.MakeHeader(scalePanel, "UI Scale", addon.SET_CW)
    scaleHdr:SetPoint(addon.TOPLEFT, scalePanel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD)

    local scaleDesc = scalePanel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    scaleDesc:SetPoint(addon.TOPLEFT, scaleHdr, addon.BOTTOMLEFT, 4, -8)
    scaleDesc:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
    scaleDesc:SetText("Scale the addon windows and all text. Changes apply instantly.")
    scaleDesc:SetWidth(addon.SET_CW - 8)

    local scaleOptions = {
        {label="50%",  val=0.50}, {label="60%",  val=0.60}, {label="70%",  val=0.70},
        {label="80%",  val=0.80}, {label="90%",  val=0.90}, {label="100%", val=1.00},
        {label="110%", val=1.10}, {label="120%", val=1.20}, {label="130%", val=1.30},
        {label="140%", val=1.40}, {label="150%", val=1.50}, {label="160%", val=1.60},
        {label="170%", val=1.70}, {label="180%", val=1.80}, {label="190%", val=1.90},
        {label="200%", val=2.00},
    }

    local scaleLbl = scalePanel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    scaleLbl:SetPoint(addon.TOPLEFT, scaleDesc, addon.BOTTOMLEFT, 0, -12)
    scaleLbl:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
    scaleLbl:SetText("Scale:")

    local scaleBox = CreateFrame(addon.BUTTON, nil, scalePanel, addon.BACKDROP_TEMPLATE)
    scaleBox:SetSize(100, 26)
    scaleBox:SetPoint(addon.LEFT, scaleLbl, addon.RIGHT, 8, 0)
    addon.BgBorder(scaleBox, CT.result_bg[1],CT.result_bg[2],CT.result_bg[3], CT.result_bdr[1],CT.result_bdr[2],CT.result_bdr[3])
    local scaleBoxLbl = scaleBox:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    scaleBoxLbl:SetPoint(addon.LEFT, scaleBox, addon.LEFT, 8, 0)
    scaleBoxLbl:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3])
    local curScale = DB.uiScale or 1.0
    scaleBoxLbl:SetText(string.format("%.0f%%", curScale * 100))

    local scaleDropdown = CreateFrame(addon.FRAME, nil, scalePanel, addon.BACKDROP_TEMPLATE)
    scaleDropdown:SetSize(100, #scaleOptions * 22)
    scaleDropdown:SetPoint(addon.TOPLEFT, scaleBox, addon.BOTTOMLEFT, 0, -2)
    scaleDropdown:SetFrameStrata("TOOLTIP")
    addon.BgBorder(scaleDropdown, CT.bg[1],CT.bg[2],CT.bg[3], CT.win_border[1],CT.win_border[2],CT.win_border[3])
    scaleDropdown:Hide()

    local function ApplyScale(val, label)
        DB.uiScale = val
        scaleBoxLbl:SetText(label)
        scaleDropdown:Hide()
        if DB.MainFrame     then DB.MainFrame:SetScale(val) end
        if DB.SettingsFrame then DB.SettingsFrame:SetScale(val) end
    end

    for i, opt in ipairs(scaleOptions) do
        local row = CreateFrame(addon.BUTTON, nil, scaleDropdown)
        row:SetSize(100, 22)
        row:SetPoint(addon.TOPLEFT, scaleDropdown, addon.TOPLEFT, 0, -(i-1)*22)
        local rb = row:CreateTexture(nil,addon.BACKGROUND)
        rb:SetAllPoints()
        local isEven = (i%2==0)
        rb:SetColorTexture(isEven and CT.row_even[1] or CT.row_odd[1],
                           isEven and CT.row_even[2] or CT.row_odd[2],
                           isEven and CT.row_even[3] or CT.row_odd[3], 1)
        local rl = row:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
        rl:SetPoint(addon.LEFT, row, addon.LEFT, 10, 0)
        if opt.val == 1.0 then
            rl:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3])
        else
            rl:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
        end
        rl:SetText(opt.label)
        local ov, ol = opt.val, opt.label
        row:SetScript(addon.OnClick,  function() ApplyScale(ov, ol) end)
        row:SetScript(addon.OnEnter, function() rb:SetColorTexture(CT.row_hover[1],CT.row_hover[2],CT.row_hover[3],1) end)
        row:SetScript(addon.OnLeave, function()
            rb:SetColorTexture(isEven and CT.row_even[1] or CT.row_odd[1],
                               isEven and CT.row_even[2] or CT.row_odd[2],
                               isEven and CT.row_even[3] or CT.row_odd[3], 1)
        end)
    end

    scaleBox:SetScript(addon.OnClick, function()
        if scaleDropdown:IsShown() then scaleDropdown:Hide() else scaleDropdown:Show() end
    end)

    local scaleResetBtn = addon.MakeBtn(scalePanel, "Reset to 100%", 120, 26)
    scaleResetBtn:SetPoint(addon.TOPLEFT, scaleLbl, addon.BOTTOMLEFT, 0, -14)
    scaleResetBtn:SetScript(addon.OnClick, function()
        ApplyScale(1.0, "100%")
    end)

    --------------------------------------------------------------------
    -- CHANGELOG PANEL
    --------------------------------------------------------------------

    local clScrollBG, clScrollContent, _ = addon.MakeScrollBox(changelogPanel, addon.SET_CW, addon.SET_H - 50)
    clScrollBG:SetPoint(addon.TOPLEFT, changelogPanel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD)

    local yOff = -6
    for _, block in ipairs(addon.CHANGELOG) do
        -- Version header
        local vHdr = addon.MakeHeader(clScrollContent, "v"..block.version, addon.SET_CW - 4)
        vHdr:SetPoint(addon.TOPLEFT, clScrollContent, addon.TOPLEFT, 0, yOff)
        yOff = yOff - 34

        for _, entry in ipairs(block.entries) do
            local isNew = entry.type == "new"
            -- Tag label
            local tag = clScrollContent:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
            tag:SetPoint(addon.TOPLEFT, clScrollContent, addon.TOPLEFT, 8, yOff)
            tag:SetText(isNew and "|cff44cc44[New]|r" or "|cffcc4444[Fix]|r")

            -- Entry text
            local txt = clScrollContent:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
            txt:SetPoint(addon.TOPLEFT, clScrollContent, addon.TOPLEFT, 52, yOff)
            txt:SetPoint(addon.RIGHT,   clScrollContent, addon.RIGHT,  -8, 0)
            txt:SetJustifyH(addon.LEFT)
            txt:SetWordWrap(true)
            txt:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
            txt:SetText(entry.text)

            -- Measure wrapped height (approx 14px per line, min 18)
            local lineCount = math.max(1, math.ceil(#entry.text / 72))
            yOff = yOff - (lineCount * 14) - 6
        end

        yOff = yOff - 10  -- gap between versions
    end

    clScrollContent:SetHeight(math.abs(yOff) + 20)

    mainFrame:SetScript(addon.OnShow, SetNavActive("activities"))
    SetNavActive("activities")
    return mainFrame
end
addon.BuildSettingsWindow = BuildSettingsWindow;
