#!/bin/bash

echo "🚀 修复 VPS 部署问题 - Jy技術團隊 瓦斯行管理系統 2025"
echo "================================================"

# 1. 安装 npm
echo "📦 安装 npm..."
apt update
apt install npm -y

# 2. 停止当前的 ollama 容器并重新启动，正确映射端口
echo "🐳 重新配置 Docker 容器..."
docker stop ollama || true
docker rm ollama || true

# 启动新的 ollama 容器，正确映射端口
docker run -d \
  --name ollama \
  -p 11434:11434 \
  -v ollama_data:/root/.ollama \
  --restart unless-stopped \
  ollama/ollama

echo "⏳ 等待 Ollama 服务启动..."
sleep 10

# 3. 由于内存限制，使用更小的模型
echo "🤖 由于内存限制(3.8GB)，切换到更小的 AI 模型..."
docker exec ollama ollama pull gemma:2b

# 4. 移除占用内存的大模型
echo "🗑️  清理大模型以释放内存..."
docker exec ollama ollama rm deepseek-r1:8b || true

# 5. 测试 API 连接
echo "🔍 测试 Ollama API 连接..."
sleep 5
if curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "✅ Ollama API 连接成功"
    curl http://localhost:11434/api/tags
else
    echo "❌ Ollama API 连接失败"
    echo "检查容器状态:"
    docker logs ollama --tail 20
fi

# 6. 安装应用依赖
echo "📦 安装应用依赖..."
npm install

# 7. 创建优化的启动脚本
cat > optimized-start.sh << 'EOF'
#!/bin/bash

echo "🚀 启动优化版 Jy技術團隊 瓦斯行管理系統 2025..."

# 检查 Docker 服务
if ! systemctl is-active --quiet docker; then
    echo "🐳 启动 Docker 服务..."
    systemctl start docker
fi

# 检查 Ollama 容器
if ! docker ps | grep ollama > /dev/null; then
    echo "🤖 启动 Ollama 容器..."
    docker start ollama || docker run -d --name ollama -p 11434:11434 -v ollama_data:/root/.ollama ollama/ollama
    sleep 10
fi

# 等待 API 可用
echo "⏳ 等待 Ollama API 就绪..."
timeout=30
while [ $timeout -gt 0 ]; do
    if curl -s http://localhost:11434/api/tags > /dev/null; then
        echo "✅ Ollama API 就绪"
        break
    fi
    echo "等待中... ($timeout)"
    sleep 1
    ((timeout--))
done

if [ $timeout -eq 0 ]; then
    echo "❌ Ollama API 启动超时"
    exit 1
fi

# 设置虚拟显示
export DISPLAY=:99
if ! pgrep -f "Xvfb :99" > /dev/null; then
    echo "🖥️  启动虚拟显示..."
    Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
    sleep 2
fi

# 启动应用
echo "🚀 启动瓦斯行管理系統..."
npm start

EOF

chmod +x optimized-start.sh

echo ""
echo "✅ 修复完成！接下来："
echo "1. 运行: ./optimized-start.sh"
echo "2. 或者使用 gemma:2b 模型 (更适合 3.8GB 内存)"
echo ""
echo "📊 系统资源状态："
free -h
echo ""
echo "🐳 Docker 容器状态："
docker ps
