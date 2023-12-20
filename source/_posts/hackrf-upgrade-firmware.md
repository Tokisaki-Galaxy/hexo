---
title: Win/Lin HackRF升级固件 (2021.03.1)
date: 2021-7-23 21:55:23
author: Tokisaki Galaxy
excerpt: Windows/Linux下HackRF 升级固件 (2021.03.1)
tags:
 - hackrf
 - Windows
 - Linux
categories: 软件安装与配置
---

## 更新固件

### 安装工具

#### Windows

先安装[GNURadio Windows](http://www.gcndevelopment.com/gnuradio/index.htm)，添加安装目录/bin到path里面

#### Linux

`apt install hackrf`

### 检测是否连上

`hackrf_info`，如果出现了信息，就是连上了，同时可以看到现在的版本号。截止目前最新的Release是`hackrf-2021.03.1`。

### 下载Release

[https://github.com/mossmann/hackrf/releases](https://github.com/mossmann/hackrf/releases)

### 更新

解压后，进入firmware-bin目录下。

```bash
#更新flash
hackrf_spiflash -Rw hackrf_one_usb.bin
```

*如果你的hackrf_spiflash里没有-R选项，那就去掉它，它的作用只是写入新的固件后重启而已*

网上的很多更新固件的文章都是2017、2018年版的，需要刷flash盒cpld包。但是最新版不需要cpld包了，所以只需要刷进去一个文件就行了。

> CPLD bitstreams are now included in and loaded automatically by the firmware. There is no longer a need to update the CPLD separately.
> ---Github Release(2021.03.1)发行说明

然后再执行`hackrf_info`，可以看到已经更新到2021.03.1了。

## 更新软件

先安装编译需要的软件`sudo apt-get install build-essential cmake libusb-1.0-0-dev pkg-config libfftw3-dev`。
然后进入host目录中

```bash
mkdir build&cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
sudo ldconfig
```
