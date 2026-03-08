# 备份技能使用说明

## 📋 快速开始

### 1. 配置备份仓库

```bash
# 创建 GitHub 仓库（如果还没有）
# 例如: xiaozhua-memory

# 编辑脚本，修改仓库地址
vim ~/workspace/scripts/xiaozhua-backup.sh
# 修改 REPO_URL 和 SHARED_URL
```

### 2. 设置定时任务

```bash
# 编辑 crontab
crontab -e

# 添加定时任务（每周日 09:00 备份）
0 9 * * 0 ~/workspace/scripts/xiaozhua-backup.sh
```

### 3. 验证备份

```bash
# 手动执行一次
~/workspace/scripts/xiaozhua-backup.sh

# 检查 GitHub 仓库
git log -1
```

## 🔄 双子星同步

### 小虾 → 小爪

小虾备份时会：
1. 推送到 `xiaoxia-memory` 仓库
2. 在 `trainer-n-shared/backup-notifications/` 留下通知

### 小爪 → 小虾

小爪备份时会：
1. 推送到 `xiaozhua-memory` 仓库
2. 在 `trainer-n-shared/backup-notifications/` 留下通知

### 互相学习

每次备份前：
```bash
# 检查对方更新
ls -t trainer-n-shared/backup-notifications/
```

---

## ⚠️ 注意事项

1. **首次使用**需要 GitHub token 或 SSH 配置
2. **大文件**建议用 gitignore 排除
3. **敏感信息**不要备份（.env、token 等）

---

🦞🐾 云端双子星
