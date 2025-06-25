# 瓦斯行管理系统 - 外网访问配置指南

> **Jy技術團隊 2025** - 专业瓦斯行管理解决方案

## 🚀 快速开始

### 一键配置外网访问

```bash
# 1. 下载并运行外网配置脚本
sudo chmod +x configure-external-access.sh
sudo ./configure-external-access.sh

# 2. 测试网络连通性
sudo chmod +x test-network-connectivity.sh
sudo ./test-network-connectivity.sh

# 3. (可选) 配置SSL证书
sudo chmod +x setup-ssl-certificate.sh
sudo ./setup-ssl-certificate.sh
```

## 🔧 配置步骤详解

### 第一步：配置服务器防火墙和网络

运行主配置脚本：
```bash
sudo ./configure-external-access.sh
```

此脚本将自动：
- ✅ 检测并配置防火墙规则
- ✅ 配置应用监听所有网络接口
- ✅ 创建和启动系统服务
- ✅ 验证网络配置

### 第二步：配置云服务商安全组

## 🛡️ 各大云服务商安全组设置

### 阿里云 ECS

1. **登录阿里云控制台**
   - 进入 ECS 控制台
   - 选择您的 ECS 实例

2. **配置安全组**
   - 点击"安全组" → "配置规则"
   - 添加入方向规则：

   | 授权策略 | 优先级 | 协议类型 | 端口范围 | 授权对象 | 描述 |
   |---------|--------|----------|----------|----------|------|
   | 允许 | 100 | TCP | 3000/3000 | 0.0.0.0/0 | 瓦斯管理系统 |
   | 允许 | 100 | TCP | 80/80 | 0.0.0.0/0 | HTTP |
   | 允许 | 100 | TCP | 443/443 | 0.0.0.0/0 | HTTPS |

### 腾讯云 CVM

1. **登录腾讯云控制台**
   - 进入 CVM 控制台
   - 选择您的 CVM 实例

2. **配置安全组**
   - 点击"安全组" → "修改规则"
   - 添加入站规则：

   | 类型 | 来源 | 协议端口 | 策略 | 备注 |
   |------|------|----------|------|------|
   | 自定义 | 0.0.0.0/0 | TCP:3000 | 允许 | 瓦斯管理系统 |
   | HTTP | 0.0.0.0/0 | TCP:80 | 允许 | HTTP |
   | HTTPS | 0.0.0.0/0 | TCP:443 | 允许 | HTTPS |

### AWS EC2

1. **登录 AWS 控制台**
   - 进入 EC2 Dashboard
   - 选择您的 EC2 实例

2. **配置 Security Groups**
   - 选择 Security Groups → Edit inbound rules
   - 添加规则：

   | Type | Protocol | Port Range | Source | Description |
   |------|----------|------------|--------|-------------|
   | Custom TCP | TCP | 3000 | 0.0.0.0/0 | Gas Management System |
   | HTTP | TCP | 80 | 0.0.0.0/0 | HTTP |
   | HTTPS | TCP | 443 | 0.0.0.0/0 | HTTPS |

### 华为云 ECS

1. **登录华为云控制台**
   - 进入 ECS 控制台
   - 选择您的 ECS 实例

2. **配置安全组**
   - 选择"安全组" → "管理规则"
   - 添加入方向规则：   | 优先级 | 策略 | 协议 | 端口 | 源地址 | 描述 |
   |--------|------|------|------|--------|------|
   | 1 | 允许 | TCP | 3000 | 0.0.0.0/0 | 瓦斯管理系统 |
   | 1 | 允许 | TCP | 80 | 0.0.0.0/0 | HTTP |
   | 1 | 允许 | TCP | 443 | 0.0.0.0/0 | HTTPS |

### Azure Virtual Machines

1. **登录 Azure 门户**
   - 进入虚拟机控制台
   - 选择您的虚拟机

2. **配置网络安全组**
   - 选择"网络" → "入站端口规则"
   - 添加入站安全规则：

   | 优先级 | 名称 | 端口 | 协议 | 源 | 目标 | 操作 |
   |--------|------|------|------|-----|------|------|
   | 100 | GasManagement | 3000 | TCP | Any | Any | 允许 |
   | 110 | HTTP | 80 | TCP | Any | Any | 允许 |
   | 120 | HTTPS | 443 | TCP | Any | Any | 允许 |

## 🔧 第三步：验证配置

### 运行网络测试
```bash
sudo ./test-network-connectivity.sh
```

测试脚本将检查：
- ✅ 端口监听状态
- ✅ 防火墙规则
- ✅ 服务运行状态
- ✅ 网络连通性

### 手动验证步骤

1. **检查端口监听**
   ```bash
   sudo netstat -tulpn | grep :3000
   # 或
   sudo ss -tulpn | grep :3000
   ```
   应该显示: `0.0.0.0:3000`

2. **测试本地访问**
   ```bash
   curl -I http://localhost:3000
   ```

3. **测试外网访问**
   从其他网络环境访问: `http://YOUR_SERVER_IP:3000`

## 🔒 第四步：配置SSL证书 (推荐)

### 自动配置 Let's Encrypt 证书
```bash
sudo ./setup-ssl-certificate.sh
```

此脚本将：
- ✅ 安装 Nginx 反向代理
- ✅ 获取免费 SSL 证书
- ✅ 配置 HTTPS 访问
- ✅ 设置自动证书续期

### 手动配置步骤

1. **准备域名**
   - 注册域名 (例如: gas.example.com)
   - 将域名 A 记录指向服务器IP

2. **安装 Nginx 和 Certbot**
   ```bash
   # Ubuntu/Debian
   sudo apt update
   sudo apt install nginx certbot python3-certbot-nginx
   
   # CentOS/RHEL
   sudo yum install nginx certbot python3-certbot-nginx
   ```

3. **配置 Nginx 反向代理**
   创建配置文件 `/etc/nginx/sites-available/gas-management`

4. **获取SSL证书**
   ```bash
   sudo certbot --nginx -d your-domain.com
   ```

## 📊 访问地址

配置完成后，您可以通过以下地址访问系统：

### HTTP 访问
- **外网访问**: `http://YOUR_SERVER_IP:3000`
- **内网访问**: `http://PRIVATE_IP:3000`
- **本地访问**: `http://localhost:3000`

### HTTPS 访问 (配置SSL后)
- **安全访问**: `https://your-domain.com`

## 👤 默认登录账号

| 角色 | 用户名 | 密码 | 权限说明 |
|------|--------|------|----------|
| 管理员 | admin | password | 全部功能访问权限 |
| 经理 | manager | password | 业务管理和报表权限 |
| 员工 | employee | password | 基础操作权限 |

⚠️ **重要提醒**: 请在首次登录后立即更改默认密码！

## 🔧 常见问题解决

### 问题1: 外网无法访问
```bash
# 检查应用监听地址
sudo netstat -tulpn | grep :3000

# 应该显示 0.0.0.0:3000，而不是 127.0.0.1:3000
# 如果显示 localhost，重新运行配置脚本
sudo ./configure-external-access.sh
```

### 问题2: 防火墙阻止访问
```bash
# Ubuntu/Debian
sudo ufw allow 3000
sudo ufw status

# CentOS/RHEL
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload
```

### 问题3: 服务未运行
```bash
# 检查服务状态
sudo systemctl status gas-management

# 启动服务
sudo systemctl start gas-management

# 查看错误日志
sudo journalctl -u gas-management -f
```

### 问题4: 云服务商安全组未配置
- 登录云服务商控制台
- 找到安全组/防火墙规则配置
- 开放端口 3000、80、443
- 保存配置并重启实例

### 问题5: 域名解析问题
```bash
# 检查域名解析
nslookup your-domain.com
dig your-domain.com

# 确保域名指向正确的服务器IP
```

## 🛠️ 管理命令

### 服务管理
```bash
# 查看服务状态
sudo systemctl status gas-management

# 启动/停止/重启服务
sudo systemctl start gas-management
sudo systemctl stop gas-management
sudo systemctl restart gas-management

# 查看实时日志
sudo journalctl -u gas-management -f
```

### 防火墙管理
```bash
# UFW 防火墙
sudo ufw status
sudo ufw allow 3000
sudo ufw delete allow 3000

# Firewalld 防火墙
sudo firewall-cmd --list-all
sudo firewall-cmd --add-port=3000/tcp --permanent
sudo firewall-cmd --reload
```

### SSL 证书管理
```bash
# 查看证书状态
sudo certbot certificates

# 手动续期证书
sudo certbot renew

# 测试自动续期
sudo certbot renew --dry-run
```

## 📈 性能优化建议

### 服务器配置建议
- **最低配置**: 1核2GB内存
- **推荐配置**: 2核4GB内存
- **存储空间**: 至少20GB可用空间

### 网络优化
```bash
# 调整网络参数
echo 'net.core.somaxconn = 1024' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_max_syn_backlog = 1024' >> /etc/sysctl.conf
sysctl -p
```

### 应用优化
```bash
# 配置进程管理器
npm install -g pm2

# 使用 PM2 启动应用 (可选)
pm2 start ecosystem.config.js
pm2 startup
pm2 save
```

## 📋 安全检查清单

- [ ] 更改默认登录密码
- [ ] 配置SSL证书
- [ ] 启用防火墙并配置规则
- [ ] 定期更新系统和应用
- [ ] 配置自动备份
- [ ] 监控系统资源使用情况
- [ ] 审查访问日志
- [ ] 限制SSH访问 (使用密钥认证)

## 📞 技术支持

**Jy技術團隊 2025**
- 🌐 专业瓦斯行管理解决方案
- 🔧 7x24小时技术支持
- 📧 技术支持: support@jytech.com
- 📱 紧急联系: +886-xxx-xxxx

## 🔄 更新日志

### v1.0.0 (2025-01-01)
- ✅ 首次发布
- ✅ 支持外网访问配置
- ✅ 集成AI助理功能
- ✅ 提供完整部署脚本

---

© 2025 Jy技術團隊 - 保留所有权利
   | 100 | 允许 | TCP | 3000 | 0.0.0.0/0 | 瓦斯管理系统 |
   | 100 | 允许 | TCP | 80 | 0.0.0.0/0 | HTTP |
   | 100 | 允许 | TCP | 443 | 0.0.0.0/0 | HTTPS |

### Vultr VPS

1. **登录 Vultr 控制台**
   - 进入 Instances 页面
   - 选择您的 VPS

2. **配置防火墙**
   - 点击 "Firewall" 标签
   - 添加规则：

   | IP Type | Protocol | Port | Source |
   |---------|----------|------|--------|
   | IPv4 | TCP | 3000 | 0.0.0.0/0 |
   | IPv4 | TCP | 80 | 0.0.0.0/0 |
   | IPv4 | TCP | 443 | 0.0.0.0/0 |

## 🔧 通用配置步骤

### 1. 检查当前配置
```bash
# 检查防火墙状态
ufw status
# 或
firewall-cmd --list-all

# 检查端口监听
netstat -tulpn | grep :3000
```

### 2. 开放必要端口
```bash
# Ubuntu/Debian (UFW)
sudo ufw allow 3000/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# CentOS/RHEL (Firewalld)
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload
```

### 3. 配置应用监听所有接口
确保应用配置文件 `.env` 包含：
```env
APP_HOST=0.0.0.0
APP_PORT=3000
```

## 🔒 安全最佳实践

### 1. 限制访问源 IP（推荐）
如果您知道访问来源 IP，建议限制访问：
```bash
# 只允许特定 IP 访问
sudo ufw allow from YOUR_IP_ADDRESS to any port 3000

# 只允许特定网段访问  
sudo ufw allow from 192.168.1.0/24 to any port 3000
```

### 2. 使用非标准端口
```bash
# 修改为非标准端口（如 8080）
echo "APP_PORT=8080" >> .env
sudo ufw allow 8080/tcp
```

### 3. 配置 SSL 证书
```bash
# 安装 Certbot
sudo apt install certbot

# 获取免费 SSL 证书
sudo certbot certonly --standalone -d your-domain.com
```

### 4. 启用访问日志
```bash
# 在应用配置中启用日志
echo "ENABLE_ACCESS_LOG=true" >> .env
echo "LOG_LEVEL=info" >> .env
```

## 🧪 测试外网访问

### 1. 本地测试
```bash
# 测试应用响应
curl -I http://localhost:3000

# 测试外网 IP 访问
curl -I http://YOUR_PUBLIC_IP:3000
```

### 2. 在线测试工具
- **端口检测**: https://tool.chinaz.com/port/
- **网站测试**: https://www.websiteplanet.com/webtools/uptime-checker/
- **SSL 检测**: https://www.ssllabs.com/ssltest/

### 3. 浏览器测试
直接在浏览器中访问：
```
http://YOUR_PUBLIC_IP:3000
```

## ⚠️ 故障排除

### 问题 1: 无法访问
```bash
# 检查服务状态
systemctl status gas-management

# 检查端口监听
ss -tulpn | grep :3000

# 检查防火墙
ufw status
```

### 问题 2: 连接超时
1. 检查云服务商安全组设置
2. 检查本地防火墙配置
3. 确认应用监听正确的接口

### 问题 3: 403/404 错误
1. 检查应用日志
2. 确认路由配置
3. 检查文件权限

## 📱 移动端访问优化

### 1. 响应式设计
应用已支持响应式设计，可在手机上正常访问。

### 2. PWA 支持
可考虑添加 PWA 支持，让手机用户可以"安装"应用。

### 3. 性能优化
- 启用 Gzip 压缩
- 配置缓存策略
- 优化图片资源

---

**📞 技术支持**: Jy技術團隊 2025  
**🚀 瓦斯行管理系統** - 让传统行业拥抱数字化未来
