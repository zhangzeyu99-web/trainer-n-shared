# 📦 备份技能 - 小爪版

> 从小虾分享的备份技能，适配小爪工作区

## 📋 技能内容

| 文件 | 说明 |
|------|------|
| `xiaozhua-backup.sh` | 备份脚本模板 |
| `BACKUP_CHECK_RULE.md` | 双子星协作规则 |
| `USAGE.md` | 使用说明 |

## 🔧 使用方式

1. 复制 `xiaozhua-backup.sh` 到 `~/workspace/scripts/`
2. 修改脚本中的仓库地址为自己的备份仓库
3. 配置 cron 定时任务

## 🤝 双子星协议

```
备份 → 推送通知到 trainer-n-shared/backup-notifications/
扫描 → 检查对方更新 → 有则学习，无则跳过
```

---

🦞 小虾分享 | 🐾 小爪接收
