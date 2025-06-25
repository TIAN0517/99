#!/bin/bash

# 瓦斯行管理系统 - 快速外网访问启动脚本
# Jy技術團隊 2025
# 此脚本提供最简单的外网访问配置方式

echo "⚡ 瓦斯行管理系统 - 快速外网访问配置"
echo "Jy技術團隊 2025"
echo "======================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查权限
if [ "$EUID" -ne 0 ]; then
    log_error "请使用 root 权限运行此脚本"
    echo "执行: sudo $0"
    exit 1
fi

echo ""
log_info "正在进行快速外网访问配置..."
echo ""

# 1. 快速防火墙配置
log_info "步骤 1/5: 配置防火墙..."

if command -v ufw &> /dev/null; then
    ufw --force enable
    ufw allow ssh
    ufw allow 3000/tcp comment 'Gas Management System'
    log_success "UFW 防火墙配置完成"
elif command -v firewall-cmd &> /dev/null; then
    systemctl enable firewalld
    systemctl start firewalld
    firewall-cmd --permanent --add-service=ssh
    firewall-cmd --permanent --add-port=3000/tcp
    firewall-cmd --reload
    log_success "Firewalld 防火墙配置完成"
else
    log_warning "未检测到防火墙，请手动开放端口 3000"
fi

# 2. 快速网络配置
log_info "步骤 2/5: 配置网络设置..."

APP_DIR="/opt/gas-management-system"
if [ ! -d "$APP_DIR" ]; then
    APP_DIR="$(pwd)"
fi

cd "$APP_DIR"

# 创建环境配置
cat > .env << EOF
NODE_ENV=production
APP_HOST=0.0.0.0
APP_PORT=3000
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=gemma:2b
DISPLAY=:99
COMPANY_NAME=Jy技術團隊
APP_YEAR=2025
EOF

log_success "网络配置完成"

# 3. 快速服务配置
log_info "步骤 3/5: 配置系统服务..."

cat > /etc/systemd/system/gas-management.service << EOF
[Unit]
Description=Gas Management System - Jy技術團隊 2025
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$APP_DIR
Environment=NODE_ENV=production
Environment=DISPLAY=:99
ExecStartPre=/bin/bash -c 'if ! pgrep -f "Xvfb :99" > /dev/null; then Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 & fi'
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=gas-management

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable gas-management

log_success "系统服务配置完成"

# 4. 启动服务
log_info "步骤 4/5: 启动服务..."

# 启动虚拟显示
if ! pgrep -f "Xvfb :99" > /dev/null; then
    Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
    sleep 2
fi

# 启动主服务
systemctl restart gas-management
sleep 5

if systemctl is-active --quiet gas-management; then
    log_success "服务启动成功"
else
    log_error "服务启动失败"
    journalctl -u gas-management --since "1 minute ago" -n 10
fi

# 5. 验证配置
log_info "步骤 5/5: 验证配置..."

PUBLIC_IP=$(curl -s --max-time 10 ifconfig.me 2>/dev/null || echo "获取失败")
PRIVATE_IP=$(hostname -I | awk '{print $1}')

if netstat -tulpn 2>/dev/null | grep ":3000" | grep -q "0.0.0.0" || ss -tulpn 2>/dev/null | grep ":3000" | grep -q "0.0.0.0"; then
    log_success "端口监听验证成功"
else
    log_warning "端口监听可能异常"
fi

# 显示结果
echo ""
echo "🎉 快速外网访问配置完成！"
echo "================================"
echo ""
log_success "访问地址:"
echo "  🌍 外网访问: http://$PUBLIC_IP:3000"
echo "  🏠 内网访问: http://$PRIVATE_IP:3000"
echo "  💻 本地访问: http://localhost:3000"
echo ""
log_success "默认登录:"
echo "  👨‍💼 管理员: admin / password"
echo "  👨‍💼 经理:   manager / password"
echo "  👨‍💼 员工:   employee / password"
echo ""
log_warning "重要提醒:"
echo "  1. 🛡️ 请确保云服务商安全组已开放端口 3000"
echo "  2. 🔐 请立即更改默认登录密码"
echo "  3. 📊 运行完整测试: ./test-network-connectivity.sh"
echo ""
echo "🔧 Jy技術團隊 2025 - 专业瓦斯行管理解决方案"
