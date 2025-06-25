import React, { useState, useEffect } from 'react';
import './AdminDashboard.css';
import AIAssistantPanel from '../components/AIAssistantPanel';
import ProductManagement4D from './ProductManagement4D';
import OrderManagement4D from './OrderManagement4D';
import CustomerManagement4D from './CustomerManagement4D';
import FinancialAnalysis4D from './FinancialAnalysis4D';

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

interface StatCard {
  title: string;
  value: string;
  icon: string;
  change: string;
  positive: boolean;
  subtitle: string;
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
  const statCards: StatCard[] = [
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

  return (
    <div className="admin-dashboard">
      {/* 4D科技感頂部導航 */}
      <header className="admin-header">
        <div className="header-left">
          <h1>🔥 瓦斯管理系統 4D</h1>
          <span className="current-time">
            SYSTEM TIME: {currentTime.toLocaleString('zh-TW')}
          </span>
        </div>

        <div className="header-right">
          <div className="system-status">
            <span className="status-indicator online"></span>
            <span className="status-text">SYSTEM ONLINE</span>
          </div>

          <button
            className="ai-assistant-btn"
            onClick={() => setIsAIOpen(true)}
          >
            🤖 AI NEURAL LINK
          </button>
        </div>
      </header>

      {/* 主要內容區域 */}
      <main className="admin-main">
        {activeModule === 'dashboard' && (
          <>
            {/* 統計卡片區域 - 全息投影風格 */}
            <section className="stats-overview">
              {statCards.map((card, index) => (
                <div key={index} className="stat-card">
                  <div className="stat-header">
                    <span className="stat-title">{card.title}</span>
                    <div className="stat-icon">{card.icon}</div>
                  </div>

                  <div className="stat-value">{card.value}</div>

                  <div className={`stat-change ${card.positive ? 'positive' : 'negative'}`}>
                    <span>{card.positive ? '↗' : '↘'}</span>
                    {card.change} {card.subtitle}
                  </div>
                </div>
              ))}
            </section>

            {/* 圖表和側邊欄區域 */}
            <section className="charts-section">
              {/* 主要圖表 */}
              <div className="chart-container">
                <h3 className="chart-title">營收趨勢分析</h3>
                <div className="chart-placeholder">
                  <div className="hologram-chart">
                    <div className="chart-bar" style={{ height: '60%' }}></div>
                    <div className="chart-bar" style={{ height: '80%' }}></div>
                    <div className="chart-bar" style={{ height: '45%' }}></div>
                    <div className="chart-bar" style={{ height: '90%' }}></div>
                    <div className="chart-bar" style={{ height: '70%' }}></div>
                    <div className="chart-bar" style={{ height: '95%' }}></div>
                    <div className="chart-bar" style={{ height: '85%' }}></div>
                  </div>
                </div>
              </div>

              {/* 側邊欄數據 */}
              <div className="dashboard-sidebar">
                <div className="sidebar-section">
                  <h3 className="sidebar-title">最近交易</h3>
                  {recentTransactions.map((transaction) => (
                    <div key={transaction.id} className="transaction-item">
                      <div className="transaction-info">
                        <div className="transaction-desc">{transaction.description}</div>
                        <div className="transaction-date">
                          {transaction.date.toLocaleString('zh-TW')}
                        </div>
                      </div>
                      <div className={`transaction-amount ${transaction.type}`}>
                        {transaction.type === 'income' ? '+' : '-'}
                        {formatCurrency(transaction.amount)}
                      </div>
                    </div>
                  ))}
                </div>

                <div className="sidebar-section">
                  <h3 className="sidebar-title">系統狀態</h3>

                  <div className="progress-container">
                    <div className="progress-label">
                      <span>CPU使用率</span>
                      <span>45%</span>
                    </div>
                    <div className="progress-bar">
                      <div className="progress-fill" style={{ width: '45%' }}></div>
                    </div>
                  </div>

                  <div className="progress-container">
                    <div className="progress-label">
                      <span>記憶體使用</span>
                      <span>62%</span>
                    </div>
                    <div className="progress-bar">
                      <div className="progress-fill" style={{ width: '62%' }}></div>
                    </div>
                  </div>

                  <div className="progress-container">
                    <div className="progress-label">
                      <span>網路連線</span>
                      <span>98%</span>
                    </div>
                    <div className="progress-bar">
                      <div className="progress-fill" style={{ width: '98%' }}></div>
                    </div>
                  </div>
                </div>
              </div>
            </section>

            {/* 數據表格區域 */}
            <section className="data-table">
              <div className="table-header">
                <h3 className="table-title">實時業務數據</h3>
              </div>
              <div className="table-content">
                <div className="data-row">
                  <div className="data-cell">瓦斯桶 20kg</div>
                  <div className="data-cell">庫存: 156</div>
                  <div className="data-cell">狀態: 正常</div>
                </div>
                <div className="data-row">
                  <div className="data-cell">瓦斯桶 5kg</div>
                  <div className="data-cell">庫存: 89</div>
                  <div className="data-cell">狀態: 正常</div>
                </div>
                <div className="data-row">
                  <div className="data-cell">瓦斯桶 50kg</div>
                  <div className="data-cell">庫存: 23</div>
                  <div className="data-cell">狀態: 警示</div>
                </div>
                <div className="data-row">
                  <div className="data-cell">配送車輛</div>
                  <div className="data-cell">在線: 8/10</div>
                  <div className="data-cell">狀態: 運行中</div>
                </div>
              </div>
            </section>
          </>
        )}

        {/* 產品管理模組 */}
        {activeModule === 'products' && <ProductManagement4D />}
        {/* 訂單管理模組 */}
        {activeModule === 'orders' && <OrderManagement4D />}
        {/* 客戶管理模組 */}
        {activeModule === 'customers' && <CustomerManagement4D />}
        {/* 財務管理模組 */}
        {activeModule === 'finance' && <FinancialAnalysis4D />}

        {/* 模塊導航 */}
        <section className="module-navigation">
          <h3 className="nav-title">系統模組</h3>
          <div className="module-grid">
            {modules.map((module) => (
              <button
                key={module.id}
                className={`module-btn ${activeModule === module.id ? 'active' : ''}`}
                onClick={() => setActiveModule(module.id)}
              >
                <span className="module-icon">{module.icon}</span>
                <span className="module-name">{module.name}</span>
              </button>
            ))}
          </div>
        </section>
      </main>

      {/* AI助手組件 */}
      {isAIOpen && (
        <AIAssistantPanel
          onClose={() => setIsAIOpen(false)}
          currentModule={activeModule}
          dashboardStats={{
            totalRevenue: stats.totalRevenue,
            monthlyRevenue: stats.todayRevenue * 30,
            totalOrders: stats.totalOrders,
            pendingOrders: stats.pendingOrders,
            totalCustomers: stats.totalCustomers,
            activeCustomers: stats.newCustomers,
            totalProducts: 100,
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
