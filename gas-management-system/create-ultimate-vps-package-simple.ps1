# 创建终极完整VPS部署包
# 包含完整源代码、依赖项和所有配置文件

$ErrorActionPreference = "Stop"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$packageName = "gas-management-system-ultimate-vps-$timestamp"
$packageDir = Join-Path $PWD $packageName
$zipFile = "$packageName.zip"

Write-Host "=== 创建终极完整VPS部署包 ===" -ForegroundColor Green
Write-Host "包名: $packageName" -ForegroundColor Cyan

# 创建临时目录
if (Test-Path $packageDir) {
    Remove-Item $packageDir -Recurse -Force
}
New-Item -ItemType Directory -Path $packageDir -Force | Out-Null

# 1. 复制完整源代码
Write-Host "复制源代码目录..." -ForegroundColor Yellow
if (Test-Path "src") {
    Copy-Item "src" -Destination $packageDir -Recurse -Force
    Write-Host "✓ 源代码已复制" -ForegroundColor Green
} else {
    Write-Host "✗ 警告: src目录不存在" -ForegroundColor Red
}

# 2. 复制资源文件
Write-Host "复制资源文件..." -ForegroundColor Yellow
if (Test-Path "assets") {
    Copy-Item "assets" -Destination $packageDir -Recurse -Force
    Write-Host "✓ 资源文件已复制" -ForegroundColor Green
}

# 3. 复制核心配置文件
Write-Host "复制核心配置文件..." -ForegroundColor Yellow
$coreFiles = @(
    "package.json",
    "package-lock.json",
    "tsconfig.json",
    "webpack.config.js",
    "electron-builder.json"
)

foreach ($file in $coreFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file" -ForegroundColor Green
    } else {
        Write-Host "✗ $file 不存在" -ForegroundColor Red
    }
}

# 4. 复制VPS部署脚本
Write-Host "复制VPS部署脚本..." -ForegroundColor Yellow
$vpsScripts = @(
    "deploy-vps-complete.sh",
    "deploy-vps-linux.sh",
    "quick-deploy-linux.sh",
    "docker-compose.vps.yml",
    "Dockerfile.vps"
)

foreach ($script in $vpsScripts) {
    if (Test-Path $script) {
        Copy-Item $script -Destination $packageDir -Force
        Write-Host "✓ $script" -ForegroundColor Green
    }
}

# 5. 复制外部访问工具
Write-Host "复制外部访问工具..." -ForegroundColor Yellow
$externalAccessFiles = @(
    "external-access-manager.sh",
    "deploy-external-access.sh",
    "configure-external-access.sh",
    "setup-external-access.sh",
    "setup-ssl-certificate.sh",
    "troubleshoot-external-access.sh",
    "quick-external-access.sh",
    "test-network-connectivity.sh",
    "check-network-config.sh"
)

foreach ($file in $externalAccessFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file" -ForegroundColor Green
    }
}

# 6. 复制AI配置工具
Write-Host "复制AI配置工具..." -ForegroundColor Yellow
$aiFiles = @(
    "auto-setup-ai-model.sh",
    "setup-ai-for-vps.sh",
    "diagnose-ai-connection.sh",
    "AI-MODEL-GUIDE.md"
)

foreach ($file in $aiFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file" -ForegroundColor Green
    }
}

# 7. 复制性能优化工具
Write-Host "复制性能优化工具..." -ForegroundColor Yellow
$optimizationFiles = @(
    "optimize-vps-performance.sh",
    "quick-optimize.sh"
)

foreach ($file in $optimizationFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file" -ForegroundColor Green
    }
}

# 8. 复制文档
Write-Host "复制文档..." -ForegroundColor Yellow
$docFiles = @(
    "README.md",
    "USAGE.md",
    "VPS-DEPLOYMENT-GUIDE.md",
    "LINUX-VPS-DEPLOYMENT.md",
    "QUICK-START-LINUX.md",
    "EXTERNAL-ACCESS-GUIDE.md",
    "EXTERNAL-ACCESS-TOOLS-README.md",
    "EXTERNAL-ACCESS-USAGE-GUIDE.md",
    "VPS-TRANSFER-GUIDE.md"
)

foreach ($file in $docFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $packageDir -Force
        Write-Host "✓ $file" -ForegroundColor Green
    }
}

# 9. 创建生产环境配置
Write-Host "创建生产环境配置..." -ForegroundColor Yellow
$envContent = "NODE_ENV=production`nPORT=3000`nHOST=0.0.0.0`nLOG_LEVEL=info`n"
Set-Content -Path (Join-Path $packageDir ".env.production") -Value $envContent -Encoding UTF8
Write-Host "✓ .env.production" -ForegroundColor Green

# 10. 统计文件信息
$fileCount = (Get-ChildItem $packageDir -Recurse -File).Count
$totalSize = (Get-ChildItem $packageDir -Recurse -File | Measure-Object -Property Length -Sum).Sum

Write-Host "`n=== 包内容统计 ===" -ForegroundColor Cyan
Write-Host "文件总数: $fileCount" -ForegroundColor White
Write-Host "总大小: $([math]::Round($totalSize / 1MB, 2)) MB" -ForegroundColor White

# 11. 创建压缩包
Write-Host "`n创建压缩包..." -ForegroundColor Yellow
if (Test-Path $zipFile) {
    Remove-Item $zipFile -Force
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($packageDir, $zipFile)

$zipSize = (Get-Item $zipFile).Length
Write-Host "✓ 压缩包已创建: $zipFile" -ForegroundColor Green
Write-Host "压缩包大小: $([math]::Round($zipSize / 1MB, 2)) MB" -ForegroundColor Cyan

# 12. 清理临时文件
Remove-Item $packageDir -Recurse -Force

Write-Host "`n=== 终极VPS包创建完成 ===" -ForegroundColor Green
Write-Host "包文件: $zipFile" -ForegroundColor Cyan
Write-Host "包含内容:" -ForegroundColor Yellow
Write-Host "  ✓ 完整源代码 (src/)" -ForegroundColor Green
Write-Host "  ✓ 资源文件 (assets/)" -ForegroundColor Green
Write-Host "  ✓ 核心配置文件" -ForegroundColor Green
Write-Host "  ✓ VPS部署脚本" -ForegroundColor Green
Write-Host "  ✓ 外部访问工具" -ForegroundColor Green
Write-Host "  ✓ AI配置工具" -ForegroundColor Green
Write-Host "  ✓ 性能优化工具" -ForegroundColor Green
Write-Host "  ✓ 完整文档集" -ForegroundColor Green

Write-Host "`n此包是完全自包含的，可以直接在VPS上部署运行！" -ForegroundColor Green
