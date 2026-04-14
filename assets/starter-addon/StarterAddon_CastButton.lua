--[[
    StarterAddon - 施法按钮模块
    演示 3.80.1 SecureActionButton 的基本用法
]]

StarterAddon.CastButton = {}

function StarterAddon:InitCastButton()
    -- 创建安全按钮
    local btn = CreateFrame("Button", "StarterAddonCastButton", UIParent, "SecureActionButtonTemplate, SecureHandlerBaseTemplate")
    btn:SetSize(64, 64)
    btn:SetPoint("CENTER", UIParent, "CENTER", 0, -100)

    -- 视觉层
    local icon = btn:CreateTexture(nil, "BACKGROUND")
    icon:SetAllPoints()
    icon:SetTexture("Interface\\ICONS\\INV_Misc_QuestionMark")
    btn.icon = icon

    -- 显示施法名称的字体
    local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("BOTTOM", btn, "BOTTOM", 0, 2)
    btn.text = text

    -- 应用透明度和缩放
    btn:SetAlpha(self:GetAlpha())
    btn:SetScale(self:GetScale())

    -- 启用拖拽
    btn:SetMovable(true)
    btn:EnableMouse(true)
    btn:RegisterForDrag("LeftButton")
    btn:SetScript("OnDragStart", function(self)
        if not StarterAddon:IsLocked() then
            self:StartMoving()
        end
    end)
    btn:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    -- 左键施法（3.80.1: 使用 type="spell" + macro 而非 CastSpellByName）
    btn:SetAttribute("type", "spell")
    btn:SetAttribute("spell", "治疗石")

    -- 更新按钮显示
    local function UpdateButton()
        local spellName = btn:GetAttribute("spell")
        local spellIcon = C_Spell and C_Spell.GetSpellInfo and select(2, C_Spell.GetSpellInfo(spellName))
        if spellIcon then
            icon:SetTexture(spellIcon)
        end
        text:SetText(spellName)
    end

    btn:SetScript("OnShow", UpdateButton)
    btn:SetScript("OnEvent", function(self, event)
        if event == "SPELLS_CHANGED" then
            UpdateButton()
        end
    end)
    btn:RegisterEvent("SPELLS_CHANGED")

    StarterAddon.CastButton.frame = btn
    StarterAddon:Debug("施法按钮已创建")
end

-- 修改施法按钮的法术
function StarterAddon:SetCastButtonSpell(spellName)
    local btn = self.CastButton.frame
    if not btn then return end
    btn:SetAttribute("spell", spellName)

    -- 更新图标
    local spellIcon = C_Spell and C_Spell.GetSpellInfo and select(2, C_Spell.GetSpellInfo(spellName))
    if spellIcon then
        btn.icon:SetTexture(spellIcon)
    end
    btn.text:SetText(spellName)
    self:Debug("施法按钮已设置为: " .. spellName)
end

-- 显示/隐藏施法按钮
function StarterAddon:ToggleCastButton(show)
    local btn = self.CastButton.frame
    if not btn then return end
    if show == nil then
        show = not btn:IsShown()
    end
    btn:SetShown(show)
end
