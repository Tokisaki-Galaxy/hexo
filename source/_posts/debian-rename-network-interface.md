---
title: debian重新命名网卡
date: 2023-1-23 20:27:43
author: Tokisaki Galaxy
summary: debian有时候安装完驱动，网卡名字会变得很奇怪，可以重新命名
tags: 
 - Debian
categories: Linux
---

新买了个RTL8812BU网卡，打算用来给parrot用，然后去找了驱动装上之后，发现网卡名居然不是wlan0，是一串长长的名字，这个可忍不了。
parrot5是基于debian10 x64的。

查了一下，修改一下命名规则就好啦。

```shell
sudo nano /etc/default/grub
```

将原来`GRUB_CMDLINE_LINUX=""`改为`GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"`。

```shell
sudo update-grub
```

另外，如果在使用过程中出现`write failed: Network is down`，需要把虚拟机设置，主机控制器里面兼容性从USB3.x改成USB2.0。
