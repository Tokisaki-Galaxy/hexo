---
title: RTL9210(A/B)固件配置
date: 2024-12-20 12:11:55
author: Tokisaki Galaxy
excerpt: RTL9210(A/B)固件配置
tags: 
 - firmware
 - rtl9210
 - Windows
categories: 电脑硬件
---

## RTL9210固件配置

RTL9210 分为A版和B版。A版支持NVMe，B版同时支持SATA和NVMe。
[RTL9210(A/B)公版](https://www.station-drivers.com/index.php/en/component/remository/search/submit_search,yes/search_filetitle,1/search_filedesc,1/search_text,rtl9210b/page,2/lang,en-gb/?Itemid=0)
[RTL9210A/B参数解释](https://github.com/bensuperpc/rtl9210-firmware)

|名称|内容|
|---|---|
|MANUFACTURE|生产商|
|SCSI_VENDOR|SCSI 中显示的生产商名称|
|PRODUCT|产品型号|
|SCSI_PRODUCT|SCSI 中显示的产品型号|
|SERIAL|产品序列号|
|EN_UPS|建议关闭，设为1会每次插拔增加不安全关机数|
|DIS_SHOW_EMPTY_DISK|插硬盘是否显示空硬盘|
|ASPMDIS|是否禁用活动电源管理 值为16进制1和0。(开启:0x1 关闭:0x0)  开启后桥接会始终保持高功率，会很烫，但是好像速度没影响。|
|DISK_IPS_THRES|指定硬盘多久休眠（分钟）|
|EN_U1U2|开启U1U2功率管理模式|
|U2_MAXPWR|U2模式最大功率|
|U3_MAXPWR|U3模式最大功率|
|下列各个设置请|根据自己的硬盘盒厂商设定|
|LED|
|SUSPEND_LED_OFF|弹出后关灯
|SUSPEND_DISK_OFF|弹出后单色灯灭灯，双色的话显示蓝色|
|UART_DBG_PIN|UART串口 DEBUG PIN码|
|PD|【待确认】开启PD供电模式？详细作用不明，但是WTG一定要关闭，否则可能导致加电速度慢，引导时找不到硬盘。|

## 另外别人记录的坑

默认配置里有一行SCSI_WP_PIN = 0xc，这行如果不删会出现向硬盘里写文件时提示硬盘有写保护，同时LED也不亮。[来源](https://www.bilibili.com/opus/841596810157883397)

## MD202原厂设置

如需使用自行把`:`换成`=`。
```yaml
U2PHY : 02 f4 9b e0 e1 
U3PHY : 02 d4 09 00 d5 00 80 
VID : 0x0bda
PID : 0x9210
MANUFACTURE : "HIKSEMI"
PRODUCT : "MD202"
SERIAL : "012345678935"
SCSI_PRODUCT : "MD202" ;这里出现未知字符，可能是厂商防伪用
SCSI_VENDOR : "HIKSEMI" ;这里出现未知字符，可能是厂商防伪用
USB_SELF_PWR : n/a
DISK_HOTPLUG : 0x00
LED : 0x02
PINMUX1 : 0x00000000
PINMUX2 : 0x00000070
U2_MAXPWR : 0xfa
U3_MAXPWR : 0x70
ASPMDIS : 0x00
PCIE_REFCLK : n/a
DISK_IPS_THRES : 0x0a
SWR_1_2V : n/a
EN_UPS : n/a
PD : n/a
CUSTOMIZED_LED : n/a
SUSPEND_LED_OFF : 0x03
FORCE_USB_SPEED : n/a
FORCE_PCIE_SPEED : n/a
EN_U1U2 : n/a
FORCE_USB_QUIRK : n/a
FORCE_PCIE_QUIRK : n/a
FAN : n/a
DIS_SHOW_EMPTY_DISK : n/a
FORCE_SATA_NORMAL_DMA : n/a
UART_DBG_PIN : 0x05
FINGER_PRINT_EN : n/a
RM_INTERNAL_RD : n/a
HS_AUTO_SWITCH : n/a
UART_BAUD_RATE : n/a
CUSTOMIZED_DISK_IDENTIFY : n/a
HW_LED_CFG : n/a
CDROM_CFG : n/a
SUPPORT_HID : n/a
LATE_INIT_DISK : n/a
SCSI_WP_PIN : n/a
SD_MMC_TYPE : n/a
FORCE_PORT_TYPE : n/a
BCDDEVICE : n/a
SUSPEND_DISK_OFF : n/a
SCSI_WB_PIN : n/a
CUSTOMIZED_FEATURE : n/a
PERIPH_API : n/a
RAID_CFG : n/a

Boot Mode : Flash
FW Ver : 1.27.24
FW Build Date : 2021.09.07
IC Pkg Type : PCIE/SATA
UUID : n/a

Disconn_ForceUSB2 : false
```

## 自用MD202

```yaml
VID = 0xbda
PID = 0x9210
MANUFACTURE = "HIKSEMI"
SCSI_VENDOR = "HIKSEMI"
PRODUCT = "MD202"
SCSI_PRODUCT = "MD202"
SERIAL = "012345678938"
LED = 0x2
DIS_SHOW_EMPTY_DISK = 0x1
DISK_IPS_THRES = 0

PINMUX1 = 0x0
PINMUX2 = 0x70
U2_MAXPWR = 0xfa
U3_MAXPWR = 0x70
SUSPEND_LED_OFF = 0x1
SUSPEND_DISK_OFF = 0x7
UART_DBG_PIN = 0x5

EN_UPS = 0x0
EN_U1U2 = 0x1
ASPMDIS = 0x0
```