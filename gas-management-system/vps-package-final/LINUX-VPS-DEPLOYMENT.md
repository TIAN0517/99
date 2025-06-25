# Linux VPS 部署指南

## Jy技術團隊 瓦斯行管理系統 2025 - Linux VPS 专用部署

### 🐧 支持的 Linux 系统

- **Ubuntu** 20.04+ / 22.04+ (推荐)
- **Debian** 11+ / 12+
- **CentOS** 8+ / Rocky Linux 8+
- **Red Hat Enterprise Linux** 8+
- **openSUSE** Leap 15.4+

### 📋 系统要求

| 配置级别 | 内存 | CPU | 存储 | AI 模型 |
|---------|------|-----|------|---------|
| **最低配置** | 2GB | 1核 | 20GB | phi3:mini |
| **推荐配置** | 4GB | 2核 | 40GB | gemma:2b |
| **高性能配置** | 8GB+ | 4核+ | 80GB+ | deepseek-r1:8b |

### 🚀 一键快速部署

#### 方法一：使用快速部署脚本（推荐新手）

```bash
# 1. 上传部署包到 VPS
scp gas-management-system-vps-package.zip root@your-vps-ip:/root/

# 2. SSH 连接到 VPS
ssh root@your-vps-ip

# 3. 解压并运行快速部署
cd /root
unzip gas-management-system-vps-package.zip
cd gas-management-system
chmod +x quick-deploy-linux.sh
./quick-deploy-linux.sh
```

#### 方法二：使用完整部署脚本（推荐高级用户）

```bash
# SSH 连接到 VPS
ssh root@your-vps-ip

# 解压并运行完整部署
cd /root
unzip gas-management-system-vps-package.zip
cd gas-management-system
chmod +x deploy-vps-linux.sh
./deploy-vps-linux.sh
```

### 📦 手动部署步骤

如果自动脚本遇到问题，可以按以下步骤手动部署：

#### 1. 准备系统环境

```bash
# Ubuntu/Debian 系统
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git unzip nodejs npm xvfb bc jq net-tools

# CentOS/RHEL 系统
sudo yum update -y
sudo yum install -y curl wget git unzip nodejs npm xorg-x11-server-Xvfb bc jq net-tools

# 或者使用 dnf (较新的系统)
sudo dnf update -y
sudo dnf install -y curl wget git unzip nodejs npm xorg-x11-server-Xvfb bc jq net-tools
```

#### 2. 安装 Docker

```bash
# 自动安装 Docker
curl -fsSL https://get.docker.com | sh

# 启动并设置自启动
sudo systemctl enable docker
sudo systemctl start docker

# 验证安装
docker --version
```

#### 3. 部署应用

```bash
# 创建应用目录
sudo mkdir -p /opt/gas-management-system
cd /opt/gas-management-system

# 解压应用文件（假设已上传到 /root/）
sudo unzip /root/gas-management-system-vps-package.zip

# 安装 Node.js 依赖
npm install --production --no-audit --no-fund
```

#### 4. 启动 Ollama AI 服务

```bash
# 根据内存选择配置
TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.1f", $2/1024}')

# 设置内存限制和模型
if (( $(echo "$TOTAL_MEM < 3.0" | bc -l) )); then
    AI_MODEL="gemma:2b"
    MEMORY_LIMIT="2g"
else
    AI_MODEL="deepseek-r1:8b"
    MEMORY_LIMIT="4g"
fi

# 启动 Ollama 容器
docker run -d \
    --name ollama \
    --restart unless-stopped \
    -p 11434:11434 \
    -v ollama_data:/root/.ollama \
    -e OLLAMA_HOST=0.0.0.0:11434 \
    -e OLLAMA_KEEP_ALIVE=5m \
    -e OLLAMA_MAX_LOADED_MODELS=1 \
    --memory="$MEMORY_LIMIT" \
    ollama/ollama

# 等待服务启动
sleep 20

# 下载 AI 模型
docker exec ollama ollama pull $AI_MODEL
```

#### 5. 配置应用环境

```bash
# 创建环境配置文件
cat > .env << EOF
NODE_ENV=production
OLLAMA_BASE_URL=http://localhost:11434
DEFAULT_AI_MODEL=$AI_MODEL
APP_PORT=3000
DISPLAY=:99
EOF
```

#### 6. 安装进程管理器

```bash
# 安装 PM2
npm install -g pm2

# 创建 PM2 配置
cat > ecosystem.config.js << EOF
module.exports = {
  apps: [{
    name: 'gas-management-system',
    script: 'npm',
    args: 'start',
    cwd: '/opt/gas-management-system',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '400M',
    env: {
      NODE_ENV: 'production',
      DISPLAY: ':99'
    },
    log_file: './logs/combined.log',
    out_file: './logs/out.log',
    error_file: './logs/error.log'
  }]
};
EOF
```

#### 7. 创建系统服务

```bash
# 创建 systemd 服务文件
sudo tee /etc/systemd/system/gas-management.service > /dev/null << EOF
[Unit]
Description=Jy技術團隊 瓦斯行管理系統 2025
After=network.target docker.service
Requires=docker.service

[Service]
Type=forking
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

# 重新加载 systemd 并启用服务
sudo systemctl daemon-reload
sudo systemctl enable gas-management.service
```

#### 8. 配置防火墙

```bash
# Ubuntu/Debian (ufw)
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 3000/tcp
sudo ufw allow 11434/tcp

# CentOS/RHEL (firewalld)
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --permanent --add-port=11434/tcp
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

### 🛠️ 服务管理

#### systemd 服务管理

```bash
# 启动服务
sudo systemctl start gas-management

# 停止服务
sudo systemctl stop gas-management

# 重启服务
sudo systemctl restart gas-management

# 查看状态
sudo systemctl status gas-management

# 查看日志
sudo journalctl -u gas-management -f

# 查看最近的错误
sudo journalctl -u gas-management --since "1 hour ago" -p err
```

#### PM2 进程管理

```bash
# 查看进程状态
pm2 status

# 查看应用日志
pm2 logs gas-management-system

# 重启应用
pm2 restart gas-management-system

# 停止应用
pm2 stop gas-management-system

# 查看实时日志
pm2 logs gas-management-system --lines 50 -f
```

#### Docker 容器管理

```bash
# 查看容器状态
docker ps

# 查看 Ollama 日志
docker logs ollama

# 重启 Ollama 容器
docker restart ollama

# 进入 Ollama 容器
docker exec -it ollama bash

# 查看可用模型
docker exec ollama ollama list
```

### 🔍 故障排除

#### 1. 应用无法启动

```bash
# 检查端口占用
sudo netstat -tulpn | grep :3000

# 检查 Node.js 进程
ps aux | grep node

# 查看应用日志
tail -f /opt/gas-management-system/logs/*.log

# 检查权限
ls -la /opt/gas-management-system/
```

#### 2. Ollama 服务问题

```bash
# 检查 Docker 服务
sudo systemctl status docker

# 检查 Ollama 容器
docker ps -a | grep ollama

# 重新创建 Ollama 容器
docker stop ollama && docker rm ollama
# 然后重新运行启动命令

# 测试 API 连接
curl http://localhost:11434/api/tags
```

#### 3. 内存不足问题

```bash
# 查看内存使用
free -h

# 查看最占内存的进程
ps aux --sort=-%mem | head -10

# 创建交换文件（如果需要）
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

#### 4. 网络连接问题

```bash
# 检查防火墙状态
sudo ufw status  # Ubuntu/Debian
sudo firewall-cmd --list-all  # CentOS/RHEL

# 检查端口监听
sudo ss -tulpn | grep -E ':3000|:11434'

# 测试本地连接
curl -I http://localhost:3000
curl http://localhost:11434/api/tags
```

### 📊 性能监控

#### 系统监控命令

```bash
# 查看系统资源
htop

# 查看 Docker 容器资源使用
docker stats

# 查看磁盘使用
df -h

# 查看网络连接
ss -tulpn
```

#### 应用监控脚本

创建监控脚本 `/opt/gas-management-system/monitor.sh`：

```bash
#!/bin/bash
echo "📊 Jy技術團隊 瓦斯行管理系統 2025 - 监控面板"
echo "=============================================="
echo "时间: $(date)"
echo "运行时间: $(uptime -p)"
echo "系统负载: $(uptime | awk -F'load average:' '{print $2}')"
echo ""
echo "内存使用:"
free -h
echo ""
echo "Docker 容器:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "应用进程:"
pm2 status 2>/dev/null || echo "使用 systemctl status gas-management 查看"
echo ""
echo "网络端口:"
ss -tulpn | grep -E ':3000|:11434'
```

### 🔒 安全加固

#### 1. 系统安全

```bash
# 更新系统
sudo apt update && sudo apt upgrade -y  # Ubuntu/Debian
sudo yum update -y  # CentOS/RHEL

# 配置自动安全更新
sudo apt install unattended-upgrades  # Ubuntu/Debian

# 安装 fail2ban 防暴力破解
sudo apt install fail2ban  # Ubuntu/Debian
sudo yum install fail2ban  # CentOS/RHEL
```

#### 2. 应用安全

```bash
# 限制文件权限
sudo chmod 755 /opt/gas-management-system
sudo chmod 600 /opt/gas-management-system/.env

# 配置日志轮转
sudo tee /etc/logrotate.d/gas-management > /dev/null << EOF
/opt/gas-management-system/logs/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
}
EOF
```

#### 3. 网络安全

```bash
# 仅允许必要端口
sudo ufw deny incoming
sudo ufw allow outgoing
sudo ufw allow ssh
sudo ufw allow 3000/tcp
# 注意：仅在需要外部访问 AI API 时才开放 11434 端口
# sudo ufw allow 11434/tcp
```

### 🚀 性能优化

#### 1. 系统优化

```bash
# 调整系统参数
sudo tee -a /etc/sysctl.conf > /dev/null << EOF
# 网络优化
net.core.somaxconn = 1024
net.core.netdev_max_backlog = 5000
net.ipv4.tcp_max_syn_backlog = 1024

# 内存优化
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
EOF

# 应用设置
sudo sysctl -p
```

#### 2. Docker 优化

```bash
# 配置 Docker 日志大小限制
sudo tee /etc/docker/daemon.json > /dev/null << EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl restart docker
```

#### 3. 应用优化

```bash
# 启用 PM2 集群模式（如果内存充足）
# 修改 ecosystem.config.js
sed -i 's/instances: 1/instances: "max"/' /opt/gas-management-system/ecosystem.config.js

# 重启应用
pm2 restart gas-management-system
```

### 📱 移动端访问优化

如果需要移动端访问，建议配置 Nginx 反向代理：

```bash
# 安装 Nginx
sudo apt install nginx  # Ubuntu/Debian
sudo yum install nginx  # CentOS/RHEL

# 配置 Nginx
sudo tee /etc/nginx/sites-available/gas-management > /dev/null << EOF
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# 启用配置
sudo ln -s /etc/nginx/sites-available/gas-management /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 🆘 技术支持

如遇到问题，请按以下步骤收集信息：

```bash
# 收集系统信息
echo "=== 系统信息 ===" > debug.log
uname -a >> debug.log
free -h >> debug.log
df -h >> debug.log

# 收集服务状态
echo "=== 服务状态 ===" >> debug.log
systemctl status gas-management >> debug.log
docker ps >> debug.log

# 收集日志
echo "=== 应用日志 ===" >> debug.log
tail -50 /opt/gas-management-system/logs/*.log >> debug.log

# 收集系统日志
echo "=== 系统日志 ===" >> debug.log
journalctl -u gas-management --since "1 hour ago" >> debug.log
```

然后将 `debug.log` 文件发送给技术支持团队。

---

**📞 联系方式：Jy技術團隊**  
**🚀 Jy技術團隊 瓦斯行管理系統 2025 - 专业、可靠、高效**
