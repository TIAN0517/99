#!/bin/bash
# 瓦斯管理系统 - VPS修复和启动脚本
# 解决依赖缺失问题并启动应用

set -e

echo "=== 瓦斯管理系统 - VPS修复启动 ==="
echo "开始时间: $(date)"

# 检查是否为root用户
if [ "$EUID" -eq 0 ]; then
    echo "检测到root用户，将创建专用用户运行应用..."
    
    # 创建应用用户
    if ! id "gasapp" &>/dev/null; then
        useradd -m -s /bin/bash gasapp
        echo "✓ 创建用户 gasapp"
    fi
    
    # 设置目录权限
    chown -R gasapp:gasapp /home/ubuntu/gas-management-system-ultimate-vps-20250622_150020
    
    # 切换到应用用户继续执行
    echo "切换到gasapp用户继续安装..."
    sudo -u gasapp bash << 'EOF'
#!/bin/bash
cd /home/ubuntu/gas-management-system-ultimate-vps-20250622_150020

echo "=== 第一步：安装Node.js依赖 ==="
echo "安装项目依赖..."
npm install --verbose

echo "=== 第二步：检查依赖是否安装成功 ==="
if [ -d "node_modules" ]; then
    echo "✓ node_modules 目录已创建"
    echo "已安装的依赖数量: $(ls node_modules | wc -l)"
else
    echo "✗ node_modules 目录未找到，依赖安装失败"
    exit 1
fi

echo "=== 第三步：尝试构建应用 ==="
echo "开始构建..."
npm run build || {
    echo "构建失败，尝试安装缺失的依赖..."
    npm install html-webpack-plugin webpack webpack-cli typescript @types/node @types/react @types/react-dom
    npm run build
}

echo "=== 第四步：启动应用 ==="
echo "启动Electron应用..."
npm start
EOF

else
    echo "=== 非root用户，直接安装依赖 ==="
    
    echo "=== 第一步：检查Node.js版本 ==="
    node --version
    npm --version
    
    echo "=== 第二步：清理缓存并安装依赖 ==="
    npm cache clean --force
    rm -rf node_modules package-lock.json
    npm install --verbose
    
    echo "=== 第三步：检查关键依赖 ==="
    npm list html-webpack-plugin webpack webpack-cli || {
        echo "安装缺失的构建依赖..."
        npm install html-webpack-plugin webpack webpack-cli typescript
        npm install @types/node @types/react @types/react-dom
    }
    
    echo "=== 第四步：构建应用 ==="
    npm run build
    
    echo "=== 第五步：启动应用 ==="
    npm start
fi

echo "=== 应用启动完成 ==="
echo "如果是桌面环境，Electron窗口应该已经打开"
echo "如果是服务器环境，请查看上面的日志信息"
