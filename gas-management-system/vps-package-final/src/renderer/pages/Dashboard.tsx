import React, { useState, useEffect } from 'react';
import { DashboardStats } from '../../types';
import './Dashboard.css';

export const Dashboard: React.FC = () => {
  const [stats, setStats] = useState<DashboardStats>({
    todayRevenue: 0,
    monthlyRevenue: 0,
    totalOrders: 0,
    pendingOrders: 0,
    lowStockProducts: 0,
    totalCustomers: 0,
  });

  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // 模擬數據載入
    setTimeout(() => {
      setStats({
        todayRevenue: 125680,
        monthlyRevenue: 2845600,
        totalOrders: 156,
        pendingOrders: 23,
        lowStockProducts: 8,
        totalCustomers: 342,
      });
      setIsLoading(false);
    }, 1500);
  }, []);

  const StatCard: React.FC<{
    title: string;
    value: string | number;
    icon: string;
    color: string;
    change?: string;
  }> = ({ title, value, icon, color, change }) => (
    <div className={`stat-card ${color}`}>
      <div className="stat-icon">
        <span>{icon}</span>
      </div>
      <div className="stat-content">
        <h3 className="stat-title">{title}</h3>
        <div className="stat-value">{value}</div>
        {change && (
          <div className="stat-change">
            <span className="change-indicator">↗</span>
            {change}
          </div>
        )}
      </div>
      <div className="stat-glow"></div>
    </div>
  );

  if (isLoading) {
    return (
      <div className="dashboard-loading">
        <div className="loading-spinner"></div>
        <p>載入儀表板數據中...</p>
      </div>
    );
  }

  return (
    <div className="dashboard">
      {/* 頁面標題 */}
      <div className="dashboard-header">
        <div className="header-content">
          <h1 className="page-title">營運儀表板</h1>
          <p className="page-subtitle">即時監控您的瓦斯行營運狀況</p>
        </div>
        <div className="header-actions">
          <button className="refresh-btn">
            <span className="btn-icon">🔄</span>
            更新數據
          </button>
        </div>
      </div>

      {/* 統計卡片 */}
      <div className="stats-grid">
        <StatCard
          title="今日營收"
          value={`NT$ ${stats.todayRevenue.toLocaleString()}`}
          icon="💰"
          color="primary"
          change="+12.5%"
        />
        <StatCard
          title="本月營收"
          value={`NT$ ${stats.monthlyRevenue.toLocaleString()}`}
          icon="📈"
          color="success"
          change="+8.3%"
        />
        <StatCard
          title="總訂單數"
          value={stats.totalOrders}
          icon="📋"
          color="info"
          change="+15.2%"
        />
        <StatCard
          title="待處理訂單"
          value={stats.pendingOrders}
          icon="⏳"
          color="warning"
        />
        <StatCard
          title="庫存不足"
          value={stats.lowStockProducts}
          icon="⚠️"
          color="danger"
        />
        <StatCard
          title="總客戶數"
          value={stats.totalCustomers}
          icon="👥"
          color="secondary"
          change="+5.7%"
        />
      </div>

      {/* 圖表區域 */}
      <div className="charts-section">
        <div className="chart-container">
          <div className="chart-header">
            <h3>銷售趨勢</h3>
            <div className="chart-controls">
              <button className="chart-btn active">7天</button>
              <button className="chart-btn">30天</button>
              <button className="chart-btn">90天</button>
            </div>
          </div>
          <div className="chart-placeholder">
            <div className="chart-mock">
              <div className="chart-bar" style={{height: '60%'}}></div>
              <div className="chart-bar" style={{height: '80%'}}></div>
              <div className="chart-bar" style={{height: '45%'}}></div>
              <div className="chart-bar" style={{height: '90%'}}></div>
              <div className="chart-bar" style={{height: '70%'}}></div>
              <div className="chart-bar" style={{height: '85%'}}></div>
              <div className="chart-bar" style={{height: '75%'}}></div>
            </div>
            <p className="chart-note">圖表功能將在後續版本中完善</p>
          </div>
        </div>

        <div className="quick-actions">
          <h3>快速操作</h3>
          <div className="action-buttons">
            <button className="action-btn">
              <span className="action-icon">📦</span>
              <span className="action-label">新增產品</span>
            </button>
            <button className="action-btn">
              <span className="action-icon">📋</span>
              <span className="action-label">建立訂單</span>
            </button>
            <button className="action-btn">
              <span className="action-icon">👤</span>
              <span className="action-label">新增客戶</span>
            </button>
            <button className="action-btn">
              <span className="action-icon">📊</span>
              <span className="action-label">查看報表</span>
            </button>
          </div>
        </div>
      </div>

      {/* 最近活動 */}
      <div className="recent-activities">
        <h3>最近活動</h3>
        <div className="activity-list">
          <div className="activity-item">
            <div className="activity-icon success">✓</div>
            <div className="activity-content">
              <p className="activity-text">訂單 #12345 已完成配送</p>
              <span className="activity-time">5分鐘前</span>
            </div>
          </div>
          <div className="activity-item">
            <div className="activity-icon warning">⚠</div>
            <div className="activity-content">
              <p className="activity-text">15kg液化瓦斯庫存不足</p>
              <span className="activity-time">15分鐘前</span>
            </div>
          </div>
          <div className="activity-item">
            <div className="activity-icon info">💰</div>
            <div className="activity-content">
              <p className="activity-text">收到客戶王先生的付款 NT$ 2,400</p>
              <span className="activity-time">1小時前</span>
            </div>
          </div>
          <div className="activity-item">
            <div className="activity-icon primary">📦</div>
            <div className="activity-content">
              <p className="activity-text">新訂單 #12346 等待處理</p>
              <span className="activity-time">2小時前</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
