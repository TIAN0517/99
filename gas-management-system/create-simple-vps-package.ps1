# 创建完整VPS部署包 - 简化版本
# Jy技術團隊 瓦斯行管理系統 2025

param(
    [string]$OutputDir = "vps-packages"
)

# 设置控制台编码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

Write-Host "🔥 =======================================" -ForegroundColor Red
Write-Host "🔥  创建完整VPS部署包" -ForegroundColor Red  
Write-Host "🔥 =======================================" -ForegroundColor Red
Write-Host ""

# 创建时间戳
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$packageName = "gas-management-ultimate-$timestamp"
$packageDir = Join-Path $OutputDir $packageName

Write-Host "📦 包名: $packageName" -ForegroundColor Green
Write-Host "📂 输出目录: $packageDir" -ForegroundColor Green

# 创建输出目录
if (Test-Path $packageDir) {
    Remove-Item $packageDir -Recurse -Force
}
New-Item -ItemType Directory -Path $packageDir -Force | Out-Null

Write-Host "📋 复制文件..." -ForegroundColor Yellow

# 1. 复制核心文件
$coreFiles = @(
    "package.json",
    "gas-enhanced-beautiful-v2.js", 
    "start-gas-web.js"
)

foreach ($file in $coreFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file" -ForegroundColor Green
    }
}

# 2. 复制源代码
if (Test-Path "src") {
    Copy-Item "src" -Destination $packageDir -Recurse -Force
    Write-Host "✓ src/ 目录" -ForegroundColor Green
}

# 3. 复制重要脚本
$scripts = @(
    "deploy-vps-complete.sh",
    "deploy-enhanced-beautiful-gas.sh",
    "configure-external-access.sh", 
    "setup-external-access.sh"
)

foreach ($script in $scripts) {
    if (Test-Path $script) {
        Copy-Item $script -Destination $packageDir -Force
        Write-Host "✓ $script" -ForegroundColor Green
    }
}

# 4. 复制文档
$docs = @(
    "README.md",
    "VPS-DEPLOYMENT-GUIDE.md",
    "EXTERNAL-ACCESS-GUIDE.md"
)

foreach ($doc in $docs) {
    if (Test-Path $doc) {
        Copy-Item $doc -Destination $packageDir -Force
        Write-Host "✓ $doc" -ForegroundColor Green
    }
}

# 5. 创建环境配置
$env = @"
NODE_ENV=production
PORT=3000
HOST=0.0.0.0
EXTERNAL_IP=165.154.226.148
DOMAIN=lstjks.sytes.net
"@

$env | Out-File -FilePath "$packageDir\.env.production" -Encoding UTF8
Write-Host "✓ .env.production" -ForegroundColor Green

# 6. 创建一键部署脚本
$deploy = @"
#!/bin/bash
echo "🔥 Jy技術團隊 瓦斯行管理系統 - 一键部署"
chmod +x *.sh
npm install --production
pkill -f "node.*gas" 2>/dev/null || true
sleep 2
nohup node gas-enhanced-beautiful-v2.js > gas.log 2>&1 &
echo "✅ Enhanced Beautiful版本已启动！"
echo "🌐 访问: http://YOUR_VPS_IP:3000"
"@

$deploy | Out-File -FilePath "$packageDir\quick-deploy.sh" -Encoding UTF8
Write-Host "✓ quick-deploy.sh" -ForegroundColor Green

# 7. 创建安装说明
$readme = @"
# Jy技術團隊 瓦斯行管理系統 VPS部署包

## 快速部署

1. 解压文件
2. 运行: chmod +x quick-deploy.sh && ./quick-deploy.sh
3. 访问: http://YOUR_VPS_IP:3000

## 外网访问
- IP: http://165.154.226.148:3000  
- 域名: http://lstjks.sytes.net:3000

## 版本: Enhanced Beautiful Edition v2.1
© 2025 Jy技術團隊
"@

$readme | Out-File -FilePath "$packageDir\INSTALL.md" -Encoding UTF8
Write-Host "✓ INSTALL.md" -ForegroundColor Green

# 8. 统计和压缩
$allFiles = Get-ChildItem -Path $packageDir -Recurse -File
$totalFiles = $allFiles.Count
$totalSize = [math]::Round(($allFiles | Measure-Object -Property Length -Sum).Sum / 1MB, 2)

Write-Host "📊 文件数: $totalFiles" -ForegroundColor Green
Write-Host "📦 大小: $totalSize MB" -ForegroundColor Green

# 创建压缩包
$zipPath = "$OutputDir\$packageName.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($packageDir, $zipPath)

$zipSize = [math]::Round((Get-Item $zipPath).Length / 1MB, 2)
Remove-Item $packageDir -Recurse -Force

Write-Host ""
Write-Host "🎊 打包完成！" -ForegroundColor Green
Write-Host "📦 压缩包: $zipPath" -ForegroundColor Green  
Write-Host "📊 大小: $zipSize MB" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 VPS部署:" -ForegroundColor Yellow
Write-Host "1. 上传到VPS" -ForegroundColor White
Write-Host "2. unzip $packageName.zip" -ForegroundColor White
Write-Host "3. cd $packageName" -ForegroundColor White
Write-Host "4. chmod +x quick-deploy.sh && ./quick-deploy.sh" -ForegroundColor White
Write-Host ""
Write-Host "🌐 访问地址:" -ForegroundColor Yellow
Write-Host "- http://165.154.226.148:3000" -ForegroundColor White
Write-Host "- http://lstjks.sytes.net:3000" -ForegroundColor White
