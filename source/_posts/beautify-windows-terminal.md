---
title: 美化Windows Terminal
date: 2021-2-27 8:42:48
author: Tokisaki Galaxy
summary: 美化Windows Terminal
tags:
 - 美化
 - Windows Terminal
categories: 软件安装与配置
---

![最后的效果](https://cdn.jsdelivr.net/gh/Tokisaki-Galaxy/res/site/source/_posts/beautify-windows-terminal/1.webp)

## 安装Windows Terminal

有两种下载方法，去[Github](https://github.com/microsoft/terminal/releases)或者Windows Store。
建议去Windows Store下，可以自动更新。

### 更新Windows Powershell

**这一步是可选的**
Windows自带的是万年不变的5.0，可以更新到新的版本，目前为止，最新的LTS长期支持是7.0.5版本。
[更新方法](https://aka.ms/PSWindows)

## 更改Windows Terminal配色方案

[https://docs.microsoft.com/zh-cn/windows/terminal/customize-settings/color-schemes](https://docs.microsoft.com/zh-cn/windows/terminal/customize-settings/color-schemes)

## 设置脚本运行权限

默认是禁止所有脚本运行，可以通过`Get-ExecutionPolicy`来查看当前脚本运行策略，然后通过`Set-ExecutionPolicy`来设置新的策略。
可选的策略

```json
Restricted——默认的设置， 不允许任何script运行
AllSigned——只能运行经过数字证书签名的script
RemoteSigned——运行本地的script不需要数字签名，但是运行从网络上下载的script就必须要有数字签名
Unrestricted——允许所有的script运行
```

可以输入`Set-ExecutionPolicy all`来使用`AllSigned`策略，即允许只输入前面几个字符。

为了之后的美化设置，我们需要设置为`RemoteSigned`。
输入`Set-ExecutionPolicy remote`即可。

## 安装美化模块

### 安装模块命令语法

Powershell下安装模块的命令
`Install-Module [moudel name]`
`Install-Module [moudel name] -Scope CurrentUser  #只为当前用户安装`

## 安装模块

```shell
Install-Module posh-git
Install-Module oh-my-posh
Install-Module DirColors  #让 ls (Get-ChildItem) 像 Unix 系终端一样具有多彩色
```

## 加载模块与设置主题

**注意，加载主题的命令是`Set-PoshPrompt -Theme powerline`，而不是`Set-Theme powerline`！！！**

```shell
Import-Module DirColors
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme powerline
```

[这里是oh-my-posh的链接](https://ohmyposh.dev/docs/)，放在这里给有可能需要的人用。
这时已经可以看到美化后的终端了，但是关闭后就会重置之前的设置，所以需要把刚才这几段命令放到每次打开终端自动加载的脚本里。

## 保存设置

### 为你一个用户保存

输入`$PROFILE`，然后它会显示你个人用户每次打开终端自动运行的脚本，然后用notepad编辑那个文件，把下面这一段添加进去。
```shell
Import-Module DirColors
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme powerline
```

### 为这台电脑上所有用户保存

一样的操作，只不过要修改的文件在`"%windir%\system32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1"`。

## 乱码的解决方法

乱码是因为oh-my-posh使用了图标，但是你的字体里又没有包含图标，所以需要换一个新的，带图标的字体。
[Nerd字体下载地址](https://www.nerdfonts.com/)
我自用的是Nerd里面的[Cascadia Cove Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip)，感觉挺舒服的。
下载完之后安装到电脑，然后在Windows Terminal设置里面使用该字体就好了。

## 自用的设置文件(只是颜色的那一部分)

```json
"profiles":
    {
      "defaults": {
        // Put settings here that you want to apply to all profiles.
        "acrylicOpacity": 0.6, //背景透明度(0-1)
        "useAcrylic": true, // 启用毛玻璃
        "backgroundImage": "C:\\Users\\Tokisaki_Galaxy\\OneDrive\\图片\\SCP.jpg", //背景图片
        "backgroundImageOpacity": 0.1, //图片透明度（0-1）
        "experimental.retroTerminalEffect": false, //复古的CRT 效果
        "backgroundImageStretchMode": "uniformToFill", //填充模式
        "fontFace": "CaskaydiaCove Nerd Font", //字体名称
        "fontSize": 12, //文字大小
        "fontWeight": "normal", //文字宽度，可设置加粗
        "colorScheme": "Solarized Light", //主题名字
        "cursorColor": "#FFFFFF", //光标颜色
        "cursorShape": "bar", //光标形状
        "antialiasingMode": "cleartype" //ClearType
      },
```
