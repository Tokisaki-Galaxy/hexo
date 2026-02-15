---
title: 现代化 LuCI 插件开发方案：AI Agent 集成 Playwright 和 Docker 全自动开发
date: 2026-01-29 20:09:38
author: Tokisaki Galaxy
excerpt: 通过 GitHub Copilot Agent 集成 Playwright 和 Docker 实现的现代化 LuCI 插件开发方案，显著提升开发效率和测试覆盖率。
tags:
  - openwrt
  - luci
  - github-copilot
  - playwright
  - agent
categories: openwrt
---

OpenWrt 的 LuCI 插件开发一直存在环境搭建复杂、UI 调试效率低、跨平台编译繁琐等问题，导致开发周期极长。

最近发现 GitHub Copilot 可以预装测试环境软件包，更改`copilot-instrument.md`来实现自定义agent行为，于是尝试将其与 Playwright 和 Docker 结合，打造了一套现代化的 LuCI 插件开发方案。

该方案集成 AI 辅助代码生成（playwright docker）、自动化 UI 测试和全自动 CI/CD 构建发布流水线，大幅提升开发效率

已经成功运用于多个 LuCI 插件项目中，如 [luci-app-2fa](https://github.com/tokisaki-galaxy/luci-app-2fa) 和 [luci-app-tailscale-community](https://github.com/tokisaki-galaxy/luci-app-tailscale-community)。

## AI 辅助开发：让 Copilot 理解 OpenWrt

在编写 LuCI 后端代码（如 ucode 或 Lua）时，AI 生成内容容易出现理解偏差。通过在项目目录下配置 `copilot-instructions.md`，可以为 AI 预设一套开发规范。

这份指令集包括：

 - 全自动调试指令：告诉 AI 如何在 Docker 容器中编译、部署和测试插件。
 - 服务启动顺序：明确 `ubusd`、`procd`、`rpcd`、`uhttpd` 的依赖关系，避免页面报错。
 - 路径映射：帮助 AI 理解源码与 OpenWrt 文件系统（如 `/www/luci-static`）的对应关系。
 - 开发规范：定义代码风格与openwrt/luci类似、注释要求和最佳实践。

## 自动化 UI 测试：Playwright + Docker

为了确保插件在不同 OpenWrt 版本下的 UI 渲染一致，引入 Playwright 进行端到端测试。通过 Docker 容器模拟完整的 LuCI 环境，Agent 可自动登录、截图并验证页面效果，大幅减少手动测试时间。


| Login Page | 2FA Verification | Invalid OTP |
|------------|------------------|-------------|
| ![login](https://github.com/user-attachments/assets/7b8e4cfb-1f06-4c3f-b63a-1ba23a01be86) | ![2fa](https://github.com/user-attachments/assets/a95d879e-b404-423b-95ca-2230b696a243) | ![error](https://github.com/user-attachments/assets/56399325-ebfb-46c9-aeb4-f162e27b99ce) |
[来源自 luci-app-2fa #3](https://github.com/Tokisaki-Galaxy/luci-app-2fa/pull/3)

相关配置可在 `copilot-instructions.md` 中定义，适用于如 `luci-app-tailscale-community` 这类复杂应用。

## 全自动 CI/CD 构建流水线

本项目模板内置 GitHub Actions 配置文件 `build.yml`，实现：

- 多格式并行编译：同时支持 IPK 和 APK 格式。
- 动态版本管理：基于 Git Tag 或 Commit Hash 自动注入 `PKG_VERSION`。
- 自动签名与托管：构建后自动使用 `usign` 签名，并部署至 GitHub Pages，生成可直接用于 OpenWrt 的 OPKG 软件源。

## 快速开始

你可以直接使用本模板快速创建项目：

👉 [Tokisaki-Galaxy/openwrt-template](https://github.com/Tokisaki-Galaxy/openwrt-template)

核心配置文件：

- 构建逻辑：`build.yml`
- AI 指令集：`copilot-instructions.md`
- 测试 Mock：`handlers.js`

通过结合 AI Agent 的生成能力与端到端测试的验证能力，LuCI 插件的开发协作与分发效率将显著提升。欢迎在 GitHub Discussion 参与交流。

## 案例
 - [luci-app-2fa](https://github.com/tokisaki-galaxy/luci-app-2fa)
 - [luci-app-tailscale-community](https://github.com/tokisaki-galaxy/luci-app-tailscale-community)

### PR 示例
 - [Integrate 2FA verification into LuCI login flow #3](https://github.com/Tokisaki-Galaxy/luci-app-2fa/pull/3)
 - [Add LuCI auth plugin mechanism for 2FA login enforcement #4](https://github.com/Tokisaki-Galaxy/luci-app-2fa/pull/4)
 - [feat: Revive luci-app-2fa from openwrt/luci PR #7069 #1](https://github.com/Tokisaki-Galaxy/luci-app-2fa/pull/1)

## 技术细节

- SDK 环境：基于 `openwrt/rootfs:x86-64-23.05.5` 镜像
- 主要工具：ucode、ubus、rpcd、Playwright
