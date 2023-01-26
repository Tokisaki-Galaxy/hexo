---
title: 树莓派3b刷openwrt作为旁路由
date: 2023-1-24 13:24:11
author: Tokisaki Galaxy
summary: 
tags: 
categories: Linux
---

## 参考资料

[Openwrt 作为旁路网关（不是旁路由、单臂路由）的终极设置方法，破解迷思](https://sspai.com/post/68511)

## 固件下载

[OpenWrt RPi](https://doc.openwrt.cc/2-OpenWrt-Rpi/)

## 刷机

用etcher就可以了，然后进Linux里面用GPart扩展分区，不然SD卡空间不能完全利用。

## 配置

emmm最后没做到少数派里面说的旁路网关，只做到了单臂路由。等哪天我做到旁路网关再回来吧。
旁路网关只影响上行数据，单臂路由会影响上下行。在树莓派3b上，网卡只有100M最高上限，所以跑不满，会影响网速。。。
