import React, { useState, useEffect, useRef } from 'react';
import './AIChatWindow.css';
import { GeminiService } from '../services/OllamaService';

interface ChatMessage {
  id: string;
  type: 'user' | 'ai' | 'system';
  content: string;
  timestamp: Date;
  status?: 'sending' | 'sent' | 'error';
}

interface AIChatWindowProps {
  isOpen: boolean;
  onClose: () => void;
}

const AIChatWindow: React.FC<AIChatWindowProps> = ({ isOpen, onClose }) => {
  const [messages, setMessages] = useState<ChatMessage[]>([
    {
      id: '1',
      type: 'system',
      content: '🤖 AI助理已就緒！我是您的瓦斯管理系統智能助手，可以幫助您處理各種業務問題。',
      timestamp: new Date()
    }
  ]);
  const [inputText, setInputText] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [aiStatus, setAiStatus] = useState<'connected' | 'connecting' | 'disconnected'>('connecting');
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  const geminiService = new GeminiService();

  // 快速回復建議
  const quickReplies = [
    '📊 顯示今日銷售統計',
    '📋 查看待處理訂單',
    '👥 客戶管理幫助',
    '💰 財務分析',
    '🔍 系統使用說明'
  ];

  // 初始化AI連接
  useEffect(() => {
    const initializeAI = async () => {
      try {
        setAiStatus('connecting');
        // 模擬連接過程
        setTimeout(() => {
          setAiStatus('connected');
        }, 1000);

        // 發送歡迎消息
        const welcomeMessage: ChatMessage = {
          id: Date.now().toString(),
          type: 'ai',
          content: `🎉 AI助理連接成功！\n\n我可以幫助您：\n• 查詢銷售數據和統計\n• 管理客戶信息\n• 分析業務趨勢\n• 解答系統使用問題\n• 提供業務建議`,
          timestamp: new Date()
        };

        setMessages(prev => [...prev, welcomeMessage]);
      } catch (error) {
        setAiStatus('disconnected');
        console.error('AI初始化失敗:', error);
      }
    };

    if (isOpen) {
      initializeAI();
      // 聚焦輸入框
      setTimeout(() => {
        inputRef.current?.focus();
      }, 300);
    }
  }, [isOpen]);

  // 自動滾動到底部
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, isTyping]);

  // 發送消息
  const sendMessage = async () => {
    if (!inputText.trim()) return;
    setIsTyping(true);
    setMessages(prev => [...prev, { id: Date.now().toString(), type: 'user', content: inputText, timestamp: new Date() }]);
    setInputText('');
    try {
      const response = await geminiService.chat(inputText.trim());
      setMessages(prev => [...prev, { id: (Date.now() + 1).toString(), type: 'ai', content: response.message, timestamp: new Date() }]);
    } catch (e) {
      setMessages(prev => [...prev, { id: (Date.now() + 1).toString(), type: 'system', content: '❌ AI請求失敗', timestamp: new Date() }]);
    } finally {
      setIsTyping(false);
    }
  };

  // 處理輸入
  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  };

  // 清空聊天記錄
  const clearChat = () => {
    if (confirm('確定要清空所有聊天記錄嗎？')) {
      setMessages([{
        id: '1',
        type: 'system',
        content: '💬 聊天記錄已清空。',
        timestamp: new Date()
      }]);
    }
  };

  // 重新連接AI
  const reconnectAI = async () => {
    setAiStatus('connecting');
    try {
      // 模擬重新連接過程
      setTimeout(() => {
        setAiStatus('connected');
      }, 1000);

      const successMessage: ChatMessage = {
        id: Date.now().toString(),
        type: 'system',
        content: '✅ AI服務重新連接成功！',
        timestamp: new Date()
      };
      setMessages(prev => [...prev, successMessage]);
    } catch (error) {
      setAiStatus('disconnected');
    }
  };

  // 格式化時間
  const formatTime = (date: Date) => {
    return date.toLocaleTimeString('zh-TW', {
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  // 獲取狀態圖標
  const getStatusIcon = () => {
    switch (aiStatus) {
      case 'connected': return '🟢';
      case 'connecting': return '🟡';
      case 'disconnected': return '🔴';
      default: return '⚪';
    }
  };

  // 獲取狀態文本
  const getStatusText = () => {
    switch (aiStatus) {
      case 'connected': return 'AI在線';
      case 'connecting': return '連接中...';
      case 'disconnected': return 'AI離線';
      default: return '未知狀態';
    }
  };

  if (!isOpen) return null;

  return (
    <div className="ai-chat-overlay">
      <div className="ai-chat-window">
        {/* 聊天窗口標題欄 */}
        <div className="chat-header">
          <div className="chat-title">
            <div className="ai-avatar">🤖</div>
            <div className="title-info">
              <h3>AI智能助手</h3>
              <div className="ai-status">
                <span className="status-indicator">{getStatusIcon()}</span>
                <span className="status-text">{getStatusText()}</span>
              </div>
            </div>
          </div>

          <div className="chat-controls">
            <button
              className="control-btn reconnect-btn"
              onClick={reconnectAI}
              disabled={aiStatus === 'connecting'}
              title="重新連接AI"
            >
              🔄
            </button>
            <button
              className="control-btn clear-btn"
              onClick={clearChat}
              title="清空聊天"
            >
              🗑️
            </button>
            <button
              className="control-btn close-btn"
              onClick={onClose}
              title="關閉聊天窗口"
            >
              ✕
            </button>
          </div>
        </div>

        {/* 聊天消息區域 */}
        <div className="chat-messages">
          {messages.map((message) => (
            <div
              key={message.id}
              className={`message message-${message.type} ${message.status ? `status-${message.status}` : ''}`}
            >
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
                  {message.status === 'sending' && (
                    <span className="sending-indicator">發送中...</span>
                  )}
                  {message.status === 'error' && (
                    <span className="error-indicator">發送失敗</span>
                  )}
                </div>
              </div>
            </div>
          ))}

          {/* AI打字指示器 */}
          {isTyping && (
            <div className="message message-ai typing">
              <div className="message-avatar">🤖</div>
              <div className="message-content">
                <div className="typing-indicator">
                  <span></span>
                  <span></span>
                  <span></span>
                </div>
                <div className="message-time">正在輸入...</div>
              </div>
            </div>
          )}

          <div ref={messagesEndRef} />
        </div>

        {/* 快速回復按鈕 */}
        {aiStatus === 'connected' && (
          <div className="quick-replies">
            {quickReplies.map((reply, index) => (
              <button
                key={index}
                className="quick-reply-btn"
                onClick={sendMessage}
                disabled={isTyping}
              >
                {reply}
              </button>
            ))}
          </div>
        )}

        {/* 輸入區域 */}
        <div className="chat-input-area">
          <div className="input-container">
            <input
              ref={inputRef}
              type="text"
              className="chat-input"
              placeholder={
                aiStatus === 'connected'
                  ? "輸入您的問題..."
                  : "AI服務未連接，請檢查連接狀態"
              }
              value={inputText}
              onChange={(e) => setInputText(e.target.value)}
              onKeyPress={handleKeyPress}
              disabled={aiStatus !== 'connected' || isTyping}
            />

            <button
              className="send-btn"
              onClick={() => sendMessage()}
              disabled={!inputText.trim() || aiStatus !== 'connected' || isTyping}
            >
              {isTyping ? '⏳' : '🚀'}
            </button>
          </div>

          <div className="input-hint">
            按 Enter 發送消息，Shift + Enter 換行
          </div>
        </div>
      </div>
    </div>
  );
};

export default AIChatWindow;
