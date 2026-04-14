# WoW Lua API 速查表（3.80.1 兼容）

按功能分类的常用 API 速查。所有 API 已验证兼容时光服 3.80.1。

## 目录

1. [单位/目标](#1-单位目标)
2. [法术/施法](#2-法术施法)
3. [物品/背包](#3-物品背包)
4. [玩家/角色](#4-玩家角色)
5. [聊天/消息](#5-聊天消息)
6. [地图/坐标](#6-地图坐标)
7. [任务](#7-任务)
8. [团队/副本](#8-团队副本)
9. [UI/框架](#9-ui框架)
10. [工具函数](#10-工具函数)
11. [数学/字符串](#11-数学字符串)
12. [SavedVariables](#12-savedvariables)

---

## 1. 单位/目标

    UnitName("unit")                        -- 名字, 服务器名
    UnitHealth("unit")                      -- 当前生命值
    UnitHealthMax("unit")                   -- 最大生命值
    UnitPower("unit", powerType)            -- 当前能量（0=法力,1=怒气,2=集中,3=能量...）
    UnitPowerMax("unit", powerType)         -- 最大能量
    UnitPowerType("unit")                   -- 能量类型编号
    UnitLevel("unit")                       -- 等级
    UnitClass("unit")                       -- 本地化职业名, 英文职业名
    UnitRace("unit")                        -- 种族
    UnitFactionGroup("unit")                -- 阵营 "Alliance"/"Horde"
    UnitExists("unit")                      -- 单位是否存在
    UnitIsDead("unit")                      -- 是否死亡
    UnitIsGhost("unit")                     -- 是否灵魂状态
    UnitIsFriend("unit1", "unit2")          -- 是否友好
    UnitIsEnemy("unit1", "unit2")           -- 是否敌对
    UnitIsPlayer("unit")                    -- 是否玩家
    UnitInParty("unit")                     -- 是否在小队
    UnitInRaid("unit")                      -- 是否在团队
    UnitIsUnit("unit1", "unit2")            -- 是否同一单位
    UnitGUID("unit")                        -- 全局唯一标识符
    UnitCanAttack("unit1", "unit2")         -- 是否可攻击
    UnitCanAssist("unit1", "unit2")         -- 是否可协助

常用 unit 标识：`"player"`, `"target"`, `"targettarget"`, `"focus"`, `"pet"`, `"party1"`~`"party4"`, `"raid1"`~`"raid40"`, `"mouseover"`

---

## 2. 法术/施法

    GetSpellInfo(spellID or spellName)      -- 名字, 排名, 图标, 施法时间, 最小距离, 最大距离...
    GetSpellTexture(spellID or spellName)   -- 法术图标纹理路径
    IsSpellKnown(spellID)                   -- 是否已学
    IsSpellInRange(spellID or spellName, "unit")  -- 1=在范围内, 0=超出范围, nil=无效
    GetSpellCooldown(spellID)               -- startTime, duration, enabled
    IsUsableSpell(spellID or spellName)     -- 是否可用（法力够、不在冷却等）
    GetNumSpellTabs()                       -- 法术书页签数
    GetSpellTabInfo(tabIndex)                -- 名称, 图标纹理, 偏移, 精通书页
    CastSpell(spellID, "unit")              -- 安全版本（仅限安全代码中调用）

光环查询（推荐 AuraUtil）：

    AuraUtil.ForEachAura("unit", "HELPFUL|HARMFUL", nil, function(...)
        -- name, icon, count, debuffType, duration, expirationTime, source, isStealable,
        -- nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer
    end)

    -- 或使用索引查询
    C_UnitAuras.GetAuraDataByIndex("unit", index, filter)

---

## 3. 物品/背包

    C_Container.GetContainerNumSlots(bagID)                    -- 背包格数（0=背包, 1~4=其他包）
    C_Container.GetContainerNumFreeSlots(bagID)                -- 空闲格数
    C_Container.GetContainerItemInfo(bagID, slotID)            -- 返回物品信息表
    C_Container.GetContainerItemLink(bagID, slotID)            -- 物品链接
    C_Container.PickupContainerItem(bagID, slotID)             -- 拾取物品
    C_Container.UseContainerItem(bagID, slotID)                -- 使用物品（安全操作）
    C_Container.SplitContainerItem(bagID, slotID, amount)      -- 分裂堆叠

    C_Item.GetItemInfo(itemID or itemLink)                     -- 完整物品信息
    C_Item.GetItemInfoInstant(itemID)                          -- 即时可用信息（名称/图标/质量等）
    C_Item.IsEquippableItem(itemID)                            -- 是否可装备
    C_Item.GetItemIconByID(itemID)                             -- 物品图标

物品链接颜色编码：

    -- |cffRRGGBB|Hitem:itemID:enchant:gem1:gem2:gem3:suffixID:uniqueID:level:specID:upgradeID|H[name]|h|r
    local _, _, itemID = string.find(itemLink, "|Hitem:(%d+):")

---

## 4. 玩家/角色

    UnitLevel("player")                       -- 等级
    GetRealmName()                            -- 服务器名
    GetPlayerInfoByGUID(guid)                 -- 返回名字, 服务器, 种族, 性别, 类, 英文类, 地区
    UnitXP("player")                          -- 当前经验值
    UnitXPMax("player")                       -- 升级所需经验
    GetMoney()                                -- 金币（铜币单位）
    GetGuildInfo("player")                    -- 公会名, 公会等级, 公会位阶
    GetSpecialization()                       -- 当前专精ID（如有）
    IsInGuild()                               -- 是否在公会中
    IsInGroup()                               -- 是否在小队
    IsInRaid()                                -- 是否在团队
    GetNumGroupMembers()                      -- 队伍/团队人数

---

## 5. 聊天/消息

    SendChatMessage(msg, chatType, language, target)
        -- chatType: "SAY", "YELL", "WHISPER", "PARTY", "RAID", "GUILD", "OFFICER"

    C_ChatInfo.SendChatMessage(msg, chatType)   -- 新版发送接口

    print("调试消息")                             -- 输出到默认聊天窗口
    DEFAULT_CHAT_FRAME:AddMessage("消息")        -- 输出到主聊天窗口

聊天事件参数（CHAT_MSG_*）：
- `CHAT_MSG_WHISPER`：msg, fullName, languageName, channelName, ...
- `CHAT_MSG_PARTY`：msg, author, ...
- `CHAT_MSG_RAID`：msg, author, ...
- `CHAT_MSG_SAY`：msg, author, ...
- `CHAT_MSG_YELL`：msg, author, ...
- `CHAT_MSG_GUILD`：msg, author, ...
- `CHAT_MSG_SYSTEM`：msg, ...

---

## 6. 地图/坐标

    C_Map.GetBestMapForUnit("unit")                  -- 获取单位所在地图 ID
    C_Map.GetPlayerMapPosition(mapID)                -- 返回 Vector2DMixin（有 :GetXY() 方法）
    C_Map.GetMapInfo(mapID)                           -- 地图信息表
    C_Map.WorldMapFrame_GetMapID()                    -- 当前世界地图 ID
    C_Map.SetMapByID(mapID)                           -- 设置当前地图上下文
    C_Map.GetMapLevel(mapID)                          -- 地图推荐等级

获取玩家世界坐标：

    local uiMapID = C_Map.GetBestMapForUnit("player")
    if uiMapID then
        local pos = C_Map.GetPlayerMapPosition(uiMapID)
        if pos then
            local x, y = pos:GetXY()
            print(string.format("坐标: %.1f, %.1f", x * 100, y * 100))
        end
    end

---

## 7. 任务

    C_QuestLog.GetNumQuestLogEntries()               -- 任务日志条目数
    C_QuestLog.GetQuestLogTitle(index)                -- 标题, 等级, 已推荐, 重复, 频繁...
    C_QuestLog.GetQuestLogQuestText(index)            -- 描述, 目标
    C_QuestLog.GetSelectedQuest()                     -- 当前选中的任务 ID
    C_QuestLog.SetSelectedQuest(index)                -- 选中任务

    C_QuestInfo.GetQuestInfo(questID)                 -- 任务详细信息

    C_Timer.After(0.1, function()                    -- 延迟执行（推荐替代 CreateFrame hack）
        -- 需要在下一帧查询的任务信息
    end)

---

## 8. 团队/副本

    GetNumGroupMembers()                              -- 队伍人数
    IsInRaid()                                        -- 是否在团队
    IsInGroup()                                        -- 是否在小队
    UnitInRaid("unit")                                -- 是否在团队中
    UnitGroupRolesAssigned("unit")                    -- 指定角色 "TANK"/"HEALER"/"DAMAGER"

    -- 团队副本信息
    local name, type, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance = GetInstanceInfo()

---

## 9. UI/框架

    CreateFrame("frameType" [, "name" [, parent [, "template"]]])
        -- frameType: "Frame", "Button", "ScrollFrame", "Slider", "EditBox", "StatusBar", "Cooldown", "CheckButton"
        -- template: "SecureActionButtonTemplate", "UIPanelButtonTemplate", etc.

    frame:SetPoint("point", relativeTo, "relativePoint", x, y)
        -- point: "TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "CENTER", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT"

    frame:SetSize(width, height)
    frame:SetWidth(width) / frame:SetHeight(height)
    frame:Show() / frame:Hide()
    frame:SetScript("handler", function)              -- OnClick, OnEnter, OnLeave, OnEvent, OnUpdate, etc.
    frame:SetBackdrop(backdropTable)
    frame:SetBackdropColor(r, g, b, a)
    frame:SetBackdropBorderColor(r, g, b, a)
    frame:RegisterEvent(event)
    frame:UnregisterEvent(event)
    frame:UnregisterAllEvents()

创建纹理：

    local tex = frame:CreateTexture(nil, "ARTWORK")
    tex:SetTexture("path/to/texture")
    tex:SetPoint(...)
    tex:SetSize(width, height)
    tex:SetColorTexture(r, g, b, a)                  -- 纯色填充
    tex:SetVertexColor(r, g, b, a)                    -- 色调
    tex:SetAlpha(0.5)                                 -- 透明度

创建字体字符串：

    local fs = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetPoint("CENTER")
    fs:SetText("文本")
    fs:SetTextColor(1, 1, 0, 1)                       -- 黄色

---

## 10. 工具函数

    C_Timer.After(delay, callback)                    -- 延时执行
    hooksecurefunc([table,] functionName, hookfunc)    -- 安全 hook
    IsAddOnLoaded("AddOnName")                        -- 插件是否已加载
    LoadAddOn("AddOnName")                            -- 加载插件
    GetAddOnInfo(index)                               -- 插件信息
    GetAddOnMetadata("AddOnName", field)              -- 插件元数据
    GetTime()                                         -- 当前时间（秒）
    date("%H:%M:%S")                                  -- 格式化日期
    GetFPS()                                          -- 帧率
    GetBuildInfo()                                    -- 版本号信息

---

## 11. 数学/字符串

    -- Lua 标准库
    math.floor(x), math.ceil(x), math.abs(x), math.max(a, b, ...), math.min(a, b, ...)
    math.random(min, max), math.randomseed(seed)
    string.format("%s 等级 %d", name, level)
    string.len(s), string.sub(s, i, j), string.find(s, pattern)
    string.gsub(s, pattern, replacement)
    strsplit(delimiter, string)                        -- WoW 扩展：分割字符串
    strjoin(delimiter, ...)                            -- WoW 扩展：连接字符串
    strtrim(s)                                         -- WoW 扩展：去除首尾空白

颜色转换：

    -- RGBA (0-1) → Hex
    function RGBToHex(r, g, b)
        return string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
    end
    -- |cffRRGGBB 文本 |r

---

## 12. SavedVariables

在 TOC 中声明：

    ## SavedVariables: MyAddonDB
    ## SavedVariablesPerCharacter: MyAddonCharDB

在代码中访问：

    local defaults = {
        profile = { enabled = true, alpha = 0.8 },
        char = { position = { x = 0, y = 0 } },
    }

    -- 首次加载初始化
    MyAddonDB = MyAddonDB or {}
    for k, v in pairs(defaults.profile) do
        if MyAddonDB[k] == nil then
            MyAddonDB[k] = v
        end
    end

推荐使用 SavedVariables 管理库（如 AceDB-3.0）自动处理默认值合并与配置迁移。如不使用第三方库，务必自行实现默认值合并逻辑。