import React, { useState, useRef, useEffect } from 'react';
import { User, AIChat } from '../../types';
import './AIAssistant.css';

interface AIAssistantProps {
  onClose: () => void;
  user: User;
}

export const AIAssistant: React.FC<AIAssistantProps> = ({ onClose, user }) => {
  const [messages, setMessages] = useState<AIChat[]>([]);
  const [inputMessage, setInputMessage] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  useEffect(() => {
    // 添加歡迎消息
    const welcomeMessage: AIChat = {
      id: 'welcome',
      message: '',
      response: `您好 ${user.name}！我是董娘的助理，很高興為您服務！\n\n我可以幫助您：\n• 查詢產品庫存狀況\n• 分析銷售數據\n• 處理客戶訂單問題\n• 提供營運建議\n• 回答系統操作問題\n\n請告訴我您需要什麼幫助？`,
      timestamp: new Date(),
      userId: user.id,
    };
    setMessages([welcomeMessage]);
  }, [user]);

  const handleSendMessage = async () => {
    if (!inputMessage.trim() || isLoading) return;

    const userMessage: AIChat = {
      id: Date.now().toString(),
      message: inputMessage,
      response: '',
      timestamp: new Date(),
      userId: user.id,
    };

    setMessages(prev => [...prev, userMessage]);
    setInputMessage('');
    setIsLoading(true);

    try {
      // 調用 Ollama API
      const response = await window.electronAPI.ai.chat(inputMessage);
      
      const aiResponse: AIChat = {
        id: (Date.now() + 1).toString(),
        message: '',
        response: response.message || '抱歉，我現在無法回應您的問題。請稍後再試。',
        timestamp: new Date(),
        userId: 'assistant',
      };

      setMessages(prev => [...prev, aiResponse]);
    } catch (error) {
      console.error('AI Chat Error:', error);
      const errorResponse: AIChat = {
        id: (Date.now() + 1).toString(),
        message: '',
        response: '抱歉，連接AI助理時發生錯誤。請檢查Ollama服務是否正在運行。',
        timestamp: new Date(),
        userId: 'assistant',
      };
      setMessages(prev => [...prev, errorResponse]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  const quickQuestions = [
    '今天的銷售情況如何？',
    '哪些產品庫存不足？',
    '最近的客戶訂單趨勢',
    '如何提高營業額？',
  ];

  return (
    <div className="ai-assistant">
      <div className="ai-header">
        <div className="ai-info">
          <div className="ai-avatar">
            <span className="ai-icon">🤖</span>
            <div className="ai-status-indicator"></div>
          </div>
          <div className="ai-details">
            <h3 className="ai-name">董娘的助理</h3>
            <p className="ai-status">線上服務中</p>
          </div>
        </div>
        <button className="ai-close-btn" onClick={onClose}>
          <svg width="20" height="20" viewBox="0 0 24 24">
            <path 
              d="M6 6l12 12M6 18L18 6" 
              stroke="currentColor" 
              strokeWidth="2" 
              strokeLinecap="round"
            />
          </svg>
        </button>
      </div>

      <div className="ai-messages">
        {messages.map((msg, index) => (
          <div 
            key={msg.id} 
            className={`message ${msg.userId === user.id ? 'user-message' : 'ai-message'}`}
          >
            <div className="message-content">
              <div className="message-text">
                {msg.message || msg.response}
              </div>
              <div className="message-time">
                {msg.timestamp.toLocaleTimeString('zh-TW', { 
                  hour: '2-digit', 
                  minute: '2-digit' 
                })}
              </div>
            </div>
          </div>
        ))}
        
        {isLoading && (
          <div className="message ai-message">
            <div className="message-content">
              <div className="typing-indicator">
                <span></span>
                <span></span>
                <span></span>
              </div>
            </div>
          </div>
        )}
        
        <div ref={messagesEndRef} />
      </div>

      {/* 快速問題 */}
      {messages.length <= 1 && (
        <div className="quick-questions">
          <p className="quick-title">常見問題：</p>
          <div className="quick-buttons">
            {quickQuestions.map((question, index) => (
              <button 
                key={index}
                className="quick-btn"
                onClick={() => setInputMessage(question)}
              >
                {question}
              </button>
            ))}
          </div>
        </div>
      )}

      <div className="ai-input-area">
        <div className="input-wrapper">
          <textarea
            className="ai-input"
            value={inputMessage}
            onChange={(e) => setInputMessage(e.target.value)}
            onKeyPress={handleKeyPress}
            placeholder="輸入您的問題..."
            rows={1}
            disabled={isLoading}
          />
          <button 
            className="send-btn"
            onClick={handleSendMessage}
            disabled={!inputMessage.trim() || isLoading}
          >
            {isLoading ? (
              <div className="loading-spinner"></div>
            ) : (
              <svg width="20" height="20" viewBox="0 0 24 24">
                <path 
                  d="M2 21l21-9L2 3v7l15 2-15 2v7z" 
                  fill="currentColor"
                />
              </svg>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};
