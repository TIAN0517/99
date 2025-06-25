// 支援多AI API自動切換
export const AI_CONFIG = {
    provider: process.env.AI_PROVIDER || 'gemini',
    gemini: {
        apiKey: process.env.GEMINI_API_KEY || '',
        model: 'gemini-1.5-pro-latest',
    },
    deepseek: {
        apiKey: process.env.DEEPSEEK_API_KEY || '',
        model: 'deepseek-chat',
    },
    openai: {
        apiKey: process.env.OPENAI_API_KEY || '',
        model: 'gpt-4o',
    },
};
