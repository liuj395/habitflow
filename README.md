# 🚀 HabitFlow 用户注册系统

这是一个完整的用户注册和部署跟踪系统，专门为 HabitFlow 应用设计，可以管理用户注册信息并跟踪他们的部署平台偏好。

## 📁 文件说明

- **`index.html`** - 应用主页和导航
- **`user-registration.html`** - 用户注册界面  
- **`deployment-tracker.html`** - 部署跟踪仪表板
- **`README.md`** - 项目说明文档

## 🌐 GitHub 部署步骤

### 1. 创建 GitHub 仓库
1. 访问 [GitHub](https://github.com) 并登录
2. 点击右上角 "+" → "New repository"
3. 输入仓库名称（如：`habitflow-app`）
4. 选择 "Public"（GitHub Pages 需要公开仓库）
5. 点击 "Create repository"

### 2. 上传文件
1. 在新创建的仓库页面，点击 "uploading an existing file"
2. 将桌面上的所有文件拖拽到上传区域：
   - `index.html`
   - `user-registration.html` 
   - `deployment-tracker.html`
   - `README.md`
3. 在底部写入提交信息：`添加 HabitFlow 用户注册系统`
4. 点击 "Commit changes"

### 3. 启用 GitHub Pages
1. 在仓库页面，点击 "Settings" 选项卡
2. 在左侧菜单找到 "Pages"
3. 在 Source 部分：
   - 选择 "Deploy from a branch"
   - Branch: 选择 "main"
   - Folder: 选择 "/ (root)"
4. 点击 "Save"
5. 等待几分钟，您的网站就会上线

### 4. 访问您的应用
部署完成后，您可以通过以下地址访问：
- **主页**: `https://您的用户名.github.io/仓库名/`
- **用户注册**: `https://您的用户名.github.io/仓库名/user-registration.html`
- **数据统计**: `https://您的用户名.github.io/仓库名/deployment-tracker.html`

## 🔄 更新应用

当您需要更新应用时：

1. 在 GitHub 仓库页面，点击要修改的文件
2. 点击文件右上角的铅笔图标（Edit this file）
3. 进行修改
4. 在底部写入更新说明
5. 点击 "Commit changes"
6. GitHub Pages 会自动更新（可能需要几分钟）

## 🚀 功能特性

### 用户注册系统
- ✅ 美观的响应式注册界面
- ✅ 用户信息验证（用户名、邮箱唯一性）
- ✅ 部署平台选择（GitHub Pages、Netlify、Vercel、Firebase）
- ✅ 经验等级设置
- ✅ 本地数据存储
- ✅ 注册记录实时显示
- ✅ 数据导出功能

### 部署跟踪器
- ✅ 实时统计仪表板
- ✅ 用户注册趋势分析
- ✅ 部署平台偏好图表
- ✅ 用户筛选和搜索
- ✅ 数据可视化
- ✅ 自动数据刷新

## 📊 支持的部署平台

1. **GitHub Pages** - 免费，简单易用
2. **Netlify** - 免费，功能强大
3. **Vercel** - 免费，速度快
4. **Firebase Hosting** - Google服务

## 💾 数据存储

- 使用浏览器 `localStorage` 进行本地数据存储
- 支持数据导出为 JSON 格式
- 支持批量数据管理
- 自动数据备份机制

## 🔒 安全特性

- 客户端数据验证
- 用户名和邮箱唯一性检查
- 数据格式验证
- 错误处理和异常捕获

## 📱 响应式设计

- 完美支持桌面和移动设备
- 现代化的用户界面
- 流畅的动画效果
- 直观的用户体验

## 🛠️ 技术栈

- **前端**: HTML5, CSS3, JavaScript (ES6+)
- **样式**: CSS Grid, Flexbox, 渐变效果
- **存储**: LocalStorage API
- **图表**: 纯 CSS 实现的柱状图
- **响应式**: CSS Media Queries

## 📞 获得帮助

如果在部署过程中遇到问题：

1. 检查所有文件是否正确上传
2. 确认 GitHub Pages 设置正确
3. 等待 5-10 分钟让 GitHub 处理部署
4. 查看浏览器控制台是否有错误信息

## 🎉 完成！

现在您的 HabitFlow 用户注册系统已经成功部署到 GitHub Pages 上了！用户可以通过您的网站链接访问和使用这个系统。

---

**HabitFlow 用户注册系统** - 让用户管理变得简单高效！ 🚀