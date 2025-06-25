import React, { useState, useEffect } from 'react';
import './Dashboard.css';
import AIChatWindow from '../components/AIChatWindow';

interface DashboardStats {
  totalProducts: number;
  totalOrders: number;
  totalCustomers: number;
  totalRevenue: number;
  pendingOrders: number;
  lowStockItems: number;
}

interface Activity {
  id: string;
  type: 'order' | 'product' | 'customer' | 'system';
  message: string;
  timestamp: Date;
  icon: string;
}

const Dashboard: React.FC = () => {
  const [stats, setStats] = useState<DashboardStats>({
    totalProducts: 156,
    totalOrders: 423,
    totalCustomers: 89,
    totalRevenue: 1250000,
    pendingOrders: 12,
    lowStockItems: 5
  });

  const [activities, setActivities] = useState<Activity[]>([
    {
      id: '1',
      type: 'order',
      message: '新訂單 #ORD-2024-001 已建立',
      timestamp: new Date(Date.now() - 300000),
      icon: '📦'
    },
    {
      id: '2',
      type: 'product',
      message: '20kg瓦斯鋼瓶庫存不足',
      timestamp: new Date(Date.now() - 600000),
      icon: '⚠️'
    },
    {
      id: '3',
      type: 'customer',
      message: '新客戶 王大明 已註冊',
      timestamp: new Date(Date.now() - 900000),
      icon: '👤'
    },
    {
      id: '4',
      type: 'system',
      message: 'AI 助理已成功連接 (llama3:8b-instruct-q4_0)',
      timestamp: new Date(Date.now() - 1200000),
      icon: '🤖'
    }
  ]);

  const [currentTime, setCurrentTime] = useState(new Date());
  const [isChatOpen, setIsChatOpen] = useState(false);

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
    }, 1000);

    return () => clearInterval(timer);
  }, []);

  const refreshStats = () => {
    // 模擬數據刷新
    setStats(prev => ({
      ...prev,
      totalOrders: prev.totalOrders + Math.floor(Math.random() * 3),
      totalRevenue: prev.totalRevenue + Math.floor(Math.random() * 50000)
    }));
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('zh-TW', {
      style: 'currency',
      currency: 'TWD'
    }).format(amount);
  };

  const formatTime = (date: Date) => {
    return date.toLocaleTimeString('zh-TW', {
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    });
  };

  const formatDate = (date: Date) => {
    return date.toLocaleDateString('zh-TW', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      weekday: 'long'
    });
  };

  const getRelativeTime = (timestamp: Date) => {
    const diff = Date.now() - timestamp.getTime();
    const minutes = Math.floor(diff / 60000);
    if (minutes < 1) return '剛剛';
    if (minutes < 60) return `${minutes}分鐘前`;
    const hours = Math.floor(minutes / 60);
    if (hours < 24) return `${hours}小時前`;
    const days = Math.floor(hours / 24);
    return `${days}天前`;
  };

  return (
    <div className="dashboard">
      {/* Dashboard Header */}
      <div className="dashboard-header">
        <div className="header-content">
          <h1>🏢 Jy技術團隊 瓦斯管理系統</h1>
          <p className="text-gradient">
            {formatDate(currentTime)} | {formatTime(currentTime)}
          </p>
        </div>
        <button className="refresh-btn" onClick={refreshStats}>
          <span className="animate-rotate">🔄</span>
          <span>刷新數據</span>
        </button>
      </div>

      {/* Stats Grid */}
      <div className="stats-grid">
        <div className="stat-card primary animate-float">
          <div className="stat-icon">📊</div>
          <div className="stat-content">
            <div className="stat-title">總產品數量</div>
            <div className="stat-value text-gradient">{stats.totalProducts}</div>
            <div className="stat-change">
              <span className="change-indicator">📈</span>
              <span>+12 本月新增</span>
            </div>
          </div>
          <div className="stat-glow"></div>
        </div>

        <div className="stat-card success animate-float" style={{ animationDelay: '0.1s' }}>
          <div className="stat-icon">📦</div>
          <div className="stat-content">
            <div className="stat-title">總訂單數</div>
            <div className="stat-value text-gradient">{stats.totalOrders}</div>
            <div className="stat-change">
              <span className="change-indicator">📈</span>
              <span>+{Math.floor(Math.random() * 10)} 今日新增</span>
            </div>
          </div>
          <div className="stat-glow"></div>
        </div>

        <div className="stat-card info animate-float" style={{ animationDelay: '0.2s' }}>
          <div className="stat-icon">👥</div>
          <div className="stat-content">
            <div className="stat-title">總客戶數</div>
            <div className="stat-value text-gradient">{stats.totalCustomers}</div>
            <div className="stat-change">
              <span className="change-indicator">📈</span>
              <span>+3 本週新增</span>
            </div>
          </div>
          <div className="stat-glow"></div>
        </div>

        <div className="stat-card warning animate-float" style={{ animationDelay: '0.3s' }}>
          <div className="stat-icon">💰</div>
          <div className="stat-content">
            <div className="stat-title">總營收</div>
            <div className="stat-value text-gradient">{formatCurrency(stats.totalRevenue)}</div>
            <div className="stat-change">
              <span className="change-indicator">📈</span>
              <span>+15.2% 較上月</span>
            </div>
          </div>
          <div className="stat-glow"></div>
        </div>

        <div className="stat-card danger animate-float" style={{ animationDelay: '0.4s' }}>
          <div className="stat-icon">⏳</div>
          <div className="stat-content">
            <div className="stat-title">待處理訂單</div>
            <div className="stat-value text-gradient">{stats.pendingOrders}</div>
            <div className="stat-change">
              <span className="change-indicator">⚠️</span>
              <span>需要關注</span>
            </div>
          </div>
          <div className="stat-glow"></div>
        </div>

        <div className="stat-card secondary animate-float" style={{ animationDelay: '0.5s' }}>
          <div className="stat-icon">📉</div>
          <div className="stat-content">
            <div className="stat-title">低庫存商品</div>
            <div className="stat-value text-gradient">{stats.lowStockItems}</div>
            <div className="stat-change">
              <span className="change-indicator">🔔</span>
              <span>需要補貨</span>
            </div>
          </div>
          <div className="stat-glow"></div>
        </div>
      </div>

      {/* Charts Section */}
      <div className="charts-section">
        <div className="chart-container animate-slide-in">
          <div className="chart-header">
            <h3 className="text-gradient">📈 銷售趨勢</h3>
            <div className="chart-controls">
              <button className="chart-btn active">7天</button>
              <button className="chart-btn">30天</button>
              <button className="chart-btn">90天</button>
            </div>
          </div>
          <div className="chart-placeholder">
            <div className="chart-mock">
              {[65, 45, 78, 52, 89, 67, 95].map((height, index) => (
                <div
                  key={index}
                  className="chart-bar animate-glow"
                  style={{
                    height: `${height}%`,
                    animationDelay: `${index * 0.1}s`
                  }}
                ></div>
              ))}
            </div>
            <p className="chart-note">🚀 銷售數據持續增長中</p>
          </div>
        </div>

        <div className="quick-actions animate-slide-in" style={{ animationDelay: '0.2s' }}>
          <h3 className="text-gradient">⚡ 快速操作</h3>
          <div className="action-buttons">
            <a href="#/products" className="action-btn">
              <span className="action-icon">📦</span>
              <span className="action-label">產品管理</span>
            </a>
            <a href="#/orders" className="action-btn">
              <span className="action-icon">🛒</span>
              <span className="action-label">訂單管理</span>
            </a>
            <a href="#/customers" className="action-btn">
              <span className="action-icon">👥</span>
              <span className="action-label">客戶管理</span>
            </a>            <a href="#/financial" className="action-btn">
              <span className="action-icon">💰</span>
              <span className="action-label">財務分析</span>
            </a>
            <button
              className="action-btn"
              onClick={() => setIsChatOpen(true)}
            >
              <span className="action-icon">🤖</span>
              <span className="action-label">AI 助理</span>
            </button>
          </div>
        </div>
      </div>

      {/* Recent Activities */}
      <div className="recent-activities animate-slide-in" style={{ animationDelay: '0.4s' }}>
        <h3 className="text-gradient">🕐 最近活動</h3>
        <div className="activity-list">
          {activities.map((activity, index) => (
            <div
              key={activity.id}
              className="activity-item animate-slide-in"
              style={{ animationDelay: `${0.6 + index * 0.1}s` }}
            >
              <div className={`activity-icon ${activity.type}`}>
                {activity.icon}
              </div>
              <div className="activity-content">
                <div className="activity-text">{activity.message}</div>
                <div className="activity-time">{getRelativeTime(activity.timestamp)}</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* System Status */}
      <div className="system-status animate-slide-in" style={{ animationDelay: '0.8s' }}>
        <div className="status-item">
          <span className="status-indicator status-online"></span>
          <span>AI 助理服務 (Llama3 8B)</span>
        </div>
        <div className="status-item">
          <span className="status-indicator status-online"></span>
          <span>數據庫連接</span>
        </div>
        <div className="status-item">
          <span className="status-indicator status-warning"></span>
          <span>備份系統</span>        </div>
      </div>

      {/* AI Chat Window */}
      <AIChatWindow
        isOpen={isChatOpen}
        onClose={() => setIsChatOpen(false)}
      />

      {/* Floating AI Chat Button */}
      {!isChatOpen && (
        <button
          className="floating-chat-btn animate-pulse"
          onClick={() => setIsChatOpen(true)}
          title="開啟AI助理聊天"
        >
          🤖
        </button>
      )}
    </div>
  );
};

export default Dashboard;
