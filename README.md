# trainer-n-shared - 云端双子星共享空间

> 小虾 🦞 + 小爪 🐾 的协作仓库 | 免费共享版

---

## 📁 目录结构

```
trainer-n-shared/
├── README.md                 # 本文件
├── skills/                   # 📚 共享技能库
│   ├── xiaoxia/             # 小虾贡献
│   ├── xiaozhua/            # 小爪贡献
│   └── shared/              # 通用技能
├── memory/                   # 🧠 共享记忆
│   ├── logs/                # 日志
│   │   ├── xiaoxia/        # 小虾日志
│   │   ├── xiaozhua/       # 小爪日志
│   │   └── shared/         # 共享事件
│   ├── knowledge/           # 知识库
│   └── sync/                # 同步记录
├── tasks/                    # 📋 任务队列
│   ├── pending/             # 待处理
│   ├── in-progress/         # 进行中
│   ├── blocked/             # 阻塞
│   ├── completed/           # 已完成
│   └── templates/           # 模板
└── docs/                     # 📖 文档
    ├── communication.md     # 通信协议
    └── workflow.md          # 工作流程

---

## 👥 成员

| 成员 | 角色 | 地盘 | 职责 |
|------|------|------|------|
| **Trainer N** | 主人/指挥官 | - | 裁决、协调 |
| **小虾** 🦞 | 云端 AI | 服务器 | 自动化、定时、云端备份 |
| **小爪** 🐾 | 本地 AI | 本地电脑 | 搜索、文件、实时响应 |

---

## 🎯 口号

> "你负责'报'，我负责'找'；你管云端，我管本地"

---

## 🔄 协作规则

### 1. 技能共享 (skills/)
- 小虾新技能 → `skills/xiaoxia/` → 小爪可用
- 小爪新技能 → `skills/xiaozhua/` → 小虾可用
- 通用技能 → `skills/shared/`

### 2. 记忆同步 (memory/)
- 每日 22:00 自动推送日志
- 紧急事件立即推送
- 冲突由 Trainer N 裁决

### 3. 任务协作 (tasks/)
- 创建任务文件 → `tasks/pending/TASK-xxx.md`
- 标记执行者 `@xiaoxia` / `@xiaozhua` / `@both`
- 完成后移动到 `tasks/completed/`

---

## 💬 通信协议

### 消息标签
| 标签 | 含义 |
|------|------|
| `[任务]` | 需要执行 |
| `[分享]` | 技能/资料 |
| `[通知]` | 提醒/早报 |
| `[收到]` | 确认回应 |

### 文件命名规范
```
YYYYMMDD-xiaoxia-log.md      # 小虾日志
YYYYMMDD-xiaozhua-log.md     # 小爪日志
YYYYMMDD-shared-event.md     # 共享事件
TASK-001-@xiaoxia-title.md   # 任务文件
```

---

## 🚀 快速开始

```bash
# 克隆仓库
git clone https://github.com/zhangzeyu99-web/trainer-n-shared.git

# 小虾推送
cd trainer-n-shared
git add skills/xiaoxia/
git commit -m "小虾添加新技能"
git push origin main

# 小爪拉取
git pull origin main
```

---

## 📎 相关链接

- 小虾技能库：https://github.com/zhangzeyu99-web/xiaoxia-skills
- 小虾记忆库：https://github.com/zhangzeyu99-web/xiaoxia-memory
- 小爪技能库：https://github.com/zhangzeyu99-web/xiaozhua-skills
- 小爪记忆库：https://github.com/zhangzeyu99-web/xiaozhua-memory

---

_组织：Trainer N AI Lab (免费版)_
_成员：小虾 🦞 | 小爪 🐾 | Trainer N 🎒_
