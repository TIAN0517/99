# Jy技術團隊 - 瓦斯行管理系統

![Jy技術團隊](https://img.shields.io/badge/Developed%20by-Jy%E6%8A%80%E8%A1%93%E5%9C%98%E9%9A%8A-blue?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-1.0.0-green?style=for-the-badge)
![Electron](https://img.shields.io/badge/Electron-Latest-purple?style=for-the-badge)
![React](https://img.shields.io/badge/React-18+-blue?style=for-the-badge)

一個現代化的瓦斯行業務管理系統，採用最新的4D邊框設計與AI智能助理技術。

## ✨ 主要特色

### 🎨 現代化4D邊框設計
- 科技感十足的4D邊框界面  
- 流暢的動畫效果與過渡
- 響應式設計適應各種螢幕尺寸
- 深色主題配色方案

### 🤖 AI智能助理 - "董娘的助理"
- 整合Ollama本地AI模型 (deepseek-r1:8b)
- 專業的瓦斯行業務諮詢
- 即時客服與問題解答
- 支援繁體中文對話

### 💼 完整業務管理功能

- 🚀 **現代化 4D 無邊框界面設計**
- 🤖 **AI 智能助理** - 董娘的助理
- 📊 **即時營運儀表板**
- 🛢️ **產品庫存管理**
- 📋 **訂單管理系統**
- 👥 **客戶關係管理**
- 💰 **財務分析功能**
- 🔐 **安全登入系統**

## 技術棧

- **前端**: React 19 + TypeScript
- **桌面框架**: Electron 36
- **打包工具**: Webpack 5
- **AI 集成**: Ollama
- **樣式**: 原生 CSS3 (科技感設計)

## 系統要求

- Node.js 18+
- Windows 10/11, macOS 10.15+, 或 Linux
- Ollama (用於 AI 助理功能)

## 安裝與運行

## 🚀 VPS 部署指南

### 快速部署（推荐）

1. **上传文件到 VPS**：
   ```bash
   # 上传部署包到 VPS 的 /root/ 目录
   scp gas-management-system-vps-package.zip root@your-vps-ip:/root/
   ```

2. **执行一键部署脚本**：
   ```bash
   # SSH 连接到 VPS
   ssh root@your-vps-ip
   
   # 解压并运行部署脚本
   cd /root
   unzip gas-management-system-vps-package.zip
   cd gas-management-system
   chmod +x deploy-vps-complete.sh
   ./deploy-vps-complete.sh
   ```

3. **访问应用**：
   - 应用界面：`http://your-vps-ip:3000`
   - AI API：`http://your-vps-ip:11434`

### 内存优化配置

#### 高配置 VPS (≥6GB 内存)
- AI 模型：`deepseek-r1:8b`
- 功能：完整 AI 功能，复杂推理

#### 中配置 VPS (3-6GB 内存)  
- AI 模型：`gemma:2b`
- 功能：基础 AI 对话，轻量级推理

#### 低配置 VPS (<3GB 内存)
- AI 模型：`phi3:mini`
- 功能：简单对话，基础问答

### 开发环境部署

### 1. 安裝依賴
```bash
npm install
```

### 2. 開發模式
```bash
npm run dev
```

### 3. 構建應用
```bash
npm run build
```

### 4. 啟動應用
```bash
npm start
```

### 5. 打包發布
```bash
npm run dist
```

## 演示帳號

| 角色 | 用戶名 | 密碼 |
|------|--------|------|
| 管理員 | admin | password |
| 經理 | manager | password |
| 員工 | employee | password |

## AI 助理設置

為了使用 AI 助理功能，請先安裝並運行 Ollama：

### 安裝 Ollama
```bash
# Windows
winget install Ollama.Ollama

# macOS
brew install ollama

# Linux
curl -fsSL https://ollama.ai/install.sh | sh
```

### 運行模型
```bash
ollama run deepseek-r1:8b
```

## 項目結構

```
gas-management-system/
├── src/
│   ├── main/           # Electron 主進程
│   ├── renderer/       # React 渲染進程
│   │   ├── components/ # 可重用組件
│   │   ├── pages/      # 頁面組件
│   │   ├── services/   # 服務層
│   │   └── styles/     # 樣式文件
│   ├── preload.ts      # 預載脚本
│   └── types.ts        # 類型定義
├── dist/               # 構建輸出
└── package.json
```

## 功能說明

### 登入系統
- 支持多角色權限管理
- 安全的用戶驗證
- 自動保存登入狀態

### 儀表板
- 即時營收統計
- 訂單狀態監控
- 庫存警報提醒
- 客戶數據概覽

### 產品管理
- 產品資訊維護
- 庫存數量追蹤
- 成本價格管理
- 供應商資訊

### 訂單管理
- 訂單建立與編輯
- 配送狀態追蹤
- 客戶資訊管理
- 訂單歷史查詢

### AI 助理
- 智能問答系統
- 營運數據分析
- 業務建議提供
- 操作指導協助

## 開發團隊

**Jy技術團隊** - 專注於現代化企業管理系統開發

## 授權協議

MIT License

## 更新日誌

### v1.0.0 (2025-06-22)
- 初始版本發布
- 基礎管理功能
- AI 助理集成
- 現代化 UI 設計

## 技術支持

如有問題或建議，請聯繫開發團隊。

---

**瓦斯行管理系統** - 讓傳統行業擁抱數位化未來 🚀
