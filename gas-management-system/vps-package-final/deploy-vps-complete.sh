#!/bin/bash

echo "🚀 Jy技術團隊 瓦斯行管理系統 2025 - VPS 完整部署脚本"
echo "================================================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 错误处理
set -e
trap 'echo -e "${RED}❌ 部署失败，请检查错误信息${NC}"' ERR

# 函数定义
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
    log_error "请使用 root 权限运行此脚本"
    exit 1
fi

# 1. 系统信息检查
log_info "检查系统信息..."
echo "系统: $(uname -a)"
echo "内存: $(free -h | grep Mem)"
echo "磁盘: $(df -h / | tail -1)"

TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.1f", $2/1024}')
log_info "总内存: ${TOTAL_MEM}GB"

if (( $(echo "$TOTAL_MEM < 3.0" | bc -l) )); then
    log_warning "内存不足 3GB，将使用超轻量级配置"
    USE_MICRO_MODEL=true
else
    USE_MICRO_MODEL=false
fi

# 2. 更新系统包
log_info "更新系统包..."
apt update && apt upgrade -y

# 3. 安装必要的软件包
log_info "安装必要软件包..."
apt install -y \
    curl \
    wget \
    git \
    unzip \
    htop \
    nginx \
    ufw \
    fail2ban \
    nodejs \
    npm \
    xvfb \
    xauth \
    bc

# 4. 安装 Docker
if ! command -v docker &> /dev/null; then
    log_info "安装 Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
    log_success "Docker 安装完成"
else
    log_success "Docker 已安装"
fi

# 5. 安装 Docker Compose
if ! command -v docker-compose &> /dev/null; then
    log_info "安装 Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    log_success "Docker Compose 安装完成"
else
    log_success "Docker Compose 已安装"
fi

# 6. 创建应用目录
APP_DIR="/opt/gas-management-system"
log_info "创建应用目录: $APP_DIR"
mkdir -p $APP_DIR
cd $APP_DIR

# 7. 解压应用文件
if [ -f "/root/gas-management-system-vps-package.zip" ]; then
    log_info "解压应用文件..."
    unzip -o /root/gas-management-system-vps-package.zip
    log_success "应用文件解压完成"
else
    log_error "未找到应用包文件，请确保 gas-management-system-vps-package.zip 在 /root/ 目录下"
    exit 1
fi

# 8. 安装应用依赖
log_info "安装应用依赖..."
npm install --production --no-audit --no-fund

# 9. 配置 Ollama 服务
log_info "配置 Ollama 服务..."

# 停止并清理现有容器
docker stop ollama 2>/dev/null || true
docker rm ollama 2>/dev/null || true

# 启动优化的 Ollama 容器
docker run -d \
    --name ollama \
    --restart unless-stopped \
    -p 11434:11434 \
    -v ollama_data:/root/.ollama \
    -e OLLAMA_HOST=0.0.0.0:11434 \
    -e OLLAMA_KEEP_ALIVE=3m \
    -e OLLAMA_MAX_LOADED_MODELS=1 \
    --memory=2.5g \
    --memory-swap=3g \
    ollama/ollama

log_info "等待 Ollama 服务启动..."
sleep 15

# 检查服务状态
if curl -s http://localhost:11434/api/tags > /dev/null; then
    log_success "Ollama 服务启动成功"
else
    log_error "Ollama 服务启动失败"
    docker logs ollama --tail 20
    exit 1
fi

# 10. 下载合适的 AI 模型
log_info "下载 AI 模型..."
if [ "$USE_MICRO_MODEL" = true ]; then
    log_info "使用微型模型 phi3:mini (内存占用 < 2GB)"
    docker exec ollama ollama pull phi3:mini
    DEFAULT_MODEL="phi3:mini"
else
    log_info "使用轻量级模型 gemma:2b (内存占用 ~2.5GB)"
    docker exec ollama ollama pull gemma:2b
    DEFAULT_MODEL="gemma:2b"
fi

# 验证模型下载
log_info "验证模型安装..."
docker exec ollama ollama list

# 11. 创建环境配置
log_info "创建环境配置..."
cat > .env << EOF
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=$DEFAULT_MODEL
APP_PORT=3000
LOG_LEVEL=info
COMPANY_NAME=Jy技術團隊
APP_YEAR=2025
EOF

# 12. 创建启动脚本
log_info "创建启动脚本..."
cat > start.sh << 'EOF'
#!/bin/bash

echo "🚀 启动 Jy技術團隊 瓦斯行管理系統 2025..."

# 检查 Docker 服务
if ! systemctl is-active --quiet docker; then
    echo "🐳 启动 Docker 服务..."
    systemctl start docker
    sleep 5
fi

# 检查 Ollama 容器
if ! docker ps | grep ollama > /dev/null; then
    echo "🤖 启动 Ollama 容器..."
    docker start ollama
    sleep 10
fi

# 等待 Ollama API 就绪
echo "⏳ 等待 Ollama API 就绪..."
timeout=60
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

# 设置虚拟显示（如果需要）
export DISPLAY=:99
if ! pgrep -f "Xvfb :99" > /dev/null; then
    echo "🖥️  启动虚拟显示..."
    Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
    sleep 2
fi

# 启动应用
echo "🚀 启动瓦斯行管理系統..."
cd /opt/gas-management-system

# 使用 PM2 管理进程（如果可用）
if command -v pm2 &> /dev/null; then
    pm2 start ecosystem.config.js
else
    # 直接启动
    npm start
fi
EOF

chmod +x start.sh

# 13. 创建 PM2 配置（可选）
if command -v pm2 &> /dev/null || npm list -g pm2 &> /dev/null; then
    log_info "创建 PM2 配置..."
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
      DISPLAY: ':99'
    },
    log_file: './logs/app.log',
    out_file: './logs/out.log',
    error_file: './logs/error.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss'
  }]
};
EOF
else
    log_info "安装 PM2 进程管理器..."
    npm install -g pm2
fi

# 14. 创建系统服务
log_info "创建系统服务..."
cat > /etc/systemd/system/gas-management.service << EOF
[Unit]
Description=Jy技術團隊 瓦斯行管理系統 2025
After=network.target docker.service
Requires=docker.service

[Service]
Type=simple
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

# 15. 配置防火墙
log_info "配置防火墙..."
ufw --force enable
ufw allow ssh
ufw allow 3000
ufw allow 11434

# 16. 创建监控脚本
log_info "创建监控脚本..."
cat > monitor.sh << 'EOF'
#!/bin/bash

echo "📊 Jy技術團隊 瓦斯行管理系統 2025 - 系统监控"
echo "================================================"

echo "🖥️  系统资源:"
free -h
echo ""

echo "🐳 Docker 容器状态:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo "🤖 Ollama 模型:"
docker exec ollama ollama list 2>/dev/null || echo "Ollama 服务不可用"
echo ""

echo "🌐 服务端口检查:"
netstat -tulpn | grep -E ":3000|:11434" || echo "服务端口未监听"
echo ""

echo "📝 应用日志 (最后10行):"
tail -10 /opt/gas-management-system/logs/*.log 2>/dev/null || echo "暂无日志文件"
EOF

chmod +x monitor.sh

# 17. 创建日志目录
mkdir -p logs
chmod 755 logs

# 18. 最终测试
log_info "执行最终测试..."

# 测试 Ollama API
if curl -s http://localhost:11434/api/tags > /dev/null; then
    log_success "Ollama API 测试通过"
else
    log_error "Ollama API 测试失败"
fi

# 显示完成信息
echo ""
echo "🎉 部署完成！"
echo "================================================"
log_success "Jy技術團隊 瓦斯行管理系統 2025 已成功部署到 VPS"
echo ""
echo "📋 重要信息:"
echo "• 应用目录: /opt/gas-management-system"
echo "• 服务端口: 3000 (应用), 11434 (AI)"
echo "• AI 模型: $DEFAULT_MODEL"
echo "• 系统内存: ${TOTAL_MEM}GB"
echo ""
echo "🛠️  管理命令:"
echo "• 启动服务: systemctl start gas-management"
echo "• 停止服务: systemctl stop gas-management"
echo "• 查看状态: systemctl status gas-management"
echo "• 手动启动: cd /opt/gas-management-system && ./start.sh"
echo "• 系统监控: cd /opt/gas-management-system && ./monitor.sh"
echo ""
echo "🌐 访问地址:"
echo "• 应用界面: http://$(curl -s ifconfig.me):3000"
echo "• Ollama API: http://$(curl -s ifconfig.me):11434"
echo ""
echo "📚 日志文件:"
echo "• 应用日志: /opt/gas-management-system/logs/"
echo "• 系统日志: journalctl -u gas-management -f"
echo ""

# 询问是否立即启动
read -p "是否立即启动服务？(y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "启动服务..."
    systemctl start gas-management
    sleep 5
    systemctl status gas-management
    echo ""
    log_success "服务已启动！请通过浏览器访问 http://$(curl -s ifconfig.me):3000"
else
    log_info "稍后可使用 'systemctl start gas-management' 启动服务"
fi

log_success "VPS 部署脚本执行完成！"
