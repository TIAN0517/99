#!/bin/bash
# 一键部署美观版瓦斯管理系统

echo "🎨 部署完整美观版瓦斯管理系统..."

# 停止现有服务
pkill -f "node.*gas" 2>/dev/null || true
sleep 2

# 创建美观版应用
cat > gas-beautiful.js << 'EOF'
const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.send(`<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>瓦斯管理系統</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Microsoft JhengHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh; color: #333;
        }
        .app-container { padding: 20px; max-width: 1400px; margin: 0 auto; }
        .page-header {
            background: rgba(255, 255, 255, 0.95); padding: 30px; border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1); margin-bottom: 30px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .header-content h1 { font-size: 2.5rem; color: #2c3e50; margin-bottom: 8px; font-weight: 700; }
        .header-content p { color: #7f8c8d; font-size: 1.1rem; }
        .btn {
            padding: 12px 24px; border: none; border-radius: 10px; font-size: 1rem;
            font-weight: 600; cursor: pointer; transition: all 0.3s ease;
            display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #545b62; transform: translateY(-1px); }
        .products-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px; margin-bottom: 30px;
        }
        .product-card {
            background: rgba(255, 255, 255, 0.95); border-radius: 20px; padding: 25px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1); transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .product-card:hover { transform: translateY(-8px); box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15); }
        .product-header {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;
        }
        .product-header h3 { color: #2c3e50; font-size: 1.4rem; font-weight: 600; }
        .status {
            padding: 6px 12px; border-radius: 20px; font-size: 0.85rem;
            font-weight: 600; color: white;
        }
        .status-success { background: linear-gradient(135deg, #2ecc71, #27ae60); }
        .status-warning { background: linear-gradient(135deg, #f39c12, #e67e22); }
        .status-danger { background: linear-gradient(135deg, #e74c3c, #c0392b); }
        .product-info { margin-bottom: 20px; }
        .info-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 10px 0; border-bottom: 1px solid #ecf0f1;
        }
        .info-row:last-child { border-bottom: none; }
        .label { color: #7f8c8d; font-weight: 500; }
        .value { color: #2c3e50; font-weight: 600; }
        .value.price { color: #667eea; font-size: 1.1rem; }
        .product-actions { display: flex; gap: 10px; }
        .inventory-summary {
            background: rgba(255, 255, 255, 0.95); border-radius: 20px; padding: 30px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
        .inventory-summary h3 { color: #2c3e50; font-size: 1.5rem; margin-bottom: 20px; font-weight: 600; }
        .summary-stats {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;
        }
        .stat-item {
            text-align: center; padding: 20px; background: #f8f9fa;
            border-radius: 15px; border-left: 4px solid #667eea;
        }
        .stat-label {
            display: block; color: #7f8c8d; font-size: 0.9rem;
            margin-bottom: 8px; font-weight: 500;
        }
        .stat-value {
            display: block; color: #2c3e50; font-size: 1.8rem; font-weight: 700;
        }
        .stat-value.danger { color: #e74c3c; }
        .system-info {
            background: rgba(255, 255, 255, 0.95); border-radius: 20px; padding: 25px;
            margin-bottom: 30px; box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
        .system-info h3 { color: #2c3e50; margin-bottom: 15px; }
        .system-stats {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;
        }
        .system-stat {
            display: flex; justify-content: space-between; padding: 10px 15px;
            background: #f8f9fa; border-radius: 10px;
        }
        @media (max-width: 768px) {
            .page-header { flex-direction: column; gap: 20px; text-align: center; }
            .products-grid { grid-template-columns: 1fr; }
            .summary-stats { grid-template-columns: 1fr; }
            .system-stats { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="app-container">
        <div class="page-header">
            <div class="header-content">
                <h1>🔥 瓦斯管理系統</h1>
                <p>管理瓦斯產品資訊、庫存與價格</p>
            </div>
            <button class="btn btn-primary">
                <span>+</span>
                新增產品
            </button>
        </div>
        
        <div class="system-info">
            <h3>📊 系統狀態</h3>
            <div class="system-stats">
                <div class="system-stat">
                    <span>系統狀態</span>
                    <span style="color: #27ae60; font-weight: bold;">✅ 正常運行</span>
                </div>
                <div class="system-stat">
                    <span>域名</span>
                    <span>lstjks.sytes.net:3000</span>
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
        
        <div class="products-grid" id="products-grid">載入中...</div>
        
        <div class="inventory-summary">
            <h3>📈 庫存總覽</h3>
            <div class="summary-stats" id="summary-stats">計算中...</div>
        </div>
    </div>
    
    <script>
        function getStockStatus(stock) {
            if (stock < 20) return 'danger';
            if (stock < 50) return 'warning';
            return 'success';
        }
        
        function getStockLabel(stock) {
            if (stock < 20) return '庫存不足';
            if (stock < 50) return '庫存偏低';
            return '庫存充足';
        }
        
        fetch('/api/products').then(r => r.json()).then(products => {
            document.getElementById('products-grid').innerHTML = products.map(product => {
                const status = getStockStatus(product.stock);
                const label = getStockLabel(product.stock);
                return \`
                <div class="product-card">
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
                        <button class="btn btn-secondary">編輯</button>
                        <button class="btn btn-primary">補貨</button>
                    </div>
                </div>
                \`;
            }).join('');
            
            const totalProducts = products.length;
            const lowStockProducts = products.filter(p => p.stock < 20).length;
            const totalValue = products.reduce((sum, p) => sum + (p.cost * p.stock), 0);
            const avgProfit = Math.round(products.reduce((sum, p) => sum + ((p.price - p.cost) / p.price * 100), 0) / products.length);
            
            document.getElementById('summary-stats').innerHTML = \`
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
                    <span class="stat-value">NT$ \${totalValue.toLocaleString()}</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">平均利潤率</span>
                    <span class="stat-value">\${avgProfit}%</span>
                </div>
            \`;
        });
    </script>
</body>
</html>`);
});

app.get('/api/products', (req, res) => {
    res.json([
        { id: '1', name: '液化石油氣', size: '5kg', price: 280, cost: 220, stock: 150, supplier: '中油公司' },
        { id: '2', name: '液化石油氣', size: '15kg', price: 680, cost: 520, stock: 85, supplier: '中油公司' },
        { id: '3', name: '工業用瓦斯', size: '50kg', price: 1850, cost: 1420, stock: 12, supplier: '台塑石化' },
        { id: '4', name: '家用瓦斯', size: '20kg', price: 850, cost: 650, stock: 45, supplier: '台塑石化' }
    ]);
});

app.listen(3000, '0.0.0.0', () => {
    console.log('🔥 =======================================');
    console.log('🔥  瓦斯管理系統 - 美觀版已啟動！');
    console.log('🔥 =======================================');
    console.log('📍 本地: http://localhost:3000');
    console.log('🌐 外網: http://165.154.226.148:3000');
    console.log('🔗 域名: http://lstjks.sytes.net:3000');
    console.log('⏰ 時間: ' + new Date().toLocaleString('zh-TW'));
    console.log('🔥 =======================================');
});
EOF

# 启动美观版
echo "🚀 启动美觀版瓦斯管理系統..."
node gas-beautiful.js
