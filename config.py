# config.py
# 目前僅支援 Google Gemini 1.5 Pro
# 本專案AI API Key: 請勿公開於公開文件
import os
from dotenv import load_dotenv

load_dotenv()

# AI模型與API金鑰設定
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "AIzaSyD7bIKgCLX4A6bn8uIoNQQPon1PRCXYMA8")
AI_MODEL = "Gemini 1.5 Pro"

# 若需更換API Key，請直接修改.env或本檔案，無須重啟前端
