#!/bin/bash

echo "🤖 配置 Ollama AI 模型 - Jy技術團隊 瓦斯行管理系統 2025"
echo "=================================================="

# 检查 Docker 容器状态
echo "📋 检查 Ollama 容器状态..."
if ! docker ps | grep ollama > /dev/null; then
    echo "❌ Ollama 容器未运行"
    echo "启动容器: docker start ollama"
    exit 1
else
    echo "✅ Ollama 容器正在运行"
fi

# 检查系统内存
TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.1f", $2/1024}')
echo "💾 系统内存: ${TOTAL_MEM}GB"

# 根据内存推荐模型
if (( $(echo "$TOTAL_MEM < 3.0" | bc -l 2>/dev/null || echo "1") )); then
    RECOMMENDED_MODEL="gemma:2b"
    echo "🎯 推荐模型: $RECOMMENDED_MODEL (轻量级，适合当前内存)"
else
    RECOMMENDED_MODEL="qwen2:1.5b"
    echo "🎯 推荐模型: $RECOMMENDED_MODEL (中等性能)"
fi

# 检查 API 连接
echo "🌐 测试 Ollama API 连接..."
if curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "✅ API 连接正常"
else
    echo "❌ API 连接失败，请检查容器状态"
    exit 1
fi

# 下载推荐模型
echo ""
echo "📥 开始下载模型: $RECOMMENDED_MODEL"
echo "⏳ 这可能需要几分钟时间，请耐心等待..."

if docker exec ollama ollama pull "$RECOMMENDED_MODEL"; then
    echo "✅ 模型下载成功！"
else
    echo "❌ 模型下载失败，请检查网络连接"
    exit 1
fi

# 验证模型安装
echo ""
echo "📋 验证模型安装..."
docker exec ollama ollama list

# 测试模型功能
echo ""
echo "🧪 测试模型功能..."
TEST_RESPONSE=$(curl -s -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"$RECOMMENDED_MODEL\",
    \"prompt\": \"你好，请简单介绍一下自己\",
    \"stream\": false
  }" | jq -r '.response' 2>/dev/null)

if [ -n "$TEST_RESPONSE" ] && [ "$TEST_RESPONSE" != "null" ]; then
    echo "✅ 模型功能测试成功"
    echo "🤖 AI 回复: $TEST_RESPONSE"
else
    echo "⚠️  模型功能测试失败，但模型已安装"
fi

# 更新应用配置
echo ""
echo "⚙️  更新应用配置..."
CONFIG_FILE=".env"

# 创建或更新 .env 文件
cat > $CONFIG_FILE << EOF
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=$RECOMMENDED_MODEL
APP_PORT=3000
DISPLAY=:99
LOG_LEVEL=info
COMPANY_NAME=Jy技術團隊
APP_YEAR=2025
EOF

echo "✅ 配置文件已更新"

# 显示完成信息
echo ""
echo "🎉 AI 模型配置完成！"
echo "=================================================="
echo "✅ 模型名称: $RECOMMENDED_MODEL"
echo "✅ API 地址: http://localhost:11434"
echo "✅ 配置文件: $CONFIG_FILE"
echo ""
echo "🛠️  常用命令:"
echo "查看模型: docker exec ollama ollama list"
echo "运行模型: docker exec -it ollama ollama run $RECOMMENDED_MODEL"
echo "API 测试: curl http://localhost:11434/api/tags"
echo ""
echo "🚀 现在可以启动应用了:"
echo "npm install --production"
echo "npm start"
echo ""
echo "📞 技术支持: Jy技術團隊 2025"
