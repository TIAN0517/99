import React from 'react';
import { User } from '../../types';
import './Sidebar.css';

interface SidebarProps {
  currentPage: string;
  onPageChange: (page: string) => void;
  user: User;
  onLogout: () => void;
  onAIToggle: () => void;
}

export const Sidebar: React.FC<SidebarProps> = ({
  currentPage,
  onPageChange,
  user,
  onLogout,
  onAIToggle,
}) => {
  const menuItems = [
    { id: 'dashboard', label: '儀表板', icon: '📊' },
    { id: 'products', label: '產品管理', icon: '🛢️' },
    { id: 'orders', label: '訂單管理', icon: '📋' },
    { id: 'customers', label: '客戶管理', icon: '👥' },
    { id: 'financial', label: '財務分析', icon: '💰' },
  ];

  return (
    <div className="sidebar">
      {/* 用戶資訊 */}
      <div className="user-profile">
        <div className="user-avatar">
          {user.avatar ? (
            <img src={user.avatar} alt={user.name} />
          ) : (
            <div className="avatar-placeholder">
              {user.name.charAt(0).toUpperCase()}
            </div>
          )}
        </div>
        <div className="user-info">
          <div className="user-name">{user.name}</div>
          <div className="user-role">{user.role === 'admin' ? '管理員' : user.role === 'manager' ? '經理' : '員工'}</div>
        </div>
        <div className="user-status">
          <div className="status-indicator online"></div>
        </div>
      </div>

      {/* 導航選單 */}
      <nav className="sidebar-nav">
        <ul className="nav-list">
          {menuItems.map((item) => (
            <li key={item.id} className="nav-item">
              <button
                className={`nav-link ${currentPage === item.id ? 'active' : ''}`}
                onClick={() => onPageChange(item.id)}
              >
                <span className="nav-icon">{item.icon}</span>
                <span className="nav-label">{item.label}</span>
                {currentPage === item.id && <div className="active-indicator"></div>}
              </button>
            </li>
          ))}
        </ul>
      </nav>

      {/* AI 助理按鈕 */}
      <div className="ai-section">
        <button className="ai-toggle-btn" onClick={onAIToggle}>
          <span className="ai-icon">🤖</span>
          <span className="ai-label">董娘的助理</span>
          <div className="ai-pulse"></div>
        </button>
      </div>

      {/* 系統資訊 */}
      <div className="system-info">
        <div className="info-item">
          <span className="info-label">系統版本</span>
          <span className="info-value">v1.0.0</span>
        </div>
        <div className="info-item">
          <span className="info-label">平台</span>
          <span className="info-value">{window.electronAPI.system.platform}</span>
        </div>
      </div>

      {/* 登出按鈕 */}
      <div className="sidebar-footer">
        <button className="logout-btn" onClick={onLogout}>
          <span className="logout-icon">🚪</span>
          <span className="logout-label">登出</span>
        </button>
      </div>
    </div>
  );
};
