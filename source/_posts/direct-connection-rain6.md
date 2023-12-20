---
title: 裸连R6
author: Tokisaki Galaxy
top: false
cover: false
toc: true
comments: true
mathjax: false
noindex: false
sitemap: true
date: 2020-11-22 13:02:03
img:
coverImg:
excerpt: 裸连r6
tags:
 - 游戏
 - 彩虹六号
 - 中国移动
categories: 游戏
password:
---

>* 本方法并不保证一定可行，只是根据我的个人实际经历编写
>* 本方法无法完全代替加速器，只是提供一种省钱（不用加速器）的方法

**本方法只是提供不使用加速器连接到服务器，游玩彩六的一种方法，实际使用效果并不比加速器好。打开游戏时的连接到服务器和加载对战列表需要2,3分钟，每次对战结束都要等一分钟回到主页面**

*但是不用加速器就代表省钱啊，我最喜欢不要钱的东西了*

上个星期刚重装完系统，结果发现加速器加速之后彩六语音用不了（腾讯加速器），但是上周有VIP，又不是不能玩，所以就没管它。但是这个星期加速器到期了，只好去修复一下NAT类型碰碰运气，看看能不能裸连上去。

> 话说腾讯加速器是真的恶心，加速效果堪比三流加速器，而且还整什么VIP和SVIP。。

> 插句题外话，育碧的阿三客服真的睿智，上周周日晚上跟我说什么由于恶劣行为永久封禁，然后周一发个工单，周三还不回，周三再发一个，周五才解决封禁，然后最后跟我说什么“出于技术原因，您的账号被误封了。”，害我在学校担心了一个星期。。。

按下WIN+I打开设置，进入游戏->Xbox网络，等圈圈转完之后查看`Xbox Live多人游戏`那一栏，`NAT类型`如果是**开放**，请按下CTRL+W，这篇博客对你没用。

我的ISP是移动，当时是看他宽带便宜装的，结果玩游戏比同学的电信差了一大截。移动在你的入户路由外面又套了层小区（或者城区）的大型局域网，所以被人称作墙中墙~~2333~，导致游戏很难连上处在国外的服务器。

首先点击`Xbox Live多人游戏`最下面的修复，并重启电脑后重新检查`NAT类型`是否已经变为开放，如果这样就能解决，那么自然皆大欢喜。

## 手动启用teredo
如果很不幸的（事实上大部分人都没法通过简单的修复按钮修复）无法修复，那需要手动启用teredo。

打开powershell或者cmd，输入

```shell
netsh interface Teredo set state servername=default
netsh interface Teredo set state type=natawareclient
```

// 网上有人说`natawareclient`比`enterpriseclient`更适合家庭使用，如果`natawareclient`不行就试试`enterpriseclient`。

重启电脑，再次查看NAT类型

我自己到这里就已经解决了，并且彩六里语音也可以使用了（惊喜）。
