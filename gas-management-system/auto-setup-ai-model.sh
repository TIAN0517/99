#!/bin/bash

echo "🤖 Jy技術團隊 瓦斯行管理系統 2025 - AI 模型自动选择"
echo "=================================================="

# 检查是否在 Docker 容器环境中
if ! docker ps | grep ollama > /dev/null; then
    echo "❌ Ollama 容器未运行，请先启动 Ollama 服务"
    echo "启动命令: docker start ollama"
    exit 1
fi

# 获取系统内存信息
echo "📊 检查系统资源..."
TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.1f", $2/1024}')
AVAILABLE_MEM=$(free -m | awk 'NR==2{printf "%.1f", $7/1024}')

echo "总内存: ${TOTAL_MEM}GB"
echo "可用内存: ${AVAILABLE_MEM}GB"

# 根据内存选择最佳模型
echo ""
echo "🧠 AI 模型推荐:"
if (( $(echo "$TOTAL_MEM < 1.5" | bc -l 2>/dev/null || echo "1") )); then
    MODEL="phi3:mini"
    MEMORY_NEED="1.8GB"
    DESCRIPTION="超轻量级模型，适合极低内存环境"
    FEATURES="基础中文对话、简单问答"
elif (( $(echo "$TOTAL_MEM < 3.5" | bc -l 2>/dev/null || echo "0") )); then
    MODEL="gemma:2b"
    MEMORY_NEED="2.5GB"
    DESCRIPTION="轻量级模型，性价比最高"
    FEATURES="流畅中文对话、业务咨询、数据查询"
elif (( $(echo "$TOTAL_MEM < 6.0" | bc -l 2>/dev/null || echo "0") )); then
    MODEL="qwen2:1.5b"
    MEMORY_NEED="3.5GB"
    DESCRIPTION="中等性能模型，中文优化"
    FEATURES="专业对话、复杂查询、业务分析"
else
    MODEL="deepseek-r1:8b"
    MEMORY_NEED="6.6GB"
    DESCRIPTION="高性能模型，推理能力强"
    FEATURES="高级推理、代码生成、复杂业务分析"
fi

echo "推荐模型: $MODEL"
echo "内存需求: $MEMORY_NEED"
echo "模型特点: $DESCRIPTION"
echo "主要功能: $FEATURES"

# 检查是否有足够内存
if (( $(echo "$AVAILABLE_MEM < 1.0" | bc -l 2>/dev/null || echo "1") )); then
    echo ""
    echo "⚠️  警告: 可用内存不足，建议释放内存或重启系统"
fi

echo ""
read -p "是否立即下载并安装推荐的模型 $MODEL？(y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📥 开始下载模型: $MODEL"
    echo "这可能需要几分钟时间，请耐心等待..."
    
    # 检查模型是否已存在
    if docker exec ollama ollama list | grep -q "$MODEL"; then
        echo "✅ 模型 $MODEL 已存在"
    else
        # 下载模型
        echo "⏬ 正在下载模型..."
        if docker exec ollama ollama pull "$MODEL"; then
            echo "✅ 模型下载成功！"
        else
            echo "❌ 模型下载失败，请检查网络连接或重试"
            exit 1
        fi
    fi
    
    # 更新配置文件
    echo "⚙️  更新应用配置..."
    CONFIG_FILE="/opt/gas-management-system/.env"
    
    if [ -f "$CONFIG_FILE" ]; then
        # 更新现有配置
        if grep -q "DEFAULT_AI_MODEL" "$CONFIG_FILE"; then
            sed -i "s/DEFAULT_AI_MODEL=.*/DEFAULT_AI_MODEL=$MODEL/" "$CONFIG_FILE"
        else
            echo "DEFAULT_AI_MODEL=$MODEL" >> "$CONFIG_FILE"
        fi
        echo "✅ 配置文件已更新"
    else
        # 创建新配置文件
        cat > "$CONFIG_FILE" << EOF
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=$MODEL
APP_PORT=3000
DISPLAY=:99
EOF
        echo "✅ 配置文件已创建"
    fi
    
    # 重启应用服务
    echo "🔄 重启应用服务..."
    if systemctl is-active --quiet gas-management; then
        systemctl restart gas-management
        echo "✅ 服务已重启"
    else
        echo "💡 请手动启动服务: systemctl start gas-management"
    fi
    
    echo ""
    echo "🎉 AI 模型配置完成！"
    echo "=================================================="
    echo "当前使用模型: $MODEL"
    echo "内存占用: $MEMORY_NEED"
    echo "功能特点: $FEATURES"
    echo ""
    echo "🌐 现在可以访问应用并使用 AI 助理功能了！"
    
else
    echo ""
    echo "💡 您可以稍后手动下载模型:"
    echo "   docker exec ollama ollama pull $MODEL"
    echo ""
    echo "🔧 其他可选模型:"
    echo "   超轻量: docker exec ollama ollama pull phi3:mini"
    echo "   轻量级: docker exec ollama ollama pull gemma:2b"
    echo "   中等级: docker exec ollama ollama pull qwen2:1.5b"
    echo "   高性能: docker exec ollama ollama pull deepseek-r1:8b"
fi

# 显示当前已安装的模型
echo ""
echo "📋 当前已安装的模型:"
docker exec ollama ollama list 2>/dev/null || echo "无法获取模型列表"

echo ""
echo "✨ 感谢使用 Jy技術團隊 瓦斯行管理系統 2025！"
