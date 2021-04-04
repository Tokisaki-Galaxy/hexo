---
title: VS静态编译设置
date: 2021-4-4 10:31:13
author: Tokisaki Galaxy
summary: VS静态编译设置
tags:
 - C++
categories: 学习记录
---

有时候把自己写的程序拷到其他电脑上运行，会出现缺少msxxxx.dll的提示，这是因为目标电脑上没有安装对应版本的C++运行库。

这时候要么在目标电脑上安装C++运行库，要么在编译的时候把动态编译（不包含运行库）改成静态编译（自带运行库）。另外，动态编译生成的体积比静态编译下的的体积要小的多。

首先必须搞清楚项目->项目属性->配置属性->C/C++->代码生成->运行库中四个选项的关系： 

显示名|编译选项
---|---
多线程调试Dll (/MDd)|MD_DynamicDebug
多线程Dll (/MD)|MD_DynamicRelease
多线程(/MT)|MD_StaticRelease
多线程(/MTd)|MD_StaticDebug

在msdn中有详细解释:
[http://msdn.microsoft.com/en-us/library/2kzt1wy3(VS.80).aspx](http://msdn.microsoft.com/en-us/library/2kzt1wy3(VS.80).aspx)

带有小d的（比如/MDd，/MTd）是Debug模式的。
带有D是动态（/MD，/MDd），带有T是静态（/MT，/MTd）。
