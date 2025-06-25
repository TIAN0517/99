#!/bin/bash

echo "🚀 启动4D科技感瓦斯管理系统"
echo "================================================"

# 检查Node.js是否已安装
if ! command -v node &> /dev/null; then
    echo "❌ 未检测到Node.js，请先安装Node.js"
    exit 1
fi

# 检查Ollama是否正在运行
echo "🤖 检查AI服务状态..."
if curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "✅ Ollama AI服务已连接"
    
    # 检查是否有llama3模型
    MODELS=$(curl -s http://localhost:11434/api/tags | grep -o '"name":"[^"]*' | cut -d'"' -f4)
    if echo "$MODELS" | grep -q "llama3"; then
        echo "✅ 检测到Llama3模型"
    else
        echo "⚠️  未检测到Llama3模型，尝试下载..."
        echo "📥 下载llama3:8b-instruct-q4_0模型..."
        ollama pull llama3:8b-instruct-q4_0
        
        if [ $? -eq 0 ]; then
            echo "✅ Llama3模型下载成功"
        else
            echo "❌ Llama3模型下载失败，将使用其他可用模型"
        fi
    fi
else
    echo "⚠️  Ollama服务未连接，AI助理将使用模拟响应"
    echo "💡 提示：要启用AI功能，请先安装并启动Ollama"
    echo "   安装: curl -fsSL https://ollama.ai/install.sh | sh"
    echo "   启动: ollama serve"
fi

# 安装依赖
echo "📦 检查并安装依赖..."
if [ ! -d "node_modules" ]; then
    npm install express
fi

# 启动系统
echo "🌟 启动4D科技感瓦斯管理系统..."
echo "================================================"

node gas-4d-ultimate.js
