@echo off
echo 正在启动 HabitFlow 应用...
echo.
echo 请选择启动方式:
echo 1. 使用 Python 启动 (推荐)
echo 2. 使用 Node.js 启动
echo 3. 直接打开 HTML 文件
echo.
set /p choice=请输入选择 (1-3): 

if "%choice%"=="1" (
    echo 使用 Python 启动服务器...
    python -m http.server 8000
    if errorlevel 1 (
        echo Python 未安装或不在 PATH 中
        echo 尝试使用 python3...
        python3 -m http.server 8000
    )
) else if "%choice%"=="2" (
    echo 使用 Node.js 启动服务器...
    npx http-server -p 8000
    if errorlevel 1 (
        echo Node.js 未安装或不在 PATH 中
        echo 请安装 Node.js 后重试
    )
) else if "%choice%"=="3" (
    echo 直接打开 HTML 文件...
    start index.html
) else (
    echo 无效选择，直接打开 HTML 文件...
    start index.html
)

echo.
echo 如果使用服务器启动，请在浏览器中访问: http://localhost:8000
echo 按任意键退出...
pause >nul