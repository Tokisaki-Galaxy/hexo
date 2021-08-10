---
title: dnspod public dns 初体验
date: 2021-8-10 16:08:44
author: Tokisaki Galaxy
summary: 试试腾讯的public dns
tags:
 - DNSPod
 - DNS
categories: 踩坑记录
---

最近腾讯DnsPod新出了一个性化dns，可以自定义拦截列表，用于拦截广告，追踪器。国内以前也要类似的产品，比如红🐟之类的。

我只以前用树莓派搭过adguard home，用于在家里拦截广告，追踪器。这样做的好处是只需要在网关上设置，不需要在家里每个设备上单独设置了。但用树莓派的不足之处在于出门不能使用（废话），解析时间略长（50-60ms，约长一倍）。

现在新推出的dnspod处于公测期间，可以免费无限量使用，正好拿来试试水。

从dnspod中进入公共解析，完成创建后可以看到下面这个界面。

![publicdns](https://ftp.bmp.ovh/imgs/2021/08/a6d39e3f44ac5ccf.png)

然后只需要把dns服务器地址设为路由器dhcp服务器里面就行了

![tplink设置dhcp服务器](https://ftp.bmp.ovh/imgs/2021/08/6bd7b21343604d1a.png)

TP-LINK打钱
由于dnspod的IPv4地址不能为所有客户1对1的给一个地址，必须将你的地址绑定到你的账户上

![publicdns绑定](https://ftp.bmp.ovh/imgs/2021/08/09de7d3cf32cfec5.png)

家里用的宽带一般是动态IP，每天都会变，而我们又不可能每天都登录dnspod来手动绑定，所以推出了一项功能叫自动绑定接口。

只要变化的IP后访问了这个接口（GET请求），就会自动绑定。那么我们只需要把这个地址设为我们浏览器的启动页就好了。

（这真的是最合理的办法了啊）

第二种方法，写一个python脚本访问，不过你要加启动项或者每天自己点

```python
import requests
requests.get("xxxxxxxxxx") #这是你的自动绑定接口
```
