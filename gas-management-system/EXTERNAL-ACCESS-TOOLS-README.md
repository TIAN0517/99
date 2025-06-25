# 瓦斯行管理系统 - 外网连线工具包

> **Jy技術團隊 2025** - 专业瓦斯行管理解决方案

## 🌐 外网连线配置工具集

本工具包提供完整的外网访问配置解决方案，让您的瓦斯行管理系统可以从任何网络位置访问。

### 📋 工具清单

#### 🚀 主要配置工具

| 工具名称 | 用途 | 适用环境 | 推荐度 |
|---------|------|----------|--------|
| `external-access-manager.sh` | 外网连线管理中心 (交互式菜单) | Linux | ⭐⭐⭐⭐⭐ |
| `deploy-external-access.sh` | 一键完整部署 (自动化) | Linux | ⭐⭐⭐⭐⭐ |
| `quick-external-access.sh` | 快速配置 (最简单) | Linux | ⭐⭐⭐⭐ |
| `configure-external-access.ps1` | Windows 配置工具 | Windows | ⭐⭐⭐⭐ |

#### 🔧 专项配置工具

| 工具名称 | 功能说明 | 使用场景 |
|---------|----------|----------|
| `configure-external-access.sh` | 基础外网访问配置 | 手动逐步配置 |
| `setup-ssl-certificate.sh` | SSL 证书配置 | 启用 HTTPS 安全访问 |
| `test-network-connectivity.sh` | 网络连通性测试 | 验证配置结果 |
| `troubleshoot-external-access.sh` | 故障诊断修复 | 解决访问问题 |

#### 📚 文档资源

| 文档名称 | 内容说明 |
|---------|----------|
| `EXTERNAL-ACCESS-GUIDE.md` | 完整配置指南 |
| `LINUX-VPS-DEPLOYMENT.md` | Linux VPS 部署指南 |
| `QUICK-START-LINUX.md` | 快速开始指南 |

## 🚀 快速开始

### 方法一：一键自动配置 (推荐)

```bash
# Linux 环境
sudo chmod +x external-access-manager.sh
sudo ./external-access-manager.sh
```

### 方法二：完全自动化部署

```bash
# Linux 环境 - 一键完整部署
sudo chmod +x deploy-external-access.sh
sudo ./deploy-external-access.sh
```

### 方法三：快速简单配置

```bash
# Linux 环境 - 最简配置
sudo chmod +x quick-external-access.sh
sudo ./quick-external-access.sh
```

### 方法四：Windows 环境

```powershell
# Windows PowerShell (管理员权限)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\configure-external-access.ps1
```

## 📖 详细配置步骤

### 🔧 基本配置流程

1. **服务器配置**
   ```bash
   sudo ./configure-external-access.sh
   ```

2. **网络测试**
   ```bash
   sudo ./test-network-connectivity.sh
   ```

3. **SSL配置** (可选)
   ```bash
   sudo ./setup-ssl-certificate.sh
   ```

4. **故障排除** (如需要)
   ```bash
   sudo ./troubleshoot-external-access.sh
   ```

### 🛡️ 云服务商安全组配置

#### 必须开放的端口

| 端口 | 协议 | 用途 | 必需性 |
|------|------|------|--------|
| 22 | TCP | SSH 访问 | 必需 |
| 3000 | TCP | 瓦斯管理系统 | 必需 |
| 80 | TCP | HTTP (SSL配置时) | 可选 |
| 443 | TCP | HTTPS | 可选 |

#### 各云服务商配置方法

- **阿里云**: ECS 控制台 → 安全组 → 配置规则
- **腾讯云**: CVM 控制台 → 安全组 → 修改规则  
- **AWS**: EC2 Dashboard → Security Groups → Edit inbound rules
- **Azure**: Virtual Machines → Networking → Inbound port rules

## 🎯 访问地址

配置完成后，可通过以下地址访问系统：

### HTTP 访问
- **外网访问**: `http://YOUR_SERVER_IP:3000`
- **内网访问**: `http://PRIVATE_IP:3000`
- **本地访问**: `http://localhost:3000`

### HTTPS 访问 (配置SSL后)
- **安全访问**: `https://your-domain.com`

## 👤 默认登录账号

| 角色 | 用户名 | 密码 | 权限说明 |
|------|--------|------|----------|
| 管理员 | admin | password | 全部功能访问 |
| 经理 | manager | password | 业务管理和报表 |
| 员工 | employee | password | 基础操作 |

⚠️ **重要**: 请在首次登录后立即更改默认密码！

## 🔍 故障排除

### 常见问题及解决方案

#### ❌ 外网无法访问

1. **检查服务状态**
   ```bash
   sudo systemctl status gas-management
   ```

2. **检查端口监听**
   ```bash
   sudo netstat -tulpn | grep :3000
   ```

3. **运行故障诊断**
   ```bash
   sudo ./troubleshoot-external-access.sh
   ```

#### ❌ 应用启动失败

1. **查看错误日志**
   ```bash
   sudo journalctl -u gas-management -f
   ```

2. **重启服务**
   ```bash
   sudo systemctl restart gas-management
   ```

#### ❌ 防火墙问题

```bash
# Ubuntu/Debian
sudo ufw allow 3000
sudo ufw status

# CentOS/RHEL
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload
```

## 🔧 管理命令

### 服务管理
```bash
# 查看状态
sudo systemctl status gas-management

# 启动/停止/重启
sudo systemctl start gas-management
sudo systemctl stop gas-management
sudo systemctl restart gas-management

# 查看日志
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

## 🔒 安全建议

### 基础安全
- [ ] 更改默认登录密码
- [ ] 使用强密码策略
- [ ] 定期更新系统
- [ ] 配置 SSL 证书

### 高级安全
- [ ] 限制 SSH 访问来源
- [ ] 配置防火墙白名单
- [ ] 启用访问日志监控
- [ ] 定期安全审计

## 📈 性能优化

### 服务器要求
- **最低配置**: 1核2GB内存，20GB存储
- **推荐配置**: 2核4GB内存，50GB存储
- **网络带宽**: 1Mbps以上

### 优化脚本
```bash
# 运行性能优化
sudo ./optimize-vps-performance.sh

# 快速优化
sudo ./quick-optimize.sh
```

## 📞 技术支持

### 联系方式
- **技术团队**: Jy技術團隊 2025
- **支持邮箱**: support@jytech.com
- **紧急联系**: +886-xxx-xxxx

### 支持资源
- 📖 [完整部署指南](EXTERNAL-ACCESS-GUIDE.md)
- 🐧 [Linux VPS 部署](LINUX-VPS-DEPLOYMENT.md)
- ⚡ [快速开始指南](QUICK-START-LINUX.md)

## 🔄 更新日志

### v1.2.0 (2025-06-22)
- ✅ 新增外网连线管理中心
- ✅ 优化一键部署流程
- ✅ 增强故障诊断功能
- ✅ 添加 Windows 支持
- ✅ 完善文档说明

### v1.1.0 (2025-01-15)
- ✅ 添加 SSL 证书支持
- ✅ 增强网络连通性测试
- ✅ 优化防火墙配置

### v1.0.0 (2025-01-01)
- ✅ 首次发布
- ✅ 基础外网访问功能
- ✅ 支持主流 Linux 发行版

---

## 📋 使用检查清单

### 部署前准备
- [ ] 确认服务器基本配置满足要求
- [ ] 准备云服务商账号访问权限
- [ ] 备份重要数据
- [ ] 确认网络连通性

### 配置过程
- [ ] 运行外网配置脚本
- [ ] 配置云服务商安全组
- [ ] 测试网络连通性
- [ ] 验证服务运行状态

### 配置后验证
- [ ] 测试本地访问
- [ ] 测试内网访问  
- [ ] 测试外网访问
- [ ] 更改默认密码
- [ ] 配置数据备份

### 可选增强
- [ ] 配置 SSL 证书
- [ ] 设置域名解析
- [ ] 优化服务器性能
- [ ] 配置监控告警

---

© 2025 Jy技術團隊 - 专业瓦斯行管理解决方案
