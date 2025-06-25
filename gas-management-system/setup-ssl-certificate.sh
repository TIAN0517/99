#!/bin/bash

# 瓦斯行管理系统 - SSL证书配置脚本
# Jy技術團隊 2025
# 使用 Let's Encrypt 免费SSL证书提供HTTPS访问

echo "🔒 瓦斯行管理系统 - SSL证书配置"
echo "Jy技術團隊 2025"
echo "================================"

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

# 检查是否为 root 用户
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "请使用 root 权限运行此脚本"
        echo "执行: sudo $0"
        exit 1
    fi
}

# 检查域名配置
check_domain() {
    log_info "配置域名..."
    
    echo "要使用SSL证书，您需要一个域名指向此服务器。"
    echo ""
    read -p "请输入您的域名 (例如: gas.example.com): " DOMAIN_NAME
    
    if [ -z "$DOMAIN_NAME" ]; then
        log_error "域名不能为空"
        exit 1
    fi
    
    log_info "检查域名解析..."
    DOMAIN_IP=$(dig +short "$DOMAIN_NAME" 2>/dev/null | head -1)
    PUBLIC_IP=$(curl -s --max-time 10 ifconfig.me 2>/dev/null)
    
    if [ -n "$DOMAIN_IP" ] && [ -n "$PUBLIC_IP" ]; then
        if [ "$DOMAIN_IP" = "$PUBLIC_IP" ]; then
            log_success "域名解析正确: $DOMAIN_NAME -> $PUBLIC_IP"
        else
            log_warning "域名解析不匹配:"
            echo "  域名指向: $DOMAIN_IP"
            echo "  服务器IP: $PUBLIC_IP"
            echo ""
            read -p "是否继续配置SSL？(y/N): " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log_info "请先将域名指向服务器IP，然后重新运行此脚本"
                exit 1
            fi
        fi
    else
        log_warning "无法验证域名解析，将继续配置"
    fi
    
    read -p "请输入您的邮箱 (用于Let's Encrypt通知): " EMAIL
    if [ -z "$EMAIL" ]; then
        log_error "邮箱不能为空"
        exit 1
    fi
}

# 安装依赖
install_dependencies() {
    log_info "安装依赖软件..."
    
    # 检测操作系统
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        log_error "无法检测操作系统"
        exit 1
    fi
    
    case $OS in
        ubuntu|debian)
            apt update
            apt install -y nginx certbot python3-certbot-nginx
            ;;
        centos|rhel|fedora)
            if command -v dnf &> /dev/null; then
                dnf install -y nginx certbot python3-certbot-nginx
            else
                yum install -y epel-release
                yum install -y nginx certbot python3-certbot-nginx
            fi
            ;;
        *)
            log_error "不支持的操作系统: $OS"
            exit 1
            ;;
    esac
    
    log_success "依赖软件安装完成"
}

# 配置 Nginx
configure_nginx() {
    log_info "配置 Nginx 反向代理..."
    
    # 备份原配置
    if [ -f "/etc/nginx/sites-available/default" ]; then
        cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup
    fi
    
    # 创建配置文件
    cat > "/etc/nginx/sites-available/gas-management" << EOF
# 瓦斯行管理系统 Nginx 配置
# Jy技術團隊 2025

server {
    listen 80;
    server_name $DOMAIN_NAME;
    
    # 重定向到 HTTPS
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN_NAME;
    
    # SSL 配置 (证书路径将由 certbot 自动配置)
    ssl_certificate /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem;
    
    # SSL 安全设置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # 安全头
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Referrer-Policy "strict-origin-when-cross-origin";
    
    # 反向代理到应用
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        
        # 增加超时时间
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # 可选：AI API 代理 (如果需要外网访问)
    location /api/ai/ {
        proxy_pass http://localhost:11434/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
    
    # 静态文件缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)\$ {
        proxy_pass http://localhost:3000;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF
    
    # 启用站点
    if [ -d "/etc/nginx/sites-enabled" ]; then
        ln -sf /etc/nginx/sites-available/gas-management /etc/nginx/sites-enabled/
        
        # 禁用默认站点
        if [ -f "/etc/nginx/sites-enabled/default" ]; then
            rm /etc/nginx/sites-enabled/default
        fi
    else
        # CentOS/RHEL 风格配置
        ln -sf /etc/nginx/sites-available/gas-management /etc/nginx/conf.d/gas-management.conf
    fi
    
    # 测试配置
    if nginx -t; then
        log_success "Nginx 配置验证成功"
    else
        log_error "Nginx 配置验证失败"
        exit 1
    fi
    
    # 启动 Nginx
    systemctl enable nginx
    systemctl start nginx
    
    log_success "Nginx 配置完成"
}

# 获取 SSL 证书
obtain_ssl_certificate() {
    log_info "获取 Let's Encrypt SSL 证书..."
    
    # 停止 nginx 以获取证书 (standalone 模式)
    systemctl stop nginx
    
    # 获取证书
    certbot certonly \
        --standalone \
        --email "$EMAIL" \
        --agree-tos \
        --no-eff-email \
        --domain "$DOMAIN_NAME"
    
    if [ $? -eq 0 ]; then
        log_success "SSL 证书获取成功"
    else
        log_error "SSL 证书获取失败"
        systemctl start nginx
        exit 1
    fi
    
    # 重新启动 nginx
    systemctl start nginx
    
    # 设置证书自动续期
    (crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
    
    log_success "SSL 证书自动续期已配置"
}

# 更新防火墙规则
update_firewall() {
    log_info "更新防火墙规则..."
    
    if command -v ufw &> /dev/null; then
        ufw allow 'Nginx Full'
        ufw delete allow 3000/tcp
        ufw --force enable
        log_success "UFW 防火墙规则已更新"
        
    elif command -v firewall-cmd &> /dev/null; then
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        firewall-cmd --permanent --remove-port=3000/tcp
        firewall-cmd --reload
        log_success "Firewalld 防火墙规则已更新"
        
    else
        log_warning "请手动更新防火墙规则:"
        echo "  - 开放端口 80 (HTTP)"
        echo "  - 开放端口 443 (HTTPS)"
        echo "  - 可以关闭端口 3000 (应用现在通过反向代理访问)"
    fi
}

# 更新应用配置
update_app_config() {
    log_info "更新应用配置..."
    
    # 查找应用目录
    APP_DIR=""
    if [ -d "/opt/gas-management-system" ]; then
        APP_DIR="/opt/gas-management-system"
    elif [ -f "package.json" ]; then
        APP_DIR="$(pwd)"
    else
        read -p "请输入应用安装目录: " APP_DIR
    fi
    
    if [ ! -d "$APP_DIR" ]; then
        log_error "应用目录不存在: $APP_DIR"
        return 1
    fi
    
    cd "$APP_DIR"
    
    # 更新环境配置
    if [ -f ".env" ]; then
        # 备份原配置
        cp .env .env.backup.ssl
        
        # 添加 SSL 相关配置
        cat >> .env << EOF

# SSL 配置
HTTPS_ENABLED=true
SSL_DOMAIN=$DOMAIN_NAME
NGINX_PROXY=true
SECURE_COOKIES=true
EOF
        log_success "应用配置已更新"
    fi
    
    # 重启应用服务
    systemctl restart gas-management
    log_success "应用服务已重启"
}

# 验证 SSL 配置
verify_ssl_configuration() {
    log_info "验证 SSL 配置..."
    
    sleep 5
    
    # 检查证书
    if openssl s_client -connect "$DOMAIN_NAME:443" -servername "$DOMAIN_NAME" < /dev/null 2>/dev/null | openssl x509 -noout -dates > /dev/null; then
        log_success "SSL 证书验证成功"
        
        # 显示证书信息
        echo "证书信息:"
        openssl s_client -connect "$DOMAIN_NAME:443" -servername "$DOMAIN_NAME" < /dev/null 2>/dev/null | openssl x509 -noout -dates
    else
        log_warning "SSL 证书验证失败，可能需要等待DNS传播"
    fi
    
    # 测试 HTTPS 访问
    if curl -s --max-time 10 "https://$DOMAIN_NAME" > /dev/null 2>&1; then
        log_success "HTTPS 访问测试成功"
    else
        log_warning "HTTPS 访问测试失败，请检查配置"
    fi
}

# 显示配置信息
show_ssl_info() {
    echo ""
    echo "🎉 SSL 证书配置完成！"
    echo "======================================"
    echo ""
    log_success "访问地址:"
    echo "  🔒 HTTPS 访问: https://$DOMAIN_NAME"
    echo "  🔓 HTTP 访问:  http://$DOMAIN_NAME (自动重定向到 HTTPS)"
    echo ""
    log_success "登录账号:"
    echo "  👨‍💼 管理员: admin / password"
    echo "  👨‍💼 经理:   manager / password"
    echo "  👨‍💼 员工:   employee / password"
    echo ""
    log_info "管理命令:"
    echo "  查看应用状态: systemctl status gas-management"
    echo "  查看 Nginx 状态: systemctl status nginx"
    echo "  重新载入 Nginx: systemctl reload nginx"
    echo "  续期证书: certbot renew"
    echo "  查看证书状态: certbot certificates"
    echo ""
    log_info "SSL 证书管理:"
    echo "  证书位置: /etc/letsencrypt/live/$DOMAIN_NAME/"
    echo "  自动续期: 已配置 (每日12点检查)"
    echo "  有效期: 90天 (自动续期)"
    echo ""
    log_warning "重要提醒:"
    echo "1. 🔐 建议立即更改默认登录密码"
    echo "2. 🔄 证书会自动续期，无需手动操作"
    echo "3. 🛡️ 应用现在通过 Nginx 反向代理访问"
    echo "4. 📊 可以通过 Nginx 日志监控访问情况"
    echo ""
    echo "🔧 技术支持: Jy技術團隊 2025"
}

# 主程序
main() {
    check_root
    echo ""
    
    check_domain
    echo ""
    
    install_dependencies
    echo ""
    
    configure_nginx
    echo ""
    
    obtain_ssl_certificate
    echo ""
    
    update_firewall
    echo ""
    
    update_app_config
    echo ""
    
    verify_ssl_configuration
    echo ""
    
    show_ssl_info
}

# 执行主程序
main "$@"
