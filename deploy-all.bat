@echo off
echo ================================
echo HabitFlow 应用部署助手
echo ================================
echo.
echo 请选择部署平台:
echo 1. GitHub Pages (免费，简单)
echo 2. Netlify (免费，功能强大)
echo 3. Vercel (免费，速度快)
echo 4. Firebase Hosting (Google服务)
echo 5. 查看所有部署指南
echo.
set /p choice=请输入选择 (1-5): 

if "%choice%"=="1" (
    echo.
    echo 📖 GitHub Pages 部署指南:
    echo ================================
    type deploy-github.md
) else if "%choice%"=="2" (
    echo.
    echo 📖 Netlify 部署指南:
    echo ================================
    type deploy-netlify.md
) else if "%choice%"=="3" (
    echo.
    echo 📖 Vercel 部署指南:
    echo ================================
    type deploy-vercel.md
) else if "%choice%"=="4" (
    echo.
    echo 📖 Firebase 部署指南:
    echo ================================
    type deploy-firebase.md
) else if "%choice%"=="5" (
    echo.
    echo 📖 所有部署选项:
    echo ================================
    echo.
    echo 🔗 GitHub Pages: 最简单的免费选项
    start deploy-github.md
    echo.
    echo 🔗 Netlify: 功能最全面
    start deploy-netlify.md
    echo.
    echo 🔗 Vercel: 速度最快
    start deploy-vercel.md
    echo.
    echo 🔗 Firebase: Google 基础设施
    start deploy-firebase.md
) else (
    echo 无效选择，显示 GitHub Pages 指南...
    type deploy-github.md
)

echo.
echo ================================
echo 💡 推荐顺序:
echo 1. 新手推荐: GitHub Pages
echo 2. 进阶推荐: Netlify
echo 3. 专业推荐: Vercel
echo ================================
echo.
pause