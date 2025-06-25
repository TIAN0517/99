#!/bin/bash

echo "🚀 Jy技術團隊 瓦斯行管理系統 2025 - Linux VPS 完整部署脚本"
echo "================================================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 错误处理
set -e
trap 'echo -e "${RED}❌ 部署失败，请检查错误信息${NC}"' ERR

# 函数定义
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }
log_header() { echo -e "${PURPLE}🔧 $1${NC}"; }

# 检测 Linux 发行版
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/redhat-release ]; then
        OS=centos
        VER=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))
    else
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    
    echo "$OS"
}

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
    log_error "请使用 root 权限运行此脚本: sudo $0"
    exit 1
fi

echo "🐧 Linux VPS 部署开始..."
echo "================================================================"

# 1. 系统信息检查
log_header "系统信息检查"
OS_NAME=$(detect_os)
log_info "操作系统: $OS_NAME"
log_info "内核版本: $(uname -r)"
log_info "架构: $(uname -m)"

echo "📊 硬件信息:"
echo "CPU: $(nproc) 核心"
echo "内存: $(free -h | grep Mem | awk '{print $2}')"
echo "磁盘: $(df -h / | tail -1 | awk '{print $4}') 可用"

TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.1f", $2/1024}')
log_info "总内存: ${TOTAL_MEM}GB"

# 根据内存选择配置
if (( $(echo "$TOTAL_MEM < 2.0" | bc -l 2>/dev/null || echo "1") )); then
    log_warning "内存不足 2GB，将使用超轻量级配置"
    USE_MODEL="phi3:mini"
    DOCKER_MEMORY="1g"
elif (( $(echo "$TOTAL_MEM < 4.0" | bc -l 2>/dev/null || echo "0") )); then
    log_info "使用轻量级配置"
    USE_MODEL="gemma:2b"
    DOCKER_MEMORY="2.5g"
else
    log_info "使用标准配置"
    USE_MODEL="deepseek-r1:8b"
    DOCKER_MEMORY="4g"
fi

log_info "选择 AI 模型: $USE_MODEL"

# 2. 更新系统包
log_header "更新系统包"
case "$OS_NAME" in
    *"Ubuntu"*|*"Debian"*)
        log_info "检测到 Debian/Ubuntu 系统"
        export DEBIAN_FRONTEND=noninteractive
        apt update && apt upgrade -y
        PACKAGE_MANAGER="apt"
        ;;
    *"CentOS"*|*"Red Hat"*|*"Rocky"*|*"AlmaLinux"*)
        log_info "检测到 RHEL/CentOS 系统"
        yum update -y || dnf update -y
        PACKAGE_MANAGER="yum"
        ;;
    *"openSUSE"*|*"SUSE"*)
        log_info "检测到 SUSE 系统"
        zypper refresh && zypper update -y
        PACKAGE_MANAGER="zypper"
        ;;
    *)
        log_warning "未识别的 Linux 发行版，尝试使用通用方法"
        PACKAGE_MANAGER="unknown"
        ;;
esac

# 3. 安装必要的软件包
log_header "安装必要软件包"
install_packages() {
    case "$PACKAGE_MANAGER" in
        "apt")
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
                bc \
                jq \
                net-tools
            ;;
        "yum")
            yum install -y epel-release || dnf install -y epel-release
            yum install -y \
                curl \
                wget \
                git \
                unzip \
                htop \
                nginx \
                firewalld \
                fail2ban \
                nodejs \
                npm \
                xorg-x11-server-Xvfb \
                xorg-x11-xauth \
                bc \
                jq \
                net-tools || \
            dnf install -y \
                curl \
                wget \
                git \
                unzip \
                htop \
                nginx \
                firewalld \
                nodejs \
                npm \
                xorg-x11-server-Xvfb \
                bc \
                jq \
                net-tools
            ;;
        "zypper")
            zypper install -y \
                curl \
                wget \
                git \
                unzip \
                htop \
                nginx \
                ufw \
                nodejs \
                npm \
                xvfb \
                xauth \
                bc \
                jq \
                net-tools
            ;;
        *)
            log_error "未支持的包管理器，请手动安装依赖"
            exit 1
            ;;
    esac
}

install_packages
log_success "软件包安装完成"

# 4. 安装 Docker
log_header "安装 Docker"
if ! command -v docker &> /dev/null; then
    log_info "安装 Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
    log_success "Docker 安装完成"
else
    log_success "Docker 已安装"
    systemctl enable docker
    systemctl start docker
fi

# 5. 安装 Docker Compose
log_header "安装 Docker Compose"
if ! command -v docker-compose &> /dev/null; then
    log_info "安装 Docker Compose..."
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    log_success "Docker Compose 安装完成"
else
    log_success "Docker Compose 已安装"
fi

# 6. 创建应用目录
APP_DIR="/opt/gas-management-system"
log_header "创建应用目录"
log_info "应用目录: $APP_DIR"
mkdir -p $APP_DIR
cd $APP_DIR

# 7. 解压应用文件
log_header "部署应用文件"
PACKAGE_LOCATIONS=(
    "/root/gas-management-system-vps-package.zip"
    "/tmp/gas-management-system-vps-package.zip"
    "./gas-management-system-vps-package.zip"
    "../gas-management-system-vps-package.zip"
)

PACKAGE_FOUND=false
for location in "${PACKAGE_LOCATIONS[@]}"; do
    if [ -f "$location" ]; then
        log_info "找到应用包: $location"
        unzip -o "$location"
        PACKAGE_FOUND=true
        break
    fi
done

if [ "$PACKAGE_FOUND" = false ]; then
    log_error "未找到应用包文件，请确保以下位置之一存在应用包:"
    for location in "${PACKAGE_LOCATIONS[@]}"; do
        echo "  - $location"
    done
    exit 1
fi

log_success "应用文件解压完成"

# 8. 安装应用依赖
log_header "安装应用依赖"
if [ -f "package.json" ]; then
    log_info "安装 Node.js 依赖..."
    npm install --production --no-audit --no-fund
    log_success "依赖安装完成"
else
    log_error "未找到 package.json 文件"
    exit 1
fi

# 9. 配置 Ollama 服务
log_header "配置 Ollama AI 服务"

# 停止并清理现有容器
log_info "清理现有 Docker 容器..."
docker stop ollama 2>/dev/null || true
docker rm ollama 2>/dev/null || true

# 启动优化的 Ollama 容器
log_info "启动 Ollama 容器 (内存限制: $DOCKER_MEMORY)..."
docker run -d \
    --name ollama \
    --restart unless-stopped \
    -p 11434:11434 \
    -v ollama_data:/root/.ollama \
    -e OLLAMA_HOST=0.0.0.0:11434 \
    -e OLLAMA_KEEP_ALIVE=5m \
    -e OLLAMA_MAX_LOADED_MODELS=1 \
    -e OLLAMA_NUMA=false \
    --memory="$DOCKER_MEMORY" \
    --memory-swap="$DOCKER_MEMORY" \
    --oom-kill-disable=false \
    ollama/ollama

log_info "等待 Ollama 服务启动..."
sleep 20

# 检查服务状态
RETRIES=10
while [ $RETRIES -gt 0 ]; do
    if curl -s http://localhost:11434/api/tags > /dev/null; then
        log_success "Ollama 服务启动成功"
        break
    fi
    log_info "等待服务就绪... (剩余重试: $RETRIES)"
    sleep 5
    ((RETRIES--))
done

if [ $RETRIES -eq 0 ]; then
    log_error "Ollama 服务启动失败"
    echo "Docker 日志:"
    docker logs ollama --tail 20
    exit 1
fi

# 10. 下载 AI 模型
log_header "下载 AI 模型"
log_info "下载模型: $USE_MODEL"
docker exec ollama ollama pull "$USE_MODEL"

# 验证模型下载
log_info "验证模型安装..."
docker exec ollama ollama list

# 11. 创建环境配置
log_header "创建环境配置"
cat > .env << EOF
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=$USE_MODEL
APP_PORT=3000
LOG_LEVEL=info
COMPANY_NAME=Jy技術團隊
APP_YEAR=2025
DISPLAY=:99
EOF

log_info "环境配置文件已创建"

# 12. 创建优化的启动脚本
log_header "创建启动脚本"
cat > start.sh << 'EOF'
#!/bin/bash

echo "🚀 启动 Jy技術團隊 瓦斯行管理系統 2025..."

# 加载环境变量
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

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
    sleep 15
fi

# 等待 Ollama API 就绪
echo "⏳ 等待 Ollama API 就绪..."
timeout=120
while [ $timeout -gt 0 ]; do
    if curl -s http://localhost:11434/api/tags > /dev/null; then
        echo "✅ Ollama API 就绪"
        break
    fi
    echo "等待中... ($timeout)"
    sleep 2
    ((timeout--))
done

if [ $timeout -eq 0 ]; then
    echo "❌ Ollama API 启动超时"
    echo "检查 Docker 日志:"
    docker logs ollama --tail 10
    exit 1
fi

# 设置虚拟显示
export DISPLAY=:99
if ! pgrep -f "Xvfb :99" > /dev/null; then
    echo "🖥️  启动虚拟显示..."
    Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
    sleep 3
fi

# 创建日志目录
mkdir -p logs

# 启动应用
echo "🚀 启动瓦斯行管理系統..."
cd /opt/gas-management-system

# 使用 PM2 管理进程（如果可用）
if command -v pm2 &> /dev/null; then
    echo "使用 PM2 启动应用..."
    pm2 start ecosystem.config.js --update-env
else
    echo "直接启动应用..."
    npm start 2>&1 | tee logs/app.log
fi
EOF

chmod +x start.sh

# 13. 创建 PM2 配置
log_header "创建进程管理配置"
if ! command -v pm2 &> /dev/null; then
    log_info "安装 PM2 进程管理器..."
    npm install -g pm2
fi

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
      DEFAULT_AI_MODEL: '$USE_MODEL'
    },
    log_file: './logs/combined.log',
    out_file: './logs/out.log',
    error_file: './logs/error.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    merge_logs: true,
    kill_timeout: 5000
  }]
};
EOF

# 14. 创建系统服务
log_header "创建系统服务"
cat > /etc/systemd/system/gas-management.service << EOF
[Unit]
Description=Jy技術團隊 瓦斯行管理系統 2025
Documentation=https://github.com/jy-tech-team/gas-management-system
After=network.target docker.service
Wants=docker.service
Requires=docker.service

[Service]
Type=forking
User=root
Group=root
WorkingDirectory=/opt/gas-management-system
ExecStartPre=/bin/sleep 10
ExecStart=/opt/gas-management-system/start.sh
ExecReload=/bin/kill -USR2 \$MAINPID
Restart=always
RestartSec=15
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=30
Environment=NODE_ENV=production
Environment=DISPLAY=:99

# 安全设置
NoNewPrivileges=false
PrivateTmp=false

# 资源限制
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable gas-management.service
log_success "系统服务已创建并启用"

# 15. 配置防火墙
log_header "配置防火墙"
case "$PACKAGE_MANAGER" in
    "apt")
        # Ubuntu/Debian 使用 ufw
        ufw --force enable
        ufw allow ssh
        ufw allow 3000/tcp comment 'Gas Management System'
        ufw allow 11434/tcp comment 'Ollama API'
        ufw status
        ;;
    "yum")
        # CentOS/RHEL 使用 firewalld
        systemctl enable firewalld
        systemctl start firewalld
        firewall-cmd --permanent --add-port=3000/tcp
        firewall-cmd --permanent --add-port=11434/tcp
        firewall-cmd --permanent --add-service=ssh
        firewall-cmd --reload
        firewall-cmd --list-all
        ;;
    *)
        log_warning "请手动配置防火墙，开放端口 3000 和 11434"
        ;;
esac

log_success "防火墙配置完成"

# 16. 创建监控脚本
log_header "创建监控工具"
cat > monitor.sh << 'EOF'
#!/bin/bash

echo "📊 Jy技術團隊 瓦斯行管理系統 2025 - 系统监控"
echo "================================================"

# 系统信息
echo "🖥️  系统信息:"
echo "时间: $(date)"
echo "运行时间: $(uptime -p)"
echo "负载: $(uptime | awk -F'load average:' '{ print $2 }')"
echo ""

# 内存使用
echo "💾 内存使用:"
free -h
echo ""

# 磁盘使用
echo "💿 磁盘使用:"
df -h | grep -E '^/dev/'
echo ""

# Docker 容器状态
echo "🐳 Docker 容器状态:"
if command -v docker &> /dev/null; then
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}"
else
    echo "Docker 未安装"
fi
echo ""

# Ollama 模型
echo "🤖 Ollama 模型:"
if docker ps | grep ollama > /dev/null; then
    docker exec ollama ollama list 2>/dev/null || echo "无法获取模型列表"
else
    echo "Ollama 容器未运行"
fi
echo ""

# 网络端口
echo "🌐 网络端口:"
netstat -tulpn | grep -E ":3000|:11434" | head -10 || ss -tulpn | grep -E ":3000|:11434" | head -10
echo ""

# 进程状态
echo "⚙️  应用进程:"
if command -v pm2 &> /dev/null; then
    pm2 status
else
    ps aux | grep -E "(node|npm)" | grep -v grep | head -5
fi
echo ""

# 应用日志
echo "📝 最新日志:"
if [ -d "/opt/gas-management-system/logs" ]; then
    echo "应用日志 (最后5行):"
    tail -5 /opt/gas-management-system/logs/*.log 2>/dev/null | head -20
else
    echo "暂无日志文件"
fi
echo ""

# 系统服务状态
echo "🔧 系统服务:"
systemctl is-active gas-management.service docker.service 2>/dev/null || echo "服务状态检查失败"
EOF

chmod +x monitor.sh

# 17. 创建日志管理
log_header "配置日志管理"
mkdir -p logs
chmod 755 logs

# 创建日志轮转配置
cat > /etc/logrotate.d/gas-management << EOF
/opt/gas-management-system/logs/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    sharedscripts
    postrotate
        if [ -f /var/run/gas-management.pid ]; then
            /bin/kill -USR1 \$(cat /var/run/gas-management.pid)
        fi
    endscript
}
EOF

# 18. 性能优化
log_header "系统性能优化"

# 调整系统参数
cat >> /etc/sysctl.conf << EOF

# Gas Management System 优化
net.core.somaxconn = 1024
net.core.netdev_max_backlog = 5000
net.ipv4.tcp_max_syn_backlog = 1024
vm.swappiness = 10
EOF

# 如果内存不足，创建交换文件
if (( $(echo "$TOTAL_MEM < 4.0" | bc -l 2>/dev/null || echo "1") )); then
    if [ ! -f /swapfile ]; then
        log_info "创建交换文件 (2GB)..."
        fallocate -l 2G /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
        log_success "交换文件创建完成"
    fi
fi

# 应用系统参数
sysctl -p

# 19. 最终测试
log_header "执行系统测试"

# 测试 Docker
if docker ps > /dev/null 2>&1; then
    log_success "Docker 服务正常"
else
    log_error "Docker 服务异常"
fi

# 测试 Ollama API
if curl -s --max-time 10 http://localhost:11434/api/tags > /dev/null; then
    log_success "Ollama API 连接正常"
else
    log_warning "Ollama API 连接异常，请检查服务状态"
fi

# 测试 Node.js
if node --version > /dev/null 2>&1 && npm --version > /dev/null 2>&1; then
    log_success "Node.js 环境正常"
else
    log_error "Node.js 环境异常"
fi

# 20. 显示完成信息
echo ""
echo "🎉 Linux VPS 部署完成！"
echo "================================================================"
log_success "Jy技術團隊 瓦斯行管理系統 2025 已成功部署到 Linux VPS"
echo ""
echo "📋 部署信息:"
echo "• 操作系统: $OS_NAME"
echo "• 应用目录: /opt/gas-management-system"
echo "• AI 模型: $USE_MODEL"
echo "• 系统内存: ${TOTAL_MEM}GB"
echo "• Docker 内存限制: $DOCKER_MEMORY"
echo ""
echo "🌐 访问地址:"
PUBLIC_IP=$(curl -s --max-time 5 ifconfig.me || curl -s --max-time 5 ipinfo.io/ip || echo "获取失败")
echo "• 应用界面: http://$PUBLIC_IP:3000"
echo "• Ollama API: http://$PUBLIC_IP:11434"
echo "• 本地访问: http://localhost:3000"
echo ""
echo "🛠️  管理命令:"
echo "• 启动服务: systemctl start gas-management"
echo "• 停止服务: systemctl stop gas-management"
echo "• 重启服务: systemctl restart gas-management"
echo "• 查看状态: systemctl status gas-management"
echo "• 查看日志: journalctl -u gas-management -f"
echo "• 手动启动: cd /opt/gas-management-system && ./start.sh"
echo "• 系统监控: cd /opt/gas-management-system && ./monitor.sh"
echo ""
echo "📁 重要文件:"
echo "• 应用配置: /opt/gas-management-system/.env"
echo "• 系统服务: /etc/systemd/system/gas-management.service"
echo "• 应用日志: /opt/gas-management-system/logs/"
echo "• 系统日志: /var/log/syslog (Debian) 或 /var/log/messages (RHEL)"
echo ""
echo "🔧 PM2 管理命令:"
echo "• 查看进程: pm2 status"
echo "• 查看日志: pm2 logs gas-management-system"
echo "• 重启应用: pm2 restart gas-management-system"
echo "• 停止应用: pm2 stop gas-management-system"
echo ""

# 询问是否立即启动
read -p "$(echo -e ${CYAN}"是否立即启动服务？(y/N): "${NC}) -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "启动服务..."
    systemctl start gas-management
    sleep 10
    
    echo ""
    log_info "检查服务状态..."
    systemctl status gas-management --no-pager -l
    
    echo ""
    log_info "检查应用响应..."
    if curl -s --max-time 10 http://localhost:3000 > /dev/null; then
        log_success "应用启动成功！"
        echo ""
        echo "🎊 部署完成！请通过浏览器访问:"
        echo "   http://$PUBLIC_IP:3000"
    else
        log_warning "应用可能还在启动中，请稍等片刻后访问"
        echo "   可以运行 './monitor.sh' 检查状态"
    fi
else
    log_info "稍后可使用以下命令启动服务:"
    echo "   systemctl start gas-management"
fi

echo ""
log_success "🚀 Linux VPS 部署脚本执行完成！"
echo "================================================================"
