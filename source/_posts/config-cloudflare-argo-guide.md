---
title: Cloudflare Argo配置指北
date: 2021-11-21 13:43:59
author: Tokisaki Galaxy
excerpt: 本文详细介绍了如何在Linux系统中配置和安装Cloudflare Argo服务，包括设置别名和将其安装为系统服务的步骤。
tags:
 - Linux
 - cloudflare
 - Argo
categories: 踩坑记录
---

## 设置别名

`sudo nano /etc/bashrc`

`alias cf=cloudflared`

## Linux安装为服务

`sudo nano /etc/cloudflared/config.yml`

```yml
tunnel: TUNNEL-UUID
credentials-file: CREDENTIALS-FILE
```

`sudo cloudflared service install`
