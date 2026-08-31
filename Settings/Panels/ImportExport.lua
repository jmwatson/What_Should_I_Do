local _, addon = ...;
local DB = addon.DB;
local CT = addon.Runtime.COLOR_TABLE;

-- XOR encode/decode for opaque export strings
local XOR_KEY = 42;
local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

local function EncodeStr(str)
    -- XOR each byte then base64-encode
    local xored = {};
    for i = 1, #str do
        xored[i] = string.char(bit.bxor(str:byte(i), XOR_KEY));
    end
    local raw = table.concat(xored);
    -- simple base64
    local out = {};
    for i = 1, #raw, 3 do
        local a, b, c = raw:byte(i), raw:byte(i + 1) or 0, raw:byte(i + 2) or 0;
        local n = a * 65536 + b * 256 + c;
        out[#out + 1] = B64:sub(math.floor(n / 262144) % 64 + 1, math.floor(n / 262144) % 64 + 1);
        out[#out + 1] = B64:sub(math.floor(n / 4096) % 64 + 1, math.floor(n / 4096) % 64 + 1);
        out[#out + 1] = (raw:byte(i + 1) and B64:sub(math.floor(n / 64) % 64 + 1, math.floor(n / 64) % 64 + 1) or "=");
        out[#out + 1] = (raw:byte(i + 2) and B64:sub(n % 64 + 1, n % 64 + 1) or "=");
    end
    return "WX!" .. table.concat(out);
end

local function DecodeStr(enc)
    if enc:sub(1,3) ~= "WX!" then
        return nil;
    end

    local b64 = enc:sub(4);
    local map = {};

    for i = 1, #B64 do
        map[B64:sub(i, i)] = i - 1;
    end

    local raw = {};

    for i = 1, #b64, 4 do
        local a = map[b64:sub(i, i)] or 0;
        local b = map[b64:sub(i + 1, i + 1)] or 0;
        local c = map[b64:sub(i + 2, i + 2)];
        local d = map[b64:sub(i + 3, i + 3)];
        local n = a * 262144 + b * 4096 + (c or 0) * 64 + (d or 0);
        raw[#raw + 1] = string.char(math.floor(n / 65536) % 256);

        if c then
            raw[#raw + 1] = string.char(math.floor(n / 256) % 256);
        end

        if d then
            raw[#raw + 1] = string.char(n % 256);
        end
    end

    -- XOR decode
    local out = {};

    for _, ch in ipairs(raw) do
        out[#out + 1] = string.char(bit.bxor(ch:byte(1), XOR_KEY));
    end

    return table.concat(out);
end

-- Build Encode/Decode tables.
local CLASS_ENC = {};
local CLASS_DEC = {};
for _, c in ipairs(addon.CLASS_INFO) do
    CLASS_ENC[c.name] = c.short_name;
    CLASS_DEC[c.short_name] = c.name;
end

local RACE_ENC = {};
local RACE_DEC = {};
for _, r in ipairs(addon.RACE_INFO) do
    if r then
        RACE_ENC[r.name] = r.short_name;
        RACE_DEC[r.short_name] = r.name;
    end
end

local FACT_ENC = {[addon.ALLIANCE] = "Al", [addon.HORDE] = "Ho", [addon.NEUTRAL] = "Ne"};
local FACT_DEC = {Al = addon.ALLIANCE, Ho = addon.HORDE, Ne = addon.NEUTRAL};

local function BuildExportStr()
    local chars = DB and DB.seenChars;
    local excl = DB.excludedChars or {};
    local parts = {};

    if not chars or #chars == 0 then
        return nil;
    end

    for _, ch in ipairs(chars) do
        local cls  = addon.EncodeClass(ch.class) or (ch.class or "?");
        local race = addon.EncodeRace(ch.race) or (ch.race or "?");
        local fact = FACT_ENC[ch.faction] or (ch.faction or "?");
        table.insert(parts, (ch.name or "?")..":"..cls..":"..tostring(ch.level or 0)..":"..race..":"..fact..":".. (excl[ch.name] and "1" or "0"));
    end

    return "W2:" .. table.concat(parts, "|");
end

local ImportExportPanelMixin = {};

function ImportExportPanelMixin:DoImport(importStr)
    importStr = strtrim(importStr or addon.EMPTY_STRING);

    if importStr == addon.EMPTY_STRING then
        self.impStatus:SetText("Paste an export string first.");
        addon.ApplyColor(self.impStatus, "SetTextColor", {0.8, 0.3, 0.3});
        return;
    end

    -- Decode WX! encoded strings first
    if importStr:sub(1, 3) == "WX!" then
        local decoded = DecodeStr(importStr);

        if not decoded then
            self.impStatus:SetText("Failed to decode string.");
            addon.ApplyColor(self.impStatus, "SetTextColor", {0.8, 0.3, 0.3});
            return;
        end

        importStr = decoded;
    end

    local str, compressed;

    if importStr:sub(1, 3) == "W2:" then
        str = importStr:sub(4);
        compressed = true;
    elseif importStr:sub(1, 5) == "WSID:" then
        str = importStr:sub(6);
        compressed = false;
    else
        self.impStatus:SetText("Invalid string format.");
        addon.ApplyColor(self.impStatus, "SetTextColor", {0.8, 0.3, 0.3});
        return;
    end

    local imported, updated, excluded = 0, 0, 0;

    if not DB.excludedChars then
        DB.excludedChars = {};
    end

    for entry in str:gmatch("[^|]+") do
        local name,cls,level,race,faction,excl = entry:match("^([^:]+):([^:]+):([^:]+):([^:]+):([^:]+):?([01]?)$");

        if name and name ~= addon.EMPTY_STRING then
            if compressed then
                cls = addon.DecodeClass(cls) or addon.NormalizeClass(cls);
                race = RACE_DEC[race] or race;
                faction = FACT_DEC[faction] or faction;
            else
                cls = addon.NormalizeClass(cls);
            end

            local exists = false;

            for _, ch in ipairs(DB.seenChars) do
                if ch.name == name then
                    if tonumber(level) and tonumber(level) > (ch.level or 0) then
                        ch.level = tonumber(level);
                        updated = updated + 1;
                    end

                    exists = true;
                    break;
                end
            end

            if not exists then
                table.insert(DB.seenChars, {
                    name=name,
                    class=cls,
                    level=tonumber(level) or 0,
                    race=race,
                    faction=faction,
                });
                imported = imported + 1;
            end

            if excl == "1" then
                DB.excludedChars[name] = true;
                excluded = excluded + 1;
            end
        end
    end

    addon.BuildRoster();

    if DB.RefreshRoster then
        DB.RefreshRoster();
    end

    self.impBox:SetText(addon.EMPTY_STRING);
    addon.ApplyColor(self.impStatus, "SetTextColor", {0.3, 0.8, 0.3});
    self.impStatus:SetText(string.format("Done! %d added, %d levels updated, %d excluded.", imported, updated, excluded));
end

-- EXPORT section
function ImportExportPanelMixin:BuildExportPanel()
    self.expHdr = addon.MakeHeader(self, "Export Roster", addon.SET_CW);
    self.expHdr:SetPoint(addon.TOPLEFT, self.noteBG, addon.BOTTOMLEFT, -4, -10);

    self.expBoxBg = CreateFrame(addon.FRAME, nil, self, addon.BACKDROP_TEMPLATE);
    self.expBoxBg:SetSize(addon.SET_CW, 54);
    self.expBoxBg:SetPoint(addon.TOPLEFT, self.expHdr, addon.BOTTOMLEFT, 0, -6);
    self.expBoxBg:SetBackdrop({bgFile=addon.BG_FILE, edgeFile=addon.BG_FILE, edgeSize=1});
    self.expBoxBg:SetBackdropColor(0.06, 0.04, 0.10, 1);
    self.expBoxBg:SetBackdropBorderColor(0.25, 0.20, 0.35, 1);

    -- ScrollFrame inside self.expBoxBg so the multiline EditBox scrolls
    self.expScroll = CreateFrame("ScrollFrame", nil, self.expBoxBg, "UIPanelScrollFrameTemplate");
    self.expScroll:SetPoint(addon.TOPLEFT, self.expBoxBg, addon.TOPLEFT, 4, -4);
    self.expScroll:SetPoint(addon.BOTTOMRIGHT, self.expBoxBg, addon.BOTTOMRIGHT, -24, 4);

    self.expBox = CreateFrame(addon.EDIT_BOX, "WhatShouldIDoExportBox", self.expScroll, "InputBoxTemplate");
    self.expBox:SetWidth(self.expScroll:GetWidth() or (addon.SET_CW - 28));
    self.expBox:SetHeight(54);
    self.expBox:SetFontObject(GameFontNormalSmall);
    addon.ApplyColor(self.expBox, "SetTextColor", {0.85, 0.85, 0.85});
    self.expBox:SetMultiLine(true);
    self.expBox:SetAutoFocus(false);
    self.expBox:SetMaxLetters(0);
    self.expBox:SetText("-- click Export to generate --");
    self.expBox._last = addon.EMPTY_STRING;
    self.expScroll:SetScrollChild(self.expBox);

    -- Hide InputBoxTemplate border textures
    if self.expBox.Left then
        self.expBox.Left:SetAlpha(0);
    end

    if self.expBox.Middle then
        self.expBox.Middle:SetAlpha(0);
    end

    if self.expBox.Right then
        self.expBox.Right:SetAlpha(0);
    end

    -- Sync scroll when text changes
    self.expBox:SetScript(addon.OnTextChanged, function(_)
        self.expScroll:UpdateScrollChildRect();
    end);

    -- Block typing but allow select/copy
    self.expBox:SetScript(addon.OnChar, function(s)
        s:SetText(s._last or addon.EMPTY_STRING);
    end);
    self.expBox:SetScript(addon.OnEscapePressed, function(s)
        s:ClearFocus();
    end);
    self.expBox:SetScript(addon.OnEnterPressed, function(s)
        s:ClearFocus();
    end);
    self.expBox:SetScript(addon.OnEditFocusGained, function(s)
        s:HighlightText();
    end);

    self.expGenBtn = addon.MakeBtn(self, "Export", addon.SET_CW, 24);
    self.expGenBtn:SetPoint(addon.TOPLEFT, self.expBoxBg, addon.BOTTOMLEFT, 0, -4);

    self.expGenBtn:SetScript(addon.OnClick, function()
        local str = BuildExportStr();
        if not str then
            self.expBox._last = addon.EMPTY_STRING;
            self.expBox:SetText("No characters in roster.");
            return;
        end
        local encoded = EncodeStr(str);
        self.expBox._last = encoded;
        self.expBox:SetText(encoded);
        self.expBox:SetFocus();
    end);

    self.ioRule = self:CreateTexture(nil,addon.ARTWORK);
    addon.ApplyColor(self.ioRule, "SetColorTexture", CT.divider);
    self.ioRule:SetHeight(1);
    self.ioRule:SetPoint(addon.TOPLEFT,  self.expGenBtn, addon.BOTTOMLEFT,  0, -10);
    self.ioRule:SetPoint(addon.TOPRIGHT, self.expGenBtn, addon.BOTTOMRIGHT, 0, -10);
end

-- IMPORT
function ImportExportPanelMixin:BuildImportPanel()
    local panel = self;
    self.impHdr = addon.MakeHeader(self, "Import Roster", addon.SET_CW);
    self.impHdr:SetPoint(addon.TOPLEFT, self.ioRule, addon.BOTTOMLEFT, 0, -8);

    self.impBoxBg = CreateFrame(addon.FRAME, nil, self, addon.BACKDROP_TEMPLATE);
    self.impBoxBg:SetSize(addon.SET_CW, 26);
    self.impBoxBg:SetPoint(addon.TOPLEFT, self.impHdr, addon.BOTTOMLEFT, 0, -6);
    self.impBoxBg:SetBackdrop({bgFile=addon.BG_FILE,edgeFile=addon.BG_FILE,edgeSize=1});
    self.impBoxBg:SetBackdropColor(0.03,0.02,0.06,1);
    addon.ApplyColor(self.impBoxBg, "SetBackdropBorderColor", CT.divider);

    self.impBox = CreateFrame(addon.EDIT_BOX, "WhatShouldIDoImportBox", self.impBoxBg);
    self.impBox:SetPoint(addon.TOPLEFT, self.impBoxBg, addon.TOPLEFT, 6, -4);
    self.impBox:SetPoint(addon.BOTTOMRIGHT, self.impBoxBg, addon.BOTTOMRIGHT, -6, 4);
    self.impBox:SetFontObject(ChatFontNormal);
    addon.ApplyColor(self.impBox, "SetTextColor", addon.WHITE);
    self.impBox:SetAutoFocus(false);
    self.impBox:SetScript(addon.OnEscapePressed, function(s) s:ClearFocus(); end);
    self.impBox:SetScript(addon.OnEditFocusGained, function()
        addon.ApplyColor(self.impBoxBg, "SetBackdropBorderColor", CT.result_bdr);
    end);
    self.impBox:SetScript(addon.OnEditFocusLost, function()
        addon.ApplyColor(self.impBoxBg, "SetBackdropBorderColor", CT.divider);
    end);

    self.impBtn = addon.MakeBtn(self, "Import Roster", addon.SET_CW, 24);
    self.impBtn:SetPoint(addon.TOPLEFT, self.impBoxBg, addon.BOTTOMLEFT, 0, -4);

    self.impStatus = self:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    self.impStatus:SetPoint(addon.TOPLEFT, self.impBtn, addon.BOTTOMLEFT, 4, -6);
    addon.ApplyColor(self.impStatus, "SetTextColor", CT.dim_text);
    self.impStatus:SetText(" ");
    self.impStatus:SetWidth(addon.SET_CW);

    self.impBtn:SetScript(addon.OnClick, function()
        panel:DoImport(panel.impBox:GetText());
    end);
    self.impBox:SetScript(addon.OnEnterPressed, function(s)
        panel:DoImport(s:GetText());
        s:ClearFocus();
    end);
end

local function BuildImportExportPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    Mixin(panel, ImportExportPanelMixin);

    panel.noteBG = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.noteBG:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD);
    panel.noteBG:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.SET_PAD, 0);
    panel.noteBG:SetJustifyH(addon.LEFT);
    panel.noteBG:SetWordWrap(true);
    addon.ApplyColor(panel.noteBG, "SetTextColor", CT.dim_text);
    panel.noteBG:SetText("|cffd5a742For multi-account players:|r Export your roster on one account, then import it on another. This lets the Leveling wheel see characters from all your accounts in one place.");
    
    panel:BuildImportPanel();
    panel:BuildExportPanel();

    return panel;
end
addon.BuildImportExportPanel = BuildImportExportPanel;