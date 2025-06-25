# 🚀 Linux VPS 一键部署指南

## Jy技術團隊 瓦斯行管理系統 2025

### 📋 系统要求
- **Linux 系统**: Ubuntu 20.04+, Debian 11+, CentOS 8+
- **最低配置**: 2GB RAM, 20GB 存储
- **推荐配置**: 4GB RAM, 40GB 存储

---

## 🎯 三步部署

### 步骤 1: 上传文件
```bash
scp gas-management-system-linux-vps-final.zip root@your-vps-ip:/root/
```

### 步骤 2: 连接并解压
```bash
ssh root@your-vps-ip
cd /root
unzip gas-management-system-linux-vps-final.zip
cd gas-management-system
```

### 步骤 3: 一键部署
```bash
chmod +x quick-deploy-linux.sh
./quick-deploy-linux.sh
```

**完成！** 浏览器访问: `http://your-vps-ip:3000`

---

## 🔧 管理命令

### 启动/停止服务
```bash
systemctl start gas-management     # 启动
systemctl stop gas-management      # 停止  
systemctl restart gas-management   # 重启
systemctl status gas-management    # 状态
```

### 查看日志
```bash
journalctl -u gas-management -f    # 系统日志
pm2 logs gas-management-system     # 应用日志
```

### 系统监控
```bash
cd /opt/gas-management-system
./monitor.sh                       # 运行监控
```

---

## 🛠️ 故障处理

### AI 服务问题
```bash
docker restart ollama              # 重启 AI 服务
docker logs ollama                 # 查看 AI 日志
```

### 应用无响应
```bash
pm2 restart gas-management-system  # 重启应用
pm2 status                         # 查看状态
```

### 端口被占用
```bash
netstat -tulpn | grep :3000       # 检查端口
pkill -f "node.*main.js"          # 强制结束进程
```

---

## 💡 重要说明

### 登录账号
| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | password |
| 经理 | manager | password |
| 员工 | employee | password |

### AI 模型自动选择
- **< 3GB 内存**: 使用 `gemma:2b` (轻量级)
- **> 6GB 内存**: 使用 `deepseek-r1:8b` (高性能)

### 防火墙端口
- **3000**: 应用访问端口
- **11434**: AI API 端口 (内部使用)

---

## 📞 技术支持

**问题排查步骤**:
1. 检查系统服务: `systemctl status gas-management`
2. 查看应用日志: `pm2 logs gas-management-system`
3. 检查 Docker: `docker ps`
4. 运行监控: `./monitor.sh`

**联系方式**: Jy技術團隊

---

**🎉 享受现代化的瓦斯行管理体验！**
