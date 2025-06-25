#!/bin/bash
# 创建完整美观的瓦斯管理系统 - 完全还原原始设计

echo "🎨 创建完整美观版瓦斯管理系统..."

cat > gas-beautiful.js << 'EOF'
const express = require('express');
const app = express();
const PORT = 3000;

app.use(express.json());

// 主页路由 - 完整还原原始设计
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
            font-family: 'Microsoft JhengHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }
        
        .app-container {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .page-header {
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-content h1 {
            font-size: 2.5rem;
            color: #2c3e50;
            margin-bottom: 8px;
            font-weight: 700;
        }
        
        .header-content p {
            color: #7f8c8d;
            font-size: 1.1rem;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #545b62;
            transform: translateY(-1px);
        }
        
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .product-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
        }
        
        .product-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .product-header h3 {
            color: #2c3e50;
            font-size: 1.4rem;
            font-weight: 600;
        }
        
        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            color: white;
        }
        
        .status-success {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
        }
        
        .status-warning {
            background: linear-gradient(135deg, #f39c12, #e67e22);
        }
        
        .status-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
        }
        
        .product-info {
            margin-bottom: 20px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .label {
            color: #7f8c8d;
            font-weight: 500;
        }
        
        .value {
            color: #2c3e50;
            font-weight: 600;
        }
        
        .value.price {
            color: #667eea;
            font-size: 1.1rem;
        }
        
        .product-actions {
            display: flex;
            gap: 10px;
        }
        
        .inventory-summary {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
        
        .inventory-summary h3 {
            color: #2c3e50;
            font-size: 1.5rem;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .summary-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .stat-item {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 15px;
            border-left: 4px solid #667eea;
        }
        
        .stat-label {
            display: block;
            color: #7f8c8d;
            font-size: 0.9rem;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .stat-value {
            display: block;
            color: #2c3e50;
            font-size: 1.8rem;
            font-weight: 700;
        }
        
        .stat-value.danger {
            color: #e74c3c;
        }
        
        .system-info {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
        
        .system-info h3 {
            color: #2c3e50;
            margin-bottom: 15px;
        }
        
        .system-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }
        
        .system-stat {
            display: flex;
            justify-content: space-between;
            padding: 10px 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        
        .loading {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }
        
        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }
            
            .products-grid {
                grid-template-columns: 1fr;
            }
            
            .summary-stats {
                grid-template-columns: 1fr;
            }
            
            .system-stats {
                grid-template-columns: 1fr;
            }
        }
        
        .fade-in {
            opacity: 0;
            animation: fadeIn 0.6s ease forwards;
        }
        
        @keyframes fadeIn {
            to {
                opacity: 1;
            }
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- 页面头部 -->
        <div class="page-header fade-in">
            <div class="header-content">
                <h1>🔥 瓦斯管理系統</h1>
                <p>管理瓦斯產品資訊、庫存與價格</p>
            </div>
            <button class="btn btn-primary" onclick="addProduct()">
                <span>+</span>
                新增產品
            </button>
        </div>
        
        <!-- 系统信息 -->
        <div class="system-info fade-in">
            <h3>📊 系統狀態</h3>
            <div class="system-stats">
                <div class="system-stat">
                    <span>系統狀態</span>
                    <span style="color: #27ae60; font-weight: bold;">✅ 正常運行</span>
                </div>
                <div class="system-stat">
                    <span>伺服器</span>
                    <span>lstjks.sytes.net:${PORT}</span>
                </div>
                <div class="system-stat">
                    <span>外網IP</span>
                    <span>165.154.226.148</span>
                </div>
                <div class="system-stat">
                    <span>啟動時間</span>
                    <span>${new Date().toLocaleString('zh-TW')}</span>
                </div>
            </div>
        </div>
        
        <!-- 产品网格 -->
        <div class="products-grid" id="products-grid">
            <div class="loading">載入產品資料中...</div>
        </div>
        
        <!-- 库存总览 -->
        <div class="inventory-summary fade-in">
            <h3>📈 庫存總覽</h3>
            <div class="summary-stats" id="summary-stats">
                <div class="loading">計算統計中...</div>
            </div>
        </div>
    </div>
    
    <script>
        // 产品数据管理
        let products = [];
        
        // 获取库存状态
        function getStockStatus(stock) {
            if (stock < 20) return 'danger';
            if (stock < 50) return 'warning';
            return 'success';
        }
        
        // 获取库存标签
        function getStockLabel(stock) {
            if (stock < 20) return '庫存不足';
            if (stock < 50) return '庫存偏低';
            return '庫存充足';
        }
        
        // 渲染产品卡片
        function renderProducts(products) {
            const grid = document.getElementById('products-grid');
            
            if (products.length === 0) {
                grid.innerHTML = '<div class="loading">暂无产品数据</div>';
                return;
            }
            
            grid.innerHTML = products.map((product, index) => {
                const status = getStockStatus(product.stock);
                const label = getStockLabel(product.stock);
                
                return \`
                <div class="product-card fade-in" style="animation-delay: \${index * 0.1}s">
                    <div class="product-header">
                        <h3>\${product.name}</h3>
                        <span class="status status-\${status}">\${label}</span>
                    </div>
                    
                    <div class="product-info">
                        <div class="info-row">
                            <span class="label">規格:</span>
                            <span class="value">\${product.size}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">售價:</span>
                            <span class="value price">NT$ \${product.price.toLocaleString()}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">成本:</span>
                            <span class="value">NT$ \${product.cost.toLocaleString()}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">庫存:</span>
                            <span class="value">\${product.stock} 桶</span>
                        </div>
                        <div class="info-row">
                            <span class="label">供應商:</span>
                            <span class="value">\${product.supplier}</span>
                        </div>
                    </div>
                    
                    <div class="product-actions">
                        <button class="btn btn-secondary" onclick="editProduct('\${product.id}')">編輯</button>
                        <button class="btn btn-primary" onclick="restockProduct('\${product.id}')">補貨</button>
                    </div>
                </div>
                \`;
            }).join('');
        }
        
        // 渲染统计信息
        function renderSummary(products) {
            const summaryContainer = document.getElementById('summary-stats');
            
            const totalProducts = products.length;
            const lowStockProducts = products.filter(p => p.stock < 20).length;
            const totalInventoryValue = products.reduce((sum, p) => sum + (p.cost * p.stock), 0);
            const avgProfitMargin = products.length > 0 ? 
                Math.round(products.reduce((sum, p) => sum + ((p.price - p.cost) / p.price * 100), 0) / products.length) : 0;
            
            summaryContainer.innerHTML = \`
                <div class="stat-item">
                    <span class="stat-label">總產品數</span>
                    <span class="stat-value">\${totalProducts}</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">低庫存產品</span>
                    <span class="stat-value \${lowStockProducts > 0 ? 'danger' : ''}">\${lowStockProducts}</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">總庫存值</span>
                    <span class="stat-value">NT$ \${totalInventoryValue.toLocaleString()}</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">平均利潤率</span>
                    <span class="stat-value">\${avgProfitMargin}%</span>
                </div>
            \`;
        }
        
        // 加载产品数据
        function loadProducts() {
            fetch('/api/products')
                .then(response => response.json())
                .then(data => {
                    products = data;
                    renderProducts(products);
                    renderSummary(products);
                })
                .catch(error => {
                    console.error('載入產品失敗:', error);
                    document.getElementById('products-grid').innerHTML = 
                        '<div class="loading" style="color: #e74c3c;">載入產品失敗，請檢查網路連接</div>';
                });
        }
        
        // 产品操作函数
        function addProduct() {
            alert('新增產品功能開發中...');
        }
        
        function editProduct(id) {
            alert(\`編輯產品 ID: \${id}\`);
        }
        
        function restockProduct(id) {
            alert(\`補貨產品 ID: \${id}\`);
        }
        
        // 页面加载完成后执行
        document.addEventListener('DOMContentLoaded', () => {
            loadProducts();
            
            // 每30秒刷新一次数据
            setInterval(loadProducts, 30000);
        });
    </script>
</body>
</html>
    `);
});

// API路由 - 完整产品数据
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

// 系统信息API
app.get('/api/system', (req, res) => {
    res.json({
        status: 'running',
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        version: process.version,
        platform: process.platform,
        domain: 'lstjks.sytes.net',
        ip: '165.154.226.148',
        port: PORT,
        startTime: new Date()
    });
});

// 健康检查
app.get('/health', (req, res) => {
    res.json({ 
        status: 'ok', 
        timestamp: new Date(),
        domain: 'lstjks.sytes.net',
        ip: '165.154.226.148'
    });
});

// 启动服务器
app.listen(PORT, '0.0.0.0', () => {
    console.log('🔥 =======================================');
    console.log('🔥  瓦斯管理系統已成功啟動！');
    console.log('🔥 =======================================');
    console.log(\`📍 本地訪問: http://localhost:\${PORT}\`);
    console.log(\`🌐 外網訪問: http://165.154.226.148:\${PORT}\`);
    console.log(\`🔗 域名訪問: http://lstjks.sytes.net:\${PORT}\`);
    console.log(\`⏰ 啟動時間: \${new Date().toLocaleString('zh-TW')}\`);
    console.log('🔥 =======================================');
    console.log('');
    console.log('🌟 功能特色:');
    console.log('   ✨ 完整還原原始設計界面');
    console.log('   📱 響應式設計，支援手機訪問');
    console.log('   🎨 美觀的漸變色彩和動畫效果');
    console.log('   📊 即時庫存統計和狀態顯示');
    console.log('   🔄 自動數據刷新');
    console.log('');
    console.log('🎯 立即訪問您的瓦斯管理系統！');
});

// 优雅关闭
process.on('SIGINT', () => {
    console.log('\n🔥 正在關閉瓦斯管理系統...');
    process.exit(0);
});
EOF

echo "✅ 完整美观版已创建"
echo "🎯 停止旧服务并启动新版本..."

# 停止旧服务
pkill -f "node.*gas" 2>/dev/null || true

echo "🚀 启动完整美观版瓦斯管理系统..."
node gas-beautiful.js
