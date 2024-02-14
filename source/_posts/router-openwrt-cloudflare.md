---
title: router-openwrt-cloudflare
date: 2024-2-9 14:52:30
author: Tokisaki Galaxy
excerpt: 解决openwrt使用cloudflared service install安装服务无法使用的问题   
tags: 
 - openwrt
 - linux
categories: Linux
---

openwrt使用cloudflared安装服务的时候会有兼容性问题，问题出现在/etc/init.d/目录下的服务脚本，默认使用的是SysVinit，而cloudflared使用的是procd。所以我们需要修改服务脚本，将其改为procd的格式。

**SysVinit** 是许多早期 Linux 发行版使用的传统初始化系统。它使用一系列的 shell 脚本，按照特定的顺序启动各种服务。这些脚本通常位于 `/etc/init.d/` 目录中，每个脚本对应一个服务。SysVinit 的主要缺点是它启动服务的方式是线性的，不能并行启动，这可能导致启动时间较长。

**procd** 是 OpenWrt 使用的初始化系统。与 SysVinit 不同，procd 可以并行启动服务，从而加快系统启动时间。procd 还提供了一些其他高级功能，如进程监控、自动重启和 cgroup 管理。procd 的服务脚本通常位于 `/etc/init.d/` 目录中，与 SysVinit 类似，但它们的格式和语法有所不同。

```bash
#!/bin/sh /etc/rc.common
# Copyright (C) 2021 Tianling Shen <cnsztl@immortalwrt.org>

USE_PROCD=1
START=99

CONF="cloudflared"
PROG="/usr/bin/cloudflared"

start_service() {
    procd_open_instance
    procd_set_param command "$PROG" "--pidfile" "/var/run/$CONF.pid" "--autoupdate-freq" "24h0m0s" "tunnel" "run" "--token" "xxxxxxxxxxxxxxxx"
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_set_param pidfile "/var/run/$CONF.pid"
    procd_close_instance
}

stop_service() {
    procd_kill $CONF
}

reload_service() {
    stop
    start
}

service_triggers() {
    procd_add_reload_trigger "$CONF"
}
```