---
title: apt
date: 2021-10-30 17:43:11
author: Tokisaki Galaxy
excerpt: 
 - Linux
 - cloudflare
 - Argo
 - metasploit
 - 网络安全
categories: Linux
---

## 绝对禁止在实战中使用HTTP协议

用cobaltstrike的HTTP上线，被教育局抓了，刚上线几分钟教育局就打来电话了。还好套了层cloudflare argo

## meterpreter/reverse_tcp和meterpreter_reverse_tcp区别

```text
payload/windows/x64/meterpreter/reverse_tcp                               normal  No     Windows Meterpreter (Reflective Injection x64), Windows x64 Reverse TCP Stager

payload/windows/x64/meterpreter_reverse_tcp                               normal  No     Windows Meterpreter Shell, Reverse TCP Inline x64
```

这两个的区别在于第一个是stage模式，第二个是stageless
