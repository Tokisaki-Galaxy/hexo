---
title: 完全卸载联想电脑管家
date: 2020-12-13 13:45:26
author: Tokisaki Galaxy
img: 
coverImg: 
top: false
cover: false
toc: true
comments: true
mathjax: false
summary: 删除LenovoIM控制进程
tags: 
 - 电脑
 - Lenovo
categories: 软件安装与配置
password: 
noindex: false
sitemap: true
---

Lenovo管家（包括UWP）卸载之后会在系统内留下一堆Lenovo.imxxxx的进程，直接定位目录删除，windowsupdate又给下回来了。找了好久才找到卸载的方法。
方法1.
从**设备管理器**中展开系统设备类别。右键单击**系统接口基础V2设备**，然后选择**卸载**。

方法2.
```shell
c:\windows\system32\imcontroller.infinstaller.exe -uninstall
```