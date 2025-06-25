#!/bin/bash

# 4D科技感瓦斯管理系統啟動腳本
# Jy技術團隊 © 2025

echo "🚀 啟動4D科技感瓦斯管理系統..."
echo "=============================================="

# 檢查Node.js環境
echo "📋 檢查系統環境..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js 未安裝，請先安裝 Node.js"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ npm 未安裝，請先安裝 npm"
    exit 1
fi

echo "✅ Node.js $(node -v) 已安裝"
echo "✅ npm $(npm -v) 已安裝"

# 檢查並啟動Ollama AI服務
echo ""
echo "🤖 檢查AI服務狀態..."
if command -v ollama &> /dev/null; then
    echo "✅ Ollama 已安裝"
    
    # 檢查Ollama服務是否運行
    if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo "✅ Ollama 服務正在運行"
        
        # 檢查llama3:8b-instruct-q4_0模型
        if ollama list | grep -q "llama3:8b-instruct-q4_0"; then
            echo "✅ llama3:8b-instruct-q4_0 模型已安裝"
        else
            echo "⚠️ llama3:8b-instruct-q4_0 模型未安裝，正在下載..."
            ollama pull llama3:8b-instruct-q4_0
        fi
    else
        echo "🔄 啟動Ollama服務..."
        ollama serve &
        sleep 5
        
        echo "📥 下載AI模型..."
        ollama pull llama3:8b-instruct-q4_0
    fi
else
    echo "⚠️ Ollama 未安裝，AI功能將不可用"
    echo "   請訪問 https://ollama.ai 下載安裝"
fi

# 進入項目目錄
cd "$(dirname "$0")"

# 安裝依賴
echo ""
echo "📦 檢查項目依賴..."
if [ ! -d "node_modules" ]; then
    echo "📥 安裝項目依賴..."
    npm install
else
    echo "✅ 依賴已安裝"
fi

# 啟動開發服務器
echo ""
echo "🌐 啟動開發服務器..."
echo "=============================================="
echo "🏢 Jy技術團隊 4D科技感瓦斯管理系統"
echo "🔗 本地地址: http://localhost:3000"
echo "🤖 AI助理: Llama3 8B (如已安裝)"
echo "⚡ 4D科技感界面已激活"
echo "=============================================="

# 同時啟動Electron應用和Web服務
if [ -f "gas-4d-ultimate.js" ]; then
    echo "🚀 啟動4D Ultimate Web版本..."
    node gas-4d-ultimate.js &
    WEB_PID=$!
fi

echo "🖥️ 啟動Electron桌面版..."
npm start

# 清理進程
if [ ! -z "$WEB_PID" ]; then
    echo "🧹 清理進程..."
    kill $WEB_PID 2>/dev/null
fi

echo "👋 4D科技感瓦斯管理系統已關閉"
