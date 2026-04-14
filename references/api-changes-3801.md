# 3.80.1 API 变更详细列表

时光服 3.80.1（2026-04-09）的 API 大幅向正式服对齐。本文档列出主要变更，供迁移适配时参考。

## 目录

1. [安全框架变更](#1-安全框架变更)
2. [C_ 命名空间迁移](#2-c_-命名空间迁移)
3. [容器/背包 API](#3-容器背包-api)
4. [物品与装备 API](#4-物品与装备-api)
5. [法术与光环 API](#5-法术与光环-api)
6. [单位/目标 API](#6-单位目标-api)
7. [聊天/信息 API](#7-聊天信息-api)
8. [UI/框架 API](#8-ui框架-api)
9. [设置/配置 API](#9-设置配置-api)
10. [地图/坐标 API](#10-地图坐标-api)
11. [新增 API](#11-新增-api)
12. [完全移除的 API](#12-完全移除的-api)

---

## 1. 安全框架变更

### CastSpellByName() 不再可从非安全代码调用

旧用法（3.80.0 之前，宏中可用）：

    /cast 复活术

新方案：使用 SecureActionButtonTemplate 代替。详见 `references/secure-action-button.md`。

### TargetUnit() 受限

旧用法：

    TargetUnit("target")

新方案：通过 SecureActionButton 的 `type = "target"` 属性实现。

### UseAction() 受限

旧用法：

    UseAction(slot, checkCursor, onSelf)

新方案：SecureActionButton 的 `type = "action"` 属性。

### 注意

`hooksecurefunc` 仍然可用，是安全的 hook 方式。禁止使用 `setfenv` / `getfenv` 等沙箱逃逸手段。

---

## 2. C_ 命名空间迁移

3.80.1 延续了暴雪的 API 整理策略，将散落的全局函数归入 `C_` 命名空间。以下是主要迁移：

| 旧全局函数 | 新 C_ 命名空间 |
|------------|---------------|
| `GetContainerNumSlots(bag)` | `C_Container.GetContainerNumSlots(bag)` |
| `GetContainerNumFreeSlots(bag)` | `C_Container.GetContainerNumFreeSlots(bag)` |
| `GetContainerItemInfo(bag, slot)` | `C_Container.GetContainerItemInfo(bag, slot)` |
| `GetContainerItemLink(bag, slot)` | `C_Container.GetContainerItemLink(bag, slot)` |
| `PickupContainerItem(bag, slot)` | `C_Container.PickupContainerItem(bag, slot)` |
| `UseContainerItem(bag, slot)` | `C_Container.UseContainerItem(bag, slot)` |
| `GetItemInfo(itemID)` | `C_Item.GetItemInfo(itemID)` |
| `GetItemInfoInstant(itemID)` | `C_Item.GetItemInfoInstant(itemID)` |
| `IsEquippableItem(itemID)` | `C_Item.IsEquippableItem(itemID)` |
| `GetQuestLogTitle(questIndex)` | `C_QuestLog.GetQuestLogTitle(questIndex)` |
| `GetQuestLogQuestText(questIndex)` | `C_QuestLog.GetQuestLogQuestText(questIndex)` |
| `GetNumQuestLogEntries()` | `C_QuestLog.GetNumQuestLogEntries()` |
| `GetQuestInfo(questID)` | `C_QuestInfo.GetQuestInfo(questID)` |
| `GetAchievementInfo(achID)` | `C_AchievementInfo.GetAchievementInfo(achID)` |
| `GetNumBindings()` | `C_Binding.GetNumBindings()` |
| `GetBinding(index)` | `C_Binding.GetBinding(index)` |

---

## 3. 容器/背包 API

### 返回值结构变化

旧 `GetContainerItemInfo` 返回 8 个平铺值：

    texture, count, locked, quality, readable, lootable, hyperlink, isFiltered
        = GetContainerItemInfo(bag, slot)

新 `C_Container.GetContainerItemInfo` 返回一个表：

    local info = C_Container.GetContainerItemInfo(bag, slot)
    if info then
        local texture = info.iconFileID
        local count = info.stackCount
        local locked = info.isLocked
        local quality = info.quality
        local readable = info.isReadable
        local lootable = info.hasLoot
        local hyperlink = info.hyperlink
        local filtered = info.isFiltered
    end

---

## 4. 物品与装备 API

### GetItemInfo 变化

    -- 旧写法
    local name, _, rarity, _, _, _, _, _, _, icon = GetItemInfo(itemID)

    -- 新写法（兼容但推荐 C_ 命名空间）
    local itemInfo = C_Item.GetItemInfo(itemID)
    if itemInfo then
        local name = itemInfo.itemName
        local icon = itemInfo.itemIcon
    end

### 新增装备管理

    `C_EquipmentSet` 命名空间提供装备方案管理：

    local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs()
    for _, setID in ipairs(equipmentSetIDs) do
        local name, iconFileID = C_EquipmentSet.GetEquipmentSetInfo(setID)
    end

---

## 5. 法术与光环 API

### 施法相关

    -- CastSpellByName 仍存在于安全环境中，但不能从普通 Lua 调用
    -- 使用 SecureActionButton 代替
    -- 参见 references/secure-action-button.md

### 光环查询

    -- AuraUtil 命名空间是查询光环的推荐方式
    AuraUtil.ForEachAura("target", "HELPFUL", nil, function(name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer)
        -- 处理每个光环
    end)

    -- 或者使用 C_UnitAuras
    local info = C_UnitAuras.GetAuraDataByIndex("player", 1, "HELPFUL")

---

## 6. 单位/目标 API

### 单位信息

    -- 旧写法
    local name, realm = UnitName("target")

    -- 新写法（返回值相同，但部分扩展函数归入 C_ 命名空间）
    local unitInfo = C_UnitAuras.GetAuraDataByIndex("target", 1)

### 目标条件检查

    `UnitExists`、`UnitIsDead`、`UnitIsFriend`、`UnitIsEnemy` 等函数仍然可用，接口未变。

---

## 7. 聊天/信息 API

### 聊天窗口

    -- 旧写法
    local name, fontSize, r, g, b, alpha, shown, locked, docked = GetChatWindowInfo(index)

    -- 新写法
    local chatInfo = C_ChatInfo.GetChatWindowInfo(index)

### 消息发送

    `SendChatMessage` 仍然可用但增加了参数：

    SendChatMessage("消息内容", "SAY")
    -- 参数 3: target (可选)
    -- 参数 4: channel (可选)

---

## 8. UI/框架 API

### FrameXML 变化

3.80.1 的 FrameXML 大幅向正式服看齐。以下全局框架名称可能已变化：

| 旧名称 | 备注 |
|--------|------|
| `ContainerFrame` 系列 | 已重构，使用 `C_Container` |
| `PaperDollFrame` | 仍然存在，但内部结构变化 |
| `CharacterMicroButton` | 按钮系统重构 |
| `ActionButton` 系列 | 样式更新 |

### 字体与纹理

    -- 推荐使用 SharedFont 或 FontObject
    NORMAL_FONT_COLOR  -- 仍可用
    GameFontNormal     -- 仍可用
    -- 新增字体对象，与正式服对齐

---

## 9. 设置/配置 API

### 旧 Settings 系统

3.80.0 之前使用的 `InterfaceOptionsFrame` / `InterfaceOptions_AddCategory` 方式已废弃。

### 新 Settings API（正式服风格）

    -- 注册配置面板
    local category = Settings.RegisterVerticalLayoutCategory("MyAddon")
    Settings.RegisterAddOnCategory(category)

    -- 布尔选项
    Settings.NewCheckbox(name, variable, onChange)

    -- 滑块
    Settings.NewSlider(name, min, max, step, variable, onChange)

    -- 下拉菜单
    Settings.NewDropdown(name, options, variable, onChange)

### SavedVariables

TOC 中的 `## SavedVariables` 和 `## SavedVariablesPerCharacter` 仍然有效，加载后可直接访问全局变量。

---

## 10. 地图/坐标 API

    -- 旧写法
    local x, y = GetPlayerMapPosition("player")

    -- 新写法
    local mapPosition = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"))
    if mapPosition then
        local x, y = mapPosition:GetXY()
    end

    -- 世界地图坐标
    local uiMapID = C_Map.GetBestMapForUnit("player")
    local position = C_Map.GetPlayerMapPosition(uiMapID)

---

## 11. 新增 API

以下 API 在 3.80.1 中新增或正式可用：

| API | 说明 |
|-----|------|
| `C_Timer.After(delay, callback)` | 延迟执行（替代 `CreateFrame` 定时器 hack） |
| `C_Macro.RunMacroText(text)` | 安全地执行宏文本 |
| `C_ItemUpgrade.GetItemUpgradeEffect(...)` | 物品升级信息 |
| `C_TransmogCollection` | 幻化收藏 |
| `C_ToyBox` | 玩具箱 |
| `C_MountJournal` | 坐骑日志 |
| `C_PetJournal` | 战宠日志 |
| `C_HeirloomInfo` | 传家宝 |
| `C_AzeriteEssence` | 艾泽里特精华（如适用） |

---

## 12. 完全移除的 API

以下 API 在 3.80.1 中已被彻底移除：

| API | 替代方案 |
|-----|---------|
| `SetCVar()` 部分参数 | `C_CVar.SetCVar()` 或 `Settings` |
| `GetCVar()` 部分参数 | `C_CVar.GetCVar()` |
| 旧版背包框架直接操作 | `C_Container` |
| `ToggleFriendsFrame()` | `SocialMenu` 或 `C_Social` |
| `ToggleAchievementFrame()` | `AchievementFrame_LoadUI()` |
| `LFGDungeonList` 旧接口 | `C_LFGDungeonList` |

> **注意**：本文档基于社区开发者（如 AutoDPS 等插件的适配报告）和正式服 API 文档整理。暴雪未提供完整的 3.80.1 API 变更日志，建议使用 `/dump` 在游戏内验证具体函数是否存在。如发现遗漏或错误，请参考 NGA 时光服插件讨论区的最新讨论。