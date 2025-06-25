import React, { useEffect, useState } from 'react';
import { AI_CONFIG } from '../config';

const ApiStatusCard: React.FC = () => {
    const [status, setStatus] = useState<'ok' | 'error' | 'warning' | 'loading'>('loading');
    const [quota, setQuota] = useState<string>('--');
    const [msg, setMsg] = useState('');

    useEffect(() => {
        async function checkApi() {
            setStatus('loading');
            try {
                if (AI_CONFIG.provider === 'gemini') {
                    const res = await fetch('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-latest?key=' + AI_CONFIG.gemini.apiKey);
                    if (res.ok) {
                        setStatus('ok');
                        setMsg('Gemini API 正常');
                        setQuota('可用');
                    } else if (res.status === 429) {
                        setStatus('warning');
                        setMsg('API 流量用盡');
                        setQuota('已用盡');
                    } else {
                        setStatus('error');
                        setMsg('API 錯誤');
                        setQuota('--');
                    }
                }
                // 可擴充 deepseek/openai ...
            } catch {
                setStatus('error');
                setMsg('API 無法連線');
                setQuota('--');
            }
        }
        checkApi();
        const timer = setInterval(checkApi, 60000);
        return () => clearInterval(timer);
    }, []);

    return (
        <div className={`card api-status-card status-${status}`}
            style={{ padding: 20, marginBottom: 16, minWidth: 260, display: 'flex', alignItems: 'center', gap: 16 }}>
            <span style={{ fontSize: 28 }}>{status === 'ok' ? '✅' : status === 'loading' ? '⏳' : status === 'warning' ? '⚠️' : '❌'}</span>
            <div>
                <div style={{ fontWeight: 'bold' }}>API 狀態：{msg}</div>
                <div>流量：{quota}</div>
            </div>
        </div>
    );
};
export default ApiStatusCard;
