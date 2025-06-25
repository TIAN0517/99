import React from 'react';
const BannerNotice: React.FC<{ message: string }> = ({ message }) => (
    <div style={{ background: 'linear-gradient(90deg,#2676ff,#ff9a3c)', color: '#fff', padding: '10px 0', textAlign: 'center', fontWeight: 'bold', fontSize: 18, letterSpacing: 2, boxShadow: '0 2px 12px #2676ff' }}>📢 {message}</div>
);
export default BannerNotice;
