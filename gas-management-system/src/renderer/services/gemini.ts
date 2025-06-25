// Google Gemini 1.5 Pro API 封裝
export async function geminiChat({
    apiKey,
    messages
}: {
    apiKey: string;
    messages: { role: 'user' | 'model', content: string }[];
}): Promise<string> {
    const url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-latest:generateContent?key=' + apiKey;
    const body = {
        contents: messages.map(m => ({ role: m.role, parts: [{ text: m.content }] })),
        generationConfig: {
            temperature: 0.7,
            topP: 0.9,
            maxOutputTokens: 1024
        }
    };
    const res = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
    });
    if (!res.ok) throw new Error('Gemini API 請求失敗: ' + res.status);
    const data = await res.json();
    if (data.candidates && data.candidates[0]?.content?.parts[0]?.text) {
        return data.candidates[0].content.parts[0].text;
    }
    throw new Error('Gemini API 回應為空');
}
