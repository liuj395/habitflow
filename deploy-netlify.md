# Netlify 部署指南

## 🌐 使用 Netlify 免费部署

Netlify 提供更强大的功能和更快的部署速度。

### 方法1: 拖拽部署（最简单）
1. 访问 [Netlify](https://netlify.com)
2. 注册/登录账户
3. 将整个项目文件夹打包成 ZIP
4. 拖拽 ZIP 文件到 Netlify 部署区域
5. 自动获得随机域名，如: `https://amazing-app-123456.netlify.app`

### 方法2: Git 连接部署（推荐）
1. 先将代码推送到 GitHub/GitLab
2. 在 Netlify 中点击 "New site from Git"
3. 连接你的 Git 仓库
4. 选择分支（通常是 main）
5. 构建设置保持默认（静态网站无需构建）
6. 点击 "Deploy site"

### 优势特性
- ✅ 自动 HTTPS
- ✅ 全球 CDN 加速
- ✅ 自动部署（代码更新时）
- ✅ 自定义域名支持
- ✅ 表单处理功能
- ✅ 无限带宽

### 自定义域名
1. 在 Netlify 控制台点击 "Domain settings"
2. 点击 "Add custom domain"
3. 输入你的域名
4. 按提示配置 DNS 记录

### 环境变量（如需要）
如果应用需要配置：
1. 进入 "Site settings" → "Environment variables"
2. 添加所需的环境变量