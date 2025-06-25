#!/bin/bash
# 瓦斯管理系统 - 一键部署脚本
# 适用于Ubuntu/Debian VPS

set -e

echo "=== 瓦斯管理系统 - VPS一键部署 ==="
echo "开始时间: $(date)"

# 检查权限
if [ "$EUID" -ne 0 ]; then
    echo "请使用sudo运行此脚本"
    exit 1
fi

# 更新系统
echo "更新系统包..."
apt update && apt upgrade -y

# 安装Node.js 18+
echo "安装Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# 安装依赖
echo "安装系统依赖..."
apt-get install -y nginx certbot python3-certbot-nginx ufw

# 安装项目依赖
echo "安装项目依赖..."
npm install --production

# 构建项目 (如果需要)
echo "构建项目..."
npm run build 2>/dev/null || echo "跳过构建步骤"

# 配置防火墙
echo "配置防火墙..."
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 3000
echo "y" | ufw enable

# 配置Nginx
echo "配置Nginx..."
cat > /etc/nginx/sites-available/gas-management << 'EOL'
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOL

ln -sf /etc/nginx/sites-available/gas-management /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx

# 创建systemd服务
echo "创建系统服务..."
cat > /etc/systemd/system/gas-management.service << 'EOL'
[Unit]
Description=Gas Management System
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=$(pwd)
Environment=NODE_ENV=production
Environment=PORT=3000
ExecStart=/usr/bin/node dist/main/main.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable gas-management

# 启动服务
echo "启动服务..."
systemctl start gas-management
systemctl start nginx

# 检查状态
echo "检查服务状态..."
systemctl status gas-management --no-pager
systemctl status nginx --no-pager

echo "=== 部署完成 ==="
echo "访问地址: http://$(curl -s ifconfig.me)"
echo "本地访问: http://localhost"
echo ""
echo "管理命令:"
echo "  查看日志: journalctl -u gas-management -f"
echo "  重启服务: systemctl restart gas-management"
echo "  配置SSL: ./setup-ssl-certificate.sh"
echo "  外部访问: ./external-access-manager.sh"
