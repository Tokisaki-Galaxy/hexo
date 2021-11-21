---
title: apt
date: 2021-10-30 17:43:11
author: Tokisaki Galaxy
summary: 
 - Linux
 - cloudflare
 - Argo
 - metasploit
 - 网络安全
categories: 踩坑记录
---

## meterpreter/reverse_tcp和meterpreter_reverse_tcp区别

```text
payload/windows/x64/meterpreter/reverse_tcp                               normal  No     Windows Meterpreter (Reflective Injection x64), Windows x64 Reverse TCP Stager

payload/windows/x64/meterpreter_reverse_tcp                               normal  No     Windows Meterpreter Shell, Reverse TCP Inline x64
```

这两个的区别在于第一个是stage模式，第二个是stageless
