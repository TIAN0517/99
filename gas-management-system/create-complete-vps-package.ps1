# 瓦斯行管理系统 - 完整VPS部署包创建脚本
# Jy技術團隊 2025

Write-Host "📦 创建完整VPS部署包..." -ForegroundColor Cyan
Write-Host "Jy技術團隊 2025" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Yellow

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$packageName = "gas-management-system-complete-vps-$timestamp"
$packagePath = ".\$packageName"

Write-Host ""
Write-Host "正在创建完整部署包目录..." -ForegroundColor Blue

# 创建包目录
if (Test-Path $packagePath) {
    Remove-Item $packagePath -Recurse -Force
}
New-Item -ItemType Directory -Path $packagePath | Out-Null

Write-Host "复制完整应用文件..." -ForegroundColor Blue

# 复制整个src目录（包含所有源代码）
if (Test-Path "src") {
    Copy-Item "src" -Destination "$packagePath\src" -Recurse -Force
    Write-Host "  ✅ 源代码目录 (src/)" -ForegroundColor Green
} else {
    Write-Host "  ❌ 未找到 src 目录" -ForegroundColor Red
}

# 复制assets目录
if (Test-Path "assets") {
    Copy-Item "assets" -Destination "$packagePath\assets" -Recurse -Force
    Write-Host "  ✅ 资源目录 (assets/)" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  未找到 assets 目录" -ForegroundColor Yellow
}

# 复制核心配置文件
$configFiles = @(
    "package.json",
    "tsconfig.json", 
    "webpack.config.js",
    "electron-builder.json"
)

foreach ($file in $configFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination "$packagePath\$file" -Force
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  未找到: $file" -ForegroundColor Yellow
    }
}

Write-Host "复制外网连线配置工具..." -ForegroundColor Blue

# 复制所有外网连线工具
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

# 复制所有重要文档
$docFiles = @(
    "README.md",
    "USAGE.md",
    "QUICK-START-LINUX.md",
    "LINUX-VPS-DEPLOYMENT.md",
    "VPS-DEPLOYMENT-GUIDE.md",
    "EXTERNAL-ACCESS-GUIDE.md",
    "EXTERNAL-ACCESS-TOOLS-README.md",
    "EXTERNAL-ACCESS-USAGE-GUIDE.md",
    "VPS-TRANSFER-GUIDE.md"
)

foreach ($file in $docFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination "$packagePath\$file" -Force
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  未找到: $file" -ForegroundColor Yellow
    }
}

# 创建完整的部署说明
Write-Host "创建完整部署说明..." -ForegroundColor Blue

$deployInstructions = @"
# 瓦斯行管理系统 - 完整VPS部署包
Jy技術團隊 2025

## 🚀 一键完整部署

### 方法一：超级快速部署 (推荐)
``````bash
# 1. 解压部署包
unzip gas-management-system-complete-vps-*.zip
cd gas-management-system-complete-vps-*

# 2. 一键部署（包含应用和外网配置）
chmod +x *.sh && sudo ./deploy-external-access.sh
``````

### 方法二：分步部署
``````bash
# 1. 设置权限
chmod +x *.sh

# 2. 安装依赖和构建应用
sudo ./deploy-vps-linux.sh

# 3. 配置外网访问
sudo ./configure-external-access.sh

# 4. 可选：配置SSL证书
sudo ./setup-ssl-certificate.sh
``````

## 📋 包含内容

本部署包包含：
- ✅ 完整的React/TypeScript源代码
- ✅ 所有页面组件 (ProductManagement.tsx等)
- ✅ 外网连线配置工具
- ✅ VPS优化脚本
- ✅ AI配置工具
- ✅ 完整文档

## 🌐 部署后访问

- **外网访问**: http://YOUR_SERVER_IP:3000
- **默认账号**: admin / password

## 💡 重要提醒

1. **云服务商安全组**: 必须开放端口 3000
2. **更改密码**: 首次登录后立即更改
3. **SSL配置**: 推荐配置HTTPS安全访问

## 🔧 故障排除

如遇问题：
``````bash
sudo ./troubleshoot-external-access.sh
``````

## 📞 技术支持

Jy技術團隊 2025  
Email: support@jytech.com
"@

$deployInstructions | Out-File -FilePath "$packagePath\COMPLETE-DEPLOY-GUIDE.md" -Encoding UTF8

# 创建启动脚本
$startScript = @"
#!/bin/bash
# 瓦斯行管理系统完整启动脚本
echo "🚀 瓦斯行管理系统启动..."

# 设置环境变量
export NODE_ENV=production
export DISPLAY=:99
export APP_HOST=0.0.0.0
export APP_PORT=3000

# 启动虚拟显示
if ! pgrep -f "Xvfb :99" > /dev/null; then
    echo "启动虚拟显示..."
    Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
    sleep 2
fi

# 检查Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js 未安装，请先安装 Node.js"
    exit 1
fi

# 安装依赖
if [ ! -d "node_modules" ]; then
    echo "📦 安装依赖..."
    npm install --production
fi

# 构建应用（如果需要）
if [ ! -d "dist" ]; then
    echo "🔨 构建应用..."
    npm run build:linux
fi

# 启动应用
echo "✅ 启动瓦斯行管理系统..."
npm start
"@

$startScript | Out-File -FilePath "$packagePath\start-complete.sh" -Encoding UTF8

# 创建环境配置
$envConfig = @"
# 瓦斯行管理系统 - 生产环境配置
# Jy技術團隊 2025

NODE_ENV=production
APP_HOST=0.0.0.0
APP_PORT=3000

# AI配置
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=gemma:2b
AI_TIMEOUT=30000
AI_RETRY_ATTEMPTS=3

# 显示配置
DISPLAY=:99
XVFB_ARGS="-screen 0 1024x768x24"

# 公司信息
COMPANY_NAME=Jy技術團隊
APP_YEAR=2025

# 安全配置
CORS_ORIGIN=*
TRUST_PROXY=true
SECURE_HEADERS=true
SESSION_SECRET=\$(openssl rand -base64 32 2>/dev/null || echo "default-secret-key")
"@

$envConfig | Out-File -FilePath "$packagePath\.env.production" -Encoding UTF8

Write-Host ""
Write-Host "检查包大小..." -ForegroundColor Blue

# 计算目录大小
$dirSize = (Get-ChildItem $packagePath -Recurse | Measure-Object -Property Length -Sum).Sum
$sizeInMB = [math]::Round($dirSize / 1MB, 2)

Write-Host "  包大小: $sizeInMB MB" -ForegroundColor White
Write-Host "  文件数: $((Get-ChildItem $packagePath -Recurse -File).Count)" -ForegroundColor White

if ($sizeInMB -lt 1) {
    Write-Host "  ⚠️  包大小过小，可能缺少文件" -ForegroundColor Yellow
} else {
    Write-Host "  ✅ 包大小正常" -ForegroundColor Green
}

Write-Host ""
Write-Host "压缩完整部署包..." -ForegroundColor Blue

# 压缩成ZIP文件
$zipPath = ".\$packageName.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

try {
    Compress-Archive -Path $packagePath -DestinationPath $zipPath -CompressionLevel Optimal
    
    $finalSize = [math]::Round((Get-Item $zipPath).Length / 1MB, 2)
    
    Write-Host ""
    Write-Host "✅ 完整VPS部署包创建成功！" -ForegroundColor Green
    Write-Host ""
    Write-Host "📦 部署包信息:" -ForegroundColor Cyan
    Write-Host "   文件名: $packageName.zip" -ForegroundColor White
    Write-Host "   压缩后大小: $finalSize MB" -ForegroundColor White
    Write-Host "   压缩前大小: $sizeInMB MB" -ForegroundColor White
    Write-Host "   位置: $(Get-Location)\$packageName.zip" -ForegroundColor White
    Write-Host ""
    
    Write-Host "📋 包含完整内容:" -ForegroundColor Cyan
    Write-Host "   ✅ React/TypeScript 完整源代码" -ForegroundColor Green
    Write-Host "   ✅ ProductManagement.tsx (最新版本)" -ForegroundColor Green
    Write-Host "   ✅ 所有页面组件和样式" -ForegroundColor Green
    Write-Host "   ✅ 外网连线配置工具集" -ForegroundColor Green
    Write-Host "   ✅ VPS部署和优化脚本" -ForegroundColor Green
    Write-Host "   ✅ AI配置工具" -ForegroundColor Green
    Write-Host "   ✅ 完整文档和指南" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "🚀 VPS部署指令:" -ForegroundColor Yellow
    Write-Host "1. 上传: scp $packageName.zip root@YOUR_SERVER_IP:/opt/" -ForegroundColor White
    Write-Host "2. 解压: unzip $packageName.zip && cd $packageName" -ForegroundColor White
    Write-Host "3. 部署: chmod +x *.sh && sudo ./deploy-external-access.sh" -ForegroundColor White
    Write-Host ""
    Write-Host "🌐 访问地址: http://YOUR_SERVER_IP:3000" -ForegroundColor Green
    Write-Host "👤 默认账号: admin / password" -ForegroundColor Green
    Write-Host ""
    
    # 清理临时目录
    Remove-Item $packagePath -Recurse -Force
    
    Write-Host "🎉 完整部署包准备就绪！" -ForegroundColor Green
    Write-Host "🔧 Jy技術團隊 2025 - 这次包含了所有应用代码！" -ForegroundColor Blue
    
} catch {
    Write-Host "❌ 压缩失败: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
