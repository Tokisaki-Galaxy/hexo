---
title: Office E5订阅
date: 2021-3-17 14:9:34
author: Tokisaki Galaxy
excerpt: 关于Office E5订阅的申请与续订
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
![续订成功邮件](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/post/office-e5/1.jpg)

## 申请教程

### 申请Office E5

1.进入[官网](https://developer.microsoft.com/zh-cn/microsoft-365/dev-program)后，点击立即加入。
![立即加入](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/post/office-e5/2.jpg)

### 用自己的微软账户登录

### 登录之后填写国家地区、基本信息就不说了，自己写就好了

### 创建订阅

这一步很关键，

第一个国家的意思是你的onedrive数据等存储位置。比如我选择US，那么我的数据就是放在美国的微软数据中心。所以根据你自己的真实位置去选择。（当然一般建议如果都很远就选美国，因为美国的网络基础建设很好，以后搭网盘也快一点）

第二个用户名随意，admin或者root再或者iamsb随便挑。

第三个域名，是登录时的后缀。是由microsoft给你的免费二级域名。其实也是个邮箱地址的后缀。

随便写一个自己喜欢的就好，只要不是已经被注册的就行。但是注意，这个注册完就不能改了。

![创建订阅](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/post/office-e5/3.jpg)
然后会让你验证一个手机号。用国内的也行。

-----

### 添加许可证

接着上面，验证完手机号之后你会跳转到[这个页面](https://developer.microsoft.com/zh-cn/microsoft-365/profile)，**（当然你应该是显示91天，我这里是因为续订了，才显示120天）**。点击那个用红框框出来的按钮，进入后台。
![转到订阅](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/post/office-e5/4.jpg)

现在，我们已经申请好了E5订阅了。如果你只是自己用，现在已经可以使用“用户名@域.onmicrosoft.com”和之前设置的密码登录你电脑上的Office和Onedrive了。

**进后台最好挂个梯子，不然国内有些地区加载不了。**

进入 管理 - > 用户 -> 活跃用户 -> 点击用户名 -> 许可证和用户 ,添加好后点击应用就可以了
![“管理”按钮在哪](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/post/office-e5/5.jpg)

-----

### Onedrive网盘

#### **设置5T网盘容量**

默认onedrive容量是1T，但是可以通过设置更改为5T。（强烈建议去改成5T）

一个域名下最多有25个用户，所以最多有25*5T=125T的云存储空间。还可以改回收站保留时间。

修改默认容量大小：

1. 打开微软365管理中心，[点击前往✈](https://admin.microsoft.com/) 登陆上你的E5管理员账号。

2. 点击左侧下方的全部显示，点击展开后显示的“SharePoint”，点击打开，选到左边设置，就可以修改默认Onedrive分配大小。

   ![修改默认分配大小](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/post/office-e5/6.jpg)



其他自己去慢慢探索吧，就不详细说了。

---

### 零零碎碎的其他注意事项

最好给[管理员控制面板](admin.microsoft.com)加个书签，免得找不到

---------

## 自动续订教程

**Office E5订阅第一次订阅有效期是90天，到期后会进行一次检测，以此判断你是否有资格继续白嫖。**

无限续期的原理是多次调用API来达到让microsoft认为你是开发者，然后给你白嫖（自动续期）E5的效果。所以续订不是100%成功的，要看巨硬心情。

（虽然挺大概率成功的，但总归要提醒一下，以防万一

### Telegram法

首推这个方法，最简单的。
添加[这个机器人](https://t.me/E5Sub_bot)，然后按提示一步一步走就行了，记得设机器人为免打扰，不然吵死你。

### Github Actions法

论Github Actions的无数种用法。

[传送门](https://github.com/ishadows/AutoApiP)

根据教程一步一步做就行了，挺简单的。

### OneIndex法

这个严格来说不能算一个单独的续订方法，续订只是它的一个副产品而已，但是也顺便加上了（毕竟怎么说都是能续订的）。

这个说的东西有点多，有空哪天再开个坑详细讲吧。这个玩意已经算是个Onedrive的第三方客户端了。今天彩六新赛季，要去上分了。

