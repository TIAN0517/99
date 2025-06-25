import requests
import json

api_key = "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"

headers = {
    "Authorization": f"Bearer {api_key}",
    "Content-Type": "application/json"
}

payload = {
    "model": "openchat/openchat-3.5-0106",  # ✅ 改為有效模型 ID
    "messages": [
        {"role": "system", "content": "你是客服助理，請用繁體中文回覆。"},
        {"role": "user", "content": "我想查詢最近一次瓦斯使用紀錄"}
    ],
    "stream": False
}

try:
    response = requests.post(
        url="https://openrouter.ai/api/v1/chat/completions",
        headers=headers,
        data=json.dumps(payload)
    )

    if response.status_code == 200:
        data = response.json()
        reply = data["choices"][0]["message"]["content"]
        print("✅ AI 回覆：", reply)
    else:
        print(f"❌ 錯誤：{response.status_code}")
        print(response.text)

except Exception as e:
    print("⚠️ 發生例外錯誤：", str(e))
