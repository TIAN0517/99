# Jy技術團隊 瓦斯行管理系統 2025 - VPS 部署包生成脚本 (完整优化版)
Write-Host "🚀 Jy技術團隊 瓦斯行管理系統 2025 - VPS 部署包生成" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan

# 创建临时目录
$tempDir = "vps-package-temp"
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

Write-Host "📦 准备 VPS 部署文件..." -ForegroundColor Yellow

# 复制必要的应用文件
$filesToCopy = @(
    "package.json",
    "tsconfig.json", 
    "webpack.config.js",
    "electron-builder.json",
    "src/",
    "assets/",
    "README.md",
    "USAGE.md",
    "VPS-DEPLOYMENT-GUIDE.md",
    "FINAL-DELIVERY-REPORT.md"
)

foreach ($file in $filesToCopy) {
    if (Test-Path $file) {
        if ((Get-Item $file).PSIsContainer) {
            Copy-Item $file $tempDir -Recurse
            Write-Host "  ✅ 已复制目录: $file" -ForegroundColor Green
        } else {
            Copy-Item $file $tempDir
            Write-Host "  ✅ 已复制文件: $file" -ForegroundColor Green
        }
    } else {
        Write-Host "  ⚠️  文件不存在: $file" -ForegroundColor Yellow
    }
}

# 复制 VPS 专用文件
$vpsFiles = @(
    "deploy-vps-complete.sh",
    "vps-fix-deployment.sh", 
    "docker-compose.vps.yml",
    "Dockerfile.vps"
)

foreach ($file in $vpsFiles) {
    if (Test-Path $file) {
        Copy-Item $file $tempDir
        Write-Host "  ✅ 已复制 VPS 文件: $file" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  VPS 文件不存在: $file" -ForegroundColor Yellow
    }
}

# 创建 VPS 专用的 package.json（移除开发依赖）
Write-Host "📝 创建生产环境 package.json..." -ForegroundColor Yellow
$packageJson = Get-Content "package.json" | ConvertFrom-Json

# 移除开发依赖，只保留生产依赖
$productionPackage = @{
    name = $packageJson.name
    version = $packageJson.version
    description = $packageJson.description
    main = $packageJson.main
    scripts = @{
        start = "node dist/main/main.js"
        build = "webpack --mode production"
        "build:main" = "webpack --config webpack.config.js --mode production"
        "build:renderer" = "webpack --config webpack.config.js --mode production"
    }
    dependencies = $packageJson.dependencies
    engines = $packageJson.engines
    author = "Jy技術團隊"
    license = "MIT"
    copyright = "© 2025 Jy技術團隊. All rights reserved."
}

$productionPackage | ConvertTo-Json -Depth 10 | Set-Content "$tempDir/package.json"

# 创建优化的 Dockerfile
Write-Host "🐳 创建优化的 Dockerfile..." -ForegroundColor Yellow
@"
# VPS 专用 Dockerfile - 内存优化版
FROM node:18-alpine AS builder

WORKDIR /app

# 复制 package 文件
COPY package*.json ./

# 安装依赖（仅生产环境）
RUN npm ci --only=production --no-audit --no-fund

# 复制源代码
COPY . .

# 构建应用
RUN npm run build

# 生产环境镜像
FROM node:18-alpine

WORKDIR /app

# 安装必要的系统包
RUN apk add --no-cache curl dumb-init

# 创建非 root 用户
RUN addgroup -g 1001 -S nodejs && adduser -S gas-app -u 1001

# 复制构建产物和依赖
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# 创建日志目录
RUN mkdir -p logs && chown nodejs:nodejs logs

# 切换到非 root 用户
USER nodejs

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# 暴露端口
EXPOSE 3000

# 启动应用
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/main/main.js"]
"@ | Set-Content "$tempDir/Dockerfile"

# 创建环境变量模板
Write-Host "⚙️ 创建环境配置模板..." -ForegroundColor Yellow
@"
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=gemma:2b
APP_PORT=3000
LOG_LEVEL=info
COMPANY_NAME=Jy技術團隊
APP_YEAR=2025

# VPS 优化配置
OLLAMA_KEEP_ALIVE=3m
OLLAMA_MAX_LOADED_MODELS=1
MEMORY_LIMIT=2048
"@ | Set-Content "$tempDir/.env.example"

# 创建 PM2 生态系统配置
Write-Host "🔧 创建 PM2 配置..." -ForegroundColor Yellow
@"
module.exports = {
  apps: [{
    name: 'gas-management-system',
    script: 'dist/main/main.js',
    cwd: '/opt/gas-management-system',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '400M',
    env: {
      NODE_ENV: 'production',
      DISPLAY: ':99',
      OLLAMA_BASE_URL: 'http://localhost:11434'
    },
    log_file: './logs/app.log',
    out_file: './logs/out.log', 
    error_file: './logs/error.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss',
    merge_logs: true,
    kill_timeout: 3000
  }]
};
"@ | Set-Content "$tempDir/ecosystem.config.js"

# 创建快速启动脚本
Write-Host "🚀 创建快速启动脚本..." -ForegroundColor Yellow
@"
#!/bin/bash

echo "🚀 Jy技術團隊 瓦斯行管理系統 2025 - 快速启动"
echo "=============================================="

# 设置错误处理
set -e

# 检查 Docker 服务
if ! systemctl is-active --quiet docker; then
    echo "🐳 启动 Docker 服务..."
    systemctl start docker
    sleep 3
fi

# 检查 Ollama 容器
if ! docker ps --format '{{.Names}}' | grep -q "^ollama$"; then
    echo "🤖 启动 Ollama 容器..."
    if docker ps -a --format '{{.Names}}' | grep -q "^ollama$"; then
        docker start ollama
    else
        echo "❌ Ollama 容器不存在，请先运行完整部署脚本"
        exit 1
    fi
    sleep 10
fi

# 等待 Ollama API 就绪
echo "⏳ 等待 Ollama API 就绪..."
timeout=30
while [ $timeout -gt 0 ]; do
    if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo "✅ Ollama API 就绪"
        break
    fi
    echo "等待中... ($timeout)"
    sleep 1
    ((timeout--))
done

if [ $timeout -eq 0 ]; then
    echo "❌ Ollama API 启动超时，尝试重启容器..."
    docker restart ollama
    sleep 15
fi

# 设置虚拟显示
export DISPLAY=:99
if ! pgrep -f "Xvfb :99" > /dev/null; then
    echo "🖥️ 启动虚拟显示..."
    Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
    sleep 2
fi

# 进入应用目录
cd /opt/gas-management-system

# 启动应用
echo "🚀 启动瓦斯行管理系統..."
if command -v pm2 &> /dev/null; then
    echo "使用 PM2 启动..."
    pm2 start ecosystem.config.js
    pm2 logs gas-management-system
else
    echo "直接启动..."
    npm start
fi
"@ | Set-Content "$tempDir/quick-start.sh"

# 创建停止脚本
@"
#!/bin/bash

echo "🛑 停止 Jy技術團隊 瓦斯行管理系統 2025"

# 停止 PM2 应用
if command -v pm2 &> /dev/null; then
    pm2 stop gas-management-system
    pm2 delete gas-management-system
fi

# 停止系统服务
systemctl stop gas-management || true

# 停止进程
pkill -f "node.*main.js" || true
pkill -f "Xvfb :99" || true

echo "✅ 应用已停止"
"@ | Set-Content "$tempDir/stop.sh"

# 创建安装说明
Write-Host "📚 创建安装说明..." -ForegroundColor Yellow
@"
# Jy技術團隊 瓦斯行管理系統 2025 - VPS 安装说明

## 🚀 快速开始

### 1. 一键部署（推荐）
```bash
chmod +x deploy-vps-complete.sh
./deploy-vps-complete.sh
```

### 2. 手动部署
请参考 VPS-DEPLOYMENT-GUIDE.md 获取详细说明。

## 📊 系统要求

- **最低配置**: 2GB RAM, 10GB 存储空间
- **推荐配置**: 4GB RAM, 20GB 存储空间  
- **操作系统**: Ubuntu 20.04+, CentOS 8+, Debian 11+

## 🔧 管理命令

```bash
# 启动应用
./quick-start.sh

# 停止应用
./stop.sh

# 查看状态
./monitor.sh

# 系统服务管理
systemctl start|stop|restart gas-management
```

## 📞 技术支持

- **开发团队**: Jy技術團隊
- **版本**: 2025
- **文档**: VPS-DEPLOYMENT-GUIDE.md

---
© 2025 Jy技術團隊. All rights reserved.
"@ | Set-Content "$tempDir/INSTALL.md"

# 创建版本信息文件
@"
{
  "name": "Jy技術團隊 瓦斯行管理系統",
  "version": "1.0.0",
  "build_date": "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
  "build_type": "VPS Production",
  "developer": "Jy技術團隊",
  "year": "2025",
  "ai_model_support": [
    "deepseek-r1:8b",
    "gemma:2b", 
    "phi3:mini"
  ],
  "system_requirements": {
    "min_memory_gb": 2,
    "recommended_memory_gb": 4,
    "min_storage_gb": 10,
    "node_version": "18+",
    "docker_required": true
  }
}
"@ | Set-Content "$tempDir/version.json"

# 压缩为部署包
Write-Host "📦 创建部署包..." -ForegroundColor Yellow
$zipName = "gas-management-system-vps-package-complete.zip"

if (Test-Path $zipName) {
    Remove-Item $zipName -Force
}

# 使用 PowerShell 压缩
Compress-Archive -Path "$tempDir/*" -DestinationPath $zipName -CompressionLevel Optimal

# 清理临时目录
Remove-Item $tempDir -Recurse -Force

# 显示结果
$zipSize = [math]::Round((Get-Item $zipName).Length / 1MB, 2)
Write-Host ""
Write-Host "🎉 VPS 部署包创建完成！" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "📦 文件名: $zipName" -ForegroundColor White
Write-Host "📏 大小: ${zipSize} MB" -ForegroundColor White
Write-Host ""
Write-Host "📋 包含文件:" -ForegroundColor Yellow
Write-Host "  • 应用源代码和配置" -ForegroundColor White
Write-Host "  • VPS 部署脚本 (deploy-vps-complete.sh)" -ForegroundColor White
Write-Host "  • Docker 配置文件" -ForegroundColor White
Write-Host "  • PM2 生态系统配置" -ForegroundColor White
Write-Host "  • 快速启动/停止脚本" -ForegroundColor White
Write-Host "  • 完整部署文档" -ForegroundColor White
Write-Host "  • 监控和故障排除工具" -ForegroundColor White
Write-Host ""
Write-Host "🚀 部署步骤:" -ForegroundColor Yellow
Write-Host "  1. 上传到 VPS: scp $zipName root@vps:/root/" -ForegroundColor White
Write-Host "  2. 解压: unzip $zipName" -ForegroundColor White  
Write-Host "  3. 运行: chmod +x deploy-vps-complete.sh && ./deploy-vps-complete.sh" -ForegroundColor White
Write-Host ""
Write-Host "✨ Jy技術團隊 2025 - 瓦斯行管理系統 VPS 部署包准备就绪！" -ForegroundColor Green
