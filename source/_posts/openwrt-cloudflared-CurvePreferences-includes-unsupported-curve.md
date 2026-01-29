---
title: cloudflare出现了CurvePreferences-includes-unsupported-curve错误
date: 2024-5-18 16:10:40
author: Tokisaki Galaxy
excerpt: Openwrt上面的cloudflare在新版时出现了CurvePreferences-includes-unsupported-curve错误
tags: 
 - cloudflare
 - tunnel
 - openwrt
categories: openwrt
---

## 问题

在Openwrt的cloudflared中，当你使用新版本时（2024年3月或者4月开始），可能会出现`CurvePreferences includes unsupported curve`错误，这是因为新版本的cloudflared使用了新的加密算法，而这个要求Go构建工具链的更新。
而Openwrt上的cloudflared并没有更新工具链，所以会出现这个错误。

## 解决方法

目前解决方法可以通过使用旧版本的cloudflared（不推荐），或者修改参数让它只使用HTTP2协议，而不是默认的QUIC协议。

修改运行参数，加上`--protocol http2`。如果不加，默认是使用auto，但是那个auto只会使用QUIC协议来链接，无法自动切换到HTTP2，只会报`CurvePreferences includes unsupported curve`，然后访问时候提示`Argo ERROR`。

提及的Issues
https://github.com/openwrt/packages/issues/23852
https://github.com/cloudflare/cloudflared/issues/1158