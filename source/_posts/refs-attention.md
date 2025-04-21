---
title: ReFS使用注意事项
author: Tokisaki Galaxy
date: 2025-04-21 17:58:22
excerpt: ReFS 使用注意事项，例如禁止自动更新，手动更新，数据压缩，重复数据删除，数据修复，完整性流等。
tags: 
 - ReFS
 - 文件系统
 - Windows
keywords:
 - ReFS
 - 文件系统
 - Windows
 - 完整性流
 - 数据压缩
 - 重复数据删除
 - ReFS数据修复
categories:
  - 文件系统
---

## 什么是ReFS

浏览本文的时候，默认你已经了解了ReFS的基本概念以及优劣。如果不了解，可以参考[ReFS概述](https://learn.microsoft.com/zh-cn/windows-server/storage/refs/refs-overview)。
本文只讨论自己使用ReFS的注意事项，若有命令参数等请自行参考本文的超链接官方文档。
并且本文对ReFS的归纳并不完整，请参阅官方文档。

## ReFS注意事项

下面只讨论作为数据盘的情况，不太建议用作系统盘。虽然新版本的Windows支持从REFS引导，但是社区依然发现在系统还原这种基础问题上依然有问题。

{% note warning %}
强烈建议在使用前，禁止自动升级REFS版本。不然在回撤Windows版本的时候，你会无法访问数据盘，变成RAW分区。
REFS的版本升级是不可逆的，升级后无法降级！！！
{% endnote %}

## 日常维护

### 禁止自动升级（推荐）

```reg
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem]
"RefsDisableLastAccessUpdate"=dword:00000001
;"RefsDisableVolumeUpgrade"=dword:00000001   不用这种方法，似乎会阻止手动升级
```

### 手动升级（推荐）

在你确认你不需要降级的情况下，手动升级ReFS版本。高版本的ReFS会有更好的性能和稳定性。

```powershell
# 查看版本
fsutil fsinfo refsinfo z:

# 升级文件系统版本
fsutil Volume Upgrade <C:>
```

### 数据压缩（推荐）

这个挺好用的。
[数据压缩文档](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/refsutil-compression)

### 重复数据删除（推荐）

[重复数据删除文档](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/refsutil-dedupe)

## 数据修复（必看）

[分析和解决文件系统损坏问题](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/refsutil-triage)
[对于变成RAW(损坏的卷)执行恢复作以检索数据。](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/refsutil-salvage)

## 高级功能

### ReFS完整性流（推荐）

完整性流是 ReFS 的一项功能，它可以确保文件数据的完整性。它使用 CRC32 校验和来验证文件数据的完整性。启用完整性流后，ReFS 会在每次读取文件时计算 CRC32 校验和，并将其与存储在文件中的校验和进行比较。如果校验和不匹配，则 ReFS 会尝试修复文件。
[完整性流文档](https://learn.microsoft.com/zh-cn/windows-server/storage/refs/integrity-streams)

#### Get-FileIntegrity

若要查看是否为文件数据启用了完整性流，请使用 Get-FileIntegrity cmdlet。

```powershell
Get-FileIntegrity -FileName 'C:\Docs\TextDocument.txt'
```
```powershell
Get-Item -Path 'C:\Docs\*' | Get-FileIntegrity
```
也可以使用 Get-Item cmdlet 获取指定目录中所有文件的完整性流设置。

#### Set-FileIntegrity

若要对文件数据启用/禁用完整性流，请使用 Set-FileIntegrity cmdlet。
```powershell
Set-FileIntegrity -FileName 'H:\Docs\TextDocument.txt' -Enable $True
```
也可以使用 Get-Item cmdlet 设置指定文件夹中所有文件的完整性流设置。
```powershell
Get-Item -Path 'H\Docs\*' | Set-FileIntegrity -Enable $True
```
Set-FileIntegrity cmdlet 也可直接用于卷和目录。
```powershell
Set-FileIntegrity H:\ -Enable $True
Set-FileIntegrity H:\Docs -Enable $True
```

### 高级重复数据删除

[高级重复数据删除指令](https://learn.microsoft.com/en-us/powershell/module/microsoft.refsdedup.commands/?view=windowsserver2025-ps)
我一直分不清ReFSDedupSchedule和ReFSDedupScrubSchedule区别。总之我一直用ReFSDedupScrubSchedule。

不过基本上常用的下面这些
```powershell
Disable-ReFSDedup Z:
refsutil dedup z: /d
Enable-ReFSDedup -Volume "Z:" -Type DedupAndCompress
Set-ReFSDedupScrubSchedule -Volume: Z: -Start 2025/4/29 19:0:0 -WeeksInterval 2
Start-ReFSDedupJob -Volume Z: -CompressionFormat LZ4
Stop-ReFSDedupJob Z:
```
