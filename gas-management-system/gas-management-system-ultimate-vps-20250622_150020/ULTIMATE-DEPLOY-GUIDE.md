# 瓦斯管理系统 - VPS终极部署指南

## 🚀 快速部署 (推荐)

### 一行命令部署
```bash
unzip gas-management-system-ultimate-vps-*.zip
cd gas-management-system-ultimate-vps-*
chmod +x *.sh && sudo ./deploy-ultimate.sh
```

### 部署后访问
- 公网访问: `http://你的VPS_IP`
- 本地访问: `http://localhost`

## 📦 包内容说明

此VPS包包含以下完整内容：

### 🔧 核心应用文件
- `src/` - 完整源代码 (26个文件)
- `assets/` - 静态资源文件 (11个文件)
- `package.json` - 项目配置
- `package-lock.json` - 依赖锁定文件
- `tsconfig.json` - TypeScript配置
- `webpack.config.js` - 构建配置

### 🚀 部署脚本
- `deploy-ultimate.sh` - 一键部署脚本
- `deploy-vps-linux.sh` - Linux VPS部署
- `quick-deploy-linux.sh` - 快速部署
- `docker-compose.vps.yml` - Docker配置
- `Dockerfile.vps` - Docker镜像

### 🌐 外部访问工具
- `external-access-manager.sh` - 交互式管理中心
- `deploy-external-access.sh` - 一键外部访问配置
- `configure-external-access.sh` - 基础配置
- `setup-ssl-certificate.sh` - SSL证书配置
- `troubleshoot-external-access.sh` - 故障排除

### 🤖 AI配置工具
- `auto-setup-ai-model.sh` - AI模型自动配置
- `setup-ai-for-vps.sh` - VPS AI配置
- `diagnose-ai-connection.sh` - AI连接诊断

### ⚡ 性能优化工具
- `optimize-vps-performance.sh` - 性能优化
- `quick-optimize.sh` - 快速优化

### 📚 完整文档
- `README.md` - 项目说明
- `VPS-DEPLOYMENT-GUIDE.md` - VPS部署指南
- `EXTERNAL-ACCESS-GUIDE.md` - 外部访问指南
- `AI-MODEL-GUIDE.md` - AI模型指南
- 其他详细文档...

## 🛠️ 手动部署步骤

如果需要手动部署，请按以下步骤操作：

### 1. 环境准备
```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash -
sudo apt-get install -y nodejs

# 安装系统依赖
sudo apt-get install -y nginx certbot python3-certbot-nginx ufw git
```

### 2. 项目配置
```bash
# 安装项目依赖
npm install --production

# 构建项目 (如果需要)
npm run build
```

### 3. 系统服务配置
```bash
# 配置防火墙
sudo ufw allow 22 && sudo ufw allow 80 && sudo ufw allow 443 && sudo ufw allow 3000
sudo ufw enable

# 启动Nginx
sudo systemctl enable nginx && sudo systemctl start nginx
```

### 4. 外部访问配置
```bash
# 快速配置外部访问
./external-access-manager.sh

# 或使用一键脚本
./deploy-external-access.sh
```

## 🔧 管理命令

### 服务管理
```bash
# 查看服务状态
sudo systemctl status gas-management

# 重启服务
sudo systemctl restart gas-management

# 查看日志
sudo journalctl -u gas-management -f
```

### 外部访问管理
```bash
# 交互式管理中心
./external-access-manager.sh

# 快速外部访问设置
./quick-external-access.sh

# 故障排除
./troubleshoot-external-access.sh
```

### 性能优化
```bash
# 一键优化
./quick-optimize.sh

# 详细优化
./optimize-vps-performance.sh
```

### SSL证书配置
```bash
# 配置SSL证书
./setup-ssl-certificate.sh your-domain.com
```

## 🩺 故障排除

如果遇到问题，请按顺序检查：

1. **运行诊断脚本**
   ```bash
   ./troubleshoot-external-access.sh
   ```

2. **检查服务状态**
   ```bash
   sudo systemctl status gas-management
   sudo systemctl status nginx
   ```

3. **查看日志**
   ```bash
   sudo journalctl -u gas-management -f
   sudo tail -f /var/log/nginx/error.log
   ```

4. **检查网络连接**
   ```bash
   ./test-network-connectivity.sh
   ```

5. **检查防火墙**
   ```bash
   sudo ufw status
   ```

## 📊 包统计信息

- **总文件数**: 88个文件
- **包含源代码**: 完整的src目录
- **包含资源**: 完整的assets目录
- **部署脚本**: 13个专业脚本
- **文档文件**: 18个详细文档
- **配置文件**: 所有必要配置

## ✅ 验证部署

部署完成后，请访问以下地址验证：

- 🌐 公网访问: `http://你的VPS_IP`
- 🏠 本地访问: `http://localhost`
- 🔒 HTTPS访问: `https://你的域名` (配置SSL后)

## 🎯 下一步

部署成功后，您可以：

1. 配置域名和SSL证书
2. 设置外部访问权限
3. 配置AI模型功能
4. 优化系统性能
5. 设置定期备份

---

**🎉 恭喜！您已成功部署瓦斯管理系统到VPS！**

本包包含完整的应用程序和所有必要的部署工具，可以实现真正的一键部署。
