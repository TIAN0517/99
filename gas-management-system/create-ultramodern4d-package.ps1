# UltraModern4D瓦斯管理系统 - 完整打包脚本

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$packageName = "UltraModern4D-Gas-Management-System-Complete-$timestamp"
$zipName = "$packageName.zip"

Write-Host "🚀 创建UltraModern4D系统完整压缩包..." -ForegroundColor Cyan
Write-Host "包名: $packageName" -ForegroundColor Yellow

# 创建临时打包目录
$tempDir = "temp_package_$timestamp"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
Write-Host "✅ 创建临时目录: $tempDir" -ForegroundColor Green

# 复制核心系统文件
Write-Host "📦 复制核心系统文件..." -ForegroundColor Yellow

# 核心源码
Copy-Item "src" -Destination "$tempDir\src" -Recurse -Force
Copy-Item "dist" -Destination "$tempDir\dist" -Recurse -Force

# 核心配置文件
$coreFiles = @(
    "package.json",
    "package-lock.json", 
    "tsconfig.json",
    "webpack.config.js",
    "electron-builder.json"
)

foreach ($file in $coreFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $tempDir -Force
        Write-Host "  ✅ $file" -ForegroundColor Green
    }
}

# UltraModern4D系统文档
Write-Host "📚 复制UltraModern4D文档..." -ForegroundColor Yellow
$ultraDocs = @(
    "ULTRAMODERN-4D-EXPERIENCE-GUIDE.md",
    "4D-VISUAL-EFFECTS-GUIDE.md", 
    "FINAL-PROJECT-COMPLETION-REPORT.md",
    "QUICK-START-4D.md",
    "4D-TECH-SYSTEM-LAUNCH-REPORT.md",
    "FINAL-4D-DELIVERY-REPORT.md"
)

foreach ($doc in $ultraDocs) {
    if (Test-Path $doc) {
        Copy-Item $doc -Destination $tempDir -Force
        Write-Host "  ✅ $doc" -ForegroundColor Green
    }
}

# AI助手相关文件
Write-Host "🤖 复制AI助手文件..." -ForegroundColor Yellow
$aiFiles = @(
    "AI-ASSISTANT-GUIDE.md",
    "AI-MODEL-GUIDE.md"
)

foreach ($file in $aiFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $tempDir -Force
        Write-Host "  ✅ $file" -ForegroundColor Green
    }
}

# 系统检查和启动脚本
Write-Host "🔧 复制系统工具..." -ForegroundColor Yellow
$tools = @(
    "check-4d-system-status.ps1",
    "check-4d-system-status.sh"
)

foreach ($tool in $tools) {
    if (Test-Path $tool) {
        Copy-Item $tool -Destination $tempDir -Force
        Write-Host "  ✅ $tool" -ForegroundColor Green
    }
}

# 创建启动脚本
Write-Host "📝 创建启动脚本..." -ForegroundColor Yellow

# Windows启动脚本
$startScriptWin = @"
@echo off
echo 🚀 UltraModern4D瓦斯管理系统启动中...
echo =====================================

echo 📋 检查Node.js环境...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js未安装，请先安装Node.js 16+
    pause
    exit /b 1
)

echo ✅ Node.js环境正常

echo 📦 安装依赖包...
call npm install

echo 🔧 编译系统...
call npm run build

echo 🚀 启动UltraModern4D系统...
call npm start

pause
"@

$startScriptWin | Out-File -FilePath "$tempDir\start-ultramodern4d.bat" -Encoding utf8
Write-Host "  ✅ start-ultramodern4d.bat" -ForegroundColor Green

# Linux启动脚本
$startScriptLinux = @"
#!/bin/bash
echo "🚀 UltraModern4D瓦斯管理系统启动中..."
echo "====================================="

echo "📋 检查Node.js环境..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js未安装，请先安装Node.js 16+"
    exit 1
fi

echo "✅ Node.js环境正常"

echo "📦 安装依赖包..."
npm install

echo "🔧 编译系统..."
npm run build

echo "🚀 启动UltraModern4D系统..."
npm start
"@

$startScriptLinux | Out-File -FilePath "$tempDir\start-ultramodern4d.sh" -Encoding utf8
Write-Host "  ✅ start-ultramodern4d.sh" -ForegroundColor Green

# 创建README文件
Write-Host "📝 创建README..." -ForegroundColor Yellow
$readme = @"
# 🚀 UltraModern4D瓦斯管理系统

## 📋 系统介绍
这是一个具有4D科技感界面的现代化瓦斯管理系统，集成了AI助手功能。

## ✨ 主要特性
- 🎨 4D科技感界面设计
- 🤖 本地AI助手支持
- 💼 完整的业务管理功能
- ⚡ 60FPS流畅动画体验
- 📊 实时数据可视化

## 🛠️ 环境要求
- Node.js 16+
- npm 7+
- Windows 10+ / macOS 10.15+ / Linux
- 4GB+ 内存
- 支持硬件加速的显卡

## 🚀 快速启动

### Windows用户:
双击运行 `start-ultramodern4d.bat`

### Linux/macOS用户:
```bash
chmod +x start-ultramodern4d.sh
./start-ultramodern4d.sh
```

### 手动启动:
```bash
npm install
npm run build  
npm start
```

## 🤖 AI助手配置
系统需要Ollama服务支持AI助手功能:

1. 安装Ollama: https://ollama.ai/
2. 启动服务: `ollama serve`
3. 下载模型: `ollama pull qwen3:8b`

## 📚 详细文档
- `ULTRAMODERN-4D-EXPERIENCE-GUIDE.md` - 完整体验指南
- `4D-VISUAL-EFFECTS-GUIDE.md` - 视觉效果优化指南
- `FINAL-PROJECT-COMPLETION-REPORT.md` - 项目完成报告
- `AI-ASSISTANT-GUIDE.md` - AI助手使用指南

## 🎯 快速体验
1. 启动系统后观察4D动画效果
2. 点击右上角"🤖 AI助手"体验智能对话
3. 切换左侧导航栏的不同模块
4. 鼠标悬停在卡片上体验3D效果

## 📞 技术支持
如遇问题请参考文档或运行系统状态检查:
- Windows: `.\check-4d-system-status.ps1`
- Linux: `./check-4d-system-status.sh`

---
🌟 享受您的4D科技感管理体验！
生成时间: $(Get-Date -Format "yyyy年MM月dd日 HH:mm:ss")
"@

$readme | Out-File -FilePath "$tempDir\README.md" -Encoding utf8
Write-Host "  ✅ README.md" -ForegroundColor Green

# 创建版本信息文件
$versionInfo = @"
{
  "name": "UltraModern4D Gas Management System",
  "version": "1.0.0",
  "buildDate": "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")",
  "description": "4D科技感瓦斯管理系统",
  "features": [
    "4D科技感界面设计",
    "本地AI助手集成", 
    "完整业务管理功能",
    "60FPS流畅动画",
    "实时数据可视化"
  ],
  "requirements": {
    "nodejs": "16+",
    "npm": "7+",
    "memory": "4GB+",
    "graphics": "Hardware acceleration support"
  }
}
"@

$versionInfo | Out-File -FilePath "$tempDir\version-info.json" -Encoding utf8
Write-Host "  ✅ version-info.json" -ForegroundColor Green

# 创建压缩包
Write-Host "🗜️ 创建压缩包..." -ForegroundColor Yellow
if (Get-Command Compress-Archive -ErrorAction SilentlyContinue) {
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipName -Force
    Write-Host "✅ 压缩包创建成功: $zipName" -ForegroundColor Green
} else {
    Write-Host "❌ PowerShell Compress-Archive 不可用" -ForegroundColor Red
    # 尝试使用7zip
    if (Get-Command 7z -ErrorAction SilentlyContinue) {
        7z a $zipName "$tempDir\*"
        Write-Host "✅ 使用7zip创建压缩包: $zipName" -ForegroundColor Green
    } else {
        Write-Host "❌ 需要安装7zip或使用PowerShell 5.0+" -ForegroundColor Red
    }
}

# 清理临时目录
Remove-Item -Path $tempDir -Recurse -Force
Write-Host "🗑️ 清理临时目录" -ForegroundColor Gray

# 显示结果
if (Test-Path $zipName) {
    $zipSize = [math]::Round((Get-Item $zipName).Length / 1MB, 2)
    Write-Host ""
    Write-Host "🎉 UltraModern4D系统打包完成！" -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "📦 压缩包: $zipName" -ForegroundColor White
    Write-Host "📏 大小: $zipSize MB" -ForegroundColor White
    Write-Host "📅 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")" -ForegroundColor White
    Write-Host ""
    Write-Host "📋 包含内容:" -ForegroundColor Yellow
    Write-Host "  ✅ UltraModern4D核心系统" -ForegroundColor Green
    Write-Host "  ✅ 完整源代码和编译产物" -ForegroundColor Green
    Write-Host "  ✅ 详细使用文档" -ForegroundColor Green
    Write-Host "  ✅ 启动脚本 (Windows/Linux)" -ForegroundColor Green
    Write-Host "  ✅ 系统检查工具" -ForegroundColor Green
    Write-Host "  ✅ AI助手配置指南" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 现在可以将压缩包分发给用户使用！" -ForegroundColor Cyan
} else {
    Write-Host "❌ 压缩包创建失败" -ForegroundColor Red
}
