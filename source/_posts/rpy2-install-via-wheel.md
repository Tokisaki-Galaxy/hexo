---
title: 通过wheel文件解决rpy2安装权限问题
author: Tokisaki Galaxy
date: 2025-02-27 23:01:48
excerpt: 解决Windows环境下pip安装rpy2时出现的权限错误问题
tags:
- Python
- rpy2
- 安装问题
categories:
- 编程
---

## 问题背景

最近在尝试Python与R语言交互时，需要安装rpy2这个包。按照常规方式使用pip安装时，却不断遇到各种各样的错误：

```bash
        File "Z:\ProgramData\miniconda3\Lib\subprocess.py", line 1538, in _execute_child
          hp, ht, pid, tid = _winapi.CreateProcess(executable, args,
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      PermissionError: [WinError 5] Access is denied
      [end of output]

  note: This error originates from a subprocess, and is likely not a problem with pip.
error: subprocess-exited-with-error

× Getting requirements to build wheel did not run successfully.
│ exit code: 1
╰─> See above for output.

note: This error originates from a subprocess, and is likely not a problem with pip.
```

还有其他各种各样的问题，在重新设置R_HOME(https://www.cnblogs.com/Xeonilian/p/windows_rpy2_install.html)、安装R_Tools(https://blog.csdn.net/BioFlorist/article/details/121665959)、安装MinGW等等方法都无法解决。
这个问题困扰了我整整两天，尝试了各种方法都未能解决。
甚至到了我一度以为是rpy2不支持windows（在rpy2的官网上，他说对windows的支持不由官方提供，而是由社区提供），但是我同学却轻轻松松安装成功了。

## 解决方案

在多次尝试失败后，网上别人推荐使用conda安装的方法，但是那种虽然能安装，但是却使用的是conda安装的R环境，而不是我本地的R环境。有大量的R包需要重装。
在找了许久之后，我发现可以通过预编译的wheel文件来绕过编译问题。
但是，网上很多教程用的是[托管在www.lfd.uci.edu的wheel包](https://www.cnblogs.com/cloudtj/articles/6372197.html)，但是维护托管网站的教授因为服务器费用问题，已经关闭不再提供对rpy2的托管。
不过后来经过寻找，我在[piwheels](https://www.piwheels.org/project/rpy2/)网站上找到了预编译好的rpy2 wheel文件。
虽然没有很多版本的wheel文件，最新的稳定版3.5.17也没有，只有3.6.0.dev2 pre-release，但是怎么说都比没有强很多了。

另外，[官网上也有些R和rpy2的兼容性情况](https://rpy2.github.io/doc/v3.5.x/html/overview.html#background)。

## 安装步骤

1. 访问[piwheels](https://www.piwheels.org/project/rpy2/)
2. 根据你的python版本，找到对应的wheel文件
3. 下载wheel文件到本地
4. 打开命令行，使用以下命令安装：

```bash
pip install 你下载的wheel文件路径
```

## 安装要点
安装前请确保系统中已经正确配置了R语言环境，rpy2需要调用R的库文件。

## 总结
当pip编译rpy2出现错误时，可以去www.piwheels.org试试看，能不能搜到预编译的wheel文件。
虽然这个过程有点曲折，但希望我的经历能帮助到遇到类似问题的你，少走一些弯路。