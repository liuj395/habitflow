@echo off
chcp 65001 >nul
echo ================================
echo ⚡ Vercel 输出目录快速修复工具
echo ================================
echo.

echo ❌ 错误: No Output Directory named "public" found
echo 🔧 正在立即修复此问题...
echo.

REM 第一步：检查当前构建输出
echo [1/4] 🔍 检查构建输出目录...
set output_found=
if exist "dist" (
    echo ✅ 发现 dist/ 目录
    set output_found=dist
)
if exist "build" (
    echo ✅ 发现 build/ 目录  
    set output_found=build
)
if exist "out" (
    echo ✅ 发现 out/ 目录
    set output_found=out
)

if "%output_found%"=="" (
    echo ⚠️  未发现构建输出，先执行构建...
    if exist "package.json" (
        npm run build
        REM 重新检查
        if exist "dist" set output_found=dist
        if exist "build" set output_found=build
        if exist "out" set output_found=out
    )
)

REM 第二步：创建正确的 vercel.json
echo.
echo [2/4] 📝 创建 vercel.json 配置文件...

if exist "vercel.json" (
    echo 备份现有配置...
    copy vercel.json vercel.json.backup >nul
)

REM 根据发现的目录创建配置
if "%output_found%"=="dist" (
    echo 配置为 Vite/Vue 项目 ^(dist 目录^)
    echo {> vercel.json
    echo   "version": 2,>> vercel.json
    echo   "buildCommand": "npm run build",>> vercel.json
    echo   "outputDirectory": "dist",>> vercel.json
    echo   "installCommand": "npm install",>> vercel.json
    echo   "rewrites": [>> vercel.json
    echo     {>> vercel.json
    echo       "source": "/(.*)",>> vercel.json
    echo       "destination": "/index.html">> vercel.json
    echo     }>> vercel.json
    echo   ]>> vercel.json
    echo }>> vercel.json
) else if "%output_found%"=="build" (
    echo 配置为 Create React App ^(build 目录^)
    echo {> vercel.json
    echo   "version": 2,>> vercel.json
    echo   "buildCommand": "npm run build",>> vercel.json
    echo   "outputDirectory": "build",>> vercel.json
    echo   "installCommand": "npm install",>> vercel.json
    echo   "rewrites": [>> vercel.json
    echo     {>> vercel.json
    echo       "source": "/(.*)",>> vercel.json
    echo       "destination": "/index.html">> vercel.json
    echo     }>> vercel.json
    echo   ]>> vercel.json
    echo }>> vercel.json
) else if "%output_found%"=="out" (
    echo 配置为 Next.js 静态导出 ^(out 目录^)
    echo {> vercel.json
    echo   "version": 2,>> vercel.json
    echo   "buildCommand": "npm run build && npm run export",>> vercel.json
    echo   "outputDirectory": "out",>> vercel.json
    echo   "installCommand": "npm install">> vercel.json
    echo }>> vercel.json
) else (
    echo ⚠️  未检测到标准输出目录，使用通用配置
    echo.
    echo 请手动选择输出目录:
    echo 1. dist ^(Vite/Vue^)
    echo 2. build ^(Create React App^)
    echo 3. out ^(Next.js^)
    echo 4. 自定义
    echo.
    set /p manual_choice=请选择 (1-4): 
    
    if "!manual_choice!"=="1" (
        set output_found=dist
    ) else if "!manual_choice!"=="2" (
        set output_found=build
    ) else if "!manual_choice!"=="3" (
        set output_found=out
    ) else if "!manual_choice!"=="4" (
        set /p output_found=请输入输出目录名: 
    ) else (
        set output_found=dist
    )
    
    echo {> vercel.json
    echo   "version": 2,>> vercel.json
    echo   "buildCommand": "npm run build",>> vercel.json
    echo   "outputDirectory": "%output_found%",>> vercel.json
    echo   "installCommand": "npm install",>> vercel.json
    echo   "rewrites": [>> vercel.json
    echo     {>> vercel.json
    echo       "source": "/(.*)",>> vercel.json
    echo       "destination": "/index.html">> vercel.json
    echo     }>> vercel.json
    echo   ]>> vercel.json
    echo }>> vercel.json
)

echo ✅ vercel.json 已创建！
echo.

REM 第三步：显示配置内容
echo [3/4] 📄 配置文件内容:
echo ================================
type vercel.json
echo ================================
echo.

REM 第四步：重新部署
echo [4/4] 🚀 重新部署到 Vercel...
echo.

echo 💡 现在执行以下命令之一:
echo.
echo 开发环境部署:  vercel
echo 生产环境部署:  vercel --prod
echo.

set /p deploy_choice=选择部署环境 (d=开发, p=生产, s=跳过): 

if /i "%deploy_choice%"=="d" (
    echo 正在部署到开发环境...
    vercel
) else if /i "%deploy_choice%"=="p" (
    echo 正在部署到生产环境...
    vercel --prod
) else (
    echo 跳过自动部署
    echo.
    echo 🔧 手动部署命令:
    echo vercel          ^(开发环境^)
    echo vercel --prod   ^(生产环境^)
)

echo.
echo ================================
echo ✅ 修复完成！
echo ================================
echo.

echo 📋 修复总结:
echo - ✅ 检测到输出目录: %output_found%
echo - ✅ 创建了正确的 vercel.json 配置
echo - ✅ 配置了正确的构建和输出设置
echo - ✅ 添加了 SPA 路由支持
echo.

echo 💡 如果仍有问题，请检查:
echo 1. 构建命令是否正确: npm run build
echo 2. 输出目录是否存在: %output_found%/
echo 3. index.html 是否在输出目录中
echo.

echo 🌐 部署成功后，你的网站将在以下地址可用:
echo https://your-project-name.vercel.app
echo.

echo 📚 更多帮助:
echo - Vercel 文档: https://vercel.com/docs
echo - 项目设置: https://vercel.com/dashboard
echo.

pause