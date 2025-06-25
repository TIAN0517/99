import React, { useState, useEffect } from 'react';
import './OrderManagement-4d.css';

interface OrderItem {
  id: string;
  name: string;
  quantity: number;
  price: number;
  icon: string;
}

interface Order {
  id: string;
  customer: string;
  date: string;
  status: 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled';
  items: OrderItem[];
  total: number;
  phone?: string;
  address?: string;
  notes?: string;
}

const OrderManagement4D: React.FC = () => {
  const [orders, setOrders] = useState<Order[]>([
    {
      id: 'ORD-2025-001',
      customer: '王小明',
      date: '2025-01-16',
      status: 'processing',
      phone: '0912-345-678',
      address: '台北市信義區信義路五段7號',
      items: [
        { id: '1', name: '20kg瓦斯桶', quantity: 2, price: 650, icon: '🛢️' },
        { id: '2', name: '5kg瓦斯桶', quantity: 1, price: 200, icon: '⚡' }
      ],
      total: 1500,
      notes: '請在下午配送'
    },
    {
      id: 'ORD-2025-002',
      customer: '李美華',
      date: '2025-01-15',
      status: 'shipped',
      phone: '0923-456-789',
      address: '新北市板橋區中山路一段161號',
      items: [
        { id: '3', name: '15kg瓦斯桶', quantity: 3, price: 450, icon: '🔥' }
      ],
      total: 1350,
      notes: '請先電話聯絡'
    },
    {
      id: 'ORD-2025-003',
      customer: '張大偉',
      date: '2025-01-14',
      status: 'delivered',
      phone: '0934-567-890',
      address: '桃園市中壢區中正路100號',
      items: [
        { id: '4', name: '50kg瓦斯桶', quantity: 1, price: 1200, icon: '🏭' },
        { id: '5', name: '安全檢測器', quantity: 2, price: 450, icon: '🔔' }
      ],
      total: 2100
    },
    {
      id: 'ORD-2025-004',
      customer: '陳雅芳',
      date: '2025-01-13',
      status: 'pending',
      phone: '0945-678-901',
      address: '台中市西屯區台灣大道三段99號',
      items: [
        { id: '6', name: '30kg瓦斯桶', quantity: 2, price: 850, icon: '⚡' }
      ],
      total: 1700,
      notes: '急件配送'
    },
    {
      id: 'ORD-2025-005',
      customer: '林志強',
      date: '2025-01-12',
      status: 'cancelled',
      phone: '0956-789-012',
      address: '高雄市前鎮區成功二路25號',
      items: [
        { id: '7', name: '瓦斯爐具', quantity: 1, price: 2500, icon: '🔥' }
      ],
      total: 2500,
      notes: '客戶取消訂單'
    }
  ]);

  const [filteredOrders, setFilteredOrders] = useState<Order[]>(orders);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [showModal, setShowModal] = useState(false);
  const [editingOrder, setEditingOrder] = useState<Order | null>(null);
  const [newOrder, setNewOrder] = useState<Partial<Order>>({
    customer: '',
    phone: '',
    address: '',
    status: 'pending',
    items: [],
    notes: ''
  });

  // 过滤订单
  useEffect(() => {
    let filtered = orders;

    // 按状态过滤
    if (statusFilter !== 'all') {
      filtered = filtered.filter(order => order.status === statusFilter);
    }

    // 按搜索词过滤
    if (searchTerm) {
      filtered = filtered.filter(order =>
        order.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
        order.customer.toLowerCase().includes(searchTerm.toLowerCase())
      );
    }

    setFilteredOrders(filtered);
  }, [orders, searchTerm, statusFilter]);

  const getStatusText = (status: string) => {
    switch (status) {
      case 'pending': return '待處理';
      case 'processing': return '處理中';
      case 'shipped': return '已出貨';
      case 'delivered': return '已配送';
      case 'cancelled': return '已取消';
      default: return status;
    }
  };

  const getStatusClass = (status: string) => {
    return `order-status status-${status}`;
  };

  const handleAddOrder = () => {
    setEditingOrder(null);
    setNewOrder({
      customer: '',
      phone: '',
      address: '',
      status: 'pending',
      items: [],
      notes: ''
    });
    setShowModal(true);
  };

  const handleEditOrder = (order: Order) => {
    setEditingOrder(order);
    setNewOrder({ ...order });
    setShowModal(true);
  };

  const handleDeleteOrder = (orderId: string) => {
    if (confirm('確定要刪除此訂單嗎？')) {
      setOrders(orders.filter(o => o.id !== orderId));
    }
  };

  const handleSaveOrder = () => {
    if (!newOrder.customer || !newOrder.phone || !newOrder.address) {
      alert('請填寫所有必填欄位');
      return;
    }

    if (editingOrder) {
      // 編輯現有訂單
      setOrders(orders.map(o =>
        o.id === editingOrder.id
          ? { ...newOrder as Order, id: editingOrder.id }
          : o
      ));
    } else {
      // 新增訂單
      const id = `ORD-2025-${String(orders.length + 1).padStart(3, '0')}`;
      const date = new Date().toISOString().split('T')[0];
      const total = (newOrder.items || []).reduce((sum, item) => sum + (item.price * item.quantity), 0);

      setOrders([...orders, {
        ...newOrder as Order,
        id,
        date,
        total,
        items: newOrder.items || []
      }]);
    }

    setShowModal(false);
    setEditingOrder(null);
  };

  const handleStatusChange = (orderId: string, newStatus: string) => {
    setOrders(orders.map(order =>
      order.id === orderId
        ? { ...order, status: newStatus as Order['status'] }
        : order
    ));
  };

  // 统计数据
  const totalOrders = orders.length;
  const pendingOrders = orders.filter(o => o.status === 'pending').length;
  const processingOrders = orders.filter(o => o.status === 'processing').length;
  const shippedOrders = orders.filter(o => o.status === 'shipped').length;
  const deliveredOrders = orders.filter(o => o.status === 'delivered').length;
  const cancelledOrders = orders.filter(o => o.status === 'cancelled').length;
  const totalRevenue = orders
    .filter(o => o.status === 'delivered')
    .reduce((sum, o) => sum + o.total, 0);

  return (
    <div className="order-management">
      <div className="order-header">
        <div>
          <h1>📋 訂單管理</h1>
          <p className="subtitle">4D科技感訂單管理系統 - 智能追蹤每一筆訂單</p>
        </div>
        <div className="order-controls">
          <input
            type="text"
            className="search-input"
            placeholder="🔍 搜索訂單編號或客戶名稱..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
          <button className="add-order-btn" onClick={handleAddOrder}>
            ➕ 新增訂單
          </button>
        </div>
      </div>

      <div className="orders-container">
        {/* 统计面板 */}
        <div className="stats-panel">
          <div className="stat-item">
            <div className="stat-number">{totalOrders}</div>
            <div className="stat-label">總訂單數</div>
          </div>
          <div className="stat-item">
            <div className="stat-number">{pendingOrders}</div>
            <div className="stat-label">待處理</div>
          </div>
          <div className="stat-item">
            <div className="stat-number">{processingOrders}</div>
            <div className="stat-label">處理中</div>
          </div>
          <div className="stat-item">
            <div className="stat-number">{deliveredOrders}</div>
            <div className="stat-label">已配送</div>
          </div>
          <div className="stat-item">
            <div className="stat-number">NT$ {totalRevenue.toLocaleString()}</div>
            <div className="stat-label">總營收</div>
          </div>
        </div>

        {/* 状态过滤器 */}
        <div className="status-filters">
          <button
            className={`filter-btn ${statusFilter === 'all' ? 'active' : ''}`}
            onClick={() => setStatusFilter('all')}
          >
            全部
          </button>
          <button
            className={`filter-btn ${statusFilter === 'pending' ? 'active' : ''}`}
            onClick={() => setStatusFilter('pending')}
          >
            待處理
          </button>
          <button
            className={`filter-btn ${statusFilter === 'processing' ? 'active' : ''}`}
            onClick={() => setStatusFilter('processing')}
          >
            處理中
          </button>
          <button
            className={`filter-btn ${statusFilter === 'shipped' ? 'active' : ''}`}
            onClick={() => setStatusFilter('shipped')}
          >
            已出貨
          </button>
          <button
            className={`filter-btn ${statusFilter === 'delivered' ? 'active' : ''}`}
            onClick={() => setStatusFilter('delivered')}
          >
            已配送
          </button>
          <button
            className={`filter-btn ${statusFilter === 'cancelled' ? 'active' : ''}`}
            onClick={() => setStatusFilter('cancelled')}
          >
            已取消
          </button>
        </div>

        {/* 订单网格 */}
        <div className="orders-grid">
          {filteredOrders.map((order) => (
            <div key={order.id} className="order-card">
              <div className="order-id">
                📋 {order.id}
              </div>

              <div className="order-customer">
                👤 {order.customer}
              </div>

              <div className="order-date">
                📅 {order.date}
              </div>

              {order.phone && (
                <div className="order-date">
                  📞 {order.phone}
                </div>
              )}

              {order.address && (
                <div className="order-date">
                  📍 {order.address}
                </div>
              )}

              <div className={getStatusClass(order.status)}>
                {getStatusText(order.status)}
              </div>

              <div className="order-items">
                <h4>訂單商品</h4>
                <div className="item-list">
                  {order.items.map((item) => (
                    <div key={item.id} className="item-row">
                      <span className="item-name">
                        {item.icon} {item.name}
                      </span>
                      <span className="item-quantity">
                        ×{item.quantity}
                      </span>
                      <span className="item-price">
                        NT$ {(item.price * item.quantity).toLocaleString()}
                      </span>
                    </div>
                  ))}
                </div>
              </div>

              <div className="order-total">
                <span className="total-label">總金額</span>
                <span className="total-amount">NT$ {order.total.toLocaleString()}</span>
              </div>

              {order.notes && (
                <div className="order-date">
                  📝 {order.notes}
                </div>
              )}

              <div className="order-actions">
                <button
                  className="action-btn edit-btn"
                  onClick={() => handleEditOrder(order)}
                >
                  編輯
                </button>
                <select
                  className="action-btn view-btn"
                  value={order.status}
                  onChange={(e) => handleStatusChange(order.id, e.target.value)}
                  style={{
                    padding: '12px 8px',
                    fontSize: '0.85rem',
                    background: 'rgba(138, 43, 226, 0.2)',
                    border: '1px solid rgba(138, 43, 226, 0.3)',
                    borderRadius: 'var(--border-radius-md)'
                  }}
                >
                  <option value="pending">待處理</option>
                  <option value="processing">處理中</option>
                  <option value="shipped">已出貨</option>
                  <option value="delivered">已配送</option>
                  <option value="cancelled">已取消</option>
                </select>
                <button
                  className="action-btn delete-btn"
                  onClick={() => handleDeleteOrder(order.id)}
                >
                  刪除
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* 添加/编辑订单模态框 */}
      {showModal && (
        <div className="modal">
          <div className="modal-content">
            <h2>{editingOrder ? '編輯訂單' : '新增訂單'}</h2>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">客戶姓名 *</label>
                <input
                  type="text"
                  className="form-input"
                  value={newOrder.customer || ''}
                  onChange={(e) => setNewOrder({ ...newOrder, customer: e.target.value })}
                  placeholder="請輸入客戶姓名"
                />
              </div>
              <div className="form-group">
                <label className="form-label">聯絡電話 *</label>
                <input
                  type="tel"
                  className="form-input"
                  value={newOrder.phone || ''}
                  onChange={(e) => setNewOrder({ ...newOrder, phone: e.target.value })}
                  placeholder="請輸入聯絡電話"
                />
              </div>
            </div>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">配送地址 *</label>
                <input
                  type="text"
                  className="form-input"
                  value={newOrder.address || ''}
                  onChange={(e) => setNewOrder({ ...newOrder, address: e.target.value })}
                  placeholder="請輸入配送地址"
                />
              </div>
              <div className="form-group">
                <label className="form-label">訂單狀態</label>
                <select
                  className="form-select"
                  value={newOrder.status || 'pending'}
                  onChange={(e) => setNewOrder({ ...newOrder, status: e.target.value as Order['status'] })}
                >
                  <option value="pending">待處理</option>
                  <option value="processing">處理中</option>
                  <option value="shipped">已出貨</option>
                  <option value="delivered">已配送</option>
                  <option value="cancelled">已取消</option>
                </select>
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">備註</label>
              <textarea
                className="form-input form-textarea"
                value={newOrder.notes || ''}
                onChange={(e) => setNewOrder({ ...newOrder, notes: e.target.value })}
                placeholder="請輸入訂單備註..."
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
                onClick={handleSaveOrder}
              >
                {editingOrder ? '更新訂單' : '新增訂單'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default OrderManagement4D;
