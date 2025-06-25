import React from 'react';
import './TitleBar.css';

export const TitleBar: React.FC = () => {
  const handleMinimize = async () => {
    await window.electronAPI.window.minimize();
  };

  const handleMaximize = async () => {
    await window.electronAPI.window.maximize();
  };

  const handleClose = async () => {
    await window.electronAPI.window.close();
  };

  return (
    <div className="title-bar">
      <div className="title-bar-content">        <div className="app-info">
          <div className="app-icon">⚡</div>
          <span className="app-title">Jy技術團隊 - 瓦斯行管理系統 2025</span>
          <span className="app-version">v1.0.0</span>
        </div>
        
        <div className="window-controls">
          <button 
            className="control-btn minimize-btn" 
            onClick={handleMinimize}
            title="最小化"
          >
            <svg width="12" height="12" viewBox="0 0 12 12">
              <path d="M2 6h8" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
            </svg>
          </button>
          
          <button 
            className="control-btn maximize-btn" 
            onClick={handleMaximize}
            title="最大化/還原"
          >
            <svg width="12" height="12" viewBox="0 0 12 12">
              <path 
                d="M3 3h6v6H3z" 
                fill="none" 
                stroke="currentColor" 
                strokeWidth="1.5"
              />
            </svg>
          </button>
          
          <button 
            className="control-btn close-btn" 
            onClick={handleClose}
            title="關閉"
          >
            <svg width="12" height="12" viewBox="0 0 12 12">
              <path 
                d="M3 3l6 6M9 3l-6 6" 
                stroke="currentColor" 
                strokeWidth="1.5" 
                strokeLinecap="round"
              />
            </svg>
          </button>
        </div>
      </div>
    </div>
  );
};
