---
title: ntfs_file_system
date: 2021-1-31 14:36:39
author: Tokisaki Galaxy
excerpt: 
tags: 
categories: 
---

玩office e5订阅里的5TOnedrive空间时候，发现有个文件死活删不掉。
然后我手贱的尝试命令行，粉碎机，发现均没用的时候就祭出了dg。（我有Bitlocker，所以不想用PE）
发现dg用来依然没用，并且文件越来越多了，还出现各种乱码文件。
马上警觉.jpg。chkdsk/f走起，是否在下一次重启检查文件系统，是。
结果重启直接NTFS_FILE_SYSTEM蓝屏。发现dg直接把我NTFS文件系统搞炸了。。。
然后只好进PE里用chkdsk。
结语：没事别用dg。。。