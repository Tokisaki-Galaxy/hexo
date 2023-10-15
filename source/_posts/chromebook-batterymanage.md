---
title: ChromeBook电池阈值限制充电到80%停止
date: 2023-9-16 15:25:58
author: Tokisaki Galaxy
summary: [ChromeBook]适用于coreboot的电池阈值，限制充电到80%停止
tags: 
 - coreboot
 - chromebook
 - windows
categories: 捡垃圾
---

## 目的

前几天买的
C++写的，默认3分钟定时检查一次电量，所以如果有**略微超出80%是正常情况**。
平时在**休眠状态资源占用极低**。
确保两个exe文件在同一个目录下。

## 使用方法

### 手动启动

确保两个文件放在同一目录，点击chromebook_batterymanage.exe。

### 自动启动

确保两个文件放在同一目录，然后在"任务计划程序"里面创建计划，开机启动，执行chromebook_batterymanage.exe
预期情况，每隔3分钟检测一次电池电量，若大于等于80%，则停止向电池供电。不探测的时候后台休眠，占用极低。

## 下载

**感谢coreboot提供的ectool。**

真的希望大家顺路可以去gayhub点个star，
[github项目链接（首选）](github.com/Tokisaki-Galaxy/chromebook_batterymanage)

分流地址（可能没有更新到最新版本）
[蓝奏云分流（备选）](www.lanzouj.com/iAkTP1bu5hgb)
