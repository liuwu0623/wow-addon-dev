# SecureActionButton 完整指南

3.80.1 中，直接在非安全代码中调用施法/使用物品等受保护函数已被禁止。`SecureActionButtonTemplate` 是唯一的合规替代方案。

## 目录

1. [基本原理](#1-基本原理)
2. [创建基本安全按钮](#2-创建基本安全按钮)
3. [type 属性详解](#3-type-属性详解)
4. [条件修饰键](#4-条件修饰键)
5. [常见模式](#5-常见模式)
6. [与宏命令结合](#6-与宏命令结合)
7. [注意事项](#7-注意事项)

---

## 1. 基本原理

SecureActionButtonTemplate 继承自 SecureButtonTemplate，通过 attribute（属性）系统声明行为，在安全环境中执行受保护动作。

核心流程：
1. 用 `CreateFrame("Button", name, parent, "SecureActionButtonTemplate")` 创建按钮
2. 用 `SetAttribute` 设置行为属性
3. 玩家点击按钮时，游戏在安全环境中执行对应动作

属性设置可以在安全代码（OnLoad 等）或非安全代码中完成，但读取和执行发生在安全环境中。

---

## 2. 创建基本安全按钮

### 施法按钮

    local btn = CreateFrame("Button", "MySpellBtn", UIParent, "SecureActionButtonTemplate, UIMenuButtonStretchTemplate")
    btn:SetSize(80, 30)
    btn:SetPoint("CENTER", 0, -100)
    btn:SetText("施放复活术")

    btn:SetAttribute("type", "spell")
    btn:SetAttribute("spell", "复活术")
    btn:SetAttribute("unit", "target")

点击此按钮 = 对当前目标施放复活术。

### 使用物品按钮

    local btn = CreateFrame("Button", "MyItemBtn", UIParent, "SecureActionButtonTemplate")
    btn:SetAttribute("type", "item")
    btn:SetAttribute("item", "治疗石")
    btn:SetAttribute("unit", "player")

### 执行宏按钮

    local btn = CreateFrame("Button", "MyMacroBtn", UIParent, "SecureActionButtonTemplate")
    btn:SetAttribute("type", "macro")
    btn:SetAttribute("macrotext", "/cast 复活术\n/y 正在复活 %t!")

---

## 3. type 属性详解

| type 值 | 说明 | 需要的附加属性 |
|----------|------|---------------|
| `"spell"` | 施放法术 | `spell`（法术名/ID）, `unit`（目标单位） |
| `"item"` | 使用物品 | `item`（物品名/ID/link）, `unit` |
| `"macro"` | 执行指定宏 | `macro`（宏名） |
| `"macrotext"` | 执行宏文本 | `macrotext`（宏文本内容） |
| `"action"` | 执行动作条槽位 | `action`（槽位编号） |
| `"target"` | 切换目标 | `target`（单位标识，如 "target", "focus"） |
| `"focus"` | 设置焦点 | `target` |
| `"assist"` | 协助目标 | `target` |
| `"click"` | 模拟点击另一个按钮 | `clickbutton`（要点击的按钮名） |

---

## 4. 条件修饰键

SecureActionButton 支持根据修饰键改变行为。格式：`<modifier>-<button>-<attribute>`

    -- 默认行为：对目标施放
    btn:SetAttribute("type", "spell")
    btn:SetAttribute("spell", "治疗术")
    btn:SetAttribute("unit", "target")

    -- Alt+左键：对自己施放
    btn:SetAttribute("alt-type1", "spell")
    btn:SetAttribute("alt-spell1", "治疗术")
    btn:SetAttribute("alt-unit1", "player")

    -- Shift+左键：施放快速治疗
    btn:SetAttribute("shift-type1", "spell")
    btn:SetAttribute("shift-spell1", "快速治疗")
    btn:SetAttribute("shift-unit1", "target")

    -- Ctrl+右键：施放守护之魂
    btn:SetAttribute("ctrl-type2", "spell")
    btn:SetAttribute("ctrl-spell2", "守护之魂")
    btn:SetAttribute("ctrl-unit2", "target")

修饰键组合：
- `alt-` / `ctrl-` / `shift-`
- 可以组合：`alt-ctrl-type1`
- 按钮编号：`1` = 左键，`2` = 右键，`3` = 中键

---

## 5. 常见模式

### 模式 1：智能施法按钮

根据目标是否存在，自动选择对自己还是目标施法：

    local btn = CreateFrame("Button", "SmartHealBtn", UIParent, "SecureActionButtonTemplate")
    btn:SetPoint("CENTER")

    -- 使用 HARMFUL/HELPFUL 检查单位类型
    -- 注意：条件判断需在安全环境中完成，推荐用 securestateDriver

    btn:SetAttribute("type", "spell")
    btn:SetAttribute("spell", "治疗术")
    btn:SetAttribute("unit", "target")

    -- 注册状态驱动器，根据目标友好度自动切换
    RegisterStateDriver(btn, "targethelp", "[help] true; false")

    btn:SetAttribute("unit-targethelp-true", "target")
    btn:SetAttribute("unit-targethelp-false", "player")

### 模式 2：多法术轮转按钮

点击切换不同法术（利用 `type = "action"` 配合 `action` 循环）：

    local btn = CreateFrame("Button", "CycleSpellBtn", UIParent, "SecureActionButtonTemplate")
    btn:SetSize(40, 40)

    -- 使用 SecureHandler 实现点击轮转
    -- 更高级的用法需配合 SecureHandlerBaseTemplate
    -- 简单方案：预设多个修饰键对应不同法术

    btn:SetAttribute("type", "spell")
    btn:SetAttribute("spell", "圣光术")         -- 默认
    btn:SetAttribute("shift-spell1", "圣光闪现")  -- Shift+左键
    btn:SetAttribute("ctrl-spell1", "神圣震击")   -- Ctrl+左键
    btn:SetAttribute("alt-spell1", "圣光信标")    -- Alt+左键

### 模式 3：宠物技能按钮

    local petBtn = CreateFrame("Button", "PetSkillBtn", UIParent, "SecureActionButtonTemplate")
    petBtn:SetAttribute("type", "spell")
    petBtn:SetAttribute("spell", 416748)  -- 使用法术 ID
    petBtn:SetAttribute("unit", "pet")

---

## 6. 与宏命令结合

### 替代旧版 /cast 宏

旧版（3.80.0 之前，通过 Lua 调用会报错）：

    /cast [mod:alt,@player] [help] 治疗术; 快速治疗

3.80.1 安全写法：

    local btn = CreateFrame("Button", "SmartCastBtn", UIParent, "SecureActionButtonTemplate")
    -- 默认：快速治疗
    btn:SetAttribute("type1", "spell")
    btn:SetAttribute("spell1", "快速治疗")
    -- Alt：对自己施放治疗术
    btn:SetAttribute("alt-type1", "spell")
    btn:SetAttribute("alt-spell1", "治疗术")
    btn:SetAttribute("alt-unit1", "player")

### 使用 macrotext 实现复杂条件

    local btn = CreateFrame("Button", "ComplexMacroBtn", UIParent, "SecureActionButtonTemplate")
    btn:SetAttribute("type", "macrotext")
    btn:SetAttribute("macrotext", "/cast [target=focus] 治疗术")

    -- 带 Shift 变体
    btn:SetAttribute("shift-macrotext", "/cast [target=targettarget] 快速治疗")

---

## 7. 注意事项

1. **属性设置时机**：可以在 `PLAYER_LOGIN` 事件中设置属性，无需在 OnLoad 中完成
2. **法术 ID vs 法术名**：优先使用法术名，更稳定；使用法术 ID 时注意版本兼容
3. **SecureStateDriver**：`RegisterStateDriver` 可以让按钮根据条件（姿态、目标等）自动切换状态
4. **hook 限制**：安全属性不能通过 `hooksecurefunc` 修改，因为执行时无法获取非安全上下文
5. **不受限操作**：打印消息、更新 UI 外观、读写 SavedVariables 等非保护操作仍可在普通 Lua 中自由执行
6. **调试**：使用 `/dump` 检查按钮属性：`/dump MySpellBtn:GetAttribute("type")`