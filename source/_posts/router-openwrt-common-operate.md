---
title: openwrt找出占用空间最大的文件
date: 2024-2-9 14:53:30
author: Tokisaki Galaxy
excerpt: openwrt找出占用空间最大的文件
tags: 
 - Linux
 - openwrt
categories: Linux
---

OpenWrt的find命令不支持-size +1M这种格式。所以我们如果想找分类出大于1M的文件，可以使用-size +1048576c来代替。
1048576是1MB的字节数，c表示计数的是字节。
```bash
find / -type f -size +1048576c -exec du -h {} \;    # 查找大于1M的文件
```
然后可以去删除不需要的文件，毕竟硬路由寸金寸土。
