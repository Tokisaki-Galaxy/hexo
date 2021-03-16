---
title: jsdelivrCDN使用方法
date: 2021-2-28 11:22:15
author: Tokisaki Galaxy
summary: jsdelivrCDN使用方法
tags:
 - jsdelivr
 - 优化
categories: 学习记录
---

博客上用了很多js和css，如果都通过服务器加载，加载速度会很慢（一开始我用这个主题，GithubPages托管的时候，第一次加载用来40s+）。所以需要把js和css文件放到CDN上。
我知道的公共CDN有[BootCDN](https://www.bootcdn.cn/)和[JSDELIVR](https://www.jsdelivr.com/)。
jsdelivr可以直接加载github上的文件，bootcdn不行。
我原来使用的是BootCDN，但是这玩意比jsdelivr慢，并且只能用官方的库，所以改用了jsdelivr。

## jsdelivr的加载方法

### Github

**一言蔽之，就是`https://cdn.jsdelivr.net/gh/用户名称/仓库名称@版本号/目录`。**

详细版：

```json
// 加载任何GitHub的发布、提交或分支
// 注意:我们建议在支持npm的项目中使用npm
https://cdn.jsdelivr.net/gh/user/repo@version/file

// 加载 jQuery v3.2.1
https://cdn.jsdelivr.net/gh/jquery/jquery@3.2.1/dist/jquery.min.js

// 使用一个版本范围而不是特定的版本
https://cdn.jsdelivr.net/gh/jquery/jquery@3.2/dist/jquery.min.js
https://cdn.jsdelivr.net/gh/jquery/jquery@3/dist/jquery.min.js

// 完全省略版本以获得最新的版本
// 你不应该在生产中使用它
https://cdn.jsdelivr.net/gh/jquery/jquery/dist/jquery.min.js

// 添加 ".min" 到任何js/css文件
// 如果它不存在，我们将为您生成它（并帮你压缩
https://cdn.jsdelivr.net/gh/jquery/jquery@3.2.1/src/core.min.js

// 在末尾添加 "/" 以获得目录列表
https://cdn.jsdelivr.net/gh/jquery/jquery/
```

### npm

gh换成npm，没有用户名。其他不变。

```json
https://cdn.jsdelivr.net/npm/包名@版本号/目录
```

## 刷新CDN

把链接中的`https://cdn.jsdelivr.net/`换成`https://purge.jsdelivr.net/`就行了。

## 注意事项

如果不加"@版本/分支"偶尔会错误的出现文件过大报错，并且无法加载，（10KB+>50MB ¿)例如下面这一条是有潜在问题的。
`https://cdn.jsdelivr.net/gh/jquery/jquery/src/core.min.js`
所以无论什么时候，必须加上分支/版本名，上面的URL必须写成这样：
`https://cdn.jsdelivr.net/gh/jquery/jquery@latest/src/core.min.js`
这应该也算个小小的bug？
