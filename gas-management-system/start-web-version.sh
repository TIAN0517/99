#!/bin/bash
# 瓦斯管理系统 - Web版本启动脚本
# 将Electron应用转换为Web版本在VPS上运行

set -e

echo "=== 瓦斯管理系统 - Web版本启动 ==="
echo "开始时间: $(date)"

# 安装依赖
echo "=== 第一步：安装依赖 ==="
npm install

# 检查是否安装成功
echo "=== 第二步：检查依赖安装 ==="
if [ ! -d "node_modules" ]; then
    echo "依赖安装失败，重试..."
    npm cache clean --force
    npm install --force
fi

# 安装额外的Web服务器依赖
echo "=== 第三步：安装Web服务器依赖 ==="
npm install express cors helmet morgan
npm install --save-dev nodemon concurrently

# 创建Web服务器
echo "=== 第四步：创建Web服务器 ==="
cat > server.js << 'EOL'
const express = require('express');
const path = require('path');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const app = express();
const PORT = process.env.PORT || 3000;

// 中间件
app.use(helmet());
app.use(cors());
app.use(morgan('combined'));
app.use(express.json());
app.use(express.static(path.join(__dirname, 'dist')));

// 路由
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

// API路由 (基础示例)
app.get('/api/products', (req, res) => {
    res.json([
        {
            id: '1',
            name: '液化石油氣',
            type: 'lpg',
            size: '5kg',
            price: 280,
            cost: 220,
            stock: 150,
            supplier: '中油公司',
            lastUpdated: new Date()
        },
        {
            id: '2',
            name: '液化石油氣',
            type: 'lpg',
            size: '15kg',
            price: 680,
            cost: 520,
            stock: 85,
            supplier: '中油公司',
            lastUpdated: new Date()
        },
        {
            id: '3',
            name: '工業用瓦斯',
            type: 'industrial',
            size: '50kg',
            price: 1850,
            cost: 1420,
            stock: 12,
            supplier: '台塑石化',
            lastUpdated: new Date()
        }
    ]);
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`瓦斯管理系統 Web版本已啟動`);
    console.log(`本地訪問: http://localhost:${PORT}`);
    console.log(`外部訪問: http://$(curl -s ifconfig.me):${PORT}`);
});
EOL

# 修改package.json添加Web启动脚本
echo "=== 第五步：修改package.json ==="
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.scripts = pkg.scripts || {};
pkg.scripts['start:web'] = 'node server.js';
pkg.scripts['dev:web'] = 'nodemon server.js';
pkg.scripts['build:web'] = 'npm run build:renderer';
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
console.log('✓ package.json已更新');
"

# 构建前端资源
echo "=== 第六步：构建前端资源 ==="
npm run build:renderer || {
    echo "前端构建失败，尝试安装缺失依赖..."
    npm install html-webpack-plugin css-loader style-loader ts-loader
    npm run build:renderer
}

# 启动Web服务器
echo "=== 第七步：启动Web服务器 ==="
echo "正在启动瓦斯管理系统Web版本..."
echo "请稍等..."

# 创建systemd服务文件
if [ "$EUID" -eq 0 ]; then
    echo "创建系统服务..."
    cat > /etc/systemd/system/gas-management-web.service << EOL
[Unit]
Description=Gas Management System Web
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=$(pwd)
Environment=NODE_ENV=production
Environment=PORT=3000
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL

    systemctl daemon-reload
    systemctl enable gas-management-web
    systemctl start gas-management-web
    
    echo "=== 服务已启动 ==="
    echo "系统服务状态:"
    systemctl status gas-management-web --no-pager
else
    echo "=== 直接启动Web服务器 ==="
    node server.js
fi
