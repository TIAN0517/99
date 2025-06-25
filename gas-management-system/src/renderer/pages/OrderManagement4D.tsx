import React, { useState } from 'react';
import './OrderManagement4D.css';

interface Order {
  id: string;
  customerName: string;
  customerPhone: string;
  products: {
    name: string;
    size: string;
    quantity: number;
    price: number;
  }[];
  totalAmount: number;
  status: 'pending' | 'processing' | 'completed' | 'cancelled';
  deliveryAddress: string;
  orderDate: Date;
  deliveryDate?: Date;
}

export const OrderManagement4D: React.FC = () => {
  const [orders, setOrders] = useState<Order[]>([
    {
      id: 'ORD-001',
      customerName: '張先生',
      customerPhone: '0912-345-678',
      products: [
        { name: '液化石油氣', size: '20kg', quantity: 2, price: 680 },
        { name: '液化石油氣', size: '5kg', quantity: 1, price: 280 }
      ],
      totalAmount: 1640,
      status: 'pending',
      deliveryAddress: '台北市信義區信義路五段7號',
      orderDate: new Date(2024, 11, 22, 9, 30),
    },
    {
      id: 'ORD-002',
      customerName: '李小姐',
      customerPhone: '0987-654-321',
      products: [
        { name: '液化石油氣', size: '15kg', quantity: 3, price: 680 }
      ],
      totalAmount: 2040,
      status: 'processing',
      deliveryAddress: '新北市板橋區中山路二段168號',
      orderDate: new Date(2024, 11, 22, 11, 15),
    },
    {
      id: 'ORD-003',
      customerName: '王老闆',
      customerPhone: '0955-123-456',
      products: [
        { name: '工業用瓦斯', size: '50kg', quantity: 1, price: 1850 }
      ],
      totalAmount: 1850,
      status: 'completed',
      deliveryAddress: '桃園市龜山區復興路88號',
      orderDate: new Date(2024, 11, 21, 14, 20),
      deliveryDate: new Date(2024, 11, 22, 10, 30),
    },
  ]);

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'pending': return '#ffc107';
      case 'processing': return '#00d4ff';
      case 'completed': return '#00ff7f';
      case 'cancelled': return '#ff4757';
      default: return '#78dbff';
    }
  };

  const getStatusLabel = (status: string) => {
    switch (status) {
      case 'pending': return '待處理';
      case 'processing': return '處理中';
      case 'completed': return '已完成';
      case 'cancelled': return '已取消';
      default: return '未知';
    }
  };

  const totalOrders = orders.length;
  const pendingOrders = orders.filter(o => o.status === 'pending').length;
  const processingOrders = orders.filter(o => o.status === 'processing').length;
  const completedOrders = orders.filter(o => o.status === 'completed').length;
  const totalRevenue = orders
    .filter(o => o.status === 'completed')
    .reduce((sum, o) => sum + o.totalAmount, 0);

  return (
    <div className="order-management-4d">
      {/* 4D 標題區 */}
      <div className="header-4d">
        <div className="header-content-4d">
          <h1 className="title-4d">
            <span className="hologram-text">訂單管理系統</span>
            <div className="scan-line"></div>
          </h1>
          <p className="subtitle-4d">智能訂單追蹤 • 即時狀態更新 • 自動化配送</p>
        </div>
        <button className="btn-4d btn-add">
          <div className="btn-glow"></div>
          <span className="btn-text">
            <i className="icon-plus">+</i>
            新增訂單
          </span>
        </button>
      </div>

      {/* 4D 統計面板 */}
      <div className="stats-panel-4d">
        <div className="stat-card-4d">
          <div className="stat-icon pulse-cyan">📋</div>
          <div className="stat-content">
            <div className="stat-value">{totalOrders}</div>
            <div className="stat-label">總訂單數</div>
          </div>
          <div className="energy-bar">
            <div className="energy-fill" style={{ width: '100%' }}></div>
          </div>
        </div>

        <div className="stat-card-4d">
          <div className="stat-icon pulse-yellow">⏳</div>
          <div className="stat-content">
            <div className="stat-value warning">{pendingOrders}</div>
            <div className="stat-label">待處理</div>
          </div>
          <div className="energy-bar">
            <div className="energy-fill warning" style={{ width: `${(pendingOrders / totalOrders) * 100}%` }}></div>
          </div>
        </div>

        <div className="stat-card-4d">
          <div className="stat-icon pulse-cyan">⚡</div>
          <div className="stat-content">
            <div className="stat-value">{processingOrders}</div>
            <div className="stat-label">處理中</div>
          </div>
          <div className="energy-bar">
            <div className="energy-fill" style={{ width: `${(processingOrders / totalOrders) * 100}%` }}></div>
          </div>
        </div>

        <div className="stat-card-4d">
          <div className="stat-icon pulse-green">✅</div>
          <div className="stat-content">
            <div className="stat-value">{completedOrders}</div>
            <div className="stat-label">已完成</div>
          </div>
          <div className="energy-bar">
            <div className="energy-fill" style={{ width: `${(completedOrders / totalOrders) * 100}%` }}></div>
          </div>
        </div>

        <div className="stat-card-4d">
          <div className="stat-icon pulse-magenta">💰</div>
          <div className="stat-content">
            <div className="stat-value">NT$ {totalRevenue.toLocaleString()}</div>
            <div className="stat-label">完成營收</div>
          </div>
          <div className="energy-bar">
            <div className="energy-fill" style={{ width: '75%' }}></div>
          </div>
        </div>
      </div>

      {/* 4D 訂單列表 */}
      <div className="orders-container-4d">
        {orders.map((order, index) => (
          <div
            key={order.id}
            className="order-card-4d"
            style={{ '--delay': `${index * 0.1}s` } as React.CSSProperties}
          >
            <div className="card-hologram"></div>
            <div className="card-border"></div>

            {/* 訂單標題 */}
            <div className="order-header-4d">
              <div className="order-id">
                <span className="id-label">訂單編號</span>
                <span className="id-value">{order.id}</span>
              </div>
              <div
                className="status-badge"
                style={{ '--status-color': getStatusColor(order.status) } as React.CSSProperties}
              >
                <div className="status-dot"></div>
                <span>{getStatusLabel(order.status)}</span>
              </div>
            </div>

            {/* 客戶信息 */}
            <div className="customer-info-4d">
              <div className="customer-detail">
                <span className="customer-name">{order.customerName}</span>
                <span className="customer-phone">{order.customerPhone}</span>
              </div>
              <div className="order-time">
                下單時間: {order.orderDate.toLocaleString('zh-TW')}
              </div>
            </div>

            {/* 產品列表 */}
            <div className="products-list-4d">
              <h4 className="products-title">訂購產品</h4>
              {order.products.map((product, idx) => (
                <div key={idx} className="product-item-4d">
                  <div className="product-info">
                    <span className="product-name">{product.name}</span>
                    <span className="product-spec">{product.size}</span>
                  </div>
                  <div className="product-quantity">x{product.quantity}</div>
                  <div className="product-price">NT$ {(product.price * product.quantity).toLocaleString()}</div>
                </div>
              ))}
            </div>

            {/* 配送地址 */}
            <div className="delivery-info-4d">
              <span className="delivery-label">配送地址:</span>
              <span className="delivery-address">{order.deliveryAddress}</span>
            </div>

            {/* 總金額 */}
            <div className="order-total-4d">
              <span className="total-label">訂單總額</span>
              <span className="total-amount">NT$ {order.totalAmount.toLocaleString()}</span>
            </div>

            {/* 操作按鈕 */}
            <div className="order-actions-4d">
              {order.status === 'pending' && (
                <>
                  <button className="action-btn process">
                    <div className="btn-hologram"></div>
                    <span>處理訂單</span>
                  </button>
                  <button className="action-btn cancel">
                    <div className="btn-hologram"></div>
                    <span>取消訂單</span>
                  </button>
                </>
              )}
              {order.status === 'processing' && (
                <button className="action-btn complete">
                  <div className="btn-hologram"></div>
                  <span>標記完成</span>
                </button>
              )}
              <button className="action-btn view">
                <div className="btn-hologram"></div>
                <span>查看詳情</span>
              </button>
            </div>

            {/* 交付時間 */}
            {order.deliveryDate && (
              <div className="delivery-time">
                交付時間: {order.deliveryDate.toLocaleString('zh-TW')}
              </div>
            )}
          </div>
        ))}
      </div>

      {/* 4D 掃描線效果 */}
      <div className="scanner-overlay">
        <div className="scan-line-horizontal"></div>
        <div className="scan-line-vertical"></div>
      </div>        </div>
  );
};

export default OrderManagement4D;
