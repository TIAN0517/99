import React, { useState } from 'react';
import './styles/theme.css';
import HomePage from './pages/HomePage';
import ModulesPage from './pages/ModulesPage';
import DashboardPage from './pages/DashboardPage';
import LoginPage from './pages/LoginPage';

const PAGES = [
    { name: '首頁', component: HomePage },
    { name: '儀表板', component: DashboardPage },
    { name: '功能模組', component: ModulesPage },
];

const App: React.FC = () => {
    const [page, setPage] = useState(0);
    const [user, setUser] = useState<{ name: string, role: string, avatar: string } | null>(null);
    return (
        <div>
            <nav style={{ display: 'flex', alignItems: 'center', gap: 24, background: '#181c2b', padding: '12px 32px', boxShadow: '0 2px 12px #2676ff' }}>
                <img src={require('./assets/logo.svg')} alt="LOGO" style={{ height: 40 }} />
                <div style={{ fontFamily: 'Orbitron', fontSize: 28, color: '#2676ff', fontWeight: 'bold', letterSpacing: 2, textShadow: '0 0 8px #ff9a3c' }}>Jy技術團隊</div>
                <div style={{ flex: 1 }} />
                {PAGES.map((p, i) => (<button key={p.name} className="btn-primary" style={{ marginRight: 8 }} onClick={() => setPage(i)}>{p.name}</button>))}
                {user && <div style={{ marginLeft: 16, fontSize: 18 }}>{user.avatar} {user.name} <span style={{ color: '#ff9a3c', fontSize: 14 }}>({user.role})</span></div>}
            </nav>
            {!user ? <LoginPage onLogin={setUser} /> : React.createElement(PAGES[page].component)}
        </div>
    );
};
export default App;
