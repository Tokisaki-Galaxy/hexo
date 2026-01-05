---
title: 解决REFS卷变成RAW的经历
date: 2023-10-16 15:58:21
author: Tokisaki Galaxy
excerpt: 之前把分区格式化成REFS，结果系统更新之后变成RAW分区，最后用微软自带的refsutil工具把数据捞出来了。
tags: 
 - REFS
 - refsutil
 - Windows
 - 数据恢复
categories: 
 - 数据恢复
---

## 起因

之前听闻REFS文件系统对NVME和SMR HDD有特别的优化，而且数据安全更好，是未来代替NTFS的文件系统。
所以一年前的时候把两个分区格式化成REFS来试试水。确实效果不错，**除了OneDrive没法在REFS分区上用以外。**

前几天突然内置的SMR HDD在系统更新之后变成了RAW分区。一开始是尝试在文件浏览器里面打开，显示参数错误。后来磁盘管理里显示RAW分区。
一开始以为是系统更新的问题，但是发现另一个REFS分区可以打开，突发奇想去事件管理器里一看，发现原来分区挂了。
![无法打开](https://pic.imgdb.cn/item/652d57f2c458853aef660f9d.png)

然后接着发现电脑很卡，在任务管理器里面看到那个已经挂的磁盘占用率持续90%+的读写，很好奇在干嘛，然后发现事件管理器里面提示这个。

![自动修复不成功](https://pic.imgdb.cn/item/652d57f1c458853aef660d88.png)
![无法纠正](https://pic.imgdb.cn/item/652d5e21c458853aef7691e4.png)

那就只能去整数据恢复了。一开始我打算用R-Studio。
但是发现虽然REFS分区现在可以用R-Studio，但是REFS文件系统在快速迭代，那个软件更新速度赶不上微软的更新速度。所以我用那个软件恢复出来的文件是没有文件目录结构的。最后还是用微软自己家的数据恢复工具refsutil。

## REFS数据打捞工具refsutil

### 什么是refsutil

用于诊断严重损坏的 ReFS 卷（变成RAW）、识别剩余文件，并将这些文件复制到另一个卷。
该工具位于 %SystemRoot%\Windows\System32 文件夹中。
**除非卷为 RAW，否则不必使用 ReFSutil 工具。 如果为只读，则仍可访问数据。**

[Microsoft对refsutil的介绍](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/refsutil)

### 怎么用

>ReFS Salvage 有两个阶段：扫描阶段和复制阶段。 在自动模式下，扫描阶段和复制阶段将按顺序运行。 在手动模式下，每个阶段都可以单独运行。 进度和日志保存在工作目录中，以允许单独运行阶段以及暂停和恢复扫描阶段。

1.确定为什么不能挂载
2.快速扫描阶段
3.完全扫描阶段
4.查看交互式控制台(因为可以看看哪些不需要的，然后在txt文件里删掉)
5.使用列表的复制阶段，把选择的文件复制出来

确定目标卷是否为refs卷，并确定该卷是否可装载。 如果卷不可装载，则会提供原因。
![诊断扫描](https://pic.imgdb.cn/item/652d57fbc458853aef6629f8.png)

![快速扫描阶段](https://pic.imgdb.cn/item/652d57f2c458853aef6610b8.png)

![完全扫描阶段](https://pic.imgdb.cn/item/652d57f1c458853aef660ca4.png)

## 后期的思路

### 启动REFS的完整性流功能

启动完整性流可能有帮助，完整性流是REFS的一项可选功能，保证获得数据是原始未出错。

>完整性流是 ReFS 中的可选功能，它使用校验和来验证和维护数据完整性。虽然 ReFS 始终对元数据使用校验和，但默认情况下，ReFS 不会为文件数据生成或验证校验和。 完整性流是一项可选功能，允许用户对文件数据使用校验和。 启用完整性流后，ReFS 可以清楚地确定数据是否有效或已损坏。 此外，ReFS 和存储空间可以共同自动地更正损坏的元数据和数据。

**！！！对性能有负面影响哦！！！**

```bash
Get-Item -Path 'C:\*' | Set-FileIntegrity -Enable $True
Set-FileIntegrity C:\ -Enable $True

Get-Item -Path 'C:\*' | Set-FileIntegrity -Enable $False
Set-FileIntegrity C:\ -Enable $False

Get-Item -Path 'C:\*' | Get-FileIntegrity
Get-Item -Path 'C:\' | Get-FileIntegrity
```

### 使用软RAID阵列

使用VHDX的虚拟硬盘，并且使用Windows的存储池功能，构造软RAID1。分布在两个硬盘上提升可靠性。
