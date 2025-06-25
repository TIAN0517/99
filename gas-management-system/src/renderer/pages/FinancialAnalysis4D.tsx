import React, { useState } from 'react';
import './FinancialAnalysis4D.css';

interface FinancialData {
  month: string;
  revenue: number;
  expenses: number;
  profit: number;
}

interface Transaction {
  id: string;
  date: Date;
  description: string;
  amount: number;
  type: 'income' | 'expense';
  category: string;
}

export const FinancialAnalysis4D: React.FC = () => {
  const [financialData] = useState<FinancialData[]>([
    { month: '1月', revenue: 850000, expenses: 620000, profit: 230000 },
    { month: '2月', revenue: 920000, expenses: 680000, profit: 240000 },
    { month: '3月', revenue: 780000, expenses: 590000, profit: 190000 },
    { month: '4月', revenue: 1100000, expenses: 750000, profit: 350000 },
    { month: '5月', revenue: 1250000, expenses: 820000, profit: 430000 },
    { month: '6月', revenue: 1180000, expenses: 790000, profit: 390000 },
  ]);

  const [transactions] = useState<Transaction[]>([
    {
      id: '1',
      date: new Date(2024, 11, 22),
      description: '瓦斯桶銷售收入',
      amount: 45000,
      type: 'income',
      category: '銷售收入'
    },
    {
      id: '2',
      date: new Date(2024, 11, 22),
      description: '配送車輛維修費',
      amount: 8500,
      type: 'expense',
      category: '維修費用'
    },
    {
      id: '3',
      date: new Date(2024, 11, 21),
      description: '批發瓦斯採購',
      amount: 120000,
      type: 'expense',
      category: '採購成本'
    },
    {
      id: '4',
      date: new Date(2024, 11, 21),
      description: '企業客戶月費',
      amount: 85000,
      type: 'income',
      category: '月費收入'
    },
  ]);

  const currentMonth = financialData[financialData.length - 1];
  const totalRevenue = financialData.reduce((sum, data) => sum + data.revenue, 0);
  const totalExpenses = financialData.reduce((sum, data) => sum + data.expenses, 0);
  const totalProfit = financialData.reduce((sum, data) => sum + data.profit, 0);
  const profitMargin = ((totalProfit / totalRevenue) * 100).toFixed(1);

  const maxRevenue = Math.max(...financialData.map(d => d.revenue));

  return (
    <div className="financial-analysis-4d">
      {/* 4D 標題區 */}
      <div className="header-4d">
        <div className="header-content-4d">
          <h1 className="title-4d">
            <span className="hologram-text">財務分析系統</span>
            <div className="scan-line"></div>
          </h1>
          <p className="subtitle-4d">智能財務追蹤 • 即時利潤分析 • 預測性報告</p>
        </div>
        <button className="btn-4d btn-add">
          <div className="btn-glow"></div>
          <span className="btn-text">
            <i className="icon-plus">📊</i>
            生成報告
          </span>
        </button>
      </div>

      {/* 4D 財務統計面板 */}
      <div className="stats-panel-4d">
        <div className="stat-card-4d">
          <div className="stat-icon pulse-green">💰</div>
          <div className="stat-content">
            <div className="stat-value">NT$ {totalRevenue.toLocaleString()}</div>
            <div className="stat-label">總營收</div>
          </div>
          <div className="energy-bar">
            <div className="energy-fill" style={{ width: '100%' }}></div>
          </div>
        </div>

        <div className="stat-card-4d">
          <div className="stat-icon pulse-red">💸</div>
          <div className="stat-content">
            <div className="stat-value expense">NT$ {totalExpenses.toLocaleString()}</div>
            <div className="stat-label">總支出</div>
          </div>
          <div className="energy-bar">
            <div className="energy-fill expense" style={{ width: `${(totalExpenses / totalRevenue) * 100}%` }}></div>
          </div>
        </div>

        <div className="stat-card-4d">
          <div className="stat-icon pulse-cyan">📈</div>
          <div className="stat-content">
            <div className="stat-value profit">NT$ {totalProfit.toLocaleString()}</div>
            <div className="stat-label">總利潤</div>
          </div>
          <div className="energy-bar">
            <div className="energy-fill profit" style={{ width: `${(totalProfit / totalRevenue) * 100}%` }}></div>
          </div>
        </div>

        <div className="stat-card-4d">
          <div className="stat-icon pulse-magenta">📊</div>
          <div className="stat-content">
            <div className="stat-value">{profitMargin}%</div>
            <div className="stat-label">利潤率</div>
          </div>
          <div className="energy-bar">
            <div className="energy-fill" style={{ width: `${profitMargin}%` }}></div>
          </div>
        </div>

        <div className="stat-card-4d">
          <div className="stat-icon pulse-yellow">💳</div>
          <div className="stat-content">
            <div className="stat-value">NT$ {currentMonth.revenue.toLocaleString()}</div>
            <div className="stat-label">本月營收</div>
          </div>
          <div className="energy-bar">
            <div className="energy-fill" style={{ width: `${(currentMonth.revenue / maxRevenue) * 100}%` }}></div>
          </div>
        </div>
      </div>

      {/* 4D 圖表區域 */}
      <div className="charts-container-4d">
        {/* 營收趨勢圖 */}
        <div className="chart-card-4d">
          <div className="chart-header">
            <h3 className="chart-title">營收趨勢分析</h3>
            <div className="chart-controls">
              <button className="control-btn active">6個月</button>
              <button className="control-btn">1年</button>
            </div>
          </div>

          <div className="revenue-chart-4d">
            {financialData.map((data, index) => (
              <div key={data.month} className="chart-column">
                <div className="column-group">
                  <div
                    className="chart-bar revenue"
                    style={{ height: `${(data.revenue / maxRevenue) * 100}%` }}
                    data-value={`NT$ ${data.revenue.toLocaleString()}`}
                  >
                    <div className="bar-glow"></div>
                  </div>
                  <div
                    className="chart-bar expenses"
                    style={{ height: `${(data.expenses / maxRevenue) * 100}%` }}
                    data-value={`NT$ ${data.expenses.toLocaleString()}`}
                  >
                    <div className="bar-glow"></div>
                  </div>
                  <div
                    className="chart-bar profit"
                    style={{ height: `${(data.profit / maxRevenue) * 100}%` }}
                    data-value={`NT$ ${data.profit.toLocaleString()}`}
                  >
                    <div className="bar-glow"></div>
                  </div>
                </div>
                <div className="chart-label">{data.month}</div>
              </div>
            ))}
          </div>

          <div className="chart-legend">
            <div className="legend-item">
              <div className="legend-color revenue"></div>
              <span>營收</span>
            </div>
            <div className="legend-item">
              <div className="legend-color expenses"></div>
              <span>支出</span>
            </div>
            <div className="legend-item">
              <div className="legend-color profit"></div>
              <span>利潤</span>
            </div>
          </div>
        </div>

        {/* 利潤分析圓餅圖 */}
        <div className="chart-card-4d">
          <div className="chart-header">
            <h3 className="chart-title">本月財務分佈</h3>
          </div>

          <div className="pie-chart-container">
            <div className="pie-chart-4d">
              <div className="pie-slice profit-slice" style={{ '--percentage': `${(currentMonth.profit / currentMonth.revenue) * 100}%` } as React.CSSProperties}>
                <div className="slice-label">
                  利潤<br />
                  NT$ {currentMonth.profit.toLocaleString()}
                </div>
              </div>
              <div className="pie-slice expense-slice" style={{ '--percentage': `${(currentMonth.expenses / currentMonth.revenue) * 100}%` } as React.CSSProperties}>
                <div className="slice-label">
                  支出<br />
                  NT$ {currentMonth.expenses.toLocaleString()}
                </div>
              </div>
              <div className="pie-center">
                <div className="center-value">NT$ {currentMonth.revenue.toLocaleString()}</div>
                <div className="center-label">總營收</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* 交易記錄 */}
      <div className="transactions-container-4d">
        <div className="transactions-header">
          <h3 className="transactions-title">最近交易記錄</h3>
          <div className="filter-controls">
            <button className="filter-btn active">全部</button>
            <button className="filter-btn">收入</button>
            <button className="filter-btn">支出</button>
          </div>
        </div>

        <div className="transactions-list-4d">
          {transactions.map((transaction, index) => (
            <div
              key={transaction.id}
              className={`transaction-card-4d ${transaction.type}`}
              style={{ '--delay': `${index * 0.1}s` } as React.CSSProperties}
            >
              <div className="transaction-icon">
                {transaction.type === 'income' ? '💰' : '💸'}
              </div>

              <div className="transaction-details">
                <div className="transaction-description">{transaction.description}</div>
                <div className="transaction-meta">
                  <span className="transaction-date">{transaction.date.toLocaleDateString('zh-TW')}</span>
                  <span className="transaction-category">{transaction.category}</span>
                </div>
              </div>

              <div className={`transaction-amount ${transaction.type}`}>
                {transaction.type === 'income' ? '+' : '-'}
                NT$ {transaction.amount.toLocaleString()}
              </div>

              <div className="transaction-glow"></div>
            </div>
          ))}
        </div>
      </div>

      {/* 財務健康度儀表板 */}
      <div className="health-dashboard-4d">
        <h3 className="dashboard-title">財務健康度監控</h3>

        <div className="health-metrics">
          <div className="health-metric">
            <div className="metric-label">現金流狀態</div>
            <div className="metric-gauge">
              <div className="gauge-fill" style={{ width: '78%' }}></div>
              <div className="gauge-value">良好</div>
            </div>
          </div>

          <div className="health-metric">
            <div className="metric-label">成本控制</div>
            <div className="metric-gauge">
              <div className="gauge-fill" style={{ width: '85%' }}></div>
              <div className="gauge-value">優秀</div>
            </div>
          </div>

          <div className="health-metric">
            <div className="metric-label">獲利能力</div>
            <div className="metric-gauge">
              <div className="gauge-fill" style={{ width: '72%' }}></div>
              <div className="gauge-value">良好</div>
            </div>
          </div>

          <div className="health-metric">
            <div className="metric-label">增長趨勢</div>
            <div className="metric-gauge">
              <div className="gauge-fill" style={{ width: '90%' }}></div>
              <div className="gauge-value">優秀</div>
            </div>
          </div>
        </div>
      </div>

      {/* 4D 掃描線效果 */}
      <div className="scanner-overlay">
        <div className="scan-line-horizontal"></div>
        <div className="scan-line-vertical"></div>
      </div>        </div>
  );
};

export default FinancialAnalysis4D;
