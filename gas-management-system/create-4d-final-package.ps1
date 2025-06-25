# PowerShell script to create final 4D Gas Management System package
# 4D科技感瓦斯管理系統 - 最終打包腳本

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$packageName = "gas-4d-tech-system-final-$timestamp"
$packagePath = "$packageName"

Write-Host "🚀 開始創建4D科技感瓦斯管理系統最終版本..."
Write-Host "📦 打包名稱: $packageName"

# 創建打包目錄
New-Item -ItemType Directory -Path $packagePath -Force

# 核心應用文件
Write-Host "📂 複製核心應用文件..."
Copy-Item "src" -Destination "$packagePath/src" -Recurse -Force
Copy-Item "package.json" -Destination "$packagePath/" -Force
Copy-Item "tsconfig.json" -Destination "$packagePath/" -Force
Copy-Item "webpack.config.js" -Destination "$packagePath/" -Force
Copy-Item "electron-builder.json" -Destination "$packagePath/" -Force

# 4D科技感服務器
Write-Host "🌟 複製4D科技感服務器..."
Copy-Item "gas-4d-ultimate.js" -Destination "$packagePath/" -Force

# 啟動腳本
Write-Host "🚀 複製啟動腳本..."
Copy-Item "start-4d-system.bat" -Destination "$packagePath/" -Force
Copy-Item "start-4d-system.sh" -Destination "$packagePath/" -Force

# 文檔
Write-Host "📚 複製文檔..."
Copy-Item "README-4D.md" -Destination "$packagePath/" -Force
Copy-Item "TESTING-GUIDE.md" -Destination "$packagePath/" -Force
Copy-Item "DELIVERY-REPORT.md" -Destination "$packagePath/" -Force

# VPS部署相關
Write-Host "🌐 複製VPS部署文件..."
Copy-Item "diagnose-vps-connection.sh" -Destination "$packagePath/" -Force
Copy-Item "fix-vps-connection.sh" -Destination "$packagePath/" -Force
Copy-Item "one-click-start-vps.sh" -Destination "$packagePath/" -Force

# AI相關
Write-Host "🤖 複製AI配置文件..."
Copy-Item "setup-ai-for-vps.sh" -Destination "$packagePath/" -Force
Copy-Item "AI-MODEL-GUIDE.md" -Destination "$packagePath/" -Force

# 創建安裝說明
Write-Host "📝 創建安裝說明..."
@"
# 🚀 4D科技感瓦斯管理系統 - 安裝指南

## 快速啟動

### Windows 用戶
1. 解壓此壓縮包
2. 雙擊運行 ``start-4d-system.bat``
3. 等待自動安裝依賴和啟動

### Linux/macOS 用戶
1. 解壓此壓縮包
2. 給予執行權限: ``chmod +x start-4d-system.sh``
3. 運行: ``./start-4d-system.sh``

### VPS 部署
1. 上傳整個文件夾到VPS
2. 運行: ``./one-click-start-vps.sh``
3. 訪問: ``http://您的VPS_IP:3000``

## 功能特色

- 🎨 4D科技感無邊框界面
- 🤖 AI智能助理 (Llama3 8B)
- 📊 實時業務統計儀表板
- 💬 浮動聊天窗口
- 🌐 Web版本 + 桌面版

## 技術支持

**Jy技術團隊** - 專業系統開發
- 24/7 技術支持
- 功能定制開發
- 系統維護升級

打包時間: $timestamp
"@ | Out-File -FilePath "$packagePath/安裝說明.txt" -Encoding UTF8

# 創建版本信息
@"
{
  "name": "4D科技感瓦斯管理系統",
  "version": "1.0.0",
  "build": "$timestamp",
  "features": [
    "4D科技感界面設計",
    "AI智能助理集成",
    "無邊框窗口",
    "實時統計儀表板",
    "跨平台支持"
  ],
  "developer": "Jy技術團隊",
  "date": "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}
"@ | Out-File -FilePath "$packagePath/version.json" -Encoding UTF8

# 壓縮打包
Write-Host "🗜️ 開始壓縮..."
Compress-Archive -Path $packagePath -DestinationPath "$packageName.zip" -Force

# 清理臨時目錄
Remove-Item -Path $packagePath -Recurse -Force

# 完成
$packageSize = [math]::Round((Get-Item "$packageName.zip").Length / 1MB, 2)
Write-Host ""
Write-Host "✅ 打包完成！"
Write-Host "📦 文件名: $packageName.zip"
Write-Host "📏 文件大小: $packageSize MB"
Write-Host ""
Write-Host "🎯 包含內容:"
Write-Host "   - 4D科技感完整源代碼"
Write-Host "   - AI聊天窗口組件"
Write-Host "   - 一鍵啟動腳本"
Write-Host "   - VPS部署工具"
Write-Host "   - 完整使用文檔"
Write-Host ""
Write-Host "🚀 現在可以分發此壓縮包了！"
