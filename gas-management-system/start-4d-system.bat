@echo off
chcp 65001 >nul
title 4D科技感瓦斯管理系統 - Jy技術團隊

echo.
echo 🚀 啟動4D科技感瓦斯管理系統...
echo ==============================================

REM 檢查Node.js環境
echo 📋 檢查系統環境...
node -v >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js 未安裝，請先安裝 Node.js
    pause
    exit /b 1
)

npm -v >nul 2>&1
if errorlevel 1 (
    echo ❌ npm 未安裝，請先安裝 npm
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('node -v') do set NODE_VERSION=%%i
for /f "tokens=*" %%i in ('npm -v') do set NPM_VERSION=%%i

echo ✅ Node.js %NODE_VERSION% 已安裝
echo ✅ npm %NPM_VERSION% 已安裝

REM 檢查並啟動Ollama AI服務
echo.
echo 🤖 檢查AI服務狀態...
ollama --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Ollama 未安裝，AI功能將不可用
    echo    請訪問 https://ollama.ai 下載安裝
    goto :skip_ai
)

echo ✅ Ollama 已安裝

REM 檢查Ollama服務是否運行
curl -s http://localhost:11434/api/tags >nul 2>&1
if errorlevel 1 (
    echo 🔄 啟動Ollama服務...
    start /b ollama serve
    timeout /t 5 /nobreak >nul
)

echo ✅ Ollama 服務正在運行

REM 檢查模型
ollama list | findstr "llama3:8b-instruct-q4_0" >nul 2>&1
if errorlevel 1 (
    echo ⚠️ llama3:8b-instruct-q4_0 模型未安裝，正在下載...
    ollama pull llama3:8b-instruct-q4_0
) else (
    echo ✅ llama3:8b-instruct-q4_0 模型已安裝
)

:skip_ai

REM 進入項目目錄
cd /d "%~dp0"

REM 檢查依賴
echo.
echo 📦 檢查項目依賴...
if not exist "node_modules" (
    echo 📥 安裝項目依賴...
    npm install
) else (
    echo ✅ 依賴已安裝
)

REM 啟動服務
echo.
echo 🌐 啟動開發服務器...
echo ==============================================
echo 🏢 Jy技術團隊 4D科技感瓦斯管理系統
echo 🔗 本地地址: http://localhost:3000
echo 🤖 AI助理: Llama3 8B (如已安裝)
echo ⚡ 4D科技感界面已激活
echo ==============================================

REM 同時啟動Web版本（如果存在）
if exist "gas-4d-ultimate.js" (
    echo 🚀 啟動4D Ultimate Web版本...
    start /b node gas-4d-ultimate.js
)

REM 啟動Electron桌面版
echo 🖥️ 啟動Electron桌面版...
npm start

echo.
echo 👋 4D科技感瓦斯管理系統已關閉
pause
