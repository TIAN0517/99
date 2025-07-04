# 智慧瓦斯AI管理系統（企業級）

## 企業級功能亮點
- Gemini/DeepSeek/OpenAI API自動切換，API Key存於.env
- 全RWD響應、卡片分頁、品牌色#2676ff/#ff9a3c、LOGO、Orbitron字型、Neon發光
- 多用戶登入、權限分級、查詢歷史、API健康檢查、流量統計、公告Banner
- 健康檢查/查詢/回覆/錯誤皆美化，API自動切備用
- 結構清晰：components/、pages/、assets/、styles/、utils/、config.js
- PWA支援，manifest、favicon、SEO、404頁、robots.txt

## 一鍵部署
```bash
npm install
npm run dev
# 後端（如有）
uvicorn app:app --reload
```

## API金鑰設定
.env 內填入：
```
GEMINI_API_KEY=xxx
DEEPSEEK_API_KEY=xxx
OPENAI_API_KEY=xxx
AI_PROVIDER=gemini # 可選 gemini/deepseek/openai
```

## AI 模型與 API Key 設定

- 本系統目前AI模型：**Google Gemini 1.5 Pro (modelVersion: gemini-1.5-pro-002)**
- API Key 已於 `config.py` 及 `.env` 設定，預設金鑰：`GEMINI_API_KEY = "AIzaSyD7bIKgCLX4A6bn8uIoNQQPon1PRCXYMA8"`
- **安全提醒：請勿公開API金鑰於公開文件或網路**
- 若API金鑰流量用盡，系統將自動顯示友善提示，僅需於 `.env` 或 `config.py` 更換金鑰，無須重啟前端

## 主要結構
- src/renderer/components/ 主要元件
- src/renderer/pages/ 分頁
- src/renderer/assets/ LOGO等
- src/renderer/styles/ 主題
- src/renderer/config.js AI API設定
- src/renderer/utils/ 工具
- public/ 靜態資源、favicon、manifest、404

## 企業級維護/擴充
- 新增分頁/模組：於 pages/ 新增檔案並註冊於 App.tsx
- 新增API：於 config.js 設定API資訊
- LOGO/品牌色/字型可於 assets/、styles/theme.css 調整
- 權限/公告/健康檢查可於 components/ 擴充
- favicon、manifest、SEO meta、404頁可於 public/ 調整

## 進階
- API流量將盡自動警告，API錯誤自動切換備用
- 查詢歷史自動儲存localStorage
- Unicode自動decode顯示
- PWA支援，手機可安裝桌面捷徑

---

> 2025/06/25 由AI自動優化產生
#   9 9  
 