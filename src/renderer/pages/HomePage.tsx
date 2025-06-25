import React from 'react';
import ApiStatusCard from '../components/ApiStatusCard';
import BannerNotice from '../components/BannerNotice';
import logo from '../assets/logo.svg';

const HomePage: React.FC = () => (
    <div style={{ maxWidth: 900, margin: '0 auto', padding: 24 }}>
        <img src={logo} alt="Jy技術團隊LOGO" style={{ height: 60, margin: '0 auto', display: 'block', filter: 'drop-shadow(0 0 12px #2676ff)' }} />
        <h1 className="neon" style={{ textAlign: 'center', fontSize: 36, margin: '16px 0 8px' }}>智慧瓦斯AI管理系統</h1>
        <BannerNotice message="歡迎使用企業級智慧瓦斯AI管理系統，請注意API流量與健康狀態！" />
        <ApiStatusCard />
        <div className="card" style={{ margin: '32px 0', padding: 24 }}>
            <h2 style={{ fontSize: 24, marginBottom: 12 }}>系統功能總覽</h2>
            <ul style={{ fontSize: 18, lineHeight: 2 }}>
                <li>💰 帳務管理、成本分析</li>
                <li>🛠️ 派工、維修、FAQ、優惠活動</li>
                <li>👥 員工/用戶/權限分級管理</li>
                <li>📦 設備/分裝廠分析、查詢歷史</li>
                <li>🤖 AI 智能查詢與自動分流</li>
                <li>📱 RWD 響應式設計，支援手機/平板/桌面</li>
            </ul>
        </div>
    </div>
);
export default HomePage;
