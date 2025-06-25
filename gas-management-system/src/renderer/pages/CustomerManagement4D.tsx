import React, { useState } from 'react';
import { Customer } from '../../types';
import './CustomerManagement4D.css';

export const CustomerManagement4D: React.FC = () => {
    const [customers, setCustomers] = useState<Customer[]>([
        {
            id: '1',
            name: '王大明',
            phone: '0912-345-678',
            address: '台北市中山區民生東路123號',
            email: 'wang@example.com',
            customerType: 'business',
            registrationDate: new Date('2024-01-15'),
            totalOrders: 45,
            totalSpent: 123400,
        },
        {
            id: '2',
            name: '李小華',
            phone: '0987-654-321',
            address: '新北市板橋區文化路456號',
            customerType: 'individual',
            registrationDate: new Date('2024-03-20'),
            totalOrders: 12,
            totalSpent: 24800,
        },
        {
            id: '3',
            name: '陳氏餐廳',
            phone: '02-2345-6789',
            address: '台中市西區精誠路789號',
            email: 'chen.restaurant@example.com',
            customerType: 'business',
            registrationDate: new Date('2023-11-10'),
            totalOrders: 89,
            totalSpent: 267800,
        },
        {
            id: '4',
            name: '張美麗',
            phone: '0955-123-456',
            address: '高雄市前鎮區中正路321號',
            customerType: 'individual',
            registrationDate: new Date('2024-02-28'),
            totalOrders: 8,
            totalSpent: 15600,
        },
    ]);

    const [selectedCustomer, setSelectedCustomer] = useState<Customer | null>(null);
    const [searchTerm, setSearchTerm] = useState('');

    const filteredCustomers = customers.filter(customer =>
        customer.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        customer.phone.includes(searchTerm) ||
        customer.email?.toLowerCase().includes(searchTerm.toLowerCase())
    );

    const totalCustomers = customers.length;
    const businessCustomers = customers.filter(c => c.customerType === 'business').length;
    const individualCustomers = customers.filter(c => c.customerType === 'individual').length;
    const totalRevenue = customers.reduce((sum, c) => sum + c.totalSpent, 0);
    const avgOrderValue = totalRevenue / customers.reduce((sum, c) => sum + c.totalOrders, 0);

    const getCustomerTypeLabel = (type: string) => {
        return type === 'business' ? '企業客戶' : '個人客戶';
    };

    const getCustomerTypeColor = (type: string) => {
        return type === 'business' ? '#ff77c6' : '#00d4ff';
    };

    const getCustomerLevel = (totalSpent: number) => {
        if (totalSpent >= 200000) return { level: 'VIP', color: '#ffd700' };
        if (totalSpent >= 100000) return { level: '金級', color: '#ff77c6' };
        if (totalSpent >= 50000) return { level: '銀級', color: '#78dbff' };
        return { level: '銅級', color: '#00ff7f' };
    };

    return (
        <div className="customer-management-4d">
            {/* 4D 標題區 */}
            <div className="header-4d">
                <div className="header-content-4d">
                    <h1 className="title-4d">
                        <span className="hologram-text">客戶管理系統</span>
                        <div className="scan-line"></div>
                    </h1>
                    <p className="subtitle-4d">智能客戶分析 • 精準營銷 • 關係管理</p>
                </div>
                <div className="header-actions">
                    <div className="search-container-4d">
                        <input
                            type="text"
                            placeholder="搜尋客戶..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                            className="search-input-4d"
                        />
                        <div className="search-effects"></div>
                    </div>
                    <button className="btn-4d btn-add">
                        <div className="btn-glow"></div>
                        <span className="btn-text">
                            <i className="icon-plus">+</i>
                            新增客戶
                        </span>
                    </button>
                </div>
            </div>

            {/* 4D 統計面板 */}
            <div className="stats-panel-4d">
                <div className="stat-card-4d">
                    <div className="stat-icon pulse-cyan">👥</div>
                    <div className="stat-content">
                        <div className="stat-value">{totalCustomers}</div>
                        <div className="stat-label">總客戶數</div>
                    </div>
                    <div className="energy-bar">
                        <div className="energy-fill" style={{ width: '100%' }}></div>
                    </div>
                </div>

                <div className="stat-card-4d">
                    <div className="stat-icon pulse-magenta">🏢</div>
                    <div className="stat-content">
                        <div className="stat-value">{businessCustomers}</div>
                        <div className="stat-label">企業客戶</div>
                    </div>
                    <div className="energy-bar">
                        <div className="energy-fill" style={{ width: `${(businessCustomers / totalCustomers) * 100}%` }}></div>
                    </div>
                </div>

                <div className="stat-card-4d">
                    <div className="stat-icon pulse-cyan">👤</div>
                    <div className="stat-content">
                        <div className="stat-value">{individualCustomers}</div>
                        <div className="stat-label">個人客戶</div>
                    </div>
                    <div className="energy-bar">
                        <div className="energy-fill" style={{ width: `${(individualCustomers / totalCustomers) * 100}%` }}></div>
                    </div>
                </div>

                <div className="stat-card-4d">
                    <div className="stat-icon pulse-green">💰</div>
                    <div className="stat-content">
                        <div className="stat-value">NT$ {totalRevenue.toLocaleString()}</div>
                        <div className="stat-label">總消費額</div>
                    </div>
                    <div className="energy-bar">
                        <div className="energy-fill" style={{ width: '85%' }}></div>
                    </div>
                </div>

                <div className="stat-card-4d">
                    <div className="stat-icon pulse-yellow">📊</div>
                    <div className="stat-content">
                        <div className="stat-value">NT$ {Math.round(avgOrderValue).toLocaleString()}</div>
                        <div className="stat-label">平均訂單金額</div>
                    </div>
                    <div className="energy-bar">
                        <div className="energy-fill" style={{ width: '70%' }}></div>
                    </div>
                </div>
            </div>

            {/* 4D 客戶網格 */}
            <div className="customers-grid-4d">
                {filteredCustomers.map((customer, index) => {
                    const customerLevel = getCustomerLevel(customer.totalSpent);
                    return (
                        <div
                            key={customer.id}
                            className={`customer-card-4d ${selectedCustomer?.id === customer.id ? 'selected' : ''}`}
                            onClick={() => setSelectedCustomer(customer)}
                            style={{ '--delay': `${index * 0.1}s` } as React.CSSProperties}
                        >
                            <div className="card-hologram"></div>
                            <div className="card-border"></div>

                            {/* 客戶標題 */}
                            <div className="customer-header-4d">
                                <div className="customer-name-section">
                                    <h3 className="customer-name">{customer.name}</h3>
                                    <div
                                        className="customer-type-badge"
                                        style={{ '--type-color': getCustomerTypeColor(customer.customerType) } as React.CSSProperties}
                                    >
                                        {getCustomerTypeLabel(customer.customerType)}
                                    </div>
                                </div>
                                <div
                                    className="customer-level-badge"
                                    style={{ '--level-color': customerLevel.color } as React.CSSProperties}
                                >
                                    <div className="level-dot"></div>
                                    <span>{customerLevel.level}</span>
                                </div>
                            </div>

                            {/* 客戶頭像區域 */}
                            <div className="customer-avatar-4d">
                                <div className="avatar-container">
                                    <div className="avatar-circle">
                                        <span className="avatar-text">
                                            {customer.name.charAt(0)}
                                        </span>
                                    </div>
                                    <div className="avatar-glow"></div>
                                </div>
                            </div>

                            {/* 聯絡信息 */}
                            <div className="contact-info-4d">
                                <div className="contact-item">
                                    <span className="contact-icon">📞</span>
                                    <span className="contact-value">{customer.phone}</span>
                                </div>
                                {customer.email && (
                                    <div className="contact-item">
                                        <span className="contact-icon">📧</span>
                                        <span className="contact-value">{customer.email}</span>
                                    </div>
                                )}
                                <div className="contact-item">
                                    <span className="contact-icon">📍</span>
                                    <span className="contact-value">{customer.address}</span>
                                </div>
                            </div>

                            {/* 統計數據 */}
                            <div className="customer-stats-4d">
                                <div className="stats-grid">
                                    <div className="stat-item">
                                        <span className="stat-number">{customer.totalOrders}</span>
                                        <span className="stat-label">總訂單</span>
                                    </div>
                                    <div className="stat-item">
                                        <span className="stat-number">NT$ {customer.totalSpent.toLocaleString()}</span>
                                        <span className="stat-label">總消費</span>
                                    </div>
                                    <div className="stat-item">
                                        <span className="stat-number">
                                            NT$ {Math.round(customer.totalSpent / customer.totalOrders).toLocaleString()}
                                        </span>
                                        <span className="stat-label">平均訂單</span>
                                    </div>
                                </div>
                            </div>

                            {/* 註冊信息 */}
                            <div className="registration-info-4d">
                                <span className="registration-label">註冊日期:</span>
                                <span className="registration-date">
                                    {customer.registrationDate.toLocaleDateString('zh-TW')}
                                </span>
                            </div>

                            {/* 操作按鈕 */}
                            <div className="customer-actions-4d">
                                <button className="action-btn edit">
                                    <div className="btn-hologram"></div>
                                    <span>編輯資料</span>
                                </button>
                                <button className="action-btn orders">
                                    <div className="btn-hologram"></div>
                                    <span>查看訂單</span>
                                </button>
                                <button className="action-btn contact">
                                    <div className="btn-hologram"></div>
                                    <span>聯絡客戶</span>
                                </button>
                            </div>
                        </div>
                    );
                })}
            </div>

            {/* 客戶詳細信息面板 */}
            {selectedCustomer && (
                <div className="customer-detail-panel-4d">
                    <div className="panel-header">
                        <h3>客戶詳細資訊 - {selectedCustomer.name}</h3>
                        <button
                            className="close-btn"
                            onClick={() => setSelectedCustomer(null)}
                        >
                            ×
                        </button>
                    </div>

                    <div className="detail-content">
                        <div className="detail-section">
                            <h4>基本信息</h4>
                            <div className="detail-grid">
                                <div className="detail-item">
                                    <span className="label">客戶名稱:</span>
                                    <span className="value">{selectedCustomer.name}</span>
                                </div>
                                <div className="detail-item">
                                    <span className="label">客戶類型:</span>
                                    <span className="value">{getCustomerTypeLabel(selectedCustomer.customerType)}</span>
                                </div>
                                <div className="detail-item">
                                    <span className="label">電話號碼:</span>
                                    <span className="value">{selectedCustomer.phone}</span>
                                </div>
                                <div className="detail-item">
                                    <span className="label">電子郵件:</span>
                                    <span className="value">{selectedCustomer.email || '未提供'}</span>
                                </div>
                                <div className="detail-item">
                                    <span className="label">地址:</span>
                                    <span className="value">{selectedCustomer.address}</span>
                                </div>
                            </div>
                        </div>

                        <div className="detail-section">
                            <h4>消費分析</h4>
                            <div className="consumption-analysis">
                                <div className="analysis-chart">
                                    <div className="chart-container">
                                        <div className="chart-bar">
                                            <div
                                                className="bar-fill"
                                                style={{ height: `${(selectedCustomer.totalOrders / 100) * 100}%` }}
                                            ></div>
                                        </div>
                                        <span className="chart-label">訂單數量</span>
                                    </div>
                                    <div className="chart-container">
                                        <div className="chart-bar">
                                            <div
                                                className="bar-fill"
                                                style={{ height: `${(selectedCustomer.totalSpent / 300000) * 100}%` }}
                                            ></div>
                                        </div>
                                        <span className="chart-label">消費金額</span>
                                    </div>
                                </div>
                                <div className="analysis-data">
                                    <div className="data-row">
                                        <span className="data-label">總訂單數:</span>
                                        <span className="data-value">{selectedCustomer.totalOrders} 筆</span>
                                    </div>
                                    <div className="data-row">
                                        <span className="data-label">總消費額:</span>
                                        <span className="data-value">NT$ {selectedCustomer.totalSpent.toLocaleString()}</span>
                                    </div>
                                    <div className="data-row">
                                        <span className="data-label">平均訂單:</span>
                                        <span className="data-value">
                                            NT$ {Math.round(selectedCustomer.totalSpent / selectedCustomer.totalOrders).toLocaleString()}
                                        </span>
                                    </div>
                                    <div className="data-row">
                                        <span className="data-label">客戶等級:</span>
                                        <span className="data-value">{getCustomerLevel(selectedCustomer.totalSpent).level}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            )}

            {/* 4D 掃描線效果 */}
            <div className="scanner-overlay">
                <div className="scan-line-horizontal"></div>
                <div className="scan-line-vertical"></div>
            </div>        </div>
    );
};

export default CustomerManagement4D;
