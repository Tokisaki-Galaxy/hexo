---
title: Kindle 浏览器 User-Agent 切换工具
date: 2025-12-30 10:28:10
author: Tokisaki Galaxy
excerpt: 针对 Kindle 内置浏览器强制跳转移动版页面的问题，开发了基于 KUAL 的 UA 修改插件，实现桌面端网页的完整访问。
tags:
 - Kindle
 - KUAL
 - 浏览器
categories:
 - Kindle
---

{% note danger %}
修改系统文件存在潜在风险。操作前请务必备份重要数据。
{% endnote %}

{% note info %}
开源仓库：[Tokisaki-Galaxy/kindle-modify-browserUA](https://github.com/Tokisaki-Galaxy/kindle-modify-browserUA)
{% endnote %}

## 开发背景

Kindle 内置浏览器在访问现代网页被识别为移动设备。这导致页面功能缺失或强制重定向至简陋的移动版。
亚马逊在 5.16.4 版本固件中引入了 Chromium 内核。在新的浏览器内核下，基本上可以获得与电脑浏览器相似的体验。我购买KPW5原本就是为了在kindle上看小说，但是没想到贴吧居然强制跳转到移动版，导致无法正常使用。于是找了好久，找到了修改为电脑版User-Agent的方法，以便访问完整的网页内容。

## 核心特性

### 桌面模式伪装
系统支持一键将 UA 修改为 Windows 10 Edge 字符串。网页服务端将识别设备为桌面电脑。用户可直接访问完整的桌面版布局。

### 状态实时监测
集成 `status.sh` 脚本。用户可通过 KUAL 界面直接查看当前生效的 UA 类型。确保修改状态透明可查。

### 无损还原机制
系统保留原始 UA 配置。用户可随时通过菜单恢复 Kindle 默认设置。操作过程安全可逆。

## 工作原理

插件通过修改系统路径 `/usr/bin/browser` 实现。脚本在执行时自动获取 `mntroot rw` 读写权限。修改完成后系统将自动重启。新配置将在浏览器启动时生效。

## 安装与操作

### 前提条件
*   设备已完成越狱。
*   已安装 KUAL (Kindle Unified Application Launcher)。
*   固件版本不低于 5.16.4。

### 部署步骤
1.  下载项目压缩包。
2.  将 `modify-browserUA` 文件夹拷贝至 Kindle 的 `extensions` 目录。
3.  在 KUAL 菜单中找到 `modify browserUA` 选项。

### 功能菜单
* Change to Desktop UA：切换至桌面模式。
* Status：查询当前 UA 状态。
* Restore：还原系统默认设置。
