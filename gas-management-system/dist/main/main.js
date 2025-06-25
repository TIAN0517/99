"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const electron_1 = require("electron");
const path = require("path");
class GasManagementApp {
    constructor() {
        this.mainWindow = null;
        this.createWindow = this.createWindow.bind(this);
        this.initializeApp();
    }
    initializeApp() {
        // 当 Electron 完成初始化并准备创建浏览器窗口时调用此方法
        electron_1.app.whenReady().then(() => {
            this.createWindow();
            // 在 macOS 上，当应用图标被点击时重新创建窗口
            electron_1.app.on('activate', () => {
                if (electron_1.BrowserWindow.getAllWindows().length === 0) {
                    this.createWindow();
                }
            });
        });
        // 当所有窗口都关闭时退出应用
        electron_1.app.on('window-all-closed', () => {
            if (process.platform !== 'darwin') {
                electron_1.app.quit();
            }
        });
        // 注册 IPC 处理程序
        this.registerIpcHandlers();
    }
    createWindow() {
        // 创建主窗口 - 现代化无边框设计
        this.mainWindow = new electron_1.BrowserWindow({
            width: 1400,
            height: 900,
            minWidth: 1200,
            minHeight: 800,
            frame: false, // 无边框设计
            transparent: true, // 透明窗口
            titleBarStyle: 'hidden',
            title: 'Jy技術團隊 - 瓦斯行管理系統 2025',
            webPreferences: {
                nodeIntegration: false,
                contextIsolation: true,
                preload: path.join(__dirname, '../preload.js'),
            },
            icon: path.join(__dirname, '../../assets/icons/icon.svg'),
            show: false, // 先不显示，等加载完成后再显示
        });
        // 加载应用
        if (process.env.NODE_ENV === 'development') {
            this.mainWindow.loadURL('http://localhost:3000');
            this.mainWindow.webContents.openDevTools();
        }
        else {
            this.mainWindow.loadFile(path.join(__dirname, '../../dist/index.html'));
        }
        // 窗口准备显示时显示
        this.mainWindow.once('ready-to-show', () => {
            this.mainWindow?.show();
            // 添加启动动画
            this.mainWindow?.webContents.executeJavaScript(`
        document.body.style.opacity = '0';
        document.body.style.transform = 'scale(0.95)';
        document.body.style.transition = 'all 0.3s ease-out';
        setTimeout(() => {
          document.body.style.opacity = '1';
          document.body.style.transform = 'scale(1)';
        }, 100);
      `);
        });
        this.mainWindow.on('closed', () => {
            this.mainWindow = null;
        });
        // 设置自定义菜单
        this.setApplicationMenu();
    }
    setApplicationMenu() {
        const template = [
            {
                label: '瓦斯行管理系统',
                submenu: [
                    { label: '关于', role: 'about' },
                    { type: 'separator' },
                    { label: '退出', accelerator: 'CmdOrCtrl+Q', role: 'quit' }
                ]
            },
            {
                label: '编辑',
                submenu: [
                    { label: '撤销', accelerator: 'CmdOrCtrl+Z', role: 'undo' },
                    { label: '重做', accelerator: 'Shift+CmdOrCtrl+Z', role: 'redo' },
                    { type: 'separator' },
                    { label: '剪切', accelerator: 'CmdOrCtrl+X', role: 'cut' },
                    { label: '复制', accelerator: 'CmdOrCtrl+C', role: 'copy' },
                    { label: '粘贴', accelerator: 'CmdOrCtrl+V', role: 'paste' }
                ]
            },
            {
                label: '窗口',
                submenu: [
                    { label: '最小化', accelerator: 'CmdOrCtrl+M', role: 'minimize' },
                    { label: '关闭', accelerator: 'CmdOrCtrl+W', role: 'close' }
                ]
            }
        ];
        const menu = electron_1.Menu.buildFromTemplate(template);
        electron_1.Menu.setApplicationMenu(menu);
    }
    registerIpcHandlers() {
        // 窗口控制
        electron_1.ipcMain.handle('window-minimize', () => {
            this.mainWindow?.minimize();
        });
        electron_1.ipcMain.handle('window-maximize', () => {
            if (this.mainWindow?.isMaximized()) {
                this.mainWindow.unmaximize();
            }
            else {
                this.mainWindow?.maximize();
            }
        });
        electron_1.ipcMain.handle('window-close', () => {
            this.mainWindow?.close();
        });
        // Ollama AI 集成
        electron_1.ipcMain.handle('ollama-chat', async (event, message) => {
            try {
                // 这里将集成 Ollama API 调用
                const response = await this.callOllamaAPI(message);
                return response;
            }
            catch (error) {
                console.error('Ollama API Error:', error);
                return { error: '董娘的助理暂时无法回应，请稍后再试。' };
            }
        });
    }
    async callOllamaAPI(message) {
        try {
            // 調用本地 Ollama 服務
            const response = await fetch('http://localhost:11434/api/generate', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }, body: JSON.stringify({
                    model: 'deepseek-r1:8b',
                    prompt: `你是"董娘的助理"，專門為瓦斯行業務設計的AI助手。用戶問題：${message}\n\n請用繁體中文回答：`,
                    stream: false,
                    options: {
                        temperature: 0.7,
                        max_tokens: 300,
                    }
                }),
            });
            if (response.ok) {
                const data = await response.json();
                return {
                    message: data.response || '抱歉，我現在無法回應。',
                    timestamp: new Date().toISOString()
                };
            }
        }
        catch (error) {
            console.error('Ollama API call failed:', error);
        }
        // 如果 Ollama 不可用，使用模擬回應
        const mockResponses = [
            `關於"${message}"，根據我的瓦斯行業務經驗，建議您可以從以下幾個方面來處理...`,
            `您提到的"${message}"是很常見的問題。在瓦斯行業中，我們通常這樣解決...`,
            `針對"${message}"，我建議您先檢查庫存狀況，然後評估客戶需求...`,
            `這個"${message}"的問題，建議您可以參考我們的標準作業流程...`,
        ];
        const randomResponse = mockResponses[Math.floor(Math.random() * mockResponses.length)];
        return {
            message: randomResponse,
            timestamp: new Date().toISOString(),
            note: '(模擬回應 - 請安裝 Ollama 以獲得完整 AI 功能)'
        };
    }
}
// 启动应用
new GasManagementApp();
