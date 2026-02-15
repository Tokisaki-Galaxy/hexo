---
title: DLL Proxy 项目详解：高兼容性 version.dll 劫持与隐匿型 Payload 启动器
date: 2026-02-15 15:25:16
author: Tokisaki Galaxy
excerpt: 高度兼容的dll劫持与隐匿型Payload启动器。
tags:
  - DLL Proxy
  - Windows
  - 安全研究
---

{% note error %}
该项目可能涉及安全研究和渗透测试等敏感领域，请确保在合法授权的环境中使用。未经授权的使用可能违反法律法规。
{% endnote %}

## 项目简介

[项目链接](https://github.com/Tokisaki-Galaxy/dll-proxy)

本项目使用C语言开发高度兼容的 version.dll 劫持用动态链接库（DLL Proxy）。核心目标如下：

- **无缝转发**：所有标准 version.dll API 调用均透明转发到系统原版 DLL。
- **隐匿触发**：DLL 加载时异步启动线程，解密并执行隐藏 Payload（如启动系统计算器）。

适用平台为 Windows 7/8/10/11 x64，兼顾兼容性、隐匿性与体积控制。适合安全研究、渗透测试等场景。

## 目录结构

```text
.
├── .gitignore
├── build.bat
├── LICENSE
├── README.md
├── .github/
│   └── workflows/
│       ├── build.yml
│       └── copilot-setup-steps.yml
└── src/
    ├── proxy.c
    ├── version.rc
    └── vm_engine.h
```

- `proxy.c`：主代理逻辑，实现 API 转发与 Payload 启动
- `vm_engine.h`：虚拟机引擎，用于动态生成/还原加密命令字符串
- `version.rc`：资源脚本，伪装 DLL 版本信息
- `build.bat`：本地构建脚本
- `build.yml`：GitHub Actions 自动化构建与打包
- `README.md`：详细设计文档

## 核心功能与实现细节

### 1. 绝对路径 API 转发

通过 `#pragma comment(linker, "/export:...")`，将 17 个标准 version.dll 导出函数全部转发到系统目录下原版 DLL。  
采用绝对路径，避免再次被劫持，提升兼容性和稳定性。

### 2. 字符串难读化与动态还原

避免明文存储 "calc.exe" 字符串，避免对抗时通过 strings 或类似工具直接发现。通过自定义虚拟机（见 `vm_engine.h`）动态生成命令。  
字节码运行时还原目标命令，避免静态分析直接发现敏感字符串。

### 3. 异步 Payload 启动

在 DllMain 的 DLL_PROCESS_ATTACH 阶段，立即用 CreateThread 启动新线程，避免 Loader Lock 和主线程阻塞。  
新线程中调用 CreateProcessW 启动计算器，命令行参数由虚拟机还原。  
命令使用后，调用 SecureWipe 和 SecureZeroMemory 立即清除内存，防止敏感数据残留。

### 4. 资源伪装与体积控制

`version.rc` 仿造微软官方 version.dll 的资源描述，提升伪装性。  
构建参数优化，关闭调试符号，启用链接器优化，确保 DLL 体积小于 50KB。

## 构建与自动化

### 本地构建

直接运行 `build.bat`：

```bat
rc.exe /v src/version.rc
cl.exe /c /O1 /GL /GS- /MT src/proxy.c /Fo:proxy.obj
link.exe /DLL /OUT:version.dll /ENTRY:DllMain /NODEFAULTLIB /SUBSYSTEM:WINDOWS ^
/LTCG /OPT:REF /OPT:ICF ^
proxy.obj src/version.res kernel32.lib user32.lib
```

### CI/CD 自动化

`build.yml` 支持主分支和 Tag 自动构建、打包、发布 Release。  
自动 strip 符号、打包 zip 并上传 Release。

## 关键代码片段

**API 转发声明：**

```c
#pragma comment(linker, "/export:GetFileVersionInfoA=C:\\Windows\\System32\\version.GetFileVersionInfoA,@1")
// ...其余16个API同理...
```

**虚拟机动态还原命令：**

```c
static void ExecuteVM(WCHAR* output) {
    // ...虚拟机解释字节码，动态生成 "calc.exe" ...
}
```

**异步 Payload 启动与内存擦除：**

```c
DWORD WINAPI ExecutePayload(LPVOID lpParam) {
    WCHAR command[64];
    ExecuteVM(command);
    // ...CreateProcessW 启动 calc.exe...
    SecureWipe(command, sizeof(command));
    return 0;
}
```

## 总结

本项目通过 DLL Proxy 技术，实现了对系统 version.dll 的无缝转发，并集成隐匿型 Payload 启动机制。设计兼顾兼容性、隐匿性与安全性，适合安全研究、红队测试等场景。详细设计与实现细节请参考 README.md 及源码注释。
