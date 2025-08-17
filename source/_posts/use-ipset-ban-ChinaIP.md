---
title: 在 Linux 上使用 ipset 高效屏蔽特定国家 IP（中国等）
author: Tokisaki Galaxy
excerpt: 一种在 Linux 服务器上，利用 ipset 和 systemd 定时任务，实现低资源消耗、非持久化、高效率地屏蔽特定国家或地区 IP 地址列表的方案。
tags:
  - Linux
  - iptables
  - ipset
  - systemd
  - Google Cloud
date: 2025-08-17 18:19:40
categories:
  - 服务器运维
---

## 前言

从Google Cloud白嫖了个服务器，但是最近时不时总是发现偷偷跑钱，每个月一两块钱，虽然少但是与白嫖相悖。

因为虽然每个月有200G免费流量，但是中国不属于免费流量范围，所以每次访问中国IP都会扣钱。于是就想办法封中国IP。

一开始看到网上很多ufw的脚步，比如这种
```bash
#!/bin/bash for ip in $(cat cn.zone); do sudo ufw deny from $ip done
```
用一堆for循环塞到ufw里面，当一个网络数据包到达时，内核需要从上到下逐一检查这个长长的规则列表。时间复杂度是O(n)，当规则数量很多时，性能会显著下降。

而ipset是专门为处理大量IP地址而设计的，它使用哈希表来存储IP地址，查询时间复杂度接近O(1)。所以使用ipset代替ufw可以显著提高性能。

一开始是用ipset-persistent，netfilter-persistent进行持久化，但是这两个工具会保存所有规则，容易导致ipset规则积累过多。所以采用服务的方式绕开持久化。

## 解决方案
### systemed Service
```ini
# /etc/systemd/system/china-ip-blocker.service
[Unit]
Description=Update and apply China IP blocklist using ipset
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
# 脚本绝对路径
ExecStart=/usr/local/bin/update_china_blocklist.sh
PrivateTmp=true
ProtectSystem=strict
ReadWritePaths=/var/run
ProtectHome=true
NoNewPrivileges=true
SupplementaryGroups=systemd-resolve
```

### systemed Timer
```ini
# /etc/systemd/system/china-ip-blocker.timer
[Unit]
Description=Run china-ip-blocker service on boot and daily
[Timer]
OnBootSec=2min
OnUnitActiveSec=12h
Unit=china-ip-blocker.service
[Install]
WantedBy=timers.target
```

### 主程序
```bash
#!/bin/bash
# =================================================================
#  High-Performance, Low-Resource IP Blocklist Update Script
#
#  Designed for execution via systemd timer or cron.
#  This script is non-persistent and relies on being run on boot
#  and periodically to maintain firewall rules.
# =================================================================

set -o errexit   # Exit immediately if a command exits with a non-zero status.
set -o nounset   # Exit immediately if it tries to use an undeclared variable.
set -o pipefail  # The return value of a pipeline is the status of the last command to exit with a non-zero status.

# --- Configuration ---
readonly IPSET_NAME="chinablock"
readonly IP_LIST_URL="https://www.ipdeny.com/ipblocks/data/countries/cn.zone"
readonly TMP_FILE="/dev/shm/${IPSET_NAME}.zone"
readonly LOCK_FILE="/var/run/${IPSET_NAME}.lock"
readonly MIN_IP_COUNT=100 # Minimum expected number of IP ranges

# Efficient logging function using bash printf built-in (>= bash 4.2)
log() {
    # %-1s prints a single space. Using it to get printf to evaluate the format string.
    printf '%(%Y-%m-%d %H:%M:%S)T - %s\n' -1 "$1"
}

# Centralized error-handling function
die() {
    log "FATAL: $1" >&2
    exit 1
}

main() {
    # --- Prerequisite Checks ---
    if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
        die "This script must be run as root."
    fi

    for cmd in ipset wget iptables flock awk head tail; do
        if ! command -v "$cmd" &>/dev/null; then
            die "Required command '$cmd' is not found."
        fi
    done
    
    # Ensure temporary file is cleaned up on any exit
    trap 'rm -f "$TMP_FILE"' EXIT

    log "Starting IP blocklist update for set '$IPSET_NAME'..."

    # --- Download IP List ---
    log "Downloading IP list from $IP_LIST_URL..."
    if ! wget -q --timeout=60 --tries=3 -O "$TMP_FILE" "$IP_LIST_URL"; then
        die "Download failed from $IP_LIST_URL."
    fi

    # --- Create and Load Temporary IPSet ---
    local temp_ipset_name="${IPSET_NAME}_temp"
    ipset create "$temp_ipset_name" hash:net -exist
    ipset flush "$temp_ipset_name"

    log "Validating list and preparing for bulk load..."
    # Use a single awk pass to validate and generate restore data.
    # It exits with an error code if the line count is too low.
    # The last line of its output is the total count.
    local awk_output
    awk_output=$(awk -v set_name="$temp_ipset_name" \
        '{ print "add " set_name " " $1 } END { if (NR < '$MIN_IP_COUNT') exit 1; print NR }' "$TMP_FILE") \
        || die "IP list validation failed (expected >$MIN_IP_COUNT lines, found $(wc -l < "$TMP_FILE" | awk '{print $1}'))."
    
    # Pipe all but the last line (the count) to ipset restore for high-speed loading.
    echo "$awk_output" | head -n -1 | ipset restore || die "ipset restore command failed."
    
    local final_count
    final_count=$(echo "$awk_output" | tail -n 1)
    
    log "Loaded $final_count IP blocks into temporary set '$temp_ipset_name'."

    # --- Atomically Activate the New IPSet ---
    ipset create "$IPSET_NAME" hash:net -exist
    ipset swap "$temp_ipset_name" "$IPSET_NAME"
    ipset destroy "$temp_ipset_name"
    log "Successfully updated and activated ipset '$IPSET_NAME'."

    # --- Ensure IPTables Rule Exists ---
    # This check is crucial because the rule is lost on reboot.
    if ! iptables -C INPUT -m set --match-set "$IPSET_NAME" src -j DROP &>/dev/null; then
        log "iptables rule not found. Inserting it at the top of the INPUT chain..."
        # -I INPUT 1 ensures it's one of the first rules evaluated, which is critical for performance.
        iptables -I INPUT 1 -m set --match-set "$IPSET_NAME" src -j DROP
        log "iptables rule for '$IPSET_NAME' added."
    else
        log "iptables rule for '$IPSET_NAME' already exists."
    fi

    log "Update completed successfully."
}

# --- Execution Wrapper ---
# Use flock for robust concurrency control. The lock is held on file descriptor 200.
(
    flock -n 200 || die "Script is already running. Another instance holds the lock."
    main
) 200>"$LOCK_FILE"

exit 0
```

## 使用方式

### 创建 `systemd` Service 文件

在 `/etc/systemd/system/` 目录下创建 `china-ip-blocker.service`。

### 创建 `systemd` Timer 文件

这个文件定义了触发上述 `service` 的时间和频率。

在 `/etc/systemd/system/` 目录下创建一个与 `service` 文件同名（但后缀不同）的 `china-ip-blocker.timer` 文件。

### 部署和启用

1.  **放置脚本**：将脚本（例如 `update_china_blocklist.sh`）放置到一个合适的位置，比如 `/usr/local/bin/`，并确保它有可执行权限。
    ```bash
    sudo chmod +x /usr/local/bin/update_china_blocklist.sh
    ```

2.  **重载 `systemd` 配置**：让 `systemd` 知道你创建了新的单元文件。
    ```bash
    sudo systemctl daemon-reload
    ```

3.  **启用并启动定时器**：
    ```bash
    sudo systemctl enable china-ip-blocker.timer
    sudo systemctl start china-ip-blocker.timer
    ```
    *   `enable` 会让定时器开机自启。
    *   `start` 会立即激活定时器，让它开始计时。
    *   **注意**：你只需要 `enable` 和 `start` `.timer` 文件，它会自动管理 `.service` 文件。

### 管理和调试

*   **查看定时器状态**：
    ```bash
    systemctl status china-ip-blocker.timer
    ```
    输出会显示 `NEXT`（下一次运行时间）。

*   **查看服务运行日志**：
    ```bash
    journalctl -u china-ip-blocker.service
    ```
    这会显示脚本的所有输出和错误信息，比传统的日志文件管理更方便。

*   **手动触发一次任务**：
    ```bash
    sudo systemctl start china-ip-blocker.service
    ```

## 检查生效

```bash
root@nagasaki-soyo:/home/tokisaki# sudo ipset list chinablock
Name: chinablock
Type: hash:net
Revision: 7
Header: family inet hashsize 2048 maxelem 65536 bucketsize 12 initval 0xc19a419f
Size in memory: 233664
References: 1
Number of entries: 8711
Members:
58.240.0.0/15
103.3.100.0/22
...
```

```bash
root@nagasaki-soyo:/home/tokisaki# sudo iptables -L INPUT -n -v
Chain INPUT (policy DROP 619 packets, 41086 bytes)
 pkts bytes target     prot opt in     out     source               destination
 5345  916K DROP       0    --  *      *       0.0.0.0/0            0.0.0.0/0            match-set chinablock src
 492K  168M ts-input   0    --  *      *       0.0.0.0/0            0.0.0.0/0
 355K  138M ufw-before-logging-input  0    --  *      *       0.0.0.0/0            0.0.0.0/0
 355K  138M ufw-before-input  0    --  *      *       0.0.0.0/0            0.0.0.0/0
  627 41710 ufw-after-input  0    --  *      *       0.0.0.0/0            0.0.0.0/0
  619 41086 ufw-after-logging-input  0    --  *      *       0.0.0.0/0            0.0.0.0/0
  619 41086 ufw-reject-input  0    --  *      *       0.0.0.0/0            0.0.0.0/0
  619 41086 ufw-track-input  0    --  *      *       0.0.0.0/0            0.0.0.0/0
```