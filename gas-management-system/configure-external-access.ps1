# 瓦斯行管理系统 - Windows 外网访问配置脚本
# Jy技術團隊 2025

Write-Host "🌐 瓦斯行管理系统 - Windows 外网访问配置指南" -ForegroundColor Cyan
Write-Host "Jy技術團隊 2025" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Yellow

function Write-Info {
    param($Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param($Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param($Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param($Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# 检查管理员权限
function Test-AdminRights {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# 获取公网IP
function Get-PublicIP {
    try {
        $ip = Invoke-RestMethod -Uri "https://ifconfig.me/ip" -TimeoutSec 10
        return $ip.Trim()
    }
    catch {
        try {
            $ip = Invoke-RestMethod -Uri "https://ipinfo.io/ip" -TimeoutSec 10
            return $ip.Trim()
        }
        catch {
            return "获取失败"
        }
    }
}

# 获取本地IP
function Get-LocalIP {
    $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.InterfaceDescription -notlike "*Loopback*" }
    foreach ($adapter in $adapters) {
        $ip = Get-NetIPAddress -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne "127.0.0.1" }
        if ($ip) {
            return $ip.IPAddress
        }
    }
    return "获取失败"
}

# 配置Windows防火墙
function Configure-WindowsFirewall {
    Write-Info "配置 Windows 防火墙..."
    
    try {
        # 检查防火墙规则是否已存在
        $existingRule = Get-NetFirewallRule -DisplayName "瓦斯管理系统" -ErrorAction SilentlyContinue
        
        if ($existingRule) {
            Write-Success "防火墙规则已存在"
        }
        else {
            # 创建入站规则
            New-NetFirewallRule -DisplayName "瓦斯管理系统" -Direction Inbound -Protocol TCP -LocalPort 3000 -Action Allow -Description "Jy技術團隊 瓦斯行管理系统"
            Write-Success "Windows 防火墙规则已创建"
        }
        
        # 显示相关防火墙规则
        Write-Info "当前防火墙规则:"
        Get-NetFirewallRule -DisplayName "*瓦斯*" | Format-Table DisplayName, Direction, Action, Enabled
    }
    catch {
        Write-Error "配置防火墙失败: $($_.Exception.Message)"
        Write-Warning "请手动在 Windows 防火墙中开放端口 3000"
    }
}

# 检查应用状态
function Test-ApplicationStatus {
    Write-Info "检查应用状态..."
    
    # 检查端口监听
    $portTest = Test-NetConnection -ComputerName localhost -Port 3000 -InformationLevel Quiet
    
    if ($portTest) {
        Write-Success "端口 3000 正在监听"
        return $true
    }
    else {
        Write-Warning "端口 3000 未在监听"
        return $false
    }
}

# 检查Node.js进程
function Test-NodeProcess {
    $nodeProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue
    $npmProcesses = Get-Process -Name "npm" -ErrorAction SilentlyContinue
    
    if ($nodeProcesses -or $npmProcesses) {
        Write-Success "检测到 Node.js 应用正在运行"
        Write-Info "运行中的进程:"
        if ($nodeProcesses) {
            $nodeProcesses | Format-Table Id, ProcessName, CPU, WorkingSet
        }
        if ($npmProcesses) {
            $npmProcesses | Format-Table Id, ProcessName, CPU, WorkingSet
        }
        return $true
    }
    else {
        Write-Warning "未检测到 Node.js 应用进程"
        return $false
    }
}

# 测试网络连接
function Test-NetworkConnectivity {
    Write-Info "测试网络连接..."
    
    # 测试本地连接
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3000" -TimeoutSec 10 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Success "本地访问测试成功"
        }
    }
    catch {
        Write-Warning "本地访问测试失败: $($_.Exception.Message)"
    }
    
    # 测试外网连接
    try {
        $connectivity = Test-Connection -ComputerName "8.8.8.8" -Count 2 -Quiet
        if ($connectivity) {
            Write-Success "外网连接正常"
        }
        else {
            Write-Warning "外网连接异常"
        }
    }
    catch {
        Write-Warning "网络连接测试失败"
    }
}

# 显示访问信息
function Show-AccessInfo {
    param(
        [string]$PublicIP,
        [string]$LocalIP
    )
    
    Write-Host ""
    Write-Host "🎉 外网访问配置检查完成！" -ForegroundColor Green
    Write-Host "======================================" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Success "访问地址:"
    Write-Host "  🌍 外网访问: http://$PublicIP:3000" -ForegroundColor White
    Write-Host "  🏠 内网访问: http://$LocalIP:3000" -ForegroundColor White
    Write-Host "  💻 本地访问: http://localhost:3000" -ForegroundColor White
    Write-Host ""
    
    Write-Success "默认登录账号:"
    Write-Host "  👨‍💼 管理员: admin / password" -ForegroundColor White
    Write-Host "  👨‍💼 经理:   manager / password" -ForegroundColor White
    Write-Host "  👨‍💼 员工:   employee / password" -ForegroundColor White
    Write-Host ""
    
    Write-Warning "重要提醒:"
    Write-Host "  1. 🛡️ 确保路由器/防火墙已开放端口 3000" -ForegroundColor Yellow
    Write-Host "  2. 🔐 请立即更改默认登录密码" -ForegroundColor Yellow
    Write-Host "  3. 📊 如果是云服务器，请配置安全组" -ForegroundColor Yellow
    Write-Host "  4. 🔧 如有问题，请查看详细文档" -ForegroundColor Yellow
    Write-Host ""
}

# 启动应用
function Start-GasManagementApp {
    Write-Info "尝试启动瓦斯管理系统..."
    
    $currentPath = Get-Location
    
    # 检查是否在正确的目录
    if (-not (Test-Path "package.json")) {
        Write-Error "未找到 package.json，请确保在应用根目录运行此脚本"
        return $false
    }
    
    # 检查 Node.js
    try {
        $nodeVersion = node --version
        Write-Info "Node.js 版本: $nodeVersion"
    }
    catch {
        Write-Error "未找到 Node.js，请先安装 Node.js"
        return $false
    }
    
    # 检查依赖
    if (-not (Test-Path "node_modules")) {
        Write-Info "安装依赖..."
        npm install
    }
    
    # 启动应用
    Write-Info "启动应用..."
    Write-Host "正在启动瓦斯管理系统，请稍候..." -ForegroundColor Green
    Write-Host "启动后请不要关闭此窗口..." -ForegroundColor Yellow
    
    # 在后台启动应用
    Start-Process powershell -ArgumentList "-Command", "npm start" -WindowStyle Minimized
    
    # 等待应用启动
    Write-Host "等待应用启动..." -ForegroundColor Blue
    Start-Sleep -Seconds 10
    
    return $true
}

# 主程序
function Main {
    Write-Host ""
    
    # 检查管理员权限
    if (-not (Test-AdminRights)) {
        Write-Warning "建议以管理员权限运行以配置防火墙"
        $continue = Read-Host "是否继续？(y/N)"
        if ($continue -ne "y" -and $continue -ne "Y") {
            exit
        }
    }
    
    # 获取IP地址
    Write-Info "获取网络信息..."
    $publicIP = Get-PublicIP
    $localIP = Get-LocalIP
    
    Write-Info "公网IP: $publicIP"
    Write-Info "本地IP: $localIP"
    Write-Host ""
    
    # 配置防火墙
    if (Test-AdminRights) {
        Configure-WindowsFirewall
        Write-Host ""
    }
    
    # 检查应用状态
    $appRunning = Test-ApplicationStatus
    $processRunning = Test-NodeProcess
    
    # 如果应用未运行，询问是否启动
    if (-not $appRunning -and -not $processRunning) {
        Write-Warning "应用似乎未在运行"
        $startApp = Read-Host "是否尝试启动应用？(y/N)"
        
        if ($startApp -eq "y" -or $startApp -eq "Y") {
            $started = Start-GasManagementApp
            if ($started) {
                Write-Host "等待应用完全启动..." -ForegroundColor Blue
                Start-Sleep -Seconds 5
                $appRunning = Test-ApplicationStatus
            }
        }
    }
    
    Write-Host ""
    
    # 测试网络连接
    Test-NetworkConnectivity
    Write-Host ""
    
    # 显示访问信息
    Show-AccessInfo -PublicIP $publicIP -LocalIP $localIP
    
    # 额外说明
    Write-Host "📖 详细配置说明:" -ForegroundColor Cyan
    Write-Host "   查看 EXTERNAL-ACCESS-GUIDE.md 文档" -ForegroundColor White
    Write-Host ""
    Write-Host "🔧 Windows 特别说明:" -ForegroundColor Cyan
    Write-Host "   • 如果是家用网络，可能需要配置路由器端口转发" -ForegroundColor White
    Write-Host "   • 如果是云服务器，请配置安全组开放端口 3000" -ForegroundColor White
    Write-Host "   • 杀毒软件可能会阻止网络访问，请添加信任" -ForegroundColor White
    Write-Host ""
    Write-Host "🌟 Jy技術團隊 2025 - 专业瓦斯行管理解决方案" -ForegroundColor Green
}

# 执行主程序
Main
