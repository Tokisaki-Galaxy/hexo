---
title: POPUCOM 三消棋：网页的多人联机小游戏
date: 2025-11-22 16:16:33
author: Tokisaki Galaxy
excerpt: 9×9 棋盘的三消策略棋，支持本地与多人联机。提供 Serverless 与 Python（Legacy）两套实现。
tags:
  - 三消
  - 棋类
  - Multiplayer
  - Serverless
  - Supabase
  - Vercel
  - Upstash
  - Python
  - Flask
categories:
  - 项目
---

[在线试玩（Vercel）](https://pop.tokisaki.top/)
[项目地址（GitHub）](https://github.com/Tokisaki-Galaxy/POPUCOM-Chess-Multiplayer)

{% note info %}
复刻自yj的小游戏，现在改为浏览器的轻量棋类游戏。规则简洁。决策空间充足。支持房间对战与本地练习。
{% endnote %}

## 玩法概要

- 棋盘：9×9。
- 落子：只能落在中立或己方领地。不可落在对方领地。
- 三消：横、竖、两条对角线。出现连续 3 子即消除这三子，格点清空。
- 领地：三消所在直线归属当前玩家。自该直线两端向外延伸，遇到对方棋子或下一格为对方棋子即停止。领地可被覆盖。
- 回合与胜负：双方共 50 步即结算。比较己方领地格数。多者胜，持平为和。

屏幕截图与录屏见仓库 README。

## 形态

- Serverless（推荐）：前端 + API 全托管在 Vercel。数据落在 Supabase。支持限流中间件。
- Python（Legacy）：Flask REST 服务 + Pygame 客户端。本地或自建服务器可用。

## 架构与核心文件

- 前端与规则引擎
  - 页面与样式：index.html、styles.css。
  - 交互与本地规则引擎：main.js。
  - 关键类：BaseGame。核心算法在 BaseGame.calculateNextState。处理三连消与领地扩张，并推进回合与胜负。
  - 模式：
    - LocalGame：本地单机。
    - OnlineGame：基于轮询同步房间状态。
- Serverless API（Vercel）
  - 入口：api/game.js，导出 handler。
  - 路由：
    - GET /api/game?roomId=... 查询房间状态。
    - POST /api/game 创建或确保房间存在。
    - PUT /api/game 写入局面（棋盘、领地、当前手、胜负、最后一步）。
- 数据与运维（Supabase / PostgreSQL）
  - 表结构初始化与 Realtime 发布：database-init.sql。
  - 定时清理 48 小时未活跃房间（pg_cron）：cron-cleandata.sql。
- 频控（Edge Middleware）
  - 文件：middleware.js。
  - 依赖：@upstash/redis、@upstash/ratelimit、@vercel/edge。

## 规则实现要点

- 三消检测：以每个落子点为起点，同时检测四个方向是否形成长度为 3 的连续同色。
- 消除与归零：命中三消的格点清零。可并发命中多线。
- 领地扩张：记录三消线段归属后，从线段两端向外扫描。遇到对手棋子或“下一格是对手棋子”即停止。被覆盖的领地以最新归属为准。
- 结算：总步数到 $50$ 即统计两侧领地格数。多者胜，持平为和局。

实现对应：
- JS：BaseGame.calculateNextState（落子 → 扫描 → 清子 → 领地扩张 → 回合推进 → 胜负判定）。
- Python：process_eliminations、remove_elimination_tiles、claim_line，统一由 GameEngine 驱动。

## Serverless 快速开始

1) 准备 Supabase  
- 新建项目。执行 database-init.sql 初始化表与策略。  
- 可选：执行 cron-cleandata.sql，启用 pg_cron 清理过期房间。

2) 配置 Vercel 环境变量  
- SUPABASE_URL：项目 REST URL。  
- SUPABASE_KEY：建议使用 Legacy API Key。  
- 可选限流：配置 Upstash Redis（URL、TOKEN）。

3) 部署  
- 将仓库导入 Vercel。完成后访问根路径即可游玩。

### 数据表（Supabase / PostgreSQL）

- 表 games（JSON 持久化局面 + 元数据）：
  - room_id（PK）
  - board（int[][]）
  - territory（int[][]）
  - current_player（int）
  - winner（int）
  - last_move_pos（int[2]）
  - updated_at（timestamptz）

示例（节选）：
```sql
create table if not exists public.games (
  room_id text primary key,
  board jsonb not null,
  territory jsonb not null,
  current_player int not null default 1,
  winner int not null default 0,
  last_move_pos jsonb,
  updated_at timestamptz not null default now()
);

create index if not exists idx_games_updated_at on public.games(updated_at desc);
```

## Python 版本（Legacy）

- 服务端（Flask）
  - GameEngine：维护棋面与回合、胜负。
  - process_eliminations / remove_elimination_tiles / claim_line：规则的三阶段实现。
  - MatchState：对局调度与并发安全。
  - server.py：加入、查询、落子、重置的 REST 路由。
- 客户端（Pygame）
  - LocalGame：本地对局。
  - RemoteGame：轮询 Flask 服务。
  - client.py：渲染与事件循环。

启动步骤：
```bash
# 进入 python 子目录（若有）
pip install -r python/requirements.txt
python python/server.py
python python/client.py  # 选择本地或在线模式
```

## 频控与稳定性

- middleware.js 基于 Upstash Redis 实现节流。  
- 按 IP 与路径维度限速。边缘执行，开销低。  
- 与 Supabase Realtime 可并用，减少轮询压力。

## 可扩展方向

- 实时联动：由轮询迁移至 Supabase Realtime 或 WebSocket / Edge Functions。
- 观战与复盘：为非玩家提供只读视角。持久化历史步谱并可回放。
- 防作弊：IP/设备指纹/节流策略结合服务器侧校验。
- 体验优化：房间分享卡片。一键截图（已在 main.js 集成 html2canvas）。移动端触控适配（styles.css 已适配基础尺寸）。

## 许可证与致谢

- 参见仓库 LICENSE。  
- 感谢 Vercel、Supabase、Upstash 提供的云端基础设施。  
- 感谢社区对规则与可用性的建议。

{% note success %}
服务已就绪即可直接游玩。欢迎提交 Issue 与 PR。
{% endnote %}
