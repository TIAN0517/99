const express = require('express');
const app = express();
const PORT = 3000;

// 静态文件服务
app.use(express.json());

// 主页路由 - Enhanced Beautiful版本
app.get('/', (req, res) => {
    res.send(`<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>瓦斯管理系統 Enhanced - Jy技術團隊</title>
    <style>
        :root {
            --primary-color: #00d4ff;
            --secondary-color: #ff6b35;
            --success-color: #00ff88;
            --warning-color: #ffaa00;
            --error-color: #ff4444;
            --text-primary: #ffffff;
            --text-secondary: rgba(255, 255, 255, 0.7);
            --text-muted: rgba(255, 255, 255, 0.5);
            --background-primary: #0a0a0a;
            --background-secondary: #1a1a1a;
            --border-color: rgba(255, 255, 255, 0.1);
            --gradient-card: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Microsoft JhengHei', 'PingFang TC', 'Noto Sans TC', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: var(--text-primary);
            overflow-x: hidden;
        }
        
        .product-management {
            padding: 24px;
            max-width: 1200px;
            margin: 0 auto;
            animation: fadeIn 0.8s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .system-info {
            background: var(--gradient-card);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 32px;
            backdrop-filter: blur(20px);
        }
        
        .system-info h3 {
            font-size: 20px;
            color: var(--text-primary);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .system-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 16px;
        }
        
        .system-stat {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
        }
        
        .system-stat:hover {
            background: rgba(255, 255, 255, 0.08);
            transform: translateY(-1px);
        }
        
        .system-stat span:first-child {
            color: var(--text-secondary);
            font-size: 14px;
        }
        
        .system-stat span:last-child {
            color: var(--text-primary);
            font-weight: 600;
            font-size: 14px;
        }
        
        .status-success {
            color: var(--success-color) !important;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            padding-bottom: 16px;
            border-bottom: 2px solid rgba(0, 212, 255, 0.1);
        }
        
        .header-content h1 {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 4px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }
        
        .header-content p {
            color: var(--text-secondary);
            font-size: 14px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), #0099cc);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 212, 255, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 212, 255, 0.4);
        }
        
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }
        
        .product-card {
            background: var(--gradient-card);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 20px;
            transition: all 0.3s ease;
            backdrop-filter: blur(20px);
            position: relative;
            overflow: hidden;
        }
        
        .product-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .product-card:hover {
            transform: translateY(-4px);
            border-color: var(--primary-color);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
        }
        
        .product-card:hover::before {
            opacity: 1;
        }
        
        .product-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
        }
        
        .product-header h3 {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }
        
        .stock-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .stock-status.success {
            background: rgba(0, 255, 136, 0.2);
            color: var(--success-color);
            border: 1px solid var(--success-color);
        }
        
        .stock-status.warning {
            background: rgba(255, 170, 0, 0.2);
            color: var(--warning-color);
            border: 1px solid var(--warning-color);
        }
        
        .stock-status.danger {
            background: rgba(255, 68, 68, 0.2);
            color: var(--error-color);
            border: 1px solid var(--error-color);
        }
        
        .product-info {
            margin-bottom: 20px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .label {
            font-size: 13px;
            color: var(--text-secondary);
            font-weight: 500;
        }
        
        .value {
            font-size: 14px;
            color: var(--text-primary);
            font-weight: 600;
        }
        
        .value.price {
            color: var(--success-color);
            font-size: 16px;
        }
        
        .value.danger {
            color: var(--error-color);
        }
        
        .inventory-summary {
            background: var(--gradient-card);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 24px;
            backdrop-filter: blur(20px);
            margin-bottom: 24px;
        }
        
        .inventory-summary h3 {
            font-size: 20px;
            color: var(--text-primary);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .summary-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .stat-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 16px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }
        
        .stat-item:hover {
            background: rgba(255, 255, 255, 0.08);
            transform: translateY(-2px);
        }
        
        .stat-label {
            font-size: 12px;
            color: var(--text-secondary);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: var(--text-primary);
        }
        
        .footer {
            text-align: center;
            padding: 24px;
            color: var(--text-muted);
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: 32px;
        }
        
        .footer .brand {
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .loading {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px;
            color: var(--text-secondary);
        }
        
        .loading::after {
            content: "";
            width: 20px;
            height: 20px;
            border: 2px solid var(--primary-color);
            border-top: 2px solid transparent;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-left: 12px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* 響應式設計 */
        @media (max-width: 768px) {
            .product-management {
                padding: 16px;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
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
    </style>
</head>
<body>
    <div class="product-management">
        <!-- 系統資訊 -->
        <div class="system-info">
            <h3>🚀 Enhanced 系統狀態</h3>
            <div class="system-stats">
                <div class="system-stat">
                    <span>系統狀態</span>
                    <span class="status-success">✅ Enhanced 正常運行</span>
                </div>
                <div class="system-stat">
                    <span>外網IP</span>
                    <span>165.154.226.148</span>
                </div>
                <div class="system-stat">
                    <span>域名訪問</span>
                    <span>lstjks.sytes.net</span>
                </div>
                <div class="system-stat">
                    <span>服務端口</span>
                    <span>3000</span>
                </div>
                <div class="system-stat">
                    <span>版本</span>
                    <span>Enhanced v2.1</span>
                </div>
                <div class="system-stat">
                    <span>啟動時間</span>
                    <span id="start-time">${new Date().toLocaleString('zh-TW')}</span>
                </div>
            </div>
        </div>
        
        <!-- 頁面標題 -->
        <div class="page-header">
            <div class="header-content">
                <h1>🔥 產品管理 Enhanced</h1>
                <p>完全還原 ProductManagement.tsx 設計 - 增強版界面</p>
            </div>
            <button class="btn btn-primary" onclick="addProduct()">
                <span>+</span>
                新增產品
            </button>
        </div>
        
        <!-- 產品列表 -->
        <div class="products-grid" id="products-grid">
            <div class="loading">載入 Enhanced 產品資料中...</div>
        </div>
        
        <!-- 庫存總覽 -->
        <div class="inventory-summary">
            <h3>📊 Enhanced 庫存總覽</h3>
            <div class="summary-stats" id="summary-stats">
                <div class="loading">計算 Enhanced 庫存統計中...</div>
            </div>
        </div>
        
        <!-- 頁腳 -->
        <div class="footer">
            <p>© 2025 <span class="brand">Jy技術團隊</span> - 瓦斯管理系統 Enhanced Edition v2.1</p>
            <p>🎨 完全還原 ProductManagement.tsx 原始設計 + 增強功能</p>
            <p>🌐 外網訪問: <strong>165.154.226.148:3000</strong> | 🔗 域名: <strong>lstjks.sytes.net:3000</strong></p>
        </div>
    </div>
    
    <script>
        console.log('🔥 Enhanced 瓦斯管理系統 v2.1 啟動中...');
        
        // 產品資料載入
        fetch('/api/products')
            .then(response => response.json())
            .then(products => {
                console.log('📦 Enhanced 產品資料載入完成:', products.length, '個產品');
                renderProducts(products);
                renderSummaryStats(products);
            })
            .catch(error => {
                console.error('❌ 載入產品資料失敗:', error);
                document.getElementById('products-grid').innerHTML = 
                    '<div style="text-align: center; color: var(--error-color); padding: 40px;">Enhanced 模式載入資料失敗，請重新整理頁面</div>';
            });
        
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
        
        function renderProducts(products) {
            const grid = document.getElementById('products-grid');
            grid.innerHTML = products.map((product, index) => {
                const stockStatus = getStockStatus(product.stock);
                const stockLabel = getStockLabel(product.stock);
                const profit = ((product.price - product.cost) / product.cost * 100).toFixed(1);
                
                return \`
                    <div class="product-card" style="animation-delay: \${index * 0.1}s">
                        <div class="product-header">
                            <h3>\${product.name}</h3>
                            <span class="stock-status \${stockStatus}">\${stockLabel}</span>
                        </div>
                        <div class="product-info">
                            <div class="info-row">
                                <span class="label">規格</span>
                                <span class="value">\${product.size}</span>
                            </div>
                            <div class="info-row">
                                <span class="label">售價</span>
                                <span class="value price">NT$ \${product.price.toLocaleString()}</span>
                            </div>
                            <div class="info-row">
                                <span class="label">成本</span>
                                <span class="value">NT$ \${product.cost.toLocaleString()}</span>
                            </div>
                            <div class="info-row">
                                <span class="label">利潤率</span>
                                <span class="value" style="color: \${profit > 30 ? 'var(--success-color)' : profit > 15 ? 'var(--warning-color)' : 'var(--error-color)'}">\${profit}%</span>
                            </div>
                            <div class="info-row">
                                <span class="label">庫存</span>
                                <span class="value \${stockStatus === 'danger' ? 'danger' : ''}">\${product.stock} 桶</span>
                            </div>
                            <div class="info-row">
                                <span class="label">供應商</span>
                                <span class="value">\${product.supplier}</span>
                            </div>
                        </div>
                    </div>
                \`;
            }).join('');
        }
        
        function renderSummaryStats(products) {
            const totalProducts = products.length;
            const totalStock = products.reduce((sum, p) => sum + p.stock, 0);
            const totalValue = products.reduce((sum, p) => sum + (p.price * p.stock), 0);
            const lowStockCount = products.filter(p => p.stock < 20).length;
            const avgProfit = (products.reduce((sum, p) => sum + ((p.price - p.cost) / p.cost * 100), 0) / totalProducts).toFixed(1);
            const totalCost = products.reduce((sum, p) => sum + (p.cost * p.stock), 0);
            const totalProfit = totalValue - totalCost;
            
            document.getElementById('summary-stats').innerHTML = \`
                <div class="stat-item">
                    <span class="stat-label">總產品數</span>
                    <span class="stat-value">\${totalProducts}</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">總庫存</span>
                    <span class="stat-value">\${totalStock} 桶</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">庫存總值</span>
                    <span class="stat-value">NT$ \${totalValue.toLocaleString()}</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">預估利潤</span>
                    <span class="stat-value" style="color: var(--success-color)">NT$ \${totalProfit.toLocaleString()}</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">低庫存警告</span>
                    <span class="stat-value" style="color: \${lowStockCount > 0 ? 'var(--warning-color)' : 'var(--success-color)'}">\${lowStockCount} 項</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">平均利潤率</span>
                    <span class="stat-value">\${avgProfit}%</span>
                </div>
            \`;
        }
        
        function addProduct() {
            alert('Enhanced 功能：新增產品功能將在後續版本中實現');
        }
        
        // 每10秒更新一次時間
        setInterval(() => {
            document.getElementById('start-time').textContent = new Date().toLocaleString('zh-TW');
        }, 10000);
        
        console.log('✨ Enhanced 瓦斯管理系統 v2.1 載入完成！');
        console.log('🌐 外網訪問: http://165.154.226.148:3000');
        console.log('🔗 域名訪問: http://lstjks.sytes.net:3000');
    </script>
</body>
</html>`);
});

// API路由 - 產品資料 (Enhanced)
app.get('/api/products', (req, res) => {
    console.log('📦 Enhanced API請求: /api/products');
    const products = [
        {
            id: '1',
            name: '液化石油氣',
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
            size: '20kg',
            price: 850,
            cost: 650,
            stock: 45,
            supplier: '台塑石化',
            lastUpdated: new Date()
        },
        {
            id: '5',
            name: '攜帶式瓦斯',
            size: '2kg',
            price: 180,
            cost: 140,
            stock: 200,
            supplier: '中油公司',
            lastUpdated: new Date()
        },
        {
            id: '6',
            name: '商用瓦斯',
            size: '30kg',
            price: 1200,
            cost: 950,
            stock: 25,
            supplier: '台塑石化',
            lastUpdated: new Date()
        }
    ];

    res.json(products);
});

// 健康檢查 (Enhanced)
app.get('/health', (req, res) => {
    res.json({
        status: 'Enhanced OK',
        timestamp: new Date().toISOString(),
        version: 'Enhanced v2.1',
        message: 'Enhanced 瓦斯管理系統運行正常',
        externalAccess: {
            ip: '165.154.226.148:3000',
            domain: 'lstjks.sytes.net:3000'
        }
    });
});

// 系統資訊 (Enhanced)
app.get('/api/system', (req, res) => {
    res.json({
        status: 'Enhanced 正常運行',
        version: 'Enhanced v2.1',
        startTime: new Date().toISOString(),
        externalIP: '165.154.226.148',
        domain: 'lstjks.sytes.net',
        port: PORT,
        features: [
            '✨ 完全還原 ProductManagement.tsx 設計',
            '🎨 Enhanced 4D 科技感界面',
            '📱 Enhanced 響應式設計',
            '⚡ Enhanced 即時資料更新',
            '📊 Enhanced 庫存預警系統',
            '🚀 Enhanced 流暢動畫效果'
        ],
        enhanced: true
    });
});

// 404處理 (Enhanced)
app.use((req, res) => {
    res.status(404).json({
        error: 'Enhanced 頁面不存在',
        message: '請返回首頁使用 Enhanced 系統功能',
        timestamp: new Date().toISOString(),
        redirectUrl: 'http://165.154.226.148:3000'
    });
});

// 啟動 Enhanced 服務器
app.listen(PORT, '0.0.0.0', () => {
    console.log('🔥 =======================================');
    console.log('🔥  Enhanced 瓦斯管理系統 v2.1 已啟動！');
    console.log('🔥 =======================================');
    console.log('📍 本地訪問: http://localhost:' + PORT);
    console.log('🌐 外網訪問: http://165.154.226.148:' + PORT);
    console.log('🔗 域名訪問: http://lstjks.sytes.net:' + PORT);
    console.log('📋 健康檢查: http://165.154.226.148:' + PORT + '/health');
    console.log('📊 系統資訊: http://165.154.226.148:' + PORT + '/api/system');
    console.log('⏰ 啟動時間: ' + new Date().toLocaleString('zh-TW'));
    console.log('🔥 =======================================');
    console.log('');
    console.log('🌟 Enhanced Edition v2.1 特色功能:');
    console.log('   ✨ 完全還原 ProductManagement.tsx 原始設計');
    console.log('   🎨 Enhanced 4D 科技感無邊框界面');
    console.log('   📱 Enhanced 完美響應式設計');
    console.log('   ⚡ Enhanced 即時資料載入與更新');
    console.log('   📊 Enhanced 智能庫存統計分析');
    console.log('   🚀 Enhanced 流暢動畫與過渡效果');
    console.log('   💎 Enhanced Professional 級別視覺設計');
    console.log('   🌐 Enhanced 外網連線優化');
    console.log('');
    console.log('🎯 Enhanced 系統已就緒，等待連線...');
    console.log('💡 提示：訪問 http://165.154.226.148:3000 或 http://lstjks.sytes.net:3000');
});

// 錯誤處理
process.on('uncaughtException', (error) => {
    console.error('❌ Enhanced 系統發生未捕獲異常:', error);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('❌ Enhanced 系統發生未處理拒絕:', reason);
});

// 優雅關閉
process.on('SIGINT', () => {
    console.log('\n🛑 Enhanced 瓦斯管理系統正在優雅關閉...');
    process.exit(0);
});

process.on('SIGTERM', () => {
    console.log('\n🛑 Enhanced 瓦斯管理系統收到終止信號，正在關閉...');
    process.exit(0);
});
