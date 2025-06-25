import React, { useState } from 'react';
import { GasProduct } from '../../types';

export const ProductManagement: React.FC = () => {
  const [products, setProducts] = useState<GasProduct[]>([
    {
      id: '1',
      name: '液化石油氣',
      type: 'lpg',
      size: '5kg',
      price: 280,
      cost: 220,
      stock: 150,
      supplier: '中油公司',
      lastUpdated: new Date(),
    },
    {
      id: '2',
      name: '液化石油氣',
      type: 'lpg',
      size: '15kg',
      price: 680,
      cost: 520,
      stock: 85,
      supplier: '中油公司',
      lastUpdated: new Date(),
    },
    {
      id: '3',
      name: '工業用瓦斯',
      type: 'industrial',
      size: '50kg',
      price: 1850,
      cost: 1420,
      stock: 12,
      supplier: '台塑石化',
      lastUpdated: new Date(),
    },
  ]);

  const getStockStatus = (stock: number) => {
    if (stock < 20) return 'danger';
    if (stock < 50) return 'warning';
    return 'success';
  };

  const getStockLabel = (stock: number) => {
    if (stock < 20) return '庫存不足';
    if (stock < 50) return '庫存偏低';
    return '庫存充足';
  };

  return (
    <div className="product-management">
      <div className="page-header">
        <div className="header-content">
          <h1>產品管理</h1>
          <p>管理瓦斯產品資訊、庫存與價格</p>
        </div>
        <button className="btn btn-primary">
          <span>+</span>
          新增產品
        </button>
      </div>

      <div className="products-grid">
        {products.map((product) => (
          <div key={product.id} className="product-card card">
            <div className="product-header">
              <h3>{product.name}</h3>
              <span className={`status status-${getStockStatus(product.stock)}`}>
                {getStockLabel(product.stock)}
              </span>
            </div>
            
            <div className="product-info">
              <div className="info-row">
                <span className="label">規格:</span>
                <span className="value">{product.size}</span>
              </div>
              <div className="info-row">
                <span className="label">售價:</span>
                <span className="value price">NT$ {product.price}</span>
              </div>
              <div className="info-row">
                <span className="label">成本:</span>
                <span className="value">NT$ {product.cost}</span>
              </div>
              <div className="info-row">
                <span className="label">庫存:</span>
                <span className="value">{product.stock} 桶</span>
              </div>
              <div className="info-row">
                <span className="label">供應商:</span>
                <span className="value">{product.supplier}</span>
              </div>
            </div>

            <div className="product-actions">
              <button className="btn btn-secondary">編輯</button>
              <button className="btn btn-primary">補貨</button>
            </div>
          </div>
        ))}
      </div>

      <div className="inventory-summary card">
        <h3>庫存總覽</h3>
        <div className="summary-stats">
          <div className="stat-item">
            <span className="stat-label">總產品數</span>
            <span className="stat-value">{products.length}</span>
          </div>
          <div className="stat-item">
            <span className="stat-label">低庫存產品</span>
            <span className="stat-value danger">
              {products.filter(p => p.stock < 20).length}
            </span>
          </div>
          <div className="stat-item">
            <span className="stat-label">總庫存值</span>
            <span className="stat-value">
              NT$ {products.reduce((sum, p) => sum + (p.cost * p.stock), 0).toLocaleString()}
            </span>
          </div>
        </div>
      </div>
    </div>
  );
};
