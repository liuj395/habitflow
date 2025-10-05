# Vercel 部署指南

## ⚡ 使用 Vercel 快速部署

Vercel 是现代化的部署平台，特别适合前端应用。

### 快速部署步骤
1. 访问 [Vercel](https://vercel.com)
2. 使用 GitHub 账户登录
3. 点击 "New Project"
4. 导入你的 GitHub 仓库
5. 保持默认设置
6. 点击 "Deploy"

### 命令行部署
```bash
# 安装 Vercel CLI
npm i -g vercel

# 在项目目录中运行
vercel

# 按提示完成配置
# 自动获得 .vercel.app 域名
```

### 配置文件（可选）
创建 `vercel.json` 配置文件：

```json
{
  "version": 2,
  "name": "habitflow",
  "builds": [
    {
      "src": "**/*",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/$1"
    }
  ]
}
```

### 优势特性
- ✅ 极快的部署速度
- ✅ 自动 HTTPS
- ✅ 全球边缘网络
- ✅ Git 集成
- ✅ 预览部署
- ✅ 分析功能