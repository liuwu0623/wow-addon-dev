--[[
    StarterAddon - 小地图按钮模块
    创建可拖拽的小地图图标，左键打开配置面板
]]

StarterAddon.MiniMap = {}

-- 拖拽相关
local isDragging = false

function StarterAddon:InitMinimap()
    -- 创建小地图按钮（使用 MinimapButtonTemplate 或自定义）
    local btn = CreateFrame("Button", "StarterAddonMiniMapButton", Minimap)
    btn:SetSize(32, 32)
    btn:SetFrameStrata("MEDIUM")
    btn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 12, -72)

    -- 图标
    local icon = btn:CreateTexture(nil, "BACKGROUND")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER")
    icon:SetTexture("Interface\\ICONS\\INV_Misc_QuestionMark")
    btn.icon = icon

    -- 背景高亮
    local highlight = btn:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetSize(28, 28)
    highlight:SetPoint("CENTER")
    highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    highlight:SetBlendMode("ADD")
    btn.highlight = highlight

    -- 左键：打开配置面板
    btn:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            StarterAddon:OpenConfig()
        end
    end)

    -- 提示
    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("StarterAddon", 1, 1, 1)
        GameTooltip:AddLine("左键点击打开设置", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
        GameTooltip:AddLine("拖拽移动位置", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
        GameTooltip:Show()
    end)

    btn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- 拖拽定位到小地图边缘
    btn:SetMovable(true)
    btn:EnableMouse(true)
    btn:RegisterForDrag("LeftButton")

    btn:SetScript("OnDragStart", function(self, button)
        if button == "LeftButton" then
            isDragging = false
            self:SetScript("OnUpdate", function(self)
                local mx, my = Minimap:GetCenter()
                local px, py = self:GetCenter()
                if mx and py then
                    local angle = math.atan2(py - my, px - mx)
                    local radius = Minimap:GetWidth() / 2 + 4
                    local x = mx + radius * math.cos(angle) - self:GetWidth() / 2
                    local y = my + radius * math.sin(angle) - self:GetHeight() / 2
                    self:ClearAllPoints()
                    self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
                    isDragging = true
                end
            end)
        end
    end)

    btn:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
        if isDragging then
            StarterAddon:Debug("小地图按钮位置已更新")
        end
        isDragging = false
    end)

    -- 初始显示/隐藏
    btn:SetShown(StarterAddon:ShowMinimapIcon())

    StarterAddon.MiniMap.frame = btn
    StarterAddon:Debug("小地图按钮已创建")
end

-- 切换小地图图标显示（供 Config 调用）
function StarterAddon:ToggleMinimap(show)
    local btn = self.MiniMap.frame
    if btn then
        btn:SetShown(show)
    end
end