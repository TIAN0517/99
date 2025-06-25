# PowerShell script to create complete VPS deployment package
# 包含所有必要的配置文件

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$packageName = "gas-4d-vps-complete-$tiWrite-Host "🚀 VPS部署步驟:"
Write-Host "   1. 上傳壓縮包到VPS"
Write-Host "   2. 解壓: unzip $packageName.zip"
Write-Host "   3. 進入目錄: cd $packageName"
Write-Host "   4. 運行: ./vps-quick-start.sh"
Write-Host "   5. 訪問: http://VPS_IP:3000"p"
$packagePath = "$packageName"

Write-Host "🚀 創建完整的VPS部署包..."
Write-Host "📦 包名: $packageName"

# 創建打包目錄
New-Item -ItemType Directory -Path $packagePath -Force

# 複製完整源代碼
Write-Host "📂 複製源代碼..."
Copy-Item "src" -Destination "$packagePath/src" -Recurse -Force

# 複製配置文件
Write-Host "⚙️ 複製配置文件..."
Copy-Item "package.json" -Destination "$packagePath/" -Force
Copy-Item "tsconfig.json" -Destination "$packagePath/" -Force
Copy-Item "webpack.config.js" -Destination "$packagePath/" -Force
Copy-Item "electron-builder.json" -Destination "$packagePath/" -Force

# 複製服務器文件
Write-Host "🌐 複製服務器文件..."
Copy-Item "gas-4d-ultimate.js" -Destination "$packagePath/" -Force

# 複製修復腳本
Write-Host "🔧 複製修復腳本..."
Copy-Item "fix-vps-deployment.sh" -Destination "$packagePath/" -Force
Copy-Item "diagnose-vps-connection.sh" -Destination "$packagePath/" -Force

# 複製啟動腳本
Write-Host "🚀 複製啟動腳本..."
Copy-Item "start-4d-system.sh" -Destination "$packagePath/" -Force

# 複製文檔
Write-Host "📚 複製文檔..."
Copy-Item "README-4D.md" -Destination "$packagePath/" -Force
Copy-Item "4D-SYSTEM-USAGE-GUIDE.md" -Destination "$packagePath/" -Force

# 創建VPS專用快速啟動腳本
Write-Host "📝 創建VPS快速啟動腳本..."
@"
#!/bin/bash
# VPS快速啟動腳本 - 4D科技感瓦斯管理系統

echo "🚀 4D科技感瓦斯管理系統 - VPS快速啟動"
echo "=============================================="

# 檢查並修復部署問題
if [ -f "fix-vps-deployment.sh" ]; then
    echo "🔧 運行部署修復腳本..."
    chmod +x fix-vps-deployment.sh
    ./fix-vps-deployment.sh
else
    echo "🌐 直接啟動4D Web版本..."
    
    # 停止現有服務
    pkill -f "node.*gas" 2>/dev/null || true
    
    # 檢查Node.js
    if ! command -v node &> /dev/null; then
        echo "❌ Node.js 未安裝，請先安裝"
        exit 1
    fi
    
    # 啟動服務
    echo "🔥 啟動4D科技感瓦斯管理系統..."
    nohup node gas-4d-ultimate.js > gas-system.log 2>&1 &
    
    sleep 3
    echo "✅ 服務已啟動！"
    echo "🌐 訪問地址: http://`$(curl -s ifconfig.me)`:3000"
fi
"@ | Out-File -FilePath "$packagePath/vps-quick-start.sh" -Encoding UTF8

# 創建VPS安裝說明
@"
# 🌐 VPS部署指南 - 4D科技感瓦斯管理系統

## 快速部署步驟

### 1. 上傳文件
將整個 `$packageName` 文件夾上傳到VPS

### 2. 設置權限
```bash
cd $packageName
chmod +x *.sh
```

### 3. 一鍵啟動
```bash
./vps-quick-start.sh
```

### 4. 如遇問題，運行修復
```bash
./fix-vps-deployment.sh
```

## 訪問系統
- **Web界面**: http://您的VPS_IP:3000
- **AI聊天**: 點擊🤖按鈕

## 功能特色
- 🎨 4D科技感無邊框界面
- 🤖 AI智能助理
- 📊 實時統計儀表板
- 💬 浮動聊天窗口

## 故障排除
1. 運行診斷腳本: `./diagnose-vps-connection.sh`
2. 檢查服務日誌: `tail -f gas-system.log`
3. 重啟服務: `pkill -f node && ./vps-quick-start.sh`

## 系統要求
- Ubuntu 18.04+
- Node.js 16+
- 1GB+ 內存
- 端口3000開放

---
**Jy技術團隊** - 專業VPS部署解決方案
"@ | Out-File -FilePath "$packagePath/VPS-部署指南.md" -Encoding UTF8

# 創建系統信息文件
@"
{
  "system": "4D科技感瓦斯管理系統",
  "version": "1.0.0-vps",
  "build": "$timestamp",
  "deployment": "VPS專用版本",
  "features": [
    "完整源代碼",
    "配置文件齊全",
    "一鍵部署腳本",
    "故障診斷工具",
    "修復工具包"
  ],
  "developer": "Jy技術團隊",
  "support": "24/7 技術支持"
}
"@ | Out-File -FilePath "$packagePath/system-info.json" -Encoding UTF8

# 壓縮打包
Write-Host "🗜️ 正在壓縮..."
Compress-Archive -Path $packagePath -DestinationPath "$packageName.zip" -Force

# 清理
Remove-Item -Path $packagePath -Recurse -Force

# 顯示結果
$packageSize = [math]::Round((Get-Item "$packageName.zip").Length / 1MB, 2)
Write-Host ""
Write-Host "✅ VPS部署包創建完成！"
Write-Host "📦 文件名: $packageName.zip"
Write-Host "📏 大小: $packageSize MB"
Write-Host ""
Write-Host "🎯 包含內容:"
Write-Host "   ✅ 完整源代碼和配置"
Write-Host "   ✅ VPS一鍵部署腳本"
Write-Host "   ✅ 故障診斷和修復工具"
Write-Host "   ✅ 4D科技感Web服務器"
Write-Host "   ✅ 詳細部署文檔"
Write-Host ""
Write-Host "🚀 VPS部署步驟:"
Write-Host "   1. 上傳壓縮包到VPS"
Write-Host "   2. 解壓: unzip $packageName.zip"
Write-Host "   3. 進入目錄: cd $packageName"
Write-Host "   4. 運行: ./vps-quick-start.sh"
Write-Host "   5. 訪問: http://VPS_IP:3000"
