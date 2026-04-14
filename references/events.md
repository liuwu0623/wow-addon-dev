# 常用事件列表与参数说明

WoW 插件通过事件系统获取游戏状态变化通知。以下列出 3.80.1 中常用的核心事件。

## 目录

1. [玩家事件](#1-玩家事件)
2. [单位事件](#2-单位事件)
3. [聊天事件](#3-聊天事件)
4. [背包/物品事件](#4-背包物品事件)
5. [法术/施法事件](#5-法术施法事件)
6. [任务事件](#6-任务事件)
7. [团队/副本事件](#7-团队副本事件)
8. [UI 事件](#8-ui事件)
9. [战斗事件](#9-战斗事件)
10. [地图/区域事件](#10-地图区域事件)
11. [事件注册最佳实践](#11-事件注册最佳实践)

---

## 1. 玩家事件

| 事件名 | 触发时机 | 参数 |
|--------|---------|------|
| `PLAYER_LOGIN` | 登录完成，SavedVariables 已加载 | 无 |
| `PLAYER_LOGOUT` | 登出 | 无 |
| `PLAYER_ENTERING_WORLD` | 进入世界（包括切换地图后） | isInitialLogin, isReloadingUi |
| `PLAYER_LEAVING_WORLD` | 离开世界 | 无 |
| `PLAYER_LEVEL_UP` | 升级 | level, healthDelta, powerDelta, numNewTalents, numNewPvpTalentSlots, strengthDelta, agilityDelta, staminaDelta, intellectDelta |
| `PLAYER_XP_UPDATE` | 经验值变化 | unitTag, xp, totalXP |
| `PLAYER_MONEY` | 金钱变化 | 无 |
| `PLAYER_REGEN_ENABLED` | 脱战 | 无 |
| `PLAYER_REGEN_DISABLED` | 进战 | 无 |
| `PLAYER_FLAGS_CHANGED` | 玩家标记变化（AFK/DND 等） | unitTarget |
| `PLAYER_SPECIALIZATION_CHANGED` | 专精切换 | unitTarget |
| `PLAYER_DEAD` | 玩家死亡 | 无 |
| `PLAYER_ALIVE` | 玩家复活 | 无 |
| `PLAYER_UNGHOST` | 灵魂状态结束 | 无 |

---

## 2. 单位事件

| 事件名 | 触发时机 | 参数 |
|--------|---------|------|
| `UNIT_HEALTH` | 生命值变化 | unitTarget |
| `UNIT_MAXHEALTH` | 最大生命值变化 | unitTarget |
| `UNIT_POWER_UPDATE` | 能量变化 | unitTarget, powerType |
| `UNIT_POWER_BAR_SHOW` | 能量条显示 | unitTarget |
| `UNIT_POWER_BAR_HIDE` | 能量条隐藏 | unitTarget |
| `UNIT_AURA` | 光环（增益/减益）变化 | unitTarget |
| `UNIT_TARGET` | 目标改变 | unitTarget |
| `UNIT_NAME_UPDATE` | 名字更新 | unitTarget |
| `UNIT_LEVEL` | 等级变化 | unitTarget |
| `UNIT_FACTION` | 阵营变化 | unitTarget |
| `UNIT_CLASSIFICATION_CHANGED` | 分类变化 | unitTarget |
| `UNIT_DISPLAYPOWER` | 能量类型变化 | unitTarget |
| `UNIT_PET` | 宠物状态变化 | unitTarget |

---

## 3. 聊天事件

| 事件名 | 触发时机 | 参数 |
|--------|---------|------|
| `CHAT_MSG_WHISPER` | 收到密语 | msg, fullName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInRaid, supressRaidIcons |
| `CHAT_MSG_WHISPER_INFORM` | 发出密语 | 同上 |
| `CHAT_MSG_SAY` | 说话 | 同上 |
| `CHAT_MSG_YELL` | 喊话 | 同上 |
| `CHAT_MSG_PARTY` | 小队聊天 | 同上 |
| `CHAT_MSG_PARTY_LEADER` | 小队队长聊天 | 同上 |
| `CHAT_MSG_RAID` | 团队聊天 | 同上 |
| `CHAT_MSG_RAID_LEADER` | 团队队长聊天 | 同上 |
| `CHAT_MSG_RAID_WARNING` | 团队警告 | 同上 |
| `CHAT_MSG_GUILD` | 公会聊天 | 同上 |
| `CHAT_MSG_OFFICER` | 官员聊天 | 同上 |
| `CHAT_MSG_CHANNEL` | 频道聊天 | 同上（额外包含 channelName） |
| `CHAT_MSG_SYSTEM` | 系统消息 | msg |

通用聊天事件参数获取模式：

    frame:SetScript("OnEvent", function(self, event, ...)
        if event == "CHAT_MSG_WHISPER" then
            local msg, sender = ...
            -- sender 格式通常为 "玩家名-服务器名"
        end
    end)

---

## 4. 背包/物品事件

| 事件名 | 触发时机 | 参数 |
|--------|---------|------|
| `BAG_UPDATE` | 背包内容变化 | bagID |
| `BAG_UPDATE_DELAYED` | 背包更新完成 | bagID |
| `BAG_NEW_ITEMS_UPDATED` | 新物品高亮更新 | 无 |
| `ITEM_LOCKED` | 物品锁定 | bagID, slotID |
| `ITEM_UNLOCKED` | 物品解锁 | bagID, slotID |
| `INVENTORY_SEARCH_UPDATE` | 背包搜索更新 | 无 |
| `EQUIPMENT_SETS_CHANGED` | 装备方案变化 | 无 |
| `EQUIPMENT_SWAP_FINISHED` | 装备切换完成 | 成功/失败, 集合名称 |

---

## 5. 法术/施法事件

| 事件名 | 触发时机 | 参数 |
|--------|---------|------|
| `UNIT_SPELLCAST_SENT` | 施法发出 | unitTarget, target, castGUID, spellID |
| `UNIT_SPELLCAST_SUCCEEDED` | 施法成功 | unitTarget, castGUID, spellID |
| `UNIT_SPELLCAST_FAILED` | 施法失败 | unitTarget, castGUID, spellID |
| `UNIT_SPELLCAST_INTERRUPTED` | 施法被打断 | unitTarget, castGUID, spellID |
| `UNIT_SPELLCAST_START` | 施法开始 | unitTarget, castGUID, spellID |
| `UNIT_SPELLCAST_STOP` | 施法停止 | unitTarget, castGUID, spellID |
| `UNIT_SPELLCAST_DELAYED` | 施法延迟 | unitTarget, castGUID, spellID |
| `SPELL_DATA_LOAD_RESULT` | 法术数据加载完成 | spellID, success |
| `LEARNED_SPELL_IN_TAB` | 学习新法术 | spellID, skillLineIndex, isGuildPerkSpell |

---

## 6. 任务事件

| 事件名 | 触发时机 | 参数 |
|--------|---------|------|
| `QUEST_ACCEPTED` | 接受任务 | questLogIndex, questID |
| `QUEST_TURNED_IN` | 提交任务 | questID, xpReward, moneyReward |
| `QUEST_REMOVED` | 放弃任务 | questID |
| `QUEST_UPDATED` | 任务进度更新 | questID |
| `QUEST_LOG_UPDATE` | 任务日志更新 | 无 |
| `QUEST_WATCH_UPDATE` | 任务追踪更新 | questID |
| `UNIT_QUEST_LOG_CHANGED` | 单位任务日志变化 | unitTarget |

---

## 7. 团队/副本事件

| 事件名 | 触发时机 | 参数 |
|--------|---------|------|
| `GROUP_ROSTER_UPDATE` | 队伍/团队名单变化 | 无 |
| `PARTY_LEADER_CHANGED` | 队长变更 | 无 |
| `PARTY_MEMBER_ENABLE` | 成员上线 | 无 |
| `PARTY_MEMBER_DISABLE` | 成员下线 | 无 |
| `PLAYER_JOINED_PARTY` | 加入队伍 | partyIndex |
| `PLAYER_LEFT_PARTY` | 离开队伍 | partyIndex |
| `INSTANCE_ENCOUNTER_ENGAGE_UNIT` | Boss 战开始 | 无 |
| `INSTANCE_ENCOUNTER_DISengaged` | Boss 战脱战 | 无 |
| `ENCOUNTER_START` | 遭遇战开始 | encounterID, name, difficulty, groupSize |
| `ENCOUNTER_END` | 遭遇战结束 | encounterID, name, difficulty, groupSize, success |
| `PLAYER_DIFFICULTY_CHANGED` | 难度变更 | 无 |

---

## 8. UI 事件

| 事件名 | 触发时机 | 参数 |
|--------|---------|------|
| `ADDON_LOADED` | 插件加载完成 | addOnName |
| `PLAYER_LOGIN` | 登录完成 | 无 |
| `PLAYER_ENTERING_WORLD` | 进入世界 | isInitialLogin, isReloadingUi |
| `UI_SCALE_CHANGED` | UI 缩放变化 | 无 |
| `DISPLAY_SIZE_CHANGED` | 显示分辨率变化 | 无 |
| `CVAR_UPDATE` | CVar 变化 | cvarName, value |
| `LOADING_SCREEN_DISABLED` | 加载画面结束 | 无 |
| `MODIFIER_STATE_CHANGED` | 修饰键状态变化 | key, state |

---

## 9. 战斗事件

| 事件名 | 触发时机 | 参数 |
|--------|---------|------|
| `PLAYER_REGEN_DISABLED` | 进战 | 无 |
| `PLAYER_REGEN_ENABLED` | 脱战 | 无 |
| `COMBAT_LOG_EVENT_UNFILTERED` | 任意战斗日志 | 见下方 |
| `UNIT_COMBAT` | 单位战斗事件 | unitTarget, action, damage, damageType |

COMBAT_LOG_EVENT_UNFILTERED 子事件（通过 CombatLogGetCurrentEventInfo() 获取）：

    local timestamp, subEvent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
          destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool
        = CombatLogGetCurrentEventInfo()

常见 subEvent：
- `SPELL_CAST_START` — 施法开始
- `SPELL_CAST_SUCCESS` — 施法成功
- `SPELL_DAMAGE` — 法术伤害
- `SPELL_HEAL` — 法术治疗
- `SPELL_AURA_APPLIED` — 光环施加
- `SPELL_AURA_REMOVED` — 光环消失
- `SWING_DAMAGE` — 普攻伤害
- `SWING_MISSED` — 普攻未命中

---

## 10. 地图/区域事件

| 事件名 | 触发时机 | 参数 |
|--------|---------|------|
| `ZONE_CHANGED` | 切换区域 | newAreaID, newZoneName, newZoneText |
| `ZONE_CHANGED_NEW_AREA` | 切换到大区域 | 无 |
| `ZONE_CHANGED_INDOORS` | 室内外切换 | 无 |
| `MINIMAP_UPDATE_ZOOM` | 小地图缩放变化 | 无 |
| `WORLD_MAP_UPDATE` | 世界地图更新 | 无 |
| `MAP_CHANGED` | 地图变更 | mapID |
| `NEW_WMO_CHUNK` | 加载新地图区块 | chunkX, chunkY |

---

## 11. 事件注册最佳实践

### 模式 1：单 Frame 统一注册

    local myFrame = CreateFrame("Frame")
    myFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_LOGIN" then
            self:UnregisterEvent("PLAYER_LOGIN")
            -- 初始化
        elseif event == "UNIT_AURA" then
            local unit = ...
            -- 处理光环变化
        end
    end)

    myFrame:RegisterEvent("PLAYER_LOGIN")
    myFrame:RegisterEvent("UNIT_AURA")

### 模式 2：按功能拆分 Frame

    local uiFrame = CreateFrame("Frame")
    uiFrame:SetScript("OnEvent", function(self, event, ...)
        -- 只处理 UI 相关事件
    end)

    local combatFrame = CreateFrame("Frame")
    combatFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    combatFrame:SetScript("OnEvent", function(self, event, ...)
        -- 只处理战斗事件
    end)

### 注意事项

1. **PLAYER_LOGIN 时 SavedVariables 才可用**，在此之前不要访问
2. **及时注销不再需要的事件**，减少性能开销
3. **UNIT_AURA 等高频事件**需要优化处理逻辑，避免在 OnEvent 中做重计算
4. **COMBAT_LOG_EVENT_UNFILTERED** 非常高频，务必过滤感兴趣的 subEvent
5. **使用 C_Timer.After** 替代 `OnUpdate` 做定时任务
6. **重载界面** `/reload` 是最有效的调试手段