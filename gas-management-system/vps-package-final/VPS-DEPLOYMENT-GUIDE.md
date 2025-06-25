# 🚀 Jy技術團隊 瓦斯行管理系統 2025 - VPS 部署完整指南

## 📋 部署概览

本指南提供了完整的 VPS 部署解决方案，包括内存优化配置和故障排除方案。

### 🎯 支持的 VPS 配置

| 配置等级 | 内存要求 | AI 模型 | 功能特性 |
|---------|---------|---------|---------|
| 🔥 高性能 | ≥6GB | deepseek-r1:8b | 完整 AI 功能，复杂推理 |
| ⚡ 标准 | 3-6GB | gemma:2b | 基础 AI 对话，轻量推理 |
| 💡 经济 | <3GB | phi3:mini | 简单对话，基础问答 |

## 🚀 一键部署

### 步骤 1：上传部署包
```bash
# 使用 SCP 上传（推荐）
scp gas-management-system-vps-package.zip root@your-vps-ip:/root/

# 或使用 SFTP
sftp root@your-vps-ip
put gas-management-system-vps-package.zip /root/
```

### 步骤 2：执行部署
```bash
# SSH 连接到 VPS
ssh root@your-vps-ip

# 解压并运行部署脚本
cd /root
unzip gas-management-system-vps-package.zip
cd gas-management-system
chmod +x deploy-vps-complete.sh
./deploy-vps-complete.sh
```

### 步骤 3：验证部署
```bash
# 检查服务状态
systemctl status gas-management

# 查看系统监控
./monitor.sh

# 测试应用访问
curl http://localhost:3000
```

## 🔧 手动部署步骤

如果一键部署遇到问题，请按以下步骤手动部署：

### 1. 系统准备
```bash
# 更新系统
apt update && apt upgrade -y

# 安装基础软件
apt install -y curl wget git nodejs npm docker.io docker-compose xvfb bc
```

### 2. Docker 配置
```bash
# 启动 Docker 服务
systemctl enable docker
systemctl start docker

# 验证 Docker 安装
docker --version
docker-compose --version
```

### 3. Ollama 部署
```bash
# 部署优化的 Ollama 容器
docker run -d \
  --name ollama \
  --restart unless-stopped \
  -p 11434:11434 \
  -v ollama_data:/root/.ollama \
  -e OLLAMA_HOST=0.0.0.0:11434 \
  -e OLLAMA_KEEP_ALIVE=3m \
  -e OLLAMA_MAX_LOADED_MODELS=1 \
  --memory=2.5g \
  --memory-swap=3g \
  ollama/ollama

# 等待服务启动
sleep 15

# 验证服务
curl http://localhost:11434/api/tags
```

### 4. AI 模型下载
```bash
# 根据内存配置选择模型

# 高配置 (≥6GB)
docker exec ollama ollama pull deepseek-r1:8b

# 标准配置 (3-6GB)
docker exec ollama ollama pull gemma:2b

# 经济配置 (<3GB)
docker exec ollama ollama pull phi3:mini

# 验证模型安装
docker exec ollama ollama list
```

### 5. 应用部署
```bash
# 创建应用目录
mkdir -p /opt/gas-management-system
cd /opt/gas-management-system

# 解压应用文件
unzip /root/gas-management-system-vps-package.zip

# 安装依赖
npm install --production

# 创建环境配置
cat > .env << EOF
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=gemma:2b
APP_PORT=3000
LOG_LEVEL=info
COMPANY_NAME=Jy技術團隊
APP_YEAR=2025
EOF
```

### 6. 系统服务配置
```bash
# 创建 systemd 服务
cat > /etc/systemd/system/gas-management.service << EOF
[Unit]
Description=Jy技術團隊 瓦斯行管理系統 2025
After=network.target docker.service
Requires=docker.service

[Service]
Type=simple
User=root
WorkingDirectory=/opt/gas-management-system
ExecStart=/opt/gas-management-system/start.sh
Restart=always
RestartSec=10
Environment=NODE_ENV=production
Environment=DISPLAY=:99

[Install]
WantedBy=multi-user.target
EOF

# 重载并启用服务
systemctl daemon-reload
systemctl enable gas-management.service
systemctl start gas-management.service
```

## 🛠️ 服务管理

### 基本命令
```bash
# 启动服务
systemctl start gas-management

# 停止服务
systemctl stop gas-management

# 重启服务
systemctl restart gas-management

# 查看状态
systemctl status gas-management

# 查看日志
journalctl -u gas-management -f
```

### 手动启动
```bash
# 进入应用目录
cd /opt/gas-management-system

# 手动启动
./start.sh

# 后台运行
nohup ./start.sh > logs/app.log 2>&1 &
```

## 📊 监控与维护

### 系统监控
```bash
# 使用内置监控脚本
cd /opt/gas-management-system
./monitor.sh

# 查看资源使用
htop
free -h
df -h

# 查看 Docker 容器状态
docker ps
docker stats
```

### 日志管理
```bash
# 应用日志
tail -f /opt/gas-management-system/logs/*.log

# 系统日志
journalctl -u gas-management -f

# Docker 日志
docker logs ollama -f
```

### 性能优化
```bash
# 创建交换文件（如果内存不足）
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# 清理 Docker 缓存
docker system prune -f

# 重启 Ollama 释放内存
docker restart ollama
```

## 🔒 安全配置

### 防火墙设置
```bash
# 启用 UFW 防火墙
ufw --force enable

# 允许必要端口
ufw allow ssh
ufw allow 3000    # 应用端口
ufw allow 11434   # Ollama API（可选）

# 查看防火墙状态
ufw status
```

### SSL 证书（可选）
```bash
# 安装 Certbot
apt install certbot python3-certbot-nginx

# 获取 SSL 证书
certbot --nginx -d your-domain.com

# 自动续期
crontab -e
# 添加：0 12 * * * /usr/bin/certbot renew --quiet
```

## 🚨 故障排除

### 常见问题

#### 1. 内存不足
**症状**：AI 模型加载失败，应用响应慢
```bash
# 检查内存使用
free -h

# 解决方案：切换到更小的模型
docker exec ollama ollama pull phi3:mini
# 更新 .env 文件中的 DEFAULT_AI_MODEL
```

#### 2. Ollama 服务无法启动
**症状**：curl 11434 端口失败
```bash
# 检查 Docker 容器状态
docker ps -a

# 查看容器日志
docker logs ollama

# 重启容器
docker restart ollama

# 重新创建容器
docker stop ollama && docker rm ollama
./deploy-vps-complete.sh
```

#### 3. 应用无法启动
**症状**：3000 端口无响应
```bash
# 检查 Node.js 进程
ps aux | grep node

# 查看应用日志
journalctl -u gas-management -f

# 手动启动调试
cd /opt/gas-management-system
export DISPLAY=:99
npm start
```

#### 4. AI 助理无响应
**症状**：聊天功能无法使用
```bash
# 测试 Ollama API
curl http://localhost:11434/api/tags

# 检查模型列表
docker exec ollama ollama list

# 重新下载模型
docker exec ollama ollama pull gemma:2b
```

#### 5. 端口冲突
**症状**：端口被占用错误
```bash
# 检查端口占用
netstat -tulpn | grep :3000
netstat -tulpn | grep :11434

# 杀死占用进程
kill $(lsof -t -i:3000)

# 修改端口配置
vim /opt/gas-management-system/.env
```

### 调试模式
```bash
# 启用调试模式
export DEBUG=gas-management:*
export LOG_LEVEL=debug

# 详细日志输出
npm start --verbose
```

## 🔄 升级与更新

### 应用升级
```bash
# 备份当前版本
cp -r /opt/gas-management-system /opt/gas-management-system.backup

# 上传新版本
scp new-gas-management-system-vps-package.zip root@vps:/root/

# 停止服务
systemctl stop gas-management

# 解压新版本
cd /root
unzip new-gas-management-system-vps-package.zip
cp -r gas-management-system/* /opt/gas-management-system/

# 更新依赖
cd /opt/gas-management-system
npm install --production

# 启动服务
systemctl start gas-management
```

### AI 模型升级
```bash
# 下载新模型
docker exec ollama ollama pull new-model:latest

# 更新配置
vim /opt/gas-management-system/.env

# 重启应用
systemctl restart gas-management
```

## 📞 技术支持

### 联系方式
- **开发团队**：Jy技術團隊
- **项目年份**：2025
- **技术支持**：通过系统内 AI 助理或查阅文档

### 社区资源
- **Ollama 文档**：https://ollama.ai/docs
- **Electron 文档**：https://electronjs.org/docs
- **React 文档**：https://react.dev

---

## 🎉 部署完成检查清单

- [ ] 系统软件包已更新
- [ ] Docker 服务正常运行
- [ ] Ollama 容器正常启动
- [ ] AI 模型成功下载
- [ ] 应用依赖安装完成
- [ ] 环境配置文件创建
- [ ] 系统服务已配置
- [ ] 防火墙规则已设置
- [ ] 应用可通过浏览器访问
- [ ] AI 助理功能正常
- [ ] 监控脚本可用
- [ ] 日志文件正常生成

**恭喜！Jy技術團隊 瓦斯行管理系統 2025 已成功部署到您的 VPS！** 🎊
