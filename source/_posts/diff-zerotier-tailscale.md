---
title: ZeroTier和Tailscale的区别
author: Tokisaki Galaxy
date: 2025-04-20 13:53:45
excerpt: 对比了ZeroTier和Tailscale，分析了它们在协议、网络结构、连接稳定性等差异。
tags:
  - ZeroTier
  - Tailscale
  - VPN
  - Virtual LAN
  - Network
keywords: ZeroTier, Tailscale, VPN, Virtual LAN, Network, 对比, 区别
categories:
  - 网络技术
---

网上基本上没人说这两个有什么差别，其实实际使用的时候区别还是蛮大的。

先说结论，ZeroTier用的是私有协议，Tailscale用的是WireGuard。但是ZeroTier有点像玩具，Tailscale更完善。

## ZeroTier

ZeroTier 是一种虚拟局域网解决方案，它可以将不同地点的设备连接到同一个网络中，如同它们处于同一物理网络。

## Tailscale

Tailscale 是一种基于 WireGuard 的 VPN 解决方案，可以安全地连接您的设备和应用，无需复杂的防火墙配置。

### 协议以及网络结构

ZeroTier使用的是私有协议，Tailscale使用的是WireGuard。ZeroTier和Tailscale都提供自定义中继服务器，分别是MOON和DERP服务器。
在网络结构上，ZeroTier是一个P2P网络，Tailscale是一个Mesh网络。

### 连接稳定性(最大区别)

Tailscale的稳定性比ZeroTier要好的多。
 - Tailscale在网络中，如果对其他节点没有数据交互，会设置为idle状态，在开始数据交换，会先由DERP服务器进行中转，**同时**开始尝试进行NAT穿透。对于客户端，可以通过`tailscale status`命令来查看连接状态。
 - ZeroTier在网络中，默认会尝试对所有节点进行连接，并直接进行NAT穿透。ZeroTier的MOON服务器会在连接不稳定的时候，自动进行中转。对于客户端，可以通过`zerotier-cli peers`命令来查看连接状态。

{% note warning %}
但是ZeroTier的MOON服务器只提供UDP中继，默认不提供TCP中继！
如果要使用TCP中继，需要自行编译源代码并且配置，非常麻烦。
而UDP中继在国内网络环境下，基本上不可用的，这就导致如果显示为REPLYING的节点，基本上无法连接。
{% endnote %}

**这就导致了ZeroTier中，如果双方有任意一方在较差的网络环境下，连接会非常不稳定，甚至无法连接。而Tailscale则不会出现这种情况。**

### 穿透NAT(速度)

ZeroTier的私有协议在穿透NAT方面做得非常好，Tailscale的WireGuard没有ZeroTier好。

### 安全性

都差不多，对普通人没啥区别。
