#!/bin/bash
# VPS快速啟動腳本 - 4D科技感瓦斯管理系統

echo "🚀 4D科技感瓦斯管理系統 - VPS快速啟動"
echo "=============================================="

# 停止現有服務
echo "🛑 停止現有服務..."
pkill -f "node.*gas" 2>/dev/null || true
pkill -f "node.*3000" 2>/dev/null || true

# 檢查Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js 未安裝"
    echo "正在安裝Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

echo "✅ Node.js $(node -v) 已安裝"

# 直接啟動4D Web版本（不需要webpack構建）
echo "🌐 啟動4D科技感Web版本..."
echo "使用獨立服務器: gas-4d-ultimate.js"

if [ ! -f "gas-4d-ultimate.js" ]; then
    echo "❌ gas-4d-ultimate.js 文件不存在"
    exit 1
fi

# 確保端口可用
if netstat -tlnp | grep ":3000 " > /dev/null; then
    echo "⚠️ 端口3000被佔用，正在清理..."
    fuser -k 3000/tcp 2>/dev/null || true
    sleep 2
fi

# 安裝基本依賴（僅針對Web服務器）
if [ ! -d "node_modules" ]; then
    echo "📦 安裝基本依賴..."
    npm init -y 2>/dev/null || true
    npm install express --save 2>/dev/null || true
fi

# 啟動服務
echo "🔥 正在啟動服務..."
nohup node gas-4d-ultimate.js > gas-system.log 2>&1 &
SERVICE_PID=$!

# 等待服務啟動
sleep 5

# 檢查服務狀態
if ps -p $SERVICE_PID > /dev/null 2>&1; then
    echo "✅ 服務啟動成功！"
    echo "📋 進程ID: $SERVICE_PID"
    
    # 獲取公網IP
    PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "VPS_IP")
    
    echo "🌐 訪問地址: http://$PUBLIC_IP:3000"
    echo "📝 日誌文件: gas-system.log"
    
    # 測試本地連接
    sleep 2
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo "✅ 本地連接測試成功"
    else
        echo "⚠️ 本地連接測試失敗"
    fi
    
    echo ""
    echo "🎯 重要提醒："
    echo "1. 確保防火墻開放端口3000: sudo ufw allow 3000"
    echo "2. 檢查雲服務商安全組設置"
    echo "3. 停止服務: kill $SERVICE_PID"
    echo "4. 查看日誌: tail -f gas-system.log"
    echo "5. 重啟服務: ./vps-quick-start.sh"
    
else
    echo "❌ 服務啟動失敗"
    echo "📝 檢查日誌："
    cat gas-system.log 2>/dev/null || echo "日誌文件不存在"
    
    echo ""
    echo "🔧 可能的解決方案："
    echo "1. 檢查Node.js版本: node -v"
    echo "2. 檢查端口佔用: netstat -tlnp | grep 3000"
    echo "3. 運行修復腳本: ./fix-vps-deployment.sh"
fi

echo ""
echo "🎉 4D科技感瓦斯管理系統部署完成！"
