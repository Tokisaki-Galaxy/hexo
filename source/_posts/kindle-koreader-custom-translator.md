---
title: KOReader 自定义翻译后端插件
date: 2025-12-16 20:56:33
author: Tokisaki Galaxy
excerpt: 通过自建 Cloudflare Worker 端点替换 KOReader 官方翻译接口，解决特定网络下的不可用问题。
tags:
 - KOReader
 - Kindle
 - Cloudflare Worker
 - 翻译
categories:
 - Kindle
---

项目地址 https://github.com/Tokisaki-Galaxy/kindle-koreader-custom-translator

## 背景

KOReader 原生 Google 翻译接口在部分网络环境下不可达。为保持自动检测、拼音/罗马音等原生体验，提供自定义后端替换方案。

默认使用Cloudflare Worker 上的AI模型`@cf/meta/m2m100-1.2b`进行翻译，如果需要可以通过自建方式，自行更换成其他模型，或提升速率限制。

## 核心思路

- 自定义端点：`CUSTOM_ENDPOINT` 指向 `translate.api.tokisaki.top`，可选代理 `translate-proxy.api.tokisaki.top`，但是代理可能会有延迟。
- 语言映射：`SUPPORTED_LANGUAGES` 覆盖 249 种语言。
- 配置入口：KUAL 动态菜单在 `menu.json`，插件元数据在 `config.xml`。
- 安装与恢复：`bin/install.sh`、`bin/use_proxy.sh`、`bin/restore.sh` 负责部署、切换与回滚。

## 文件结构

- `translator.lua`：请求改写与展示逻辑，向自定义端点发送 `{ text, targetLanguage, sourceLanguage }`。
- `menu.json`：KUAL 菜单项，支持直连与代理安装。
- `config.xml`：插件元信息。
- `bin/install.sh`：安装并自动备份原版文件。
- `bin/use_proxy.sh`：切换代理端点。
- `bin/restore.sh`：恢复官方 translator。

## 安装与使用

### Kindle + KUAL

1. 将项目放入 `/mnt/us/extensions/koreader-custom-translator/`。
2. KUAL → “KOReader Custom Translator” → **Install**。
3. 若直连受限，选择 **Install (Use Proxy API)**。

### 手动部署（Kobo/Android/Linux）

```sh
cd bin
sh install.sh                 # 自动检测 KOReader 路径
KO_DIR=/path/to/koreader sh install.sh  # 手动指定路径
```

## 代理与恢复

- 切换代理：`sh bin/use_proxy.sh`。
- 恢复官方：KUAL 选择 **Restore**，或运行 `sh bin/restore.sh`。

## 使用提示

- 升级 KOReader 后需重新执行安装脚本，避免官方更新覆盖 `translator.lua`。
- 确认设备可访问自定义端点；若不可达，可先试代理端点。
- 发生异常可使用自动生成的 `translator.lua.bak` 回滚。

## 结语

该插件在受限网络下提供稳定的翻译后端，同时保持 KOReader 原生语言检测与罗马音展示能力。直连与代理可按环境自由切换，更新与恢复均可一键完成。
