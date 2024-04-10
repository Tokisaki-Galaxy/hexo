---
title: ZeroTier原理与实践
date: 2024-4-10 13:27:51
author: Tokisaki Galaxy
excerpt: ZeroTier的网络原理和一点点实践经验
tags:
 - Argo
 - ZeroTier
 - cloudflare
 - ztncui
 - 路由
 - Planet
 - ZeroTier
categories: 学习
---

## 前言

因为网络上这方面的信息很少，我在使用的时候有时摸不着头脑，所以写下来供后人参考。
[ZeroTier协议议定书](https://docs.zerotier.com/protocol)，下面简称议定书。截止本文书写日期2024/04/11，现在处于v1版本，v2版本据说会大改，但是已经放卫星放四年了，而且这种网络基础设施应该会保持向下兼容，故信息大体上应该长期有效，细枝末节以当前版本为准。


### 什么是Planet

> To achieve this VL1 is organized like DNS. At the base of the network is a collection of always-present root servers whose role is similar to that of DNS root name servers. Roots run the same software as regular endpoints but reside at fast stable locations on the network and are designated as such by a world definition. World definitions come in two forms: the planet and one or more moons. The protocol includes a secure mechanism allowing world definitions to be updated in-band if root servers' IP addresses or ZeroTier addresses change.
> There is only one planet. Earth's root servers are operated by ZeroTier, Inc. as a free service. There are currently four root servers distributed across the globe and multiple network providers. Almost everyone in the world has one within less than 100ms network latency from their location.

*其实我觉得ZeroTier里面的Planet和流浪地球电影版里面的全球根服务器非常非常相似*

在ZeroTier世界里面，一切以Planet中心为主，可以理解成DNS里面的根服务器（他们也确实这么称呼，在议定书里面称为RootServers）。所有节点在联网的时候都会去尝试连接Planet来获得其他节点的信息。官方提供的Planet服务器是免费的。
Planet的功能包括，**记录所有联网节点网络信息**（记住这个），记录节点互联所使用的密钥并提供交换服务，在节点无法互相直连的情况下提供中继。

ZeroTier公司提供收费服务的**只有网页端的[Controller](https://my.zerotier.com)**。其中的25个设备限制我们只需要自行建立Controller即可绕过，**但是**自建的Controller没有SSO，Ruler之类的功能。

zerotier在初次启动的时候会从Planet获得所有所需要的连接信息，首先会尝试通过ID定位Moon（如果设置）信息，并且缓存下来，如果无法连接到Planet会连接到缓存的Moon。

### 什么是Moon
Planet和Moon的关系可以理解成Moon是自己建立的Private Root Servers。功能**基本上**和Planet是完全一致的。
如果你[选择自建Moon服务器](https://docs.zerotier.com/roots)，Moon服务器为了保证稳定性，官方建议不再承担其他网络功能（作为LEAF之类的）。所以意味着只要你知道别人的Moon服务器ID，**可以直接加入，不需要对方同意。**

#### 加入Moon方式
```bash
zerotier-cli orbit <world ID> <seed> - Join a moon via any member root
#一般情况下world ID和seed可以一样
```

## 链路层结构
ZeroTier链路层分为VL1和VL2。
VL1称为点对点网络，只用于连接到基础设施Planet和Moon，以获取网络配置。在大部分情况是零配置，不需要关注。
VL2称为以太网虚拟层，是你自己通过my.zerotier.com或者自行构建Controller建立的网络
Planet/Moon 是 Zerotier VL1 层的设施，主要用来辅助 Peer 之间的连接建立。Controller 是 VL2 层的设施，主要用来保存虚拟网的配置。一个虚拟网中的设备首先要接入 VL1 与 Controller 沟通，最后才能接入 VL2 中的一个虚拟网。

## 节点类型
在执行`zerotier-cli peers`之后，其中`<role>`中可以看到每个节点的类型，这些类型是在VL1层中的角色。其中有LEAF,PLANET,MOON。
LEAF是普通的节点，**一般**是你的设备连上去之后会直接变成LEAF。

## Controller
Controller位于链路层的VL2中，在VL1中是一个特殊的LEAF。
如果你想加入一个网络，或连接这个网络上的其他节点，你首先需要连接这个网络对应的Controller。
如果无法连接到Controller，表现为一直显示为Request Configure（请求配置中）。

如果你认真看完上面的文字，你应该明白Controller是不需要有公网IP的，但是要求必须连接稳定。*为了这点，我自己是在Moon上面运行Controller，但是官方其实不建议这样做*
[ZeroTier官方提供了搭建Controller的方式](https://docs.zerotier.com/controller)，但是官方给出的是命令行的形式，已经有人套了个GUI，名字叫ztncui。

## ztncui搭建
https://key-networks.com/ztncui/
注意最好不要使用ZeroTier网络来访问搭建好的Controller，因为这样如果出问题很容易丢失访问权限。我建议用CloudFlare Tunnel来访问，还可以设置二步验证，增强安全性。
ztncui默认是https协议，没有http协议，其证书是自签的。使用Cloudflare Tunnel来映射到域名访问，需要在Cloudflare里面设置要开启运行任意证书（因为默认Tunnel不认自签证书）才能正常访问。

下面是一些有用的快速脚本。

## 搭建moon的快速命令

```bash
cd /var/lib/zerotier-one
sudo su
#zerotier-idtool initmoon identity.public > moon.json
exit

#下面几行可以保存为一个脚本，之后只用改moon.json里面的stablePoint
zerotier-idtool genmoon moon.json
sudo mv 000000??????????.moon moons.d/
sudo systemctl restart zerotier-one
```
