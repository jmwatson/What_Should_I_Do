local _, addon = ...;
local DB = addon.DB;
local RT = addon.Runtime;

local minimapBtn;

local function UpdateMinimapButtonPosition()
    if not minimapBtn then
        return;
    end

    local angle = math.rad(DB.minimap.minimapPos or 45);
    local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND";
    local w = (Minimap:GetWidth() or 140) / 2;
    local h = (Minimap:GetHeight() or 140) / 2;
    local x, y = math.cos(angle) * w, math.sin(angle) * h;

    local quadrant;
    if x >= 0 and y >= 0 then
        quadrant = "TOPRIGHT";
    elseif x >= 0 and y < 0 then
        quadrant = "BOTTOMRIGHT";
    elseif x < 0 and y >= 0 then
        quadrant = "TOPLEFT";
    else
        quadrant = "BOTTOMLEFT";
    end

    local squareShapes = {
        SQUARE = {"TOPLEFT","TOPRIGHT","BOTTOMLEFT","BOTTOMRIGHT"},
        CORNER_TOPLEFT = {"TOPLEFT"},
        CORNER_TOPRIGHT = {"TOPRIGHT"},
        CORNER_BOTTOMLEFT = {"BOTTOMLEFT"},
        CORNER_BOTTOMRIGHT = {"BOTTOMRIGHT"},
        SIDE_LEFT = {"TOPLEFT","BOTTOMLEFT"},
        SIDE_RIGHT = {"TOPRIGHT","BOTTOMRIGHT"},
        SIDE_TOP = {"TOPLEFT","TOPRIGHT"},
        SIDE_BOTTOM = {"BOTTOMLEFT","BOTTOMRIGHT"},
        TRICORNER_TOPLEFT = {"TOPLEFT","TOPRIGHT","BOTTOMLEFT"},
        TRICORNER_TOPRIGHT = {"TOPLEFT","TOPRIGHT","BOTTOMRIGHT"},
        TRICORNER_BOTTOMLEFT = {"TOPLEFT","BOTTOMLEFT","BOTTOMRIGHT"},
        TRICORNER_BOTTOMRIGHT = {"TOPRIGHT","BOTTOMLEFT","BOTTOMRIGHT"},
    };

    local corners = squareShapes[minimapShape];
    local isSquareCorner = false;
    if corners then
        for _, c in ipairs(corners) do
            if c == quadrant then
                isSquareCorner = true;
                break;
            end
        end
    end

    if isSquareCorner then
        x = math.max(-w, math.min(w, x));
        y = math.max(-h, math.min(h, y));
    else
        local radius = math.min(w, h);
        x = math.cos(angle) * radius;
        y = math.sin(angle) * radius;
    end

    minimapBtn:ClearAllPoints();
    minimapBtn:SetPoint("CENTER", Minimap, "CENTER", x, y);
end
addon.UpdateMinimapButtonPosition = UpdateMinimapButtonPosition;

local function CreateMinimapButton()
    local btn = CreateFrame(addon.BUTTON, "WhatShouldIDoMinimapButton", Minimap);
    btn:SetSize(31, 31);
    btn:SetFrameStrata("MEDIUM");
    btn:SetFrameLevel(8);
    btn:RegisterForClicks("AnyUp");
    btn:RegisterForDrag(addon.LEFT_BUTTON);

    local icon = btn:CreateTexture(nil, addon.BACKGROUND);
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
    icon:SetSize(20, 20);
    icon:SetPoint(addon.CENTER, 0, 1);

    local border = btn:CreateTexture(nil, addon.OVERLAY);
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder");
    border:SetSize(54, 54);
    border:SetPoint(addon.TOPLEFT);

    btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight");

    btn:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter();
            local px, py = GetCursorPosition();
            local scale = Minimap:GetEffectiveScale();
            px, py = px / scale, py / scale;
            local angle = math.deg(math.atan2(py - my, px - mx));
            DB.minimap.minimapPos = angle;
            UpdateMinimapButtonPosition();
        end);
    end);
    btn:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil);
    end);

    btn:SetScript(addon.OnClick, function(_, mouseBtn)
        if mouseBtn == addon.LEFT_BUTTON then
            if RT.MainFrame:IsShown() then
                RT.MainFrame:Hide();
                if RT.SettingsFrame then
                    RT.SettingsFrame:Hide();
                end
            else
                addon.BuildRoster();
                RT.MainFrame:Show();
            end
        elseif mouseBtn == addon.RIGHT_BUTTON then
            if RT.SettingsFrame:IsShown() then
                RT.SettingsFrame:Hide();
            else
                RT.SettingsFrame:Show();
            end
        end
    end);

    btn:SetScript(addon.OnEnter, function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:SetText(addon.STRING, 1, 0.85, 0.20);
        GameTooltip:AddLine("Left-click: open / close", 0.8, 0.8, 0.8);
        GameTooltip:AddLine("Right-click: settings", 0.8, 0.8, 0.8);
        GameTooltip:Show();
    end);
    btn:SetScript(addon.OnLeave, function() GameTooltip:Hide(); end);

    return btn;
end

local function RegisterMinimapButton()
    DB.minimap = DB.minimap or {hide=false, minimapPos=45};
    minimapBtn = CreateMinimapButton();
    UpdateMinimapButtonPosition();
    if DB.minimap.hide then
        minimapBtn:Hide();
    end
end
addon.RegisterMinimapButton = RegisterMinimapButton;