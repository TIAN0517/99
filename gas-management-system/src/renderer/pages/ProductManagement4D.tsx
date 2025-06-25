import React, { useState } from 'react';
import { GasProduct } from '../../types';
import './ProductManagement4D.css';

export const ProductManagement4D: React.FC = () => {
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
        {
            id: '4',
            name: '桶裝瓦斯',
            type: 'lpg',
            size: '20kg',
            price: 850,
            cost: 650,
            stock: 45,
            supplier: '中油公司',
            lastUpdated: new Date(),
        },
    ]);

    const [selectedProduct, setSelectedProduct] = useState<GasProduct | null>(null);

    const getStockStatus = (stock: number) => {
        if (stock < 20) return 'critical';
        if (stock < 50) return 'warning';
        return 'optimal';
    };

    const getStockLabel = (stock: number) => {
        if (stock < 20) return '庫存危急';
        if (stock < 50) return '庫存偏低';
        return '庫存充足';
    };

    const getStockPercentage = (stock: number) => {
        const maxStock = 200; // 假設最大庫存為200
        return Math.min((stock / maxStock) * 100, 100);
    };

    const totalProducts = products.length;
    const lowStockProducts = products.filter(p => p.stock < 20).length;
    const totalInventoryValue = products.reduce((sum, p) => sum + (p.cost * p.stock), 0);
    const avgProfit = products.reduce((sum, p) => sum + ((p.price - p.cost) / p.price * 100), 0) / products.length;

    return (
        <div className="product-management-4d">
            {/* 4D 全息標題區 */}
            <div className="header-4d">
                <div className="header-content-4d">
                    <h1 className="title-4d">
                        <span className="hologram-text">產品管理系統</span>
                        <div className="scan-line"></div>
                    </h1>
                    <p className="subtitle-4d">智能庫存監控 • 即時數據分析 • 預測性補貨</p>
                </div>
                <button className="btn-4d btn-add">
                    <div className="btn-glow"></div>
                    <span className="btn-text">
                        <i className="icon-plus">+</i>
                        新增產品
                    </span>
                </button>
            </div>

            {/* 4D 統計面板 */}
            <div className="stats-panel-4d">
                <div className="stat-card-4d">
                    <div className="stat-icon pulse-cyan">📦</div>
                    <div className="stat-content">
                        <div className="stat-value">{totalProducts}</div>
                        <div className="stat-label">總產品數</div>
                    </div>
                    <div className="energy-bar">
                        <div className="energy-fill" style={{ width: '100%' }}></div>
                    </div>
                </div>

                <div className="stat-card-4d">
                    <div className="stat-icon pulse-red">⚠️</div>
                    <div className="stat-content">
                        <div className="stat-value critical">{lowStockProducts}</div>
                        <div className="stat-label">低庫存警報</div>
                    </div>
                    <div className="energy-bar">
                        <div className="energy-fill critical" style={{ width: `${(lowStockProducts / totalProducts) * 100}%` }}></div>
                    </div>
                </div>

                <div className="stat-card-4d">
                    <div className="stat-icon pulse-green">💰</div>
                    <div className="stat-content">
                        <div className="stat-value">NT$ {totalInventoryValue.toLocaleString()}</div>
                        <div className="stat-label">庫存總值</div>
                    </div>
                    <div className="energy-bar">
                        <div className="energy-fill" style={{ width: '85%' }}></div>
                    </div>
                </div>

                <div className="stat-card-4d">
                    <div className="stat-icon pulse-magenta">📈</div>
                    <div className="stat-content">
                        <div className="stat-value">{avgProfit.toFixed(1)}%</div>
                        <div className="stat-label">平均利潤率</div>
                    </div>
                    <div className="energy-bar">
                        <div className="energy-fill" style={{ width: `${avgProfit}%` }}></div>
                    </div>
                </div>
            </div>

            {/* 4D 產品網格 */}
            <div className="products-grid-4d">
                {products.map((product, index) => (
                    <div
                        key={product.id}
                        className={`product-card-4d ${selectedProduct?.id === product.id ? 'selected' : ''}`}
                        onClick={() => setSelectedProduct(product)}
                        style={{ '--delay': `${index * 0.1}s` } as React.CSSProperties}
                    >
                        <div className="card-hologram"></div>
                        <div className="card-border"></div>

                        <div className="product-header-4d">
                            <div className="product-title">
                                <h3>{product.name}</h3>
                                <span className="product-size">{product.size}</span>
                            </div>
                            <div className={`status-indicator ${getStockStatus(product.stock)}`}>
                                <div className="status-dot"></div>
                                <span>{getStockLabel(product.stock)}</span>
                            </div>
                        </div>

                        <div className="product-visual">
                            <div className="product-3d-model">
                                <div className="gas-cylinder">
                                    <div className="cylinder-body"></div>
                                    <div className="cylinder-valve"></div>
                                </div>
                            </div>
                        </div>

                        <div className="product-metrics">
                            <div className="metric-item">
                                <span className="metric-label">售價</span>
                                <span className="metric-value price">NT$ {product.price}</span>
                            </div>
                            <div className="metric-item">
                                <span className="metric-label">成本</span>
                                <span className="metric-value">NT$ {product.cost}</span>
                            </div>
                            <div className="metric-item">
                                <span className="metric-label">利潤</span>
                                <span className="metric-value profit">
                                    {(((product.price - product.cost) / product.price) * 100).toFixed(1)}%
                                </span>
                            </div>
                        </div>

                        <div className="stock-monitor">
                            <div className="stock-info">
                                <span className="stock-label">庫存量</span>
                                <span className="stock-value">{product.stock} 桶</span>
                            </div>
                            <div className="stock-bar">
                                <div
                                    className={`stock-fill ${getStockStatus(product.stock)}`}
                                    style={{ width: `${getStockPercentage(product.stock)}%` }}
                                ></div>
                                <div className="stock-scanner"></div>
                            </div>
                        </div>

                        <div className="supplier-info">
                            <span className="supplier-label">供應商</span>
                            <span className="supplier-name">{product.supplier}</span>
                        </div>

                        <div className="product-actions-4d">
                            <button className="action-btn edit">
                                <div className="btn-hologram"></div>
                                <span>編輯</span>
                            </button>
                            <button className="action-btn restock">
                                <div className="btn-hologram"></div>
                                <span>補貨</span>
                            </button>
                        </div>

                        <div className="update-timestamp">
                            最後更新: {product.lastUpdated.toLocaleTimeString()}
                        </div>
                    </div>
                ))}
            </div>

            {/* 4D 詳細信息面板 */}
            {selectedProduct && (
                <div className="product-detail-panel-4d">
                    <div className="panel-header">
                        <h3>產品詳細資訊</h3>
                        <button
                            className="close-btn"
                            onClick={() => setSelectedProduct(null)}
                        >
                            ×
                        </button>
                    </div>

                    <div className="detail-content">
                        <div className="detail-section">
                            <h4>基本信息</h4>
                            <div className="detail-grid">
                                <div className="detail-item">
                                    <span className="label">產品名稱:</span>
                                    <span className="value">{selectedProduct.name}</span>
                                </div>
                                <div className="detail-item">
                                    <span className="label">產品類型:</span>
                                    <span className="value">{selectedProduct.type}</span>
                                </div>
                                <div className="detail-item">
                                    <span className="label">規格:</span>
                                    <span className="value">{selectedProduct.size}</span>
                                </div>
                            </div>
                        </div>

                        <div className="detail-section">
                            <h4>庫存分析</h4>
                            <div className="stock-analysis">
                                <div className="analysis-chart">
                                    <div className="chart-bar">
                                        <div className="bar-fill" style={{ height: `${getStockPercentage(selectedProduct.stock)}%` }}></div>
                                    </div>
                                    <span className="chart-label">當前庫存</span>
                                </div>
                                <div className="analysis-data">
                                    <p>當前庫存: {selectedProduct.stock} 桶</p>
                                    <p>建議補貨量: {Math.max(0, 100 - selectedProduct.stock)} 桶</p>
                                    <p>預估可售天數: {Math.floor(selectedProduct.stock / 5)} 天</p>
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

export default ProductManagement4D;
