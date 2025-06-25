import React, { useState } from 'react';
import { Customer } from '../../types';
import './CustomerManagement.css';

export const CustomerManagement: React.FC = () => {
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
      address: '台北市大安區忠孝東路789號',
      email: 'chen.restaurant@example.com',
      customerType: 'business',
      registrationDate: new Date('2023-11-10'),
      totalOrders: 156,
      totalSpent: 456700,
    }
  ]);

  const [searchTerm, setSearchTerm] = useState('');

  const filteredCustomers = customers.filter(customer =>
    customer.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    customer.phone.includes(searchTerm)
  );

  const getCustomerTypeLabel = (type: 'individual' | 'business') => {
    return type === 'business' ? '企業客戶' : '個人客戶';
  };

  const getCustomerLevel = (totalSpent: number) => {
    if (totalSpent >= 300000) return { level: 'VIP', color: 'warning' };
    if (totalSpent >= 100000) return { level: '金牌', color: 'success' };
    if (totalSpent >= 50000) return { level: '銀牌', color: 'info' };
    return { level: '銅牌', color: 'secondary' };
  };

  return (
    <div className="customer-management">
      <div className="page-header">
        <div className="header-content">
          <h1>客戶管理</h1>
          <p>管理客戶資料與關係維護</p>
        </div>
        <div className="header-actions">
          <input
            type="text"
            className="search-input"
            placeholder="搜尋客戶姓名或電話..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
          <button className="btn btn-primary">
            <span>+</span>
            新增客戶
          </button>
        </div>
      </div>

      <div className="customers-grid">
        {filteredCustomers.map((customer) => {
          const level = getCustomerLevel(customer.totalSpent);
          return (
            <div key={customer.id} className="customer-card card">
              <div className="customer-header">
                <div className="customer-info">
                  <h3>{customer.name}</h3>
                  <span className={`customer-type ${customer.customerType}`}>
                    {getCustomerTypeLabel(customer.customerType)}
                  </span>
                </div>
                <span className={`customer-level status-${level.color}`}>
                  {level.level}
                </span>
              </div>
              
              <div className="customer-details">
                <div className="detail-item">
                  <span className="icon">📞</span>
                  <span className="text">{customer.phone}</span>
                </div>
                <div className="detail-item">
                  <span className="icon">📍</span>
                  <span className="text">{customer.address}</span>
                </div>
                {customer.email && (
                  <div className="detail-item">
                    <span className="icon">📧</span>
                    <span className="text">{customer.email}</span>
                  </div>
                )}
              </div>

              <div className="customer-stats">
                <div className="stat">
                  <span className="stat-label">總訂單</span>
                  <span className="stat-value">{customer.totalOrders}</span>
                </div>
                <div className="stat">
                  <span className="stat-label">總消費</span>
                  <span className="stat-value">NT$ {customer.totalSpent.toLocaleString()}</span>
                </div>
                <div className="stat">
                  <span className="stat-label">註冊日期</span>
                  <span className="stat-value">{customer.registrationDate.toLocaleDateString('zh-TW')}</span>
                </div>
              </div>

              <div className="customer-actions">
                <button className="btn btn-secondary">編輯</button>
                <button className="btn btn-primary">查看訂單</button>
                <button className="btn btn-warning">聯絡</button>
              </div>
            </div>
          );
        })}
      </div>

      <div className="customer-summary card">
        <h3>客戶統計</h3>
        <div className="summary-grid">
          <div className="summary-item">
            <span className="summary-icon">👥</span>
            <div className="summary-content">
              <span className="summary-label">總客戶數</span>
              <span className="summary-value">{customers.length}</span>
            </div>
          </div>
          <div className="summary-item">
            <span className="summary-icon">🏢</span>
            <div className="summary-content">
              <span className="summary-label">企業客戶</span>
              <span className="summary-value">{customers.filter(c => c.customerType === 'business').length}</span>
            </div>
          </div>
          <div className="summary-item">
            <span className="summary-icon">👤</span>
            <div className="summary-content">
              <span className="summary-label">個人客戶</span>
              <span className="summary-value">{customers.filter(c => c.customerType === 'individual').length}</span>
            </div>
          </div>
          <div className="summary-item">
            <span className="summary-icon">💰</span>
            <div className="summary-content">
              <span className="summary-label">總營收貢獻</span>
              <span className="summary-value">NT$ {customers.reduce((sum, c) => sum + c.totalSpent, 0).toLocaleString()}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
