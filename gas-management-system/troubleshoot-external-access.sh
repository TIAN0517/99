#!/bin/bash

# 瓦斯行管理系统 - 外网访问故障排除工具
# Jy技術團隊 2025

echo "🔧 瓦斯行管理系统 - 外网访问故障排除工具"
echo "Jy技術團隊 2025"
echo "============================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_fix() {
    echo -e "${GREEN}[FIX]${NC} $1"
}

# 问题计数器
ISSUES_FOUND=0
ISSUES_FIXED=0

# 记录问题
record_issue() {
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
    log_error "问题 $ISSUES_FOUND: $1"
}

# 记录修复
record_fix() {
    ISSUES_FIXED=$((ISSUES_FIXED + 1))
    log_fix "已修复: $1"
}

# 检查1：服务状态
check_service_status() {
    log_info "检查1: 服务状态..."
    
    if systemctl is-active --quiet gas-management; then
        log_success "瓦斯管理系统服务正在运行"
    else
        record_issue "瓦斯管理系统服务未运行"
        
        echo "尝试修复..."
        if systemctl start gas-management; then
            sleep 3
            if systemctl is-active --quiet gas-management; then
                record_fix "服务已成功启动"
            else
                log_error "服务启动失败，查看错误日志:"
                journalctl -u gas-management --since "5 minutes ago" -n 10
            fi
        else
            log_error "无法启动服务"
        fi
    fi
    
    # 检查服务配置
    if [ ! -f "/etc/systemd/system/gas-management.service" ]; then
        record_issue "系统服务配置文件缺失"
        
        echo "尝试重新创建服务配置..."
        read -p "请输入应用安装目录 (默认: /opt/gas-management-system): " APP_DIR
        APP_DIR=${APP_DIR:-/opt/gas-management-system}
        
        if [ -d "$APP_DIR" ]; then
            cat > /etc/systemd/system/gas-management.service << EOF
[Unit]
Description=Gas Management System - Jy技術團隊 2025
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$APP_DIR
Environment=NODE_ENV=production
Environment=DISPLAY=:99
ExecStartPre=/bin/bash -c 'if ! pgrep -f "Xvfb :99" > /dev/null; then Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 & fi'
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=gas-management

[Install]
WantedBy=multi-user.target
EOF
            
            systemctl daemon-reload
            systemctl enable gas-management
            record_fix "系统服务配置已重新创建"
        else
            log_error "应用目录不存在: $APP_DIR"
        fi
    fi
    
    echo ""
}

# 检查2：端口监听
check_port_listening() {
    log_info "检查2: 端口监听状态..."
    
    PORT_LISTEN=$(netstat -tulpn 2>/dev/null | grep ":3000" || ss -tulpn 2>/dev/null | grep ":3000")
    
    if [ -z "$PORT_LISTEN" ]; then
        record_issue "端口 3000 未在监听"
        
        echo "检查应用是否正在运行..."
        if ! pgrep -f "npm.*start\|node.*main\|electron" > /dev/null; then
            log_error "应用进程未运行，尝试启动服务..."
            systemctl restart gas-management
            sleep 5
        fi
    else
        # 检查监听地址
        if echo "$PORT_LISTEN" | grep -q "0.0.0.0:3000"; then
            log_success "应用正在监听所有网络接口 (0.0.0.0:3000)"
        elif echo "$PORT_LISTEN" | grep -q "127.0.0.1:3000\|localhost:3000"; then
            record_issue "应用仅监听本地接口，外网无法访问"
            
            echo "尝试修复网络配置..."
            fix_network_binding
        else
            log_warning "端口监听状态异常: $PORT_LISTEN"
        fi
    fi
    
    echo ""
}

# 修复网络绑定
fix_network_binding() {
    log_info "修复网络绑定配置..."
    
    # 查找应用目录
    APP_DIR=""
    if [ -d "/opt/gas-management-system" ]; then
        APP_DIR="/opt/gas-management-system"
    elif [ -f "package.json" ]; then
        APP_DIR="$(pwd)"
    else
        read -p "请输入应用安装目录: " APP_DIR
    fi
    
    if [ ! -d "$APP_DIR" ]; then
        log_error "应用目录不存在: $APP_DIR"
        return 1
    fi
    
    cd "$APP_DIR"
    
    # 检查并修复 .env 配置
    if [ -f ".env" ]; then
        # 备份配置
        cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
        
        # 确保配置正确
        if ! grep -q "APP_HOST=0.0.0.0" .env; then
            echo "APP_HOST=0.0.0.0" >> .env
        fi
        
        # 移除 localhost 绑定
        sed -i 's/APP_HOST=localhost/APP_HOST=0.0.0.0/g' .env
        sed -i 's/APP_HOST=127.0.0.1/APP_HOST=0.0.0.0/g' .env
        
        record_fix "环境配置已修复"
    fi
    
    # 检查并修复 package.json
    if [ -f "package.json" ]; then
        if grep -q "localhost" package.json; then
            cp package.json package.json.backup.$(date +%Y%m%d_%H%M%S)
            sed -i 's/localhost/0.0.0.0/g' package.json
            record_fix "应用启动配置已修复"
        fi
    fi
    
    # 重启服务以应用更改
    systemctl restart gas-management
    sleep 3
    
    log_success "网络绑定配置修复完成"
}

# 检查3：防火墙配置
check_firewall() {
    log_info "检查3: 防火墙配置..."
    
    if command -v ufw &> /dev/null; then
        if ufw status | grep -q "Status: active"; then
            if ufw status | grep -q "3000"; then
                log_success "UFW 防火墙已正确配置端口 3000"
            else
                record_issue "UFW 防火墙未开放端口 3000"
                
                echo "尝试修复防火墙规则..."
                if ufw allow 3000/tcp comment 'Gas Management System'; then
                    record_fix "UFW 防火墙规则已添加"
                else
                    log_error "无法添加防火墙规则"
                fi
            fi
        else
            log_warning "UFW 防火墙未启用"
            
            read -p "是否启用 UFW 防火墙？(y/N): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                ufw --force enable
                ufw allow ssh
                ufw allow 3000/tcp comment 'Gas Management System'
                record_fix "UFW 防火墙已启用并配置"
            fi
        fi
        
    elif command -v firewall-cmd &> /dev/null; then
        if systemctl is-active --quiet firewalld; then
            if firewall-cmd --list-ports | grep -q "3000/tcp"; then
                log_success "Firewalld 已正确配置端口 3000"
            else
                record_issue "Firewalld 未开放端口 3000"
                
                echo "尝试修复防火墙规则..."
                if firewall-cmd --permanent --add-port=3000/tcp && firewall-cmd --reload; then
                    record_fix "Firewalld 防火墙规则已添加"
                else
                    log_error "无法添加防火墙规则"
                fi
            fi
        else
            log_warning "Firewalld 防火墙未启用"
            
            read -p "是否启用 Firewalld 防火墙？(y/N): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                systemctl enable firewalld
                systemctl start firewalld
                firewall-cmd --permanent --add-service=ssh
                firewall-cmd --permanent --add-port=3000/tcp
                firewall-cmd --reload
                record_fix "Firewalld 防火墙已启用并配置"
            fi
        fi
        
    else
        log_warning "未检测到防火墙工具"
        echo "请手动确保防火墙开放端口 3000"
    fi
    
    echo ""
}

# 检查4：网络连接
check_network_connectivity() {
    log_info "检查4: 网络连接..."
    
    # 检查外网连接
    if ping -c 3 8.8.8.8 > /dev/null 2>&1; then
        log_success "外网连接正常"
    else
        record_issue "外网连接异常"
        log_error "无法连接到外网，请检查网络配置"
    fi
    
    # 检查本地访问
    if curl -s --max-time 10 http://localhost:3000 > /dev/null 2>&1; then
        log_success "本地访问正常"
    else
        record_issue "本地访问失败"
        
        echo "本地访问失败，可能原因："
        echo "  • 应用未启动"
        echo "  • 端口未监听"
        echo "  • 配置错误"
    fi
    
    # 检查内网访问
    PRIVATE_IP=$(hostname -I | awk '{print $1}')
    if [ -n "$PRIVATE_IP" ] && [ "$PRIVATE_IP" != "127.0.0.1" ]; then
        if curl -s --max-time 10 "http://$PRIVATE_IP:3000" > /dev/null 2>&1; then
            log_success "内网访问正常"
        else
            record_issue "内网访问失败"
            echo "内网IP: $PRIVATE_IP"
        fi
    fi
    
    echo ""
}

# 检查5：系统资源
check_system_resources() {
    log_info "检查5: 系统资源..."
    
    # 检查内存使用
    MEMORY_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
    if [ "$MEMORY_USAGE" -gt 90 ]; then
        record_issue "内存使用率过高: ${MEMORY_USAGE}%"
        echo "建议："
        echo "  • 重启不必要的服务"
        echo "  • 增加服务器内存"
        echo "  • 优化应用配置"
    else
        log_success "内存使用率正常: ${MEMORY_USAGE}%"
    fi
    
    # 检查磁盘空间
    DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$DISK_USAGE" -gt 90 ]; then
        record_issue "磁盘空间不足: ${DISK_USAGE}%"
        echo "建议："
        echo "  • 清理不必要的文件"
        echo "  • 扩展磁盘空间"
        echo "  • 迁移数据到其他位置"
    else
        log_success "磁盘空间充足: ${DISK_USAGE}%"
    fi
    
    # 检查CPU负载
    CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    CPU_CORES=$(nproc)
    if (( $(echo "$CPU_LOAD > $CPU_CORES" | bc -l) )); then
        record_issue "CPU负载过高: $CPU_LOAD (核心数: $CPU_CORES)"
        echo "建议："
        echo "  • 检查高CPU使用进程"
        echo "  • 优化应用性能"
        echo "  • 升级服务器配置"
    else
        log_success "CPU负载正常: $CPU_LOAD"
    fi
    
    echo ""
}

# 检查6：云服务商安全组
check_cloud_security_groups() {
    log_info "检查6: 云服务商安全组..."
    
    PUBLIC_IP=$(curl -s --max-time 10 ifconfig.me 2>/dev/null)
    
    echo "请手动检查您的云服务商安全组配置："
    echo ""
    echo "需要开放的端口："
    echo "  • 22   (SSH)"
    echo "  • 3000 (瓦斯管理系统)"
    echo "  • 80   (HTTP，可选)"
    echo "  • 443  (HTTPS，可选)"
    echo ""
    echo "当前服务器IP: ${PUBLIC_IP:-"未知"}"
    echo ""
    echo "各云服务商配置方法："
    echo "  • 阿里云: ECS 控制台 → 安全组 → 配置规则"
    echo "  • 腾讯云: CVM 控制台 → 安全组 → 修改规则"
    echo "  • AWS:    EC2 Dashboard → Security Groups → Edit inbound rules"
    echo "  • Azure:  Virtual Machines → Networking → Inbound port rules"
    echo ""
    
    read -p "您是否已确认云服务商安全组配置正确？(y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_success "云服务商安全组配置已确认"
    else
        record_issue "云服务商安全组可能未正确配置"
        echo "请参考 EXTERNAL-ACCESS-GUIDE.md 进行配置"
    fi
    
    echo ""
}

# 自动修复尝试
auto_fix_attempt() {
    if [ $ISSUES_FOUND -eq 0 ]; then
        return
    fi
    
    log_info "尝试自动修复常见问题..."
    
    # 重启虚拟显示服务
    if ! pgrep -f "Xvfb :99" > /dev/null; then
        log_info "启动虚拟显示服务..."
        Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
        sleep 2
    fi
    
    # 重启应用服务
    log_info "重启应用服务..."
    systemctl restart gas-management
    sleep 5
    
    # 检查修复结果
    if systemctl is-active --quiet gas-management; then
        if netstat -tulpn 2>/dev/null | grep ":3000" | grep -q "0.0.0.0" || ss -tulpn 2>/dev/null | grep ":3000" | grep -q "0.0.0.0"; then
            record_fix "服务重启后运行正常"
        fi
    fi
    
    echo ""
}

# 生成诊断报告
generate_diagnostic_report() {
    REPORT_FILE="diagnostic-report-$(date +%Y%m%d_%H%M%S).txt"
    
    PUBLIC_IP=$(curl -s --max-time 10 ifconfig.me 2>/dev/null || echo "unknown")
    PRIVATE_IP=$(hostname -I | awk '{print $1}')
    
    cat > "$REPORT_FILE" << EOF
瓦斯行管理系统 - 故障诊断报告
Jy技術團隊 2025
生成时间: $(date)
=======================================

诊断结果:
- 发现问题: $ISSUES_FOUND 个
- 已修复问题: $ISSUES_FIXED 个
- 剩余问题: $((ISSUES_FOUND - ISSUES_FIXED)) 个

服务器信息:
- 公网IP: $PUBLIC_IP
- 内网IP: $PRIVATE_IP
- 操作系统: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)

服务状态:
$(systemctl status gas-management --no-pager 2>/dev/null || echo "服务状态检查失败")

端口监听:
$(netstat -tulpn 2>/dev/null | grep ":3000" || ss -tulpn 2>/dev/null | grep ":3000" || echo "未找到端口监听")

防火墙状态:
$(if command -v ufw &> /dev/null; then ufw status; elif command -v firewall-cmd &> /dev/null; then firewall-cmd --list-all; else echo "未检测到防火墙"; fi)

系统资源:
- 内存使用: $(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')
- 磁盘使用: $(df / | tail -1 | awk '{print $5}')
- CPU负载: $(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')

建议操作:
1. 如有剩余问题，请根据上述诊断结果进行手动修复
2. 确认云服务商安全组配置
3. 测试外网访问功能
4. 联系技术支持如需要进一步帮助
EOF
    
    log_success "诊断报告已生成: $REPORT_FILE"
}

# 显示修复建议
show_repair_suggestions() {
    echo ""
    echo "🔧 故障修复建议"
    echo "================"
    
    if [ $((ISSUES_FOUND - ISSUES_FIXED)) -gt 0 ]; then
        echo ""
        log_warning "仍有 $((ISSUES_FOUND - ISSUES_FIXED)) 个问题需要解决"
        echo ""
        echo "常见解决方案："
        echo ""
        echo "1. 服务无法启动："
        echo "   • 检查应用目录权限"
        echo "   • 确认 Node.js 已正确安装"
        echo "   • 查看服务日志: journalctl -u gas-management -f"
        echo ""
        echo "2. 外网无法访问："
        echo "   • 确认应用监听 0.0.0.0:3000"
        echo "   • 检查防火墙规则"
        echo "   • 验证云服务商安全组配置"
        echo ""
        echo "3. 性能问题："
        echo "   • 增加服务器资源"
        echo "   • 优化应用配置"
        echo "   • 清理系统缓存"
        echo ""
        echo "4. 网络连接问题："
        echo "   • 检查网络配置"
        echo "   • 验证DNS解析"
        echo "   • 测试基础网络连通性"
        echo ""
    else
        log_success "所有检测到的问题都已修复！"
        echo ""
        echo "建议进行最终测试："
        echo "  • 本地访问: http://localhost:3000"
        echo "  • 外网访问: http://$PUBLIC_IP:3000"
    fi
    
    echo ""
    echo "📞 如需技术支持，请联系 Jy技術團隊"
    echo "📧 请提供诊断报告以获得更好的支持"
}

# 主程序
main() {
    echo ""
    log_info "开始故障诊断..."
    echo ""
    
    check_service_status
    check_port_listening
    check_firewall
    check_network_connectivity
    check_system_resources
    check_cloud_security_groups
    
    auto_fix_attempt
    
    generate_diagnostic_report
    show_repair_suggestions
    
    echo ""
    if [ $ISSUES_FOUND -eq 0 ]; then
        log_success "未发现问题，系统运行正常！"
    else
        log_info "诊断完成，发现 $ISSUES_FOUND 个问题，已修复 $ISSUES_FIXED 个"
    fi
}

# 执行主程序
main "$@"
