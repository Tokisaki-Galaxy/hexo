---
title: 使用Cloudflare Argo隐藏VIPER后台
date: 2021-11-14 13:21:8
author: Tokisaki Galaxy
summary: 使用Cloudflare Argo隐藏VIPER后台。
tags:
 - Linux
 - cloudflare
 - Argo
 - metasploit
 - 网络安全
categories: 踩坑记录
---

> What is a Cloudflare Argo Tunnel
> Argo隧道提供了一种简便的方法，可将Web服务器安全地公开到Internet，而无需打开防火墙端口和配置ACL。 Argo隧道还可以确保请求在到达网络服务器之前先通过Cloudflare进行路由，因此可以确保通过Cloudflare的WAF和Unmetered DDoS缓解功能停止了攻击流量，并且如果为帐户启用了这些功能，则可以通过Access进行身份验证。

为什么走Argo而不是普通CDN？
因为走CDN要用安全组放通60000端口，并且泄露了C&C服务器的IP地址，增加了被朔源隐患。使用ArgoTunnel不需要放通后台端口。而且有Cloudflare官方证书。

并且现在Cloudflare默认走香港节点，大陆访问也不慢。

为啥我要这么搞呢，其实一开始我只是想隐藏后台，所以使用宿主机装nginx反代，但是太难弄了。最后突然想起来Argo可以不开放端口，绑定域名外加隐藏地址，所以就赶紧上了Argo。

## 配置VIPER

因为viper使用的是自签名证书，如果直接转发`https://127.0.0.1:60000`是不行的，会报证书错误。所以要先进容器内改nginx的配置文件，关掉ssl，改成http。

```shell
docker ps #查看容器名
docker exec -i -t viper-c /bin/bash
#下面是在容器内的操作
cd /root/viper/Docker/
nano viper.conf
```

用Ctrl+Shift+_跳转到第7行。

```config
.......
server {
        include /root/viper/Docker/nginxconfig/viper.conf;
        ssl off;    #把这里由on改成off
        ssl_certificate /root/viper/Docker/nginxconfig/server.crt;
.......
```

最后记得重载nginx的配置文件，让改动生效。

```shell
nginx -s reload
exit #退出容器内
```

## 配置Argo

### 安装

Cloudflared 是源服务器和 Cloudflare Argo Server 的连接软件。

你可以参考这里的文档。

官方文档
[Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation)

Github Release
[Downloads](https://github.com/cloudflare/cloudflared/releases)

### 配置Tunnel

```shell
cloudflared tunnel login #先登录，并且选择example.com的域名
cloudflared tunnel create viper
cloudflared tunnel route dns viper vip #通过vip这条隧道，自动在cloudflare中添加一条指向vip.example.com的CNAME记录
```

### 确认Tunnel配置

启动隧道试试，如果没问题就继续。

```shell
cloudflared tunnel --name viper --url http://127.0.0.1:60000
```

然后可以访问vip.example.com查看效果，如果没有问题就继续。
这样启动隧道只是一个临时的措施，所以我们要持久化。

### 持久化Argo

先运行`cloudflared tunnel list`记一下Tunnel的ID是多少。
然后创立cloudflared的配置文件。

```shell
cd ~/.cloudflare
nano config.yaml
```

按照下面这样写，该改的改一下

```config
tunnel: <Tunnel-UUID>
credentials-file: /root/.cloudflared/<Tunnel-UUID>.json

ingress:
  - hostname: vip.example.com
    service: http://127.0.0.1:60000
  - service: http_status:404
```

将cloudflared安装为服务，并启动。

```shell
sudo cloudflared --config ~/.cloudflared/config.yaml service install
sudo systemctl start cloudflared && sudo systemctl enable cloudflared
cloudflared tunnel run viper
```
