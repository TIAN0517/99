import React, { useState } from 'react';
const LoginPage: React.FC<{ onLogin: (user: { name: string, role: string, avatar: string }) => void }> = ({ onLogin }) => {
    const [name, setName] = useState('');
    const [role, setRole] = useState('user');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);
    const avatars = [
        '🧑‍💼', '👩‍💼', '👨‍🔧', '👩‍🔧', '👨‍💻', '👩‍💻', '👨‍🚒', '👩‍🚒'
    ];
    const [avatar, setAvatar] = useState(avatars[0]);
    const handleLogin = () => {
        setLoading(true);
        setTimeout(() => {
            if (!name.trim()) {
                setError('請輸入用戶名'); setLoading(false); return;
            }
            onLogin({ name, role, avatar });
        }, 800);
    };
    return (
        <div style={{ maxWidth: 360, margin: '60px auto', padding: 32 }} className="card">
            <h2 className="neon" style={{ textAlign: 'center', marginBottom: 24 }}>用戶登入</h2>
            <div style={{ marginBottom: 12 }}>
                <input value={name} onChange={e => setName(e.target.value)} placeholder="用戶名" style={{ width: '100%', padding: 8, borderRadius: 6, border: '1px solid #2676ff', fontSize: 18 }} />
            </div>
            <div style={{ marginBottom: 12 }}>
                <select value={role} onChange={e => setRole(e.target.value)} style={{ width: '100%', padding: 8, borderRadius: 6, fontSize: 16 }}>
                    <option value="user">一般用戶</option>
                    <option value="manager">管理員</option>
                    <option value="staff">派工/維修</option>
                </select>
            </div>
            <div style={{ marginBottom: 12, display: 'flex', gap: 8 }}>
                {avatars.map(a => (<span key={a} style={{ fontSize: 28, cursor: 'pointer', border: a === avatar ? '2px solid #ff9a3c' : '2px solid transparent', borderRadius: 8, padding: 2 }} onClick={() => setAvatar(a)}>{a}</span>))}
            </div>
            {error && <div style={{ color: '#ff9a3c', marginBottom: 8 }}>{error}</div>}
            <button className="btn-primary" style={{ width: '100%', padding: 10, fontSize: 18 }} onClick={handleLogin} disabled={loading}>{loading ? '登入中...' : '登入'}</button>
        </div>
    );
};
export default LoginPage;
