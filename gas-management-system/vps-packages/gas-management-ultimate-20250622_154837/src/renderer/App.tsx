import React, { useState, useEffect } from 'react';
import { LoginPage } from './pages/LoginPage';
import { Dashboard } from './pages/Dashboard';
import { TitleBar } from './components/TitleBar';
import { Sidebar } from './components/Sidebar';
import { ProductManagement } from './pages/ProductManagement';
import { OrderManagement } from './pages/OrderManagement';
import { CustomerManagement } from './pages/CustomerManagement';
import { FinancialAnalysis } from './pages/FinancialAnalysis';
import { AIAssistant } from './components/AIAssistant';
import { User } from '../types';
import './styles/App.css';

export const App: React.FC = () => {
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [currentPage, setCurrentPage] = useState<string>('dashboard');
  const [isAIOpen, setIsAIOpen] = useState<boolean>(false);

  useEffect(() => {
    // 检查是否有已保存的登录状态
    const savedUser = localStorage.getItem('currentUser');
    if (savedUser) {
      setCurrentUser(JSON.parse(savedUser));
    }
  }, []);

  const handleLogin = (user: User) => {
    setCurrentUser(user);
    localStorage.setItem('currentUser', JSON.stringify(user));
  };

  const handleLogout = () => {
    setCurrentUser(null);
    localStorage.removeItem('currentUser');
    setCurrentPage('dashboard');
  };
  const renderCurrentPage = () => {
    switch (currentPage) {
      case 'dashboard':
        return <Dashboard />;
      case 'products':
        return <ProductManagement />;
      case 'orders':
        return <OrderManagement />;      case 'customers':
        return <CustomerManagement />;
      case 'financial':
        return <FinancialAnalysis />;
      default:
        return <Dashboard />;
    }
  };

  if (!currentUser) {
    return (
      <div className="app">
        <TitleBar />
        <LoginPage onLogin={handleLogin} />
      </div>
    );
  }

  return (
    <div className="app">
      <TitleBar />
      <div className="app-body">
        <Sidebar 
          currentPage={currentPage}
          onPageChange={setCurrentPage}
          user={currentUser}
          onLogout={handleLogout}
          onAIToggle={() => setIsAIOpen(!isAIOpen)}
        />
        <main className="main-content">
          {renderCurrentPage()}
        </main>
        {isAIOpen && (
          <AIAssistant 
            onClose={() => setIsAIOpen(false)}
            user={currentUser}
          />
        )}
      </div>
        {/* 开发者信息 */}
      <div className="developer-info">
        <span>Powered by Jy技術團隊 © 2025</span>
      </div>
    </div>
  );
};
