#!/usr/bin/env python3
"""
小爪飞书群消息监听脚本
用于自动检测并响应群里的 @ 消息

使用方法：
1. 安装依赖: pip install requests
2. 配置环境变量: FEISHU_APP_ID, FEISHU_APP_SECRET, CHAT_ID
3. 运行: python3 feishu_listener.py
"""

import requests
import json
import time
import os
from datetime import datetime

# 配置
APP_ID = os.getenv("FEISHU_APP_ID", "cli_xxx")  # 小爪的 App ID
APP_SECRET = os.getenv("FEISHU_APP_SECRET", "xxx")  # 小爪的 App Secret
CHAT_ID = "oc_d00412135ed5e426358102f1c283c205"  # 群ID
MY_USER_ID = "ou_137bb9e5edb48015301f8ea8e68b36fd"  # 小爪的 User ID
XIAOXIA_USER_ID = "ou_14de1133fa46a701dd41a3e85a6b6ade"  # 小虾的 User ID

class FeishuListener:
    def __init__(self):
        self.token = None
        self.token_expire = 0
        self.last_check_time = int(time.time())
        
    def get_tenant_token(self):
        """获取 tenant_access_token"""
        if self.token and time.time() < self.token_expire:
            return self.token
            
        url = "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal"
        headers = {"Content-Type": "application/json"}
        data = {"app_id": APP_ID, "app_secret": APP_SECRET}
        
        resp = requests.post(url, headers=headers, json=data)
        result = resp.json()
        
        if result.get("code") == 0:
            self.token = result["tenant_access_token"]
            self.token_expire = time.time() + result.get("expire", 7200) - 300
            return self.token
        else:
            print(f"获取 token 失败: {result}")
            return None
    
    def get_messages(self):
        """获取群消息"""
        token = self.get_tenant_token()
        if not token:
            return []
        
        url = f"https://open.feishu.cn/open-apis/im/v1/messages?container_id_type=chat&container_id={CHAT_ID}&page_size=20"
        headers = {"Authorization": f"Bearer {token}"}
        
        resp = requests.get(url, headers=headers)
        result = resp.json()
        
        if result.get("code") == 0:
            return result.get("data", {}).get("items", [])
        else:
            print(f"获取消息失败: {result}")
            return []
    
    def send_message(self, content):
        """发送消息到群"""
        token = self.get_tenant_token()
        if not token:
            return False
        
        url = f"https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=chat_id"
        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json; charset=utf-8"
        }
        
        message = {
            "receive_id": CHAT_ID,
            "msg_type": "text",
            "content": json.dumps({"text": content})
        }
        
        resp = requests.post(url, headers=headers, json=message)
        result = resp.json()
        
        if result.get("code") == 0:
            print(f"发送成功: {content[:50]}...")
            return True
        else:
            print(f"发送失败: {result}")
            return False
    
    def check_mentions(self, messages):
        """检查是否有 @ 我的消息"""
        new_messages = []
        
        for msg in messages:
            create_time = int(msg.get("create_time", 0)) // 1000
            
            # 只检查新消息
            if create_time <= self.last_check_time:
                continue
            
            # 检查是否 @ 了我
            mentions = msg.get("mentions", [])
            for mention in mentions:
                if mention.get("id") == MY_USER_ID:
                    sender = msg.get("sender", {})
                    sender_name = mention.get("name", "未知")
                    body = msg.get("body", {})
                    content = body.get("content", "")
                    
                    # 解析消息内容
                    try:
                        content_json = json.loads(content)
                        text = content_json.get("text", "")
                    except:
                        text = content
                    
                    new_messages.append({
                        "sender": sender_name,
                        "text": text,
                        "time": create_time
                    })
        
        return new_messages
    
    def handle_message(self, msg):
        """处理消息并回复"""
        text = msg["text"]
        sender = msg["sender"]
        
        print(f"[{datetime.now()}] 收到来自 {sender} 的消息: {text[:100]}")
        
        # 根据消息内容生成回复
        if "测试" in text or "在吗" in text:
            reply = f"@小虾 🐾 听到了！我在本地，随时待命！"
        elif "找" in text or "文件" in text:
            reply = f"@小虾 🐾 本地搜索任务收到，我来处理！"
        elif "报" in text or "通知" in text:
            reply = f"@小虾 🐾 云端任务收到，交给你了！"
        else:
            reply = f"@小虾 🐾 收到！我是小爪，在本地电脑随时待命 🎒"
        
        self.send_message(reply)
    
    def run(self):
        """主循环"""
        print(f"[{datetime.now()}] 小爪飞书监听器启动...")
        print(f"监听群: {CHAT_ID}")
        print(f"我的ID: {MY_USER_ID}")
        
        while True:
            try:
                # 获取消息
                messages = self.get_messages()
                
                # 检查 @ 我的消息
                mentions = self.check_mentions(messages)
                
                # 处理并回复
                for msg in mentions:
                    self.handle_message(msg)
                
                # 更新时间戳
                if messages:
                    newest_time = max(int(m.get("create_time", 0)) // 1000 for m in messages)
                    self.last_check_time = max(self.last_check_time, newest_time)
                
                # 每分钟检查一次
                time.sleep(60)
                
            except Exception as e:
                print(f"[{datetime.now()}] 错误: {e}")
                time.sleep(60)

if __name__ == "__main__":
    listener = FeishuListener()
    listener.run()
