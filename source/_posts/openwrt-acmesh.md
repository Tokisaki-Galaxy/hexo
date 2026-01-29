---
title: 在 OpenWRT 上使用 acme.sh 配置 SSL 证书
date: 2025-2-3 15:49:47
author: Tokisaki Galaxy
excerpt: 如何在 OpenWRT 系统上使用 acme.sh 申请和管理 SSL 证书
tags: 
- OpenWRT
- SSL
- HTTPS
- acme.sh
categories: openwrt
---

## 前言
OpenWRT 自带的 luci-app-acme 非常难用，而且找不到官方文档（luci很多插件都这样一坨,比如tinyproxy也是年久失修。。）所以我选择官方原版acmesh。

[如有需要可以参照官方README](https://github.com/acmesh-official/acme.sh)

## 安装 acme.sh

```bash
wget -O -  https://get.acme.sh | sh -s email=my@example.com
cd ~/.acme.sh
./acme.sh --upgrade --auto-upgrade
```

## 配置 DNS API 密钥
编辑 `~/.acme.sh/account.conf` 文件，添加以下内容：

由于我使用的是cloudflare的dns，如果你是其他的，请[参照官方](https://github.com/acmesh-official/acme.sh/wiki/dnsapi)。

```bash
export CF_Zone_ID="aaaaaaaaaaa"
export CF_Token="aaaaaaaa"
```

## 申请证书
使用以下命令通过 Cloudflare 的 DNS 验证方式申请证书：

```bash
./acme.sh --issue --dns dns_cf -d admin.tokisaki.top -d '*.example.com' # dns方式可以申请通配符证书
```

## 查看证书列表
可以使用以下命令查看已申请的证书：

```bash
./acme.sh --list
```

## 安装证书
将申请到的证书安装到指定位置，并重启 uhttpd 服务：

```bash
./acme.sh --install-cert -d admin.tokisaki.top \
--key-file /etc/uhttpd.key \
--fullchain-file /etc/uhttpd.crt \
--reloadcmd '/etc/init.d/uhttpd restart'
```

## 验证安装是否有效
使用以下命令强制续期证书：

```bash
./acme.sh --renew -d admin.tokisaki.top --force
```

如果安装成功，输出如下：

```bash
.......
[Mon Feb  3 16:14:16 CST 2025] Your cert is in: /root/.acme.sh/admin.tokisaki.top_ecc/admin.tokisaki.top.cer
[Mon Feb  3 16:14:16 CST 2025] Your cert key is in: /root/.acme.sh/admin.tokisaki.top_ecc/admin.tokisaki.top.key
[Mon Feb  3 16:14:16 CST 2025] The intermediate CA cert is in: /root/.acme.sh/admin.tokisaki.top_ecc/ca.cer
[Mon Feb  3 16:14:16 CST 2025] And the full-chain cert is in: /root/.acme.sh/admin.tokisaki.top_ecc/fullchain.cer
[Mon Feb  3 16:14:17 CST 2025] Installing key to: /etc/uhttpd.key
[Mon Feb  3 16:14:17 CST 2025] Installing full chain to: /etc/uhttpd.crt
[Mon Feb  3 16:14:17 CST 2025] Running reload cmd: /etc/init.d/uhttpd restart
[Mon Feb  3 16:14:17 CST 2025] Reload successful
```