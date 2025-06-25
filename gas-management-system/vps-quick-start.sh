#!/bin/bash
# 瓦斯管理系统 - VPS 一键启动脚本
# 创建缺失文件并启动Web版本

echo "🔥 瓦斯管理系统 - VPS 一键启动"
echo "=================================="

# 创建 start-gas-web.js 文件
echo "📝 创建 Web 启动文件..."

cat > start-gas-web.js << 'EOF'
const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// 中间件
app.use(express.static(path.join(__dirname, 'dist')));
app.use(express.static(path.join(__dirname, 'src')));
app.use(express.json());

// 主页路由
app.get('/', (req, res) => {
    res.send(`
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>瓦斯管理系統</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Microsoft JhengHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .header {
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            margin-bottom: 30px;
            text-align: center;
        }
        
        .header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #7f8c8d;
            font-size: 1.1rem;
        }
        
        .status-card {
            background: rgba(255, 255, 255, 0.95);
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            margin-bottom: 30px;
        }
        
        .status-card h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 1.5rem;
        }
        
        .status-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .status-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            border-left: 4px solid #007bff;
        }
        
        .status-item.success {
            border-left-color: #28a745;
        }
        
        .status-item.warning {
            border-left-color: #ffc107;
        }
        
        .status-item.danger {
            border-left-color: #dc3545;
        }
        
        .status-label {
            display: block;
            font-weight: bold;
            color: #495057;
            margin-bottom: 5px;
        }
        
        .status-value {
            display: block;
            font-size: 1.2rem;
            font-weight: bold;
        }
        
        .status-value.success { color: #28a745; }
        .status-value.warning { color: #ffc107; }
        .status-value.danger { color: #dc3545; }
        
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .product-card {
            background: rgba(255, 255, 255, 0.95);
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
        }
        
        .product-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .product-header h4 {
            color: #2c3e50;
            font-size: 1.2rem;
        }
        
        .stock-status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            color: white;
        }
        
        .stock-status.success { background: #28a745; }
        .stock-status.warning { background: #ffc107; }
        .stock-status.danger { background: #dc3545; }
        
        .product-info {
            margin-bottom: 15px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            padding: 5px 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-label {
            color: #6c757d;
            font-weight: 500;
        }
        
        .info-value {
            color: #495057;
            font-weight: bold;
        }
        
        .price {
            color: #007bff;
        }
        
        .btn {
            background: #007bff;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
            transition: background 0.3s ease;
        }
        
        .btn:hover {
            background: #0056b3;
        }
        
        .btn-secondary {
            background: #6c757d;
        }
        
        .btn-secondary:hover {
            background: #545b62;
        }
        
        .footer {
            text-align: center;
            color: rgba(255, 255, 255, 0.8);
            margin-top: 30px;
        }
        
        @media (max-width: 768px) {
            .products-grid {
                grid-template-columns: 1fr;
            }
            
            .status-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔥 瓦斯管理系統</h1>
            <p>專業的瓦斯產品管理解決方案</p>
        </div>
        
        <div class="status-card">
            <h3>📊 系統狀態</h3>
            <div class="status-grid">
                <div class="status-item success">
                    <span class="status-label">系統狀態</span>
                    <span class="status-value success">✓ 正常運行</span>
                </div>
                <div class="status-item">
                    <span class="status-label">服務端口</span>
                    <span class="status-value">${PORT}</span>
                </div>
                <div class="status-item">
                    <span class="status-label">啟動時間</span>
                    <span class="status-value">${new Date().toLocaleString('zh-TW')}</span>
                </div>
                <div class="status-item">
                    <span class="status-label">Node.js版本</span>
                    <span class="status-value">${process.version}</span>
                </div>
            </div>
        </div>
        
        <div class="status-card">
            <h3>📦 產品管理</h3>
            <div id="products-container">
                <div class="products-grid" id="products"></div>
            </div>
        </div>
        
        <div class="status-card">
            <h3>📈 庫存總覽</h3>
            <div class="status-grid" id="inventory-summary"></div>
        </div>
        
        <div class="footer">
            <p>瓦斯管理系統 v1.0.0 | 運行在 VPS 環境</p>
        </div>
    </div>

    <script>
        // 載入產品數據
        fetch('/api/products')
            .then(response => response.json())
            .then(products => {
                // 渲染產品列表
                const productsContainer = document.getElementById('products');
                productsContainer.innerHTML = products.map(product => {
                    const stockStatus = product.stock < 20 ? 'danger' : product.stock < 50 ? 'warning' : 'success';
                    const stockLabel = product.stock < 20 ? '庫存不足' : product.stock < 50 ? '庫存偏低' : '庫存充足';
                    
                    return \`
                        <div class="product-card">
                            <div class="product-header">
                                <h4>\${product.name}</h4>
                                <span class="stock-status \${stockStatus}">\${stockLabel}</span>
                            </div>
                            <div class="product-info">
                                <div class="info-row">
                                    <span class="info-label">規格:</span>
                                    <span class="info-value">\${product.size}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">售價:</span>
                                    <span class="info-value price">NT$ \${product.price.toLocaleString()}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">成本:</span>
                                    <span class="info-value">NT$ \${product.cost.toLocaleString()}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">庫存:</span>
                                    <span class="info-value">\${product.stock} 桶</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">供應商:</span>
                                    <span class="info-value">\${product.supplier}</span>
                                </div>
                            </div>
                            <div>
                                <button class="btn btn-secondary">編輯</button>
                                <button class="btn">補貨</button>
                            </div>
                        </div>
                    \`;
                }).join('');
                
                // 計算總覽數據
                const totalProducts = products.length;
                const lowStockProducts = products.filter(p => p.stock < 20).length;
                const totalInventoryValue = products.reduce((sum, p) => sum + (p.cost * p.stock), 0);
                
                // 渲染總覽
                const summaryContainer = document.getElementById('inventory-summary');
                summaryContainer.innerHTML = \`
                    <div class="status-item">
                        <span class="status-label">總產品數</span>
                        <span class="status-value">\${totalProducts}</span>
                    </div>
                    <div class="status-item \${lowStockProducts > 0 ? 'danger' : 'success'}">
                        <span class="status-label">低庫存產品</span>
                        <span class="status-value \${lowStockProducts > 0 ? 'danger' : 'success'}">\${lowStockProducts}</span>
                    </div>
                    <div class="status-item">
                        <span class="status-label">總庫存值</span>
                        <span class="status-value">NT$ \${totalInventoryValue.toLocaleString()}</span>
                    </div>
                    <div class="status-item">
                        <span class="status-label">平均利潤率</span>
                        <span class="status-value">\${Math.round(products.reduce((sum, p) => sum + ((p.price - p.cost) / p.price * 100), 0) / products.length)}%</span>
                    </div>
                \`;
            })
            .catch(error => {
                console.error('載入產品數據失敗:', error);
                document.getElementById('products').innerHTML = '<p>無法載入產品數據</p>';
            });
    </script>
</body>
</html>
    `);
});

// API 路由
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
        },
        {
            id: '4',
            name: '家用瓦斯',
            type: 'domestic',
            size: '20kg',
            price: 850,
            cost: 650,
            stock: 45,
            supplier: '台塑石化',
            lastUpdated: new Date()
        }
    ]);
});

// 系統資訊 API
app.get('/api/system', (req, res) => {
    res.json({
        status: 'running',
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        version: process.version,
        platform: process.platform,
        port: PORT,
        startTime: new Date()
    });
});

// 健康檢查 API
app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date() });
});

// 啟動伺服器
app.listen(PORT, '0.0.0.0', () => {
    console.log('🔥 =====================================');
    console.log('🔥  瓦斯管理系統已成功啟動！');
    console.log('🔥 =====================================');
    console.log(`📍 本地訪問: http://localhost:${PORT}`);
    console.log(`🌐 外部訪問: http://$(curl -s ifconfig.me 2>/dev/null || echo 'YOUR_SERVER_IP'):${PORT}`);
    console.log(`⏰ 啟動時間: ${new Date().toLocaleString('zh-TW')}`);
    console.log(`🚀 Node.js版本: ${process.version}`);
    console.log(`💾 進程ID: ${process.pid}`);
    console.log('🔥 =====================================');
    console.log('');
    console.log('📋 可用端點:');
    console.log(`   GET  /           - 主頁面`);
    console.log(`   GET  /api/products - 產品數據`);
    console.log(`   GET  /api/system   - 系統資訊`);
    console.log(`   GET  /health       - 健康檢查`);
    console.log('');
    console.log('🎯 使用 Ctrl+C 停止服務');
});

// 優雅關閉
process.on('SIGINT', () => {
    console.log('\\n🔥 正在關閉瓦斯管理系統...');
    process.exit(0);
});

process.on('SIGTERM', () => {
    console.log('\\n🔥 正在關閉瓦斯管理系統...');
    process.exit(0);
});
EOF

echo "✅ start-gas-web.js 文件已创建"

# 启动服务
echo "🚀 启动瓦斯管理系统 Web 版本..."
echo ""

node start-gas-web.js
