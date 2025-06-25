import React, { useState, useEffect } from 'react';
import './AdminDashboard.css';
import AIAssistantPanel from '../components/AIAssistantPanel';

interface DashboardStats {
  totalRevenue: number;
  todayRevenue: number;
  totalOrders: number;
  pendingOrders: number;
  totalCustomers: number;
  newCustomers: number;
  lowStockItems: number;
  profitMargin: number;
}

interface FinancialData {
  income: number;
  expenses: number;
  profit: number;
  cashFlow: number;
}

interface RecentTransaction {
  id: string;
  type: 'income' | 'expense';
  description: string;
  amount: number;
  date: Date;
  category: string;
}

const AdminDashboard: React.FC = () => {
  const [stats, setStats] = useState<DashboardStats>({
    totalRevenue: 2450000,
    todayRevenue: 85000,
    totalOrders: 1287,
    pendingOrders: 23,
    totalCustomers: 456,
    newCustomers: 12,
    lowStockItems: 8,
    profitMargin: 28.5
  });

  const [financialData, setFinancialData] = useState<FinancialData>({
    income: 2450000,
    expenses: 1750000,
    profit: 700000,
    cashFlow: 320000
  });

  const [recentTransactions, setRecentTransactions] = useState<RecentTransaction[]>([
    {
      id: '1',
      type: 'income',
      description: '瓦斯桶銷售 - 20kg x12',
      amount: 14400,
      date: new Date(2024, 11, 22, 14, 30),
      category: '銷售收入'
    },
    {
      id: '2',
      type: 'expense',
      description: '配送車輛油費',
      amount: 2800,
      date: new Date(2024, 11, 22, 10, 15),
      category: '運營成本'
    },
    {
      id: '3',
      type: 'income',
      description: '瓦斯桶銷售 - 5kg x25',
      amount: 8750,
      date: new Date(2024, 11, 21, 16, 45),
      category: '銷售收入'
    }
  ]);

  const [isAIOpen, setIsAIOpen] = useState(false);
  const [currentTime, setCurrentTime] = useState(new Date());
  const [activeModule, setActiveModule] = useState('dashboard');

  // 實時時間更新
  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  // 格式化貨幣
  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('zh-TW', {
      style: 'currency',
      currency: 'TWD',
      minimumFractionDigits: 0
    }).format(amount);
  };

  // 統計卡片數據
  const statCards = [
    {
      title: '總營收',
      value: formatCurrency(stats.totalRevenue),
      icon: '💰',
      change: '+12.5%',
      positive: true,
      subtitle: '本月累計'
    },
    {
      title: '今日營收',
      value: formatCurrency(stats.todayRevenue),
      icon: '📈',
      change: '+8.3%',
      positive: true,
      subtitle: '較昨日'
    },
    {
      title: '總訂單',
      value: stats.totalOrders.toLocaleString(),
      icon: '📋',
      change: '+156',
      positive: true,
      subtitle: '本月新增'
    },
    {
      title: '待處理',
      value: stats.pendingOrders.toString(),
      icon: '⏳',
      change: '-5',
      positive: true,
      subtitle: '較昨日'
    },
    {
      title: '總客戶',
      value: stats.totalCustomers.toLocaleString(),
      icon: '👥',
      change: `+${stats.newCustomers}`,
      positive: true,
      subtitle: '新客戶'
    },
    {
      title: '庫存警示',
      value: stats.lowStockItems.toString(),
      icon: '⚠️',
      change: '+2',
      positive: false,
      subtitle: '需補貨'
    },
    {
      title: '利潤率',
      value: `${stats.profitMargin}%`,
      icon: '📊',
      change: '+2.1%',
      positive: true,
      subtitle: '較上月'
    },
    {
      title: '現金流',
      value: formatCurrency(financialData.cashFlow),
      icon: '💳',
      change: '+15.2%',
      positive: true,
      subtitle: '本月'
    }
  ];

  // 模塊導航
  const modules = [
    { id: 'dashboard', name: '儀表板', icon: '🏠' },
    { id: 'products', name: '產品管理', icon: '📦' },
    { id: 'orders', name: '訂單管理', icon: '📋' },
    { id: 'customers', name: '客戶管理', icon: '👥' },
    { id: 'finance', name: '財務管理', icon: '💰' },
    { id: 'reports', name: '報表分析', icon: '📊' },
    { id: 'settings', name: '系統設定', icon: '⚙️' }
  ];
  // formatTime function for display

  const formatTime = (date: Date) => {
    return date.toLocaleString('zh-TW', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  return (
    <div className="admin-dashboard">
      {/* 頂部導航欄 */}
      <div className="admin-header">
        <div className="header-left">
          <h1>🏢 瓦斯行後台管理系統</h1>
          <span className="current-time">{formatTime(currentTime)}</span>
        </div>
        <div className="header-right">
          <button
            className="ai-assistant-btn"
            onClick={() => setIsAIOpen(!isAIOpen)}
          >
            🤖 AI助手
          </button>
          <div className="user-profile">
            <span>管理員</span>
            <div className="avatar">👨‍💼</div>
          </div>
        </div>
      </div>

      <div className="dashboard-content">
        {/* 左側導航 */}
        <div className="sidebar">
          <div className="nav-section">
            <h3>📊 數據分析</h3>
            <ul>
              <li className="active">🏠 總覽</li>
              <li>📈 銷售報表</li>
              <li>💰 財務分析</li>
              <li>📋 庫存報表</li>
            </ul>
          </div>

          <div className="nav-section">
            <h3>💼 業務管理</h3>
            <ul>
              <li>📦 訂單管理</li>
              <li>👥 客戶管理</li>
              <li>🛒 產品管理</li>
              <li>🚚 配送管理</li>
            </ul>
          </div>

          <div className="nav-section">
            <h3>💰 會計系統</h3>
            <ul>
              <li>📊 損益表</li>
              <li>💳 資產負債表</li>
              <li>💸 現金流量表</li>
              <li>🧾 憑證管理</li>
              <li>📋 稅務管理</li>
            </ul>
          </div>

          <div className="nav-section">
            <h3>⚙️ 系統設置</h3>
            <ul>
              <li>👤 用戶管理</li>
              <li>🔧 系統設置</li>
              <li>📱 APP管理</li>
            </ul>
          </div>
        </div>

        {/* 主要內容區 */}
        <div className="main-content">
          {/* 統計卡片 */}
          <div className="stats-grid">
            <div className="stat-card revenue">
              <div className="stat-icon">💰</div>
              <div className="stat-content">
                <h3>總營收</h3>
                <div className="stat-value">{formatCurrency(stats.totalRevenue)}</div>
                <div className="stat-change positive">
                  <span>↗</span> 今日 {formatCurrency(stats.todayRevenue)}
                </div>
              </div>
            </div>

            <div className="stat-card orders">
              <div className="stat-icon">📦</div>
              <div className="stat-content">
                <h3>訂單統計</h3>
                <div className="stat-value">{stats.totalOrders}</div>
                <div className="stat-change warning">
                  <span>⏳</span> 待處理 {stats.pendingOrders} 筆
                </div>
              </div>
            </div>

            <div className="stat-card customers">
              <div className="stat-icon">👥</div>
              <div className="stat-content">
                <h3>客戶數量</h3>
                <div className="stat-value">{stats.totalCustomers}</div>
                <div className="stat-change positive">
                  <span>👤</span> 新增 {stats.newCustomers} 位
                </div>
              </div>
            </div>

            <div className="stat-card profit">
              <div className="stat-icon">📊</div>
              <div className="stat-content">
                <h3>利潤率</h3>
                <div className="stat-value">{stats.profitMargin}%</div>
                <div className="stat-change positive">
                  <span>📈</span> 本月成長 +3.2%
                </div>
              </div>
            </div>
          </div>

          {/* 財務概覽 */}
          <div className="section-row">
            <div className="financial-overview">
              <h3>💰 財務概覽</h3>
              <div className="financial-cards">
                <div className="financial-card income">
                  <div className="financial-icon">💵</div>
                  <div className="financial-info">
                    <span className="financial-label">本月收入</span>
                    <span className="financial-amount">{formatCurrency(financialData.income)}</span>
                  </div>
                </div>

                <div className="financial-card expense">
                  <div className="financial-icon">💸</div>
                  <div className="financial-info">
                    <span className="financial-label">本月支出</span>
                    <span className="financial-amount">{formatCurrency(financialData.expenses)}</span>
                  </div>
                </div>

                <div className="financial-card profit">
                  <div className="financial-icon">💎</div>
                  <div className="financial-info">
                    <span className="financial-label">淨利潤</span>
                    <span className="financial-amount profit-amount">{formatCurrency(financialData.profit)}</span>
                  </div>
                </div>

                <div className="financial-card cashflow">
                  <div className="financial-icon">🏦</div>
                  <div className="financial-info">
                    <span className="financial-label">現金流</span>
                    <span className="financial-amount">{formatCurrency(financialData.cashFlow)}</span>
                  </div>
                </div>
              </div>
            </div>

            <div className="quick-actions">
              <h3>⚡ 快速操作</h3>
              <div className="action-grid">
                <button className="action-btn primary">
                  <span className="action-icon">➕</span>
                  新增訂單
                </button>
                <button className="action-btn secondary">
                  <span className="action-icon">👤</span>
                  新增客戶
                </button>
                <button className="action-btn success">
                  <span className="action-icon">📦</span>
                  進貨管理
                </button>
                <button className="action-btn info">
                  <span className="action-icon">💰</span>
                  記帳憑證
                </button>
                <button className="action-btn warning">
                  <span className="action-icon">📊</span>
                  財務報表
                </button>
                <button className="action-btn danger">
                  <span className="action-icon">⚠️</span>
                  庫存警告
                </button>
              </div>
            </div>
          </div>

          {/* 最近交易 */}
          <div className="recent-transactions">
            <h3>💳 最近交易記錄</h3>
            <div className="transaction-list">
              {recentTransactions.map((transaction) => (
                <div key={transaction.id} className={`transaction-item ${transaction.type}`}>
                  <div className="transaction-icon">
                    {transaction.type === 'income' ? '💰' : '💸'}
                  </div>
                  <div className="transaction-details">
                    <div className="transaction-description">{transaction.description}</div>
                    <div className="transaction-category">{transaction.category}</div>
                  </div>
                  <div className="transaction-amount">
                    <span className={transaction.type}>
                      {transaction.type === 'income' ? '+' : '-'}
                      {formatCurrency(transaction.amount)}
                    </span>
                    <div className="transaction-time">
                      {transaction.date.toLocaleTimeString('zh-TW', {
                        hour: '2-digit',
                        minute: '2-digit'
                      })}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* 系統狀態 */}
          <div className="system-status">
            <h3>🔧 系統狀態</h3>
            <div className="status-grid">
              <div className="status-item online">
                <span className="status-indicator"></span>
                <span>APP服務</span>
                <span className="status-text">正常運行</span>
              </div>
              <div className="status-item online">
                <span className="status-indicator"></span>
                <span>AI助手</span>
                <span className="status-text">已連接</span>
              </div>
              <div className="status-item online">
                <span className="status-indicator"></span>
                <span>數據庫</span>
                <span className="status-text">正常</span>
              </div>
              <div className="status-item warning">
                <span className="status-indicator"></span>
                <span>備份系統</span>
                <span className="status-text">需要關注</span>
              </div>
            </div>
          </div>
        </div>
      </div>      {/* AI助手組件 */}
      {isAIOpen && (
        <AIAssistantPanel
          onClose={() => setIsAIOpen(false)}
          currentModule="admin-dashboard"
          dashboardStats={{
            totalRevenue: stats.totalRevenue,
            monthlyRevenue: stats.todayRevenue * 30,
            totalOrders: stats.totalOrders,
            pendingOrders: stats.pendingOrders,
            totalCustomers: stats.totalCustomers,
            activeCustomers: stats.newCustomers,
            totalProducts: 100, // 假設產品數量
            lowStockProducts: stats.lowStockItems,
            profit: financialData.profit,
            expenses: financialData.expenses
          }}
        />
      )}
    </div>
  );
};

export default AdminDashboard;
