#!/bin/bash

echo "⚡ 瓦斯管理系统性能优化 - 快速版"
echo "================================="

# 检查当前状态
echo "📊 检查当前资源使用..."
free -h
echo ""

# 优化 AI 模型
echo "🤖 优化 AI 模型..."
docker exec ollama ollama pull phi3:mini
docker exec ollama ollama rm deepseek-r1:8b 2>/dev/null || true
docker exec ollama ollama rm qwen2:1.5b 2>/dev/null || true

# 限制 Docker 内存
echo "🐳 限制 Docker 内存使用..."
docker update --memory="1g" --memory-swap="1.5g" ollama

# 清理内存
echo "🧹 清理系统内存..."
sync && echo 3 > /proc/sys/vm/drop_caches

# 更新应用配置
echo "⚙️ 更新应用配置..."
cat > .env << EOF
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=phi3:mini
APP_PORT=3000
DISPLAY=:99
LOG_LEVEL=error
NODE_OPTIONS=--max-old-space-size=128
EOF

# 优化系统参数
echo "🔧 优化系统参数..."
sysctl -w vm.swappiness=5
sysctl -w vm.dirty_ratio=10
sysctl -w vm.dirty_background_ratio=3

echo ""
echo "✅ 快速优化完成！"
echo "重启应用: systemctl restart gas-management"
