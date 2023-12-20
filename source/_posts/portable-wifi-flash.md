---
title: 晓龙410芯片随身wifi刷机浅谈
date: 2022-10-23 11:22:15
author: Tokisaki Galaxy
excerpt: 安卓系统随身wifi刷机中一点坑，自己感想
tags:
 - android
 - 刷机
 - wifi
 - 固件
categories: android&linux
---

之前在b站看到有人弄随身wifi刷机，感觉好奇怪。点进去一看发现这东西才不到20块钱，而且里面居然是晓龙410的芯片，跑着安卓4.4，然后去酷安找了个车买了俩。

刷root挺麻烦，我想只做一次root，然后之后买的同样的机器都可以直接刷进去就可以了，省时省力。
之前一直好奇QCN和救砖包到底是什么样的关系，网上有人说两者没有关系，然后我就信了那个鬼话，随便刷了miko全量包，结果基带丢了，联不了联网。。
这就说明，再使用miko保存救砖包的时候，把QCN文件也一起保存下来，所以在复制到其他机器会丢失QCN。。。
丢失QCN会导致无法使用基带，丢失IMEI。每个设备IMEI是独特的，一般来讲复制其他设备IMEI不可行。也就是说这玩意差点废了。
好在我事先用miko全量备份了，没酿成惨案。。
但是我一直想知道QCN和救砖包到底是什么样的关系。仔细想了想，备份QCN需要root，而且有提示是从NV Database里保存的，这说明QCN其实保存在系统可以访问的地方。。
所以我把两个型号一样的随身wifi全量包的每个文件，去用差异计算，寻找不同的地方，也就是保存QCN的位置。

两个随身wificlone下来的救砖包里基本所有文件都是一样的，有差异的是

```shell
cache.img
modemst1.img
modemst2.img
persist.img
userdata.img
```

很神奇，一开始我预想的是modem.img会有差异，结果居然是一样的。
cache.img不管他，可以当成一样的。
对persist.img分析，里面差异文件是`[SYS]\Journal`
所以根据文件名推测，里面应该不是重要文件，可以认为persist.img也是一致的。
所以到这里，知道了随身wifi不同设备不同的地方在于`modemst1.img modemst2.img`不同。所以可以认为QCN保存在这里。

由于这两个文件无法继续使用7zip简单的打开进行查看，所以不管他到底是哪个文件不同了。
不过我们知道QCN位置，所以可以通过Qualcomm Premium Tool刷写指定位置，这样就通过达到在新机器上直接flash预先做好的已经root的镜像，然后再烧一遍保存QCN的分区来达到简化操作的目的。

最后，通过这样保存分区来保存QCN，也不需要root，相较使用星海SVIP保存更加方便，速度也更加快。毕竟擦写分区可比用软件写QCN快多了。（不管是星海SVIP还是miko，读写QCN都好慢...）

最后测试一下，写了root的镜像，然后直接打开没有IMEI。重新烧录那两个分区，再打开就出现IMEI了。

有个很奇怪的问题，网上的教程都是使用Miko保存救砖包，然后再用Qualcomm Premium Tool保存全部文件。难道没有人知道miko生成的救砖包可以打开为压缩包，里面文件和用Qualcomm Premium Tool保存的一模一样吗，绝对是重复操作。或者说网上都是复制粘贴的吗。。
Qualcomm Premium Tool的作用无法替代，因为它可以单独擦写某个分区，但是我不认同网上千篇一律教程所说的miko保存一遍，Qualcomm Premium Tool再保存一遍的重复操作...
