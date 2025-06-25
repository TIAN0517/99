import axios from 'axios';

// AI 模型配置 - 针对不同内存环境优化
export interface AIModelConfig {
    name: string;
    minMemoryGB: number;
    description: string;
    capabilities: string[];
}

export const AI_MODELS: Record<string, AIModelConfig> = {
    'llama3:8b-instruct-q4_0': {
        name: 'llama3:8b-instruct-q4_0',
        minMemoryGB: 5.2,
        description: '🦙 Llama3 8B指令微调模型 - 高性能对话和推理',
        capabilities: ['中文对话', '英文对话', '代码生成', '复杂推理', '业务分析', '指令跟随']
    },
    'deepseek-r1:8b': {
        name: 'deepseek-r1:8b',
        minMemoryGB: 6.6,
        description: '高性能推理模型，支持复杂查询',
        capabilities: ['中文对话', '代码生成', '复杂推理', '业务分析']
    },
    'gemma:2b': {
        name: 'gemma:2b',
        minMemoryGB: 2.5,
        description: '轻量级模型，适合低内存环境',
        capabilities: ['中文对话', '基础查询', '文本生成']
    },
    'phi3:mini': {
        name: 'phi3:mini',
        minMemoryGB: 2.0,
        description: '微型模型，最低内存需求',
        capabilities: ['简单对话', '基础问答']
    }
};

// 自动选择合适的模型
export function selectOptimalModel(availableMemoryGB: number): string {
    if (availableMemoryGB >= 6.6) {
        return 'deepseek-r1:8b';
    } else if (availableMemoryGB >= 5.2) {
        return 'llama3:8b-instruct-q4_0';
    } else if (availableMemoryGB >= 2.5) {
        return 'gemma:2b';
    } else {
        return 'phi3:mini';
    }
}

// Ollama API 服務集成 - VPS 优化版
export class OllamaService {
    private baseUrl: string = 'http://localhost:11434';
    private model: string;
    private retryCount = 0;
    private maxRetries = 3;
    constructor(baseUrl?: string, model?: string) {
        if (baseUrl) this.baseUrl = baseUrl;

        // 根据环境自动选择合适的模型
        if (model) {
            this.model = model;
        } else {
            this.model = this.detectOptimalModel();
        }
    }    /**
     * 检测最佳模型 - 基于内存限制
     */
    private detectOptimalModel(): string {
        // 优先使用用户指定的 Llama3 模型
        if (typeof window !== 'undefined') {
            return 'llama3:8b-instruct-q4_0';
        }

        try {
            // 在 Node.js 环境中尝试检查系统内存
            const os = require('os');
            const totalMemoryGB = os.totalmem() / (1024 * 1024 * 1024);
            console.log(`🖥️ 系统内存: ${totalMemoryGB.toFixed(1)}GB`);
            return selectOptimalModel(totalMemoryGB);
        } catch {
            // 默认使用高性能 Llama3 模型
            console.log('🤖 使用默认高性能模型: llama3:8b-instruct-q4_0');
            return 'llama3:8b-instruct-q4_0';
        }
    }
    /**
     * 檢查 Ollama 服務是否可用 - 增强版
     */
    async isAvailable(): Promise<boolean> {
        try {
            const response = await fetch(`${this.baseUrl}/api/tags`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                },
            });

            if (!response.ok) {
                console.error(`❌ Ollama API 错误: ${response.status}`);
                return false;
            }

            const data = await response.json();
            console.log('🤖 可用模型:', data.models?.map((m: any) => m.name) || []);

            // 检查当前模型是否可用
            const availableModels = data.models?.map((m: any) => m.name) || [];
            if (!availableModels.includes(this.model)) {
                // 如果当前模型不可用，选择第一个可用的轻量级模型
                const fallbackModel = availableModels.find((model: string) =>
                    model.includes('gemma') ||
                    model.includes('phi3') ||
                    model.includes('llama2') ||
                    model.includes('tinyllama')
                );

                if (fallbackModel) {
                    console.log(`🔄 切换到可用模型: ${fallbackModel}`);
                    this.model = fallbackModel;
                } else if (availableModels.length > 0) {
                    console.log(`🔄 使用第一个可用模型: ${availableModels[0]}`);
                    this.model = availableModels[0];
                }
            }

            return true;
        } catch (error) {
            console.error('❌ Ollama 服务不可用:', error);
            return false;
        }
    }
    /**
     * 發送聊天消息到 Ollama - VPS 优化版
     */
    async chat(message: string, context?: string): Promise<{ message: string; error?: string }> {
        try {
            // 檢查服務是否可用
            const available = await this.isAvailable();
            if (!available) {
                return {
                    message: this.getFallbackResponse(message),
                    error: 'Service unavailable'
                };
            }

            console.log(`🤖 使用模型: ${this.model}`);

            // 構建提示詞
            const prompt = this.buildPrompt(message, context);

            const response = await fetch(`${this.baseUrl}/api/generate`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    model: this.model,
                    prompt: prompt,
                    stream: false,
                    options: {
                        temperature: 0.7,
                        top_p: 0.9,
                        max_tokens: 300, // 降低 token 限制以节省内存
                        num_ctx: 1024,   // 降低上下文窗口
                    }
                }),
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();

            if (data.response) {
                this.retryCount = 0; // 重置重试计数
                return {
                    message: data.response,
                };
            } else {
                throw new Error('No response from model');
            }

        } catch (error) {
            console.error('❌ Ollama chat error:', error);

            if (this.retryCount < this.maxRetries) {
                this.retryCount++;
                console.log(`🔄 重试 (${this.retryCount}/${this.maxRetries})...`);
                await new Promise(resolve => setTimeout(resolve, 1000));
                return this.chat(message, context);
            }

            this.retryCount = 0;
            return {
                message: this.getFallbackResponse(message),
                error: error instanceof Error ? error.message : 'Unknown error'
            };
        }
    }

    /**
     * 获取备用响应
     */
    private getFallbackResponse(message: string): string {
        const fallbackResponses = [
            '董娘的助理暂时离线中，请稍后再试。如需紧急帮助，请联系 Jy技術團隊。',
            '系统正在更新中，AI 助理暂时不可用。请查看帮助文档或联系技术支持。',
            '抱歉，AI 服务临时中断。您可以继续使用系统的其他功能。',
            '董娘的助理正在休息，请稍后再来咨询。系统其他功能正常运行。'
        ];

        // 根据消息类型返回更相关的回复
        if (message.includes('价格') || message.includes('费用')) {
            return '价格查询功能暂时不可用，请查看价格管理页面或联系客服。';
        } else if (message.includes('订单') || message.includes('配送')) {
            return '订单查询功能暂时不可用，请在订单管理页面查看详情。';
        } else if (message.includes('库存') || message.includes('商品')) {
            return '库存查询功能暂时不可用，请在产品管理页面查看详情。';
        }

        return fallbackResponses[Math.floor(Math.random() * fallbackResponses.length)];
    }

    /**
     * 構建針對瓦斯行業務的提示詞
     */
    private buildPrompt(message: string, context?: string): string {
        const systemPrompt = `你是"董娘的助理"，一個專門為瓦斯行業務設計的AI助手。你具備以下專業知識：

業務範圍：
- 液化石油氣(LPG)銷售與配送
- 瓦斯設備安裝與維護
- 客戶服務與訂單管理
- 庫存管理與成本控制
- 安全規範與法規遵循

回答風格：
- 使用繁體中文
- 語氣親切專業
- 提供實用的建議
- 關注安全與效率

請根據用戶的問題提供專業且實用的回答。

${context ? `業務背景：${context}` : ''}

用戶問題：${message}

董娘的助理回覆：`;

        return systemPrompt;
    }

    /**
     * 獲取可用的模型列表
     */
    async getAvailableModels(): Promise<string[]> {
        try {
            const response = await fetch(`${this.baseUrl}/api/tags`);
            if (!response.ok) return [];

            const data = await response.json();
            return data.models?.map((model: any) => model.name) || [];
        } catch (error) {
            console.error('Failed to get models:', error);
            return [];
        }
    }

    /**
     * 設置使用的模型
     */
    setModel(model: string): void {
        this.model = model;
    }
    /**
     * 獲取當前使用的模型
     */
    getCurrentModel(): string {
        return this.model;
    }

    /**
     * 获取当前使用的模型信息
     */
    getModelInfo(): AIModelConfig | null {
        return AI_MODELS[this.model] || null;
    }

    /**
     * 手动切换模型
     */
    async switchModel(modelName: string): Promise<boolean> {
        try {
            // 检查模型是否可用
            const isAvailable = await this.isAvailable();
            if (!isAvailable) return false;

            const response = await fetch(`${this.baseUrl}/api/tags`);
            const data = await response.json();
            const availableModels = data.models?.map((m: any) => m.name) || [];

            if (availableModels.includes(modelName)) {
                this.model = modelName;
                console.log(`✅ 已切换到模型: ${modelName}`);
                return true;
            } else {
                console.error(`❌ 模型不可用: ${modelName}`);
                return false;
            }
        } catch (error) {
            console.error('❌ 切换模型失败:', error);
            return false;
        }
    }

    /**
     * 生成简单响应 - 兼容旧版 API
     */
    async generateResponse(message: string): Promise<string> {
        const result = await this.chat(message);
        return result.message;
    }
}

// 創建單例實例
export const ollamaService = new OllamaService();

// 業務相關的快速回復模板
export const quickResponses = {
    greeting: '您好！我是董娘的助理，很高興為您服務！我可以幫您處理訂單查詢、庫存管理、客戶服務等各種業務問題。請告訴我您需要什麼幫助？',

    orderStatus: '讓我為您查詢訂單狀態。請提供訂單編號，我會立即為您確認配送進度和預計到達時間。',

    inventory: '關於庫存查詢，我可以幫您：\n• 檢查各規格瓦斯的庫存數量\n• 預警低庫存商品\n• 建議補貨時機\n• 分析銷售趨勢',

    safety: '瓦斯安全非常重要！請記住：\n• 定期檢查瓦斯管線\n• 使用合格的瓦斯器具\n• 保持通風良好\n• 發現異味立即關閉瓦斯\n• 定期更換老化設備',

    pricing: '關於價格資訊，我可以提供：\n• 各規格瓦斯的最新價格\n• 大量採購的優惠方案\n• 季節性價格調整資訊\n• 競爭對手價格分析',
};

const GEMINI_API_KEY = process.env.GEMINI_API_KEY || (window as any).GEMINI_API_KEY;
const GEMINI_API_URL = process.env.GEMINI_API_URL || (window as any).GEMINI_API_URL ||
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-latest:generateContent';

export class GeminiService {
    async chat(message: string, context?: string): Promise<{ message: string; error?: string }> {
        try {
            const res = await axios.post(
                `${GEMINI_API_URL}?key=${GEMINI_API_KEY}`,
                {
                    contents: [
                        { role: 'user', parts: [{ text: context ? `${context}\n${message}` : message }] }
                    ]
                },
                { headers: { 'Content-Type': 'application/json' } }
            );
            const reply = res.data.candidates?.[0]?.content?.parts?.[0]?.text || '';
            return { message: reply };
        } catch (e: any) {
            return { message: '', error: e?.response?.data?.error?.message || e.message };
        }
    }
}
