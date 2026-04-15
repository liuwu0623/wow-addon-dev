# WoW UI Source — 官方 UI 源码与 API 文档参考

## 概述

**仓库地址**：https://github.com/Gethe/wow-ui-source

暴雪官方 WoW UI 源码的 Git 镜像，包含**完整的框架实现代码**和**结构化 API 文档**。所有文件为 Lua 格式，可通过浏览器在线查看，也可克隆到本地作为离线参考。

> 这是查询 API 签名、参数类型、返回值和枚举定义的**最权威来源**。当速查表或网络搜索无法确认某个 API 的精确用法时，应直接查阅此仓库。

## 仓库结构

```
wow-ui-source/
├── Interface/
│   ├── AddOns/
│   │   ├── Blizzard_APIDocumentationGenerated/   # ★ 结构化 API 文档（576 个模块）
│   │   │   ├── Blizzard_APIDocumentationGenerated.toc
│   │   │   ├── AddOnsDocumentation.lua           #   插件加载管理 API
│   │   │   ├── UnitDocumentation.lua             #   单位查询 API
│   │   │   ├── SpellDocumentation.lua            #   法术 API
│   │   │   ├── ActionDocumentation.lua           #   动作条/施法 API
│   │   │   ├── ChatInfoDocumentation.lua         #   聊天系统 API
│   │   │   ├── BagDocumentation.lua              #   背包 API
│   │   │   ├── ...                               #   共 576 个模块
│   │   │
│   │   ├── Blizzard_Settings/                    # Settings API 框架实现
│   │   ├── Blizzard_Deprecated/                  # ★ 废弃 API 兼容层（迁移参考）
│   │   ├── Blizzard_ActionBar/                   # 动作条框架实现
│   │   ├── Blizzard_ChatFrame/                   # 聊天框架实现
│   │   ├── Blizzard_CombatLog/                   # 战斗日志实现
│   │   ├── Blizzard_UnitFrame/                   # 单位框架实现
│   │   ├── ...                                   # 300+ 个内置 AddOn
│   │
│   ├── ui-code-list.txt      # 所有源码文件完整路径列表
│   ├── ui-toc-list.txt       # 所有 AddOn TOC 文件列表
│   └── ui-gen-addon-list.txt # 自动生成的 AddOn 列表
│
├── version.txt               # 当前版本号
└── README.md
```

## 分支说明

| 分支 | 用途 |
|------|------|
| `live` | 正式服最新版本（默认分支） |
| `ptr` | 正式服 PTR |
| `ptr2` | 正式服 PTR2 |
| `beta` | 正式服 Beta |

> 时光服 3.80.1 的 API 已对齐正式服 `live` 分支，直接参考 `live` 即可。

## 核心参考路径

### 1. API 文档（Blizzard_APIDocumentationGenerated）

每个文件对应一个 API 命名空间，包含**函数签名、参数类型、返回值、事件定义、枚举和结构体**。

**在线浏览**：
https://github.com/Gethe/wow-ui-source/tree/live/Interface/AddOns/Blizzard_APIDocumentationGenerated

**文档格式示例**（以 AddOnsDocumentation.lua 为例）：

    local AddOns =
    {
        Name = "AddOns",
        Type = "System",
        Namespace = "C_AddOns",
        Environment = "All",
        Functions = {
            {
                Name = "GetAddOnInfo",
                Type = "Function",
                Arguments = {
                    { Name = "name", Type = "uiAddon", Nilable = false },
                },
                Returns = {
                    { Name = "name", Type = "cstring", Nilable = false },
                    { Name = "title", Type = "cstring", Nilable = false },
                    { Name = "notes", Type = "cstring", Nilable = false },
                    { Name = "loadable", Type = "bool", Nilable = false },
                    { Name = "reason", Type = "cstring", Nilable = false },
                    { Name = "security", Type = "cstring", Nilable = false },
                },
            },
            -- ...
        },
        Events = {
            {
                Name = "AddonLoaded",
                Type = "Event",
                LiteralName = "ADDON_LOADED",
                Payload = {
                    { Name = "addOnName", Type = "cstring", Nilable = false },
                },
            },
        },
        Tables = {
            {
                Name = "AddOnInfo",
                Type = "Structure",
                Fields = { ... },
            },
        },
    }

### 2. 废弃 API 兼容层（Blizzard_Deprecated）

**路径**：https://github.com/Gethe/wow-ui-source/tree/live/Interface/AddOns/Blizzard_Deprecated

这是进行**旧插件迁移**时最重要的参考。包含：
- `Blizzard_DeprecatedActionBar` — 旧动作条 API 兼容
- `Blizzard_DeprecatedChatInfo` — 旧聊天 API 兼容
- `Blizzard_DeprecatedItemScript` — 旧物品 API 兼容
- `Blizzard_DeprecatedSpellScript` — 旧法术 API 兼容
- `Blizzard_DeprecatedUnitScript` — 旧单位 API 兼容
- `Blizzard_DeprecatedCombatLog` — 旧战斗日志兼容
- `Blizzard_DeprecatedSpellBook` — 旧法术书兼容
- `Blizzard_DeprecatedPetInfo` — 旧宠物 API 兼容
- `Blizzard_DeprecatedGuildScript` — 旧公会 API 兼容
- `Blizzard_DeprecatedSpecialization` — 旧专精 API 兼容

每个 Deprecated 文件展示了旧 API 如何映射到新的 C_ 命名空间 API。

### 3. UI 框架实现（Frame/Button/Texture 等）

**路径**：https://github.com/Gethe/wow-ui-source/tree/live/Interface/AddOns

核心框架 AddOn（可直接阅读源码学习实现模式）：

| AddOn | 功能 |
|-------|------|
| `Blizzard_SharedXML` | 共享 XML 模板和控件定义 |
| `Blizzard_SharedXMLCore` | 核心共享库（Color, Texture, Font 等） |
| `Blizzard_ActionBarController` | 动作条控制器实现 |
| `Blizzard_ChatFrameBase` | 聊天框架基类 |
| `Blizzard_CompactRaidFrames` | 团队框架实现 |
| `Blizzard_UnitFrame` | 单位框架实现 |
| `Blizzard_CastingBarFrame` | 施法条实现 |
| `Blizzard_TargetFrame` | 目标框架实现 |
| `Blizzard_Minimap` | 小地图实现 |
| `Blizzard_TalentUI` | 天赋界面 |
| `Blizzard_Settings` | 设置系统完整实现 |

### 4. API 文档查询索引

按功能分类的常用 API 文档文件名（在 Blizzard_APIDocumentationGenerated 目录下）：

**插件管理**：
- `AddOnsDocumentation.lua` — C_AddOns 命名空间

**单位/目标**：
- `UnitDocumentation.lua` — UnitHealth, UnitName 等
- `UnitAuraDocumentation.lua` — 光环查询
- `UnitPositionDocumentation.lua` — 单位坐标

**法术/施法**：
- `SpellDocumentation.lua` — 法术信息查询
- `SpellBookDocumentation.lua` — 法术书
- `SpellCastDocumentation.lua` — 施法状态

**物品/背包**：
- `BagDocumentation.lua` — 背包操作
- `ContainerDocumentation.lua` — 容器（C_Container）
- `ItemDocumentation.lua` — 物品信息（C_Item）
- `ItemLocationDocumentation.lua` — 物品位置

**聊天**：
- `ChatInfoDocumentation.lua` — 聊天系统（C_ChatInfo）
- `ChatBubblesDocumentation.lua` — 聊天气泡

**UI 控件**：
- `SimpleFrameAPIDocumentation.lua` — Frame 基础方法
- `SimpleButtonAPIDocumentation.lua` — Button 控件
- `SimpleTextureAPIDocumentation.lua` — Texture 控件
- `SimpleFontStringAPIDocumentation.lua` — FontString 控件
- `SimpleSliderAPIDocumentation.lua` — Slider 控件
- `SimpleEditBoxAPIDocumentation.lua` — EditBox 控件
- `SimpleCheckboxAPIDocumentation.lua` — CheckButton 控件
- `SimpleScrollFrameAPIDocumentation.lua` — ScrollFrame 控件
- `FrameScriptDocumentation.lua` — Frame 全局脚本方法
- `FrameAPICooldownDocumentation.lua` — Cooldown 控件

**设置系统**：
- `SettingsUtilDocumentation.lua` — Settings 工具函数

**冷却/物品使用**：
- `CooldownDocumentation.lua` — 冷却查询
- `ActionDocumentation.lua` — 动作条操作

**地图**：
- `MapDocumentation.lua` — C_Map 命名空间

**任务**：
- `QuestLogDocumentation.lua` — 任务日志
- `QuestInfoDocumentation.lua` — 任务信息

**战斗**：
- `CombatLogDocumentation.lua` — 战斗日志
- `CombatTextDocumentation.lua` — 浮动战斗文字

**宠物/坐骑**：
- `PetDocumentation.lua` — 宠物系统
- `MountDocumentation.lua` — 坐骑系统

**团队/副本**：
- `CompactUnitFramesDocumentation.lua` — 团队框架 API

**CVar**：
- `CVarDocumentation.lua` — 控制台变量

**其他**：
- `BuildDocumentation.lua` — 版本信息
- `ClientDocumentation.lua` — 客户端信息
- `CameraDocumentation.lua` — 摄像机控制
- `MinimapFrameAPIDocumentation.lua` — 小地图 API

## 查阅方法

### 方法一：在线浏览（推荐）

直接在 GitHub 仓库中浏览，路径格式：

    https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/<模块名>.lua

### 方法二：克隆到本地

    git clone https://github.com/Gethe/wow-ui-source.git

API 文档位于：

    wow-ui-source/Interface/AddOns/Blizzard_APIDocumentationGenerated/

### 方法三：GitHub 搜索

在仓库页面使用搜索框（Enter 键），输入 API 函数名如 `GetSpellInfo`，可快速定位到定义它的文档文件。

## 数据类型说明

API 文档中使用的类型系统：

| 类型 | 说明 |
|------|------|
| `number` | 数值 |
| `bool` | 布尔值 |
| `cstring` | C 字符串（只读） |
| `string` | Lua 字符串（可修改） |
| `table` | Lua 表 |
| `LuaValueVariant` | 任意 Lua 值 |
| `uiAddon` | 插件名称（string 的子类型） |
| `token` | 预定义字符串常量 |
| `Nilable = true` | 可为 nil |
| `Nilable = false` | 不可为 nil |
| `Default = "值"` | 参数默认值 |
| `StrideIndex = N` | 多返回值按 N 个一组打包 |
| `SecretArguments = "AllowedWhenUntainted"` | 仅限非安全环境调用 |
| `SynchronousEvent = true` | 同步事件（立即触发） |

## 与本技能其他参考文档的关系

| 文档 | 定位 |
|------|------|
| `api-quick-ref.md` | 常用 API 速查，覆盖高频函数 |
| `api-changes-3801.md` | 3.80.1 版本 API 变更对照 |
| `wow-ui-source.md`（本文件） | 官方源码索引，全量 API 查阅入口 |
| `events.md` | 事件列表与参数速查 |
| `secure-action-button.md` | SecureActionButton 详细用法 |
