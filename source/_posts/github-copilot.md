---
title: 在pwsh里面使用终端Github Copilot
date: 2023-12-20 18:32:32
author: Tokisaki Galaxy
tags: 
 - Windows Terminal
 - Powershell
categories: 编程
---

如果在终端里面也可以使用github copilot将会方便很多，很多命令不用刻意去记忆，也不用去网上找很久。
<!-- more -->
先去下载[Github-CLI](https://cli.github.com/)。
然后用`gh auth login`登陆，默认是不安装copilot的，要手动安装插件`gh extension install github/gh-copilot`。

测试一下`gh copilot`是不是正常使用。

然后设置别名，方便使用。
通过读取配置文件`echo $PROFILE`的路径，然后修改`notepad $PROFILE`。
加入以下内容。

```shell
function Github-Copilot-Explain { gh copilot explain $args }
function Github-Copilot-Suggest { gh copilot suggest $args }

Set-Alias -Name cs -Value Github-Copilot-Suggest
Set-Alias -Name ce -Value Github-Copilot-Explain
```