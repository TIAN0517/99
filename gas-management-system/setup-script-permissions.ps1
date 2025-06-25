# 瓦斯行管理系统 - 脚本权限设置工具
# Jy技術團隊 2025

Write-Host "🔧 瓦斯行管理系统 - 脚本权限设置" -ForegroundColor Cyan
Write-Host "Jy技術團隊 2025" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Yellow

# 定义需要设置权限的脚本文件
$scripts = @(
    "external-access-manager.sh",
    "deploy-external-access.sh", 
    "configure-external-access.sh",
    "quick-external-access.sh",
    "setup-ssl-certificate.sh",
    "test-network-connectivity.sh",
    "troubleshoot-external-access.sh",
    "setup-external-access.sh",
    "check-network-config.sh",
    "deploy-vps-linux.sh",
    "quick-deploy-linux.sh",
    "optimize-vps-performance.sh",
    "quick-optimize.sh"
)

Write-Host ""
Write-Host "正在检查和设置脚本权限..." -ForegroundColor Blue
Write-Host ""

$foundScripts = 0
$processedScripts = 0

foreach ($script in $scripts) {
    if (Test-Path $script) {
        $foundScripts++
        Write-Host "✅ 找到脚本: $script" -ForegroundColor Green
        
        # 在 Windows 下，我们主要检查文件是否存在
        # 实际的执行权限将在 Linux 环境中由 chmod 命令设置
        try {
            # 检查文件是否可读
            $content = Get-Content $script -TotalCount 1 -ErrorAction Stop
            Write-Host "   📖 文件可读" -ForegroundColor Gray
            $processedScripts++
        }
        catch {
            Write-Host "   ❌ 文件读取失败: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "⚠️  未找到脚本: $script" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "📊 处理结果:" -ForegroundColor Cyan
Write-Host "   找到脚本: $foundScripts 个" -ForegroundColor White
Write-Host "   处理成功: $processedScripts 个" -ForegroundColor White

Write-Host ""
Write-Host "🐧 Linux 环境权限设置命令:" -ForegroundColor Yellow
Write-Host ""

foreach ($script in $scripts) {
    if (Test-Path $script) {
        Write-Host "chmod +x $script" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "📋 一键设置所有权限 (Linux):" -ForegroundColor Yellow
Write-Host "chmod +x *.sh" -ForegroundColor Gray

Write-Host ""
Write-Host "🎯 推荐使用方式:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Windows 开发环境:" -ForegroundColor White
Write-Host "   .\configure-external-access.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Linux 生产环境:" -ForegroundColor White
Write-Host "   sudo chmod +x *.sh" -ForegroundColor Gray
Write-Host "   sudo ./external-access-manager.sh" -ForegroundColor Gray
Write-Host ""
Write-Host "3. 快速配置:" -ForegroundColor White
Write-Host "   sudo ./quick-external-access.sh" -ForegroundColor Gray
Write-Host ""

if ($foundScripts -gt 0) {
    Write-Host "✅ 脚本权限检查完成！" -ForegroundColor Green
}
else {
    Write-Host "❌ 未找到任何脚本文件！" -ForegroundColor Red
    Write-Host "   请确保在正确的目录中运行此脚本" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🔧 Jy技術團隊 2025 - 专业瓦斯行管理解决方案" -ForegroundColor Green
