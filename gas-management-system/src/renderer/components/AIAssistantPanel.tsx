import React, { useState, useEffect, useRef } from 'react';
import './AIAssistantPanel4D.css';
import { geminiChat } from '../services/gemini';

interface AIMessage {
  id: string;
  type: 'user' | 'ai' | 'system';
  content: string;
  timestamp: Date;
  context?: string;
}

interface AIAssistantPanelProps {
  onClose: () => void;
  currentModule: string;
  dashboardStats: any;
}

interface OllamaModel {
  name: string;
  id: string;
  size: string;
  modified: string;
}

const AIAssistantPanel: React.FC<AIAssistantPanelProps> = ({
  onClose,
  currentModule,
  dashboardStats
}) => {
  const [messages, setMessages] = useState<AIMessage[]>([]);
  const [inputText, setInputText] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [isConnected, setIsConnected] = useState(false);
  const [availableModels, setAvailableModels] = useState<OllamaModel[]>([]);
  const [selectedModel, setSelectedModel] = useState('qwen3:8b');
  const [connectionStatus, setConnectionStatus] = useState<'connecting' | 'connected' | 'disconnected'>('connecting');
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  // 業務相關的快速指令 - 針對瓦斯行業務優化
  const quickCommands = [
    {
      title: '📊 今日營收分析',
      command: '作為瓦斯行業AI助手，請分析今日營收狀況，包括瓦斯銷售收入、配送費用、毛利率等關鍵指標',
      category: 'accounting'
    },
    {
      title: '📦 瓦斯庫存建議',
      command: '請檢查當前瓦斯桶庫存狀況，包括5kg、20kg、50kg等不同規格的庫存水位，提供補貨建議',
      category: 'inventory'
    },
    {
      title: '🚚 配送路線優化',
      command: '分析當前配送路線，提供優化建議以降低運輸成本和提高配送效率',
      category: 'logistics'
    }, {
      title: '👥 客戶分析報告',
      command: '分析瓦斯客戶數據，包括新客戶開發、老客戶維護、用氣量趨勢分析',
      category: 'customer'
    },
    {
      title: '💰 成本分析優化',
      command: '分析瓦斯採購成本、運營成本、人力成本，提供成本控制建議',
      category: 'cost'
    },
    {
      title: '📈 銷售趨勢預測',
      command: '基於歷史數據分析瓦斯銷售趨勢，預測淡旺季需求變化',
      category: 'sales'
    },
    {
      title: '⚡ 緊急問題處理',
      command: '我需要緊急處理瓦斯業務問題，請提供快速解決方案',
      category: 'emergency'
    }
  ];

  // 初始化連接和模型檢測
  useEffect(() => {
    initializeConnection();
    addSystemMessage('🤖 AI助手正在啟動，正在連接本地Ollama服務...');
  }, []);

  // 自動滾動到底部
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  // 聚焦輸入框
  useEffect(() => {
    setTimeout(() => {
      inputRef.current?.focus();
    }, 300);
  }, []);

  const initializeConnection = async () => {
    try {
      setConnectionStatus('connecting');

      // 檢查Ollama服務
      const response = await fetch('http://localhost:11434/api/tags');

      if (response.ok) {
        const data = await response.json();
        const models: OllamaModel[] = data.models.map((model: any) => ({
          name: model.name,
          id: model.name,
          size: model.size,
          modified: model.modified_at
        }));

        setAvailableModels(models);
        setIsConnected(true);
        setConnectionStatus('connected');
        // 設置默認模型（優先選擇您的高性能模型）
        const preferredModels = [
          'qwen3:32b',           // 最強大的32B模型，適合複雜分析
          'deepseek-r1:8b',      // 推理專用模型，適合業務分析
          'llama3:8b-instruct-q4_0', // 高效指令模型，適合日常對話
          'qwen3:8b'             // 平衡性能模型，通用選擇
        ];

        const selectedModel = preferredModels.find(model =>
          models.some(m => m.name === model)
        ) || models[0]?.name || 'qwen3:8b';

        setSelectedModel(selectedModel);

        // 根據選擇的模型顯示不同的歡迎信息
        const modelInfo = models.find(m => m.name === selectedModel);
        const modelSize = modelInfo ? `(${(parseInt(modelInfo.size) / (1024 ** 3)).toFixed(1)}GB)` : '';

        addSystemMessage(`✅ 成功連接到Ollama服務！

🔍 檢測到 ${models.length} 個可用模型：
${models.map(m => `• ${m.name} (${(parseInt(m.size) / (1024 ** 3)).toFixed(1)}GB)`).join('\n')}

🚀 當前使用模型: ${selectedModel} ${modelSize}

${selectedModel.includes('32b') ? '💪 您正在使用32B大模型，具備超強的推理和分析能力！' :
            selectedModel.includes('deepseek-r1') ? '🧠 您正在使用DeepSeek-R1模型，專為複雜推理設計！' :
              selectedModel.includes('llama3') ? '⚡ 您正在使用Llama3指令優化模型，響應快速準確！' :
                '🎯 您正在使用Qwen3模型，平衡性能與效率！'}

我是您的專業瓦斯行業務AI助手，我可以幫助您：
• 💰 財務分析和會計建議
• 📊 數據分析和報表解讀  
• 📦 庫存管理和補貨建議
• 🚚 配送路線優化
• 👥 客戶關係管理
• 📈 銷售趨勢分析
• ⚙️ 系統操作指導

請告訴我您需要什麼幫助！`);

      } else {
        throw new Error('Ollama服務未響應');
      }
    } catch (error) {
      setIsConnected(false);
      setConnectionStatus('disconnected');
      addSystemMessage(`❌ 無法連接到Ollama服務

請確保：
1. Ollama已安裝並正在運行
2. 服務地址：http://localhost:11434
3. 模型已下載：ollama pull qwen3:8b

當前檢測到您的模型：
• qwen3:32b (20 GB)
• llama3:8b-instruct-q4_0 (4.7 GB)  
• deepseek-r1:8b (5.2 GB)
• qwen3:8b (5.2 GB)

請啟動Ollama服務後重新連接。`);
    }
  };

  const addSystemMessage = (content: string) => {
    const message: AIMessage = {
      id: Date.now().toString(),
      type: 'system',
      content,
      timestamp: new Date()
    };
    setMessages(prev => [...prev, message]);
  };

  const sendMessage = async (text: string = inputText) => {
    if (!text.trim() || isLoading) return;

    const userMessage: AIMessage = {
      id: Date.now().toString(),
      type: 'user',
      content: text.trim(),
      timestamp: new Date(),
      context: `當前模塊: ${currentModule}, 業務數據: ${JSON.stringify(dashboardStats)}`
    };

    setMessages(prev => [...prev, userMessage]);
    setInputText('');
    setIsLoading(true);

    try {
      // 讀取 .env 的 GEMINI_API_KEY
      const apiKey = (window as any).GEMINI_API_KEY || process.env.GEMINI_API_KEY || '';
      if (!apiKey) throw new Error('未設定 Gemini API Key');
      // 構建 Gemini 對話格式
      const messages = [
        { role: 'user' as const, content: `你是一個專業的瓦斯行業務AI助手，名稱是\"董娘的智能助理\"，具備豐富的瓦斯行業經驗和專業知識。\n\n【當前業務儀表板數據】\n${JSON.stringify(dashboardStats)}\n【當前模塊】${currentModule}\n【用戶諮詢】${text.trim()}` }
      ];
      const aiReply = await geminiChat({ apiKey, messages });
      const aiMessage: AIMessage = {
        id: (Date.now() + 1).toString(),
        type: 'ai',
        content: aiReply,
        timestamp: new Date()
      };
      setMessages(prev => [...prev, aiMessage]);
    } catch (error) {
      console.error('AI請求失敗:', error);
      const errorMessage: AIMessage = {
        id: (Date.now() + 1).toString(),
        type: 'system',
        content: `❌ AI請求失敗: ${error instanceof Error ? error.message : '未知錯誤'}\n\n請檢查 Gemini API Key 與網路連線。`,
        timestamp: new Date()
      };
      setMessages(prev => [...prev, errorMessage]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  };

  const reconnectService = () => {
    setMessages([]);
    initializeConnection();
  };

  const clearChat = () => {
    setMessages([]);
    addSystemMessage('💬 聊天記錄已清空');
  };

  const formatTime = (date: Date) => {
    return date.toLocaleTimeString('zh-TW', {
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  return (
    <div className="ai-assistant-panel">
      <div className="ai-panel-header">
        <div className="panel-title">
          <span className="ai-icon">🤖</span>
          <div className="title-info">
            <h3>AI業務助手</h3>
            <div className="connection-status">
              <span className={`status-dot ${connectionStatus}`}></span>
              <span className="status-text">
                {connectionStatus === 'connected' && `已連接 (${selectedModel})`}
                {connectionStatus === 'connecting' && '連接中...'}
                {connectionStatus === 'disconnected' && '未連接'}
              </span>
            </div>
          </div>
        </div>

        <div className="panel-controls">
          {availableModels.length > 0 && (<select
            value={selectedModel}
            onChange={(e) => setSelectedModel(e.target.value)}
            className="model-selector"
          >
            {availableModels.map(model => {
              const sizeGB = (parseInt(model.size) / (1024 ** 3)).toFixed(1);
              const displayName = `${model.name} (${sizeGB}GB)`;
              return (
                <option key={model.id} value={model.name}>
                  {displayName}
                </option>
              );
            })}
          </select>
          )}

          <button
            onClick={reconnectService}
            className="control-btn reconnect"
            title="重新連接"
          >
            🔄
          </button>

          <button
            onClick={clearChat}
            className="control-btn clear"
            title="清空對話"
          >
            🗑️
          </button>

          <button
            onClick={onClose}
            className="control-btn close"
            title="關閉助手"
          >
            ✕
          </button>
        </div>
      </div>

      <div className="ai-messages">
        {messages.map((message) => (
          <div key={message.id} className={`message ${message.type}`}>
            <div className="message-avatar">
              {message.type === 'user' && '👤'}
              {message.type === 'ai' && '🤖'}
              {message.type === 'system' && 'ℹ️'}
            </div>
            <div className="message-content">
              <div className="message-text">
                {message.content.split('\n').map((line, index) => (
                  <React.Fragment key={index}>
                    {line}
                    {index < message.content.split('\n').length - 1 && <br />}
                  </React.Fragment>
                ))}
              </div>
              <div className="message-time">
                {formatTime(message.timestamp)}
              </div>
            </div>
          </div>
        ))}

        {isLoading && (
          <div className="message ai loading">
            <div className="message-avatar">🤖</div>
            <div className="message-content">
              <div className="typing-indicator">
                <span></span>
                <span></span>
                <span></span>
              </div>
              <div className="message-time">思考中...</div>
            </div>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {isConnected && (
        <div className="quick-commands">
          <div className="commands-header">
            <h4>💡 快速指令</h4>
          </div>
          <div className="commands-grid">
            {quickCommands.map((cmd, index) => (
              <button
                key={index}
                className="quick-command-btn"
                onClick={() => sendMessage(cmd.command)}
                disabled={isLoading}
              >
                {cmd.title}
              </button>
            ))}
          </div>
        </div>
      )}

      <div className="ai-input-area">
        <div className="input-container">
          <input
            ref={inputRef}
            type="text"
            className="ai-input"
            placeholder={
              isConnected
                ? "請輸入您的問題或需求..."
                : "AI服務未連接，請檢查Ollama服務狀態"
            }
            value={inputText}
            onChange={(e) => setInputText(e.target.value)}
            onKeyPress={handleKeyPress}
            disabled={!isConnected || isLoading}
          />

          <button
            className="send-btn"
            onClick={() => sendMessage()}
            disabled={!inputText.trim() || !isConnected || isLoading}
          >
            {isLoading ? '⏳' : '🚀'}
          </button>
        </div>

        <div className="input-hint">
          按 Enter 發送，Shift + Enter 換行
        </div>
      </div>
    </div>
  );
};

export default AIAssistantPanel;
