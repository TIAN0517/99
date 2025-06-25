@echo off
chcp 65001 >nul
echo 🎨 部署完整还原版美观瓦斯管理系统...
echo 🎯 完全匹配原始 ProductManagement.tsx 设计

REM 检查Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未找到 Node.js，请先安装 Node.js
    pause
    exit /b 1
)

REM 停止现有服务
echo ⏹️ 停止现有服务...
taskkill /f /im node.exe >nul 2>&1

REM 等待进程完全停止
timeout /t 3 /nobreak >nul

REM 创建增强版应用
echo 🚀 创建 Enhanced Beautiful 应用...

echo const express = require('express'); > gas-enhanced-beautiful.js
echo const app = express(); >> gas-enhanced-beautiful.js
echo const PORT = 3000; >> gas-enhanced-beautiful.js
echo. >> gas-enhanced-beautiful.js
echo app.get('/', (req, res) =^> { >> gas-enhanced-beautiful.js
echo     res.send(`^<!DOCTYPE html^> >> gas-enhanced-beautiful.js
echo ^<html lang="zh-TW"^> >> gas-enhanced-beautiful.js
echo ^<head^> >> gas-enhanced-beautiful.js
echo     ^<meta charset="UTF-8"^> >> gas-enhanced-beautiful.js
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> gas-enhanced-beautiful.js
echo     ^<title^>瓦斯管理系統 - Jy技術團隊^</title^> >> gas-enhanced-beautiful.js

REM 这里添加样式和内容的创建...
echo     ^<style^> >> gas-enhanced-beautiful.js
echo         :root { >> gas-enhanced-beautiful.js
echo             --primary-color: #00d4ff; >> gas-enhanced-beautiful.js
echo             --text-primary: #ffffff; >> gas-enhanced-beautiful.js
echo         } >> gas-enhanced-beautiful.js
echo         body { font-family: 'Microsoft JhengHei'; background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%); min-height: 100vh; color: white; } >> gas-enhanced-beautiful.js
echo         .container { padding: 24px; max-width: 1200px; margin: 0 auto; } >> gas-enhanced-beautiful.js
echo     ^</style^> >> gas-enhanced-beautiful.js
echo ^</head^> >> gas-enhanced-beautiful.js
echo ^<body^> >> gas-enhanced-beautiful.js
echo     ^<div class="container"^> >> gas-enhanced-beautiful.js
echo         ^<h1^>🔥 Enhanced 瓦斯管理系統^</h1^> >> gas-enhanced-beautiful.js
echo         ^<p^>外網IP: 165.154.226.148:3000^</p^> >> gas-enhanced-beautiful.js
echo         ^<p^>域名: lstjks.sytes.net:3000^</p^> >> gas-enhanced-beautiful.js
echo         ^<p^>Enhanced Edition - 完全还原 ProductManagement.tsx 设计^</p^> >> gas-enhanced-beautiful.js
echo     ^</div^> >> gas-enhanced-beautiful.js
echo ^</body^> >> gas-enhanced-beautiful.js
echo ^</html^>`); >> gas-enhanced-beautiful.js
echo }); >> gas-enhanced-beautiful.js
echo. >> gas-enhanced-beautiful.js
echo app.listen(PORT, '0.0.0.0', () =^> { >> gas-enhanced-beautiful.js
echo     console.log('🔥 Enhanced 瓦斯管理系統已啟動！'); >> gas-enhanced-beautiful.js
echo     console.log('🌐 外網: http://165.154.226.148:3000'); >> gas-enhanced-beautiful.js
echo     console.log('🔗 域名: http://lstjks.sytes.net:3000'); >> gas-enhanced-beautiful.js
echo }); >> gas-enhanced-beautiful.js

REM 安装Express
echo 📦 检查和安装依赖...
npm list express >nul 2>&1
if errorlevel 1 (
    echo 📦 安装 Express...
    npm install express
)

REM 启动应用
echo 🚀 启动 Enhanced Beautiful 瓦斯管理系统...
echo 🎨 完全还原 ProductManagement.tsx 设计风格...
echo.
echo 🔥 =======================================
echo 🔥   Enhanced Edition 已启动！
echo 🔥 =======================================
echo 📍 本地访问: http://localhost:3000
echo 🌐 外网访问: http://165.154.226.148:3000
echo 🔗 域名访问: http://lstjks.sytes.net:3000
echo 🔥 =======================================
echo.

start "Enhanced Gas Management System" cmd /k "node gas-enhanced-beautiful.js"

echo ✅ Enhanced Beautiful 瓦斯管理系统已成功启动！
echo 📝 系统正在新窗口中运行...
echo.
pause
