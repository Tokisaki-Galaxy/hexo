---
title: 小米R3G刷机breed后刷openwrt
date: 2023-10-10 23:42:56
author: Tokisaki Galaxy
summary: 闲鱼淘了R3G刷Openwrt玩，记录一下第一次刷breed和openwrt
tags: 
 - R3G
 - 路由
 - 刷机
 - breed
 - openwrt
 - 固件
categories: 捡垃圾
---

## 前言

挺早之前打算买个路由器玩，因为学了网络技术这么久都没用上，很想玩。
其次宿舍里打游戏有时候要局域网，总是开热点不方便。所以整个路由器刷个openwrt是个不错的选择。
一开始我打算选随身wifi，但是发现那高通CPU太弱了，根本带不动游戏联机，所以买了台据说对标K2P的R3G。
因为第一次刷breed和openwrt，网上没有什么现成的教程。七零八碎，版本也不对的教程看的挺难受，一路上挺坎坷的，终于成功之后记录一下过程。

## 打开SSH

先刷入开发版的ROM。将下载的ROM包复制到FAT32格式U盘的根目录，并重命名为miwifi.bin ，同时确保该目录下不存在其它“.bin”文件，若存在会导致刷机失败。
[https://www.miwifi.com/miwifi_download.html](https://www.miwifi.com/miwifi_download.html)

>断开小米路由器的电源，将U盘插入路由器USB接口；
>按住reset键，接通电源，等待指示灯变为黄色闪烁状态后松开reset键，路由器开始刷机；
>等待刷机完成，整个过程约为3-5分钟，完成后系统会自动重启。路由器指示灯变蓝刷机完成；如果出现异常、失败、U盘无法读取的状况，会进入红灯状态，建议重试或更换U盘再试。

**手机要装MiWIFI的APP**，然后绑定账号（不然用不了SSH）。绑定之后访问这个网站，下载SSH工具包。
[https://d.miwifi.com/rom/ssh](https://d.miwifi.com/rom/ssh)
*也可以去看看什么强开SSH，但是有人反馈强开SSH得到的shell刷机失败*

>请将下载的工具包bin文件复制到U盘（FAT/FAT32格式）的根目录下，保证文件名为miwifi_ssh.bin；
>断开小米路由器的电源，将U盘插入USB接口；
>按住reset按钮之后重新接入电源，指示灯变为黄色闪烁状态即可松开reset键；
>等待3-5秒后安装完成之后，小米路由器会自动重启，之后您就可以尽情折腾啦 ：）

尝试SSH访问。因为路由器上的dropbear版本很古典，必须加额外参数兼容那个古老的算法。

```bash
ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostKeyAlgorithms=+ssh-dss -oCiphers=+3des-cbc root@192.168.31.1
```

否则无法连接，会出现出现

```bash
Unable to negotiate with 192.168.31.1 port 22: no matching key exchange method found. 
Their offer: diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1
```

当时因为没有网线，然后绑定账号必须要用手机APP。我用电脑共享到有线网到路由器，重置路由器好多次都不行，搞了好久。所以看到还挺激动的。
![挺激动的](https://pic.imgdb.cn/item/65257c99c458853aefc0c83d.png)

## 备份原始数据

每台机器的备份有略微不同，混用同一型号其他机器的备份可能会导致信号很差。
`cat /proc/mtd`查看分区表，然后依次备份

```bash
dd if=/dev/mtd0 of=/extdisks/sda/ALL.bin
dd if=/dev/mtd1 of=/extdisks/sda/Bootloader.bin
dd if=/dev/mtd2 of=/extdisks/sda/Config.bin
dd if=/dev/mtd3 of=/extdisks/sda/Bdata.bin
dd if=/dev/mtd4 of=/extdisks/sda/Factory.bin
dd if=/dev/mtd5 of=/extdisks/sda/crash.bin
dd if=/dev/mtd6 of=/extdisks/sda/crash_syslog.bin
dd if=/dev/mtd7 of=/extdisks/sda/reserved0.bin
dd if=/dev/mtd8 of=/extdisks/sda/kernel0.bin
dd if=/dev/mtd9 of=/extdisks/sda/kernel1.bin
dd if=/dev/mtd10 of=/extdisks/sda/rootfs0.bin
dd if=/dev/mtd11 of=/extdisks/sda/rootfs1.bin
dd if=/dev/mtd12 of=/extdisks/sda/overlay.bin
dd if=/dev/mtd13 of=/extdisks/sda/ubi_rootfs.bin
dd if=/dev/mtd14 of=/extdisks/sda/data.bin #这一行可能会因为设备忙无法备份，没关系
```

### 还原备份

```bash
mtd write /extdisks/sda/Bootloader.bin Bootloader
mtd write /extdisks/sda/Config.bin Config
mtd write /extdisks/sda/Bdata.bin Bdata
mtd write /extdisks/sda/Factory.bin Factory
mtd write /extdisks/sda/crash.bin crash
mtd write /extdisks/sda/crash_syslog.bin crash_syslog
mtd write /extdisks/sda/reserved0.bin reserved0
mtd write /extdisks/sda/kernel0.bin kernel0
mtd write /extdisks/sda/kernel1.bin kernel1
mtd write /extdisks/sda/rootfs0.bin rootfs0
mtd write /extdisks/sda/rootfs1.bin rootfs1
mtd write /extdisks/sda/overlay.bin overlay
mtd write /extdisks/sda/ubi_rootfs.bin ubi_rootfs
```

## 刷breed

当时很担心成砖，所以上一步备份我备份了三次，都比较了CRC32，发现均相同才敢接着刷。
（其实现在想起来没必要这么谨慎，但是也挺好的习惯）

下载breed，在目录里搜索文件名包含R3G的文件，下载
[https://breed.hackpascal.net/](https://breed.hackpascal.net/)

使用WinSCP来传输文件到临时目录，协议使用SCP，不要用SFTP。（注意，FileZilla因为只支持SFTP，所以用不了。）
这个网站下载的是最新版，截止目前的时间，是1.2版本，和1.1版本的Web操作有较大差异。

```bash
mtd -r write /tmp/XXX.bin Bootloader
```

![刷breed](https://pic.imgdb.cn/item/65257c98c458853aefc0c82e.png)

确认完成之后，按住RESET键开机。
等到路由的灯闪烁时候，松开RESET键，浏览器访问192.168.1.1。（一般情况下不需要手动分配IP地址,有DHCP）

![breed的web界面](https://pic.imgdb.cn/item/65257c98c458853aefc0c808.png)

### 在控制台中备份

备份EEPROM和编程器固件。其中最重要的是EEPROM。

## breed控制台刷入openwrt

使用的是这个版本的openwrt
[https://www.right.com.cn/forum/forum.php?mod=viewthread&tid=8303844](https://www.right.com.cn/forum/forum.php?mod=viewthread&tid=8303844)

下载底包，然后上传。
在v1.2的breed中，只用选rootfs0和kernel1两个文件，外加闪存布局写Openwrt就可以，不需要额外设置环境变量，挺方便的。
勾上刷机之后自动重启，然后慢慢等，千万别断电就好。
*据说v1.1的要设环境变量才能启动*

![等自动重启就好](https://pic.imgdb.cn/item/65257c98c458853aefc0c7fb.png)

**进入OPENWRT之后，不要以为结束了，需要继续进行固件更新，更新文件sysupgrade.bin。**

## 一些其他的问题

```bash
mtd write mir3g-squashfs-kernel1.binkernel1
mtd write mir3g-squashfs-rootfs0.binrootfs0
nvram set flag_try_sys1_failed=1
nvram commit
reboot
```

上述命令中nvram是uboot专有命令，Breed与uboot相互独立，参数不共用，根据国外论坛对于小米路由器原厂uboot的分析，小米路由器的kernel0包含的usb恢复的功能，就是将官方固件命名为miwifi.bin放入U盘内，断电时插入路由器，用硬物抵住reset键后插电，保持10秒左右，待黄灯快速闪动后可松手，可恢复至官方固件，这个功能可用于原厂固件损坏后的修复，也算是不错的功能，所以OpenWrt官网上的建议是将内核文件刷入kernel1

## 更新源

```yml
src/gz immortalwrt_core https://mirror.sjtu.edu.cn/immortalwrt/snapshots/targets/ramips/mt7621/packages
src/gz immortalwrt_base https://downloads.immortalwrt.org/snapshots/packages/mipsel_24kc/base
src/gz immortalwrt_luci https://downloads.immortalwrt.org/snapshots/packages/mipsel_24kc/luci
src/gz immortalwrt_packages https://downloads.immortalwrt.org/snapshots/packages/mipsel_24kc/packages
src/gz immortalwrt_routing https://downloads.immortalwrt.org/snapshots/packages/mipsel_24kc/routing
src/gz immortalwrt_small8 https://downloads.immortalwrt.org/snapshots/packages/mipsel_24kc/small8
src/gz immortalwrt_telephony https://downloads.immortalwrt.org/snapshots/packages/mipsel_24kc/telephony
```

```yml
src/gz immortalwrt_core https://mirrors.cloud.tencent.com/openwrt/snapshots/targets/ramips/mt7621/packages
src/gz immortalwrt_base https://mirrors.cloud.tencent.com/openwrt/snapshots/packages/mipsel_24kc/base
src/gz immortalwrt_luci https://mirrors.cloud.tencent.com/openwrt/snapshots/packages/mipsel_24kc/luci
src/gz immortalwrt_packages https://mirrors.cloud.tencent.com/openwrt/snapshots/packages/mipsel_24kc/packages
src/gz immortalwrt_routing https://mirrors.cloud.tencent.com/openwrt/snapshots/packages/mipsel_24kc/routing
src/gz immortalwrt_small8 https://mirrors.cloud.tencent.com/openwrt/snapshots/packages/mipsel_24kc/small8
src/gz immortalwrt_telephony https://mirrors.cloud.tencent.com/openwrt/snapshots/packages/mipsel_24kc/telephony
```
