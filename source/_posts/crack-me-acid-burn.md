---
title: 【CrackMe】之Acid Burn
date: 2021-8-22 22:24:31
author: Tokisaki Galaxy
excerpt: Acid Burn.exe破解
tags:
 - x64dbg
 - 逆向工程
categories: 踩坑记录
---

谨以此系列记录自己学破解的进程。

本文使用的CrackMe链接：[【反汇编练习】160个CrackME索引目录1~160建议收藏备用 - 『脱壳破解区』 - 吾爱破解 - LCG - LSG |安卓破解|病毒分析|www.52pojie.cn](https://www.52pojie.cn/thread-709699-1-1.html)

----

第一次玩crackme，先直接启动，熟悉一下各个界面。了解一下序列号出错的提示。

它有两种验证，一种是序列号+注册名，另一种是仅序列号，大致明白流程之后关闭，然后挂上x64dbg走起。

### 序列号

先从简单的下手，载入程序后搜索所有模块-字符串，搜索出错提示"Try Again!!"，然后跳转过去。

![跳转到Try Again!!](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res@master/img/202108231107084.png)

首先必须知道点汇编指令的含义，比如jmp是无条件跳转，jne是条件跳转之类的。

（其实也不用记，x64dbg用虚线箭头标出来的是条件跳转，实线是无条件跳转，

然后看到跳转过来的"Try Again!!"附近有一个虚线、一个实线箭头。

理清一下程序流程，首先它先对输入的数据进行判断，然后用jne判断是否符合，如果不符合就输出Fail，try again!!，如果符合就啥也不干。

所以将jne指令用nop填充，第一个问题解决。

![将jne替换为nop](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res@master/img/202108231113665.png)

### 序列号+注册名

先用搜索字符串找到提示"Sorryxxxxxx"，会出现两个结果，因为它要对序列号和注册名判断两次，所以有两次提示。

先从第一处开始，jge也是条件跳转指令中一个，只要将jge改为jmp，这里就破解完成了。

![修改jge指令](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res@master/img/202108231117268.png)



然后找到第二处，

![第二处](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res@master/img/202108231120301.png)

大致梳理一下流程，基本和之前一样，把条件跳转jne改为nop就行了



### 结尾

至此无论你输什么，都会显示祝贺成功。

最后可以输出修补程序，就是破解完的程序
