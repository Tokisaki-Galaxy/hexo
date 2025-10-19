---
layout: Github云编译Openwrt软件包，再也不用本地配环境
title: Tokisaki Galaxy
excerpt: 自动编译多架构 OpenWrt 软件包的 Action
tags:
 - OpenWrt
 - GitHub Actions
 - CI/CD
date: 2025-10-12 12:32:23
categories:
 - 技术分享
 - 小玩具
---

## 项目地址
https://github.com/Tokisaki-Galaxy/openwrt-package-builder-action

## 简介
对于许多 OpenWrt 爱好者和开发者来说，为不同的目标架构编译软件包可能是一项重复且耗时的工作。为了每次搭建不同环境非常麻烦，我开发并开源了 OpenWrt Package Builder，这是一个基于 GitHub Actions 的自动化工作流，旨在让 OpenWrt 软件包的编译过程变得前所未有的简单和高效。

你只需要将软件包源码上传至 GitHub 仓库，选择一个预设的工作流，修改两个配置变量，即可自动为多个目标平台编译出 .ipk 文件。
下面是项目的README.md

---

一个简单、通用且开箱即用的 GitHub Actions 工作流，用于自动编译任何 OpenWrt 软件包。本项目提供了两种编译模式：**SDK 模式（推荐）** 和 **源码模式**，以满足不同需求。

你只需要将你的软件包源码放在仓库中，选择一个工作流文件，修改两个变量，即可为多个目标架构自动编译出 `.ipk` 文件。

## ✨ 特性

-   **🚀 简单易用**: 只需复制粘贴工作流文件，修改两个环境变量即可。
-   **⚡️ 极速编译 (SDK 模式)**: 利用官方预编译的 SDK，将编译时间从 30+ 分钟缩短至 5 分钟以内。
-   **💡 灵活强大 (源码模式)**: 可编译包括内核模块在内的任何软件包，并支持 `master` 等开发分支。
-   **⚙️ 高度通用**: 可用于编译 LuCI 应用、命令行工具、内核模块等任何类型的 OpenWrt 软件包。
-   **🎯 多目标编译**: 默认配置为 `x86_64`, `armv8`, `mips_mt7621` 等常用架构，可轻松自定义。
-   **📦 自动发布**: 编译成功后，自动将 `.ipk` 文件上传为构建产物 (Artifacts)，方便下载。
-   **💬 提交评论**: (可选) 所有构建任务成功后，会在对应的 Commit 下自动发表评论，提供产物下载链接。

## 🤔 如何选择编译模式？

本项目提供两种工作流，请根据你的需求选择其一。

| 特性 / 场景 | ✅ SDK 模式 (推荐) | ⚠️ 源码模式 |
| :--- | :--- | :--- |
| **编译速度** | **极快** (通常 < 1 分钟) | 慢 (首次编译 > 40 分钟，后续有缓存) |
| **适用包类型** | 大多数 **LuCI 应用** 和 **普通软件包** | **所有软件包**，特别是**内核模块 (`kmod-xxx`)** |
| **支持的 OpenWrt 版本** | 仅支持**官方正式发布版** (如 `v23.05.3`) | 支持**所有版本**，包括 `master` 开发分支 |
| **工作流文件** | `build-with-sdk.yml` | `build-from-source.yml` |

**总而言之：如果不确定，或者你只是编译一个 LuCI 应用，请优先选择 `SDK 模式`。**

## 🚀 如何使用

#### 举个例子

如果有不明白地方，可以参考[这里](https://github.com/Tokisaki-Galaxy/luci-app-tailscale-community/.github/workflows/build.yml)。

#### 步骤 1: 选择并创建工作流文件

根据上方的选择，在你的仓库根目录下创建对应的 `.github/workflows/` 目录和 YAML 文件。

*   **对于 SDK 模式**: 创建 `.github/workflows/build.yml`
*   **对于源码模式**: 创建 `.github/workflows/build-nonSDK.yml`

#### 步骤 2: 复制工作流代码

根据你在上一步的选择，将本仓库中对应文件的完整代码复制过去。

*   ➡️ [**`build-with-sdk.yml` 的代码**](build.yml)
*   ➡️ [**`build-from-source.yml` 的代码**](build-nonSDK.yml)

#### 步骤 3: 修改配置

打开你创建的 YAML 文件，你只需要修改 `env` 部分的 **两个** 变量：

1.  **`PACKAGE_NAME`**:
    将其值修改为你的软件包的目录名。**非常重要**，这个名字必须和你的软件包在仓库中的文件夹名称完全一致。

2.  **`OPENWRT_VERSION`**:
    设置你想要基于哪个 OpenWrt 版本进行编译。
    *   **使用 SDK 模式时**: **必须**是一个官方发布的标签，例如 `v23.05.3`。
    *   **使用源码模式时**: 可以是任何标签或分支名，例如 `v23.05.3` 或 `master`。

> **提示:** 别忘了更新 `README.md` 文件顶部的徽章链接，将 `Tokisaki-Galaxy/openwrt-package-builder-action` 替换成你自己的！

#### 步骤 4: 检查 Makefile (重要)

确保你的软件包目录下的 `Makefile` 文件中正确定义了所有依赖项。本工作流依赖 `make defconfig` 来自动解析并选中这些依赖。

例如:
```makefile
define Package/my-cool-package
  # ...
  DEPENDS:=+libcurl +libjson-c +some-other-package
endef
```

#### 步骤 5: 提交并运行

将你的代码和 `.github/workflows/` 下的 YAML 文件提交并推送到 GitHub。GitHub Actions 会自动开始运行。

你可以在仓库的 `Actions` 标签页查看编译进度。编译完成后，可以在对应的运行记录页面找到并下载 `Artifacts`。

## 🔧 自定义

### 修改编译目标

如果你需要为其他架构编译，可以修改工作流文件中的 `jobs.build.strategy.matrix.target` 部分。只需按照现有格式添加或修改条目即可。

> **请注意**：两种模式的 `matrix` 结构略有不同，请参照各自文件中的格式进行修改。

### 修改触发条件

你可以修改文件顶部的 `on` 部分来更改触发工作流的条件，例如改为 `pull_request` 或定时运行 (`schedule`)。

---

## 协议

本项目使用MIT授权。
