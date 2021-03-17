---
title: Office E5订阅
date: 2021-3-17 14:9:34
author: Tokisaki Galaxy
summary: 关于Office E5订阅的申请与续订
tags:
 - Office
 - 激活
categories: 软件安装与配置
---

其实这玩意去年年末我已经开始搞了，中间想写一篇关于如何白嫖的文章，但是我担心没法续订，所以拖到现在才写。

## 什么是Office E5

Office 365 开发版 E5 是为开发人员提供的。申请Office 365开发者计划，可以获得为期3个月的免费Office 365 E5。

注册成功之后可以获得为其90天的全套Office 365，每个人拥有5T Onedrive网盘。
（该许可证最多可添加25个用户，就相当于25个Office 365订阅，5T×25的Onedrive容量）

快到90天的时候微软如果认为你是开发者，会自动进行续订，再给你90天的订阅时间，并发送一封续订成功的电子邮件。
**网上有人说，如果到了90天之后，微软会给你点时间进行数据备份，然后微软会删除你的数据，到了这个时候就乖乖备份吧（我没到过这个阶段，你可以赌一下）**

顺便晒一下续订成功的邮件
![续订成功邮件](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/site/source/_posts/office-e5/1.jpg)

## 申请教程

### 申请Office E5

1.进入[官网](https://developer.microsoft.com/zh-cn/microsoft-365/dev-program)后，点击立即加入。
![立即加入](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/site/source/_posts/office-e5/2.jpg)

### 用自己的微软账户登录

### 登录之后填写国家地区、基本信息就不说了，自己写就好了

### 创建订阅

这一步很关键，关系到你的onedrive数据等存储位置。比如我选择US，那么我的数据就是放在美国的微软数据中心。所以根据你自己的真实位置去选择。
![创建订阅](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/site/source/_posts/office-e5/3.jpg)
然后会让你验证一个手机号。

### 添加许可证

接着上面，验证完手机号之后你会跳转到[这个页面](https://developer.microsoft.com/zh-cn/microsoft-365/profile)，**（当然你应该是显示91天，我这里是因为续订了，才显示120天）**。点击那个用红框框出来的按钮，进入后台。
![转到订阅](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/site/source/_posts/office-e5/4.jpg)
**进后台最好挂个梯子，不然国内有些地区加载不了。**

进入 管理 - > 用户 -> 活跃用户 -> 点击用户名 -> 许可证和用户 ,添加好后点击应用就可以了
![“管理”按钮在哪](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/site/source/_posts/office-e5/5.jpg)

### 其他杂项

#### Onedrive网盘

一开始每个用户是默认1T空间，可以在后台里改到5T（最大）。
还可以改回收站保留时间。

其他自己去慢慢探索吧，就不详细说了，

## 自动续订教程

**这个才是重点，前面只是铺垫。**

### Telegram法

首推这个方法，最简单的。
添加[这个机器人](https://t.me/E5Sub_bot)，然后按提示一步一步走就行了，记得设机器人为免打扰，不然吵死你。

### Github Actions法

论Github Actions的无数种用法。

[传送门](https://github.com/ishadows/AutoApiP)

根据教程一步一步做就行了，挺简单的。

### OneIndex法

这个严格来说不能算一个单独的续订方法，续订只是它的一个副产品而已，但是也顺便加上了（毕竟怎么说都是能续订的）。

这个说的东西有点多，有空哪天再开个坑详细讲吧。今天彩六新赛季，要去上分了。
