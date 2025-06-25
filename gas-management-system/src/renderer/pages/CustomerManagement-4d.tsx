import React, { useState, useEffect } from 'react';
import './CustomerManagement-4d.css';

interface Customer {
  id: string;
  name: string;
  phone: string;
  email?: string;
  address: string;
  type: 'vip' | 'regular' | 'business';
  avatar: string;
  joinDate: string;
  totalOrders: number;
  totalSpent: number;
  lastOrderDate?: string;
  notes?: string;
  status: 'active' | 'inactive';
}

const CustomerManagement4D: React.FC = () => {
  const [customers, setCustomers] = useState<Customer[]>([
    {
      id: 'CUS-001',
      name: '王小明',
      phone: '0912-345-678',
      email: 'wang@example.com',
      address: '台北市信義區信義路五段7號',
      type: 'vip',
      avatar: '👨‍💼',
      joinDate: '2023-01-15',
      totalOrders: 28,
      totalSpent: 45600,
      lastOrderDate: '2025-01-15',
      notes: 'VIP客戶，經常大量訂購',
      status: 'active'
    },
    {
      id: 'CUS-002',
      name: '李美華',
      phone: '0923-456-789',
      email: 'li@example.com',
      address: '新北市板橋區中山路一段161號',
      type: 'business',
      avatar: '👩‍💼',
      joinDate: '2023-03-20',
      totalOrders: 45,
      totalSpent: 78900,
      lastOrderDate: '2025-01-14',
      notes: '餐廳老闆，固定月訂',
      status: 'active'
    },
    {
      id: 'CUS-003',
      name: '張大偉',
      phone: '0934-567-890',
      email: 'zhang@example.com',
      address: '桃園市中壢區中正路100號',
      type: 'regular',
      avatar: '👨',
      joinDate: '2023-06-10',
      totalOrders: 12,
      totalSpent: 18500,
      lastOrderDate: '2025-01-10',
      status: 'active'
    },
    {
      id: 'CUS-004',
      name: '陳雅芳',
      phone: '0945-678-901',
      email: 'chen@example.com',
      address: '台中市西屯區台灣大道三段99號',
      type: 'vip',
      avatar: '👩',
      joinDate: '2023-02-28',
      totalOrders: 35,
      totalSpent: 52300,
      lastOrderDate: '2025-01-12',
      notes: '家庭用戶，服務要求較高',
      status: 'active'
    },
    {
      id: 'CUS-005',
      name: '林志強',
      phone: '0956-789-012',
      address: '高雄市前鎮區成功二路25號',
      type: 'regular',
      avatar: '👨‍🔧',
      joinDate: '2023-08-15',
      totalOrders: 8,
      totalSpent: 12200,
      lastOrderDate: '2024-12-20',
      status: 'inactive'
    },
    {
      id: 'CUS-006',
      name: '蘇美玲',
      phone: '0967-890-123',
      email: 'su@example.com',
      address: '台南市東區東門路二段158號',
      type: 'business',
      avatar: '👩‍🍳',
      joinDate: '2023-05-12',
      totalOrders: 52,
      totalSpent: 89400,
      lastOrderDate: '2025-01-13',
      notes: '小吃店老闆，用量穩定',
      status: 'active'
    }
  ]);

  const [filteredCustomers, setFilteredCustomers] = useState<Customer[]>(customers);
  const [searchTerm, setSearchTerm] = useState('');
  const [typeFilter, setTypeFilter] = useState('all');
  const [showModal, setShowModal] = useState(false);
  const [editingCustomer, setEditingCustomer] = useState<Customer | null>(null);
  const [newCustomer, setNewCustomer] = useState<Partial<Customer>>({
    name: '',
    phone: '',
    email: '',
    address: '',
    type: 'regular',
    avatar: '👤',
    notes: '',
    status: 'active'
  });

  // 过滤客户
  useEffect(() => {
    let filtered = customers;

    // 按类型过滤
    if (typeFilter !== 'all') {
      filtered = filtered.filter(customer => customer.type === typeFilter);
    }

    // 按搜索词过滤
    if (searchTerm) {
      filtered = filtered.filter(customer =>
        customer.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
        customer.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        customer.phone.includes(searchTerm)
      );
    }

    setFilteredCustomers(filtered);
  }, [customers, searchTerm, typeFilter]);

  const getTypeText = (type: string) => {
    switch (type) {
      case 'vip': return 'VIP客戶';
      case 'business': return '企業客戶';
      case 'regular': return '一般客戶';
      default: return type;
    }
  };

  const getTypeClass = (type: string) => {
    return `customer-type type-${type}`;
  };

  const handleAddCustomer = () => {
    setEditingCustomer(null);
    setNewCustomer({
      name: '',
      phone: '',
      email: '',
      address: '',
      type: 'regular',
      avatar: '👤',
      notes: '',
      status: 'active'
    });
    setShowModal(true);
  };

  const handleEditCustomer = (customer: Customer) => {
    setEditingCustomer(customer);
    setNewCustomer({ ...customer });
    setShowModal(true);
  };

  const handleDeleteCustomer = (customerId: string) => {
    if (confirm('確定要刪除此客戶嗎？此操作無法復原！')) {
      setCustomers(customers.filter(c => c.id !== customerId));
    }
  };

  const handleSaveCustomer = () => {
    if (!newCustomer.name || !newCustomer.phone || !newCustomer.address) {
      alert('請填寫所有必填欄位');
      return;
    }

    if (editingCustomer) {
      // 編輯現有客戶
      setCustomers(customers.map(c =>
        c.id === editingCustomer.id
          ? { ...newCustomer as Customer, id: editingCustomer.id }
          : c
      ));
    } else {
      // 新增客戶
      const id = `CUS-${String(customers.length + 1).padStart(3, '0')}`;
      const joinDate = new Date().toISOString().split('T')[0];

      setCustomers([...customers, {
        ...newCustomer as Customer,
        id,
        joinDate,
        totalOrders: 0,
        totalSpent: 0
      }]);
    }

    setShowModal(false);
    setEditingCustomer(null);
  };

  const handleContactCustomer = (customer: Customer) => {
    // 這裡可以集成實際的通訊功能
    if (customer.phone) {
      window.open(`tel:${customer.phone}`);
    }
  };

  // 统计数据
  const totalCustomers = customers.length;
  const activeCustomers = customers.filter(c => c.status === 'active').length;
  const vipCustomers = customers.filter(c => c.type === 'vip').length;
  const businessCustomers = customers.filter(c => c.type === 'business').length;
  const regularCustomers = customers.filter(c => c.type === 'regular').length;
  const totalRevenue = customers.reduce((sum, c) => sum + c.totalSpent, 0);
  const avgOrderValue = totalRevenue / customers.reduce((sum, c) => sum + c.totalOrders, 0) || 0;

  return (
    <div className="customer-management">
      <div className="customer-header">
        <div>
          <h1>👥 客戶管理</h1>
          <p className="subtitle">4D科技感客戶關係管理系統 - 建立長久的客戶關係</p>
        </div>
        <div className="customer-controls">
          <input
            type="text"
            className="search-input"
            placeholder="🔍 搜索客戶編號、姓名或電話..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
          <button className="add-customer-btn" onClick={handleAddCustomer}>
            ➕ 新增客戶
          </button>
        </div>
      </div>

      <div className="customers-container">
        {/* 统计面板 */}
        <div className="stats-panel">
          <div className="stat-panel-item">
            <div className="stat-panel-number">{totalCustomers}</div>
            <div className="stat-panel-label">總客戶數</div>
          </div>
          <div className="stat-panel-item">
            <div className="stat-panel-number">{activeCustomers}</div>
            <div className="stat-panel-label">活躍客戶</div>
          </div>
          <div className="stat-panel-item">
            <div className="stat-panel-number">{vipCustomers}</div>
            <div className="stat-panel-label">VIP客戶</div>
          </div>
          <div className="stat-panel-item">
            <div className="stat-panel-number">{businessCustomers}</div>
            <div className="stat-panel-label">企業客戶</div>
          </div>
          <div className="stat-panel-item">
            <div className="stat-panel-number">NT$ {totalRevenue.toLocaleString()}</div>
            <div className="stat-panel-label">總消費額</div>
          </div>
          <div className="stat-panel-item">
            <div className="stat-panel-number">NT$ {Math.round(avgOrderValue).toLocaleString()}</div>
            <div className="stat-panel-label">平均訂單金額</div>
          </div>
        </div>

        {/* 类型过滤器 */}
        <div className="type-filters">
          <button
            className={`filter-btn ${typeFilter === 'all' ? 'active' : ''}`}
            onClick={() => setTypeFilter('all')}
          >
            全部客戶
          </button>
          <button
            className={`filter-btn ${typeFilter === 'vip' ? 'active' : ''}`}
            onClick={() => setTypeFilter('vip')}
          >
            VIP客戶
          </button>
          <button
            className={`filter-btn ${typeFilter === 'business' ? 'active' : ''}`}
            onClick={() => setTypeFilter('business')}
          >
            企業客戶
          </button>
          <button
            className={`filter-btn ${typeFilter === 'regular' ? 'active' : ''}`}
            onClick={() => setTypeFilter('regular')}
          >
            一般客戶
          </button>
        </div>

        {/* 客户网格 */}
        <div className="customers-grid">
          {filteredCustomers.map((customer) => (
            <div key={customer.id} className="customer-card">
              <div className="customer-avatar">
                {customer.avatar}
              </div>

              <div className="customer-name">
                {customer.name}
              </div>

              <div className={getTypeClass(customer.type)}>
                {getTypeText(customer.type)}
              </div>

              <div className="customer-info">
                <div className="info-row">
                  <span className="info-icon">🆔</span>
                  <span>{customer.id}</span>
                </div>
                <div className="info-row">
                  <span className="info-icon">📞</span>
                  <span>{customer.phone}</span>
                </div>
                {customer.email && (
                  <div className="info-row">
                    <span className="info-icon">📧</span>
                    <span>{customer.email}</span>
                  </div>
                )}
                <div className="info-row">
                  <span className="info-icon">📍</span>
                  <span>{customer.address}</span>
                </div>
                <div className="info-row">
                  <span className="info-icon">📅</span>
                  <span>加入日期: {customer.joinDate}</span>
                </div>
                {customer.lastOrderDate && (
                  <div className="info-row">
                    <span className="info-icon">🛒</span>
                    <span>最後訂購: {customer.lastOrderDate}</span>
                  </div>
                )}
                <div className="info-row">
                  <span className="info-icon">🔄</span>
                  <span className={`status-${customer.status}`}>
                    {customer.status === 'active' ? '活躍' : '非活躍'}
                  </span>
                </div>
              </div>

              <div className="customer-stats">
                <div className="stat-item">
                  <div className="stat-number">{customer.totalOrders}</div>
                  <div className="stat-label">總訂單</div>
                </div>
                <div className="stat-item">
                  <div className="stat-number">NT$ {customer.totalSpent.toLocaleString()}</div>
                  <div className="stat-label">總消費</div>
                </div>
                <div className="stat-item">
                  <div className="stat-number">
                    NT$ {customer.totalOrders > 0 ? Math.round(customer.totalSpent / customer.totalOrders).toLocaleString() : '0'}
                  </div>
                  <div className="stat-label">平均訂單</div>
                </div>
              </div>

              {customer.notes && (
                <div className="info-row" style={{ marginTop: '16px', fontStyle: 'italic' }}>
                  <span className="info-icon">📝</span>
                  <span>{customer.notes}</span>
                </div>
              )}

              <div className="customer-actions">
                <button
                  className="action-btn edit-btn"
                  onClick={() => handleEditCustomer(customer)}
                >
                  編輯
                </button>
                <button
                  className="action-btn contact-btn"
                  onClick={() => handleContactCustomer(customer)}
                >
                  聯絡
                </button>
                <button
                  className="action-btn delete-btn"
                  onClick={() => handleDeleteCustomer(customer.id)}
                >
                  刪除
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* 添加/编辑客户模态框 */}
      {showModal && (
        <div className="modal">
          <div className="modal-content">
            <h2>{editingCustomer ? '編輯客戶' : '新增客戶'}</h2>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">客戶姓名 *</label>
                <input
                  type="text"
                  className="form-input"
                  value={newCustomer.name || ''}
                  onChange={(e) => setNewCustomer({ ...newCustomer, name: e.target.value })}
                  placeholder="請輸入客戶姓名"
                />
              </div>
              <div className="form-group">
                <label className="form-label">聯絡電話 *</label>
                <input
                  type="tel"
                  className="form-input"
                  value={newCustomer.phone || ''}
                  onChange={(e) => setNewCustomer({ ...newCustomer, phone: e.target.value })}
                  placeholder="請輸入聯絡電話"
                />
              </div>
            </div>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">電子郵件</label>
                <input
                  type="email"
                  className="form-input"
                  value={newCustomer.email || ''}
                  onChange={(e) => setNewCustomer({ ...newCustomer, email: e.target.value })}
                  placeholder="請輸入電子郵件"
                />
              </div>
              <div className="form-group">
                <label className="form-label">客戶類型</label>
                <select
                  className="form-select"
                  value={newCustomer.type || 'regular'}
                  onChange={(e) => setNewCustomer({ ...newCustomer, type: e.target.value as Customer['type'] })}
                >
                  <option value="regular">一般客戶</option>
                  <option value="vip">VIP客戶</option>
                  <option value="business">企業客戶</option>
                </select>
              </div>
            </div>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">頭像表情</label>
                <select
                  className="form-select"
                  value={newCustomer.avatar || '👤'}
                  onChange={(e) => setNewCustomer({ ...newCustomer, avatar: e.target.value })}
                >
                  <option value="👤">👤 默認</option>
                  <option value="👨">👨 男性</option>
                  <option value="👩">👩 女性</option>
                  <option value="👨‍💼">👨‍💼 商務男</option>
                  <option value="👩‍💼">👩‍💼 商務女</option>
                  <option value="👨‍🔧">👨‍🔧 技術男</option>
                  <option value="👩‍🍳">👩‍🍳 廚師女</option>
                  <option value="🏢">🏢 企業</option>
                </select>
              </div>
              <div className="form-group">
                <label className="form-label">狀態</label>
                <select
                  className="form-select"
                  value={newCustomer.status || 'active'}
                  onChange={(e) => setNewCustomer({ ...newCustomer, status: e.target.value as Customer['status'] })}
                >
                  <option value="active">活躍</option>
                  <option value="inactive">非活躍</option>
                </select>
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">地址 *</label>
              <input
                type="text"
                className="form-input"
                value={newCustomer.address || ''}
                onChange={(e) => setNewCustomer({ ...newCustomer, address: e.target.value })}
                placeholder="請輸入詳細地址"
              />
            </div>

            <div className="form-group">
              <label className="form-label">備註</label>
              <textarea
                className="form-input form-textarea"
                value={newCustomer.notes || ''}
                onChange={(e) => setNewCustomer({ ...newCustomer, notes: e.target.value })}
                placeholder="請輸入客戶備註..."
              />
            </div>

            <div className="modal-actions">
              <button
                className="btn-cancel"
                onClick={() => setShowModal(false)}
              >
                取消
              </button>
              <button
                className="btn-save"
                onClick={handleSaveCustomer}
              >
                {editingCustomer ? '更新客戶' : '新增客戶'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default CustomerManagement4D;
