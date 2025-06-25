#!/bin/bash

echo "🌐 Jy技術團隊 瓦斯行管理系統 2025 - 外网连接配置"
echo "=================================================="

# 获取服务器信息
echo "🖥️  服务器信息:"
echo "内网 IP: $(hostname -I | awk '{print $1}')"
echo "外网 IP: $(curl -s --max-time 10 ifconfig.me 2>/dev/null || curl -s --max-time 10 ipinfo.io/ip 2>/dev/null || echo '获取失败')"
echo "主机名: $(hostname)"

# 检查当前监听端口
echo ""
echo "📊 当前监听端口:"
netstat -tulpn | grep -E ':3000|:11434' || ss -tulpn | grep -E ':3000|:11434'

# 检查防火墙状态
echo ""
echo "🔥 防火墙状态:"
if command -v ufw &> /dev/null; then
    echo "UFW 状态:"
    ufw status
elif command -v firewall-cmd &> /dev/null; then
    echo "Firewalld 状态:"
    firewall-cmd --list-all
else
    echo "⚠️  未检测到常见防火墙工具"
fi

# 检查应用服务状态
echo ""
echo "⚙️  应用服务状态:"
if systemctl is-active --quiet gas-management; then
    echo "✅ 瓦斯管理系統服务正在运行"
else
    echo "❌ 瓦斯管理系統服务未运行"
fi

# 检查 Docker 容器
echo ""
echo "🐳 Docker 容器状态:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(ollama|gas)"

# 检测应用配置
echo ""
echo "📋 应用配置:"
if [ -f ".env" ]; then
    echo "配置文件存在，当前端口配置:"
    grep APP_PORT .env || echo "APP_PORT=3000 (默认)"
else
    echo "⚠️  配置文件不存在"
fi

echo ""
echo "🛠️  外网访问配置建议:"
echo "1. 确保防火墙开放端口 3000"
echo "2. 配置应用监听所有网络接口 (0.0.0.0)"
echo "3. 检查云服务商安全组设置"
echo "4. 可选：配置域名和 SSL 证书"
