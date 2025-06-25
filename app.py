from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import ai, modules

app = FastAPI(title="智慧瓦斯AI管理系統 API", description="企業級API，支援Gemini/DeepSeek/OpenAI自動分流")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 掛載AI與模組API
app.include_router(ai.router, prefix="/api")
app.include_router(modules.router, prefix="/api")

@app.get("/api/healthz")
def healthz():
    return {"status": "ok", "msg": "API運作正常"}

# 其他API可依需求擴充
