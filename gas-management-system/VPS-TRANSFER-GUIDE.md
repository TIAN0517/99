# 🚀 瓦斯行管理系统 - VPS传输部署指南

> **Jy技術團隊 2025** - 一键部署，即刻使用

## 📦 部署包信息

**文件名**: `gas-management-system-vps-final-20250622_144226.zip`
**大小**: 0.14 MB
**包含**: 完整应用 + 外网连线工具 + 一键部署脚本

---

## 🎯 传输到VPS的方法

### 方法一：使用 SCP (推荐)

```bash
# 从本地上传到VPS
scp gas-management-system-vps-final-20250622_144226.zip root@YOUR_SERVER_IP:/opt/
```

### 方法二：使用 SFTP

```bash
# 连接VPS
sftp root@YOUR_SERVER_IP

# 上传文件
put gas-management-system-vps-final-20250622_144226.zip /opt/

# 退出
quit
```

### 方法三：使用 FTP 客户端

使用 FileZilla、WinSCP 等工具上传到VPS的 `/opt/` 目录

---

## 🚀 VPS上的部署步骤

### 1️⃣ 解压部署包

```bash
# 进入目录
cd /opt

# 解压
unzip gas-management-system-vps-final-20250622_144226.zip

# 进入应用目录
cd gas-management-system-vps-final-20250622_144226
```

### 2️⃣ 一键部署 (超级简单！)

```bash
# 设置权限并一键部署
chmod +x *.sh && sudo ./deploy-external-access.sh
```

**就这么简单！** 🎉

---

## 🌐 部署完成后

### ✅ 立即可用

- **外网访问**: `http://YOUR_SERVER_IP:3000`
- **默认账号**: `admin` / `password`

### 🛡️ 重要提醒

1. **云服务商安全组**: 开放端口 3000
2. **更改密码**: 首次登录后立即更改默认密码
3. **SSL证书**: 可选择配置 HTTPS 安全访问

---

## 🔧 可选配置

### 配置 SSL 证书 (HTTPS)

```bash
sudo ./setup-ssl-certificate.sh
```

### 故障诊断

```bash
sudo ./troubleshoot-external-access.sh
```

### 网络测试

```bash
sudo ./test-network-connectivity.sh
```

---

## 📋 云服务商安全组配置

| 云服务商 | 配置位置 | 开放端口 |
|---------|----------|----------|
| **阿里云** | ECS控制台 → 安全组 → 配置规则 | `3000/TCP` |
| **腾讯云** | CVM控制台 → 安全组 → 修改规则 | `3000/TCP` |
| **AWS** | EC2 Dashboard → Security Groups | `3000/TCP` |
| **Azure** | Virtual Machines → Networking | `3000/TCP` |

---

## 🎊 完成！

部署完成后，您将拥有：

- ✅ **全球访问** - 任何地点都能访问您的瓦斯管理系统
- ✅ **专业界面** - 现代化4D无边框UI设计
- ✅ **AI助理** - 董娘的智能助理
- ✅ **完整功能** - 产品、客户、订单、财务全模块
- ✅ **安全可靠** - 防火墙和可选SSL加密

**🌟 Jy技術團隊 2025 - 让您的瓦斯行业务走向全球！**

---

**📞 技术支持**: support@jytech.com  
**🔧 紧急联系**: +886-xxx-xxxx
