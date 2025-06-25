#!/bin/bash

echo "🌐 配置外网访问 - Jy技術團隊 瓦斯行管理系統 2025"
echo "================================================="

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
    echo "❌ 请使用 root 权限运行此脚本: sudo $0"
    exit 1
fi

# 获取外网 IP
PUBLIC_IP=$(curl -s --max-time 10 ifconfig.me 2>/dev/null || curl -s --max-time 10 ipinfo.io/ip 2>/dev/null)
if [ -n "$PUBLIC_IP" ]; then
    echo "🌍 外网 IP: $PUBLIC_IP"
else
    echo "⚠️  无法获取外网 IP，请检查网络连接"
    PUBLIC_IP="your-server-ip"
fi

echo ""
echo "🔧 开始配置外网访问..."

# 1. 配置防火墙
echo "1. 配置防火墙规则..."

if command -v ufw &> /dev/null; then
    echo "   使用 UFW 配置防火墙..."
    ufw --force enable
    ufw allow ssh
    ufw allow 3000/tcp comment 'Gas Management System'
    ufw allow 80/tcp comment 'HTTP'
    ufw allow 443/tcp comment 'HTTPS'
    
    # 可选：如需外部访问 AI API
    read -p "   是否允许外网访问 AI API (端口 11434)？(y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ufw allow 11434/tcp comment 'Ollama AI API'
        echo "   ✅ 已开放 AI API 端口"
    else
        echo "   ℹ️  AI API 仅限内网访问"
    fi
    
    echo "   ✅ UFW 防火墙配置完成"
    ufw status

elif command -v firewall-cmd &> /dev/null; then
    echo "   使用 Firewalld 配置防火墙..."
    systemctl enable firewalld
    systemctl start firewalld
    
    firewall-cmd --permanent --add-service=ssh
    firewall-cmd --permanent --add-port=3000/tcp
    firewall-cmd --permanent --add-service=http
    firewall-cmd --permanent --add-service=https
    
    # 可选：AI API 外网访问
    read -p "   是否允许外网访问 AI API (端口 11434)？(y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        firewall-cmd --permanent --add-port=11434/tcp
        echo "   ✅ 已开放 AI API 端口"
    fi
    
    firewall-cmd --reload
    echo "   ✅ Firewalld 防火墙配置完成"
    firewall-cmd --list-all

else
    echo "   ⚠️  未检测到防火墙工具，请手动配置"
    echo "   需要开放端口: 22(SSH), 3000(应用), 80(HTTP), 443(HTTPS)"
fi

# 2. 配置应用监听所有接口
echo ""
echo "2. 配置应用网络设置..."

# 更新环境配置
if [ -f "/opt/gas-management-system/.env" ]; then
    CONFIG_FILE="/opt/gas-management-system/.env"
    cd /opt/gas-management-system
elif [ -f ".env" ]; then
    CONFIG_FILE=".env"
else
    CONFIG_FILE=".env"
    echo "   创建配置文件..."
fi

# 备份原配置
if [ -f "$CONFIG_FILE" ]; then
    cp "$CONFIG_FILE" "${CONFIG_FILE}.backup"
    echo "   ✅ 已备份原配置文件"
fi

# 创建新配置
cat > "$CONFIG_FILE" << EOF
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=gemma:2b
APP_PORT=3000
APP_HOST=0.0.0.0
DISPLAY=:99
LOG_LEVEL=info
COMPANY_NAME=Jy技術團隊
APP_YEAR=2025

# 安全设置
CORS_ORIGIN=*
TRUST_PROXY=true
SECURE_HEADERS=true
EOF

echo "   ✅ 应用配置已更新为监听所有网络接口"

# 3. 检查并修改应用启动配置
echo ""
echo "3. 检查应用启动配置..."

# 检查 package.json 中的启动脚本
if [ -f "package.json" ]; then
    if grep -q "localhost" package.json; then
        echo "   ⚠️  检测到 localhost 绑定，建议修改为 0.0.0.0"
        
        # 创建备份
        cp package.json package.json.backup
        
        # 修改启动脚本（如果存在 localhost 绑定）
        sed -i 's/localhost/0.0.0.0/g' package.json
        echo "   ✅ 已修改 package.json 中的网络绑定"
    else
        echo "   ✅ package.json 配置正常"
    fi
fi

# 4. 重启服务
echo ""
echo "4. 重启应用服务..."

if systemctl is-active --quiet gas-management; then
    systemctl restart gas-management
    echo "   ✅ 服务已重启"
    sleep 5
    
    # 检查服务状态
    if systemctl is-active --quiet gas-management; then
        echo "   ✅ 服务重启成功"
    else
        echo "   ❌ 服务重启失败，请检查日志"
        journalctl -u gas-management --since "1 minute ago" -n 10
    fi
else
    echo "   ⚠️  服务未运行，尝试启动..."
    systemctl start gas-management
    sleep 5
    
    if systemctl is-active --quiet gas-management; then
        echo "   ✅ 服务启动成功"
    else
        echo "   ❌ 服务启动失败，尝试手动启动"
        if [ -d "/opt/gas-management-system" ]; then
            cd /opt/gas-management-system
        fi
        
        # 手动启动
        export DISPLAY=:99
        if ! pgrep -f "Xvfb :99" > /dev/null; then
            Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
        fi
        
        echo "   启动应用..."
        npm start &
        sleep 3
    fi
fi

# 5. 验证外网访问
echo ""
echo "5. 验证外网访问..."

# 检查端口监听
echo "   检查端口监听状态..."
if netstat -tulpn | grep ":3000" | grep -q "0.0.0.0"; then
    echo "   ✅ 应用正在监听所有网络接口 (0.0.0.0:3000)"
elif ss -tulpn | grep ":3000" | grep -q "0.0.0.0"; then
    echo "   ✅ 应用正在监听所有网络接口 (0.0.0.0:3000)"
else
    echo "   ⚠️  应用可能仍在监听 localhost，请检查配置"
    netstat -tulpn | grep ":3000" || ss -tulpn | grep ":3000"
fi

# 测试本地访问
echo "   测试本地访问..."
if curl -s --max-time 10 http://localhost:3000 > /dev/null; then
    echo "   ✅ 本地访问正常"
else
    echo "   ❌ 本地访问失败"
fi

# 6. 安全建议
echo ""
echo "🔒 安全建议："
echo "1. 定期更新系统和应用"
echo "2. 使用强密码"
echo "3. 考虑配置 SSL 证书 (Let's Encrypt)"
echo "4. 启用应用访问日志"
echo "5. 定期备份数据"
echo "6. 限制 AI API 外网访问（如不需要）"

# 7. 显示访问信息
echo ""
echo "🎉 外网访问配置完成！"
echo "================================================="
echo ""
echo "🌐 访问地址："
echo "   HTTP:  http://$PUBLIC_IP:3000"
echo "   本地:  http://localhost:3000"
if ufw status | grep -q "11434.*ALLOW" || firewall-cmd --list-ports | grep -q "11434"; then
    echo "   AI API: http://$PUBLIC_IP:11434"
fi

echo ""
echo "👤 登录账号："
echo "   管理员: admin / password"
echo "   经理:   manager / password"
echo "   员工:   employee / password"

echo ""
echo "🔧 管理命令："
echo "   查看状态: systemctl status gas-management"
echo "   重启服务: systemctl restart gas-management"
echo "   查看日志: journalctl -u gas-management -f"
echo "   防火墙状态: ufw status 或 firewall-cmd --list-all"

echo ""
echo "⚠️  重要提醒："
echo "1. 请确保云服务商安全组已开放 3000 端口"
echo "2. 建议更改默认登录密码"
echo "3. 考虑配置域名和 SSL 证书以提高安全性"

echo ""
echo "📞 技术支持: Jy技術團隊 2025"
