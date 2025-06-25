#!/bin/bash

echo "🔍 Jy技術團隊 瓦斯行管理系統 - AI 连接问题诊断"
echo "================================================="

# 检查 Ollama 容器状态
echo "🐳 检查 Ollama 容器状态..."
if docker ps | grep ollama > /dev/null; then
    echo "✅ Ollama 容器正在运行"
    CONTAINER_STATUS=$(docker ps --format "table {{.Names}}\t{{.Status}}" | grep ollama)
    echo "   $CONTAINER_STATUS"
else
    echo "❌ Ollama 容器未运行"
    echo "🔧 尝试启动容器..."
    if docker ps -a | grep ollama > /dev/null; then
        docker start ollama
        echo "⏳ 等待容器启动..."
        sleep 15
    else
        echo "❌ 未找到 Ollama 容器，需要重新创建"
        exit 1
    fi
fi

# 检查 API 连接
echo ""
echo "🌐 检查 Ollama API 连接..."
if curl -s --max-time 10 http://localhost:11434/api/tags > /dev/null; then
    echo "✅ API 连接正常"
    
    # 获取 API 响应
    API_RESPONSE=$(curl -s http://localhost:11434/api/tags)
    echo "📋 API 响应: $API_RESPONSE"
else
    echo "❌ API 连接失败"
    echo "🔧 检查端口是否监听..."
    netstat -tulpn | grep :11434 || ss -tulpn | grep :11434
    
    echo "🔧 检查容器日志..."
    docker logs ollama --tail 10
    exit 1
fi

# 检查已安装的模型
echo ""
echo "🤖 检查已安装的 AI 模型..."
MODEL_LIST=$(docker exec ollama ollama list 2>/dev/null)
if [ $? -eq 0 ] && [ -n "$MODEL_LIST" ]; then
    echo "✅ 模型列表:"
    echo "$MODEL_LIST"
    
    # 检查是否有可用模型
    MODEL_COUNT=$(echo "$MODEL_LIST" | grep -v "NAME" | wc -l)
    if [ $MODEL_COUNT -eq 0 ]; then
        echo "⚠️  没有安装任何模型"
        NEED_MODEL=true
    else
        echo "✅ 找到 $MODEL_COUNT 个模型"
        NEED_MODEL=false
    fi
else
    echo "❌ 无法获取模型列表"
    NEED_MODEL=true
fi

# 测试模型功能
if [ "$NEED_MODEL" = false ]; then
    echo ""
    echo "🧪 测试 AI 模型功能..."
    
    # 获取第一个可用模型
    FIRST_MODEL=$(docker exec ollama ollama list 2>/dev/null | grep -v "NAME" | head -1 | awk '{print $1}')
    
    if [ -n "$FIRST_MODEL" ]; then
        echo "🎯 测试模型: $FIRST_MODEL"
        
        # 测试生成功能
        TEST_RESPONSE=$(curl -s --max-time 30 -X POST http://localhost:11434/api/generate \
            -H "Content-Type: application/json" \
            -d "{
                \"model\": \"$FIRST_MODEL\",
                \"prompt\": \"Hello\",
                \"stream\": false,
                \"options\": {\"max_tokens\": 10}
            }" 2>/dev/null)
        
        if [ $? -eq 0 ] && echo "$TEST_RESPONSE" | grep -q "response"; then
            echo "✅ 模型功能测试成功"
            RESPONSE_TEXT=$(echo "$TEST_RESPONSE" | jq -r '.response' 2>/dev/null || echo "获取响应失败")
            echo "🤖 AI 回复: $RESPONSE_TEXT"
        else
            echo "❌ 模型功能测试失败"
            echo "📝 错误响应: $TEST_RESPONSE"
        fi
    fi
fi

# 检查应用配置
echo ""
echo "⚙️ 检查应用配置..."
if [ -f ".env" ]; then
    echo "✅ 找到配置文件 .env"
    echo "📋 当前配置:"
    grep -E "(OLLAMA_BASE_URL|DEFAULT_AI_MODEL)" .env || echo "⚠️  缺少必要配置"
else
    echo "❌ 未找到配置文件 .env"
    echo "🔧 创建默认配置..."
    cat > .env << EOF
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=gemma:2b
APP_PORT=3000
DISPLAY=:99
EOF
    echo "✅ 配置文件已创建"
fi

# 解决方案建议
echo ""
echo "🛠️ 解决方案建议:"

if [ "$NEED_MODEL" = true ]; then
    echo ""
    echo "❗ 问题: 没有安装 AI 模型"
    echo "🔧 解决方案:"
    echo "1. 安装轻量级模型:"
    echo "   docker exec ollama ollama pull gemma:2b"
    echo ""
    echo "2. 或者安装超轻量模型:"
    echo "   docker exec ollama ollama pull phi3:mini"
    echo ""
fi

echo "🔧 通用解决步骤:"
echo ""
echo "1. 重启 Ollama 容器:"
echo "   docker restart ollama"
echo "   sleep 20"
echo ""
echo "2. 确保模型已下载:"
echo "   docker exec ollama ollama pull gemma:2b"
echo ""
echo "3. 测试 API 连接:"
echo "   curl http://localhost:11434/api/tags"
echo ""
echo "4. 重启应用:"
echo "   systemctl restart gas-management"
echo ""
echo "5. 查看应用日志:"
echo "   journalctl -u gas-management -f"

# 自动修复选项
echo ""
read -p "是否自动执行修复？(y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔧 开始自动修复..."
    
    # 重启容器
    echo "1. 重启 Ollama 容器..."
    docker restart ollama
    sleep 20
    
    # 安装模型
    if [ "$NEED_MODEL" = true ]; then
        echo "2. 安装 AI 模型..."
        docker exec ollama ollama pull gemma:2b
    fi
    
    # 更新配置
    echo "3. 更新配置文件..."
    cat > .env << EOF
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=gemma:2b
APP_PORT=3000
DISPLAY=:99
LOG_LEVEL=info
EOF
    
    # 测试连接
    echo "4. 测试连接..."
    sleep 10
    if curl -s http://localhost:11434/api/tags > /dev/null; then
        echo "✅ 修复成功！API 连接正常"
        
        # 重启应用
        echo "5. 重启应用..."
        systemctl restart gas-management 2>/dev/null || echo "请手动重启应用"
        
        echo ""
        echo "🎉 AI 服务修复完成！"
        echo "现在可以在应用中测试 AI 助理功能了。"
    else
        echo "❌ 修复失败，请检查 Docker 服务状态"
    fi
else
    echo "💡 请手动执行上述修复步骤"
fi

echo ""
echo "📞 如需技术支持，请联系 Jy技術團隊"
