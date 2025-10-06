@echo off
chcp 65001 >nul
echo ================================
echo 🚀 Vercel 部署助手
echo ================================
echo.

REM 检查是否安装了 Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 错误: 未检测到 Node.js
    echo 请先安装 Node.js: https://nodejs.org
    pause
    exit /b 1
)

echo ✅ Node.js 已安装
echo.

REM 检查是否安装了 Vercel CLI
vercel --version >nul 2>&1
if errorlevel 1 (
    echo 📦 正在安装 Vercel CLI...
    npm install -g vercel
    if errorlevel 1 (
        echo ❌ Vercel CLI 安装失败
        pause
        exit /b 1
    )
    echo ✅ Vercel CLI 安装成功
) else (
    echo ✅ Vercel CLI 已安装
)

echo.
echo 请选择部署方式:
echo 1. 快速部署 (自动配置)
echo 2. 自定义配置部署
echo 3. 生产环境部署
echo 4. 查看部署状态
echo 5. 设置环境变量
echo 6. 绑定自定义域名
echo.
set /p choice=请输入选择 (1-6): 

if "%choice%"=="1" (
    echo.
    echo 🚀 开始快速部署...
    echo ================================
    
    REM 检查是否已登录
    vercel whoami >nul 2>&1
    if errorlevel 1 (
        echo 请先登录 Vercel...
        vercel login
    )
    
    echo 正在构建项目...
    if exist "package.json" (
        npm run build
        if errorlevel 1 (
            echo ❌ 构建失败，请检查构建脚本
            pause
            exit /b 1
        )
    )
    
    echo 正在部署到 Vercel...
    vercel
    
) else if "%choice%"=="2" (
    echo.
    echo ⚙️ 自定义配置部署
    echo ================================
    
    echo 请选择项目类型:
    echo 1. React (Create React App)
    echo 2. React (Vite)
    echo 3. Vue.js
    echo 4. Next.js
    echo 5. 静态网站
    echo.
    set /p project_type=请选择项目类型 (1-5): 
    
    echo.
    echo 正在创建 vercel.json 配置文件...
    
    if "%project_type%"=="1" (
        echo {> vercel.json
        echo   "version": 2,>> vercel.json
        echo   "buildCommand": "npm run build",>> vercel.json
        echo   "outputDirectory": "build",>> vercel.json
        echo   "rewrites": [>> vercel.json
        echo     {>> vercel.json
        echo       "source": "/(.*)",>> vercel.json
        echo       "destination": "/index.html">> vercel.json
        echo     }>> vercel.json
        echo   ]>> vercel.json
        echo }>> vercel.json
    ) else if "%project_type%"=="2" (
        echo {> vercel.json
        echo   "version": 2,>> vercel.json
        echo   "buildCommand": "npm run build",>> vercel.json
        echo   "outputDirectory": "dist",>> vercel.json
        echo   "rewrites": [>> vercel.json
        echo     {>> vercel.json
        echo       "source": "/(.*)",>> vercel.json
        echo       "destination": "/index.html">> vercel.json
        echo     }>> vercel.json
        echo   ]>> vercel.json
        echo }>> vercel.json
    ) else if "%project_type%"=="3" (
        echo {> vercel.json
        echo   "version": 2,>> vercel.json
        echo   "buildCommand": "npm run build",>> vercel.json
        echo   "outputDirectory": "dist",>> vercel.json
        echo   "rewrites": [>> vercel.json
        echo     {>> vercel.json
        echo       "source": "/(.*)",>> vercel.json
        echo       "destination": "/index.html">> vercel.json
        echo     }>> vercel.json
        echo   ]>> vercel.json
        echo }>> vercel.json
    ) else if "%project_type%"=="4" (
        echo {> vercel.json
        echo   "version": 2>> vercel.json
        echo }>> vercel.json
    ) else (
        echo {> vercel.json
        echo   "version": 2,>> vercel.json
        echo   "rewrites": [>> vercel.json
        echo     {>> vercel.json
        echo       "source": "/(.*)",>> vercel.json
        echo       "destination": "/index.html">> vercel.json
        echo     }>> vercel.json
        echo   ]>> vercel.json
        echo }>> vercel.json
    )
    
    echo ✅ 配置文件已创建
    echo.
    echo 正在部署...
    vercel
    
) else if "%choice%"=="3" (
    echo.
    echo 🎯 生产环境部署
    echo ================================
    
    echo 正在构建生产版本...
    if exist "package.json" (
        npm run build
    )
    
    echo 正在部署到生产环境...
    vercel --prod
    
) else if "%choice%"=="4" (
    echo.
    echo 📊 部署状态
    echo ================================
    vercel ls
    echo.
    echo 详细信息:
    vercel inspect
    
) else if "%choice%"=="5" (
    echo.
    echo 🔧 环境变量设置
    echo ================================
    echo.
    echo 常用环境变量示例:
    echo - REACT_APP_API_URL
    echo - VITE_API_URL  
    echo - NODE_ENV
    echo.
    set /p env_name=请输入环境变量名: 
    set /p env_value=请输入环境变量值: 
    
    echo 正在设置环境变量...
    vercel env add %env_name% production
    echo %env_value%
    
) else if "%choice%"=="6" (
    echo.
    echo 🌐 自定义域名绑定
    echo ================================
    echo.
    set /p domain=请输入你的域名 (例: example.com): 
    
    echo 正在绑定域名...
    vercel domains add %domain%
    
    echo.
    echo 📋 DNS 配置说明:
    echo ================================
    echo 请在你的域名提供商处添加以下记录:
    echo.
    echo 类型: CNAME
    echo 名称: @ (或留空)
    echo 值: cname.vercel-dns.com
    echo.
    echo 或者:
    echo 类型: A
    echo 名称: @ (或留空) 
    echo 值: 76.76.19.61
    
) else (
    echo ❌ 无效选择
)

echo.
echo ================================
echo 🎉 部署完成！
echo.
echo 💡 有用的命令:
echo - vercel --help     查看帮助
echo - vercel ls         查看项目列表
echo - vercel logs       查看部署日志
echo - vercel domains    管理域名
echo - vercel env        管理环境变量
echo.
echo 📚 更多信息: https://vercel.com/docs
echo ================================
echo.
pause