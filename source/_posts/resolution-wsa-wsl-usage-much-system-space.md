---
title: 解决WSA或WSL占用过多C盘空间
date: 2021-12-25 23:8:27
author: Tokisaki Galaxy
summary: 用了WSA、WSL之后C盘空间爆炸，迁移到其他盘的方法
tags:
 - WSA
 - WSL
 - Windows
 - Win11
 - Linux
categories: 软件安装与配置
---

因为我电脑一开始分区只给C盘分了100G，还加了Bitlocker加密，所以搞得现在空间不够用，而且还没法扩容（因为有BitLocker，没法扩容）。所以只好把安装的软件往外面迁，但是WSA是个占空间的大户，而且微软一如既往的不提供迁移方法，只好自己想办法解决。
**同时，此办法也适用于对WSA，WSL有备份需求的用户。**

## WSA迁移方法

在文件浏览器中打开`%LocalAppData%\Packages\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe\LocalCache`。
其中`userdata.vhdx`文件是WSA的虚拟硬盘，安装的APP都在这个文件里。

用fastcopy复制到其他位置，再把原来位置的VHDX文件删除就可以了。
这里举例复制到`Z:\WSA_VHDX`

![用fastcopy复制VHDX文件](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/post/resolution-wsa-wsl-usage-much-system-space/1.png)

然后进入有管理员权限的cmd，创建链接。
**注意一定是cmd，powershell没有mklink指令**

```bash
mklink userdata.vhdx Z:\WSA_VHDX\userdata.vhdx
```

![用mklink创建软链接](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/post/resolution-wsa-wsl-usage-much-system-space/2.png)

## WSL迁移方法

基本上和WSA迁移方法一致，不同在于VHDX路径不同。
不同Linux发行版的VHDX存储路径不同，用Ubuntu20.04LTS举例，它的VHDX存储在`%LocalAppData%\Packages\CanonicalGroupLimited.Ubuntu20.04onWindows_79rhkp1fndgsc\LocalState`下的`ext4.vhdx`里面，迁移其他到位置就好了。

## 注意事项

迁移前需要关闭对于软件，不然会提示文件打开，不能删除

### WSA关闭方法

安装完WSA，会有一个绿色图标的应用，叫`Windows Subsystem for Android`，里面有个开关是关闭WSA。

### WSL关闭方法

进入powershell或者cmd，输入`wsl --shutdown`
