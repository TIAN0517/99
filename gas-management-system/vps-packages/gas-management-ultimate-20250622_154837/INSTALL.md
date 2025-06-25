# Jy技術團隊 瓦斯行管理系統 2025 - VPS部署包

## 🚀 快速部署

### Linux/VPS 环境 (推荐)
```bash
# 解压部署包
unzip gas-management-ultimate-*.zip
cd gas-management-ultimate-*

# 一键部署
chmod +x quick-deploy.sh
./quick-deploy.sh
```

## 🌐 访问系统

部署完成后，通过以下地址访问：

- **本地访问**: http://localhost:3000
- **外网IP访问**: http://165.154.226.148:3000
- **域名访问**: http://lstjks.sytes.net:3000

### API访问
- **健康检查**: http://YOUR_VPS_IP:3000/health
- **系统信息**: http://YOUR_VPS_IP:3000/api/system
- **产品API**: http://YOUR_VPS_IP:3000/api/products

## 🌟 Enhanced Beautiful Edition v2.1 特色

- ✨ 完全还原 ProductManagement.tsx 原始设计
- 🎨 Enhanced 4D 科技感无边框界面
- 📱 Enhanced 完美响应式设计
- ⚡ Enhanced 即时资料载入与更新
- 📊 Enhanced 智能库存统计分析
- 🚀 Enhanced 流畅动画与过渡效果
- 💎 Enhanced Professional 级别视觉设计

## 📦 包含内容

- `gas-enhanced-beautiful-v2.js` - Enhanced Beautiful Edition 主程序
- `start-gas-web.js` - Web版本备用程序
- `package.json` - 项目配置和依赖
- `src/` - 完整源代码目录
- `quick-deploy.sh` - 一键部署脚本
- 完整文档和配置文件

## 🔧 管理命令

### 查看运行状态
```bash
# 查看日志
tail -f gas-enhanced.log

# 检查进程
ps aux | grep node

# 健康检查
curl http://localhost:3000/health
```

### 重启服务
```bash
# 停止服务
pkill -f "node.*gas"

# 重新启动
./quick-deploy.sh
```

## 📞 技术支持

- **开发团队**: Jy技術團隊
- **项目年份**: 2025
- **版本**: Enhanced Beautiful Edition v2.1
- **外网IP**: 165.154.226.148:3000
- **域名**: lstjks.sytes.net:3000

---
**© 2025 Jy技術團隊 - 专业的瓦斯行管理解决方案**
