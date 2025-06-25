import React, { useState } from 'react';
import './OrderManagement.css';

interface Order {
    id: string;
    customerName: string;
    customerPhone: string;
    products: OrderProduct[];
    totalAmount: number;
    status: 'pending' | 'processing' | 'shipping' | 'delivered' | 'cancelled';
    orderDate: Date;
    deliveryDate?: Date;
    deliveryAddress: string;
    notes?: string;
}

interface OrderProduct {
    productId: string;
    productName: string;
    quantity: number;
    unitPrice: number;
    subtotal: number;
}

export const OrderManagement: React.FC = () => {
    const [orders, setOrders] = useState<Order[]>([
        {
            id: 'ORD-2024-001',
            customerName: '王大明',
            customerPhone: '0912-345-678',
            products: [
                { productId: '1', productName: '20kg液化瓦斯', quantity: 2, unitPrice: 1800, subtotal: 3600 },
                { productId: '2', productName: '5kg液化瓦斯', quantity: 1, unitPrice: 520, subtotal: 520 }
            ],
            totalAmount: 4120,
            status: 'processing',
            orderDate: new Date('2024-12-15T10:30:00'),
            deliveryAddress: '台北市中山區民生東路123號',
            notes: '請在上午配送'
        },
        {
            id: 'ORD-2024-002',
            customerName: '李小華',
            customerPhone: '0987-654-321',
            products: [
                { productId: '3', productName: '15kg液化瓦斯', quantity: 1, unitPrice: 1420, subtotal: 1420 }],
            totalAmount: 1420,
            status: 'shipping',
            orderDate: new Date('2024-12-14T14:20:00'),
            deliveryDate: new Date('2024-12-15T16:00:00'),
            deliveryAddress: '新北市板橋區文化路456號'
        },
        {
            id: 'ORD-2024-003',
            customerName: '陳氏餐廳',
            customerPhone: '02-2345-6789',
            products: [
                { productId: '1', productName: '20kg液化瓦斯', quantity: 5, unitPrice: 1800, subtotal: 9000 },
                { productId: '3', productName: '15kg液化瓦斯', quantity: 2, unitPrice: 1420, subtotal: 2840 }
            ],
            totalAmount: 11840,
            status: 'delivered',
            orderDate: new Date('2024-12-10T09:15:00'),
            deliveryDate: new Date('2024-12-11T11:30:00'),
            deliveryAddress: '台北市大安區忠孝東路789號'
        },
        {
            id: 'ORD-2024-004',
            customerName: '張先生',
            customerPhone: '0911-111-222',
            products: [
                { productId: '2', productName: '5kg液化瓦斯', quantity: 3, unitPrice: 520, subtotal: 1560 }
            ],
            totalAmount: 1560,
            status: 'pending',
            orderDate: new Date('2024-12-16T08:45:00'),
            deliveryAddress: '桃園市中壢區中央路321號'
        }
    ]);

    const [selectedStatus, setSelectedStatus] = useState<string>('all');
    const [searchTerm, setSearchTerm] = useState('');

    const getStatusLabel = (status: Order['status']) => {
        const statusMap = {
            pending: '待處理',
            processing: '處理中',
            shipping: '配送中',
            delivered: '已送達',
            cancelled: '已取消'
        };
        return statusMap[status];
    };

    const getStatusColor = (status: Order['status']) => {
        const colorMap = {
            pending: 'warning',
            processing: 'info',
            shipping: 'primary',
            delivered: 'success',
            cancelled: 'danger'
        };
        return colorMap[status];
    };

    const filteredOrders = orders.filter(order => {
        const matchesStatus = selectedStatus === 'all' || order.status === selectedStatus;
        const matchesSearch = order.customerName.toLowerCase().includes(searchTerm.toLowerCase()) ||
            order.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
            order.customerPhone.includes(searchTerm);
        return matchesStatus && matchesSearch;
    });

    const updateOrderStatus = (orderId: string, newStatus: Order['status']) => {
        setOrders(prevOrders =>
            prevOrders.map(order =>
                order.id === orderId
                    ? { ...order, status: newStatus, ...(newStatus === 'delivered' && !order.deliveryDate ? { deliveryDate: new Date() } : {}) }
                    : order
            )
        );
    };

    const getTotalStats = () => {
        const total = orders.length;
        const pending = orders.filter(o => o.status === 'pending').length;
        const processing = orders.filter(o => o.status === 'processing').length;
        const delivered = orders.filter(o => o.status === 'delivered').length;
        const totalRevenue = orders
            .filter(o => o.status === 'delivered')
            .reduce((sum, order) => sum + order.totalAmount, 0);

        return { total, pending, processing, delivered, totalRevenue };
    };

    const stats = getTotalStats();

    return (
        <div className="order-management">
            <div className="page-header">
                <div className="header-content">
                    <h1>訂單管理</h1>
                    <p>處理客戶訂單與配送管理</p>
                </div>
                <button className="btn btn-primary">
                    <span>+</span>
                    新增訂單
                </button>
            </div>

            {/* 訂單統計 */}
            <div className="order-stats">
                <div className="stat-card">
                    <div className="stat-icon">📋</div>
                    <div className="stat-content">
                        <h3>總訂單數</h3>
                        <div className="stat-value">{stats.total}</div>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-icon">⏳</div>
                    <div className="stat-content">
                        <h3>待處理</h3>
                        <div className="stat-value">{stats.pending}</div>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-icon">🔄</div>
                    <div className="stat-content">
                        <h3>處理中</h3>
                        <div className="stat-value">{stats.processing}</div>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-icon">✅</div>
                    <div className="stat-content">
                        <h3>已完成</h3>
                        <div className="stat-value">{stats.delivered}</div>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-icon">💰</div>
                    <div className="stat-content">
                        <h3>總營收</h3>
                        <div className="stat-value">NT$ {stats.totalRevenue.toLocaleString()}</div>
                    </div>
                </div>
            </div>

            {/* 搜尋與篩選 */}
            <div className="order-filters card">
                <div className="filter-group">
                    <input
                        type="text"
                        className="search-input"
                        placeholder="搜尋訂單編號、客戶姓名或電話..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />

                    <select
                        className="status-filter"
                        value={selectedStatus}
                        onChange={(e) => setSelectedStatus(e.target.value)}
                    >
                        <option value="all">全部狀態</option>
                        <option value="pending">待處理</option>
                        <option value="processing">處理中</option>
                        <option value="shipping">配送中</option>
                        <option value="delivered">已送達</option>
                        <option value="cancelled">已取消</option>
                    </select>
                </div>

                <div className="filter-actions">
                    <button className="btn btn-secondary">匯出報表</button>
                    <button className="btn btn-primary">批次處理</button>
                </div>
            </div>

            {/* 訂單列表 */}
            <div className="orders-list">
                {filteredOrders.map((order) => (
                    <div key={order.id} className="order-card card">
                        <div className="order-header">
                            <div className="order-info">
                                <h3>{order.id}</h3>
                                <span className={`order-status status-${getStatusColor(order.status)}`}>
                                    {getStatusLabel(order.status)}
                                </span>
                            </div>
                            <div className="order-amount">
                                NT$ {order.totalAmount.toLocaleString()}
                            </div>
                        </div>

                        <div className="order-details">
                            <div className="customer-info">
                                <div className="info-item">
                                    <span className="icon">👤</span>
                                    <span className="text">{order.customerName}</span>
                                </div>
                                <div className="info-item">
                                    <span className="icon">📞</span>
                                    <span className="text">{order.customerPhone}</span>
                                </div>
                                <div className="info-item">
                                    <span className="icon">📍</span>
                                    <span className="text">{order.deliveryAddress}</span>
                                </div>
                            </div>

                            <div className="order-products">
                                <h4>訂購商品：</h4>
                                <div className="product-list">
                                    {order.products.map((product, index) => (
                                        <div key={index} className="product-item">
                                            <span className="product-name">{product.productName}</span>
                                            <span className="product-quantity">x {product.quantity}</span>
                                            <span className="product-price">NT$ {product.subtotal.toLocaleString()}</span>
                                        </div>
                                    ))}
                                </div>
                            </div>

                            <div className="order-dates">
                                <div className="date-item">
                                    <span className="date-label">訂單日期：</span>
                                    <span className="date-value">{order.orderDate.toLocaleDateString('zh-TW')} {order.orderDate.toLocaleTimeString('zh-TW', { hour: '2-digit', minute: '2-digit' })}</span>
                                </div>
                                {order.deliveryDate && (
                                    <div className="date-item">
                                        <span className="date-label">配送日期：</span>
                                        <span className="date-value">{order.deliveryDate.toLocaleDateString('zh-TW')} {order.deliveryDate.toLocaleTimeString('zh-TW', { hour: '2-digit', minute: '2-digit' })}</span>
                                    </div>
                                )}
                            </div>

                            {order.notes && (
                                <div className="order-notes">
                                    <span className="notes-label">備註：</span>
                                    <span className="notes-text">{order.notes}</span>
                                </div>
                            )}
                        </div>

                        <div className="order-actions">
                            <button className="btn btn-secondary">編輯</button>
                            <button className="btn btn-info">列印</button>
                            {order.status === 'pending' && (
                                <button
                                    className="btn btn-primary"
                                    onClick={() => updateOrderStatus(order.id, 'processing')}
                                >
                                    開始處理
                                </button>
                            )}
                            {order.status === 'processing' && (
                                <button
                                    className="btn btn-warning"
                                    onClick={() => updateOrderStatus(order.id, 'shipping')}
                                >
                                    開始配送
                                </button>
                            )}
                            {order.status === 'shipping' && (
                                <button
                                    className="btn btn-success"
                                    onClick={() => updateOrderStatus(order.id, 'delivered')}
                                >
                                    確認送達
                                </button>
                            )}
                        </div>
                    </div>
                ))}
            </div>

            {filteredOrders.length === 0 && (
                <div className="empty-state card">
                    <div className="empty-icon">📋</div>
                    <h3>沒有找到符合條件的訂單</h3>
                    <p>請調整搜尋條件或建立新的訂單</p>
                    <button className="btn btn-primary">建立新訂單</button>
                </div>
            )}
        </div>
    );
};
