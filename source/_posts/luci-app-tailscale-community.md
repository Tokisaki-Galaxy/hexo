---
title: 在 OpenWrt 上优雅地管理 Tailscale：luci-app-tailscale-community
author: Tokisaki Galaxy
excerpt: 一个功能丰富的 LuCI 应用程序，用于在 OpenWrt 上无缝管理 Tailscale，提供直观的状态监控和强大的配置选项。
tags:
 - OpenWrt
 - Tailscale
 - LuCI
 - Network
date: 2025-10-19 15:31:50
categories:
 - 技术分享
 - 小玩具
---

## 2026/1/23
经过两三个月的代码审查[PR#8018](https://github.com/openwrt/luci/pull/8018)，`luci-app-tailscale-community` 已正式合并到 OpenWrt 主线 LuCI 仓库中，未来的发行版可以直接通过官方源安装该插件，无需额外操作。

另外，这是我第一次将个人项目成功合并到 OpenWrt 主线，感到非常荣幸！

---

## 项目地址
https://github.com/tokisaki-galaxy/luci-app-tailscale-community

## 简介

Tailscale 作为一种基于 WireGuard 的零配置 VPN，极大地简化了设备之间的安全连接。对于在 OpenWrt 路由器上运行 Tailscale 的用户来说，通过命令行进行管理虽然可行，但远不如图形化界面来得直观和高效。为了解决这一问题，我开发了 `luci-app-tailscale-community`，一个专为 OpenWrt LuCI 界面设计的 Tailscale 管理插件。

`luci-app-tailscale-community` 旨在提供一个原生集成、功能全面的 Web 界面，让用户可以轻松地监控 Tailscale 网络状态并调整各项配置，而无需登录 SSH。

### 核心功能概览

该插件将 Tailscale 的核心功能无缝集成到 LuCI 的“服务”菜单下，主要分为“状态”和“设置”两个部分。

#### 1. 状态仪表盘

提供对 Tailscale 网络健康状况的即时洞察：

*   **服务状态**: 清晰地显示 `tailscaled` 守护进程是“运行中”还是“未运行”。
*   **设备 IP**: 展示当前设备的 Tailscale IPv4 和 IPv6 地址。
*   **网络设备列表**: 以表格形式详尽列出 Tailnet 中的所有对等节点（Peers），包含以下关键信息：
    *   **在线状态**: 通过颜色标识节点是在线还是离线。
    *   **主机名与 DNS**: 显示设备的主机名和完整的 Tailscale DNS 名称。
    *   **连接类型**: 指明连接是“直连 (Direct)”还是通过“中继 (Relay)”，并显示中继服务器信息。
    *   **操作系统** 和 **Tailscale IP**。
    *   **最后在线时间**: 对于离线设备，显示其最后一次活跃的时间。

![状态页面截图](https://raw.githubusercontent.com/Tokisaki-Galaxy/luci-app-tailscale-community/refs/heads/master/image/status.png)

#### 2. 强大的设置管理

设置页面通过两个标签页，区分了即时生效的节点设置和需要重启服务的守护进程设置。

*   **节点设置 (Node Settings)**
    这些设置通过调用 `tailscale set` 命令实现，更改会立即生效，无需中断服务。支持的配置项包括：
    *   接受/通告路由 (`Accept Routes` / `Advertise Routes`)
    *   作为或使用出口节点 (`Advertise as Exit Node` / `Use Exit Node`)
    *   为子网路由启用 SNAT
    *   启用内置 SSH 服务器
    *   切换 `Shields Up` 模式以增强安全性
    *   设置自定义主机名

*   **守护进程环境设置 (Daemon Environment Settings)**
    这些高级选项通过修改 `tailscaled` 启动时的环境变量来实现，因此在保存后需要重启服务。
    *   **自定义 MTU**: 解决特定网络环境下的连接问题。
    *   **减少内存使用**: 针对内存有限的设备进行优化，通过设置 `GOGC=10` 环境变量，以少量 CPU 开销换取更低的内存占用。

![设置页面截图](https://raw.githubusercontent.com/Tokisaki-Galaxy/luci-app-tailscale-community/refs/heads/master/image/setting.png)

### 技术实现

`luci-app-tailscale-community` 主要使用 Lua 编写，并遵循 LuCI 的 MVC 架构。

*   **数据模型**: `luasrc/model/tailscale_data.lua` 是核心数据加载器。它通过执行 `tailscale status --json` 和 `tailscale ip` 命令获取实时状态，并解析 `/etc/tailscale/tailscaled.state` 文件以获取更详细的运行时配置。
*   **CBI 界面**: `luasrc/model/cbi/tailscale_status.lua` 和 `tailscale_settings.lua` 文件使用 LuCI 的 CBI (Configuration Binding Interface) 框架来构建用户界面，并将前端选项与后端配置和命令关联起来。
*   **配置应用**: 对于守护进程设置，插件会动态创建或更新位于 `/etc/profile.d/` 的一个 shell 脚本，确保在 `tailscaled` 服务启动时能加载正确的环境变量。

### 安装与使用

安装过程非常简单：

1.  **前提条件**: 确保您的 OpenWrt 设备已安装 `tailscale` 和 `coreutils-base64`。
    ```bash
    opkg update
    opkg install tailscale coreutils-base64
    ```
2.  **安装插件**: 从项目的 [GitHub Release](https://github.com/Tokisaki-Galaxy/luci-app-tailscale-community/releases) 页面下载最新的 `.ipk` 软件包，上传到路由器并使用 `opkg` 安装。
    ```bash
    opkg install luci-app-tailscale-community_*.ipk
    ```
**也可以从项目的action下载**
安装完成后，刷新 LuCI 页面，即可在“服务”菜单下找到“Tailscale”入口。
