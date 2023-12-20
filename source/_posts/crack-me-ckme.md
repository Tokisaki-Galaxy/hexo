---
title: 【CrackMe】之CKme
date: 2021-8-23 11:29:36
author: Tokisaki Galaxy
excerpt: CKme.exe破解
tags:
 - x64dbg
 - 逆向工程
categories: 踩坑记录
---

谨以此系列记录自己学破解的进程。

本文使用的CrackMe链接：[【反汇编练习】160个CrackME索引目录1~160建议收藏备用 - 『脱壳破解区』 - 吾爱破解 - LCG - LSG |安卓破解|病毒分析|www.52pojie.cn](https://www.52pojie.cn/thread-709699-1-1.html)

-------

字符串搜索，随便搜个成功。

然后搜索到了"恭喜恭喜！注册成功"，直接跳转过去

看到右边有虚线，找到虚线起源，jne指令。然后改成NOP，完成。

![5](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res@master/img/202108231305331.png)

PS.如果没加载出来图，点一下灰色框。