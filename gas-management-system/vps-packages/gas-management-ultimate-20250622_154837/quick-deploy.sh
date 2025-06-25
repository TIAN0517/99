#!/bin/bash
# Jy技術團隊 瓦斯行管理系統 - 一键部署

echo "🔥 ======================================="
echo "🔥  Jy技術團隊 瓦斯行管理系統 2025"
echo "🔥  Enhanced Beautiful Edition"
echo "🔥 ======================================="

# 设置权限
chmod +x *.sh

# 检查Node.js
if ! command -v node &> /dev/null; then
    echo "📦 安装Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# 安装依赖
echo "📦 安装依赖..."
npm install --production

# 停止现有服务
echo "⏹️ 停止现有服务..."
pkill -f "node.*gas" 2>/dev/null || true
pkill -f "node.*3000" 2>/dev/null || true
sleep 3

# 启动Enhanced Beautiful版本
echo "🚀 启动Enhanced Beautiful版本..."
if [ -f "gas-enhanced-beautiful-v2.js" ]; then
    nohup node gas-enhanced-beautiful-v2.js > gas-enhanced.log 2>&1 &
    PROCESS_PID=$!
    echo "✅ Enhanced Beautiful版本已启动！"
    echo "🆔 进程ID: $PROCESS_PID"
elif [ -f "start-gas-web.js" ]; then
    nohup node start-gas-web.js > gas-web.log 2>&1 &
    echo "✅ Web版本已启动！"
else
    echo "❌ 未找到启动文件"
    exit 1
fi

echo ""
echo "🔥 ======================================="
echo "🔥   系统已启动成功！"
echo "🔥 ======================================="
echo "📍 本地访问: http://localhost:3000"
echo "🌐 外网访问: http://YOUR_VPS_IP:3000"
echo "🔗 域名访问: http://lstjks.sytes.net:3000"
echo "📋 健康检查: http://YOUR_VPS_IP:3000/health"
echo "🔥 ======================================="
echo ""
echo "📝 查看日志: tail -f gas-enhanced.log"
echo "⏹️ 停止服务: pkill -f 'node.*gas'"
echo ""
echo "🎊 部署完成！"
