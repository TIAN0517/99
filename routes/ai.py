from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import requests
from config import GEMINI_API_KEY, AI_MODEL

router = APIRouter()

GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-002:generateContent"

class AIRequest(BaseModel):
    prompt: str
    user_role: str = "user"  # 可用於權限判斷

# 共用呼叫函式

def call_gemini(prompt: str):
    headers = {"Content-Type": "application/json"}
    data = {
        "contents": [{"parts": [{"text": f"請用繁體中文詳細回答：{prompt}"}]}]
    }
    params = {"key": GEMINI_API_KEY}
    resp = requests.post(GEMINI_API_URL, headers=headers, json=data, params=params)
    if resp.status_code == 200:
        result = resp.json()
        answer = result.get("candidates", [{}])[0].get("content", {}).get("parts", [{}])[0].get("text", "")
        return answer
    elif resp.status_code == 429:
        raise HTTPException(status_code=429, detail="API 金鑰流量已用盡，請聯絡管理員更換 API KEY。")
    else:
        raise HTTPException(status_code=resp.status_code, detail=resp.text)

@router.post("/ai_ask")
def ai_ask(req: AIRequest):
    answer = call_gemini(req.prompt)
    return {
        "answer": answer,
        "ai_model": AI_MODEL,
        "api_key": GEMINI_API_KEY if req.user_role == "admin" else "***隱藏***"
    }

@router.post("/ai_chat")
def ai_chat(req: AIRequest):
    answer = call_gemini(req.prompt)
    return {
        "answer": answer,
        "ai_model": AI_MODEL,
        "api_key": GEMINI_API_KEY if req.user_role == "admin" else "***隱藏***"
    }

@router.post("/faq")
def ai_faq(req: AIRequest):
    answer = call_gemini(req.prompt)
    return {
        "answer": answer,
        "ai_model": AI_MODEL,
        "api_key": GEMINI_API_KEY if req.user_role == "admin" else "***隱藏***"
    }

@router.post("/analyze")
def ai_analyze(req: AIRequest):
    answer = call_gemini(req.prompt)
    return {
        "answer": answer,
        "ai_model": AI_MODEL,
        "api_key": GEMINI_API_KEY if req.user_role == "admin" else "***隱藏***"
    }
