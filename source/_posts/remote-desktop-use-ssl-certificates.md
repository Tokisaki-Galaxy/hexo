---
title: 远程桌面使用SSL证书
date: 2021-4-30 19:57:20
author: Tokisaki Galaxy
excerpt: 让远程桌面使用SSL证书，解决证书错误
tags: 
 - Windows
 - 远程桌面
 - SSL
categories: 软件安装与配置
---

远程桌面默认的证书是自签的，会报证书错误，为了安全起见使用CA签的证书。
去腾讯云TrustAsia弄个一年的免费证书，然后下载。因为windows不能识别这玩意，需要先转换成p12格式。
**openssl是git自带的**

```bash
 openssl pkcs12 -export -clcerts -in [xxx.pem] -inkey [xxx.key] -out [xxx.p12]
```

把.p12文件拷到服务器，然后导入，并记下证书指纹。

还需要将导入后的密钥设置权限，添加`NETWORK SERVICE`用户的Read（读）权限。

```bash
wmic /namespace:\\root\cimv2\TerminalServices PATH Win32_TSGeneralSetting Set SSLCertificateSHA1Hash="<指纹>" 。
```

重启远程桌面服务，当你重新连接的时候你就会在上面的连接栏看到一把锁的图案，并且没有证书错误提示了。

```bash
net stop termservice && net start termservice
```
