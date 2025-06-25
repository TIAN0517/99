import requests
import json

# 四個可測試的模型 ID
model_list = [
    "openchat/openchat-3.5-0106",
    "mistralai/mixtral-8x7b",
    "meta-llama/llama-3-8b-chat",
    "nousresearch/nous-capybara-7b"
]

# API Key（用戶提供的 OpenRouter Key）
api_key = "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"

# 準備標頭
headers = {
    "Authorization": f"Bearer {api_key}",
    "Content-Type": "application/json"
}

# 測試輸入內容
messages = [
    {"role": "system", "content": "你是客服助理，請用繁體中文回答使用者問題。"},
    {"role": "user", "content": "請問瓦斯費可以線上繳費嗎？"}
]

# 儲存回應結果
results = []

# 執行每個模型測試
for model_id in model_list:
    payload = {
        "model": model_id,
        "messages": messages,
        "stream": False
    }

    try:
        response = requests.post(
            url="https://openrouter.ai/api/v1/chat/completions",
            headers=headers,
            data=json.dumps(payload),
            timeout=15
        )

        if response.status_code == 200:
            reply = response.json()["choices"][0]["message"]["content"]
            results.append((model_id, "✅ 成功", reply.strip()))
        else:
            results.append((model_id, f"❌ 錯誤 {response.status_code}", response.text.strip()))
    except Exception as e:
        results.append((model_id, "⚠️ 例外錯誤", str(e)))

import pandas as pd
df = pd.DataFrame(results, columns=["模型 ID", "狀態", "回應內容"])
import ace_tools as tools; tools.display_dataframe_to_user(name="OpenRouter API 測試結果", dataframe=df)
