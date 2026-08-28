local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

local BTN_H = 26;

local RosterPanelMixin = {};

function RosterPanelMixin:Refresh()
    self.rowPool:ReleaseAll();
    local characters = DB.seenChars;
    self.count:SetText("["..#characters.."]");

    if not DB.excludedChars then
        DB.excludedChars = {};
    end

    for i,ch in ipairs(characters) do
        local even = (i % 2 == 0);
        local row = self.rowPool:Acquire();
        local cc = addon.CLASS_INFO[ch.class] or {r = 0.8, g = 0.8, b = 0.8};
        local isExcluded = DB.excludedChars[ch.name] == true;
        local isCurrent = (ch.name == UnitName(addon.IDENTITY));

        if not row.bg then
            row.bg = row:CreateTexture(nil, addon.BACKGROUND);
            row.bg:SetAllPoints();
            row.fs = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
            row.fs:SetPoint(addon.LEFT, row, addon.LEFT, 10, 0);
            row.fs:SetJustifyH(addon.LEFT);
            row.btn = CreateFrame(addon.BUTTON, nil, row, addon.BACKDROP_TEMPLATE);
            row.btn:SetSize(58, 18);
            row.btn:SetBackdrop({bgFile = addon.BG_FILE, edgeFile = addon.BG_FILE, edgeSize = 1});
            row.btn._lbl = row.btn:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
            row.btn._lbl:SetAllPoints();
            row.btn._lbl:SetJustifyH(addon.CENTER);
            row.btn:SetScript(addon.OnClick, function()
                if DB.excludedChars[row._ch.name] then
                    DB.excludedChars[row._ch.name] = nil;
                else
                    DB.excludedChars[row._ch.name] = true;
                end
                DB.RefreshRoster();
            end);

            row.youLbl = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL)
            row.youLbl:SetPoint(addon.RIGHT, row.btn, addon.LEFT, -4, 0);
            addon.ApplyColor(row.youLbl, "SetTextColor", {0.30, 0.75, 0.30});
            row.youLbl:SetText("(you)");
            row.xbtn = CreateFrame(addon.BUTTON, nil, row);
            row.xbtn:SetSize(20, 24);
            row.xbtn:SetPoint(addon.RIGHT, row, addon.RIGHT, 0, 0);
            row.xbtn._lbl = row.xbtn:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
            row.xbtn._lbl:SetAllPoints();
            row.xbtn._lbl:SetJustifyH(addon.CENTER);
            row.xbtn._lbl:SetText("|cffcc3333x|r");
            row.xbtn:SetScript(addon.OnClick, function()
                addon.RemoveCharFromRoster(row._ch.name)
                DB.RefreshRoster();
            end);
            row.xbtn:SetScript(addon.OnEnter, function() row.xbtn._lbl:SetText("|cffff5555x|r"); end);
            row.xbtn:SetScript(addon.OnLeave, function() row.xbtn._lbl:SetText("|cffcc3333x|r"); end);
        end
        
        row._ch = ch;
        row:SetSize(addon.SET_CW - 2, 24);
        row:SetPoint(addon.TOPLEFT, self.content, addon.TOPLEFT, 0, -(i - 1) * 24);
        addon.ApplyColor(row.bg, "SetColorTexture", even and CT.row_even or CT.row_odd);

        row.fs:SetText(string.format("|cff%02x%02x%02x%s|r  |cffaaaaaa%s %s|r  |cffffcc00Lv %d|r%s",
            isExcluded and 80 or cc.r * 255,
            isExcluded and 80 or cc.g * 255,
            isExcluded and 80 or cc.b * 255,
            ch.name,
            ch.race or addon.EMPTY_STRING,
            ch.class or addon.EMPTY_STRING,
            ch.level or 0,
            isExcluded and "  |cff888888[excluded]|r" or addon.EMPTY_STRING));
        row.btn:ClearAllPoints();
        row.btn:SetPoint(addon.RIGHT, row, addon.RIGHT, isCurrent and -4 or -26, 0);
        addon.ApplyColor(row.btn, "SetBackdropColor", isExcluded and {0.25, 0.08, 0.08} or {0.08, 0.18, 0.08});
        addon.ApplyColor(row.btn, "SetBackdropBorderColor", isExcluded and {0.6, 0.2, 0.2} or {0.3, 0.3, 0.3});
        row.btn._lbl:SetText(isExcluded and "|cffff6666Excluded|r" or "|cff888888Exclude|r");

        if isCurrent then
            row.youLbl:Show();
            row.xbtn:Hide();
        else
            row.youLbl:Hide();
            row.xbtn:Show();
        end
    end

    self:SetHeight(math.max(24, #characters * 24 + 2));
    self.reset();
end

function RosterPanelMixin:ClearOthers()
    local cur = UnitName(addon.IDENTITY);
    local kept = {};

    for _, ch in ipairs(DB.seenChars) do
        if ch.name == cur then
            table.insert(kept, ch);
        end
    end

    DB.seenChars=kept;
    addon.BuildRoster();
    self:Refresh();
    print("|cffd5a742What Should I Do?:|r Roster cleared.");
end

local function BuildRosterPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    Mixin(panel, RosterPanelMixin);

    panel.header = addon.MakeHeader(panel, "Seen Characters", addon.SET_CW);
    panel.header:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD);
    panel.count = panel:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    panel.count:SetPoint(addon.RIGHT, panel.header, addon.RIGHT, -6, 0);
    addon.ApplyColor(panel.count, "SetTextColor", CT.dim_text);
    panel.note = panel:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    panel.note:SetPoint(addon.TOPLEFT, panel.header, addon.BOTTOMLEFT, 4, -6);
    addon.ApplyColor(panel.note, "SetTextColor", CT.dim_text);
    panel.note:SetText("Log into each alt to add it. Levels update on every login.");
    panel.note:SetWidth(addon.SET_CW);
    panel.scrollBG, panel.content, panel.reset = addon.MakeScrollBox(panel, addon.SET_CW, addon.SET_H - 30 - addon.SET_PAD * 2 - 80);
    panel.scrollBG:SetPoint(addon.TOPLEFT, panel.note, addon.BOTTOMLEFT, 0, -8);
    panel.clearBtn = addon.MakeBtn(panel, "Clear All Others", addon.SET_CW, BTN_H);
    panel.clearBtn:SetPoint(addon.TOPLEFT, panel.scrollBG, addon.BOTTOMLEFT, 0, -10);

    panel.rowPool = CreateFramePool(addon.FRAME,  contentArea);

    panel.clearBtn:SetScript(addon.OnClick, function()
        panel:ClearOthers();
    end);

    DB.RefreshRoster = function()
        panel:Refresh();
    end

    return panel;
end
addon.BuildRosterPanel = BuildRosterPanel;