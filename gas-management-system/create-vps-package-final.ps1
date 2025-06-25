# 瓦斯行管理系统 - VPS部署包创建脚本
# Jy技術團隊 2025

Write-Host "📦 创建VPS部署包..." -ForegroundColor Cyan
Write-Host "Jy技術團隊 2025" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Yellow

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$packageName = "gas-management-system-vps-final-$timestamp"
$packagePath = ".\$packageName"

Write-Host ""
Write-Host "正在创建部署包目录..." -ForegroundColor Blue

# 创建包目录
if (Test-Path $packagePath) {
    Remove-Item $packagePath -Recurse -Force
}
New-Item -ItemType Directory -Path $packagePath | Out-Null

# 复制主要应用文件
Write-Host "复制应用核心文件..." -ForegroundColor Blue

# 复制源代码
Copy-Item "src" -Destination "$packagePath\src" -Recurse -Force
Copy-Item "assets" -Destination "$packagePath\assets" -Recurse -Force

# 复制配置文件
Copy-Item "package.json" -Destination "$packagePath\package.json" -Force
Copy-Item "tsconfig.json" -Destination "$packagePath\tsconfig.json" -Force
Copy-Item "webpack.config.js" -Destination "$packagePath\webpack.config.js" -Force
Copy-Item "electron-builder.json" -Destination "$packagePath\electron-builder.json" -Force

Write-Host "复制外网连线配置工具..." -ForegroundColor Blue

# 复制外网连线工具
$externalAccessFiles = @(
    "external-access-manager.sh",
    "deploy-external-access.sh", 
    "configure-external-access.sh",
    "quick-external-access.sh",
    "setup-ssl-certificate.sh",
    "test-network-connectivity.sh",
    "troubleshoot-external-access.sh",
    "setup-external-access.sh",
    "check-network-config.sh"
)

foreach ($file in $externalAccessFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination "$packagePath\$file" -Force
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  未找到: $file" -ForegroundColor Yellow
    }
}

Write-Host "复制VPS部署工具..." -ForegroundColor Blue

# 复制VPS部署工具
$vpsFiles = @(
    "deploy-vps-linux.sh",
    "quick-deploy-linux.sh",
    "deploy-vps-complete.sh",
    "optimize-vps-performance.sh",
    "quick-optimize.sh",
    "docker-compose.vps.yml",
    "Dockerfile.vps"
)

foreach ($file in $vpsFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination "$packagePath\$file" -Force
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  未找到: $file" -ForegroundColor Yellow
    }
}

Write-Host "复制AI配置工具..." -ForegroundColor Blue

# 复制AI配置工具
$aiFiles = @(
    "setup-ai-for-vps.sh",
    "auto-setup-ai-model.sh",
    "diagnose-ai-connection.sh",
    "AI-MODEL-GUIDE.md"
)

foreach ($file in $aiFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination "$packagePath\$file" -Force
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  未找到: $file" -ForegroundColor Yellow
    }
}

Write-Host "复制文档文件..." -ForegroundColor Blue

# 复制文档
$docFiles = @(
    "README.md",
    "USAGE.md",
    "QUICK-START-LINUX.md",
    "LINUX-VPS-DEPLOYMENT.md",
    "VPS-DEPLOYMENT-GUIDE.md",
    "EXTERNAL-ACCESS-GUIDE.md",
    "EXTERNAL-ACCESS-TOOLS-README.md",
    "EXTERNAL-ACCESS-USAGE-GUIDE.md"
)

foreach ($file in $docFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination "$packagePath\$file" -Force
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  未找到: $file" -ForegroundColor Yellow
    }
}

# 创建部署说明文件
Write-Host "创建部署说明..." -ForegroundColor Blue

$deployInstructions = @"
# 瓦斯行管理系统 - VPS部署包
Jy技術團隊 2025

## 🚀 快速部署

### 方法一：一键自动部署 (推荐)
``````bash
# 1. 解压部署包
unzip gas-management-system-vps-final-*.zip
cd gas-management-system-vps-final-*

# 2. 设置权限并一键部署
chmod +x *.sh && sudo ./deploy-external-access.sh
``````

### 方法二：使用管理中心
``````bash
# 1. 设置权限
chmod +x *.sh

# 2. 启动管理中心
sudo ./external-access-manager.sh
``````

### 方法三：传统部署
``````bash
# 1. 基础部署
chmod +x deploy-vps-linux.sh
sudo ./deploy-vps-linux.sh

# 2. 配置外网访问
sudo ./configure-external-access.sh
``````

## 📋 部署后步骤

1. **配置云服务商安全组**
   - 开放端口 3000 (必需)
   - 开放端口 80, 443 (SSL可选)

2. **访问系统**
   - 外网访问: http://YOUR_SERVER_IP:3000
   - 默认账号: admin / password

3. **配置SSL证书** (可选)
   ``````bash
   sudo ./setup-ssl-certificate.sh
   ``````

## 🔧 故障排除

如遇问题，运行诊断工具：
``````bash
sudo ./troubleshoot-external-access.sh
``````

## 📞 技术支持

Jy技術團隊 2025
Email: support@jytech.com

## 📖 详细文档

查看以下文档获取更多信息：
- EXTERNAL-ACCESS-USAGE-GUIDE.md - 完整使用指南
- LINUX-VPS-DEPLOYMENT.md - Linux VPS 部署详解
- VPS-DEPLOYMENT-GUIDE.md - VPS 部署指南
"@

$deployInstructions | Out-File -FilePath "$packagePath\DEPLOY-INSTRUCTIONS.md" -Encoding UTF8

# 创建权限设置脚本
Write-Host "创建权限设置脚本..." -ForegroundColor Blue

$permissionScript = @"
#!/bin/bash
# 设置所有脚本执行权限
echo "设置脚本执行权限..."
chmod +x *.sh
echo "✅ 权限设置完成"
echo "现在可以运行: sudo ./deploy-external-access.sh"
"@

$permissionScript | Out-File -FilePath "$packagePath\setup-permissions.sh" -Encoding UTF8

# 创建启动脚本
$startScript = @"
#!/bin/bash
# 瓦斯行管理系统启动脚本
echo "🚀 启动瓦斯行管理系统..."

# 设置环境变量
export NODE_ENV=production
export DISPLAY=:99

# 启动虚拟显示
if ! pgrep -f "Xvfb :99" > /dev/null; then
    echo "启动虚拟显示..."
    Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
    sleep 2
fi

# 安装依赖
if [ ! -d "node_modules" ]; then
    echo "安装依赖..."
    npm install --production
fi

# 启动应用
echo "启动应用..."
npm start
"@

$startScript | Out-File -FilePath "$packagePath\start.sh" -Encoding UTF8

# 创建环境配置文件
Write-Host "创建环境配置..." -ForegroundColor Blue

$envConfig = @"
# 瓦斯行管理系统环境配置
# Jy技術團隊 2025

NODE_ENV=production
APP_HOST=0.0.0.0
APP_PORT=3000
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=gemma:2b
DISPLAY=:99
COMPANY_NAME=Jy技術團隊
APP_YEAR=2025

# AI配置
AI_TIMEOUT=30000
AI_RETRY_ATTEMPTS=3

# 安全配置
CORS_ORIGIN=*
TRUST_PROXY=true
SECURE_HEADERS=true
"@

$envConfig | Out-File -FilePath "$packagePath\.env" -Encoding UTF8

Write-Host ""
Write-Host "压缩部署包..." -ForegroundColor Blue

# 压缩成ZIP文件
$zipPath = ".\$packageName.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

try {
    Compress-Archive -Path $packagePath -DestinationPath $zipPath -CompressionLevel Optimal
    Write-Host ""
    Write-Host "✅ VPS部署包创建成功！" -ForegroundColor Green
    Write-Host ""
    Write-Host "📦 部署包信息:" -ForegroundColor Cyan
    Write-Host "   文件名: $packageName.zip" -ForegroundColor White
    Write-Host "   大小: $([math]::Round((Get-Item $zipPath).Length / 1MB, 2)) MB" -ForegroundColor White
    Write-Host "   位置: $(Get-Location)\$packageName.zip" -ForegroundColor White
    Write-Host ""
    
    # 显示包内容摘要
    $fileCount = (Get-ChildItem $packagePath -Recurse -File).Count
    Write-Host "📋 包含内容:" -ForegroundColor Cyan
    Write-Host "   总文件数: $fileCount" -ForegroundColor White
    Write-Host "   ✅ 应用源代码" -ForegroundColor Green
    Write-Host "   ✅ 外网连线配置工具" -ForegroundColor Green
    Write-Host "   ✅ VPS部署脚本" -ForegroundColor Green
    Write-Host "   ✅ AI配置工具" -ForegroundColor Green
    Write-Host "   ✅ 完整文档" -ForegroundColor Green
    Write-Host "   ✅ 一键部署脚本" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "🚀 部署说明:" -ForegroundColor Yellow
    Write-Host "1. 上传 $packageName.zip 到VPS服务器" -ForegroundColor White
    Write-Host "2. 解压: unzip $packageName.zip" -ForegroundColor White
    Write-Host "3. 进入目录: cd $packageName" -ForegroundColor White
    Write-Host "4. 一键部署: chmod +x *.sh && sudo ./deploy-external-access.sh" -ForegroundColor White
    Write-Host ""
    Write-Host "🌐 部署后访问: http://YOUR_SERVER_IP:3000" -ForegroundColor Green
    Write-Host "👤 默认账号: admin / password" -ForegroundColor Green
    Write-Host ""
    
    # 清理临时目录
    Remove-Item $packagePath -Recurse -Force
    
    Write-Host "🎉 准备就绪！可以传输到VPS了！" -ForegroundColor Green
    Write-Host "🔧 Jy技術團隊 2025 - 专业瓦斯行管理解决方案" -ForegroundColor Blue
    
} catch {
    Write-Host "❌ 压缩失败: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
