import { contextBridge, ipcRenderer } from 'electron';

// 暴露安全的 API 给渲染进程
contextBridge.exposeInMainWorld('electronAPI', {
    // 窗口控制
    window: {
        minimize: () => ipcRenderer.invoke('window-minimize'),
        maximize: () => ipcRenderer.invoke('window-maximize'),
        close: () => ipcRenderer.invoke('window-close'),
    },

    // AI 助理 (董娘的助理)
    ai: {
        chat: (message: string) => ipcRenderer.invoke('ollama-chat', message),
    },

    // 系统信息
    system: {
        platform: process.platform,
        version: process.versions.electron,
    },

    // 开发者信息
    developer: {
        team: 'Jy技术团队',
        aiName: '董娘的助理',
    },
});
