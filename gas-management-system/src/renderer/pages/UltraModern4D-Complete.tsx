import React, { useState, useEffect } from 'react';
import './UltraModern4D.css';
import AIAssistantPanel from '../components/AIAssistantPanel';

// 导入组件
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
  category?: string;
  description?: string;
  minStock?: number;
}

interface Order {
  id: string;
  customer: string;
  product: string;
  quantity: number;
  amount: number;
  status: 'pending' | 'processing' | 'shipped' | 'delivered';
  timestamp: Date;
  phone?: string;
  address?: string;
  notes?: string;
}

interface Customer {
  id: string;
  name: string;
  type: 'individual' | 'business';
  phone: string;
  email?: string;
  address: string;
  orders: number;
  spent: number;
  level: 'Bronze' | 'Silver' | 'Gold' | 'VIP';
  status: 'active' | 'inactive';
  notes?: string;
}

const UltraModern4DComplete: React.FC = () => {
  // 核心状态管理
  const [activeModule, setActiveModule] = useState('dashboard');
  const [isAIOpen, setIsAIOpen] = useState(false);
  const [currentTime, setCurrentTime] = useState(new Date());

  // 模态框状态
  const [showProductModal, setShowProductModal] = useState(false);
  const [showOrderModal, setShowOrderModal] = useState(false);
  const [showCustomerModal, setShowCustomerModal] = useState(false);
  const [editingProduct, setEditingProduct] = useState<Product | null>(null);
  const [editingOrder, setEditingOrder] = useState<Order | null>(null);
  const [editingCustomer, setEditingCustomer] = useState<Customer | null>(null);

  // 业务统计数据
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

  // 产品数据管理
  const [products, setProducts] = useState<Product[]>([
    {
      id: 'P001',
      name: '20kg 瓦斯鋼瓶',
      type: '大型瓦斯',
      category: '液化石油氣',
      stock: 145,
      price: 1200,
      status: 'in-stock',
      image: '🛢️',
      description: '家用大型瓦斯鋼瓶，適合餐廳使用',
      minStock: 20
    },
    {
      id: 'P002',
      name: '5kg 瓦斯鋼瓶',
      type: '小型瓦斯',
      category: '液化石油氣',
      stock: 23,
      price: 350,
      status: 'low-stock',
      image: '⚡',
      description: '家用小型瓦斯鋼瓶，攜帶方便',
      minStock: 30
    },
    {
      id: 'P003',
      name: '瓦斯爐具',
      type: '設備',
      category: '廚房設備',
      stock: 67,
      price: 2500,
      status: 'in-stock',
      image: '🔥',
      description: '專業瓦斯爐具，安全可靠',
      minStock: 10
    },
    {
      id: 'P004',
      name: '瓦斯熱水器',
      type: '設備',
      category: '熱水設備',
      stock: 5,
      price: 8500,
      status: 'low-stock',
      image: '🚿',
      description: '節能瓦斯熱水器，恆溫控制',
      minStock: 8
    }
  ]);

  // 订单数据管理
  const [orders, setOrders] = useState<Order[]>([
    {
      id: 'ORD001',
      customer: '王小明',
      product: '20kg 瓦斯鋼瓶',
      quantity: 2,
      amount: 2400,
      status: 'processing',
      timestamp: new Date(Date.now() - 3600000),
      phone: '0912-345-678',
      address: '台北市大安區忠孝東路123號',
      notes: '請在下午配送'
    },
    {
      id: 'ORD002',
      customer: '李美麗',
      product: '5kg 瓦斯鋼瓶',
      quantity: 4,
      amount: 1400,
      status: 'shipped',
      timestamp: new Date(Date.now() - 7200000),
      phone: '0923-456-789',
      address: '新北市板橋區文化路456號',
      notes: '請電話聯絡再配送'
    },
    {
      id: 'ORD003',
      customer: '張三豐',
      product: '瓦斯爐具',
      quantity: 1,
      amount: 2500,
      status: 'delivered',
      timestamp: new Date(Date.now() - 86400000),
      phone: '0934-567-890',
      address: '桃園市中壢區中正路789號'
    },
    {
      id: 'ORD004',
      customer: '陳雅芳',
      product: '瓦斯熱水器',
      quantity: 1,
      amount: 8500,
      status: 'pending',
      timestamp: new Date(Date.now() - 1800000),
      phone: '0945-678-901',
      address: '台中市西屯區台灣大道99號',
      notes: '需要專業安裝服務'
    }
  ]);

  // 客户数据管理
  const [customers, setCustomers] = useState<Customer[]>([
    {
      id: 'C001',
      name: '王小明',
      type: 'individual',
      phone: '0912-345-678',
      email: 'wang@email.com',
      address: '台北市大安區忠孝東路123號',
      orders: 15,
      spent: 18000,
      level: 'VIP',
      status: 'active',
      notes: '長期客戶，信用良好'
    },
    {
      id: 'C002',
      name: '李美麗',
      type: 'individual',
      phone: '0923-456-789',
      email: 'li@email.com',
      address: '新北市板橋區文化路456號',
      orders: 8,
      spent: 9600,
      level: 'Gold',
      status: 'active'
    },
    {
      id: 'C003',
      name: '張三豐',
      type: 'business',
      phone: '0934-567-890',
      email: 'zhang@restaurant.com',
      address: '桃園市中壢區中正路789號',
      orders: 25,
      spent: 45000,
      level: 'VIP',
      status: 'active',
      notes: '餐廳老闆，大客戶'
    },
    {
      id: 'C004',
      name: '陳雅芳',
      type: 'individual',
      phone: '0945-678-901',
      email: 'chen@email.com',
      address: '台中市西屯區台灣大道99號',
      orders: 3,
      spent: 3200,
      level: 'Silver',
      status: 'active'
    }
  ]);

  // 新增产品表单数据
  const [newProduct, setNewProduct] = useState<Partial<Product>>({
    name: '',
    type: '',
    category: '',
    price: 0,
    stock: 0,
    description: '',
    image: '📦',
    minStock: 5
  });

  // 新增订单表单数据
  const [newOrder, setNewOrder] = useState<Partial<Order>>({
    customer: '',
    product: '',
    quantity: 1,
    phone: '',
    address: '',
    notes: ''
  });

  // 新增客户表单数据
  const [newCustomer, setNewCustomer] = useState<Partial<Customer>>({
    name: '',
    type: 'individual',
    phone: '',
    email: '',
    address: '',
    notes: ''
  });

  // 实时时间更新
  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
      // 模拟实时数据更新
      setStats(prev => ({
        ...prev,
        todayOrders: prev.todayOrders + Math.floor(Math.random() * 0.1),
        efficiency: Math.min(100, prev.efficiency + Math.random() * 0.01)
      }));
    }, 5000);
    return () => clearInterval(timer);
  }, []);

  // 计算统计数据
  useEffect(() => {
    const totalRevenue = orders
      .filter(o => o.status === 'delivered')
      .reduce((sum, order) => sum + order.amount, 0);

    const todayOrders = orders.filter(o => {
      const orderDate = new Date(o.timestamp);
      const today = new Date();
      return orderDate.toDateString() === today.toDateString();
    }).length;

    setStats(prev => ({
      ...prev,
      totalRevenue,
      todayOrders,
      activeCustomers: customers.filter(c => c.status === 'active').length,
      productsSold: orders.reduce((sum, o) => sum + o.quantity, 0)
    }));
  }, [orders, customers]);

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
      'delivered': 'var(--accent-green)',
      'active': 'var(--accent-green)',
      'inactive': 'var(--text-secondary)'
    };
    return colors[status] || 'var(--text-secondary)';
  };

  // 产品CRUD操作
  const handleAddProduct = () => {
    setEditingProduct(null);
    setNewProduct({
      name: '',
      type: '',
      category: '',
      price: 0,
      stock: 0,
      description: '',
      image: '📦',
      minStock: 5
    });
    setShowProductModal(true);
  };

  const handleEditProduct = (product: Product) => {
    setEditingProduct(product);
    setNewProduct({ ...product });
    setShowProductModal(true);
  };

  const handleDeleteProduct = (productId: string) => {
    if (confirm('確定要刪除此產品嗎？此操作無法復原！')) {
      setProducts(prev => prev.filter(p => p.id !== productId));
    }
  };

  const handleSaveProduct = () => {
    if (!newProduct.name || !newProduct.type || !newProduct.price) {
      alert('請填寫所有必填欄位');
      return;
    }

    if (editingProduct) {
      // 編輯現有產品
      setProducts(prev => prev.map(p =>
        p.id === editingProduct.id
          ? { ...newProduct as Product, id: editingProduct.id }
          : p
      ));
    } else {
      // 新增產品
      const id = `P${String(products.length + 1).padStart(3, '0')}`;
      const status = newProduct.stock! > (newProduct.minStock || 5) ? 'in-stock' :
        newProduct.stock! > 0 ? 'low-stock' : 'out-of-stock';
      setProducts(prev => [...prev, {
        ...newProduct as Product,
        id,
        status
      }]);
    }

    setShowProductModal(false);
    setEditingProduct(null);
  };

  // 订单CRUD操作
  const handleAddOrder = () => {
    setEditingOrder(null);
    setNewOrder({
      customer: '',
      product: '',
      quantity: 1,
      phone: '',
      address: '',
      notes: ''
    });
    setShowOrderModal(true);
  };

  const handleEditOrder = (order: Order) => {
    setEditingOrder(order);
    setNewOrder({ ...order });
    setShowOrderModal(true);
  };

  const handleDeleteOrder = (orderId: string) => {
    if (confirm('確定要刪除此訂單嗎？此操作無法復原！')) {
      setOrders(prev => prev.filter(o => o.id !== orderId));
    }
  };

  const handleSaveOrder = () => {
    if (!newOrder.customer || !newOrder.product || !newOrder.quantity) {
      alert('請填寫所有必填欄位');
      return;
    }

    const product = products.find(p => p.name === newOrder.product);
    const amount = (product?.price || 0) * (newOrder.quantity || 0);

    if (editingOrder) {
      // 編輯現有訂單
      setOrders(prev => prev.map(o =>
        o.id === editingOrder.id
          ? { ...newOrder as Order, id: editingOrder.id, amount }
          : o
      ));
    } else {
      // 新增訂單
      const id = `ORD${String(orders.length + 1).padStart(3, '0')}`;
      setOrders(prev => [...prev, {
        ...newOrder as Order,
        id,
        amount,
        status: 'pending',
        timestamp: new Date()
      }]);
    }

    setShowOrderModal(false);
    setEditingOrder(null);
  };

  const handleUpdateOrderStatus = (orderId: string, newStatus: Order['status']) => {
    setOrders(prev => prev.map(o =>
      o.id === orderId ? { ...o, status: newStatus } : o
    ));
  };

  // 客户CRUD操作
  const handleAddCustomer = () => {
    setEditingCustomer(null);
    setNewCustomer({
      name: '',
      type: 'individual',
      phone: '',
      email: '',
      address: '',
      notes: ''
    });
    setShowCustomerModal(true);
  };

  const handleEditCustomer = (customer: Customer) => {
    setEditingCustomer(customer);
    setNewCustomer({ ...customer });
    setShowCustomerModal(true);
  };

  const handleDeleteCustomer = (customerId: string) => {
    if (confirm('確定要刪除此客戶嗎？此操作無法復原！')) {
      setCustomers(prev => prev.filter(c => c.id !== customerId));
    }
  };

  const handleSaveCustomer = () => {
    if (!newCustomer.name || !newCustomer.phone || !newCustomer.address) {
      alert('請填寫所有必填欄位');
      return;
    }

    if (editingCustomer) {
      // 編輯現有客戶
      setCustomers(prev => prev.map(c =>
        c.id === editingCustomer.id
          ? { ...newCustomer as Customer, id: editingCustomer.id }
          : c
      ));
    } else {
      // 新增客戶
      const id = `C${String(customers.length + 1).padStart(3, '0')}`;
      setCustomers(prev => [...prev, {
        ...newCustomer as Customer,
        id,
        orders: 0,
        spent: 0,
        level: 'Bronze',
        status: 'active'
      }]);
    }

    setShowCustomerModal(false);
    setEditingCustomer(null);
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
      {/* 快速操作按钮 */}
      <div className="quick-actions-4d">
        <button className="quick-action-btn" onClick={handleAddProduct}>
          <div className="action-icon">📦</div>
          <div className="action-text">新增產品</div>
        </button>
        <button className="quick-action-btn" onClick={handleAddOrder}>
          <div className="action-icon">📋</div>
          <div className="action-text">新增訂單</div>
        </button>
        <button className="quick-action-btn" onClick={handleAddCustomer}>
          <div className="action-icon">👤</div>
          <div className="action-text">新增客戶</div>
        </button>
        <button className="quick-action-btn" onClick={() => setActiveModule('finance')}>
          <div className="action-icon">💰</div>
          <div className="action-text">財務分析</div>
        </button>
      </div>

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
          {orders.slice(0, 3).map(order => (
            <div key={order.id} className="stream-item">
              <div className="stream-icon">🔥</div>
              <div className="stream-content">
                <div className="stream-title">{order.product} - {order.customer}</div>
                <div className="stream-time">{order.timestamp.toLocaleString('zh-TW')}</div>
              </div>
              <div className="stream-value">{formatCurrency(order.amount)}</div>
            </div>
          ))}
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
            <div className="performance-value">{stats.efficiency.toFixed(1)}%</div>
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
      <div className="module-header">
        <h2 className="module-title">📦 产品管理中心</h2>
        <button className="add-btn-4d" onClick={handleAddProduct}>
          <span className="btn-icon">➕</span>
          新增產品
        </button>
      </div>

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
              <div className="product-category">{product.category}</div>
              <div className="product-price">{formatCurrency(product.price)}</div>
              <div className="product-status" style={{ color: getStatusColor(product.status) }}>
                {product.status === 'in-stock' ? '库存充足' :
                  product.status === 'low-stock' ? '库存不足' : '缺货'}
              </div>
            </div>
            <div className="product-actions">
              <button className="action-btn primary" onClick={() => handleEditProduct(product)}>
                编辑
              </button>
              <button
                className="action-btn secondary"
                onClick={() => {
                  const newStock = prompt(`請輸入 ${product.name} 的補貨數量:`, '10');
                  if (newStock && !isNaN(Number(newStock))) {
                    setProducts(prev => prev.map(p =>
                      p.id === product.id
                        ? {
                          ...p,
                          stock: p.stock + Number(newStock),
                          status: (p.stock + Number(newStock)) > (p.minStock || 5) ? 'in-stock' : 'low-stock'
                        }
                        : p
                    ));
                  }
                }}
              >
                补货
              </button>
              <button className="action-btn danger" onClick={() => handleDeleteProduct(product.id)}>
                刪除
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  // 渲染订单管理模块
  const renderOrders = () => (
    <div className="orders-module">
      <div className="module-header">
        <h2 className="module-title">📋 订单管理中心</h2>
        <button className="add-btn-4d" onClick={handleAddOrder}>
          <span className="btn-icon">➕</span>
          新增訂單
        </button>
      </div>

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
              {order.phone && <div className="order-phone">📞 {order.phone}</div>}
              {order.address && <div className="order-address">📍 {order.address}</div>}
              {order.notes && <div className="order-notes">📝 {order.notes}</div>}
            </div>
            <div className="order-actions">
              <button className="action-btn primary" onClick={() => handleEditOrder(order)}>
                編輯
              </button>
              <select
                className="status-select"
                value={order.status}
                onChange={(e) => handleUpdateOrderStatus(order.id, e.target.value as Order['status'])}
              >
                <option value="pending">待處理</option>
                <option value="processing">處理中</option>
                <option value="shipped">已發貨</option>
                <option value="delivered">已送達</option>
              </select>
              <button className="action-btn danger" onClick={() => handleDeleteOrder(order.id)}>
                刪除
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  // 渲染客户管理模块
  const renderCustomers = () => (
    <div className="customers-module">
      <div className="module-header">
        <h2 className="module-title">👥 客户关系管理</h2>
        <button className="add-btn-4d" onClick={handleAddCustomer}>
          <span className="btn-icon">➕</span>
          新增客戶
        </button>
      </div>

      <div className="customers-grid">
        {customers.map(customer => (
          <div key={customer.id} className="customer-card-4d">
            <div className="customer-header">
              <div className="customer-name">{customer.name}</div>
              <div className="customer-level" style={{ color: getStatusColor(customer.level.toLowerCase()) }}>
                {customer.level}
              </div>
            </div>
            <div className="customer-info">
              <div className="customer-type">
                {customer.type === 'individual' ? '👤 個人客戶' : '🏢 企業客戶'}
              </div>
              <div className="customer-phone">📞 {customer.phone}</div>
              {customer.email && <div className="customer-email">📧 {customer.email}</div>}
              <div className="customer-address">📍 {customer.address}</div>
              <div className="customer-stats">
                <span>訂單: {customer.orders} 筆</span>
                <span>消費: {formatCurrency(customer.spent)}</span>
              </div>
              {customer.notes && <div className="customer-notes">📝 {customer.notes}</div>}
            </div>
            <div className="customer-actions">
              <button className="action-btn primary" onClick={() => handleEditCustomer(customer)}>
                編輯
              </button>
              <button
                className="action-btn secondary"
                onClick={() => {
                  const customerOrders = orders.filter(o => o.customer === customer.name);
                  alert(`${customer.name} 的訂單記錄:\n${customerOrders.map(o =>
                    `${o.id}: ${o.product} - ${formatCurrency(o.amount)}`
                  ).join('\n')}`);
                }}
              >
                訂單記錄
              </button>
              <button className="action-btn danger" onClick={() => handleDeleteCustomer(customer.id)}>
                刪除
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  // 渲染财务分析模块
  const renderFinance = () => (
    <div className="finance-module">
      <h2 className="module-title">💰 财务分析中心</h2>
      <AccountingSystem />
    </div>
  );

  // 渲染当前模块
  const renderCurrentModule = () => {
    switch (activeModule) {
      case 'dashboard': return renderDashboard();
      case 'products': return renderProducts();
      case 'orders': return renderOrders();
      case 'customers': return renderCustomers();
      case 'finance': return renderFinance();
      case 'reports': return (
        <div className="reports-module">
          <h2 className="module-title">📊 智能报表中心</h2>
          <div className="reports-grid">
            <div className="report-card">
              <h3>📈 銷售報表</h3>
              <p>總銷售額: {formatCurrency(stats.totalRevenue)}</p>
              <p>訂單數量: {orders.length} 筆</p>
              <p>平均訂單金額: {formatCurrency(stats.totalRevenue / orders.length)}</p>
            </div>
            <div className="report-card">
              <h3>📦 庫存報表</h3>
              <p>總產品數: {products.length} 種</p>
              <p>庫存不足: {products.filter(p => p.status === 'low-stock').length} 種</p>
              <p>缺貨產品: {products.filter(p => p.status === 'out-of-stock').length} 種</p>
            </div>
            <div className="report-card">
              <h3>👥 客戶報表</h3>
              <p>總客戶數: {customers.length} 位</p>
              <p>VIP客戶: {customers.filter(c => c.level === 'VIP').length} 位</p>
              <p>活躍客戶: {customers.filter(c => c.status === 'active').length} 位</p>
            </div>
          </div>
        </div>
      );
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

      {/* 产品模态框 */}
      {showProductModal && (
        <div className="modal-overlay-4d">
          <div className="modal-content-4d">
            <div className="modal-header">
              <h3>{editingProduct ? '編輯產品' : '新增產品'}</h3>
              <button className="close-btn" onClick={() => setShowProductModal(false)}>✕</button>
            </div>
            <div className="modal-body">
              <div className="form-row">
                <div className="form-group">
                  <label>產品名稱 *</label>
                  <input
                    type="text"
                    value={newProduct.name || ''}
                    onChange={(e) => setNewProduct(prev => ({ ...prev, name: e.target.value }))}
                    placeholder="請輸入產品名稱"
                  />
                </div>
                <div className="form-group">
                  <label>產品類型 *</label>
                  <input
                    type="text"
                    value={newProduct.type || ''}
                    onChange={(e) => setNewProduct(prev => ({ ...prev, type: e.target.value }))}
                    placeholder="例: 大型瓦斯、小型瓦斯"
                  />
                </div>
              </div>
              <div className="form-row">
                <div className="form-group">
                  <label>產品分類</label>
                  <input
                    type="text"
                    value={newProduct.category || ''}
                    onChange={(e) => setNewProduct(prev => ({ ...prev, category: e.target.value }))}
                    placeholder="例: 液化石油氣、廚房設備"
                  />
                </div>
                <div className="form-group">
                  <label>產品圖示</label>
                  <input
                    type="text"
                    value={newProduct.image || '📦'}
                    onChange={(e) => setNewProduct(prev => ({ ...prev, image: e.target.value }))}
                    placeholder="例: 🔥 ⚡ 🛢️"
                  />
                </div>
              </div>
              <div className="form-row">
                <div className="form-group">
                  <label>價格 *</label>
                  <input
                    type="number"
                    value={newProduct.price || 0}
                    onChange={(e) => setNewProduct(prev => ({ ...prev, price: Number(e.target.value) }))}
                    placeholder="0"
                    min="0"
                  />
                </div>
                <div className="form-group">
                  <label>庫存數量 *</label>
                  <input
                    type="number"
                    value={newProduct.stock || 0}
                    onChange={(e) => setNewProduct(prev => ({ ...prev, stock: Number(e.target.value) }))}
                    placeholder="0"
                    min="0"
                  />
                </div>
              </div>
              <div className="form-row">
                <div className="form-group">
                  <label>最低庫存</label>
                  <input
                    type="number"
                    value={newProduct.minStock || 5}
                    onChange={(e) => setNewProduct(prev => ({ ...prev, minStock: Number(e.target.value) }))}
                    placeholder="5"
                    min="1"
                  />
                </div>
              </div>
              <div className="form-group">
                <label>產品描述</label>
                <textarea
                  value={newProduct.description || ''}
                  onChange={(e) => setNewProduct(prev => ({ ...prev, description: e.target.value }))}
                  placeholder="請輸入產品描述"
                  rows={3}
                />
              </div>
            </div>
            <div className="modal-footer">
              <button className="btn-cancel" onClick={() => setShowProductModal(false)}>
                取消
              </button>
              <button className="btn-save" onClick={handleSaveProduct}>
                {editingProduct ? '更新' : '新增'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* 订单模态框 */}
      {showOrderModal && (
        <div className="modal-overlay-4d">
          <div className="modal-content-4d">
            <div className="modal-header">
              <h3>{editingOrder ? '編輯訂單' : '新增訂單'}</h3>
              <button className="close-btn" onClick={() => setShowOrderModal(false)}>✕</button>
            </div>
            <div className="modal-body">
              <div className="form-row">
                <div className="form-group">
                  <label>客戶名稱 *</label>
                  <input
                    type="text"
                    value={newOrder.customer || ''}
                    onChange={(e) => setNewOrder(prev => ({ ...prev, customer: e.target.value }))}
                    placeholder="請輸入客戶名稱"
                  />
                </div>
                <div className="form-group">
                  <label>產品 *</label>
                  <select
                    value={newOrder.product || ''}
                    onChange={(e) => setNewOrder(prev => ({ ...prev, product: e.target.value }))}
                  >
                    <option value="">請選擇產品</option>
                    {products.map(product => (
                      <option key={product.id} value={product.name}>
                        {product.name} - {formatCurrency(product.price)}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
              <div className="form-row">
                <div className="form-group">
                  <label>數量 *</label>
                  <input
                    type="number"
                    value={newOrder.quantity || 1}
                    onChange={(e) => setNewOrder(prev => ({ ...prev, quantity: Number(e.target.value) }))}
                    placeholder="1"
                    min="1"
                  />
                </div>
                <div className="form-group">
                  <label>聯絡電話</label>
                  <input
                    type="tel"
                    value={newOrder.phone || ''}
                    onChange={(e) => setNewOrder(prev => ({ ...prev, phone: e.target.value }))}
                    placeholder="例: 0912-345-678"
                  />
                </div>
              </div>
              <div className="form-group">
                <label>配送地址</label>
                <input
                  type="text"
                  value={newOrder.address || ''}
                  onChange={(e) => setNewOrder(prev => ({ ...prev, address: e.target.value }))}
                  placeholder="請輸入配送地址"
                />
              </div>
              <div className="form-group">
                <label>備註</label>
                <textarea
                  value={newOrder.notes || ''}
                  onChange={(e) => setNewOrder(prev => ({ ...prev, notes: e.target.value }))}
                  placeholder="請輸入訂單備註"
                  rows={3}
                />
              </div>
            </div>
            <div className="modal-footer">
              <button className="btn-cancel" onClick={() => setShowOrderModal(false)}>
                取消
              </button>
              <button className="btn-save" onClick={handleSaveOrder}>
                {editingOrder ? '更新' : '新增'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* 客户模态框 */}
      {showCustomerModal && (
        <div className="modal-overlay-4d">
          <div className="modal-content-4d">
            <div className="modal-header">
              <h3>{editingCustomer ? '編輯客戶' : '新增客戶'}</h3>
              <button className="close-btn" onClick={() => setShowCustomerModal(false)}>✕</button>
            </div>
            <div className="modal-body">
              <div className="form-row">
                <div className="form-group">
                  <label>客戶名稱 *</label>
                  <input
                    type="text"
                    value={newCustomer.name || ''}
                    onChange={(e) => setNewCustomer(prev => ({ ...prev, name: e.target.value }))}
                    placeholder="請輸入客戶名稱"
                  />
                </div>
                <div className="form-group">
                  <label>客戶類型 *</label>
                  <select
                    value={newCustomer.type || 'individual'}
                    onChange={(e) => setNewCustomer(prev => ({ ...prev, type: e.target.value as 'individual' | 'business' }))}
                  >
                    <option value="individual">個人客戶</option>
                    <option value="business">企業客戶</option>
                  </select>
                </div>
              </div>
              <div className="form-row">
                <div className="form-group">
                  <label>聯絡電話 *</label>
                  <input
                    type="tel"
                    value={newCustomer.phone || ''}
                    onChange={(e) => setNewCustomer(prev => ({ ...prev, phone: e.target.value }))}
                    placeholder="例: 0912-345-678"
                  />
                </div>
                <div className="form-group">
                  <label>電子信箱</label>
                  <input
                    type="email"
                    value={newCustomer.email || ''}
                    onChange={(e) => setNewCustomer(prev => ({ ...prev, email: e.target.value }))}
                    placeholder="例: customer@email.com"
                  />
                </div>
              </div>
              <div className="form-group">
                <label>地址 *</label>
                <input
                  type="text"
                  value={newCustomer.address || ''}
                  onChange={(e) => setNewCustomer(prev => ({ ...prev, address: e.target.value }))}
                  placeholder="請輸入客戶地址"
                />
              </div>
              <div className="form-group">
                <label>備註</label>
                <textarea
                  value={newCustomer.notes || ''}
                  onChange={(e) => setNewCustomer(prev => ({ ...prev, notes: e.target.value }))}
                  placeholder="請輸入客戶備註"
                  rows={3}
                />
              </div>
            </div>
            <div className="modal-footer">
              <button className="btn-cancel" onClick={() => setShowCustomerModal(false)}>
                取消
              </button>
              <button className="btn-save" onClick={handleSaveCustomer}>
                {editingCustomer ? '更新' : '新增'}
              </button>
            </div>
          </div>
        </div>
      )}

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
            totalCustomers: customers.length,
            activeCustomers: customers.filter(c => c.status === 'active').length,
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

export default UltraModern4DComplete;
