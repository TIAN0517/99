#!/bin/bash
# 瓦斯管理系统 - 超简单启动脚本

echo "🔥 创建瓦斯管理系统启动文件..."

cat > simple-gas-app.js << 'EOF'
const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
    res.send(`
    <html>
    <head>
        <title>瓦斯管理系統</title>
        <meta charset="UTF-8">
        <style>
            body { font-family: Arial, sans-serif; background: #667eea; color: #fff; padding: 20px; }
            .container { max-width: 1000px; margin: 0 auto; background: rgba(255,255,255,0.95); padding: 30px; border-radius: 15px; color: #333; }
            .header { text-align: center; margin-bottom: 30px; }
            .product { border: 1px solid #ddd; padding: 15px; margin: 10px 0; border-radius: 8px; background: #f9f9f9; }
            .stock-low { color: #dc3545; font-weight: bold; }
            .stock-ok { color: #28a745; font-weight: bold; }
            .btn { background: #007bff; color: white; padding: 8px 16px; border: none; border-radius: 4px; margin: 5px; cursor: pointer; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>🔥 瓦斯管理系統</h1>
                <p>系統狀態: ✅ 正常運行 | 端口: ${PORT} | 時間: ${new Date().toLocaleString('zh-TW')}</p>
            </div>
            <div id="products"></div>
        </div>
        <script>
            fetch('/api/products').then(r => r.json()).then(products => {
                document.getElementById('products').innerHTML = products.map(p => 
                    '<div class="product">' +
                    '<h3>' + p.name + ' (' + p.size + ')</h3>' +
                    '<p><strong>售價:</strong> NT$ ' + p.price + ' | <strong>庫存:</strong> ' + p.stock + ' 桶 | <strong>供應商:</strong> ' + p.supplier + '</p>' +
                    '<p class="' + (p.stock < 20 ? 'stock-low' : 'stock-ok') + '">' + (p.stock < 20 ? '⚠️ 庫存不足' : '✅ 庫存充足') + '</p>' +
                    '<button class="btn">編輯</button><button class="btn">補貨</button>' +
                    '</div>'
                ).join('');
            });
        </script>
    </body>
    </html>
    `);
});

app.get('/api/products', (req, res) => {
    res.json([
        {name: '液化石油氣', size: '5kg', price: 280, stock: 150, supplier: '中油公司'},
        {name: '液化石油氣', size: '15kg', price: 680, stock: 85, supplier: '中油公司'},
        {name: '工業用瓦斯', size: '50kg', price: 1850, stock: 12, supplier: '台塑石化'},
        {name: '家用瓦斯', size: '20kg', price: 850, stock: 45, supplier: '台塑石化'}
    ]);
});

app.listen(PORT, '0.0.0.0', () => {
    console.log('🔥 瓦斯管理系統已啟動成功！');
    console.log('📍 本地訪問: http://localhost:' + PORT);
    console.log('🌐 外部訪問: http://YOUR_SERVER_IP:' + PORT);
    console.log('⏰ 啟動時間: ' + new Date().toLocaleString('zh-TW'));
    console.log('🎯 使用 Ctrl+C 停止服務');
});
EOF

echo "✅ 启动文件已创建"
echo "🚀 正在启动瓦斯管理系统..."

node simple-gas-app.js
