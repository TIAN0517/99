import React from 'react';
const DashboardPage: React.FC = () => (
    <div style={{ maxWidth: 900, margin: '0 auto', padding: 24 }}>
        <h2 className="neon" style={{ fontSize: 28, marginBottom: 24 }}>儀表板</h2>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 24 }}>
            <div className="card" style={{ flex: '1 1 260px', minWidth: 220, padding: 20 }}>
                <div style={{ fontWeight: 'bold', fontSize: 20, marginBottom: 8 }}>今日營收</div>
                <div style={{ fontSize: 32, color: '#2676ff', fontWeight: 'bold' }}>NT$ 32,500</div>
                <div style={{ color: '#ff9a3c' }}>較昨日 +8.2%</div>
            </div>
            <div className="card" style={{ flex: '1 1 260px', minWidth: 220, padding: 20 }}>
                <div style={{ fontWeight: 'bold', fontSize: 20, marginBottom: 8 }}>訂單數</div>
                <div style={{ fontSize: 32, color: '#2676ff', fontWeight: 'bold' }}>47</div>
                <div style={{ color: '#ff9a3c' }}>進行中 5</div>
            </div>
            <div className="card" style={{ flex: '1 1 260px', minWidth: 220, padding: 20 }}>
                <div style={{ fontWeight: 'bold', fontSize: 20, marginBottom: 8 }}>活躍客戶</div>
                <div style={{ fontSize: 32, color: '#2676ff', fontWeight: 'bold' }}>1,256</div>
                <div style={{ color: '#ff9a3c' }}>本月新增 32</div>
            </div>
            <div className="card" style={{ flex: '1 1 260px', minWidth: 220, padding: 20 }}>
                <div style={{ fontWeight: 'bold', fontSize: 20, marginBottom: 8 }}>庫存警示</div>
                <div style={{ fontSize: 32, color: '#ff9a3c', fontWeight: 'bold' }}>3</div>
                <div style={{ color: '#2676ff' }}>低於安全庫存</div>
            </div>
        </div>
    </div>
);
export default DashboardPage;
