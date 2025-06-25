import React from 'react';
const modules = [
    { name: '帳務管理', desc: '查詢收支、發票、對帳、報表' },
    { name: '成本分析', desc: '瓦斯進貨、運輸、分裝、人工等成本' },
    { name: '派工管理', desc: '派工、維修、進度追蹤' },
    { name: 'FAQ', desc: '常見問題、知識庫' },
    { name: '優惠活動', desc: '促銷、折扣、會員活動' },
    { name: '員工管理', desc: '多用戶、權限分級、頭像' },
    { name: '設備管理', desc: '瓦斯桶、配送車、設備狀態' },
    { name: '分裝廠分析', desc: '分裝廠產能、庫存、效率' },
];
const ModulesPage: React.FC = () => (
    <div style={{ maxWidth: 900, margin: '0 auto', padding: 24 }}>
        <h2 className="neon" style={{ fontSize: 28, marginBottom: 24 }}>功能模組</h2>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 24 }}>
            {modules.map(m => (
                <div className="card" key={m.name} style={{ flex: '1 1 260px', minWidth: 220, padding: 20 }}>
                    <div style={{ fontWeight: 'bold', fontSize: 20, marginBottom: 8 }}>{m.name}</div>
                    <div style={{ color: '#ff9a3c' }}>{m.desc}</div>
                </div>
            ))}
        </div>
    </div>
);
export default ModulesPage;
