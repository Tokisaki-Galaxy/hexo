---
title: windows-server-firewall
date: 2025-2-12 16:21:1
author: Tokisaki Galaxy
excerpt: 
tags: 
categories: 
---

Get-NetConnectionProfile | Select-Object InterfaceAlias, Name, NetworkCategory | Format-Table -AutoSize
Get-NetConnectionProfile | Where-Object { $_.InterfaceAlias -like 'ZeroTier*' } | ForEach-Object { Set-NetConnectionProfile -Name $_.Name -NetworkCategory Private}

NetSh Advfirewall set allprofiles state off
NetSh Advfirewall show allprofiles