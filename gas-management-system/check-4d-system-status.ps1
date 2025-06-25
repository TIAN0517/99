# UltraModern4D系统状态检查 (Windows PowerShell版本)

Write-Host "🚀 UltraModern4D系统状态检查" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# 检查Electron进程
Write-Host ""
Write-Host "📋 1. 检查Electron应用状态..." -ForegroundColor Yellow
$electronProcess = Get-Process -Name "electron" -ErrorAction SilentlyContinue
if ($electronProcess) {
    Write-Host "✅ Electron应用正在运行" -ForegroundColor Green
    Write-Host "进程信息:" -ForegroundColor Gray
    $electronProcess | Select-Object Name, Id, CPU, WorkingSet | Format-Table
} else {
    Write-Host "❌ Electron应用未运行" -ForegroundColor Red
    Write-Host "建议执行: npm start" -ForegroundColor Yellow
}

# 检查Node.js进程
Write-Host ""
Write-Host "📋 2. 检查Node.js进程..." -ForegroundColor Yellow
$nodeProcess = Get-Process -Name "node" -ErrorAction SilentlyContinue
if ($nodeProcess) {
    Write-Host "✅ Node.js进程正在运行" -ForegroundColor Green
    $nodeProcess | Select-Object Name, Id, CPU | Format-Table
} else {
    Write-Host "ℹ️  Node.js进程未运行" -ForegroundColor Gray
}

# 检查AI服务
Write-Host ""
Write-Host "📋 3. 检查AI助手服务..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:11434/api/tags" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Ollama服务正常运行" -ForegroundColor Green
    
    $models = ($response.Content | ConvertFrom-Json).models
    Write-Host "可用模型:" -ForegroundColor Gray
    foreach ($model in $models) {
        Write-Host "  🧠 $($model.name)" -ForegroundColor Cyan
    }
} catch {
    Write-Host "❌ Ollama服务未运行" -ForegroundColor Red
    Write-Host "建议执行: ollama serve" -ForegroundColor Yellow
}

# 检查系统资源
Write-Host ""
Write-Host "📋 4. 检查系统资源..." -ForegroundColor Yellow
$totalRAM = [math]::Round((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$availableRAM = [math]::Round((Get-CimInstance -ClassName Win32_OperatingSystem).FreePhysicalMemory / 1MB, 2)
$usedRAM = [math]::Round($totalRAM - ($availableRAM / 1024), 2)

Write-Host "内存使用情况:" -ForegroundColor Gray
Write-Host "  总内存: $totalRAM GB" -ForegroundColor White
Write-Host "  已使用: $usedRAM GB" -ForegroundColor White
Write-Host "  可用: $([math]::Round($availableRAM / 1024, 2)) GB" -ForegroundColor White

# 检查关键文件
Write-Host ""
Write-Host "📋 5. 检查关键文件..." -ForegroundColor Yellow
$filesToCheck = @(
    "src\renderer\pages\UltraModern4D.tsx",
    "src\renderer\pages\UltraModern4D.css", 
    "src\renderer\App.tsx",
    "dist\renderer\bundle.js"
)

foreach ($file in $filesToCheck) {
    if (Test-Path $file) {
        Write-Host "✅ $file 存在" -ForegroundColor Green
    } else {
        Write-Host "❌ $file 缺失" -ForegroundColor Red
    }
}

# 检查浏览器硬件加速
Write-Host ""
Write-Host "📋 6. 浏览器优化检查..." -ForegroundColor Yellow
Write-Host "💻 建议浏览器: Chrome, Edge (启用硬件加速)" -ForegroundColor Gray
Write-Host "📺 建议分辨率: 1920x1080或更高" -ForegroundColor Gray
Write-Host "⚡ 建议性能: 中等以上显卡，4GB+内存" -ForegroundColor Gray

# 检查端口占用
Write-Host ""
Write-Host "📋 7. 检查端口状态..." -ForegroundColor Yellow
$port3000 = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
if ($port3000) {
    Write-Host "ℹ️  端口3000被占用" -ForegroundColor Yellow
    $port3000 | Select-Object LocalAddress, LocalPort, State | Format-Table
} else {
    Write-Host "ℹ️  端口3000未被占用 (Electron应用不需要Web端口)" -ForegroundColor Gray
}

# 提供快速操作指令
Write-Host ""
Write-Host "🔧 快速操作指令:" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host "启动系统: npm start" -ForegroundColor White
Write-Host "重新编译: npm run build" -ForegroundColor White  
Write-Host "启动AI服务: ollama serve" -ForegroundColor White
Write-Host "检查AI模型: ollama list" -ForegroundColor White
Write-Host "安装依赖: npm install" -ForegroundColor White

# 系统访问信息
Write-Host ""
Write-Host "🌐 系统访问信息:" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Electron应用: 已自动启动桌面应用" -ForegroundColor White
Write-Host "AI助手: 点击右上角'🤖 AI助手'按钮" -ForegroundColor White
Write-Host "模块切换: 点击左侧导航栏" -ForegroundColor White

# 故障排除指南
Write-Host ""
Write-Host "🆘 故障排除指南:" -ForegroundColor Red
Write-Host "================================" -ForegroundColor Red
Write-Host "1. 界面不美观 → 启用浏览器硬件加速" -ForegroundColor Yellow
Write-Host "2. AI不响应 → 执行 'ollama serve' 启动AI服务" -ForegroundColor Yellow  
Write-Host "3. 应用无法启动 → 执行 'npm install' 重新安装依赖" -ForegroundColor Yellow
Write-Host "4. 编译错误 → 检查Node.js版本 (需要16+)" -ForegroundColor Yellow
Write-Host "5. 动画卡顿 → 关闭其他占用GPU的程序" -ForegroundColor Yellow

# 4D效果确认
Write-Host ""
Write-Host "🎨 4D效果确认清单:" -ForegroundColor Magenta
Write-Host "================================" -ForegroundColor Magenta
Write-Host "✅ 背景粒子动画 (小点缓慢移动)" -ForegroundColor White
Write-Host "✅ 卡片悬停3D效果 (鼠标悬停时上升)" -ForegroundColor White
Write-Host "✅ 发光边框效果 (青色光芒)" -ForegroundColor White
Write-Host "✅ 实时数据更新 (数字和图表)" -ForegroundColor White
Write-Host "✅ 流畅动画过渡 (60FPS)" -ForegroundColor White

# 完成状态
Write-Host ""
Write-Host "🎉 UltraModern4D系统状态检查完成！" -ForegroundColor Green
Write-Host ""
Write-Host "📖 详细文档:" -ForegroundColor Cyan
Write-Host "  - ULTRAMODERN-4D-EXPERIENCE-GUIDE.md" -ForegroundColor White
Write-Host "  - 4D-VISUAL-EFFECTS-GUIDE.md" -ForegroundColor White
Write-Host "  - ULTRAMODERN-4D-UPGRADE-REPORT.md" -ForegroundColor White

Write-Host ""
Write-Host "🚀 享受您的4D科技感管理系统！" -ForegroundColor Green
