# Jy技術團隊 - 瓦斯行管理系統 2025 打包脚本

Write-Host "🚀 开始打包 Jy技術團隊 - 瓦斯行管理系統 2025..." -ForegroundColor Green

# 创建打包目录
$packageDir = "gas-management-system-vps-package"
if (Test-Path $packageDir) {
    Remove-Item $packageDir -Recurse -Force
}
New-Item -ItemType Directory -Path $packageDir

Write-Host "📦 复制必要文件..." -ForegroundColor Blue

# 复制核心文件
Copy-Item "package.json" $packageDir -Force
Copy-Item "tsconfig.json" $packageDir -Force
Copy-Item "webpack.config.js" $packageDir -Force
Copy-Item "electron-builder.json" $packageDir -Force
Copy-Item "README.md" $packageDir -Force
Copy-Item "USAGE.md" $packageDir -Force
Copy-Item "PROJECT_SUMMARY.md" $packageDir -Force

# 复制源代码
Copy-Item "src" $packageDir -Recurse -Force

# 复制资源文件
Copy-Item "assets" $packageDir -Recurse -Force

# 复制构建输出（如果存在）
if (Test-Path "dist") {
    Copy-Item "dist" $packageDir -Recurse -Force
}

# 创建安装脚本
$installScript = @"
# Jy技術團隊 - 瓦斯行管理系統 2025 安装脚本

Write-Host "🚀 安装 Jy技術團隊 - 瓦斯行管理系統 2025..." -ForegroundColor Green

# 检查 Node.js
try {
    `$nodeVersion = node --version
    Write-Host "✅ Node.js 版本: `$nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ 请先安装 Node.js (https://nodejs.org/)" -ForegroundColor Red
    exit 1
}

# 安装依赖
Write-Host "📦 安装依赖包..." -ForegroundColor Blue
npm install

# 构建应用
Write-Host "🔨 构建应用..." -ForegroundColor Blue
npm run build

Write-Host "✅ 安装完成！" -ForegroundColor Green
Write-Host "🚀 使用 'npm start' 启动应用" -ForegroundColor Yellow
Write-Host "🌐 Powered by Jy技術團隊 © 2025" -ForegroundColor Cyan
"@

$installScript | Out-File -FilePath "$packageDir\install.ps1" -Encoding UTF8

# 创建启动脚本
$startScript = @"
# Jy技術團隊 - 瓦斯行管理系統 2025 启动脚本

Write-Host "🚀 启动 Jy技術團隊 - 瓦斯行管理系統 2025..." -ForegroundColor Green

# 检查是否已构建
if (-not (Test-Path "dist")) {
    Write-Host "⚠️  未找到构建文件，正在构建..." -ForegroundColor Yellow
    npm run build
}

# 启动应用
npm start
"@

$startScript | Out-File -FilePath "$packageDir\start.ps1" -Encoding UTF8

# 创建 VPS 部署说明
$deployGuide = @"
# VPS 部署指南 - Jy技術團隊 瓦斯行管理系統 2025

## 系统要求
- Node.js 18+ 
- npm 或 yarn
- 至少 2GB RAM
- Windows Server 2016+ 或 Ubuntu 18.04+

## 安装步骤

### Windows VPS
1. 解压缩文件到目标目录
2. 以管理员身份运行 PowerShell
3. 执行: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
4. 执行: `.\install.ps1`
5. 执行: `.\start.ps1`

### Linux VPS
```bash
# 解压缩文件
unzip gas-management-system-vps-package.zip
cd gas-management-system-vps-package

# 安装依赖
npm install

# 构建应用
npm run build

# 启动应用
npm start
```

## AI 助理设置（可选）
如果要使用 AI 助理功能，请安装 Ollama：

### Windows
```bash
winget install Ollama.Ollama
ollama pull deepseek-r1:8b
ollama serve
```

### Linux
```bash
curl -fsSL https://ollama.ai/install.sh | sh
ollama pull deepseek-r1:8b
ollama serve
```

## 端口配置
- 应用端口：默认 Electron 桌面应用
- Ollama API：http://localhost:11434

## 故障排除
1. 权限问题：确保有足够的文件读写权限
2. 端口占用：检查 11434 端口是否被占用
3. 内存不足：确保至少有 2GB 可用内存

## 技术支持
- 开发者：Jy技術團隊
- 版本：1.0.0 (2025)
- 联系：contact@jytech.com
"@

$deployGuide | Out-File -FilePath "$packageDir\VPS-DEPLOY-GUIDE.md" -Encoding UTF8

Write-Host "🗜️  创建压缩包..." -ForegroundColor Blue

# 创建 ZIP 压缩包
$zipPath = "gas-management-system-vps-package.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Compress-Archive -Path $packageDir -DestinationPath $zipPath -CompressionLevel Optimal

# 显示结果
$zipSize = [math]::Round((Get-Item $zipPath).Length / 1MB, 2)
Write-Host "✅ 打包完成！" -ForegroundColor Green
Write-Host "📁 压缩包：$zipPath ($zipSize MB)" -ForegroundColor Yellow
Write-Host "🌐 Ready for VPS deployment!" -ForegroundColor Cyan
Write-Host "🏷️  Powered by Jy技術團隊 © 2025" -ForegroundColor Magenta

# 清理临时目录
Remove-Item $packageDir -Recurse -Force

Write-Host "`n📋 部署说明：" -ForegroundColor Blue
Write-Host "1. 将 $zipPath 上传到 VPS" -ForegroundColor White
Write-Host "2. 解压缩文件" -ForegroundColor White
Write-Host "3. 运行 install.ps1 (Windows) 或 npm install (Linux)" -ForegroundColor White
Write-Host "4. 运行 start.ps1 (Windows) 或 npm start (Linux)" -ForegroundColor White
Write-Host "5. 查看 VPS-DEPLOY-GUIDE.md 获取详细说明" -ForegroundColor White
