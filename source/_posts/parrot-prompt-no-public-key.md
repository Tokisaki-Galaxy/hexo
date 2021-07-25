---
title: ParrotSec提示NO PUBLIC KEY
date: 2021-7-23 21:14:36
author: Tokisaki Galaxy
summary: 
tags: 
categories: 
---

本有了wsl2，指望彻底把vmware扔到垃圾桶里，结果今天发现wsl2居然不支持usb设备。。。
只好又赶紧翻出来vmware装上linux。

结果apt install的时候又提示NO PUBLIC KEY。。。

## 确定要添加的PUBLIC KEY的摘要

为啥只有一张图呢？
因为懒，所以我就只传一张图了，包含所有步骤了（狗头

![1.png](https://i.loli.net/2021/07/23/6E5zoT9RgrLPywf.png)

`apt update`之后，会提示`the public key is not available: NO_PUBKEY XXXXXXXXX`
记下来这个XXXXXXX

## 添加PUBLIC KEY

`sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys XXXXXXX`

emmm其实一开始我碰到这个奇葩的问题是一脸懵逼的，去百度查一下，说用ha.pool.sks-keyserver.net这个地址，结果发现访问不了。（百度垃圾）

最后实在没办法了（找不到了），死马当活马医，给parrotsec用ubuntu的keyserver，发现居然可以，大喜。
可能是因为他们俩都是同父异母的兄弟吧（debian）。
