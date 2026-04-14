--[[
    StarterAddon - 配置面板
    使用 3.80.1 Settings API（正式服风格）
]]

StarterAddon.Config = {}

-- 配置变量包装器工厂
-- 提供 Get/Set 方法，兼容 Settings API 和 SavedVariables
-- 依赖：StarterAddon.defaults（由 StarterAddon.lua 定义）
local function MakeSavedVar(key, default)
    return {
        Get = function(self)
            return StarterAddonDB and StarterAddonDB[key] or default
        end,
        Set = function(self, value)
            if StarterAddonDB then
                StarterAddonDB[key] = value
            end
        end,
    }
end

-- 初始化配置面板
function StarterAddon:InitConfig()
    if not Settings or not Settings.RegisterVerticalLayoutCategory then
        self:Debug("Settings API 不可用，跳过配置面板初始化")
        return
    end

    local defaults = StarterAddon.defaults

    -- 基于主模块的 defaults 创建配置变量
    local sv = {}
    for key, default in pairs(defaults) do
        sv[key] = MakeSavedVar(key, default)
    end
    StarterAddon.Config.sv = sv

    -- 注册插件分类
    local category = Settings.RegisterVerticalLayoutCategory("StarterAddon")
    Settings.RegisterAddOnCategory(category)
    StarterAddon.Config.category = category

    -- === 通用设置 ===
    local general = Settings.CreateVerticalLayoutCategory("通用设置")

    Settings.AddToCategory(general, Settings.NewCheckbox(
        "启用插件", sv.enabled,
        function() StarterAddon:Debug("启用: " .. tostring(sv.enabled:Get())) end
    ))

    Settings.AddToCategory(general, Settings.NewCheckbox(
        "锁定位置", sv.locked,
        function() StarterAddon:Debug("锁定: " .. tostring(sv.locked:Get())) end
    ))

    Settings.AddToCategory(general, Settings.NewCheckbox(
        "显示小地图按钮", sv.showMinimap,
        function()
            StarterAddon:Debug("小地图: " .. tostring(sv.showMinimap:Get()))
            if StarterAddon.ToggleMinimap then
                StarterAddon:ToggleMinimap(sv.showMinimap:Get())
            end
        end
    ))

    -- === 外观设置 ===
    local appearance = Settings.CreateVerticalLayoutCategory("外观设置")

    Settings.AddToCategory(appearance, Settings.NewSlider(
        "透明度", 0.1, 1.0, 0.05, sv.alpha,
        function() StarterAddon:Debug("透明度: " .. sv.alpha:Get()) end
    ))

    Settings.AddToCategory(appearance, Settings.NewSlider(
        "缩放比例", 0.5, 2.0, 0.1, sv.scale,
        function() StarterAddon:Debug("缩放: " .. sv.scale:Get()) end
    ))

    self:Debug("配置面板初始化完成")
end

-- 打开配置面板
function StarterAddon:OpenConfig()
    if not self.Config.category then
        self:Print("配置面板未就绪，请输入 /reload 后重试")
        return
    end
    Settings.OpenToCategory(self.Config.category:GetID())
end

-- 便捷访问函数
local defaults = StarterAddon.defaults

function StarterAddon:GetAlpha()        return self.Config.sv and self.Config.sv.alpha:Get()        or defaults.alpha end
function StarterAddon:GetScale()        return self.Config.sv and self.Config.sv.scale:Get()        or defaults.scale end
function StarterAddon:IsLocked()        return self.Config.sv and self.Config.sv.locked:Get()       or defaults.locked end
function StarterAddon:ShowMinimapIcon() return self.Config.sv and self.Config.sv.showMinimap:Get() or defaults.showMinimap end
function StarterAddon:IsEnabled()       return self.Config.sv and self.Config.sv.enabled:Get()      or defaults.enabled end

-- 重置所有配置为默认值
function StarterAddon:ResetConfig()
    for k, v in pairs(StarterAddon.defaults) do
        StarterAddonDB[k] = v
    end
    self:Print("配置已重置为默认值，请 /reload 生效")
end

-- 暴露工厂函数，供插件扩展时创建新的配置变量
StarterAddon.MakeSavedVar = MakeSavedVar

--[[
    使用示例（在插件其他模块中）：

    -- 读取配置
    local alpha = StarterAddon:GetAlpha()
    local scale = StarterAddon:GetScale()

    -- 写入配置（自动保存到 SavedVariables）
    StarterAddon.Config.sv.alpha:Set(0.5)

    -- 打开配置面板
    StarterAddon:OpenConfig()

    -- 创建新的配置变量
    local myVar = StarterAddon.MakeSavedVar("myOption", "default")
    local val = myVar:Get()
    myVar:Set("newValue")
]]--