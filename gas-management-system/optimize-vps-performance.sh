#!/bin/bash

echo "🔧 Jy技術團隊 瓦斯行管理系統 2025 - Linux VPS 性能优化"
echo "================================================================"

# 检查系统资源
echo "📊 当前系统资源使用情况:"
echo "CPU: $(nproc) 核心"
echo "内存: $(free -h | grep Mem | awk '{print $3"/"$2}')"
echo "负载: $(uptime | awk -F'load average:' '{print $2}')"

# 检查 Docker 资源使用
echo ""
echo "🐳 Docker 容器资源使用:"
docker stats --no-stream

# 检查当前 AI 模型
echo ""
echo "🤖 当前 AI 模型:"
docker exec ollama ollama list 2>/dev/null || echo "无法获取模型列表"

# 获取系统内存
TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.1f", $2/1024}')
AVAILABLE_MEM=$(free -m | awk 'NR==2{printf "%.1f", $7/1024}')

echo ""
echo "💾 内存分析:"
echo "总内存: ${TOTAL_MEM}GB"
echo "可用内存: ${AVAILABLE_MEM}GB"

# 性能优化建议
echo ""
echo "🔧 性能优化建议:"

if (( $(echo "$AVAILABLE_MEM < 1.0" | bc -l 2>/dev/null || echo "1") )); then
    echo "❗ 内存严重不足，建议："
    echo "1. 使用最轻量级模型 phi3:mini"
    echo "2. 限制 Docker 内存使用"
    echo "3. 清理不必要的进程"
    RECOMMENDED_MODEL="phi3:mini"
    OPTIMIZE_MEMORY=true
elif (( $(echo "$AVAILABLE_MEM < 2.0" | bc -l 2>/dev/null || echo "0") )); then
    echo "⚠️  内存偏低，建议："
    echo "1. 使用轻量级模型 gemma:2b"
    echo "2. 优化系统参数"
    RECOMMENDED_MODEL="gemma:2b"
    OPTIMIZE_MEMORY=true
else
    echo "✅ 内存充足，可以使用标准配置"
    RECOMMENDED_MODEL="gemma:2b"
    OPTIMIZE_MEMORY=false
fi

# 执行优化
echo ""
read -p "是否执行性能优化？(y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 开始性能优化..."
    
    # 1. 优化系统参数
    echo "⚙️ 优化系统参数..."
    sysctl -w vm.swappiness=10
    sysctl -w vm.dirty_ratio=15
    sysctl -w vm.dirty_background_ratio=5
    
    # 2. 清理内存缓存
    echo "🧹 清理系统缓存..."
    sync && echo 3 > /proc/sys/vm/drop_caches
    
    # 3. 优化 Docker 配置
    echo "🐳 优化 Docker 配置..."
    
    # 限制 Ollama 容器内存
    if [ "$OPTIMIZE_MEMORY" = true ]; then
        echo "📉 限制 Ollama 容器内存使用..."
        docker update --memory="1.5g" --memory-swap="2g" ollama
    fi
    
    # 4. 切换到更轻量的模型
    if [ "$RECOMMENDED_MODEL" != "$(docker exec ollama ollama list 2>/dev/null | grep -E '^(deepseek|gemma|phi3|qwen)' | head -1 | awk '{print $1}')" ]; then
        echo "🤖 切换到更轻量的 AI 模型..."
        
        # 删除大模型
        docker exec ollama ollama rm deepseek-r1:8b 2>/dev/null || true
        docker exec ollama ollama rm qwen2:1.5b 2>/dev/null || true
        
        # 下载轻量模型
        if ! docker exec ollama ollama list | grep -q "$RECOMMENDED_MODEL"; then
            echo "📥 下载轻量级模型: $RECOMMENDED_MODEL"
            docker exec ollama ollama pull "$RECOMMENDED_MODEL"
        fi
        
        # 更新配置
        if [ -f ".env" ]; then
            sed -i "s/DEFAULT_AI_MODEL=.*/DEFAULT_AI_MODEL=$RECOMMENDED_MODEL/" .env
        fi
    fi
    
    # 5. 优化应用配置
    echo "📱 优化应用配置..."
    
    # 创建优化的环境配置
    cat > .env << EOF
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=$RECOMMENDED_MODEL
APP_PORT=3000
DISPLAY=:99
LOG_LEVEL=warn
MAX_MEMORY=256M
NODE_OPTIONS=--max-old-space-size=256
EOF
    
    # 6. 创建监控脚本
    echo "📊 创建性能监控脚本..."
    cat > performance-monitor.sh << 'EOF'
#!/bin/bash

while true; do
    clear
    echo "🔍 Jy技術團隊 瓦斯行管理系統 - 性能监控"
    echo "========================================"
    echo "时间: $(date)"
    echo ""
    
    echo "💾 内存使用:"
    free -h
    echo ""
    
    echo "🔥 CPU 使用:"
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "CPU 使用率: " 100 - $1 "%"}'
    echo ""
    
    echo "🐳 Docker 容器:"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"
    echo ""
    
    echo "📱 应用进程:"
    ps aux | grep -E "(node|npm)" | grep -v grep | head -3
    echo ""
    
    echo "按 Ctrl+C 退出监控"
    sleep 5
done
EOF
    
    chmod +x performance-monitor.sh
    
    # 7. 重启服务
    echo "🔄 重启相关服务..."
    systemctl restart gas-management 2>/dev/null || echo "服务重启可能需要手动执行"
    
    echo ""
    echo "✅ 性能优化完成！"
    echo "================="
    echo "✅ 系统参数已优化"
    echo "✅ 内存缓存已清理"
    echo "✅ Docker 配置已优化"
    echo "✅ AI 模型已切换到: $RECOMMENDED_MODEL"
    echo "✅ 应用配置已优化"
    echo ""
    echo "🛠️ 监控命令:"
    echo "./performance-monitor.sh  # 实时性能监控"
    echo "htop                      # 系统资源监控"
    echo "docker stats              # Docker 资源监控"
    
else
    echo "💡 您可以稍后手动执行优化"
fi

# 显示优化建议
echo ""
echo "💡 额外优化建议："
echo ""
echo "1. 🧹 定期清理："
echo "   sudo apt autoremove && sudo apt autoclean"
echo ""
echo "2. 🔧 系统调优："
echo "   echo 'vm.swappiness=10' >> /etc/sysctl.conf"
echo ""
echo "3. 📊 监控工具："
echo "   sudo apt install htop iotop nethogs"
echo ""
echo "4. 🐳 Docker 清理："
echo "   docker system prune -f"
echo ""
echo "5. 📝 日志清理："
echo "   journalctl --vacuum-time=7d"
echo ""
echo "6. 🚀 如果还是很卡，建议："
echo "   - 升级 VPS 配置（增加内存）"
echo "   - 使用 SSD 存储"
echo "   - 选择更近的数据中心"
