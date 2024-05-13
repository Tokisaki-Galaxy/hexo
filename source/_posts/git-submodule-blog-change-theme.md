---
title: Git子模块教程：更换Hexo博客主题
date: 2024-5-13 23:38:44
author: Tokisaki Galaxy
excerpt: 使用git submodule更换Hexo博客主题
tags: 
 - Hexo
 - Github
 - Git
 - Submodule
categories: blog
---

##  0.背景
很久之前写的博客使用Hexo搭建[传送门](https://tokisaki.top/blog/make-blog/)，不同于其他教程，我主张把存储库整个作为**私有存储库**放到github上。
优点包括没必要用当时装hexo的电脑写文章，可以用github网页版直接传一个md文件就可以。
而且原版的方式如果想迁移很麻烦，因为是本地编译，每次迁移要下载一堆库。而我这种方式只需要把存储库clone下来就可以了（由Serverless平台来编译成静态文件）。

而我的这种方式更换主题不同于其他方式，需要作为submodule来处理。
我使用的方法主题是一个从别人那里fork来的独立的存储库，可以很容易的直接在github网页版更新后继版本。
而其他人的deploy方法是直接把主题clone到themes文件夹下，这样就没法直接更新了。

所以我这里记录一下如何使用git submodule更换主题。

## 1. 找一个主题，然后fork

## 2.设置submodule

### 方式一：直接设置

[知乎submodule教程](https://zhuanlan.zhihu.com/p/404615843)
> 添加一个远程仓库项目 https://github.com/iphysresearch/GWToolkit.git 子模块到一个已有主仓库项目中。代码形式是 git submodule add <url> <repo_name>， 如下面的例子：`git submodule add https://github.com/iphysresearch/GWToolkit.git GWToolkit`
> 如果你是旧版 Git 的话，你会发现 ./GWToolkit 目录中是空的，你还需要在执行一步「更新子模块」，才可以把远程仓库项目中的内容下载下来。`$ git submodule update --init --recursive`

### 方式二：手动设置(推荐)
在主题文件夹下面clone你fork来的主题存储库。
在主存储库目录（和.git同级的目录）下面创建`.gitmodules`文件，写入下面内容
```bash
[submodule "themes/hexo-theme-matery"]
	path = themes/hexo-theme-matery
	url = https://github.com/Tokisaki-Galaxy/hexo-theme-matery.git
```

进入主存储库目录下面的.git文件夹，修改config文件，添加下面内容
```bash
[submodule "themes/hexo-theme-matery"]
	url = https://github.com/Tokisaki-Galaxy/hexo-theme-matery.git
```
最后使用`git submodule status`来检查是否正确设置。

### 异常处理

一般来讲只要使用手动设置就不会有问题。如果你无法使用方法一，请直接使用方法二手动添加。

检查步骤：
 - 检查主存储库目录下面是否存在.gitmodules文件。
 - 检查主存储库.git目录下面config文件夹是否存在[submodules]标签。
 - 执行`git submodule status`，如果显示为 `No submodule mapping found`，表示子模块的仓库没有在本地克隆。我们可以使用 `git submodule update --init` 命令来克隆子模块的仓库到本地。

## 3.检查设置成submodule

把本地的所有更改提交到主存储库，然后push到github。打开Github你的存储库网站，检查是否有主题文件夹图标不同，而且名字后面有@xxxx的版本号。如果不存在请进行手动设置。（一般是缺少.gitmodules文件）
并且点击名字后面有@xxxx的子模块进去检查是否能进入，是否有文件。