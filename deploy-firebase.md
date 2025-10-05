# Firebase Hosting 部署指南

## 🔥 使用 Firebase Hosting 部署

Google Firebase 提供可靠的静态网站托管服务。

### 准备工作
1. 访问 [Firebase Console](https://console.firebase.google.com)
2. 创建新项目或选择现有项目
3. 启用 Hosting 服务

### 安装 Firebase CLI
```bash
# 安装 Firebase CLI
npm install -g firebase-tools

# 登录 Firebase
firebase login
```

### 部署步骤
```bash
# 在项目目录中初始化
firebase init hosting

# 选择配置：
# - 选择你的 Firebase 项目
# - Public directory: . (当前目录)
# - Single-page app: No
# - 不覆盖 index.html

# 部署到 Firebase
firebase deploy
```

### 配置文件
Firebase 会创建 `firebase.json`：

```json
{
  "hosting": {
    "public": ".",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

### 自定义域名
1. 在 Firebase Console 中进入 Hosting
2. 点击 "Add custom domain"
3. 按提示配置 DNS 记录

### 优势特性
- ✅ Google 基础设施
- ✅ 免费 SSL 证书
- ✅ 全球 CDN
- ✅ 版本管理
- ✅ 回滚功能