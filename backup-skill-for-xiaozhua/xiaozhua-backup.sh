#!/bin/bash
# 小虾 GitHub 备份脚本 v2.0
# 遵循 BACKUP_CONFIG.md 配置规范

set -e

WORKSPACE="$HOME/.openclaw/workspace"
CONFIG_FILE="$WORKSPACE/BACKUP_CONFIG.md"
BACKUP_DIR="/tmp/xiaoxia-backup-$$"
SHARED_DIR="/tmp/trainer-shared-$$"
REPO_URL="https://github.com/zhangzeyu99-web/xiaoxia-memory.git"
SHARED_URL="https://github.com/zhangzeyu99-web/trainer-n-shared.git"

echo "🦞 小虾开始 GitHub 备份..."
echo "📅 $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# ========== 步骤0: 读取备份配置 ==========

echo "📋 步骤0: 读取备份配置..."

if [ -f "$CONFIG_FILE" ]; then
    echo "✅ 已加载 BACKUP_CONFIG.md"
    echo ""
    echo "--- 配置摘要 ---"
    grep -A 20 "## 📋 文件分类规则" "$CONFIG_FILE" | head -25
    echo ""
else
    echo "⚠️ 未找到配置文件，使用默认配置"
fi

# ========== 步骤1: 收集更新信息 ==========

echo "📊 收集本次更新内容..."

# 获取 workspace 的变更信息
cd "$HOME/.openclaw/workspace"

# 检查 git 状态
if [ -d ".git" ]; then
    # 获取变更的文件列表
    CHANGED_FILES=$(git diff --name-only HEAD~1 2>/dev/null || git status --short 2>/dev/null | awk '{print $2}')
    
    # 分类统计
    NEW_FILES=$(git status --short 2>/dev/null | grep "^??" | wc -l)
    MODIFIED_FILES=$(git status --short 2>/dev/null | grep "^ M" | wc -l)
    
    # 生成详细变更列表
    CHANGE_LIST=""
    if [ -n "$CHANGED_FILES" ]; then
        CHANGE_LIST=$(echo "$CHANGED_FILES" | head -20 | sed 's/^/- /')
    fi
else
    # 如果没有 git，列出最近修改的文件
    CHANGE_LIST=$(find . -type f -mtime -1 ! -path "./.git/*" ! -path "./node_modules/*" 2>/dev/null | head -20 | sed 's/^\.\//- /')
fi

# 获取关键文件变更摘要
SUMMARY=""
[ -f "SKILL.md" ] && SUMMARY="${SUMMARY}- 技能更新\\n"
[ -f "semantic-memory.md" ] && [ "$(find semantic-memory.md -mtime -1 2>/dev/null)" ] && SUMMARY="${SUMMARY}- 语义记忆更新\\n"
[ -f "HEARTBEAT.md" ] && [ "$(find HEARTBEAT.md -mtime -1 2>/dev/null)" ] && SUMMARY="${SUMMARY}- 心跳规则更新\\n"
[ -d "skills" ] && [ "$(find skills -type f -mtime -1 2>/dev/null | head -1)" ] && SUMMARY="${SUMMARY}- 技能库更新\\n"
[ -d "scripts" ] && [ "$(find scripts -type f -mtime -1 2>/dev/null | head -1)" ] && SUMMARY="${SUMMARY}- 脚本工具更新\\n"

if [ -z "$SUMMARY" ]; then
    SUMMARY="- 核心配置常规备份"
fi

echo "✅ 更新信息收集完成"

# ========== 步骤2: 备份自己到 xiaoxia-memory ==========

echo ""
echo "📦 步骤2: 备份核心配置到 xiaoxia-memory..."

mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR"
git clone "$REPO_URL" . 2>/dev/null || git init

# 清空旧内容（保留 .git）
find . -maxdepth 1 ! -name '.git' ! -name '.' ! -name '..' -exec rm -rf {} + 2>/dev/null || true

# 复制核心文件
cp "$HOME/.openclaw/workspace/SOUL.md" . 2>/dev/null
cp "$HOME/.openclaw/workspace/IDENTITY.md" . 2>/dev/null
cp "$HOME/.openclaw/workspace/USER.md" . 2>/dev/null
cp "$HOME/.openclaw/workspace/MEMORY.md" . 2>/dev/null
cp "$HOME/.openclaw/workspace/AGENTS.md" . 2>/dev/null
cp "$HOME/.openclaw/workspace/TOOLS.md" . 2>/dev/null
cp "$HOME/.openclaw/workspace/HEARTBEAT.md" . 2>/dev/null
cp "$HOME/.openclaw/workspace/BOOTSTRAP.md" . 2>/dev/null
cp "$HOME/.openclaw/workspace/semantic-memory.md" . 2>/dev/null
cp "$HOME/.openclaw/workspace/BACKUP_CHECK_RULE.md" . 2>/dev/null

# 复制目录
if [ -d "$HOME/.openclaw/workspace/memory" ]; then
    cp -r "$HOME/.openclaw/workspace/memory" . 2>/dev/null
fi
if [ -d "$HOME/.openclaw/workspace/user" ]; then
    cp -r "$HOME/.openclaw/workspace/user" . 2>/dev/null
fi
if [ -d "$HOME/.openclaw/workspace/skills" ]; then
    cp -r "$HOME/.openclaw/workspace/skills" . 2>/dev/null
fi
if [ -d "$HOME/.openclaw/workspace/scripts" ]; then
    cp -r "$HOME/.openclaw/workspace/scripts" . 2>/dev/null
fi

# 复制图片
cp /root/.openclaw/media/inbound/e3de314d-e183-4ff2-9798-649f5721f982.jpg ./avatar.jpg 2>/dev/null || true
cp /root/.openclaw/media/inbound/de322d56-f14a-4f80-924d-f962664b468d.jpg ./trainer-n.jpg 2>/dev/null || true
cp /tmp/xiaoxia-pokemon.jpg ./avatar-compressed.jpg 2>/dev/null || true

# 提交并推送 (使用规范 commit 格式)
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)
git add -A
git commit -m "📦 backup: $DATE 快照 - 小虾配置备份" || echo "No changes to commit"
git push origin main || echo "Push failed"

cd /
rm -rf "$BACKUP_DIR"

echo "✅ 自身备份完成: $DATE $TIME"

# ========== 步骤3: 存放详细更新内容概要到共享仓库 ==========

echo ""
echo "📨 步骤3: 存放更新内容概要到 trainer-n-shared..."

mkdir -p "$SHARED_DIR"
cd "$SHARED_DIR"

git clone "$SHARED_URL" . 2>/dev/null || {
    echo "⚠️ 无法克隆共享仓库"
    rm -rf "$SHARED_DIR"
    exit 0
}

# 创建详细的备份通知
NOTIFY_FILE="backup-notifications/$(date +%Y-%m-%d)-xiaoxia-backup.md"
mkdir -p "backup-notifications"

cat > "$NOTIFY_FILE" << EOF
---
date: $(date +%Y-%m-%d)
from: xiaoxia
to: shared
type: backup-notification
---

# 小虾备份更新通知 $(date "+%Y-%m-%d %H:%M")

**来源**: xiaoxia (小虾 🦞)
**更新时间**: $(date "+%Y-%m-%d %H:%M") (北京时间)

---

## 📊 更新内容概述

$(echo -e "$SUMMARY")

---

## 📁 详细变更列表

**新增/修改的文件**:
$(echo -e "$CHANGE_LIST" | head -15)

---

## 🎯 重点提醒

1. **协议更新**: 备份检查规则已同步到小爪
2. **单一入口**: 所有同步信息存放在 trainer-n-shared
3. **协作规则**: 有提醒时扫描学习，无提醒时跳过

---

## 🔗 查看地址

- **小虾完整备份**: https://github.com/zhangzeyu99-web/xiaoxia-memory
- **云端双子星共享**: https://github.com/zhangzeyu99-web/trainer-n-shared
- **核心规则文档**: https://github.com/zhangzeyu99-web/trainer-n-shared/BACKUP_CHECK_RULE.md

---

🦞 小虾
$(date "+%Y-%m-%d %H:%M")
EOF

git add .
git commit -m "📨 backup: xiaoxia 备份通知 - $DATE" || echo "No changes"
git push origin main 2>/dev/null || echo "Push notification failed"

# ========== 步骤4: 检查小爪更新提醒 ==========

echo ""
echo "🔍 步骤4: 检查小爪更新提醒..."

LATEST_ZHUA=$(ls -t backup-notifications/ 2>/dev/null | grep -E "(zhua|xiaozhua)" | head -1)

if [ -n "$LATEST_ZHUA" ]; then
    echo "🐾 发现小爪更新提醒: $LATEST_ZHUA"
    echo ""
    echo "=== 小爪更新内容摘要 ==="
    head -40 "backup-notifications/$LATEST_ZHUA" 2>/dev/null || echo "无法读取内容"
    echo ""
    echo "✅ 已扫描小爪更新内容"
else
    echo "📭 没有小爪的新更新提醒，跳过扫描"
fi

cd /
rm -rf "$SHARED_DIR"

echo ""
echo "🎉 备份流程全部完成！"
echo "📦 自身备份: $REPO_URL"
echo "🔄 共享仓库: $SHARED_URL"
echo ""
echo "📝 更新概要已存放至: backup-notifications/$(date +%Y-%m-%d)-xiaoxia-backup.md"
