---
title: WSL安装metasploit
author: Tokisaki Galaxy
top: false
cover: false
toc: true
comments: true
mathjax: false
noindex: false
sitemap: true
date: 2020-10-25 08:00:53
img:
coverImg:
summary: wsl，debian安装metasploit，并链接数据库。
tags: 
 - win10
 - WSL
 - metasploit
 - debian
categories: 软件安装与配置
password:
---

https://mirrors.tuna.tsinghua.edu.cn/help/debian/清华的debian国内镜像

# 将系统语言改为中文
```shell
sudo dpkg-reconfigure locales
#勾上zh_CN GB2312   zh_CN.GBK GBK   zh_CN.UTF-8 UTF-8
#重启生效
```

# 安装metasploit-framework
```shell
sudo nano /etc/apt/sources.list
#加入下面这一行
deb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
```

```shell
sudo wget -q -O - https://archive.kali.org/archive-key.asc | sudo apt-key add
sudo apt update
sudo apt install metasploit-framework
```

# 连接数据库

WSL中metasploit链接数据库有点麻烦，如果按照正常操作会报下面这个错误。
```shell
msfconsole
>db_status
postgresql selected,no connect
>msfdb init
System has not been booted with systemd as init system (PID 1). Can't operate.
```

原理是wsl启动的时候没systemd。

## 解决方法

启动数据库服务
```shell
msfdb init
sudo service postgresql start
sudo service postgresql status
```

手动建立数据库用户，数据库
```shell
# 
cd /etc/postgresql/13/main
sudo -u postgres psql
alter user postgres password 'root';
create user msf with password 'metasploit' createdb;
create database msf with owner=msf;
quit
```
在metasploit中链接
```shell
msfconsole
#db_connect 数据库用户名:数据库密码@数据库ip[:数据库端口]/数据库名
db_connect msf:metasploit@127.0.0.1:5958/msf
db_status
```

设置自动连接
```shell
sudo nano /usr/share/metasploit-framework/config/database.yml
```
将里面username,password改成自己设置的。