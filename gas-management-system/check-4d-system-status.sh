#!/bin/bash

echo "🚀 UltraModern4D系统状态检查"
echo "================================"

# 检查Electron进程
echo "📋 1. 检查Electron应用状态..."
if pgrep -f "electron" > /dev/null; then
    echo "✅ Electron应用正在运行"
    echo "进程信息:"
    ps aux | grep -v grep | grep electron | head -3
else
    echo "❌ Electron应用未运行"
    echo "建议执行: npm start"
fi

echo ""

# 检查端口状态  
echo "📋 2. 检查系统端口..."
if command -v netstat > /dev/null; then
    if netstat -tlnp 2>/dev/null | grep ":3000 " > /dev/null; then
        echo "✅ 端口3000已监听"
    else
        echo "ℹ️  端口3000未使用 (Electron应用不需要Web端口)"
    fi
else
    echo "ℹ️  netstat命令不可用，跳过端口检查"
fi

echo ""

# 检查AI服务
echo "📋 3. 检查AI助手服务..."
if command -v curl > /dev/null; then
    if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo "✅ Ollama服务正常运行"
        echo "可用模型:"
        curl -s http://localhost:11434/api/tags | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | head -4
    else
        echo "❌ Ollama服务未运行"
        echo "建议执行: ollama serve"
    fi
else
    echo "ℹ️  curl命令不可用，跳过AI服务检查"
fi

echo ""

# 检查系统资源
echo "📋 4. 检查系统资源..."
if command -v free > /dev/null; then
    echo "内存使用情况:"
    free -h | head -2
elif command -v vm_stat > /dev/null; then
    echo "内存使用情况 (macOS):"
    vm_stat | head -5
else
    echo "ℹ️  内存检查命令不可用"
fi

echo ""

# 检查文件状态
echo "📋 5. 检查关键文件..."
files_to_check=(
    "src/renderer/pages/UltraModern4D.tsx"
    "src/renderer/pages/UltraModern4D.css"
    "src/renderer/App.tsx"
    "dist/renderer/bundle.js"
)

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file 存在"
    else
        echo "❌ $file 缺失"
    fi
done

echo ""

# 提供使用建议
echo "📋 6. 使用建议..."
echo "🖥️  建议浏览器: Chrome, Edge (启用硬件加速)"
echo "📺 建议分辨率: 1920x1080或更高"
echo "⚡ 建议性能: 中等以上显卡，4GB+内存"

echo ""

# 快速操作指令
echo "🔧 快速操作指令:"
echo "================================"
echo "启动系统: npm start"
echo "重新编译: npm run build"
echo "启动AI服务: ollama serve"
echo "检查AI模型: ollama list"

echo ""

# 系统访问信息
echo "🌐 系统访问信息:"
echo "================================"
echo "Electron应用: 已自动启动桌面应用"
echo "AI助手: 点击右上角'🤖 AI助手'按钮"
echo "模块切换: 点击左侧导航栏"

echo ""

# 故障排除
echo "🆘 如遇问题:"
echo "================================"
echo "1. 界面不美观 → 检查硬件加速是否启用"
echo "2. AI不响应 → 执行 'ollama serve' 启动AI服务"
echo "3. 应用无法启动 → 执行 'npm install' 重新安装依赖"
echo "4. 编译错误 → 检查Node.js版本是否为16+"

echo ""
echo "🎉 UltraModern4D系统状态检查完成！"
echo "如有问题，请参考上述建议或查看详细文档。"
