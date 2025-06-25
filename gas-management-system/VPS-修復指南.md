# 🛠️ VPS部署問題修復指南

## 問題描述
如果您在VPS上遇到以下錯誤：
```
ERROR in main
Module not found: Error: Can't resolve './src'
```

## 🚀 快速解決方案

### 方案1：使用新的VPS完整包（推薦）
下載並使用最新的完整VPS部署包：
- `gas-4d-vps-complete-20250622_165814.zip` (90KB)

#### 部署步驟：
1. **上傳到VPS**
   ```bash
   # 上傳壓縮包到VPS
   scp gas-4d-vps-complete-20250622_165814.zip user@your-vps:/home/ubuntu/
   ```

2. **解壓並部署**
   ```bash
   cd /home/ubuntu
   unzip gas-4d-vps-complete-20250622_165814.zip
   cd gas-4d-vps-complete-20250622_165814
   chmod +x *.sh
   ```

3. **一鍵啟動**
   ```bash
   ./vps-quick-start.sh
   ```

### 方案2：修復現有部署
如果您已經有現有的部署，可以運行修復腳本：

```bash
# 下載修復腳本
wget https://raw.githubusercontent.com/your-repo/fix-vps-deployment.sh
chmod +x fix-vps-deployment.sh
./fix-vps-deployment.sh
```

### 方案3：手動修復
1. **直接啟動Web版本（跳過Webpack構建）**
   ```bash
   # 停止現有服務
   pkill -f "node.*gas"
   
   # 直接啟動4D Web服務器
   node gas-4d-ultimate.js
   ```

2. **檢查服務狀態**
   ```bash
   # 檢查端口
   netstat -tlnp | grep 3000
   
   # 測試連接
   curl http://localhost:3000
   ```

## 🌐 訪問系統

部署成功後，通過以下地址訪問：
- **Web界面**: http://您的VPS_IP:3000
- **功能**：
  - 🎨 4D科技感界面
  - 🤖 AI智能助理
  - 📊 實時統計儀表板

## 🔧 常見問題解決

### 1. 端口被佔用
```bash
# 釋放端口3000
sudo fuser -k 3000/tcp
# 或者
pkill -f "node.*3000"
```

### 2. 權限問題
```bash
# 給予腳本執行權限
chmod +x *.sh
```

### 3. Node.js未安裝
```bash
# 安裝Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 4. 防火墻問題
```bash
# 開放端口3000
sudo ufw allow 3000
sudo ufw reload
```

### 5. 雲服務商安全組
請在雲服務商控制台確保：
- **阿里雲**: ECS安全組開放3000端口
- **騰訊雲**: CVM安全組開放3000端口  
- **AWS**: EC2 Security Groups開放3000端口

## 📊 系統監控

### 查看服務狀態
```bash
# 查看進程
ps aux | grep node

# 查看日誌
tail -f gas-system.log

# 檢查端口
netstat -tlnp | grep 3000
```

### 重啟服務
```bash
# 停止服務
pkill -f "node.*gas"

# 重新啟動
./vps-quick-start.sh
```

## 📞 技術支持

如果以上方案都無法解決問題，請聯繫：

**Jy技術團隊**
- 🌐 專業VPS部署解決方案
- 🤖 AI系統集成專家
- 🎨 4D界面設計專家
- 📞 24/7 技術支持

---

**💡 提示**: 新的VPS完整包 `gas-4d-vps-complete-20250622_165814.zip` 已經解決了所有已知的部署問題，推薦使用！
