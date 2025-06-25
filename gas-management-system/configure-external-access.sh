#!/bin/bash

# 瓦斯行管理系统 - 外网连线配置脚本
# Jy技術團隊 2025
# 此脚本将配置所有必要的设置以启用外网访问

echo "🌐 瓦斯行管理系统 - 外网连线配置"
echo "Jy技術團隊 2025"
echo "=================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# 检查是否为 root 用户
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "请使用 root 权限运行此脚本"
        echo "执行: sudo $0"
        exit 1
    fi
}

# 获取公网 IP
get_public_ip() {
    log_info "获取公网 IP 地址..."
    
    PUBLIC_IP=""
    
    # 尝试多个 IP 查询服务
    for service in "ifconfig.me" "ipinfo.io/ip" "icanhazip.com" "ipecho.net/plain"; do
        if [ -z "$PUBLIC_IP" ]; then
            PUBLIC_IP=$(curl -s --max-time 10 "$service" 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)
            if [ -n "$PUBLIC_IP" ]; then
                log_success "公网 IP: $PUBLIC_IP (来源: $service)"
                break
            fi
        fi
    done
    
    if [ -z "$PUBLIC_IP" ]; then
        log_warning "无法自动获取公网 IP，请手动输入"
        read -p "请输入您的服务器公网 IP: " PUBLIC_IP
        if [ -z "$PUBLIC_IP" ]; then
            PUBLIC_IP="your-server-ip"
            log_warning "未输入 IP，将使用占位符"
        fi
    fi
    
    # 获取内网 IP
    PRIVATE_IP=$(hostname -I | awk '{print $1}')
    log_info "内网 IP: $PRIVATE_IP"
}

# 配置防火墙
configure_firewall() {
    log_info "配置防火墙规则..."
    
    # 检测并配置防火墙
    if command -v ufw &> /dev/null; then
        log_info "使用 UFW 配置防火墙..."
        
        # 启用 UFW
        ufw --force enable
        
        # 基础规则
        ufw allow ssh comment 'SSH Access'
        ufw allow 3000/tcp comment 'Gas Management System'
        ufw allow 80/tcp comment 'HTTP'
        ufw allow 443/tcp comment 'HTTPS'
        
        # 询问是否开放 AI API
        echo ""
        read -p "是否允许外网访问 AI API (端口 11434)？建议仅内网访问 (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ufw allow 11434/tcp comment 'Ollama AI API'
            log_success "已开放 AI API 外网访问"
            AI_EXTERNAL=true
        else
            log_info "AI API 仅限内网访问"
            AI_EXTERNAL=false
        fi
        
        log_success "UFW 防火墙配置完成"
        ufw status numbered
        
    elif command -v firewall-cmd &> /dev/null; then
        log_info "使用 Firewalld 配置防火墙..."
        
        # 启动 firewalld
        systemctl enable firewalld
        systemctl start firewalld
        
        # 基础规则
        firewall-cmd --permanent --add-service=ssh
        firewall-cmd --permanent --add-port=3000/tcp
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        
        # 询问是否开放 AI API
        echo ""
        read -p "是否允许外网访问 AI API (端口 11434)？建议仅内网访问 (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            firewall-cmd --permanent --add-port=11434/tcp
            log_success "已开放 AI API 外网访问"
            AI_EXTERNAL=true
        else
            log_info "AI API 仅限内网访问"
            AI_EXTERNAL=false
        fi
        
        firewall-cmd --reload
        log_success "Firewalld 防火墙配置完成"
        firewall-cmd --list-all
        
    elif command -v iptables &> /dev/null; then
        log_info "使用 iptables 配置防火墙..."
        
        # 基础 iptables 规则
        iptables -A INPUT -p tcp --dport 22 -j ACCEPT
        iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
        iptables -A INPUT -p tcp --dport 80 -j ACCEPT
        iptables -A INPUT -p tcp --dport 443 -j ACCEPT
        
        # 询问是否开放 AI API
        echo ""
        read -p "是否允许外网访问 AI API (端口 11434)？建议仅内网访问 (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            iptables -A INPUT -p tcp --dport 11434 -j ACCEPT
            log_success "已开放 AI API 外网访问"
            AI_EXTERNAL=true
        else
            log_info "AI API 仅限内网访问"
            AI_EXTERNAL=false
        fi
        
        # 保存 iptables 规则
        if command -v iptables-save &> /dev/null; then
            iptables-save > /etc/iptables/rules.v4 2>/dev/null || iptables-save > /etc/iptables.rules 2>/dev/null
        fi
        
        log_success "iptables 防火墙配置完成"
        
    else
        log_warning "未检测到防火墙工具，请手动配置以下端口："
        echo "  - SSH: 22"
        echo "  - 应用: 3000"
        echo "  - HTTP: 80"
        echo "  - HTTPS: 443"
        echo "  - AI API: 11434 (可选)"
    fi
}

# 配置应用网络设置
configure_app_network() {
    log_info "配置应用网络设置..."
    
    # 查找应用目录
    APP_DIR=""
    if [ -d "/opt/gas-management-system" ]; then
        APP_DIR="/opt/gas-management-system"
    elif [ -d "$(pwd)" ] && [ -f "$(pwd)/package.json" ]; then
        APP_DIR="$(pwd)"
    else
        log_warning "未找到应用目录，请手动指定"
        read -p "请输入应用安装目录: " APP_DIR
        if [ ! -d "$APP_DIR" ]; then
            log_error "指定的目录不存在: $APP_DIR"
            return 1
        fi
    fi
    
    log_info "应用目录: $APP_DIR"
    cd "$APP_DIR"
    
    # 备份现有配置
    if [ -f ".env" ]; then
        cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
        log_success "已备份现有配置文件"
    fi
    
    # 创建新的环境配置
    cat > .env << EOF
# 瓦斯行管理系统配置文件
# Jy技術團隊 2025

# 生产环境配置
NODE_ENV=production
LOG_LEVEL=info

# 网络配置
APP_HOST=0.0.0.0
APP_PORT=3000
TRUST_PROXY=true

# AI 服务配置
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=gemma:2b
AI_TIMEOUT=30000
AI_RETRY_ATTEMPTS=3

# 安全配置
CORS_ORIGIN=*
SECURE_HEADERS=true
SESSION_SECRET=$(openssl rand -base64 32)

# 公司信息
COMPANY_NAME=Jy技術團隊
APP_YEAR=2025
APP_VERSION=1.0.0

# 服务器信息
PUBLIC_IP=$PUBLIC_IP
PRIVATE_IP=$PRIVATE_IP

# 显示配置
DISPLAY=:99
XVFB_ARGS="-screen 0 1024x768x24"
EOF
    
    log_success "应用环境配置已更新"
    
    # 检查并修改 package.json 中的启动脚本
    if [ -f "package.json" ]; then
        # 备份 package.json
        cp package.json package.json.backup.$(date +%Y%m%d_%H%M%S)
        
        # 检查是否需要修改网络绑定
        if grep -q "localhost" package.json; then
            log_info "修改 package.json 中的网络绑定..."
            sed -i 's/localhost/0.0.0.0/g' package.json
            log_success "已修改网络绑定为所有接口"
        fi
    fi
}

# 配置系统服务
configure_service() {
    log_info "配置系统服务..."
    
    # 创建或更新 systemd 服务文件
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
    
    # 重新加载 systemd 配置
    systemctl daemon-reload
    systemctl enable gas-management
    
    log_success "系统服务配置完成"
}

# 启动服务
start_services() {
    log_info "启动服务..."
    
    # 启动 Xvfb
    if ! pgrep -f "Xvfb :99" > /dev/null; then
        log_info "启动虚拟显示服务..."
        Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
        sleep 2
    fi
    
    # 重启应用服务
    log_info "重启应用服务..."
    systemctl restart gas-management
    sleep 5
    
    # 检查服务状态
    if systemctl is-active --quiet gas-management; then
        log_success "应用服务启动成功"
    else
        log_error "应用服务启动失败"
        echo "查看错误日志:"
        journalctl -u gas-management --since "2 minutes ago" -n 20
        return 1
    fi
}

# 验证配置
verify_configuration() {
    log_info "验证外网访问配置..."
    
    # 检查端口监听
    log_info "检查端口监听状态..."
    sleep 3
    
    if netstat -tulpn 2>/dev/null | grep ":3000" | grep -q "0.0.0.0" || ss -tulpn 2>/dev/null | grep ":3000" | grep -q "0.0.0.0"; then
        log_success "应用正在监听所有网络接口 (0.0.0.0:3000)"
    else
        log_warning "应用可能未正确监听外网接口"
        echo "当前监听状态:"
        netstat -tulpn 2>/dev/null | grep ":3000" || ss -tulpn 2>/dev/null | grep ":3000" || echo "未找到 3000 端口监听"
    fi
    
    # 测试本地访问
    log_info "测试本地访问..."
    if curl -s --max-time 10 http://localhost:3000 > /dev/null 2>&1; then
        log_success "本地访问正常"
    else
        log_warning "本地访问失败，应用可能尚未完全启动"
    fi
    
    # 测试内网访问
    if [ -n "$PRIVATE_IP" ] && [ "$PRIVATE_IP" != "127.0.0.1" ]; then
        log_info "测试内网访问..."
        if curl -s --max-time 10 "http://$PRIVATE_IP:3000" > /dev/null 2>&1; then
            log_success "内网访问正常"
        else
            log_warning "内网访问失败"
        fi
    fi
}

# 显示配置信息
show_access_info() {
    echo ""
    echo "🎉 外网连线配置完成！"
    echo "======================================"
    echo ""
    log_success "访问地址:"
    echo "  🌍 外网访问: http://$PUBLIC_IP:3000"
    echo "  🏠 内网访问: http://$PRIVATE_IP:3000"
    echo "  💻 本地访问: http://localhost:3000"
    
    if [ "$AI_EXTERNAL" = true ]; then
        echo "  🤖 AI API:   http://$PUBLIC_IP:11434"
    fi
    
    echo ""
    log_success "登录账号:"
    echo "  👨‍💼 管理员: admin / password"
    echo "  👨‍💼 经理:   manager / password"
    echo "  👨‍💼 员工:   employee / password"
    
    echo ""
    log_info "管理命令:"
    echo "  查看状态: systemctl status gas-management"
    echo "  重启服务: systemctl restart gas-management"
    echo "  停止服务: systemctl stop gas-management"
    echo "  查看日志: journalctl -u gas-management -f"
    echo "  防火墙状态: ufw status 或 firewall-cmd --list-all"
    
    echo ""
    log_warning "重要提醒:"
    echo "1. 🛡️ 请确保云服务商安全组已开放 3000 端口"
    echo "2. 🔐 建议立即更改默认登录密码"
    echo "3. 🔒 考虑配置 SSL 证书以提高安全性"
    echo "4. 📊 定期检查服务状态和日志"
    echo "5. 💾 定期备份重要数据"
    
    echo ""
    echo "📖 详细文档: 查看 EXTERNAL-ACCESS-GUIDE.md"
    echo "🔧 技术支持: Jy技術團隊 2025"
    echo ""
}

# 主程序
main() {
    check_root
    echo ""
    
    get_public_ip
    echo ""
    
    configure_firewall
    echo ""
    
    configure_app_network
    echo ""
    
    configure_service
    echo ""
    
    start_services
    echo ""
    
    verify_configuration
    echo ""
    
    show_access_info
}

# 执行主程序
main "$@"
