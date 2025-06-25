const express = require('express');
const path = require('path');
const { spawn } = require('child_process');

// 创建4D科技感瓦斯管理系统 - 无边框版本
class GasManagement4DSystem {
    constructor() {
        this.app = express();
        this.port = process.env.PORT || 3000;
        this.isAIEnabled = false;
        this.currentModel = 'llama3:8b-instruct-q4_0';
        this.setupServer();
        this.checkAIConnection();
    }

    setupServer() {
        // 设置静态文件服务
        this.app.use(express.static(path.join(__dirname, 'public')));
        this.app.use(express.json());

        // 设置路由
        this.setupRoutes();
    }

    setupRoutes() {
        // 主页路由
        this.app.get('/', (req, res) => {
            res.send(this.generateHTML());
        });

        // API路由
        this.app.get('/api/stats', (req, res) => {
            res.json(this.getStats());
        });

        this.app.post('/api/ai/chat', async (req, res) => {
            const { message } = req.body;
            try {
                const response = await this.queryAI(message);
                res.json({ success: true, response });
            } catch (error) {
                res.json({
                    success: false,
                    response: this.getFallbackResponse(message),
                    error: error.message
                });
            }
        });

        this.app.get('/api/ai/status', (req, res) => {
            res.json({
                isEnabled: this.isAIEnabled,
                model: this.currentModel,
                status: this.isAIEnabled ? 'online' : 'offline'
            });
        });
    }

    async checkAIConnection() {
        try {
            const response = await fetch('http://localhost:11434/api/tags');
            if (response.ok) {
                const data = await response.json();
                const models = data.models || [];

                // 检查是否有llama3模型
                const llama3Model = models.find(m => m.name.includes('llama3'));
                if (llama3Model) {
                    this.currentModel = llama3Model.name;
                    this.isAIEnabled = true;
                    console.log(`🤖 AI助理已连接: ${this.currentModel}`);
                } else if (models.length > 0) {
                    this.currentModel = models[0].name;
                    this.isAIEnabled = true;
                    console.log(`🤖 AI助理已连接: ${this.currentModel}`);
                }
            }
        } catch (error) {
            console.log('❌ AI助理暂时不可用，使用模拟响应');
            this.isAIEnabled = false;
        }
    }

    async queryAI(message) {
        if (!this.isAIEnabled) {
            throw new Error('AI service not available');
        }

        const prompt = this.buildPrompt(message);

        const response = await fetch('http://localhost:11434/api/generate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                model: this.currentModel,
                prompt: prompt,
                stream: false,
                options: {
                    temperature: 0.7,
                    top_p: 0.9,
                    max_tokens: 300,
                    num_ctx: 1024,
                }
            }),
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        return data.response || '抱歉，我暂时无法回答这个问题。';
    }

    buildPrompt(message) {
        return `你是"董娘的AI助理"，專門為瓦斯行業務設計的智能助手。你具備以下專業知識：

業務範圍：
- 液化石油氣(LPG)銷售與配送
- 瓦斯設備安裝與維護
- 客戶服務與訂單管理
- 庫存管理與成本控制
- 安全規範與法規遵循

回答風格：
- 使用繁體中文
- 語氣親切專業
- 提供實用的建議
- 關注安全與效率

用戶問題：${message}

董娘的AI助理回覆：`;
    }

    getFallbackResponse(message) {
        const responses = [
            '董娘的助理暂时離線中，請稍後再試。如需緊急幫助，請聯絡 Jy技術團隊。',
            '系統正在更新中，AI 助理暫時不可用。請查看幫助文檔或聯絡技術支援。',
            '抱歉，AI 服務臨時中斷。您可以繼續使用系統的其他功能。',
            '董娘的助理正在休息，請稍後再來諮詢。系統其他功能正常運行。'
        ];

        if (message.includes('價格') || message.includes('費用')) {
            return '價格查詢功能暫時不可用，請查看價格管理頁面或聯絡客服。';
        } else if (message.includes('訂單') || message.includes('配送')) {
            return '訂單查詢功能暫時不可用，請在訂單管理頁面查看詳情。';
        } else if (message.includes('庫存') || message.includes('商品')) {
            return '庫存查詢功能暫時不可用，請在產品管理頁面查看詳情。';
        }

        return responses[Math.floor(Math.random() * responses.length)];
    }

    getStats() {
        return {
            totalProducts: 156 + Math.floor(Math.random() * 10),
            totalOrders: 423 + Math.floor(Math.random() * 20),
            totalCustomers: 89 + Math.floor(Math.random() * 5),
            totalRevenue: 1250000 + Math.floor(Math.random() * 100000),
            pendingOrders: 12 + Math.floor(Math.random() * 5),
            lowStockItems: 5 + Math.floor(Math.random() * 3),
            aiStatus: this.isAIEnabled,
            currentModel: this.currentModel
        };
    }

    generateHTML() {
        return `
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jy技術團隊 - 4D科技感瓦斯管理系統</title>
    <style>
        /* 4D科技感无边框样式 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-blue: #00d4ff;
            --secondary-purple: #8a2be2;
            --gradient-primary: linear-gradient(135deg, #00d4ff 0%, #8a2be2 100%);
            --bg-primary: linear-gradient(135deg, rgba(0, 0, 0, 0.95) 0%, rgba(20, 30, 48, 0.98) 30%, rgba(40, 60, 100, 0.92) 100%);
            --bg-glass: linear-gradient(135deg, rgba(255, 255, 255, 0.15) 0%, rgba(255, 255, 255, 0.05) 100%);
            --text-primary: #ffffff;
            --text-secondary: rgba(255, 255, 255, 0.8);
        }

        html, body {
            height: 100%;
            font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            overflow: hidden;
        }

        .app-container {
            width: 100vw;
            height: 100vh;
            display: flex;
            flex-direction: column;
            position: relative;
            overflow: hidden;
        }

        /* 3D背景效果 */
        .app-container::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 20%, rgba(0, 212, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(138, 43, 226, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 40% 70%, rgba(255, 107, 53, 0.05) 0%, transparent 50%);
            pointer-events: none;
            z-index: -1;
            animation: float-bg 8s ease-in-out infinite;
        }

        /* 动态网格 */
        .app-container::after {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                linear-gradient(rgba(0, 212, 255, 0.03) 1px, transparent 1px),
                linear-gradient(90deg, rgba(0, 212, 255, 0.03) 1px, transparent 1px);
            background-size: 50px 50px;
            pointer-events: none;
            z-index: -1;
            animation: pulse-grid 4s ease-in-out infinite;
        }

        .header {
            padding: 32px 40px;
            background: var(--bg-glass);
            border-bottom: 2px solid rgba(0, 212, 255, 0.2);
            backdrop-filter: blur(25px);
            text-align: center;
            position: relative;
        }

        .header::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 2px;
            background: var(--gradient-primary);
            animation: glow-line 3s ease-in-out infinite;
        }

        .header h1 {
            font-size: 4rem;
            font-weight: 800;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 12px;
            animation: text-glow 4s ease-in-out infinite;
            text-shadow: 0 0 40px rgba(0, 212, 255, 0.6);
        }

        .header p {
            color: var(--text-secondary);
            font-size: 18px;
            font-weight: 500;
        }

        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 32px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
        }

        .stat-card {
            background: var(--bg-glass);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 32px;
            backdrop-filter: blur(25px);
            transition: all 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-8px) rotateX(5deg) rotateY(5deg);
            border-color: var(--primary-blue);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4), 0 0 50px rgba(0, 212, 255, 0.4);
        }

        .stat-card .icon {
            font-size: 48px;
            margin-bottom: 16px;
            display: block;
        }

        .stat-card .title {
            font-size: 16px;
            color: var(--text-secondary);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-card .value {
            font-size: 32px;
            font-weight: 700;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }

        .ai-chat {
            background: var(--bg-glass);
            border: 2px solid rgba(0, 212, 255, 0.3);
            border-radius: 20px;
            padding: 32px;
            backdrop-filter: blur(25px);
        }

        .ai-chat h3 {
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 20px;
            font-size: 24px;
        }

        .chat-input {
            width: 100%;
            padding: 16px 20px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: var(--text-primary);
            font-size: 16px;
            margin-bottom: 16px;
            backdrop-filter: blur(10px);
        }

        .chat-input:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 20px rgba(0, 212, 255, 0.3);
        }

        .chat-btn {
            padding: 16px 28px;
            background: var(--gradient-primary);
            border: none;
            border-radius: 12px;
            color: white;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .chat-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 40px rgba(0, 212, 255, 0.4);
        }

        .chat-response {
            margin-top: 20px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            border-left: 4px solid var(--primary-blue);
            display: none;
        }

        .system-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-top: 20px;
        }

        .status-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
        }

        .status-indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #00ff88;
            box-shadow: 0 0 10px rgba(0, 255, 136, 0.5);
            animation: pulse-dot 2s infinite;
        }

        .status-indicator.warning {
            background: #ffaa00;
            box-shadow: 0 0 10px rgba(255, 170, 0, 0.5);
        }

        .status-indicator.offline {
            background: #ff416c;
            box-shadow: 0 0 10px rgba(255, 65, 108, 0.5);
        }

        /* 动画 */
        @keyframes float-bg {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        @keyframes pulse-grid {
            0%, 100% { opacity: 0.3; }
            50% { opacity: 0.1; }
        }

        @keyframes glow-line {
            0%, 100% { box-shadow: 0 0 20px rgba(0, 212, 255, 0.8); }
            50% { box-shadow: 0 0 40px rgba(138, 43, 226, 0.8); }
        }

        @keyframes text-glow {
            0%, 100% { filter: drop-shadow(0 0 20px rgba(0, 212, 255, 0.8)); }
            50% { filter: drop-shadow(0 0 40px rgba(138, 43, 226, 0.8)); }
        }

        @keyframes pulse-dot {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.7; transform: scale(1.2); }
        }

        /* 滚动条 */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb {
            background: var(--gradient-primary);
            border-radius: 4px;
            box-shadow: 0 0 15px rgba(0, 212, 255, 0.5);
        }

        /* 响应式 */
        @media (max-width: 768px) {
            .header h1 { font-size: 2.5rem; }
            .main-content { padding: 20px; }
            .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="app-container">
        <div class="header">
            <h1>🏢 Jy技術團隊</h1>
            <p>4D科技感瓦斯管理系統 Enhanced Beautiful Edition v2.1</p>
        </div>

        <div class="main-content">
            <div class="stats-grid" id="statsGrid">
                <!-- 动态加载统计数据 -->
            </div>

            <div class="ai-chat">
                <h3>🤖 董娘的AI助理 (Llama3 8B)</h3>
                <input type="text" class="chat-input" id="chatInput" placeholder="请输入您的问题...">
                <button class="chat-btn" onclick="sendMessage()">💬 发送消息</button>
                <div class="chat-response" id="chatResponse"></div>
                
                <div class="system-info">
                    <div class="status-item">
                        <div class="status-indicator" id="aiStatus"></div>
                        <span id="aiStatusText">AI助理状态</span>
                    </div>
                    <div class="status-item">
                        <div class="status-indicator"></div>
                        <span>系统运行正常</span>
                    </div>
                    <div class="status-item">
                        <div class="status-indicator warning"></div>
                        <span>备份系统</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let stats = {};
        let aiStatus = false;

        // 加载统计数据
        async function loadStats() {
            try {
                const response = await fetch('/api/stats');
                stats = await response.json();
                updateStatsDisplay();
                updateAIStatus();
            } catch (error) {
                console.error('Failed to load stats:', error);
            }
        }

        // 更新统计显示
        function updateStatsDisplay() {
            const statsGrid = document.getElementById('statsGrid');
            statsGrid.innerHTML = \`
                <div class="stat-card">
                    <div class="icon">📊</div>
                    <div class="title">總產品數量</div>
                    <div class="value">\${stats.totalProducts}</div>
                </div>
                <div class="stat-card">
                    <div class="icon">📦</div>
                    <div class="title">總訂單數</div>
                    <div class="value">\${stats.totalOrders}</div>
                </div>
                <div class="stat-card">
                    <div class="icon">👥</div>
                    <div class="title">總客戶數</div>
                    <div class="value">\${stats.totalCustomers}</div>
                </div>
                <div class="stat-card">
                    <div class="icon">💰</div>
                    <div class="title">總營收</div>
                    <div class="value">NT$ \${stats.totalRevenue.toLocaleString()}</div>
                </div>
                <div class="stat-card">
                    <div class="icon">⏳</div>
                    <div class="title">待處理訂單</div>
                    <div class="value">\${stats.pendingOrders}</div>
                </div>
                <div class="stat-card">
                    <div class="icon">📉</div>
                    <div class="title">低庫存商品</div>
                    <div class="value">\${stats.lowStockItems}</div>
                </div>
            \`;
        }

        // 更新AI状态
        function updateAIStatus() {
            const aiStatusEl = document.getElementById('aiStatus');
            const aiStatusTextEl = document.getElementById('aiStatusText');
            
            if (stats.aiStatus) {
                aiStatusEl.className = 'status-indicator';
                aiStatusTextEl.textContent = \`AI助理在線 (\${stats.currentModel})\`;
                aiStatus = true;
            } else {
                aiStatusEl.className = 'status-indicator offline';
                aiStatusTextEl.textContent = 'AI助理離線';
                aiStatus = false;
            }
        }

        // 发送消息到AI
        async function sendMessage() {
            const input = document.getElementById('chatInput');
            const response = document.getElementById('chatResponse');
            const message = input.value.trim();
            
            if (!message) return;

            try {
                response.style.display = 'block';
                response.innerHTML = '🤖 正在思考中...';
                
                const res = await fetch('/api/ai/chat', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ message }),
                });
                
                const data = await res.json();
                response.innerHTML = \`🤖 董娘的助理: \${data.response}\`;
                input.value = '';
            } catch (error) {
                response.innerHTML = '❌ 抱歉，AI助理暂时不可用。请稍后再试。';
            }
        }

        // 监听回车键
        document.getElementById('chatInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });

        // 定期刷新数据
        setInterval(loadStats, 30000);
        
        // 初始加载
        loadStats();
    </script>
</body>
</html>
        `;
    }

    start() {
        this.app.listen(this.port, () => {
            console.log(`
🚀 Jy技術團隊 4D科技感瓦斯管理系統已启动！
================================================
🌐 访问地址: http://localhost:${this.port}
🤖 AI模型: ${this.currentModel}
📊 状态: ${this.isAIEnabled ? '✅ AI已连接' : '❌ AI离线'}
================================================
            `);
        });
    }
}

// 启动应用
const app = new GasManagement4DSystem();
app.start();
