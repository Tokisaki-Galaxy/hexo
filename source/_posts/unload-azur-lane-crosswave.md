---
title: 【碧蓝航线】Azur Lane Crosswave 解包指南+探索历程
date: 2020-12-20 7:13:17
author: ERU
img: 
coverImg: 
top: false
cover: false
toc: true
comments: true
mathjax: false
summary: 转载【碧蓝航线】Azur Lane Crosswave 解包指南+探索历程
tags: 
 - azur-lane
 - 解包
categories: 游戏
password: 
noindex: false
sitemap: true
---

> 本文转载自(ERU博客)[https://sxjeru.wordpress.com/2020/04/17/%e3%80%90%e7%a2%a7%e8%93%9d%e8%88%aa%e7%ba%bf%e3%80%91azur-lane-crosswave-%e8%a7%a3%e5%8c%85%e6%8c%87%e5%8d%97%e6%8e%a2%e7%b4%a2%e5%8e%86%e7%a8%8b/]

前排注意：任何解包行为需把握资源用途，为尊重作品著作权，请勿用于商业行为或大范围传播！
此处仅提供教程与经验，无资源。
本人共计探索了超过4天，终于摸透了包里的数据。目前除了3D模型还未测试（已可提取），其余资源都可成功提取。

大体流程（目录）：

PAK数据包解包
虚幻4资源文件提取（CG get~）
Spine动画提取*
3D模型构建*（暂无，有生之年更新）

探索历程的无关文字会被折叠，请只看教程的读者放心食用。

文中用到的工具会给出官网与网盘地址，本人希望诸位能支持官方下载。网盘文件可能无法做到及时更新，敬请谅解。

另本人在前几天注意到steam中一则讲述如何拆包取建模的短评被删除了，说明官方还是有打击力度的。如果您是Azur Lane Crosswave或相应资源文件的版权拥有者且不愿看到这篇教程，请与我联系：

sxjeru@gmail.com

此篇教程依据全站规则，适用于CC BY-NC-SA 4.0协议共享。

一、裂解PAK

或许是幸运，或许是“自知之明”，总之地雷社没有给ALC的数据包加密，这也使得解包变得异常简单。这一步并没有坑，因而也就没有探索文字啦。

准备解包工具QuickBMS（官网、网盘）与UE4解包脚本（官网同上、网盘）。
!(znarqh5exmviggm)[https://sxjeru.files.wordpress.com/2020/04/znarqh5exmviggm.png]
双击“quickbms.exe”，依次选择脚本、PAK数据包（通常位于“~\Azur Lane Crosswave\Azurlane\Content\Paks”）、解包位置（资源保存至何处）。
等待……  Done！
二、渗透UE4

ALC采用UE4（v4.21.2.0）游戏引擎，导致所有资源文件都被“加密”成uasset、uexp等文件，如何将这些还原成原始文件是这一关的核心任务。

> 吐槽
> 手贱用umodel选游戏路径时把所有解包出来的资源文件全选了，结果分析就花了半个多小时……
> 而且umodel稳定性也不太好，在我手上至少崩了30多回。另外它无法提取所有文件，这可着实坑惨我了……

1.准备提取工具UE Viewer（官网、网盘）。

2.双击“umodel.exe”，按图中配置参数，路径自选，不建议选择根路径（Content），否则所需时间较长。我在下面列出了子目录中包含的部分资源，可参考个人需要选择相应路径。
最后点击“OK”，等待处理。（此时命令符窗口无显示，请耐心等待）
![7~$P0]J57V)OQ)}0%ULLLLQ.png](https://sxjeru.files.wordpress.com/2020/04/7p0j57voq0ullllq.png)
Battle：含有战斗场景下的各种3D模型，2D UI设计等。
Event：含有VN（视觉小说）界面下的各种立绘、CG。
Sound：含有游戏内所有的BGM、SE、Voice（配音）。
System：含有游戏主页面的UI设计文件。
World*：含有主线剧情内世界场景的资源文件，包括地图架构，2D动态Q版人物等。

4.处理完成后弹出资源选择窗口，左侧目录树找到目标后可在右侧双击感兴趣的资源来预览。建议预览较大的文件，这些文件通常是图片、模型、音乐。TD7S`[]%7SR{O_O$4HP6KOK.png

5.预览完毕后可以直接在预览器的“Tools”菜单中导出，或在文件浏览窗口批量选择需导出的文件，点击下方“Export”，选好路径与图片格式（仅影响图片文件）后确认导出即可。
![a](https://sxjeru.files.wordpress.com/2020/04/31q40q0eth2mxcb1.png)

**注：UE Viewer仅能导出部分资源文件，一些数据文件无法识别与导出。**

通常没有什么刚需的话，止步于此即可。也就只有我这么死脑筋的人会去想下面的内容了……

三、​​啊Q版小人太可爱了还会动 i了i了 一定要把她们导出来！~~

闹着玩嘛，这节主要是来提取ALC地图场景那些Q版小人。在这个坑里花了70%的时间才爬出来，获得不少经验的同时也感谢各位提供神奇工具的开源作者。

在这节里，经验伴你同行。

人生经验（点击查看）
1. 经分析可知此类2D建模由Spine软件设计，单个建模包含json*1、atlas*1、png*1，对应解包后的路径为“~\Azurlane\Content\World\Spine”。其中“Ch001”即岛风，“Ch002”即…… 额这是谁来着？

Ch002_touch.png

是绫波吗…？是她吧…… 誒别打我啊！

剩下52位诸位若学成的话就可以自己提取哦~ 请自行探索吧~~（按道理每艘秘书舰都有的说）

2. 准备文本编辑器（无脑推荐VS Code、Sublime Text 3，Notepad++ 因过于自由而不推荐），Spine Viewer WPF（作者：kiletw）。

注：SpineViewerWPF需要.NET Framework 4.7.2与Microsoft XNA Framework Redistributable 4.0作为前置库。

经验+1（点击查看）
3. 利用第二节的方法，通过 umodel 从“~\Azur Lane Crosswave\World\Spine\Chxxx\Textures”（xxx指数字，为避免误解下面采用001，毕竟小岛风辣么可爱，拿来练手也不错~）得到Ch001.png。

4. 神奇又关键的一步。资源管理器定位至“~\Azurlane\Content\World\Spine\Ch001”，将“Ch001.uexp”用文本编辑器打开，得到下图内容。（可能会有所卡顿）Z9YKX_8E(JQG)4FCKFXBGZL.png

将分界线（一排乱码）上端的文字复制，注意顶端乱码不用，按岛风举例是从“Ch001.png”到“index: -1”，创建一个新文本文件，重命名为Ch001.atlas，将内容粘贴进去，保存。

再将分界线下端文字复制，底端乱码不用，同样以岛风为例是从“{“skeleton”:”到“”angle”:-0.05}]}}}}}”。注意编辑器显示缺陷导致的复制不全。3{R_HUHH}4NX~D@BG~(~T~N.png

创建新文本文件，命名为Ch001.json，将内容粘贴进去，保存。

建议移至同个文件夹，便于处理。顺便吹一波QTTabBar。

(]B)C%{_ERK)JAHTS3L~~Q0.png

痛苦不堪的经历（点击查看）
接下去我会分成两种情况，5富人党（购买了Spine正式版）与6穷人党（如本人），分别用两种颜色描述。

由于个人经济情况限制，以下步骤可能不准确，以Spine客服为准。

5-1. 发动钞能力，购买Spine！

5-2. Spine中新建项目，选择“导入数据”，导入Ch001.json。再选择“纹理解包器”，图集文件导入Ch001.atlas，确保Ch001.png在同一文件夹，选择输出文件夹后确定。

5-3. 将导出的许多单张图与Ch001.json放在一起，就能在Spine中预览到了。更多功能请自行探索，此处不再赘述。毕竟这不是教程想表达的方法。

5-4. 选择导出，各种图片视频格式任君挑选。

6. 接上第4步。双击打开“SpineViewerWPF.exe”，在“Use Version”菜单中选择“3.7.83”（注意不是最新的3.8.x）。再点击“File -> Load Spine”，选择Ch001.atlas文件路径，并保证png与json在同一文件夹，能看到如下图。[T6(KPEMFN55`9QP}(3`PLM.png

其中左侧“Anime”可选择不同动画，一个角色通常有多种动画（如岛风有3种）。下方是播放控件与截图（相机键）还有Gif导出（摄像键）。

没错，白嫖就是那么简单~~  不过探索出这条路来并不是那么简单的……

在此提醒下，导出Gif时会占用大量内存资源，请留出足够的内存，否则程序会崩溃。

现在让我们看看探索历程的艰辛——（点击查看）
感谢你能看到最后，祝提取顺利。

当然如果有了解Spine Web用法的盆友，欢迎联系我，我实在是无法玩明白这东西。这是我搭建的测试网址：http://sxj.mcmod.cn/123.html
不知道为什么就是不显示……

插一句，岛风这憨憨，我要定了，都礼貌点儿，别抢。

最后有个彩蛋~ 虽与教程无关，但挺有趣的。