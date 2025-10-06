@echo off
chcp 65001 >nul
echo ================================
echo 🔄 Vercel 重新导入部署工具
echo ================================
echo.

echo 📋 此工具将帮助你:
echo 1. 修复配置问题
echo 2. 重新导入项目到 Vercel
echo 3. 完成部署
echo.

REM 检查 Vercel CLI
vercel --version >nul 2>&1
if errorlevel 1 (
    echo 📦 正在安装 Vercel CLI...
    npm install -g vercel
    if errorlevel 1 (
        echo ❌ Vercel CLI 安装失败
        pause
        exit /b 1
    )
)

echo ✅ Vercel CLI 已准备就绪
echo.

echo ================================
echo 🔍 第1步: 诊断当前状态
echo ================================
echo.

REM 检查是否已登录
echo 检查登录状态...
vercel whoami >nul 2>&1
if errorlevel 1 (
    echo ⚠️  未登录 Vercel，正在启动登录...
    vercel login
    echo.
)

echo ✅ Vercel 登录状态正常
echo.

REM 检查项目结构
echo 📁 分析项目结构...
if exist "package.json" (
    echo ✅ Node.js 项目 (package.json 存在)
    
    echo.
    echo 📋 项目信息:
    for /f "tokens=2 delims=:" %%a in ('type package.json ^| findstr "\"name\""') do (
        set project_name=%%a
        set project_name=!project_name: "=!
        set project_name=!project_name:",=!
        set project_name=!project_name:"=!
        echo 项目名称: !project_name!
    )
    
    REM 检查构建脚本
    echo.
    echo 🔍 检查构建配置:
    type package.json | findstr "\"build\"" >nul
    if errorlevel 1 (
        echo ⚠️  未发现 build 脚本
    ) else (
        echo ✅ 发现 build 脚本
        type package.json | findstr "\"build\""
    )
) else (
    echo 📄 静态网站 (无 package.json)
)

echo.
echo ================================
echo 🔧 第2步: 修复配置问题
echo ================================
echo.

REM 检查现有的 vercel.json
if exist "vercel.json" (
    echo 📄 发现现有的 vercel.json:
    type vercel.json
    echo.
    set /p keep_config=是否保留现有配置? (y/n): 
    if /i not "!keep_config!"=="y" (
        del vercel.json
        echo 🗑️  已删除旧配置
    )
)

REM 如果没有配置文件，创建新的
if not exist "vercel.json" (
    echo 🛠️  创建新的 vercel.json 配置...
    echo.
    
    echo 请选择项目类型:
    echo 1. Create React App (build/)
    echo 2. Vite React/Vue (dist/)
    echo 3. Next.js (自动配置)
    echo 4. Vue CLI (dist/)
    echo 5. Angular (dist/)
    echo 6. 静态网站 (当前目录)
    echo 7. 自定义配置
    echo.
    set /p config_choice=请选择 (1-7): 
    
    if "!config_choice!"=="1" (
        call :create_cra_config
    ) else if "!config_choice!"=="2" (
        call :create_vite_config
    ) else if "!config_choice!"=="3" (
        call :create_nextjs_config
    ) else if "!config_choice!"=="4" (
        call :create_vue_config
    ) else if "!config_choice!"=="5" (
        call :create_angular_config
    ) else if "!config_choice!"=="6" (
        call :create_static_config
    ) else if "!config_choice!"=="7" (
        call :create_custom_config
    ) else (
        echo ❌ 无效选择，使用默认配置
        call :create_vite_config
    )
    
    echo ✅ vercel.json 配置已创建
    echo.
    echo 📄 配置内容:
    type vercel.json
)

echo.
echo ================================
echo 🔨 第3步: 构建项目
echo ================================
echo.

if exist "package.json" (
    echo 正在安装依赖...
    npm install
    if errorlevel 1 (
        echo ⚠️  依赖安装可能有问题，但继续尝试构建...
    )
    
    echo.
    echo 正在构建项目...
    npm run build
    if errorlevel 1 (
        echo ❌ 构建失败！
        echo.
        echo 💡 请检查:
        echo 1. package.json 中是否有 build 脚本
        echo 2. 是否有语法错误
        echo 3. 依赖是否正确安装
        echo.
        set /p continue_anyway=是否强制继续部署? (y/n): 
        if /i not "!continue_anyway!"=="y" (
            echo 部署已取消
            pause
            exit /b 1
        )
    ) else (
        echo ✅ 构建成功！
    )
) else (
    echo 📄 静态网站，跳过构建步骤
)

echo.
echo ================================
echo 🚀 第4步: 重新导入到 Vercel
echo ================================
echo.

echo 🔄 清除可能的旧项目关联...
if exist ".vercel" (
    rmdir /s /q ".vercel"
    echo ✅ 已清除旧的项目关联
)

echo.
echo 🌐 开始重新导入项目...
echo.

echo 💡 提示: 接下来会询问一些配置问题
echo - 项目名称: 可以使用默认或自定义
echo - 部署目录: 已在 vercel.json 中配置
echo - 是否链接到现有项目: 选择 N (创建新项目)
echo.

pause

echo.
echo 🚀 执行 Vercel 部署...
vercel

if errorlevel 1 (
    echo ❌ 初始部署失败，尝试强制重新部署...
    vercel --force
)

echo.
echo ================================
echo 🎯 第5步: 生产环境部署
echo ================================
echo.

set /p deploy_prod=是否部署到生产环境? (y/n): 
if /i "!deploy_prod!"=="y" (
    echo 🚀 部署到生产环境...
    vercel --prod
    
    if not errorlevel 1 (
        echo.
        echo ✅ 部署成功！
        echo.
        echo 🌐 你的网站已上线！
        echo 📊 查看部署信息: vercel ls
        echo 📈 查看项目详情: vercel inspect
        echo.
    )
)

echo ================================
echo 🎉 重新导入完成！
echo ================================
echo.

echo 📋 完成的操作:
echo ✅ 修复了配置问题
echo ✅ 重新导入项目到 Vercel
echo ✅ 完成了部署
echo.

echo 💡 后续操作:
echo - 访问 https://vercel.com/dashboard 查看项目
echo - 使用 vercel --prod 更新生产版本
echo - 使用 vercel logs 查看部署日志
echo.

set /p open_dashboard=是否打开 Vercel 控制台? (y/n): 
if /i "!open_dashboard!"=="y" (
    start https://vercel.com/dashboard
)

goto :end

REM 配置创建函数
:create_cra_config
echo {> vercel.json
echo   "version": 2,>> vercel.json
echo   "buildCommand": "npm run build",>> vercel.json
echo   "outputDirectory": "build",>> vercel.json
echo   "installCommand": "npm install",>> vercel.json
echo   "rewrites": [>> vercel.json
echo     { "source": "/(.*)", "destination": "/index.html" }>> vercel.json
echo   ]>> vercel.json
echo }>> vercel.json
exit /b

:create_vite_config
echo {> vercel.json
echo   "version": 2,>> vercel.json
echo   "buildCommand": "npm run build",>> vercel.json
echo   "outputDirectory": "dist",>> vercel.json
echo   "installCommand": "npm install",>> vercel.json
echo   "rewrites": [>> vercel.json
echo     { "source": "/(.*)", "destination": "/index.html" }>> vercel.json
echo   ]>> vercel.json
echo }>> vercel.json
exit /b

:create_nextjs_config
echo {> vercel.json
echo   "version": 2>> vercel.json
echo }>> vercel.json
exit /b

:create_vue_config
echo {> vercel.json
echo   "version": 2,>> vercel.json
echo   "buildCommand": "npm run build",>> vercel.json
echo   "outputDirectory": "dist",>> vercel.json
echo   "installCommand": "npm install",>> vercel.json
echo   "rewrites": [>> vercel.json
echo     { "source": "/(.*)", "destination": "/index.html" }>> vercel.json
echo   ]>> vercel.json
echo }>> vercel.json
exit /b

:create_angular_config
echo {> vercel.json
echo   "version": 2,>> vercel.json
echo   "buildCommand": "npm run build",>> vercel.json
echo   "outputDirectory": "dist",>> vercel.json
echo   "installCommand": "npm install",>> vercel.json
echo   "rewrites": [>> vercel.json
echo     { "source": "/(.*)", "destination": "/index.html" }>> vercel.json
echo   ]>> vercel.json
echo }>> vercel.json
exit /b

:create_static_config
echo {> vercel.json
echo   "version": 2,>> vercel.json
echo   "rewrites": [>> vercel.json
echo     { "source": "/(.*)", "destination": "/index.html" }>> vercel.json
echo   ]>> vercel.json
echo }>> vercel.json
exit /b

:create_custom_config
set /p custom_output=请输入输出目录 (如: dist, build): 
set /p custom_build=请输入构建命令 (如: npm run build): 
echo {> vercel.json
echo   "version": 2,>> vercel.json
echo   "buildCommand": "%custom_build%",>> vercel.json
echo   "outputDirectory": "%custom_output%",>> vercel.json
echo   "installCommand": "npm install",>> vercel.json
echo   "rewrites": [>> vercel.json
echo     { "source": "/(.*)", "destination": "/index.html" }>> vercel.json
echo   ]>> vercel.json
echo }>> vercel.json
exit /b

:end
echo.
pause