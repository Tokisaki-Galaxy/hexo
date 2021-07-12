---
title: 自建游戏加速器
date: 2021-7-12 9:53:57
author: Tokisaki Galaxy
summary: 使用云服务器自建加速器
tags: 
 - 游戏
 - 云服务器
 - Linux
categories: 游戏
---

## 服务端

```bash
wget https://github.tokisaki.top/github.com/jedisct1/libsodium/releases/download/1.0.18-RELEASE/libsodium-1.0.18.tar.gz
wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
chmod +x shadowsocks-all.sh
sudo ./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log
```
然后输入配置信息，加密方法建议选择第三种（反正游戏加速器也不需要强加密
等运行完成之后复制SSR链接进入下一步

## 客户端

下载[Netch](https://github.com/netchx/netch/releases)，然后打开（如果闪退的话转.Net框架）。

第一个选项栏里选择从剪贴板导入，然后就可以导入服务器了，再选择需要的游戏加速规则，最后点加速。
