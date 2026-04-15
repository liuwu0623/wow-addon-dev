---
name: wow-addon-dev
description: 魔兽世界时光服（WoW Cataclysm Classic）插件开发与适配。覆盖 3.80.1 版本 API 体系，包括：从零创建插件（TOC/Lua/XML）、将正式服/怀旧服插件迁移适配至 3.80.1、修复因 API 大洗牌导致失效的接口、使用 SecureActionButton 替代被移除的 cast 宏命令、理解 3.80.1 新增与废弃的 API。适用于用户要求制作/编写/创建 WoW 插件、适配旧插件、修复插件报错、或提及魔兽世界 Lua 开发时触发。
---

# WoW Addon Dev (时光服 3.80.1)

为魔兽世界时光服 3.80.1 版本开发、迁移和修复插件。

## 背景

2026 年 4 月 9 日，时光服从 3.80.0 升级至 3.80.1，暴雪将客户端 API 大幅向正式服（Retail）对齐。大量怀旧服（Classic/ Cataclysm Classic）专有 API 被废弃或替换，导致几乎所有插件失效。插件开发者必须将接口迁移至正式服 API 体系。

**核心变化：**
- 大量 Classic/TBC/Cata 专属 API 被移除，需迁移至正式服对应接口
- 宏命令中的 `/cast` 等直接施法调用受到安全限制，需通过 `SecureActionButton` 实现
- 界面编辑功能向正式服看齐，动作条/框体/聊天等支持原生拖拽配置
- TOC 接口号变更为 `38001`

## 目录结构

```
MyAddon/
├── MyAddon.toc          # 元数据与加载清单
├── MyAddon.lua          # 主逻辑
├── MyAddon.xml          # UI 布局（可选，现代插件多纯 Lua）
├── MyAddon_Config.lua   # 配置面板（可选）
└── libs/                # 依赖库（可选）
    ├── CallbackHandler-1.0/
    └── LibSharedMedia-3.0/
```

安装路径：`World of Warcraft\_classic_\Interface\AddOns\MyAddon\`

## TOC 文件

```toc
## Interface: 38001
## Title: MyAddon
## Notes: 插件描述
## Author: 作者名
## Version: 1.0.0
## SavedVariables: MyAddonDB
## SavedVariablesPerCharacter: MyAddonCharDB

MyAddon.lua
MyAddon_Config.lua
```

关键接口号对照：

| 客户端 | Interface |
|--------|-----------|
| 时光服 3.80.1 | `38001` |
| 大灾变经典版 4.4.x | `40400` |
| 正式服 11.x | `110100` |

## 工作流决策树

```
用户需求
├── 从零创建插件 → "创建新插件"
├── 修复/适配已有插件 → "迁移与修复"
└── 理解 API 差异 → 查阅 references/api-changes-3801.md
```

## 创建新插件

### 最小可用插件

```lua
-- MyAddon.toc
-- ## Interface: 38001
-- ## Title: MyAddon
-- MyAddon.lua

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(self, event, ...)
    print("|cff00ff00[MyAddon]|r 已加载!")
end)
```

### 创建可点击按钮

```lua
local btn = CreateFrame("Button", "MyAddon_Button", UIParent, "UIPanelButtonTemplate")
btn:SetSize(120, 30)
btn:SetPoint("CENTER")
btn:SetText("点击我")
btn:SetScript("OnClick", function(self)
    print("按钮被点击!")
end)
```

### SecureActionButton（替代 /cast 宏）

3.80.1 中直接在宏中使用 `/cast` 受限，需用 SecureActionButtonTemplate：

```lua
local btn = CreateFrame("Button", "MyCastBtn", UIParent, "SecureActionButtonTemplate")
btn:SetAttribute("type", "spell")
btn:SetAttribute("spell", "复活术")
btn:SetSize(40, 40)
btn:SetPoint("CENTER")

-- 添加图标
local icon = btn:CreateTexture(nil, "ARTWORK")
icon:SetTexture(GetSpellTexture("复活术"))
icon:SetAllPoints()

-- 绑定条件：Shift+左键 = 自施放，普通左键 = 施放
btn:SetAttribute("shift-type1", "spell")
btn:SetAttribute("shift-spell1", "复活术")
btn:SetAttribute("shift-unit1", "player")
```

### 设置与配置面板（Settings API）

3.80.1 使用正式服 Settings API 管理配置：

```lua
-- 注册配置面板
do
    local category = Settings.RegisterVerticalLayoutCategory("MyAddon")

    -- 创建设置组
    local group = Settings.CreateVerticalLayoutCategory("通用设置")

    -- 布尔开关
    Settings.AddToCategory(group, Settings.NewCheckbox(
        "启用功能", -- 选项名
        Settings.Varable.New("MyAddon_Enabled", false), -- 变量
        function() end -- onChange 回调
    ))

    -- 滑块
    Settings.AddToCategory(group, Settings.NewSlider(
        "透明度", 0, 1, 0.01,
        Settings.Varable.New("MyAddon_Alpha", 1.0),
        function() end
    ))

    Settings.RegisterAddOnCategory(category)
    Settings.OpenToCategory(category)
end
```

### 事件注册

```lua
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("CHAT_MSG_WHISPER")
f:RegisterEvent("UNIT_AURA")

f:SetScript("OnEvent", function(self, event, ...)
    local args = {...}
    if event == "PLAYER_LOGIN" then
        self:UnregisterEvent("PLAYER_LOGIN")
        -- 初始化逻辑
    elseif event == "CHAT_MSG_WHISPER" then
        local msg, sender = args[1], args[2]
        print("收到密语:", msg, "来自:", sender)
    elseif event == "UNIT_AURA" then
        local unit = args[1]
        -- 处理光环变化
    end
end)
```

## 迁移与修复

将正式服/怀旧服插件适配至 3.80.1 时，按以下顺序排查：

### 1. 更新 TOC Interface

将 `## Interface:` 改为 `38001`，同时更新 `## X-Curse-Packaged-Version` 等字段。

### 2. 检查废弃 API

常见被移除/替换的 API（完整列表见 references/api-changes-3801.md）：

| 旧 API（已废弃） | 替代方案 |
|-------------------|----------|
| `CastSpellByName()` | `SecureActionButtonTemplate` |
| `TargetUnit()` | `SecureActionButtonTemplate` |
| `UseAction()` | `SecureActionButtonTemplate` |
| `ContainerFrameItemButton`（旧容器） | 使用 `C_Container` 命名空间 |
| 直接 hook 函数 | `hooksecurefunc` |

### 3. C_ 命名空间迁移

3.80.1 大量 API 已移入 `C_` 命名空间：

```lua
-- 旧写法
local count = GetContainerNumSlots(bagID)
local icon = GetContainerItemInfo(bagID, slotID)

-- 新写法
local count = C_Container.GetContainerNumSlots(bagID)
local info = C_Container.GetContainerItemInfo(bagID, slotID)
if info then
    local icon = info.iconFileID
end
```

### 4. 调试方法

```lua
-- 在 TOC 中添加开发标记
-- ## DefaultState: enabled
-- ## LoadOnDemand: 0

-- 在游戏内重载界面
/reload

-- 使用 BugGrabber/BugSack 捕获错误信息
-- 使用 /dump 检查返回值
/dump C_Container.GetContainerNumSlots(0)
```

## 插件模板

完整的入门级插件模板见 `assets/starter-addon/` 目录，包含：
- 标准目录结构
- TOC 文件
- 主逻辑文件
- 配置面板
- SecureActionButton 示例

## 参考资料

- **官方 UI 源码索引**：`references/wow-ui-source.md` — [Gethe/wow-ui-source](https://github.com/Gethe/wow-ui-source) 仓库结构与 API 文档查阅指南（576 个 API 模块、废弃 API 兼容层、UI 框架实现源码）
- **API 变更详细列表**：`references/api-changes-3801.md` — 3.80.1 版本新增、废弃与替换的完整 API 对照
- **SecureActionButton 指南**：`references/secure-action-button.md` — 安全按钮模板的完整用法与模式
- **WoW API 速查**：`references/api-quick-ref.md` — 常用 Lua API 按功能分类的速查表
- **事件系统参考**：`references/events.md` — 常用事件列表与参数说明
- **WoWInterface / CurseForge** — 插件发布平台：[wowinterface.com](https://www.wowinterface.com)、[curseforge.com/wow](https://www.curseforge.com/wow)
- **Wowpedia** — API 文档：[wowpedia.fandom.com](https://wowpedia.fandom.com/wiki/World_of_Warcraft_API)
- **NGA 时光服插件讨论区** — 中文社区：[bbs.nga.cn/thread.php?fid=510355](https://bbs.nga.cn/thread.php?fid=510355&ff=776)
