---
title: 临时关闭Hyper-V
author: Tokisaki Galaxy
top: false
cover: false
toc: true
comments: true
mathjax: false
noindex: false
sitemap: true
date: 2020-11-21 21:38:36
img:
coverImg:
summary: 临时关闭hyper-V
tags:
 - hyper-v
 - Linux
 - WSL
 - hackrf
 - debian
 - metasploit
categories: 踩坑记录
password:
---

win10的wsl2中可以装metasploit和hackrf，对我来说实在无法拒绝（windows是最好的linux发行版！），但是wsl2需要HyperV。
但是我用来玩游戏的安卓模拟器却无法和hyperv兼容，在无数次尝试之后（蓝叠那个beta版也不行），还是选择用代码临时关闭开启hypver-v，需要玩游戏的时候关闭hypver-v，需要用wsl的时候开启hypver-v（真麻烦。

**开启**
```bash
bcdedit /set hypervisorlaunchtype auto
```

**关闭**
```bash
bcdedit /set hypervisorlaunchtype off
```
