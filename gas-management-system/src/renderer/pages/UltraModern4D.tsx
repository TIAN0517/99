import React, { useState, useEffect } from 'react';
import './UltraModern4D.css';
import AIAssistantPanel from '../components/AIAssistantPanel';

// 導入組件
import ProductManagement4D from './ProductManagement-4d';
import OrderManagement4D from './OrderManagement-4d';
import CustomerManagement4D from './CustomerManagement-4d';
import AccountingSystem from '../components/AccountingSystem';

// 数据类型定义
interface BusinessStats {
  totalRevenue: number;
  monthlyGrowth: number;
  todayOrders: number;
  activeCustomers: number;
  productsSold: number;
  profit: number;
  efficiency: number;
  satisfaction: number;
}

interface Product {
  id: string;
  name: string;
  type: string;
  stock: number;
  price: number;
  status: 'in-stock' | 'low-stock' | 'out-of-stock';
  image: string;
}

interface Order {
  id: string;
  customer: string;
  product: string;
  quantity: number;
  amount: number;
  status: 'pending' | 'processing' | 'shipped' | 'delivered';
  timestamp: Date;
}

const UltraModern4D: React.FC = () => {
  // 状态管理
  const [activeModule, setActiveModule] = useState('dashboard');
  const [isAIOpen, setIsAIOpen] = useState(false);
  const [currentTime, setCurrentTime] = useState(new Date());

  // 添加模態框狀態
  const [showProductModal, setShowProductModal] = useState(false);
  const [showOrderModal, setShowOrderModal] = useState(false);
  const [showCustomerModal, setShowCustomerModal] = useState(false);
  const [editingItem, setEditingItem] = useState<any>(null);

  const [stats, setStats] = useState<BusinessStats>({
    totalRevenue: 3250000,
    monthlyGrowth: 15.8,
    todayOrders: 47,
    activeCustomers: 1256,
    productsSold: 8943,
    profit: 925000,
    efficiency: 94.2,
    satisfaction: 4.8
  });

  const [products] = useState<Product[]>([
    {
      id: 'P001',
      name: '20kg 瓦斯鋼瓶',
      type: '大型瓦斯',
      stock: 145,
      price: 1200,
      status: 'in-stock',
      image: '🛢️'
    },
    {
      id: 'P002',
      name: '5kg 瓦斯鋼瓶',
      type: '小型瓦斯',
      stock: 23,
      price: 350,
      status: 'low-stock',
      image: '⚡'
    },
    {
      id: 'P003',
      name: '瓦斯爐具',
      type: '設備',
      stock: 67,
      price: 2500,
      status: 'in-stock',
      image: '🔥'
    }
  ]);

  const [orders] = useState<Order[]>([
    {
      id: 'ORD001',
      customer: '王小明',
      product: '20kg 瓦斯鋼瓶',
      quantity: 2,
      amount: 2400,
      status: 'processing',
      timestamp: new Date(Date.now() - 3600000)
    },
    {
      id: 'ORD002',
      customer: '李美麗',
      product: '5kg 瓦斯鋼瓶',
      quantity: 4,
      amount: 1400,
      status: 'shipped',
      timestamp: new Date(Date.now() - 7200000)
    },
    {
      id: 'ORD003',
      customer: '張三豐',
      product: '瓦斯爐具',
      quantity: 1,
      amount: 2500,
      status: 'delivered',
      timestamp: new Date(Date.now() - 86400000)
    }
  ]);

  // 实时时间更新
  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  // 格式化货币
  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('zh-TW', {
      style: 'currency',
      currency: 'TWD',
      minimumFractionDigits: 0
    }).format(amount);
  };
  // 获取状态颜色
  const getStatusColor = (status: string) => {
    const colors: { [key: string]: string } = {
      'in-stock': 'var(--accent-green)',
      'low-stock': 'var(--accent-orange)',
      'out-of-stock': 'var(--accent-red)',
      'pending': 'var(--accent-orange)',
      'processing': 'var(--primary-cyan)',
      'shipped': 'var(--primary-blue)',
      'delivered': 'var(--accent-green)'
    };
    return colors[status] || 'var(--text-secondary)';
  };

  // 模块导航
  const modules = [
    { id: 'dashboard', name: '🏠 智能仪表板', icon: '🏠', color: 'var(--primary-cyan)' },
    { id: 'products', name: '📦 产品管理', icon: '📦', color: 'var(--primary-magenta)' },
    { id: 'orders', name: '📋 订单中心', icon: '📋', color: 'var(--primary-blue)' },
    { id: 'customers', name: '👥 客户关系', icon: '👥', color: 'var(--accent-green)' },
    { id: 'finance', name: '💰 财务分析', icon: '💰', color: 'var(--accent-orange)' },
    { id: 'reports', name: '📊 智能报表', icon: '📊', color: 'var(--accent-red)' }
  ];

  // 渲染仪表板模块
  const renderDashboard = () => (
    <div className="dashboard-module">
      {/* 核心统计卡片 */}
      <div className="stats-grid-4d">
        <div className="stat-card-4d revenue">
          <div className="card-header">
            <div className="stat-icon">💰</div>
            <div className="stat-title">总营收</div>
          </div>
          <div className="stat-value">{formatCurrency(stats.totalRevenue)}</div>
          <div className="stat-growth positive">
            <span className="growth-icon">📈</span>
            <span>+{stats.monthlyGrowth}%</span>
          </div>
          <div className="stat-chart">
            <div className="chart-bar" style={{ height: '80%' }}></div>
            <div className="chart-bar" style={{ height: '60%' }}></div>
            <div className="chart-bar" style={{ height: '90%' }}></div>
            <div className="chart-bar" style={{ height: '75%' }}></div>
          </div>
        </div>

        <div className="stat-card-4d orders">
          <div className="card-header">
            <div className="stat-icon">📋</div>
            <div className="stat-title">今日订单</div>
          </div>
          <div className="stat-value">{stats.todayOrders}</div>
          <div className="stat-growth positive">
            <span className="growth-icon">⚡</span>
            <span>实时更新</span>
          </div>
          <div className="pulse-indicator"></div>
        </div>

        <div className="stat-card-4d customers">
          <div className="card-header">
            <div className="stat-icon">👥</div>
            <div className="stat-title">活跃客户</div>
          </div>
          <div className="stat-value">{stats.activeCustomers.toLocaleString()}</div>
          <div className="stat-growth positive">
            <span className="growth-icon">💫</span>
            <span>本月 +{Math.floor(stats.activeCustomers * 0.08)}</span>
          </div>
          <div className="customer-avatars">
            <div className="avatar">👨</div>
            <div className="avatar">👩</div>
            <div className="avatar">👴</div>
            <div className="avatar">👵</div>
          </div>
        </div>

        <div className="stat-card-4d profit">
          <div className="card-header">
            <div className="stat-icon">💎</div>
            <div className="stat-title">净利润</div>
          </div>
          <div className="stat-value">{formatCurrency(stats.profit)}</div>
          <div className="stat-growth positive">
            <span className="growth-icon">🚀</span>
            <span>利润率 {((stats.profit / stats.totalRevenue) * 100).toFixed(1)}%</span>
          </div>
          <div className="profit-ring">
            <div className="ring-progress" style={{ '--progress': '68%' } as any}></div>
          </div>
        </div>
      </div>

      {/* 实时数据流 */}
      <div className="data-stream-section">
        <h3 className="section-title">📊 实时业务流</h3>
        <div className="data-stream">
          <div className="stream-item">
            <div className="stream-icon">🔥</div>
            <div className="stream-content">
              <div className="stream-title">瓦斯销售 +2 桶</div>
              <div className="stream-time">刚刚</div>
            </div>
            <div className="stream-value">+{formatCurrency(2400)}</div>
          </div>
          <div className="stream-item">
            <div className="stream-icon">🚚</div>
            <div className="stream-content">
              <div className="stream-title">配送完成 - 王小明</div>
              <div className="stream-time">2分钟前</div>
            </div>
            <div className="stream-value">订单 #ORD001</div>
          </div>
          <div className="stream-item">
            <div className="stream-icon">👤</div>
            <div className="stream-content">
              <div className="stream-title">新客户注册</div>
              <div className="stream-time">5分钟前</div>
            </div>
            <div className="stream-value">李小花</div>
          </div>
        </div>
      </div>

      {/* 性能指标 */}
      <div className="performance-section">
        <h3 className="section-title">⚡ 性能指标</h3>
        <div className="performance-grid">
          <div className="performance-item">
            <div className="performance-label">运营效率</div>
            <div className="performance-bar">
              <div className="bar-fill" style={{ width: `${stats.efficiency}%` }}></div>
            </div>
            <div className="performance-value">{stats.efficiency}%</div>
          </div>
          <div className="performance-item">
            <div className="performance-label">客户满意度</div>
            <div className="performance-stars">
              {[1, 2, 3, 4, 5].map(star => (
                <span key={star} className={star <= stats.satisfaction ? 'star-filled' : 'star-empty'}>
                  ⭐
                </span>
              ))}
            </div>
            <div className="performance-value">{stats.satisfaction}/5.0</div>
          </div>
        </div>
      </div>
    </div>
  );

  // 渲染产品管理模块
  const renderProducts = () => (
    <div className="products-module">
      <h2 className="module-title">📦 产品管理中心</h2>
      <div className="products-grid">
        {products.map(product => (
          <div key={product.id} className="product-card-4d">
            <div className="product-image">
              <div className="product-icon">{product.image}</div>
              <div className="stock-indicator" style={{ color: getStatusColor(product.status) }}>
                库存: {product.stock}
              </div>
            </div>
            <div className="product-info">
              <h4 className="product-name">{product.name}</h4>
              <div className="product-type">{product.type}</div>
              <div className="product-price">{formatCurrency(product.price)}</div>
              <div className="product-status" style={{ color: getStatusColor(product.status) }}>
                {product.status === 'in-stock' ? '库存充足' :
                  product.status === 'low-stock' ? '库存不足' : '缺货'}
              </div>
            </div>
            <div className="product-actions">
              <button className="action-btn primary">编辑</button>
              <button className="action-btn secondary">补货</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  // 渲染订单管理模块
  const renderOrders = () => (
    <div className="orders-module">
      <h2 className="module-title">📋 订单管理中心</h2>
      <div className="orders-list">
        {orders.map(order => (
          <div key={order.id} className="order-card-4d">
            <div className="order-header">
              <div className="order-id">{order.id}</div>
              <div className="order-status" style={{ color: getStatusColor(order.status) }}>
                {order.status === 'pending' ? '待处理' :
                  order.status === 'processing' ? '处理中' :
                    order.status === 'shipped' ? '已发货' : '已送达'}
              </div>
            </div>
            <div className="order-content">
              <div className="order-customer">👤 {order.customer}</div>
              <div className="order-product">📦 {order.product} × {order.quantity}</div>
              <div className="order-amount">💰 {formatCurrency(order.amount)}</div>
              <div className="order-time">⏰ {order.timestamp.toLocaleString('zh-TW')}</div>
            </div>
            <div className="order-actions">
              <button className="action-btn primary">查看详情</button>
              <button className="action-btn secondary">更新状态</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  // 渲染当前模块
  const renderCurrentModule = () => {
    switch (activeModule) {
      case 'dashboard': return renderDashboard();
      case 'products': return renderProducts();
      case 'orders': return renderOrders();
      case 'customers': return <div className="module-placeholder">👥 客户关系管理 - 开发中</div>;
      case 'finance': return <div className="module-placeholder">💰 财务分析 - 开发中</div>;
      case 'reports': return <div className="module-placeholder">📊 智能报表 - 开发中</div>;
      default: return renderDashboard();
    }
  };

  return (
    <div className="ultra-modern-4d">
      {/* 动态背景 */}
      <div className="animated-background">
        <div className="particles"></div>
        <div className="grid-pattern"></div>
        <div className="scan-lines"></div>
      </div>

      {/* 顶部导航栏 */}
      <header className="top-header-4d">
        <div className="header-left">
          <h1 className="system-title">🔥 4D瓦斯管理系统</h1>
          <div className="time-display">
            {currentTime.toLocaleString('zh-TW')}
          </div>
        </div>
        <div className="header-right">
          <button
            className="ai-btn-4d"
            onClick={() => setIsAIOpen(!isAIOpen)}
          >
            🤖 AI助手
          </button>
          <div className="user-profile-4d">
            <div className="user-avatar">👨‍💼</div>
            <span className="user-name">系统管理员</span>
          </div>
        </div>
      </header>

      {/* 主要内容区域 */}
      <main className="main-container-4d">
        {/* 左侧导航 */}
        <nav className="sidebar-4d">
          <div className="nav-modules">
            {modules.map(module => (
              <button
                key={module.id}
                className={`nav-module ${activeModule === module.id ? 'active' : ''}`}
                onClick={() => setActiveModule(module.id)}
                style={{ '--module-color': module.color } as any}
              >
                <span className="module-icon">{module.icon}</span>
                <span className="module-name">{module.name}</span>
                {activeModule === module.id && <div className="active-indicator"></div>}
              </button>
            ))}
          </div>
        </nav>

        {/* 内容显示区 */}
        <section className="content-area-4d">
          {renderCurrentModule()}
        </section>
      </main>

      {/* AI助手面板 */}
      {isAIOpen && (
        <AIAssistantPanel
          onClose={() => setIsAIOpen(false)}
          currentModule={activeModule}
          dashboardStats={{
            totalRevenue: stats.totalRevenue,
            monthlyRevenue: stats.totalRevenue,
            totalOrders: orders.length,
            pendingOrders: orders.filter(o => o.status === 'pending').length,
            totalCustomers: stats.activeCustomers,
            activeCustomers: stats.activeCustomers,
            totalProducts: products.length,
            lowStockProducts: products.filter(p => p.status === 'low-stock').length,
            profit: stats.profit,
            expenses: stats.totalRevenue - stats.profit
          }}
        />
      )}
    </div>
  );
};

export default UltraModern4D;
