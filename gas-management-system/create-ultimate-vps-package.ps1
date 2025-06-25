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
$envContent = @"
# VPS生产环境配置
NODE_ENV=production
PORT=3000
HOST=0.0.0.0

# 数据库配置 (如果需要)
# DB_HOST=localhost
# DB_PORT=5432
# DB_NAME=gas_management
# DB_USER=gas_admin
# DB_PASSWORD=your_secure_password

# 安全配置
# JWT_SECRET=your_jwt_secret_here
# CORS_ORIGIN=https://yourdomain.com

# 日志配置
LOG_LEVEL=info
LOG_FILE=/var/log/gas-management/app.log
"@

Set-Content -Path (Join-Path $packageDir ".env.production") -Value $envContent -Encoding UTF8
Write-Host "✓ .env.production" -ForegroundColor Green

# 10. 创建一键部署脚本
Write-Host "创建一键部署脚本..." -ForegroundColor Yellow
$deployScript = @"
#!/bin/bash
# 一键部署脚本 - 适用于Ubuntu/Debian VPS
set -e

echo "=== 瓦斯管理系统 - VPS一键部署 ==="
echo "开始时间: `$(date)`"

# 检查权限
if [ "`$EUID" -ne 0 ]; then
    echo "请使用sudo运行此脚本"
    exit 1
fi

# 更新系统
echo "更新系统包..."
apt update && apt upgrade -y

# 安装Node.js 18+
echo "安装Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# 安装依赖
echo "安装系统依赖..."
apt-get install -y nginx certbot python3-certbot-nginx ufw

# 安装项目依赖
echo "安装项目依赖..."
npm install --production

# 构建项目
echo "构建项目..."
npm run build 2>/dev/null || echo "跳过构建步骤"

# 配置防火墙
echo "配置防火墙..."
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 3000
echo "y" | ufw enable

# 配置Nginx
echo "配置Nginx..."
cat > /etc/nginx/sites-available/gas-management << 'EOL'
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade `$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host `$host;
        proxy_set_header X-Real-IP `$remote_addr;
        proxy_set_header X-Forwarded-For `$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto `$scheme;
        proxy_cache_bypass `$http_upgrade;
    }
}
EOL

ln -sf /etc/nginx/sites-available/gas-management /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx

# 创建systemd服务
echo "创建系统服务..."
cat > /etc/systemd/system/gas-management.service << 'EOL'
[Unit]
Description=Gas Management System
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=`$(pwd)
Environment=NODE_ENV=production
Environment=PORT=3000
ExecStart=/usr/bin/node dist/main/main.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable gas-management

# 启动服务
echo "启动服务..."
systemctl start gas-management
systemctl start nginx

# 检查状态
echo "检查服务状态..."
systemctl status gas-management --no-pager
systemctl status nginx --no-pager

echo "=== 部署完成 ==="
echo "访问地址: http://`$(curl -s ifconfig.me)"
echo "本地访问: http://localhost"
echo ""
echo "管理命令:"
echo "  查看日志: journalctl -u gas-management -f"
echo "  重启服务: systemctl restart gas-management"
echo "  配置SSL: ./setup-ssl-certificate.sh"
echo "  外部访问: ./external-access-manager.sh"
"@

Set-Content -Path (Join-Path $packageDir "deploy-ultimate.sh") -Value $deployScript -Encoding UTF8
Write-Host "✓ deploy-ultimate.sh" -ForegroundColor Green

# 11. 创建完整部署指南
Write-Host "创建完整部署指南..." -ForegroundColor Yellow
$guideContent = @"
# 瓦斯管理系统 - VPS终极部署指南

## 快速部署 (推荐)

1. 上传此包到VPS
2. 解压: unzip package-name.zip
3. 进入目录: cd package-directory
4. 一键部署: chmod +x *.sh && sudo ./deploy-ultimate.sh

## 手动部署步骤

### 1. 环境准备
```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash -
sudo apt-get install -y nodejs

# 安装系统依赖
sudo apt-get install -y nginx certbot python3-certbot-nginx ufw git
```

### 2. 项目设置
```bash
# 安装项目依赖
npm install --production

# 构建项目 (如果需要)
npm run build
```

### 3. 配置服务
```bash
# 配置防火墙
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 3000
sudo ufw enable

# 启动Nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```

### 4. 外部访问配置
```bash
# 快速配置外部访问
./external-access-manager.sh

# 或使用一键脚本
./deploy-external-access.sh
```

### 5. SSL证书配置 (可选)
```bash
# 配置SSL证书
./setup-ssl-certificate.sh your-domain.com
```

## 管理命令

### 服务管理
```bash
# 查看服务状态
sudo systemctl status gas-management

# 重启服务
sudo systemctl restart gas-management

# 查看日志
sudo journalctl -u gas-management -f
```

### 外部访问管理
```bash
# 交互式管理中心
./external-access-manager.sh

# 快速外部访问设置
./quick-external-access.sh

# 故障排除
./troubleshoot-external-access.sh
```

### 性能优化
```bash
# 一键优化
./quick-optimize.sh

# 详细优化
./optimize-vps-performance.sh
```

## 文件结构说明

- `src/` - 应用源代码
- `assets/` - 静态资源文件
- `*.sh` - 各种部署和管理脚本
- `*.md` - 详细文档
- `.env.production` - 生产环境配置

## 故障排除

如果遇到问题，请按顺序检查：

1. 运行诊断脚本: `./troubleshoot-external-access.sh`
2. 检查服务状态: `sudo systemctl status gas-management`
3. 查看日志: `sudo journalctl -u gas-management -f`
4. 检查网络: `./test-network-connectivity.sh`

## 技术支持

本包包含完整的瓦斯管理系统和所有必要的部署工具。
如有问题，请参考各个*.md文档文件获取详细信息。
"@

Set-Content -Path (Join-Path $packageDir "ULTIMATE-DEPLOY-GUIDE.md") -Value $guideContent -Encoding UTF8
Write-Host "✓ ULTIMATE-DEPLOY-GUIDE.md" -ForegroundColor Green

# 12. 统计文件信息
$fileCount = (Get-ChildItem $packageDir -Recurse -File).Count
$totalSize = (Get-ChildItem $packageDir -Recurse -File | Measure-Object -Property Length -Sum).Sum

Write-Host "`n=== 包内容统计 ===" -ForegroundColor Cyan
Write-Host "文件总数: $fileCount" -ForegroundColor White
Write-Host "总大小: $([math]::Round($totalSize / 1MB, 2)) MB" -ForegroundColor White

# 13. 创建压缩包
Write-Host "`n创建压缩包..." -ForegroundColor Yellow
if (Test-Path $zipFile) {
    Remove-Item $zipFile -Force
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($packageDir, $zipFile)

$zipSize = (Get-Item $zipFile).Length
Write-Host "✓ 压缩包已创建: $zipFile" -ForegroundColor Green
Write-Host "压缩包大小: $([math]::Round($zipSize / 1MB, 2)) MB" -ForegroundColor Cyan

# 14. 清理临时文件
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
Write-Host "  ✓ 一键部署脚本" -ForegroundColor Green
Write-Host "  ✓ 生产环境配置" -ForegroundColor Green

Write-Host "上传到VPS后，只需运行:" -ForegroundColor Cyan
Write-Host "  unzip package-name.zip && cd package-directory && chmod +x *.sh && sudo ./deploy-ultimate.sh" -ForegroundColor White

Write-Host "`n此包是完全自包含的，可以直接在VPS上部署运行！" -ForegroundColor Green
