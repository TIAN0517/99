#!/bin/bash
# 4D科技感瓦斯管理系統 VPS 部署修復腳本

echo "🔧 4D科技感瓦斯管理系統 - VPS部署修復"
echo "=============================================="

# 檢查當前目錄
CURRENT_DIR=$(pwd)
echo "📂 當前目錄: $CURRENT_DIR"

# 檢查必要文件
echo "📋 檢查項目文件..."

if [ ! -f "package.json" ]; then
    echo "❌ package.json 文件不存在"
    exit 1
fi

if [ ! -f "gas-4d-ultimate.js" ]; then
    echo "❌ gas-4d-ultimate.js 文件不存在"
    exit 1
fi

if [ ! -d "src" ]; then
    echo "❌ src 目錄不存在"
    exit 1
fi

echo "✅ 基本文件檢查完成"

# 檢查webpack配置
echo ""
echo "🔧 修復webpack配置..."

if [ ! -f "webpack.config.js" ]; then
    echo "⚠️ webpack.config.js 不存在，創建新配置..."
    cat > webpack.config.js << 'EOF'
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    entry: './src/renderer/index.tsx',
    target: 'electron-renderer',
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                use: 'ts-loader',
                exclude: /node_modules/,
            },
            {
                test: /\.css$/,
                use: ['style-loader', 'css-loader'],
            },
            {
                test: /\.(png|jpg|gif|svg)$/,
                use: ['file-loader'],
            },
        ],
    },
    resolve: {
        extensions: ['.tsx', '.ts', '.js'],
    },
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'dist'),
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: './src/renderer/index.html',
        }),
    ],
    mode: 'development',
    devtool: 'source-map',
};
EOF
    echo "✅ webpack.config.js 已創建"
else
    echo "✅ webpack.config.js 已存在"
fi

# 檢查TypeScript配置
if [ ! -f "tsconfig.json" ]; then
    echo "⚠️ tsconfig.json 不存在，創建新配置..."
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["DOM", "DOM.Iterable", "ES6"],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true,
    "module": "ESNext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": [
    "src"
  ]
}
EOF
    echo "✅ tsconfig.json 已創建"
else
    echo "✅ tsconfig.json 已存在"
fi

# 檢查入口文件
echo ""
echo "📋 檢查入口文件..."

if [ ! -f "src/renderer/index.tsx" ]; then
    echo "❌ 入口文件 src/renderer/index.tsx 不存在"
    echo "🔧 創建基本入口文件..."
    
    # 確保目錄存在
    mkdir -p src/renderer
    
    cat > src/renderer/index.tsx << 'EOF'
import React from 'react';
import { createRoot } from 'react-dom/client';
import { App } from './App';

const container = document.getElementById('root');
if (container) {
    const root = createRoot(container);
    root.render(<App />);
}
EOF
    echo "✅ 入口文件已創建"
else
    echo "✅ 入口文件已存在"
fi

# 檢查HTML模板
if [ ! -f "src/renderer/index.html" ]; then
    echo "❌ HTML模板 src/renderer/index.html 不存在"
    echo "🔧 創建HTML模板..."
    
    cat > src/renderer/index.html << 'EOF'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>4D科技感瓦斯管理系統</title>
</head>
<body>
    <div id="root"></div>
</body>
</html>
EOF
    echo "✅ HTML模板已創建"
else
    echo "✅ HTML模板已存在"
fi

# 安裝必要依賴
echo ""
echo "📦 安裝項目依賴..."

# 檢查Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js 未安裝"
    echo "請先安裝 Node.js: curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs"
    exit 1
fi

# 檢查npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm 未安裝"
    exit 1
fi

echo "✅ Node.js 和 npm 已安裝"

# 安裝依賴
echo "📥 安裝項目依賴..."
npm install

if [ $? -ne 0 ]; then
    echo "⚠️ npm install 失敗，嘗試清理後重新安裝..."
    rm -rf node_modules package-lock.json
    npm install
fi

# 直接啟動4D Web版本
echo ""
echo "🚀 啟動4D科技感Web版本..."
echo "=============================================="
echo "🌟 使用 gas-4d-ultimate.js 直接啟動"
echo "🔗 訪問地址: http://您的VPS_IP:3000"
echo "=============================================="

# 檢查端口是否被佔用
if netstat -tlnp | grep ":3000 " > /dev/null; then
    echo "⚠️ 端口3000已被佔用，正在停止現有服務..."
    pkill -f "node.*gas" 2>/dev/null || true
    pkill -f "node.*3000" 2>/dev/null || true
    sleep 2
fi

# 啟動服務
echo "🔥 正在啟動4D科技感瓦斯管理系統..."
nohup node gas-4d-ultimate.js > gas-system.log 2>&1 &
SERVICE_PID=$!

# 等待服務啟動
sleep 3

# 檢查服務狀態
if ps -p $SERVICE_PID > /dev/null; then
    echo "✅ 服務啟動成功！"
    echo "📋 進程ID: $SERVICE_PID"
    echo "🌐 訪問地址: http://$(curl -s ifconfig.me):3000"
    echo "📝 日誌文件: gas-system.log"
    
    # 顯示服務狀態
    echo ""
    echo "🔍 服務狀態檢查..."
    sleep 2
    
    if curl -s http://localhost:3000 > /dev/null; then
        echo "✅ 本地連接測試成功"
    else
        echo "⚠️ 本地連接測試失敗，請檢查日誌"
    fi
    
    # 顯示防火墻提醒
    echo ""
    echo "🔥 重要提醒："
    echo "1. 確保VPS防火墻開放端口3000"
    echo "2. 檢查雲服務商安全組設置"
    echo "3. 如需停止服務：kill $SERVICE_PID"
    echo "4. 查看日誌：tail -f gas-system.log"
    
else
    echo "❌ 服務啟動失敗"
    echo "📝 請檢查日誌文件: gas-system.log"
    cat gas-system.log
fi

echo ""
echo "🎉 4D科技感瓦斯管理系統部署完成！"
