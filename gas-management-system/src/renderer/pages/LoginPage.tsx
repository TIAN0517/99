import React, { useState } from 'react';
import { User } from '../../types';
import './LoginPage.css';

interface LoginPageProps {
    onLogin: (user: User) => void;
}

export const LoginPage: React.FC<LoginPageProps> = ({ onLogin }) => {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState('');

    // 模擬用戶數據
    const mockUsers: User[] = [
        {
            id: '1',
            username: 'admin',
            role: 'admin',
            name: '系統管理員',
            lastLogin: new Date(),
        },
        {
            id: '2',
            username: 'manager',
            role: 'manager',
            name: '店長',
            lastLogin: new Date(),
        },
        {
            id: '3',
            username: 'employee',
            role: 'employee',
            name: '員工',
            lastLogin: new Date(),
        },
    ];

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setIsLoading(true);
        setError('');

        // 模擬登入驗證
        await new Promise(resolve => setTimeout(resolve, 1500));

        const user = mockUsers.find(u => u.username === username);

        if (user && (password === 'password' || password === '123456')) {
            onLogin({
                ...user,
                lastLogin: new Date(),
            });
        } else {
            setError('用戶名或密碼錯誤');
        }

        setIsLoading(false);
    };

    return (
        <div className="login-page">
            <div className="login-background">
                <div className="bg-animation"></div>
                <div className="bg-particles"></div>
            </div>

            <div className="login-container">
                <div className="login-card">
                    {/* 標題區域 */}
                    <div className="login-header">
                        <div className="app-logo">
                            <div className="logo-icon">⚡</div>
                            <div className="logo-glow"></div>
                        </div>
                        <h1 className="app-title">瓦斯行管理系統</h1>
                        <p className="app-subtitle">現代化智能管理平台</p>
                    </div>

                    {/* 登入表單 */}
                    <form className="login-form" onSubmit={handleSubmit}>
                        <div className="form-group">
                            <label className="form-label">用戶名</label>
                            <div className="input-wrapper">
                                <span className="input-icon">👤</span>
                                <input
                                    type="text"
                                    className="form-input"
                                    value={username}
                                    onChange={(e) => setUsername(e.target.value)}
                                    placeholder="請輸入用戶名"
                                    required
                                />
                            </div>
                        </div>

                        <div className="form-group">
                            <label className="form-label">密碼</label>
                            <div className="input-wrapper">
                                <span className="input-icon">🔒</span>
                                <input
                                    type="password"
                                    className="form-input"
                                    value={password}
                                    onChange={(e) => setPassword(e.target.value)}
                                    placeholder="請輸入密碼"
                                    required
                                />
                            </div>
                        </div>

                        {error && (
                            <div className="error-message">
                                <span className="error-icon">⚠️</span>
                                {error}
                            </div>
                        )}

                        <button
                            type="submit"
                            className={`login-btn ${isLoading ? 'loading' : ''}`}
                            disabled={isLoading}
                        >
                            {isLoading ? (
                                <>
                                    <span className="loading-spinner"></span>
                                    正在登入...
                                </>
                            ) : (
                                '登入系統'
                            )}
                        </button>          </form>          {/* 開發者資訊 */}
                    <div className="developer-credit">
                        <span>Powered by</span>
                        <strong>Jy技術團隊 © 2025</strong>
                    </div>
                </div>
            </div>
        </div>
    );
};
