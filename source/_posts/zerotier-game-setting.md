---
title: 使用ZeroTier搭建游戏局域网环境
date: 2025-2-4 17:32:19
author: Tokisaki Galaxy
excerpt: 优化用于游戏的ZeroTier，解决常见的连接问题
tags: 
- ZeroTier
- 游戏
- 网络
categories: 
- 教程
---

## 前言

ZeroTier是一个非常好用的软件定义局域网SDN，但在用来玩局域网游戏时可能会遇到一些问题，比如无法发现其他玩家或连接延迟高。

## 服务器端配置

### 1. 启用网络广播

要让游戏能够自动发现其他玩家，需要在ZeroTier网络设置中启用广播和组播：

1. 登录管理面板（或者是ztncui）
2. 添加新路由
3. 添加以下两条路由规则：
   - 目标: `255.255.255.255/32`，via: `0.0.0.0`（启用广播）
   - 目标: `224.0.0.0/4`，via: `0.0.0.0`（启用组播）

> 注意：虽然广播会降低网络效率，但对于游戏发现功能来说是必需的。

### 2. 优化MTU设置

大多数家用网络的MTU为1500（PPPoE环境下为1492），需要调整ZeroTier的MTU以避免数据包分片：

```bash
# 进入ZeroTier配置目录
sudo su
cd /var/lib/zerotier-one/controller.d/network
# 修改目录下所有json网络配置文件中的MTU值
# 使用文本编辑器打开.json文件，将"mtu":2800改为"mtu":1492
```

## 客户端配置

### 1.安装WindowsIPBroadcast

某些游戏（文明6）只在第一个网络适配器上面广播，需要第三方软件广播到全部适配器上，WindowsIPBroadcast可以解决这个问题：
[GitHub仓库](https://github.com/dechamps/WinIPBroadcast)下载最新版本

### ~~2.加钱上moon服务器~~