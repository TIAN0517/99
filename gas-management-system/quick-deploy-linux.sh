#!/bin/bash
# 
# Jy技術團隊 瓦斯行管理系統 2025 - Linux VPS 快速部署
# 适用于 Ubuntu 20.04+, Debian 11+, CentOS 8+
#

set -e

echo "🚀 快速部署 Jy技術團隊 瓦斯行管理系統 2025"
echo "=============================================="

# 检查 root 权限
if [ "$EUID" -ne 0 ]; then
    echo "❌ 请使用 root 权限运行: sudo $0"
    exit 1
fi

# 获取系统信息
TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.1f", $2/1024}')
echo "📊 系统内存: ${TOTAL_MEM}GB"

# 选择 AI 模型
if (( $(echo "$TOTAL_MEM < 3.0" | bc -l 2>/dev/null || echo "1") )); then
    AI_MODEL="gemma:2b"
    MEMORY_LIMIT="2g"
    echo "💡 使用轻量级配置: $AI_MODEL"
else
    AI_MODEL="deepseek-r1:8b"
    MEMORY_LIMIT="4g"
    echo "💡 使用标准配置: $AI_MODEL"
fi

# 1. 安装依赖
echo "📦 安装系统依赖..."
if command -v apt &> /dev/null; then
    export DEBIAN_FRONTEND=noninteractive
    apt update -y
    apt install -y curl wget git unzip nodejs npm xvfb bc jq net-tools
elif command -v yum &> /dev/null; then
    yum install -y curl wget git unzip nodejs npm xorg-x11-server-Xvfb bc jq net-tools
elif command -v dnf &> /dev/null; then
    dnf install -y curl wget git unzip nodejs npm xorg-x11-server-Xvfb bc jq net-tools
else
    echo "❌ 不支持的系统，请手动安装依赖"
    exit 1
fi

# 2. 安装 Docker
echo "🐳 安装 Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
fi

# 3. 创建应用目录
APP_DIR="/opt/gas-management-system"
echo "📁 创建应用目录: $APP_DIR"
mkdir -p $APP_DIR
cd $APP_DIR

# 4. 查找并解压应用包
echo "📦 解压应用文件..."
PACKAGE_FOUND=false
for location in "/root/gas-management-system-vps-package.zip" "/tmp/gas-management-system-vps-package.zip" "./gas-management-system-vps-package.zip"; do
    if [ -f "$location" ]; then
        echo "✅ 找到应用包: $location"
        unzip -o "$location"
        PACKAGE_FOUND=true
        break
    fi
done

if [ "$PACKAGE_FOUND" = false ]; then
    echo "❌ 未找到应用包，请确保 gas-management-system-vps-package.zip 在以下位置之一："
    echo "   - /root/gas-management-system-vps-package.zip"
    echo "   - /tmp/gas-management-system-vps-package.zip"
    echo "   - ./gas-management-system-vps-package.zip"
    exit 1
fi

# 5. 安装应用依赖
echo "📦 安装应用依赖..."
npm install --production --no-audit --no-fund

# 6. 启动 Ollama
echo "🤖 启动 Ollama AI 服务..."
docker stop ollama 2>/dev/null || true
docker rm ollama 2>/dev/null || true

docker run -d \
    --name ollama \
    --restart unless-stopped \
    -p 11434:11434 \
    -v ollama_data:/root/.ollama \
    -e OLLAMA_HOST=0.0.0.0:11434 \
    -e OLLAMA_KEEP_ALIVE=5m \
    -e OLLAMA_MAX_LOADED_MODELS=1 \
    --memory="$MEMORY_LIMIT" \
    ollama/ollama

echo "⏳ 等待 Ollama 服务启动..."
sleep 20

# 检查 Ollama 服务
RETRIES=15
while [ $RETRIES -gt 0 ]; do
    if curl -s http://localhost:11434/api/tags > /dev/null; then
        echo "✅ Ollama 服务就绪"
        break
    fi
    echo "⏳ 等待服务启动... ($RETRIES)"
    sleep 3
    ((RETRIES--))
done

if [ $RETRIES -eq 0 ]; then
    echo "❌ Ollama 服务启动失败"
    docker logs ollama --tail 10
    exit 1
fi

# 7. 下载 AI 模型
echo "📥 下载 AI 模型: $AI_MODEL"
docker exec ollama ollama pull "$AI_MODEL"

# 8. 创建配置文件
echo "⚙️  创建配置文件..."
cat > .env << EOF
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=$AI_MODEL
APP_PORT=3000
DISPLAY=:99
EOF

# 9. 安装 PM2
echo "📦 安装 PM2 进程管理器..."
npm install -g pm2

# 10. 创建 PM2 配置
cat > ecosystem.config.js << EOF
module.exports = {
  apps: [{
    name: 'gas-management-system',
    script: 'npm',
    args: 'start',
    cwd: '/opt/gas-management-system',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '400M',
    env: {
      NODE_ENV: 'production',
      DISPLAY: ':99',
      OLLAMA_BASE_URL: 'http://localhost:11434',
      DEFAULT_AI_MODEL: '$AI_MODEL'
    },
    log_file: './logs/combined.log',
    out_file: './logs/out.log',
    error_file: './logs/error.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss'
  }]
};
EOF

# 11. 创建启动脚本
cat > start.sh << 'EOF'
#!/bin/bash
echo "🚀 启动瓦斯行管理系統..."

# 检查 Docker
if ! systemctl is-active --quiet docker; then
    systemctl start docker
    sleep 5
fi

# 检查 Ollama
if ! docker ps | grep ollama > /dev/null; then
    docker start ollama
    sleep 15
fi

# 等待 API 就绪
echo "⏳ 等待 Ollama API..."
timeout=60
while [ $timeout -gt 0 ]; do
    if curl -s http://localhost:11434/api/tags > /dev/null; then
        echo "✅ API 就绪"
        break
    fi
    sleep 2
    ((timeout--))
done

# 启动虚拟显示
export DISPLAY=:99
if ! pgrep -f "Xvfb :99" > /dev/null; then
    Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
    sleep 2
fi

# 创建日志目录
mkdir -p logs

# 启动应用
cd /opt/gas-management-system
if command -v pm2 &> /dev/null; then
    pm2 start ecosystem.config.js --update-env
else
    npm start
fi
EOF

chmod +x start.sh

# 12. 创建系统服务
echo "🔧 创建系统服务..."
cat > /etc/systemd/system/gas-management.service << EOF
[Unit]
Description=Jy技術團隊 瓦斯行管理系統 2025
After=network.target docker.service
Requires=docker.service

[Service]
Type=forking
User=root
WorkingDirectory=/opt/gas-management-system
ExecStart=/opt/gas-management-system/start.sh
Restart=always
RestartSec=10
Environment=NODE_ENV=production
Environment=DISPLAY=:99

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable gas-management.service

# 13. 配置防火墙
echo "🔥 配置防火墙..."
if command -v ufw &> /dev/null; then
    ufw --force enable
    ufw allow ssh
    ufw allow 3000
    ufw allow 11434
elif command -v firewall-cmd &> /dev/null; then
    systemctl enable firewalld 2>/dev/null || true
    systemctl start firewalld 2>/dev/null || true
    firewall-cmd --permanent --add-port=3000/tcp
    firewall-cmd --permanent --add-port=11434/tcp
    firewall-cmd --reload
fi

# 14. 创建监控脚本
cat > monitor.sh << 'EOF'
#!/bin/bash
echo "📊 系统监控"
echo "==========="
echo "内存: $(free -h | grep Mem | awk '{print $3"/"$2}')"
echo "Docker: $(docker ps --format 'table {{.Names}}\t{{.Status}}' | grep -v NAMES)"
echo "端口: $(netstat -tulpn 2>/dev/null | grep -E ':3000|:11434' | wc -l) 个服务运行中"
echo "进程: $(pm2 status 2>/dev/null || echo '请使用 systemctl status gas-management 查看')"
EOF

chmod +x monitor.sh

# 15. 创建日志目录
mkdir -p logs
chmod 755 logs

# 完成部署
PUBLIC_IP=$(curl -s --max-time 5 ifconfig.me 2>/dev/null || echo "localhost")

echo ""
echo "🎉 部署完成！"
echo "===================="
echo "🌐 访问地址: http://$PUBLIC_IP:3000"
echo "🤖 AI 模型: $AI_MODEL"
echo "💾 内存限制: $MEMORY_LIMIT"
echo ""
echo "🛠️  管理命令:"
echo "启动: systemctl start gas-management"
echo "状态: systemctl status gas-management"
echo "日志: journalctl -u gas-management -f"
echo "监控: ./monitor.sh"
echo ""

# 询问是否立即启动
read -p "立即启动服务？(y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 启动服务..."
    systemctl start gas-management
    sleep 8
    
    if curl -s --max-time 10 http://localhost:3000 > /dev/null; then
        echo "✅ 服务启动成功！"
        echo "🌐 请访问: http://$PUBLIC_IP:3000"
    else
        echo "⏳ 服务正在启动中，请稍后访问"
    fi
else
    echo "💡 稍后使用 'systemctl start gas-management' 启动"
fi

echo "✅ 快速部署完成！"
