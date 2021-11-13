---
title: TencentOS安装Docker
date: 2021-11-13 18:5:50
author: Tokisaki Galaxy
summary: 在TencentOS中安装Docker
tags:
 - Linux
 - TencentOS
 - 云服务器
categories: 踩坑记录
---

> TencentOS Server（又名 Tencent Linux，简称 TS 或 tlinux）是腾讯针对云的场景研发的 Linux 操作系统，提供特定的功能及性能优化，为云服务器实例中的应用程序提供高性能及更加安全可靠的运行环境。TencentOS Server 提供免费使用，在 CentOS（及其他发行版）上开发的应用程序可直接在 TencentOS Server 上运行，用户还可持续获得腾讯云团队的更新维护和技术支持。
>
> ...
> TencentOS Server 环境说明
> 用户态环境
> TencentOS Server 2用户态软件包保持与最新版 CentOS 7兼容，即 CentOS 7版本的软件包可以直接在 TencentOS Server 2.4 中使用。
> TencentOS Server 3用户态软件包保持与最新版 RHEL 8兼容，即 RHEL 8版本的软件包可以直接在 TencentOS Server 3.1 中使用。
> ...

[全部简介见官方文档](https://cloud.tencent.com/document/product/213/38027)

增加适用于云场景的新特性、改进内核性能并修复重大缺陷，针对容器场景进行优化，提供了隔离增强和性能优化特性，所以建议使用TencentOS部署Docter。

因为买了个服务器，看到有个没用过的TencentOS想试试，结果发现直接用官方的脚本docker死活装不上去，又找不到解决的办法，因此写下这篇文章记录。
支持一下TencentOS，但是用户社区太小了，希望更多人用增大社区用户量吧。

安装所需软件包

```shell
yum install yum-utils device-mapper-persistent-data lvm2
```

添加docker官方的安装源

```shell
yum-config-manager --add-repo http://download.docker.com/linux/centos/docker-ce.repo
yum list docker-ce --showduplicates | sort -r #会报错，不管就行。
cd /etc/yum.repos.d/
nano docker-ce.repo #修改存储库文件
 ```

将docker-ce.repo改为下面这样，一般只用得上stable，所以就改stable的部分，其他都删了。

```config
[docker-ce-stable]
name=Docker CE Stable - $basearch
#如果是TencentOS 2就是centos/7，如果是TencentOS 3就是centos/8
baseurl=https://download.docker.com/linux/centos/8/x86_64/stable
#baseurl=https://download.docker.com/linux/centos/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/centos/gpg
```

最后安装并启动docker

```shell
yum install docker-ce docker-ce-cli containerd.io
service docker start
systemctl enable docker
```
