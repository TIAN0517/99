import React, { useState } from 'react';
import './FinancialAnalysis.css';

interface FinancialData {
  month: string;
  revenue: number;
  cost: number;
  profit: number;
}

interface MonthlyReport {
  salesRevenue: number;
  operatingCosts: number;
  grossProfit: number;
  netProfit: number;
  taxes: number;
}

export const FinancialAnalysis: React.FC = () => {
  const [selectedPeriod, setSelectedPeriod] = useState('2024');
  
  const monthlyData: FinancialData[] = [
    { month: '1月', revenue: 850000, cost: 620000, profit: 230000 },
    { month: '2月', revenue: 920000, cost: 650000, profit: 270000 },
    { month: '3月', revenue: 780000, cost: 580000, profit: 200000 },
    { month: '4月', revenue: 890000, cost: 640000, profit: 250000 },
    { month: '5月', revenue: 950000, cost: 680000, profit: 270000 },
    { month: '6月', revenue: 1020000, cost: 720000, profit: 300000 },
    { month: '7月', revenue: 1100000, cost: 780000, profit: 320000 },
    { month: '8月', revenue: 980000, cost: 700000, profit: 280000 },
    { month: '9月', revenue: 1050000, cost: 750000, profit: 300000 },
    { month: '10月', revenue: 1150000, cost: 820000, profit: 330000 },
    { month: '11月', revenue: 1080000, cost: 770000, profit: 310000 },
    { month: '12月', revenue: 1200000, cost: 850000, profit: 350000 },
  ];

  const currentMonth: MonthlyReport = {
    salesRevenue: 1200000,
    operatingCosts: 850000,
    grossProfit: 350000,
    netProfit: 315000,
    taxes: 35000,
  };

  const totalRevenue = monthlyData.reduce((sum, item) => sum + item.revenue, 0);
  const totalCosts = monthlyData.reduce((sum, item) => sum + item.cost, 0);
  const totalProfit = monthlyData.reduce((sum, item) => sum + item.profit, 0);
  const profitMargin = ((totalProfit / totalRevenue) * 100).toFixed(1);

  const getMaxValue = () => {
    const maxRevenue = Math.max(...monthlyData.map(item => item.revenue));
    const maxCost = Math.max(...monthlyData.map(item => item.cost));
    return Math.max(maxRevenue, maxCost);
  };

  const maxValue = getMaxValue();

  return (
    <div className="financial-analysis">
      <div className="page-header">
        <div className="header-content">
          <h1>財務分析</h1>
          <p>營收與成本分析報表</p>
        </div>
        <div className="header-actions">
          <select 
            className="period-selector"
            value={selectedPeriod}
            onChange={(e) => setSelectedPeriod(e.target.value)}
          >
            <option value="2024">2024年</option>
            <option value="2023">2023年</option>
            <option value="2022">2022年</option>
          </select>
          <button className="btn btn-primary">
            <span>📊</span>
            生成報表
          </button>
        </div>
      </div>

      {/* 財務指標卡片 */}
      <div className="financial-stats">
        <div className="stat-card revenue">
          <div className="stat-icon">💰</div>
          <div className="stat-content">
            <h3>總營收</h3>
            <div className="stat-value">NT$ {totalRevenue.toLocaleString()}</div>
            <div className="stat-change positive">+8.5% 較去年</div>
          </div>
        </div>
        
        <div className="stat-card cost">
          <div className="stat-icon">💸</div>
          <div className="stat-content">
            <h3>總成本</h3>
            <div className="stat-value">NT$ {totalCosts.toLocaleString()}</div>
            <div className="stat-change positive">-2.3% 較去年</div>
          </div>
        </div>
        
        <div className="stat-card profit">
          <div className="stat-icon">📈</div>
          <div className="stat-content">
            <h3>總利潤</h3>
            <div className="stat-value">NT$ {totalProfit.toLocaleString()}</div>
            <div className="stat-change positive">+12.8% 較去年</div>
          </div>
        </div>
        
        <div className="stat-card margin">
          <div className="stat-icon">🎯</div>
          <div className="stat-content">
            <h3>利潤率</h3>
            <div className="stat-value">{profitMargin}%</div>
            <div className="stat-change positive">+3.2% 較去年</div>
          </div>
        </div>
      </div>

      <div className="analysis-grid">
        {/* 月度趨勢圖 */}
        <div className="chart-container card">
          <div className="chart-header">
            <h3>月度財務趨勢</h3>
            <div className="chart-legend">
              <span className="legend-item revenue">
                <span className="legend-color"></span>
                營收
              </span>
              <span className="legend-item cost">
                <span className="legend-color"></span>
                成本
              </span>
              <span className="legend-item profit">
                <span className="legend-color"></span>
                利潤
              </span>
            </div>
          </div>
          <div className="chart-content">
            <div className="chart-bars">
              {monthlyData.map((data, index) => (
                <div key={index} className="bar-group">
                  <div className="bars">
                    <div 
                      className="bar revenue-bar" 
                      style={{ height: `${(data.revenue / maxValue) * 200}px` }}
                      title={`營收: NT$ ${data.revenue.toLocaleString()}`}
                    ></div>
                    <div 
                      className="bar cost-bar" 
                      style={{ height: `${(data.cost / maxValue) * 200}px` }}
                      title={`成本: NT$ ${data.cost.toLocaleString()}`}
                    ></div>
                    <div 
                      className="bar profit-bar" 
                      style={{ height: `${(data.profit / maxValue) * 200}px` }}
                      title={`利潤: NT$ ${data.profit.toLocaleString()}`}
                    ></div>
                  </div>
                  <div className="bar-label">{data.month}</div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* 當月詳細報表 */}
        <div className="monthly-report card">
          <h3>12月份損益表</h3>
          <div className="report-items">
            <div className="report-item">
              <span className="item-label">銷售收入</span>
              <span className="item-value positive">NT$ {currentMonth.salesRevenue.toLocaleString()}</span>
            </div>
            <div className="report-item">
              <span className="item-label">營運成本</span>
              <span className="item-value negative">-NT$ {currentMonth.operatingCosts.toLocaleString()}</span>
            </div>
            <div className="report-divider"></div>
            <div className="report-item">
              <span className="item-label">毛利潤</span>
              <span className="item-value positive">NT$ {currentMonth.grossProfit.toLocaleString()}</span>
            </div>
            <div className="report-item">
              <span className="item-label">稅務支出</span>
              <span className="item-value negative">-NT$ {currentMonth.taxes.toLocaleString()}</span>
            </div>
            <div className="report-divider"></div>
            <div className="report-item total">
              <span className="item-label">淨利潤</span>
              <span className="item-value positive">NT$ {currentMonth.netProfit.toLocaleString()}</span>
            </div>
          </div>
        </div>
      </div>

      {/* 成本結構分析 */}
      <div className="cost-analysis card">
        <h3>成本結構分析</h3>
        <div className="cost-breakdown">
          <div className="cost-item">
            <div className="cost-info">
              <span className="cost-category">採購成本</span>
              <span className="cost-percentage">65%</span>
            </div>
            <div className="cost-bar">
              <div className="cost-fill" style={{ width: '65%' }}></div>
            </div>
            <span className="cost-amount">NT$ 552,500</span>
          </div>
          
          <div className="cost-item">
            <div className="cost-info">
              <span className="cost-category">人事成本</span>
              <span className="cost-percentage">20%</span>
            </div>
            <div className="cost-bar">
              <div className="cost-fill" style={{ width: '20%' }}></div>
            </div>
            <span className="cost-amount">NT$ 170,000</span>
          </div>
          
          <div className="cost-item">
            <div className="cost-info">
              <span className="cost-category">運輸費用</span>
              <span className="cost-percentage">10%</span>
            </div>
            <div className="cost-bar">
              <div className="cost-fill" style={{ width: '10%' }}></div>
            </div>
            <span className="cost-amount">NT$ 85,000</span>
          </div>
          
          <div className="cost-item">
            <div className="cost-info">
              <span className="cost-category">其他費用</span>
              <span className="cost-percentage">5%</span>
            </div>
            <div className="cost-bar">
              <div className="cost-fill" style={{ width: '5%' }}></div>
            </div>
            <span className="cost-amount">NT$ 42,500</span>
          </div>
        </div>
      </div>
    </div>
  );
};
