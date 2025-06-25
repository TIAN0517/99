import React, { useState, useEffect } from 'react';
import './AccountingSystem.css';

interface Transaction {
  id: string;
  date: Date;
  type: 'income' | 'expense';
  category: string;
  description: string;
  amount: number;
  customerName?: string;
  invoiceNumber?: string;
  paymentMethod: string;
  status: 'completed' | 'pending' | 'cancelled';
}

interface AccountingReport {
  totalIncome: number;
  totalExpenses: number;
  netProfit: number;
  grossProfit: number;
  operatingExpenses: number;
  taxableIncome: number;
}

const AccountingSystem: React.FC = () => {
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [showAddModal, setShowAddModal] = useState(false);
  const [viewMode, setViewMode] = useState<'transactions' | 'reports' | 'analysis'>('transactions');
  const [dateFilter, setDateFilter] = useState<'today' | 'week' | 'month' | 'year' | 'custom'>('month');
  const [categoryFilter, setCategoryFilter] = useState<string>('all');

  const [newTransaction, setNewTransaction] = useState<Partial<Transaction>>({
    type: 'income',
    category: '',
    description: '',
    amount: 0,
    customerName: '',
    paymentMethod: 'cash',
    status: 'completed'
  });

  // 收入類別
  const incomeCategories = [
    '瓦斯銷售',
    '設備安裝',
    '維修服務',
    '配送費用',
    '租賃收入',
    '其他收入'
  ];

  // 支出類別
  const expenseCategories = [
    '商品採購',
    '運輸費用',
    '人工成本',
    '租金水電',
    '設備維護',
    '行銷廣告',
    '保險費用',
    '稅費',
    '其他支出'
  ];

  // 模擬數據
  useEffect(() => {
    const mockTransactions: Transaction[] = [
      {
        id: '1',
        date: new Date('2025-06-22'),
        type: 'income',
        category: '瓦斯銷售',
        description: '20kg瓦斯鋼瓶銷售',
        amount: 15000,
        customerName: '王大明',
        invoiceNumber: 'INV-2025-001',
        paymentMethod: 'cash',
        status: 'completed'
      },
      {
        id: '2',
        date: new Date('2025-06-22'),
        type: 'expense',
        category: '商品採購',
        description: '瓦斯補貨',
        amount: 8000,
        paymentMethod: 'transfer',
        status: 'completed'
      },
      {
        id: '3',
        date: new Date('2025-06-21'),
        type: 'income',
        category: '設備安裝',
        description: '瓦斯爐安裝服務',
        amount: 2500,
        customerName: '李小華',
        invoiceNumber: 'INV-2025-002',
        paymentMethod: 'card',
        status: 'completed'
      },
      {
        id: '4',
        date: new Date('2025-06-21'),
        type: 'expense',
        category: '運輸費用',
        description: '配送車輛油費',
        amount: 1200,
        paymentMethod: 'cash',
        status: 'completed'
      },
      {
        id: '5',
        date: new Date('2025-06-20'),
        type: 'income',
        category: '瓦斯銷售',
        description: '5kg瓦斯桶銷售',
        amount: 3200,
        customerName: '陳先生',
        invoiceNumber: 'INV-2025-003',
        paymentMethod: 'cash',
        status: 'pending'
      }
    ];
    setTransactions(mockTransactions);
  }, []);

  const addTransaction = () => {
    if (!newTransaction.category || !newTransaction.description || !newTransaction.amount) {
      alert('請填寫完整資料');
      return;
    }

    const transaction: Transaction = {
      id: Date.now().toString(),
      date: new Date(),
      type: newTransaction.type as 'income' | 'expense',
      category: newTransaction.category,
      description: newTransaction.description,
      amount: Number(newTransaction.amount),
      customerName: newTransaction.customerName || '',
      invoiceNumber: newTransaction.type === 'income' ? `INV-${Date.now()}` : '',
      paymentMethod: newTransaction.paymentMethod as string,
      status: newTransaction.status as 'completed' | 'pending' | 'cancelled'
    };

    setTransactions(prev => [transaction, ...prev]);
    setNewTransaction({
      type: 'income',
      category: '',
      description: '',
      amount: 0,
      customerName: '',
      paymentMethod: 'cash',
      status: 'completed'
    });
    setShowAddModal(false);
  };

  const deleteTransaction = (id: string) => {
    if (confirm('確定要刪除此筆交易記錄嗎？')) {
      setTransactions(prev => prev.filter(t => t.id !== id));
    }
  };

  const calculateReport = (): AccountingReport => {
    const filteredTransactions = getFilteredTransactions();

    const totalIncome = filteredTransactions
      .filter(t => t.type === 'income' && t.status === 'completed')
      .reduce((sum, t) => sum + t.amount, 0);

    const totalExpenses = filteredTransactions
      .filter(t => t.type === 'expense' && t.status === 'completed')
      .reduce((sum, t) => sum + t.amount, 0);

    const netProfit = totalIncome - totalExpenses;
    const grossProfit = totalIncome * 0.7; // 假設毛利率70%
    const operatingExpenses = totalExpenses * 0.8; // 假設營運費用占80%
    const taxableIncome = netProfit > 0 ? netProfit * 0.8 : 0; // 應稅所得

    return {
      totalIncome,
      totalExpenses,
      netProfit,
      grossProfit,
      operatingExpenses,
      taxableIncome
    };
  };

  const getFilteredTransactions = () => {
    let filtered = [...transactions];

    // 日期篩選
    const now = new Date();
    const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const startOfWeek = new Date(startOfToday.getTime() - 7 * 24 * 60 * 60 * 1000);
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    const startOfYear = new Date(now.getFullYear(), 0, 1);

    switch (dateFilter) {
      case 'today':
        filtered = filtered.filter(t => t.date >= startOfToday);
        break;
      case 'week':
        filtered = filtered.filter(t => t.date >= startOfWeek);
        break;
      case 'month':
        filtered = filtered.filter(t => t.date >= startOfMonth);
        break;
      case 'year':
        filtered = filtered.filter(t => t.date >= startOfYear);
        break;
    }

    // 類別篩選
    if (categoryFilter !== 'all') {
      filtered = filtered.filter(t => t.category === categoryFilter);
    }

    return filtered.sort((a, b) => b.date.getTime() - a.date.getTime());
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('zh-TW', {
      style: 'currency',
      currency: 'TWD'
    }).format(amount);
  };

  const formatDate = (date: Date) => {
    return date.toLocaleDateString('zh-TW', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit'
    });
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'completed': return '#27ae60';
      case 'pending': return '#f39c12';
      case 'cancelled': return '#e74c3c';
      default: return '#95a5a6';
    }
  };

  const getStatusText = (status: string) => {
    switch (status) {
      case 'completed': return '已完成';
      case 'pending': return '待處理';
      case 'cancelled': return '已取消';
      default: return '未知';
    }
  };

  const report = calculateReport();
  const filteredTransactions = getFilteredTransactions();

  return (
    <div className="accounting-system">
      <div className="accounting-header">
        <div className="header-title">
          <h2>💰 會計系統</h2>
          <p>財務管理與記帳系統</p>
        </div>

        <div className="header-actions">
          <div className="view-tabs">
            <button
              className={`tab-btn ${viewMode === 'transactions' ? 'active' : ''}`}
              onClick={() => setViewMode('transactions')}
            >
              📝 交易記錄
            </button>
            <button
              className={`tab-btn ${viewMode === 'reports' ? 'active' : ''}`}
              onClick={() => setViewMode('reports')}
            >
              📊 財務報表
            </button>
            <button
              className={`tab-btn ${viewMode === 'analysis' ? 'active' : ''}`}
              onClick={() => setViewMode('analysis')}
            >
              📈 數據分析
            </button>
          </div>

          <button
            className="add-transaction-btn"
            onClick={() => setShowAddModal(true)}
          >
            ➕ 新增交易
          </button>
        </div>
      </div>

      {/* 快速統計 */}
      <div className="quick-stats">
        <div className="stat-card income">
          <div className="stat-icon">💵</div>
          <div className="stat-info">
            <div className="stat-label">總收入</div>
            <div className="stat-value">{formatCurrency(report.totalIncome)}</div>
          </div>
        </div>

        <div className="stat-card expense">
          <div className="stat-icon">💸</div>
          <div className="stat-info">
            <div className="stat-label">總支出</div>
            <div className="stat-value">{formatCurrency(report.totalExpenses)}</div>
          </div>
        </div>

        <div className="stat-card profit">
          <div className="stat-icon">💰</div>
          <div className="stat-info">
            <div className="stat-label">淨利潤</div>
            <div className={`stat-value ${report.netProfit >= 0 ? 'positive' : 'negative'}`}>
              {formatCurrency(report.netProfit)}
            </div>
          </div>
        </div>

        <div className="stat-card ratio">
          <div className="stat-icon">📊</div>
          <div className="stat-info">
            <div className="stat-label">利潤率</div>
            <div className={`stat-value ${report.netProfit >= 0 ? 'positive' : 'negative'}`}>
              {report.totalIncome > 0 ? ((report.netProfit / report.totalIncome) * 100).toFixed(1) : '0.0'}%
            </div>
          </div>
        </div>
      </div>

      {/* 主要內容區域 */}
      <div className="accounting-content">
        {viewMode === 'transactions' && (
          <div className="transactions-view">
            <div className="filters">
              <div className="filter-group">
                <label>日期範圍:</label>
                <select value={dateFilter} onChange={(e) => setDateFilter(e.target.value as any)}>
                  <option value="today">今天</option>
                  <option value="week">本週</option>
                  <option value="month">本月</option>
                  <option value="year">今年</option>
                </select>
              </div>

              <div className="filter-group">
                <label>類別:</label>
                <select value={categoryFilter} onChange={(e) => setCategoryFilter(e.target.value)}>
                  <option value="all">全部類別</option>
                  {[...incomeCategories, ...expenseCategories].map(cat => (
                    <option key={cat} value={cat}>{cat}</option>
                  ))}
                </select>
              </div>
            </div>

            <div className="transactions-table">
              <div className="table-header">
                <div className="col-date">日期</div>
                <div className="col-type">類型</div>
                <div className="col-category">類別</div>
                <div className="col-description">描述</div>
                <div className="col-amount">金額</div>
                <div className="col-customer">客戶</div>
                <div className="col-status">狀態</div>
                <div className="col-actions">操作</div>
              </div>

              <div className="table-body">
                {filteredTransactions.map(transaction => (
                  <div key={transaction.id} className="table-row">
                    <div className="col-date">{formatDate(transaction.date)}</div>
                    <div className={`col-type ${transaction.type}`}>
                      {transaction.type === 'income' ? '收入' : '支出'}
                    </div>
                    <div className="col-category">{transaction.category}</div>
                    <div className="col-description">{transaction.description}</div>
                    <div className={`col-amount ${transaction.type}`}>
                      {transaction.type === 'income' ? '+' : '-'}{formatCurrency(transaction.amount)}
                    </div>
                    <div className="col-customer">{transaction.customerName || '-'}</div>
                    <div className="col-status">
                      <span
                        className="status-badge"
                        style={{ backgroundColor: getStatusColor(transaction.status) }}
                      >
                        {getStatusText(transaction.status)}
                      </span>
                    </div>
                    <div className="col-actions">
                      <button
                        className="action-btn edit"
                        title="編輯"
                      >
                        ✏️
                      </button>
                      <button
                        className="action-btn delete"
                        onClick={() => deleteTransaction(transaction.id)}
                        title="刪除"
                      >
                        🗑️
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {viewMode === 'reports' && (
          <div className="reports-view">
            <div className="report-section">
              <h3>📋 財務摘要報表</h3>
              <div className="report-grid">
                <div className="report-item">
                  <div className="report-label">營業收入</div>
                  <div className="report-value positive">{formatCurrency(report.totalIncome)}</div>
                </div>
                <div className="report-item">
                  <div className="report-label">營業成本</div>
                  <div className="report-value negative">{formatCurrency(report.totalIncome - report.grossProfit)}</div>
                </div>
                <div className="report-item">
                  <div className="report-label">毛利</div>
                  <div className="report-value positive">{formatCurrency(report.grossProfit)}</div>
                </div>
                <div className="report-item">
                  <div className="report-label">營運費用</div>
                  <div className="report-value negative">{formatCurrency(report.operatingExpenses)}</div>
                </div>
                <div className="report-item">
                  <div className="report-label">稅前淨利</div>
                  <div className={`report-value ${report.netProfit >= 0 ? 'positive' : 'negative'}`}>
                    {formatCurrency(report.netProfit)}
                  </div>
                </div>
                <div className="report-item">
                  <div className="report-label">應稅所得</div>
                  <div className="report-value">{formatCurrency(report.taxableIncome)}</div>
                </div>
              </div>
            </div>

            <div className="report-section">
              <h3>📊 收支分析</h3>
              <div className="chart-placeholder">
                <div className="income-bar" style={{ width: '70%' }}>
                  <span>收入: {formatCurrency(report.totalIncome)}</span>
                </div>
                <div className="expense-bar" style={{ width: '45%' }}>
                  <span>支出: {formatCurrency(report.totalExpenses)}</span>
                </div>
              </div>
            </div>
          </div>
        )}

        {viewMode === 'analysis' && (
          <div className="analysis-view">
            <div className="analysis-section">
              <h3>📈 趨勢分析</h3>
              <p>本月財務表現良好，收入穩定增長。</p>
              <ul>
                <li>瓦斯銷售是主要收入來源，佔總收入的65%</li>
                <li>運輸成本控制良好，建議持續優化配送路線</li>
                <li>客戶付款及時率達95%，應收帳款風險較低</li>
                <li>建議加強設備安裝服務，提升整體利潤率</li>
              </ul>
            </div>
          </div>
        )}
      </div>

      {/* 新增交易模態框 */}
      {showAddModal && (
        <div className="modal-overlay">
          <div className="modal-content">
            <div className="modal-header">
              <h3>新增交易記錄</h3>
              <button onClick={() => setShowAddModal(false)}>✕</button>
            </div>

            <div className="modal-body">
              <div className="form-group">
                <label>交易類型:</label>
                <select
                  value={newTransaction.type}
                  onChange={(e) => setNewTransaction({ ...newTransaction, type: e.target.value as 'income' | 'expense' })}
                >
                  <option value="income">收入</option>
                  <option value="expense">支出</option>
                </select>
              </div>

              <div className="form-group">
                <label>類別:</label>
                <select
                  value={newTransaction.category}
                  onChange={(e) => setNewTransaction({ ...newTransaction, category: e.target.value })}
                >
                  <option value="">請選擇類別</option>
                  {(newTransaction.type === 'income' ? incomeCategories : expenseCategories).map(cat => (
                    <option key={cat} value={cat}>{cat}</option>
                  ))}
                </select>
              </div>

              <div className="form-group">
                <label>描述:</label>
                <input
                  type="text"
                  value={newTransaction.description}
                  onChange={(e) => setNewTransaction({ ...newTransaction, description: e.target.value })}
                  placeholder="請輸入交易描述"
                />
              </div>

              <div className="form-group">
                <label>金額:</label>
                <input
                  type="number"
                  value={newTransaction.amount}
                  onChange={(e) => setNewTransaction({ ...newTransaction, amount: Number(e.target.value) })}
                  placeholder="請輸入金額"
                />
              </div>

              {newTransaction.type === 'income' && (
                <div className="form-group">
                  <label>客戶姓名:</label>
                  <input
                    type="text"
                    value={newTransaction.customerName}
                    onChange={(e) => setNewTransaction({ ...newTransaction, customerName: e.target.value })}
                    placeholder="請輸入客戶姓名"
                  />
                </div>
              )}

              <div className="form-group">
                <label>付款方式:</label>
                <select
                  value={newTransaction.paymentMethod}
                  onChange={(e) => setNewTransaction({ ...newTransaction, paymentMethod: e.target.value })}
                >
                  <option value="cash">現金</option>
                  <option value="card">信用卡</option>
                  <option value="transfer">轉帳</option>
                  <option value="check">支票</option>
                </select>
              </div>

              <div className="form-group">
                <label>狀態:</label>
                <select
                  value={newTransaction.status}
                  onChange={(e) => setNewTransaction({ ...newTransaction, status: e.target.value as any })}
                >
                  <option value="completed">已完成</option>
                  <option value="pending">待處理</option>
                </select>
              </div>
            </div>

            <div className="modal-footer">
              <button onClick={() => setShowAddModal(false)} className="cancel-btn">
                取消
              </button>
              <button onClick={addTransaction} className="confirm-btn">
                新增
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default AccountingSystem;
