#!/bin/bash
# VPS连接问题诊断和修复脚本

echo "🔍 VPS连接问题诊断和修复"
echo "================================"

# 1. 检查服务是否正在运行
echo "📋 1. 检查服务状态..."
if pgrep -f "node.*gas" > /dev/null; then
    echo "✅ Node.js服务正在运行"
    echo "进程信息:"
    ps aux | grep -v grep | grep "node.*gas"
else
    echo "❌ Node.js服务未运行"
fi

# 2. 检查端口是否开放
echo ""
echo "📋 2. 检查端口状态..."
PORT=3000
if netstat -tlnp | grep ":$PORT " > /dev/null 2>&1; then
    echo "✅ 端口 $PORT 正在监听"
    netstat -tlnp | grep ":$PORT "
else
    echo "❌ 端口 $PORT 未开放"
fi

# 3. 检查防火墙状态
echo ""
echo "📋 3. 检查防火墙状态..."
if command -v ufw > /dev/null; then
    echo "UFW 防火墙状态:"
    ufw status
    
    echo ""
    echo "🔧 配置防火墙..."
    ufw allow 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw allow 3000/tcp
    echo "y" | ufw enable
    
    echo "✅ 防火墙已配置"
else
    echo "UFW 未安装，检查 iptables..."
    if command -v iptables > /dev/null; then
        iptables -L -n | grep -E "(3000|ACCEPT|DROP)"
    fi
fi

# 4. 检查网络接口
echo ""
echo "📋 4. 检查网络接口..."
echo "本机IP地址:"
ip addr show | grep -E "inet.*global" | awk '{print $2}' | cut -d'/' -f1

echo ""
echo "公网IP地址:"
PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "无法获取")
echo "$PUBLIC_IP"

# 5. 测试本地连接
echo ""
echo "📋 5. 测试本地连接..."
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ 本地连接正常"
else
    echo "❌ 本地连接失败"
fi

# 6. 检查服务绑定地址
echo ""
echo "📋 6. 检查服务绑定..."
if netstat -tlnp | grep ":3000 " | grep "0.0.0.0"; then
    echo "✅ 服务已绑定到 0.0.0.0:3000 (允许外部访问)"
elif netstat -tlnp | grep ":3000 " | grep "127.0.0.1"; then
    echo "❌ 服务只绑定到 127.0.0.1:3000 (仅本地访问)"
    echo "需要修改服务配置，绑定到 0.0.0.0"
else
    echo "❌ 端口3000未监听"
fi

# 7. 云服务商安全组检查提醒
echo ""
echo "📋 7. 云服务商安全组检查"
echo "⚠️  请检查云服务商控制台的安全组设置:"
echo "   - 阿里云: ECS -> 安全组 -> 添加规则"
echo "   - 腾讯云: CVM -> 安全组 -> 添加规则"
echo "   - AWS: EC2 -> Security Groups"
echo "   - 其他: 确保端口3000对外开放"

# 8. 生成快速修复命令
echo ""
echo "🔧 快速修复命令:"
echo "================================"
echo "# 停止现有服务"
echo "pkill -f 'node.*gas'"
echo ""
echo "# 创建正确配置的服务"
cat << 'FIXEOF'
cat > gas-web-fixed.js << 'EOF'
const express = require('express');
const app = express();
const PORT = 3000;

// 确保绑定到所有网络接口
app.listen(PORT, '0.0.0.0', () => {
    console.log('🔥 瓦斯管理系统已启动');
    console.log('📍 本地访问: http://localhost:' + PORT);
    console.log('🌐 外部访问: http://YOUR_SERVER_IP:' + PORT);
});

app.get('/', (req, res) => {
    res.send('<h1>🔥 瓦斯管理系统</h1><p>系统运行正常</p>');
});

app.get('/api/products', (req, res) => {
    res.json([{name: '测试产品', status: '正常'}]);
});
EOF

node gas-web-fixed.js
FIXEOF

echo ""
echo "🌐 访问测试:"
echo "================================"
echo "本地测试: curl http://localhost:3000"
echo "外部访问: http://$PUBLIC_IP:3000"

echo ""
echo "📞 如果仍无法访问，请检查:"
echo "1. 云服务商安全组是否开放端口3000"
echo "2. VPS提供商是否有额外的防火墙限制"
echo "3. 网络是否正常"
