---
title: cobalt-strike笔记
date: 2021-3-27 21:53:14
author: Tokisaki Galaxy
summary: 随便记一下玩cs踩的坑
tags: 
categories: 学习记录
---

## Windows Executeable（s）和>Windows Executeable的区别

Windows Executeable（s）对应的是stage(stageless)
Windows Executeable 对应的是stager
stager是一个小程序，作用是下载stage并运行。stage则就是包含了很多功能的大马，用于接受和执行我们控制端的任务并返回结果。
stager通过各种方式下载stage并运行这个过程称为Payload Staging。同样Cobalt strike也提供了类似传统远控上线的方式，把功能打包好直接运行后便可以与teamserver通讯，这个称为Payload Stageless，如果需要生成Stageless，可以直接在Attack->Package->Windows Executeable（s）下生成。

## 去除CS证书特征

cs证书库默认密码123456，先添加证书，然后再删除默认的证书。

查看证书

```shell
keytool -list -v -keystore cobaltstrike.store
```

添加证书

```shell
keytool -keystore ./cobaltstrike.store -storepass 123456 -keypass 123456 -genkey -keyalg RSA -alias microsoft -dname "CN=microsoft, OU=Microsoft, O=SoftwareSecurity, L=Washington, S=DC, C=US"
```

删除默认证书

```shell
keytool -delete -alias cobaltstrike
```

## DSN beacon

一般来讲系统有个叫`systemd-resolved`的玩意会占用53端口，需要手动解除占用，才能使用cs的dns监听器

最后用nslook ns1.xxxxx来检验是否配置正确。

设置listener的时候，DNS Host(Stager)不是一定要填IP地址，可以填上面DNS Host的任意一条就行。

## 使用Cloudflare隐匿C&C

去Freenom注册个域名，然后挂到Cloudflare下。

Cloudflare -> SSL/TLS -> 源服务器 -> 创建证书

选择PEM格式，把源证书复制下来叫server.pem。私钥复制下来叫server.key。
然后

```bash
openssl pkcs12 -export -in server.pem -inkey server.key -out cfcert.p12 -name cloudflare_cert -passout pass:123456

sudo keytool -importkeystore -deststorepass 123456 -destkeypass 123456 -destkeystore cfcert.store -srckeystore cfcert.p12  -srcstoretype PKCS12 -srcstorepass 123456 -alias cloudflare_cert
```

然后在Malleable C2里加上这个

```yaml
https-certificate {
    set keystore "cfcert.store";
    set password "123456";
}
```

另外一定要记得修改X-Forwarded-For 头配置，不然上线IP就是Cloudflare的数据中心了。

```yaml
http-config {
    set trust_x_forwarded_for "true";
}
```

然后可以访问[https://www.cloudflare.com/ips/](https://www.cloudflare.com/ips/)，去把cloudflare的地址都加入云服务器的安全组，只允许cloudflare链接。
