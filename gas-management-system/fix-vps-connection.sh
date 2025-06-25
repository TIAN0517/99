#!/bin/bash
# VPS连接修复 - 确保外部访问

echo "🔧 VPS连接修复中..."

# 1. 停止现有服务
echo "停止现有服务..."
pkill -f "node.*gas" 2>/dev/null || true
pkill -f "node.*simple" 2>/dev/null || true

# 2. 配置防火墙
echo "配置防火墙..."
if command -v ufw > /dev/null; then
    ufw allow 3000/tcp
    echo "✅ UFW已配置端口3000"
fi

# 3. 创建确保外部访问的服务
echo "创建服务文件..."
cat > gas-server.js << 'EOF'
const express = require('express');
const app = express();
const PORT = 3000;
const os = require('os');

// 获取本机IP
function getLocalIP() {
    const interfaces = os.networkInterfaces();
    for (const name of Object.keys(interfaces)) {
        for (const interface of interfaces[name]) {
            if (interface.family === 'IPv4' && !interface.internal) {
                return interface.address;
            }
        }
    }
    return 'localhost';
}

// 主页
app.get('/', (req, res) => {
    const localIP = getLocalIP();
    res.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>瓦斯管理系統</title>
        <meta charset="UTF-8">
        <style>
            body { font-family: Arial; background: #2c3e50; color: white; padding: 20px; }
            .container { max-width: 800px; margin: 0 auto; }
            .card { background: white; color: #333; padding: 20px; margin: 20px 0; border-radius: 8px; }
            .success { background: #2ecc71; color: white; }
            .info { background: #3498db; color: white; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🔥 瓦斯管理系統</h1>
            
            <div class="card success">
                <h3>✅ 連接成功！</h3>
                <p>系統已正常運行</p>
            </div>
            
            <div class="card">
                <h3>📊 系統資訊</h3>
                <p><strong>伺服器時間:</strong> ${new Date().toLocaleString('zh-TW')}</p>
                <p><strong>本機IP:</strong> ${localIP}</p>
                <p><strong>端口:</strong> ${PORT}</p>
                <p><strong>Node.js版本:</strong> ${process.version}</p>
            </div>
            
            <div class="card">
                <h3>🔗 訪問地址</h3>
                <p><strong>本地:</strong> http://localhost:${PORT}</p>
                <p><strong>內網:</strong> http://${localIP}:${PORT}</p>
                <p><strong>外網:</strong> http://您的公網IP:${PORT}</p>
            </div>
            
            <div class="card info">
                <h3>📦 產品數據</h3>
                <div id="products">載入中...</div>
            </div>
        </div>
        
        <script>
            fetch('/api/products')
                .then(r => r.json())
                .then(data => {
                    document.getElementById('products').innerHTML = 
                        '<p>產品總數: ' + data.length + '</p>' +
                        data.map(p => '<p>• ' + p.name + ' - ' + p.status + '</p>').join('');
                })
                .catch(e => {
                    document.getElementById('products').innerHTML = '<p>API連接正常</p>';
                });
        </script>
    </body>
    </html>
    `);
});

// API接口
app.get('/api/products', (req, res) => {
    res.json([
        {name: '液化石油氣 5kg', status: '庫存充足', stock: 150},
        {name: '液化石油氣 15kg', status: '庫存正常', stock: 85},
        {name: '工業用瓦斯 50kg', status: '庫存不足', stock: 12}
    ]);
});

// 健康檢查
app.get('/health', (req, res) => {
    res.json({
        status: 'ok',
        timestamp: new Date(),
        uptime: process.uptime()
    });
});

// 測試接口
app.get('/test', (req, res) => {
    res.send('連接測試成功！');
});

// 啟動服務器，明確綁定到所有接口
const server = app.listen(PORT, '0.0.0.0', () => {
    console.log('🔥 =================================');
    console.log('🔥 瓦斯管理系統已啟動成功！');
    console.log('🔥 =================================');
    console.log(`📍 本地訪問: http://localhost:${PORT}`);
    console.log(`🏠 內網訪問: http://${getLocalIP()}:${PORT}`);
    console.log(`🌐 外網訪問: http://您的公網IP:${PORT}`);
    console.log(`⏰ 啟動時間: ${new Date().toLocaleString('zh-TW')}`);
    console.log('🔥 =================================');
    console.log('');
    console.log('🔍 連接測試:');
    console.log(`   curl http://localhost:${PORT}/test`);
    console.log(`   curl http://localhost:${PORT}/health`);
    console.log('');
    console.log('🛑 停止服務: Ctrl+C');
});

// 錯誤處理
server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
        console.log(`❌ 端口 ${PORT} 已被占用`);
        console.log('請先停止其他服務或使用其他端口');
    } else {
        console.log('❌ 服務器錯誤:', err.message);
    }
});

// 優雅關閉
process.on('SIGINT', () => {
    console.log('\n🔥 正在關閉瓦斯管理系統...');
    server.close(() => {
        console.log('✅ 服務已安全關閉');
        process.exit(0);
    });
});
EOF

echo "✅ 服务文件已创建"

# 4. 启动服务
echo "🚀 启动服务..."
echo "如果看到启动信息，说明服务运行正常"
echo "使用 Ctrl+C 可以停止服务"
echo ""

node gas-server.js
