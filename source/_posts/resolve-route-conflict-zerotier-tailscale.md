---
title: Openwrt或Linux上Tailscale与ZeroTier的路由冲突IPProto-44
author: Tokisaki Galaxy
excerpt: 从发现到解决IPProto-44，Openwrt或Linux上Tailscale与ZeroTier的路由冲突
tags:
  - OpenWrt
  - Tailscale
  - ZeroTier
  - 路由冲突
date: 2025-07-11 22:44:42
categories: 网络技术
---

因为有时候tailscale和zerotier都不太稳定，所以我在OpenWrt上同时使用了这两个VPN。平时主要用tailscale，zerotier作为应急有时候有奇效。

### 问题的浮现：神秘的丢包日志

一切始于一个看似无关的现象。在检查 OpenWrt 的系统日志时，我反复看到由 `tailscaled`（Tailscale 的守护进程）打印出的错误信息：

```log
Fri Jul 11 21:10:43 2025 daemon.err tailscaled[3274]: Drop: IPProto-44{[fd7a:...] > [fd7a:...]} ... unknown-protocol-44
Fri Jul 11 21:10:53 2025 daemon.err tailscaled[3274]: [RATELIMIT] format("%s: %s %d %s\n%s") (8 dropped)
```

日志显示 Tailscale 正在丢弃一种它不认识的协议（`IPProto-44`）的数据包，来源和目的地都是我网络内的设备。更奇怪的是，这些流量似乎与 Tailscale 本身无关。经过排查，元凶很快就锁定了——这些“异常流量”正是我的 ZeroTier 客户端为了连接其 Moon 中继服务器而发出的。

### 深入分析，路由表？

为什么 ZeroTier 的流量会跑到 Tailscale 的地盘上呢？答案藏在路由规则里。

通过 SSH 登录到 OpenWrt 并执行 `ip rule show`，我们看到了问题的关键：

```bash
root@ImmortalWrt:~# ip rule show
0:      from all lookup local
...
5270:   from all lookup 52
32766:  from all lookup main
...
```

Linux 的路由规则是按优先级（`prio`，数字越小优先级越高）执行的。这段输出告诉我们：
系统会先检查是不是发给路由器自己的流量 (`lookup local`)。如果不是，它会去检查一个优先级为 `5270` 的规则，这条规则说：“**所有流量，都先去查阅路由表 `52`**”。路由表 `52` 是 Tailscale 安装时创建的专属路由表，里面只有通往其他 Tailscale 节点的路由。只有在路由表 `52` 里也找不到路时，流量才会继续往下，去查询优先级更低的 `main` 主路由表（我们正常的互联网出口就在这里）。

**结论显而易见：Tailscale 设置了一条过于“霸道”的高优先级规则，把所有从路由器发出的流量（包括 ZeroTier 的）都“劫持”了。当 ZeroTier 的特殊数据包被导向 Tailscale 的网络时，不认识它的 Tailscale 自然就选择丢弃。**

### 解决方案

要解决这个问题，我们不能粗暴地修改 Tailscale 的规则，而是应该为 ZeroTier 建立一条优先级更高的“专属通道”。

**我们的策略是：** 创建一条新的路由规则，明确告诉系统：“**凡是从 ZeroTier 虚拟网卡发出的流量，请直接走 `main` 主路由表**”，并确保这条规则的优先级高于 Tailscale 的 `5270`。

#### Openwrt脚本与使用

##### 第一步：（推荐）安装完整版 `ip` 工具

OpenWrt 自带的 `ip` 命令功能可能不全。安装 `ip-full` 可以避免很多疑难杂症。

```bash
opkg update
opkg install ip-full
```

##### 第二步：创建服务脚本

使用 `vi` 或 `nano` 创建一个新的服务文件。

```bash
nano /etc/init.d/zerotier-policy-route
```

将下面的完整脚本代码粘贴到你打开的文件中。

{% note warning %}
请根据你的实际情况，修改 `ZT_IFACE` 变量的值。你可以通过 `ifconfig | grep zt` 命令找到你的 ZeroTier 网卡名称。
{% endnote %}

```sh
#!/bin/sh /etc/rc.common

#
# This script creates policy routing rules for ZeroTier to coexist with Tailscale.
# It prevents ZeroTier's traffic from being intercepted by Tailscale's high-priority rule.
# Version 3: Intelligently handles IPv4 and IPv6 addresses.
#

START=99
STOP=15

# --- CONFIGURATION ---
# The name of your ZeroTier virtual network interface. Find it with `ifconfig | grep zt`.
ZT_IFACE="ztypia4gba"

# The priority for the new routing rule. Must be lower (higher priority) than Tailscale's (usually 5270).
RULE_PRIO="5260"

# Tag for system log entries.
LOG_TAG="zerotier-policy-route"
# --- END CONFIGURATION ---

add_rules() {
    # Get all global/unique IP addresses (v4 and v6), excluding link-local (fe80::) addresses.
    IP_LIST=$(ip addr show dev "${ZT_IFACE}" | grep -E 'inet|inet6' | grep -v ' fe80::' | awk '{print $2}' | cut -d'/' -f1)

    if [ -z "${IP_LIST}" ]; then
        logger -t "${LOG_TAG}" "Warning: No usable IP addresses found on interface ${ZT_IFACE}."
        return
    fi

    for ip in ${IP_LIST}; do
        # Check if a rule for this IP already exists to avoid duplication.
        if ! ip rule | grep -q "from ${ip} lookup main"; then
            logger -t "${LOG_TAG}" "Adding rule for ${ip} with priority ${RULE_PRIO}."
            
            # CRITICAL FIX: Use the '-6' flag for IPv6 addresses.
            if echo "${ip}" | grep -q ":"; then
                ip -6 rule add from "${ip}" lookup main prio "${RULE_PRIO}"
            else
                ip rule add from "${ip}" lookup main prio "${RULE_PRIO}"
            fi
        else
            logger -t "${LOG_TAG}" "Rule for ${ip} already exists. Skipping."
        fi
    done
}

remove_rules() {
    IP_LIST=$(ip addr show dev "${ZT_IFACE}" | grep -E 'inet|inet6' | grep -v ' fe80::' | awk '{print $2}' | cut -d'/' -f1)
    if [ -z "${IP_LIST}" ]; then return; fi

    for ip in ${IP_LIST}; do
        if ip rule | grep -q "from ${ip} lookup main"; then
            logger -t "${LOG_TAG}" "Removing rule for ${ip}."

            # Use the '-6' flag for deletion of IPv6 rules as well.
            if echo "${ip}" | grep -q ":"; then
                ip -6 rule del from "${ip}" lookup main prio "${RULE_PRIO}"
            else
                ip rule del from "${ip}" lookup main prio "${RULE_PRIO}"
            fi
        fi
    done
}

start() {
    logger -t "${LOG_TAG}" "Service starting, applying rules..."
    add_rules
}

stop() {
    logger -t "${LOG_TAG}" "Service stopping, removing rules..."
    remove_rules
}

reload() {
    logger -t "${LOG_TAG}" "Service reloading..."
    stop
    start
}
```

##### 第三步：授权并启用服务

保存文件后，在终端执行以下命令：

```bash
# 赋予脚本执行权限
chmod +x /etc/init.d/zerotier-policy-route

# 启用服务，让它开机自启
/etc/init.d/zerotier-policy-route enable

# 立即启动服务以应用规则
/etc/init.d/zerotier-policy-route start
```

##### 第四步：验证成果

执行 `ip rule show`，你将看到类似下面的输出，我们为 ZeroTier 的每个 IP 添加的 `5260` 规则已经稳稳地待在了 Tailscale 的规则之上。

```
0:      from all lookup local
...
5260:   from 172.27.72.251 lookup main
5260:   from fddd:ec77:... lookup main
5260:   from fce1:9571:... lookup main
5270:   from all lookup 52
...
```

#### Linux服务器脚本与使用

由于Openwrt出现这个提示，必然tailscale虚拟局域网中有另一台Linux服务器也安装了Tailscale和ZeroTier。我们可以将上面的脚本稍作修改，适用于其他Linux发行版。

##### 策略路由脚本

```bash
sudo nano /usr/local/sbin/zerotier-policy-route.sh
```

```sh
#!/bin/bash

#
# This script creates policy routing rules for all ZeroTier interfaces
# to coexist with Tailscale on a Debian-based system.
#

set -e # Exit immediately if a command exits with a non-zero status.

# --- CONFIGURATION ---
# The priority for the new routing rule.
# This MUST be a lower number (higher priority) than Tailscale's rule (usually 5270).
RULE_PRIO="5260"
LOG_TAG="zerotier-policy-route"
# --- END CONFIGURATION ---

# Find all ZeroTier network interfaces (names starting with 'zt').
# We use `ip -o link show` for a stable, one-line-per-interface output.
ZT_INTERFACES=$(ip -o link show | awk -F': ' '{print $2}' | grep '^zt')

if [ -z "$ZT_INTERFACES" ]; then
    logger -t "$LOG_TAG" "No ZeroTier interfaces found. Exiting."
    exit 0
fi

# Function to add rules for all found interfaces
add_rules() {
    logger -t "$LOG_TAG" "Applying policy routing rules..."
    for iface in $ZT_INTERFACES; do
        # Get all global/unique IP addresses (v4 and v6), excluding link-local (fe80::)
        IP_LIST=$(ip addr show dev "$iface" | grep -E 'inet|inet6' | grep -v 'fe80::' | awk '{print $2}' | cut -d'/' -f1)
        
        if [ -z "$IP_LIST" ]; then
            logger -t "$LOG_TAG" "No usable IP addresses on interface $iface. Skipping."
            continue
        fi

        for ip in $IP_LIST; do
            # Only add the rule if it doesn't already exist.
            if ! ip rule | grep -q "from $ip lookup main"; then
                logger -t "$LOG_TAG" "Adding rule for $ip (on $iface) with priority $RULE_PRIO."
                # Use the '-6' flag for IPv6 addresses.
                if [[ "$ip" == *":"* ]]; then
                    ip -6 rule add from "$ip" lookup main prio "$RULE_PRIO"
                else
                    ip rule add from "$ip" lookup main prio "$RULE_PRIO"
                fi
            fi
        done
    done
}

# Function to remove rules for all found interfaces
remove_rules() {
    logger -t "$LOG_TAG" "Removing policy routing rules..."
    # We need to find all possible IPs that could have had rules.
    # It's safer to just try deleting any rule with our priority.
    # This is simpler and more robust than tracking IPs.
    while ip rule | grep -q "prio $RULE_PRIO"; do
        # Find the first rule with our priority and delete it. Loop until none are left.
        RULE_TO_DELETE=$(ip rule | grep "prio $RULE_PRIO" | head -n 1)
        logger -t "$LOG_TAG" "Deleting rule: $RULE_TO_DELETE"
        # Re-construct the delete command from the rule string.
        ip rule del ${RULE_TO_DELETE}
    done
}

# Main command logic
case "$1" in
    start)
        add_rules
        ;;
    stop)
        remove_rules
        ;;
    restart)
        remove_rules
        add_rules
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac

exit 0
```
最后记得加上权限
```bash
sudo chmod +x /usr/local/sbin/zerotier-policy-route.sh
```

#### 自启动服务脚本

```bash
sudo nano /etc/systemd/system/zerotier-policy-route.service
```

```sh
[Unit]
Description=ZeroTier Policy Routing Fix for Tailscale Coexistence
After=network-online.target
Wants=network-online.target
After=zerotier-one.service tailscaled.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/sbin/zerotier-policy-route.sh start
ExecStop=/usr/local/sbin/zerotier-policy-route.sh stop

[Install]
WantedBy=multi-user.target
```

最后，要启动服务。
```bash
sudo systemctl enable zerotier-policy-route.service
sudo systemctl start zerotier-policy-route.service
```

可以验证一下`ip rule show`，应该可以看到下面这样
```
0:      from all lookup local
5210:   from all fwmark 0x80000/0xff0000 lookup main
5230:   from all fwmark 0x80000/0xff0000 lookup default
5250:   from all fwmark 0x80000/0xff0000 unreachable
5260:   from 172.27.72.101 lookup main  <--
5260:   from 172.27.62.101 lookup main  <--
5260:   from 172.27.71.101 lookup main  <--
5270:   from all lookup 52
32766:  from all lookup main
32767:  from all lookup default
```
同时，`logread` 中烦人的丢包日志也从此消失了。
