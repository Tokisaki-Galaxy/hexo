---
title: Google AI Studio 对话导出工具
date: 2025-12-04 15:11:53
author: Tokisaki Galaxy
excerpt: 针对 Google AI Studio 缺少原生导出功能的问题，开发了一款基于 Tampermonkey 的用户脚本。该脚本可将对话内容完整抓取并导出为 JSON 格式，支持 Markdown 渲染，便于后续的资料整理与归档。
tags:
 - Tampermonkey
 - Google AI Studio
 - 效率工具
 - JavaScript
categories: 
 - 效率工具
---

## 背景与动机

Google AI Studio 提供了优秀的对话体验。但在科研或日常记录中，我们常面临数据留存的难题。原生界面并未提供导出选项。

若要保存灵感、整理代码片段或备份团队协作内容，逐条复制粘贴显然过于低效。这种重复性劳动不应占据宝贵的时间。

为此，编写了一款基于 Tampermonkey 的用户脚本：**AI Studio Chat Exporter**。它旨在解决这一痛点，实现对话内容的一键打包。

## 功能概述

该脚本主要实现了以下几项功能，旨在简化数据获取流程：

*   **一键导出**
    页面加载完成后，屏幕上会出现一个悬浮的 “Export JSON” 按钮。点击它，即可将当前的聊天内容打包成 JSON 文件并下载。

*   **完整抓取**
    脚本会自动处理页面的滚动加载。这确保了每一轮对话——无论是用户的输入还是模型的回复——都能被完整收录，避免了手动复制可能产生的遗漏。

*   **系统提示词提取**
    System Prompt 往往定义了对话的基调和规则。即使侧边栏处于折叠状态，脚本也会自动展开并捕获这部分关键信息。

*   **Markdown 格式支持**
    模型输出中的标题、列表、代码块等元素，会被转换为标准的 Markdown 格式。这使得导出的内容可以直接粘贴到笔记软件或博客中，无需二次排版。

*   **多语言适配**
    界面提示词支持简体中文、英文、德语等多种语言，会根据浏览器的语言设置自动切换。

## 部署方法

使用该脚本需要浏览器扩展程序的支持。

1.  **环境准备**
    在 Chrome、Edge 或 Brave 等浏览器中安装 **Tampermonkey** (油猴) 扩展。

2.  **脚本安装**
    获取 `script.js` 脚本文件或链接。Tampermonkey 会自动识别并弹出安装界面，点击 “Install” 即可。
    [点此安装](https://greasyfork.org/zh-CN/scripts/557864-ai-studio-chat-exporter-markdown-code-block-support)

3.  **权限确认**
    确保脚本的匹配规则覆盖了 `https://aistudio.google.com/prompts/*` 这一域名。

4.  **生效验证**
    刷新 AI Studio 的对话页面。若页面顶部出现一个可拖拽的蓝色按钮，即表示安装成功。

## 使用说明

操作流程非常直观：

1.  打开任意一个 AI Studio 对话项目。
2.  找到悬浮按钮，将其拖动到不遮挡视线的位置。
3.  点击按钮。脚本将自动执行以下操作：
    *   获取系统提示词 (System Instruction)。
    *   滚动并加载所有历史对话。
    *   将内容格式化为 Markdown。
    *   生成并下载 JSON 文件。

文件默认以当前项目的标题命名，例如 `My_Project.json`。

## 数据结构

导出的 JSON 文件结构清晰，便于程序二次处理或人工阅读：

```json
{
  "system_instruction": "项目的系统提示词",
  "messages": [
    { "role": "user", "content": "用户输入的 Markdown 文本" },
    { "role": "assistant", "content": "模型输出的 Markdown 文本" }
  ]
}
```

## 注意事项

在使用过程中，可能会遇到一些细微的情况：

*   **按钮未显示**：请检查 Tampermonkey 扩展是否已启用，或者尝试刷新页面。
*   **导出内容为空**：脚本依赖于页面的 DOM 结构。请确保对话区域已正常加载，且能够滚动。
*   **System Prompt 字段为空**：并非所有对话都设置了系统提示词。若原项目未设置，该字段自然为空。
*   **权限提示**：脚本更新时，Tampermonkey 可能会请求新的地址权限，允许即可。

## 结语

AI Studio Chat Exporter 将繁琐的备份工作简化为一个点击动作。这不仅节省了时间，也让知识管理变得// filepath: x:\GitHub\hexo\source\_posts\aistudio-dump-script.md
---
title: Google AI Studio 对话导出工具
date: 2025-12-04 15:11:53
author: Tokisaki Galaxy
excerpt: 针对 Google AI Studio 缺少原生导出功能的问题，开发了一款基于 Tampermonkey 的用户脚本。该脚本可将对话内容完整抓取并导出为 JSON 格式，支持 Markdown 渲染，便于后续的资料整理与归档。
tags:
 - Tampermonkey
 - Google AI Studio
 - 效率工具
 - JavaScript
categories: 
 - 效率工具
---

## 背景与动机

Google AI Studio 提供了优秀的对话体验。但在科研或日常记录中，我们常面临数据留存的难题。原生界面并未提供导出选项。

若要保存灵感、整理代码片段或备份团队协作内容，逐条复制粘贴显然过于低效。这种重复性劳动不应占据宝贵的时间。

为此，编写了一款基于 Tampermonkey 的用户脚本：**AI Studio Chat Exporter**。它旨在解决这一痛点，实现对话内容的一键打包。

## 功能概述

该脚本主要实现了以下几项功能，旨在简化数据获取流程：

*   **一键导出**
    页面加载完成后，屏幕上会出现一个悬浮的 “Export JSON” 按钮。点击它，即可将当前的聊天内容打包成 JSON 文件并下载。

*   **完整抓取**
    脚本会自动处理页面的滚动加载。这确保了每一轮对话——无论是用户的输入还是模型的回复——都能被完整收录，避免了手动复制可能产生的遗漏。

*   **系统提示词提取**
    System Prompt 往往定义了对话的基调和规则。即使侧边栏处于折叠状态，脚本也会自动展开并捕获这部分关键信息。

*   **Markdown 格式支持**
    模型输出中的标题、列表、代码块等元素，会被转换为标准的 Markdown 格式。这使得导出的内容可以直接粘贴到笔记软件或博客中，无需二次排版。

*   **多语言适配**
    界面提示词支持简体中文、英文、德语等多种语言，会根据浏览器的语言设置自动切换。

## 部署方法

使用该脚本需要浏览器扩展程序的支持。

1.  **环境准备**
    在 Chrome、Edge 或 Brave 等浏览器中安装 **Tampermonkey** (油猴) 扩展。

2.  **脚本安装**
    获取 `script.js` 脚本文件或链接。Tampermonkey 会自动识别并弹出安装界面，点击 “Install” 即可。

3.  **权限确认**
    确保脚本的匹配规则覆盖了 `https://aistudio.google.com/prompts/*` 这一域名。

4.  **生效验证**
    刷新 AI Studio 的对话页面。若页面顶部出现一个可拖拽的蓝色按钮，即表示安装成功。

## 使用说明

操作流程非常直观：

1.  打开任意一个 AI Studio 对话项目。
2.  找到悬浮按钮，将其拖动到不遮挡视线的位置。
3.  点击按钮。脚本将自动执行以下操作：
    *   获取系统提示词 (System Instruction)。
    *   滚动并加载所有历史对话。
    *   将内容格式化为 Markdown。
    *   生成并下载 JSON 文件。

文件默认以当前项目的标题命名，例如 `My_Project.json`。

## 数据结构

导出的 JSON 文件结构清晰，便于程序二次处理或人工阅读：

```json
{
  "system_instruction": "项目的系统提示词",
  "messages": [
    { "role": "user", "content": "用户输入的 Markdown 文本" },
    { "role": "assistant", "content": "模型输出的 Markdown 文本" }
  ]
}
```

## 注意事项

在使用过程中，可能会遇到一些细微的情况：

*   **按钮未显示**：请检查 Tampermonkey 扩展是否已启用，或者尝试刷新页面。
*   **导出内容为空**：脚本依赖于页面的 DOM 结构。请确保对话区域已正常加载，且能够滚动。
*   **System Prompt 字段为空**：并非所有对话都设置了系统提示词。若原项目未设置，该字段自然为空。
*   **权限提示**：脚本更新时，Tampermonkey 可能会请求新的地址权限，允许即可。

## 结语

AI Studio Chat Exporter 将繁琐的备份工作简化为一个点击动作。这不仅节省了时间，也让知识管理变得更加有序。希望这个小工具能为各位的研究与工作带来便利。
