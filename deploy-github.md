# GitHub Pages 部署指南

## 🚀 快速部署到 GitHub Pages

### 步骤1: 创建 GitHub 仓库
1. 登录 [GitHub](https://github.com)
2. 点击右上角 "+" → "New repository"
3. 仓库名称: `habitflow` (或其他名称)
4. 设置为 Public
5. 点击 "Create repository"

### 步骤2: 上传文件
```bash
# 方法1: 使用 Git 命令行
git init
git add .
git commit -m "Initial commit: HabitFlow app"
git branch -M main
git remote add origin https://github.com/你的用户名/habitflow.git
git push -u origin main
```

或者直接在GitHub网页上传文件：
1. 点击 "uploading an existing file"
2. 拖拽所有文件到页面
3. 填写提交信息
4. 点击 "Commit changes"

### 步骤3: 启用 GitHub Pages
1. 进入仓库设置 (Settings)
2. 滚动到 "Pages" 部分
3. Source 选择 "Deploy from a branch"
4. Branch 选择 "main"
5. 文件夹选择 "/ (root)"
6. 点击 "Save"

### 步骤4: 访问应用
- 等待几分钟部署完成
- 访问: `https://你的用户名.github.io/habitflow`
- 应用即可在线使用！

## 🔧 自定义域名（可选）
如果有自己的域名：
1. 在仓库根目录创建 `CNAME` 文件
2. 文件内容写入你的域名: `habitflow.yourdomain.com`
3. 在域名DNS设置中添加CNAME记录指向GitHub Pages

## 📱 PWA 安装
部署后用户可以：
- 在手机浏览器中访问
- 点击"添加到主屏幕"
- 像原生APP一样使用