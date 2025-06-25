import React, { useState, useEffect } from 'react';
import './ProductManagement-4d.css';

interface Product {
  id: string;
  name: string;
  category: string;
  price: number;
  stock: number;
  description: string;
  icon: string;
  minStock: number;
}

const ProductManagement4D: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([
    {
      id: '1',
      name: '20kg液化瓦斯鋼瓶',
      category: '瓦斯鋼瓶',
      price: 800,
      stock: 45,
      description: '家用20公斤液化石油氣鋼瓶，適合大家庭使用',
      icon: '🏺',
      minStock: 10
    },
    {
      id: '2',
      name: '12kg液化瓦斯鋼瓶',
      category: '瓦斯鋼瓶',
      price: 600,
      stock: 32,
      description: '中型12公斤液化石油氣鋼瓶，適合小家庭使用',
      icon: '🏺',
      minStock: 15
    },
    {
      id: '3',
      name: '5kg液化瓦斯鋼瓶',
      category: '瓦斯鋼瓶',
      price: 300,
      stock: 8,
      description: '小型5公斤液化石油氣鋼瓶，適合單人使用',
      icon: '🏺',
      minStock: 20
    },
    {
      id: '4',
      name: '瓦斯爐具',
      category: '設備',
      price: 1200,
      stock: 18,
      description: '高效節能瓦斯爐具，安全可靠',
      icon: '🔥',
      minStock: 5
    },
    {
      id: '5',
      name: '瓦斯熱水器',
      category: '設備',
      price: 3500,
      stock: 12,
      description: '智能恆溫瓦斯熱水器，節能環保',
      icon: '🚿',
      minStock: 3
    },
    {
      id: '6',
      name: '安全檢測器',
      category: '安全設備',
      price: 450,
      stock: 25,
      description: '瓦斯洩漏安全檢測器，保障家庭安全',
      icon: '🔔',
      minStock: 10
    }
  ]);

  const [searchTerm, setSearchTerm] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingProduct, setEditingProduct] = useState<Product | null>(null);
  const [newProduct, setNewProduct] = useState<Partial<Product>>({
    name: '',
    category: '',
    price: 0,
    stock: 0,
    description: '',
    icon: '📦',
    minStock: 5
  });

  const filteredProducts = products.filter(product =>
    product.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    product.category.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const getStockLevel = (stock: number, minStock: number) => {
    if (stock <= minStock) return 'low';
    if (stock <= minStock * 2) return 'medium';
    return 'high';
  };

  const getStockText = (stock: number, minStock: number) => {
    const level = getStockLevel(stock, minStock);
    switch (level) {
      case 'low': return '庫存不足';
      case 'medium': return '庫存偏低';
      case 'high': return '庫存充足';
      default: return '庫存正常';
    }
  };

  const handleAddProduct = () => {
    setEditingProduct(null);
    setNewProduct({
      name: '',
      category: '',
      price: 0,
      stock: 0,
      description: '',
      icon: '📦',
      minStock: 5
    });
    setShowModal(true);
  };

  const handleEditProduct = (product: Product) => {
    setEditingProduct(product);
    setNewProduct({ ...product });
    setShowModal(true);
  };

  const handleDeleteProduct = (productId: string) => {
    if (confirm('確定要刪除此產品嗎？')) {
      setProducts(products.filter(p => p.id !== productId));
    }
  };

  const handleSaveProduct = () => {
    if (!newProduct.name || !newProduct.category || !newProduct.price) {
      alert('請填寫所有必填欄位');
      return;
    }

    if (editingProduct) {
      // 編輯現有產品
      setProducts(products.map(p =>
        p.id === editingProduct.id
          ? { ...newProduct as Product, id: editingProduct.id }
          : p
      ));
    } else {
      // 新增產品
      const id = Date.now().toString();
      setProducts([...products, { ...newProduct as Product, id }]);
    }

    setShowModal(false);
    setEditingProduct(null);
  };

  const totalProducts = products.length;
  const totalStock = products.reduce((sum, p) => sum + p.stock, 0);
  const lowStockCount = products.filter(p => p.stock <= p.minStock).length;
  const totalValue = products.reduce((sum, p) => sum + (p.price * p.stock), 0);

  const categoryOptions = [
    '瓦斯鋼瓶',
    '設備',
    '安全設備',
    '配件',
    '服務'
  ];

  const iconOptions = [
    '🏺', '🔥', '🚿', '🔔', '📦', '⚙️', '🛡️', '🔧', '💨', '🏠'
  ];

  return (
    <div className="product-management">
      {/* 頁面頭部 */}
      <div className="product-header">
        <h1>📦 產品管理系統</h1>
        <div className="product-controls">
          <div className="search-box">
            <span className="search-icon">🔍</span>
            <input
              type="text"
              className="search-input"
              placeholder="搜尋產品名稱或類別..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
          <button className="add-product-btn" onClick={handleAddProduct}>
            <span>➕</span>
            <span>新增產品</span>
          </button>
        </div>
      </div>

      <div className="products-container">
        {/* 統計面板 */}
        <div className="stats-panel">
          <div className="stat-item">
            <div className="stat-number">{totalProducts}</div>
            <div className="stat-label">總產品數</div>
          </div>
          <div className="stat-item">
            <div className="stat-number">{totalStock}</div>
            <div className="stat-label">總庫存量</div>
          </div>
          <div className="stat-item">
            <div className="stat-number">{lowStockCount}</div>
            <div className="stat-label">低庫存警告</div>
          </div>
          <div className="stat-item">
            <div className="stat-number">NT$ {totalValue.toLocaleString()}</div>
            <div className="stat-label">庫存總價值</div>
          </div>
        </div>

        {/* 產品網格 */}
        <div className="products-grid">
          {filteredProducts.map((product, index) => (
            <div
              key={product.id}
              className="product-card animate-slide-in"
              style={{ animationDelay: `${index * 0.1}s` }}
            >
              <div className="product-image">
                <span>{product.icon}</span>
              </div>
              <div className="product-name">{product.name}</div>
              <div className="product-category">{product.category}</div>
              <div className="product-price">NT$ {product.price.toLocaleString()}</div>
              <div className="product-stock">
                <div className={`stock-indicator ${getStockLevel(product.stock, product.minStock)}`}></div>
                <span>庫存: {product.stock} | {getStockText(product.stock, product.minStock)}</span>
              </div>
              <div className="product-actions">
                <button
                  className="action-btn edit-btn"
                  onClick={() => handleEditProduct(product)}
                >
                  ✏️ 編輯
                </button>
                <button
                  className="action-btn delete-btn"
                  onClick={() => handleDeleteProduct(product.id)}
                >
                  🗑️ 刪除
                </button>
              </div>
            </div>
          ))}
        </div>

        {filteredProducts.length === 0 && (
          <div className="no-results">
            <div style={{ fontSize: '48px', marginBottom: '20px' }}>📭</div>
            <h3>沒有找到符合條件的產品</h3>
            <p>請嘗試修改搜尋條件或新增產品</p>
          </div>
        )}
      </div>

      {/* 新增/編輯產品模態框 */}
      {showModal && (
        <div className="modal">
          <div className="modal-content">
            <div className="modal-header">
              <h2 className="modal-title">
                {editingProduct ? '編輯產品' : '新增產品'}
              </h2>
              <button
                className="close-btn"
                onClick={() => setShowModal(false)}
              >
                ✕
              </button>
            </div>

            <div className="form-group">
              <label className="form-label">產品名稱 *</label>
              <input
                type="text"
                className="form-input"
                value={newProduct.name || ''}
                onChange={(e) => setNewProduct({ ...newProduct, name: e.target.value })}
                placeholder="請輸入產品名稱"
              />
            </div>

            <div className="form-group">
              <label className="form-label">產品類別 *</label>
              <select
                className="form-input form-select"
                value={newProduct.category || ''}
                onChange={(e) => setNewProduct({ ...newProduct, category: e.target.value })}
              >
                <option value="">請選擇類別</option>
                {categoryOptions.map(category => (
                  <option key={category} value={category}>{category}</option>
                ))}
              </select>
            </div>

            <div className="form-group">
              <label className="form-label">圖示</label>
              <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap', marginBottom: '8px' }}>
                {iconOptions.map(icon => (
                  <button
                    key={icon}
                    type="button"
                    style={{
                      padding: '8px 12px',
                      border: newProduct.icon === icon ? '2px solid var(--primary-blue)' : '1px solid rgba(255,255,255,0.2)',
                      borderRadius: '8px',
                      background: newProduct.icon === icon ? 'rgba(0,212,255,0.2)' : 'rgba(255,255,255,0.05)',
                      fontSize: '20px',
                      cursor: 'pointer'
                    }}
                    onClick={() => setNewProduct({ ...newProduct, icon })}
                  >
                    {icon}
                  </button>
                ))}
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
              <div className="form-group">
                <label className="form-label">價格 (NT$) *</label>
                <input
                  type="number"
                  className="form-input"
                  value={newProduct.price || 0}
                  onChange={(e) => setNewProduct({ ...newProduct, price: Number(e.target.value) })}
                  placeholder="0"
                  min="0"
                />
              </div>

              <div className="form-group">
                <label className="form-label">庫存數量 *</label>
                <input
                  type="number"
                  className="form-input"
                  value={newProduct.stock || 0}
                  onChange={(e) => setNewProduct({ ...newProduct, stock: Number(e.target.value) })}
                  placeholder="0"
                  min="0"
                />
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">最低庫存警告</label>
              <input
                type="number"
                className="form-input"
                value={newProduct.minStock || 5}
                onChange={(e) => setNewProduct({ ...newProduct, minStock: Number(e.target.value) })}
                placeholder="5"
                min="1"
              />
            </div>

            <div className="form-group">
              <label className="form-label">產品描述</label>
              <textarea
                className="form-input form-textarea"
                value={newProduct.description || ''}
                onChange={(e) => setNewProduct({ ...newProduct, description: e.target.value })}
                placeholder="請輸入產品詳細描述..."
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
                onClick={handleSaveProduct}
              >
                {editingProduct ? '更新產品' : '新增產品'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ProductManagement4D;
