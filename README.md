# WoW Addon Dev — 魔兽世界时光服插件开发

面向魔兽世界时光服 **3.80.1** 版本的插件创建、迁移与修复技能。基于 2026-04-09 版本大更新后暴雪将 Classic API 大幅向正式服（Retail）对齐的背景编写。

## 适用场景

| 场景 | 说明 |
|------|------|
| 从零创建插件 | 提供完整的入门模板和开发流程 |
| 迁移旧插件 | 3.80.1 API 大洗牌后的接口替换与适配 |
| 修复插件报错 | 废弃 API 识别与替代方案查找 |
| 学习插件开发 | 参考文档覆盖常用 API、事件和安全按钮 |

## 目录结构

```
wow-addon-dev/
├── SKILL.md                              # 技能主文件（触发入口）
├── README.md                             # 本文件
├── assets/
│   └── starter-addon/                    # 可复制的入门插件模板
│       ├── StarterAddon.toc              #   TOC 元数据（Interface: 38001）
│       ├── Init.xml                      #   脚本加载入口
│       ├── StarterAddon.lua              #   主逻辑（命名空间、事件、调试）
│       ├── StarterAddon_Config.lua       #   Settings API 配置面板
│       ├── StarterAddon_CastButton.lua   #   SecureActionButton 施法按钮示例
│       └── StarterAddon_MiniMap.lua      #   可拖拽小地图图标示例
└── references/                           # 参考文档（按需加载）
        ├── wow-ui-source.md              #   官方 UI 源码索引（576 个 API 模块）
        ├── api-changes-3801.md           #   3.80.1 新增/废弃/替换 API 对照表
        ├── api-quick-ref.md              #   常用 Lua API 速查（按功能分类）
        ├── events.md                     #   常用事件列表与参数说明
        └── secure-action-button.md       #   SecureActionButton 完整用法指南
```

## 快速开始

将 `assets/starter-addon/` 目录复制到 WoW 安装目录下的 `Interface/AddOns/StarterAddon/`，启动客户端即可加载。使用 `/sa` 或 `/starteraddon` 打开配置面板。

## 核心版本信息

- **目标版本**：3.80.1（时光服 / Cataclysm Classic）
- **TOC Interface**：`38001`
- **API 体系**：正式服（Retail）对齐
- **SecureActionButton**：替代被限制的 `/cast` 宏命令
- **官方 UI 源码**：[Gethe/wow-ui-source](https://github.com/Gethe/wow-ui-source) — 暴雪官方 UI 源码镜像，含 576 个结构化 API 文档模块、废弃 API 兼容层和完整框架实现

## 技能触发关键词

制作插件、编写插件、创建插件、适配插件、修复插件、WoW 插件开发、Lua API、时光服插件、SecureActionButton