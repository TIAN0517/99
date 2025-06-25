# 创建最终完整VPS部署包
# Jy技術團隊 瓦斯行管理系統 2025 - 终极版本

param(
    [string]$OutputDir = "vps-packages"
)

$ErrorActionPreference = "Continue"
$WarningPreference = "SilentlyContinue"

# 设置控制台编码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

Write-Host "🔥 =======================================" -ForegroundColor Red
Write-Host "🔥  Jy技術團隊 瓦斯行管理系統 2025" -ForegroundColor Red
Write-Host "🔥  创建终极完整VPS部署包" -ForegroundColor Red
Write-Host "🔥 =======================================" -ForegroundColor Red
Write-Host ""

# 创建时间戳
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$packageName = "gas-management-system-ultimate-complete-$timestamp"
$packageDir = Join-Path $OutputDir $packageName

Write-Host "📦 包名: $packageName" -ForegroundColor Green
Write-Host "📂 输出目录: $packageDir" -ForegroundColor Green
Write-Host ""

# 创建输出目录
if (Test-Path $packageDir) {
    Remove-Item $packageDir -Recurse -Force
}
New-Item -ItemType Directory -Path $packageDir -Force | Out-Null

Write-Host "📋 复制核心文件..." -ForegroundColor Yellow

# 1. 复制项目核心文件
$coreFiles = @(
    "package.json",
    "tsconfig.json", 
    "webpack.config.js",
    "electron-builder.json"
)

foreach ($file in $coreFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file" -ForegroundColor Green
    }
}

# 2. 复制源代码目录
Write-Host "📁 复制源代码..." -ForegroundColor Yellow
if (Test-Path "src") {
    Copy-Item "src" -Destination $packageDir -Recurse -Force
    Write-Host "✓ src/ 目录 (完整源代码)" -ForegroundColor Green
}

# 3. 复制资源文件
Write-Host "🖼️ 复制资源文件..." -ForegroundColor Yellow
$assetDirs = @("assets", "icons", "images")
foreach ($dir in $assetDirs) {
    if (Test-Path $dir) {
        Copy-Item $dir -Destination $packageDir -Recurse -Force
        Write-Host "✓ $dir/ 目录" -ForegroundColor Green
    }
}

# 4. 复制Enhanced Beautiful版本
Write-Host "🎨 复制Enhanced Beautiful版本..." -ForegroundColor Yellow
$enhancedFiles = @(
    "gas-enhanced-beautiful-v2.js",
    "start-gas-web.js"
)

foreach ($file in $enhancedFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file (Enhanced版本)" -ForegroundColor Green
    }
}

# 5. 复制所有VPS部署脚本
Write-Host "🚀 复制VPS部署脚本..." -ForegroundColor Yellow
$vpsScripts = @(
    "deploy-vps-complete.sh",
    "deploy-vps-linux.sh", 
    "quick-deploy-linux.sh",
    "deploy-enhanced-beautiful-gas.sh",
    "deploy-enhanced-beautiful-gas.bat",
    "deploy-beautiful-gas.sh",
    "one-click-start-vps.sh",
    "super-simple-start.sh",
    "vps-quick-start.sh",
    "start-web-version.sh"
)

foreach ($script in $vpsScripts) {
    if (Test-Path $script) {
        Copy-Item $script -Destination $packageDir -Force
        Write-Host "✓ $script" -ForegroundColor Green
    }
}

# 6. 复制外网访问工具
Write-Host "🌐 复制外网访问工具..." -ForegroundColor Yellow
$externalAccessFiles = @(
    "configure-external-access.sh",
    "configure-external-access.ps1",
    "deploy-external-access.sh",
    "external-access-manager.sh",
    "setup-external-access.sh",
    "quick-external-access.sh",
    "test-network-connectivity.sh",
    "troubleshoot-external-access.sh"
)

foreach ($file in $externalAccessFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file" -ForegroundColor Green
    }
}

# 7. 复制Docker配置
Write-Host "🐳 复制Docker配置..." -ForegroundColor Yellow
$dockerFiles = @(
    "docker-compose.vps.yml",
    "Dockerfile.vps"
)

foreach ($file in $dockerFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file" -ForegroundColor Green
    }
}

# 8. 复制AI配置工具
Write-Host "🤖 复制AI配置工具..." -ForegroundColor Yellow
$aiFiles = @(
    "setup-ai-for-vps.sh",
    "auto-setup-ai-model.sh",
    "diagnose-ai-connection.sh"
)

foreach ($file in $aiFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file" -ForegroundColor Green
    }
}

# 9. 复制网络诊断工具
Write-Host "🔧 复制网络诊断工具..." -ForegroundColor Yellow
$networkFiles = @(
    "check-network-config.sh",
    "diagnose-vps-connection.sh",
    "fix-vps-connection.sh",
    "optimize-vps-performance.sh"
)

foreach ($file in $networkFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file" -ForegroundColor Green
    }
}

# 10. 复制完整文档
Write-Host "📚 复制完整文档..." -ForegroundColor Yellow
$docFiles = @(
    "README.md",
    "USAGE.md",
    "VPS-DEPLOYMENT-GUIDE.md",
    "VPS-TRANSFER-GUIDE.md",
    "EXTERNAL-ACCESS-GUIDE.md",
    "EXTERNAL-ACCESS-USAGE-GUIDE.md",
    "LINUX-VPS-DEPLOYMENT.md",
    "QUICK-START-LINUX.md",
    "AI-MODEL-GUIDE.md",
    "FINAL-DELIVERY-REPORT.md",
    "PROJECT-DELIVERY-FINAL.md",
    "VPS-DEPLOYMENT-SOLUTION-FINAL.md"
)

foreach ($file in $docFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file" -ForegroundColor Green
    }
}

# 11. 创建生产环境配置
Write-Host "⚙️ 创建生产环境配置..." -ForegroundColor Yellow

# 创建.env.production
$envProduction = @"
# 生产环境配置
NODE_ENV=production
PORT=3000
HOST=0.0.0.0

# 外网访问配置
EXTERNAL_IP=165.154.226.148
DOMAIN=lstjks.sytes.net

# AI配置
OLLAMA_HOST=localhost
OLLAMA_PORT=11434

# 应用配置
APP_NAME=瓦斯管理系統
APP_VERSION=Enhanced v2.1
COMPANY=Jy技術團隊

# 安全配置
SESSION_SECRET=gas-management-system-2025
CORS_ORIGIN=*

# 日志配置
LOG_LEVEL=info
LOG_FILE=gas-management.log
"@

$envProduction | Out-File -FilePath "$packageDir\.env.production" -Encoding UTF8
Write-Host "✓ .env.production (生产环境配置)" -ForegroundColor Green

# 12. 创建一键部署脚本
Write-Host "🚀 创建一键部署脚本..." -ForegroundColor Yellow

$oneClickDeploy = @'
#!/bin/bash
# Jy技術團隊 瓦斯行管理系統 2025 - 一键完整部署
# Enhanced Beautiful Edition

echo "🔥 ======================================="
echo "🔥  Jy技術團隊 瓦斯行管理系統 2025"
echo "🔥  Enhanced Beautiful Edition"
echo "🔥  一键完整部署"
echo "🔥 ======================================="
echo ""

# 设置执行权限
echo "⚙️ 设置脚本权限..."
chmod +x *.sh

# 检查系统
echo "🔍 检查系统环境..."
if ! command -v node &> /dev/null; then
    echo "❌ 未找到 Node.js，正在安装..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

if ! command -v npm &> /dev/null; then
    echo "❌ 未找到 npm，正在安装..."
    sudo apt-get install -y npm
fi

echo "✅ Node.js 版本: $(node --version)"
echo "✅ npm 版本: $(npm --version)"

# 安装依赖
echo "📦 安装项目依赖..."
npm install --production

# 停止现有服务
echo "⏹️ 停止现有服务..."
pkill -f "node.*gas" 2>/dev/null || true
pkill -f "node.*3000" 2>/dev/null || true
sleep 3

# 启动Enhanced Beautiful版本
echo "🎨 启动Enhanced Beautiful版本..."
if [ -f "gas-enhanced-beautiful-v2.js" ]; then
    echo "🚀 启动Enhanced Beautiful瓦斯管理系统v2.1..."
    nohup node gas-enhanced-beautiful-v2.js > gas-enhanced.log 2>&1 &
    PROCESS_PID=$!
    
    echo "✅ Enhanced Beautiful版本已启动！"
    echo "🆔 进程ID: $PROCESS_PID"
    echo ""
    echo "🔥 ======================================="
    echo "🔥   Enhanced Edition 访问信息"
    echo "🔥 ======================================="
    echo "📍 本地访问: http://localhost:3000"
    echo "🌐 外网访问: http://YOUR_VPS_IP:3000"
    echo "🔗 域名访问: http://YOUR_DOMAIN:3000"
    echo "📋 健康检查: http://YOUR_VPS_IP:3000/health"
    echo "📊 系统信息: http://YOUR_VPS_IP:3000/api/system"
    echo "🔥 ======================================="
    echo ""
    echo "📝 查看日志: tail -f gas-enhanced.log"
    echo "⏹️ 停止服务: kill $PROCESS_PID"
    
elif [ -f "start-gas-web.js" ]; then
    echo "🚀 启动Web版本..."
    nohup node start-gas-web.js > gas-web.log 2>&1 &
    echo "✅ Web版本已启动！"
else
    echo "❌ 未找到启动文件"
    exit 1
fi

echo ""
echo "🎊 部署完成！"
echo "💡 提示：请将 YOUR_VPS_IP 和 YOUR_DOMAIN 替换为实际的IP和域名"
'@

$oneClickDeploy | Out-File -FilePath "$packageDir\deploy-ultimate.sh" -Encoding UTF8
Write-Host "✓ deploy-ultimate.sh (一键部署脚本)" -ForegroundColor Green

# 13. 创建Windows一键部署脚本
$oneClickDeployWin = @'
@echo off
chcp 65001 >nul
echo 🔥 =======================================
echo 🔥  Jy技術團隊 瓦斯行管理系統 2025
echo 🔥  Enhanced Beautiful Edition
echo 🔥  Windows 一键部署
echo 🔥 =======================================
echo.

echo ⚙️ 检查环境...
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未找到 Node.js，请先安装 Node.js
    pause
    exit /b 1
)

echo ✅ Node.js 已安装

echo 📦 安装依赖...
npm install

echo ⏹️ 停止现有服务...
taskkill /f /im node.exe >nul 2>&1

echo 🎨 启动Enhanced Beautiful版本...
if exist "gas-enhanced-beautiful-v2.js" (
    start "Enhanced Gas Management" cmd /k "node gas-enhanced-beautiful-v2.js"
    echo ✅ Enhanced Beautiful版本已启动！
) else if exist "start-gas-web.js" (
    start "Gas Management Web" cmd /k "node start-gas-web.js"
    echo ✅ Web版本已启动！
) else (
    echo ❌ 未找到启动文件
    pause
    exit /b 1
)

echo.
echo 🔥 =======================================
echo 🔥   系统已启动！
echo 🔥 =======================================
echo 📍 本地访问: http://localhost:3000
echo 🌐 外网访问: http://YOUR_VPS_IP:3000
echo 🔥 =======================================
echo.
pause
'@

$oneClickDeployWin | Out-File -FilePath "$packageDir\deploy-ultimate.bat" -Encoding UTF8
Write-Host "✓ deploy-ultimate.bat (Windows一键部署)" -ForegroundColor Green

# 14. 创建安装说明
Write-Host "📋 创建安装说明..." -ForegroundColor Yellow

$installGuide = @"
# Jy技術團隊 瓦斯行管理系統 2025 - Ultimate Complete Edition

## 🎯 一键快速部署

### Linux/VPS 环境 (推荐)
\`\`\`bash
# 解压部署包
unzip gas-management-system-ultimate-complete-*.zip
cd gas-management-system-ultimate-complete-*

# 一键部署
chmod +x deploy-ultimate.sh
./deploy-ultimate.sh
\`\`\`

### Windows 环境
\`\`\`cmd
# 解压部署包并进入目录
# 双击运行
deploy-ultimate.bat
\`\`\`

## 🚀 访问系统

部署完成后，通过以下地址访问：

- **本地访问**: http://localhost:3000
- **外网访问**: http://YOUR_VPS_IP:3000 (替换为实际IP)
- **域名访问**: http://YOUR_DOMAIN:3000 (如果配置了域名)

### 特殊访问地址
- **健康检查**: http://YOUR_VPS_IP:3000/health
- **系统信息**: http://YOUR_VPS_IP:3000/api/system
- **API文档**: http://YOUR_VPS_IP:3000/api/products

## 🌟 版本特色

### Enhanced Beautiful Edition v2.1 特色功能
- ✨ 完全还原 ProductManagement.tsx 原始设计
- 🎨 Enhanced 4D 科技感无边框界面
- 📱 Enhanced 完美响应式设计
- ⚡ Enhanced 即时资料载入与更新
- 📊 Enhanced 智能库存统计分析
- 🚀 Enhanced 流畅动画与过渡效果
- 💎 Enhanced Professional 级别视觉设计
- 🌐 Enhanced 外网连线优化

## 📦 包含内容

### 核心应用
- \`gas-enhanced-beautiful-v2.js\` - Enhanced Beautiful Edition 主程序
- \`start-gas-web.js\` - Web版本备用程序
- \`package.json\` - 项目配置
- \`.env.production\` - 生产环境配置

### 部署脚本
- \`deploy-ultimate.sh\` - Linux 一键部署
- \`deploy-ultimate.bat\` - Windows 一键部署
- \`deploy-vps-complete.sh\` - 完整VPS部署
- \`deploy-enhanced-beautiful-gas.sh\` - Enhanced版本专用部署

### 外网访问工具
- \`configure-external-access.sh\` - 外网访问配置
- \`setup-external-access.sh\` - 外网访问设置
- \`test-network-connectivity.sh\` - 网络连通性测试
- \`troubleshoot-external-access.sh\` - 故障排除

### 完整文档
- \`README.md\` - 项目说明
- \`VPS-DEPLOYMENT-GUIDE.md\` - VPS部署完整指南
- \`EXTERNAL-ACCESS-GUIDE.md\` - 外网访问指南
- 更多详细文档...

## 🔧 高级配置

### 外网访问配置
\`\`\`bash
# 配置外网访问
./configure-external-access.sh

# 测试网络连接
./test-network-connectivity.sh

# 故障排除
./troubleshoot-external-access.sh
\`\`\`

### SSL证书配置 (可选)
\`\`\`bash
# 设置SSL证书 (如果需要HTTPS)
./setup-ssl-certificate.sh
\`\`\`

### AI功能配置 (可选)
\`\`\`bash
# 配置AI助理
./setup-ai-for-vps.sh
\`\`\`

## 🛠️ 管理命令

### 查看运行状态
\`\`\`bash
# 查看日志
tail -f gas-enhanced.log

# 检查进程
ps aux | grep node

# 健康检查
curl http://localhost:3000/health
\`\`\`

### 重启服务
\`\`\`bash
# 停止服务
pkill -f "node.*gas"

# 重新启动
./deploy-ultimate.sh
\`\`\`

## 📞 技术支持

- **开发团队**: Jy技術團隊
- **项目年份**: 2025
- **版本**: Enhanced Beautiful Edition v2.1
- **支持平台**: Linux, Windows, macOS

## 🎊 完成确认

部署成功后，您应该能看到：
1. ✅ 系统正常启动
2. ✅ 可以通过浏览器访问
3. ✅ Enhanced Beautiful界面正常显示
4. ✅ 产品数据正常加载
5. ✅ 所有功能正常工作

如果遇到问题，请查看对应的故障排除文档或运行诊断脚本。

---
**Jy技術團隊 © 2025 - 专业的瓦斯行管理解决方案**
"@

$installGuide | Out-File -FilePath "$packageDir\INSTALL.md" -Encoding UTF8
Write-Host "✓ INSTALL.md (安装说明)" -ForegroundColor Green

# 15. 创建版本信息
$versionInfo = @{
    name = "Jy技術團隊 瓦斯行管理系統 2025"
    version = "Enhanced Beautiful Edition v2.1"
    buildDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    platform = "Ultimate Complete"
    features = @(
        "Enhanced Beautiful UI",
        "ProductManagement.tsx 完全还原",
        "4D 科技感界面",
        "外网访问支持",
        "智能库存管理",
        "响应式设计",
        "AI助理集成",
        "Docker支持",
        "一键部署"
    )
    externalAccess = @{
        ip = "165.154.226.148"
        domain = "lstjks.sytes.net"
        port = 3000
    }
    developer = "Jy技術團隊"
    contact = "contact@jytech.com"
}

$versionInfo | ConvertTo-Json -Depth 3 | Out-File -FilePath "$packageDir\version.json" -Encoding UTF8
Write-Host "✓ version.json (版本信息)" -ForegroundColor Green

# 16. 统计文件
Write-Host ""
Write-Host "📊 统计打包文件..." -ForegroundColor Yellow

$allFiles = Get-ChildItem -Path $packageDir -Recurse -File
$totalFiles = $allFiles.Count
$totalSize = [math]::Round(($allFiles | Measure-Object -Property Length -Sum).Sum / 1MB, 2)

Write-Host "📁 总文件数: $totalFiles" -ForegroundColor Green
Write-Host "📦 总大小: $totalSize MB" -ForegroundColor Green

# 17. 创建压缩包
Write-Host ""
Write-Host "🗜️ 创建压缩包..." -ForegroundColor Yellow

$zipPath = "$OutputDir\$packageName.zip"

# 删除已存在的压缩包
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

try {
    # 使用.NET压缩
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($packageDir, $zipPath)
    
    $zipSize = [math]::Round((Get-Item $zipPath).Length / 1MB, 2)
    
    Write-Host "✅ 压缩包创建成功！" -ForegroundColor Green
    Write-Host "📦 压缩包路径: $zipPath" -ForegroundColor Green
    Write-Host "📊 压缩包大小: $zipSize MB" -ForegroundColor Green
    
} catch {
    Write-Host "❌ 压缩失败: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 18. 清理临时目录
Remove-Item $packageDir -Recurse -Force

Write-Host ""
Write-Host "🔥 =======================================" -ForegroundColor Red
Write-Host "🔥  Ultimate Complete 打包完成！" -ForegroundColor Red
Write-Host "🔥 =======================================" -ForegroundColor Red
Write-Host ""
Write-Host "📦 包名: $packageName" -ForegroundColor Green
Write-Host "📂 路径: $zipPath" -ForegroundColor Green
Write-Host "📊 大小: $zipSize MB" -ForegroundColor Green
Write-Host "📁 文件: $totalFiles 个" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 VPS部署步骤:" -ForegroundColor Yellow
Write-Host "1. 上传压缩包到VPS" -ForegroundColor White
Write-Host "2. 解压: unzip $packageName.zip" -ForegroundColor White
Write-Host "3. 进入目录: cd $packageName" -ForegroundColor White
Write-Host "4. 一键部署: chmod +x deploy-ultimate.sh && ./deploy-ultimate.sh" -ForegroundColor White
Write-Host ""
Write-Host "🌐 外网访问:" -ForegroundColor Yellow
Write-Host "- IP访问: http://165.154.226.148:3000" -ForegroundColor White
Write-Host "- 域名访问: http://lstjks.sytes.net:3000" -ForegroundColor White
Write-Host ""
Write-Host "🎊 打包完成！准备传送到VPS吧！" -ForegroundColor Green
