---
title: 住理生活自动记账工具开发实践
date: 2025-12-23 17:09:07
author: Tokisaki Galaxy
excerpt: 基于 Tesseract.js 与 IndexedDB 实现的校园生活消费自动统计工具，解决校园 App 缺乏财务统计功能的问题。
tags:
 - JavaScript
 - OCR
 - 财务管理
categories:
 - 前端
 - 开发笔记
---

{% note info %}
项目在线地址：[住理生活 · 记账助手](https://zhulishenghuo-statis.tokisaki.top/)
开源仓库：[Tokisaki-Galaxy/statistics-zhulishenghuo](https://github.com/Tokisaki-Galaxy/statistics-zhulishenghuo)
{% endnote %}

![项目图片](https://raw.githubusercontent.com/Tokisaki-Galaxy/statistics-zhulishenghuo/refs/heads/master/image/0.jpg)

## 开发背景

校园生活中的水费、接水及洗衣支出呈现零碎且频繁的特点。住理生活 App 目前缺乏直观的财务统计功能。手动记录此类微小支出效率低下。本项目旨在利用浏览器端技术实现消费记录的自动化提取与分析。

## 核心特性

### 图像识别录入
系统集成 OCR 技术。用户上传消费记录长截图即可完成数据采集。无需手动输入金额与时间。

### 本地化隐私保护
所有图像识别逻辑均在浏览器本地运行。数据存储于客户端 IndexedDB。信息不上传至任何服务器。隐私安全性得到底层保障。

### 多维度数据可视化
系统提供月度账单汇总。消费时段热力图展示生活规律。GitHub 风格的贡献图直观反映消费频次。

## 技术架构

### 前端框架
选用轻量级的 Alpine.js。逻辑层级清晰。适合小型单页应用的快速开发。

### 文字识别
集成 Tesseract.js 引擎。在浏览器端实现高性能 OCR 识别。支持复杂长图的文本解析。

### 数据持久化与可视化
利用 IndexedDB 实现大容量本地存储。确保页面刷新后数据不丢失。采用 Chart.js 绘制动态统计图表。

## 操作流程

1.  **获取截图**：在住理生活 App 中截取消费记录长图。
2.  **上传解析**：将截图上传至记账助手界面。
3.  **查阅报表**：系统自动解析并生成统计图表。
4.  **数据导出**：支持导出 CSV 或 JSON 格式文件进行二次分析。

## 注意事项

*   建议使用 PC 端浏览器以获得更佳的体验。
