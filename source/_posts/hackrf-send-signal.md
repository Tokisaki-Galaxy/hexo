---
title: HackRF发送信号
date: 2021-7-23 18:49:18
author: Tokisaki Galaxy
summary: GNURadio+HackRF发送信号
tags:
 - hackrf
 - Windows
 - Linux
 - GNURadio
 - WSL
categories: 软件安装与配置
---

近期由于河南强降水，多地区失去通信，水电。许多人受灾情况没法及时传递。
看到家里吃灰已久的HackRF One，终于决定做个紧急求救电台。
（其实很早以前就有这个想法，不过当时是玩游戏玩high了，为核战准备的）

美中不足的是这玩意是半双工的，不能一边发送一边接收信号。

## ParrotSec + GNURadio (PLAN A)

强烈推荐ParrotSec，比kali不知道好看几倍，比ubuntu多很多工具。
wsl爬，原本以为有了wsl能把vmware扔垃圾桶里，结果发现wsl不支持usb。只好找回vmware。

在某个版本之后，parrotsec不默认包含gnuradio了，需要自己手动`apt install gnuradio`。

## Windows + GNURadio (PLAN B)

本来我在parrotsec下已经弄好了，但是突然想起来gnuradio有windows版本的，加上我其实并不喜欢用vmware（感觉体积太庞大了）。
就试试几年前曾经抛弃的 gnuradio windows。抛弃原因是当时安装好了打不开。
下回来之后发现历经数次版本迭代，windows版本的gnuradio已经和linux版不分上下了，于是乎再次把vmware扔到垃圾桶里。
[GNURadio Win64 Binaries](http://www.gcndevelopment.com/gnuradio/index.htm)
（下载是真的慢，idm都救不回来那种
安装完之后记得把安装目录\bin目录加到path里面，里面有hackrf工具，不用另外找了，很方便。

## 
