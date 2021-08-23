---
title: 【CrackMe】之CKme002
date: 2021-8-23 12:03:01
author: Tokisaki Galaxy
summary: CKme002.exe破解
tags:
 - x64dbg
 - 逆向工程
categories: 踩坑记录
---

谨以此系列记录自己学破解的进程。

本文使用的CrackMe链接：[【反汇编练习】160个CrackME索引目录1~160建议收藏备用 - 『脱壳破解区』 - 吾爱破解 - LCG - LSG |安卓破解|病毒分析|www.52pojie.cn](https://www.52pojie.cn/thread-709699-1-1.html)

-----

随便找找字符串，然后找到成功意思的字符串，跳转过去。

![找字符串](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res@master/img/202108231252477.png)

然后抹掉条件跳转指令，完成

![抹掉条件跳转指令](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res@master/img/202108231253037.png)
