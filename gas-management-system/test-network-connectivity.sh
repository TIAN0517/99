#!/bin/bash

# 瓦斯行管理系统 - 网络连通性测试工具
# Jy技術團隊 2025

echo "🔍 瓦斯行管理系统 - 网络连通性测试"
echo "Jy技術團隊 2025"
echo "=================================="

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

# 获取IP信息
get_ip_info() {
    log_info "获取网络信息..."
    
    # 公网IP
    PUBLIC_IP=$(curl -s --max-time 10 ifconfig.me 2>/dev/null || curl -s --max-time 10 ipinfo.io/ip 2>/dev/null)
    if [ -n "$PUBLIC_IP" ]; then
        log_success "公网 IP: $PUBLIC_IP"
    else
        log_warning "无法获取公网 IP"
        PUBLIC_IP="unknown"
    fi
    
    # 内网IP
    PRIVATE_IP=$(hostname -I | awk '{print $1}')
    log_info "内网 IP: $PRIVATE_IP"
    
    # 网关
    GATEWAY=$(ip route | grep default | awk '{print $3}' | head -1)
    log_info "网关: $GATEWAY"
    
    echo ""
}

# 检查端口监听
check_port_listening() {
    log_info "检查端口监听状态..."
    
    # 检查 3000 端口
    if netstat -tulpn 2>/dev/null | grep ":3000" > /dev/null || ss -tulpn 2>/dev/null | grep ":3000" > /dev/null; then
        log_success "端口 3000 正在监听"
        
        # 检查监听地址
        LISTEN_ADDR=$(netstat -tulpn 2>/dev/null | grep ":3000" | awk '{print $4}' || ss -tulpn 2>/dev/null | grep ":3000" | awk '{print $5}')
        echo "  监听地址: $LISTEN_ADDR"
        
        if echo "$LISTEN_ADDR" | grep -q "0.0.0.0"; then
            log_success "应用正在监听所有网络接口"
        elif echo "$LISTEN_ADDR" | grep -q "127.0.0.1\|localhost"; then
            log_warning "应用仅监听本地接口，外网无法访问"
        fi
    else
        log_error "端口 3000 未在监听"
    fi
    
    # 检查 11434 端口 (AI API)
    if netstat -tulpn 2>/dev/null | grep ":11434" > /dev/null || ss -tulpn 2>/dev/null | grep ":11434" > /dev/null; then
        log_success "AI API 端口 11434 正在监听"
    else
        log_warning "AI API 端口 11434 未在监听"
    fi
    
    echo ""
}

# 检查防火墙状态
check_firewall() {
    log_info "检查防火墙状态..."
    
    if command -v ufw &> /dev/null; then
        log_info "检查 UFW 防火墙..."
        if ufw status | grep -q "Status: active"; then
            log_success "UFW 防火墙已启用"
            
            # 检查端口规则
            if ufw status | grep -q "3000"; then
                log_success "端口 3000 已在防火墙中开放"
            else
                log_warning "端口 3000 未在防火墙中开放"
            fi
            
            echo "当前 UFW 规则:"
            ufw status numbered
        else
            log_warning "UFW 防火墙未启用"
        fi
        
    elif command -v firewall-cmd &> /dev/null; then
        log_info "检查 Firewalld 防火墙..."
        if systemctl is-active --quiet firewalld; then
            log_success "Firewalld 防火墙已启用"
            
            # 检查端口规则
            if firewall-cmd --list-ports | grep -q "3000"; then
                log_success "端口 3000 已在防火墙中开放"
            else
                log_warning "端口 3000 未在防火墙中开放"
            fi
            
            echo "当前 Firewalld 规则:"
            firewall-cmd --list-all
        else
            log_warning "Firewalld 防火墙未启用"
        fi
        
    elif command -v iptables &> /dev/null; then
        log_info "检查 iptables 防火墙..."
        if iptables -L -n | grep -q "3000"; then
            log_success "端口 3000 已在 iptables 中配置"
        else
            log_warning "端口 3000 未在 iptables 中配置"
        fi
        
    else
        log_warning "未检测到防火墙工具"
    fi
    
    echo ""
}

# 检查服务状态
check_service_status() {
    log_info "检查服务状态..."
    
    # 检查主应用服务
    if systemctl is-active --quiet gas-management; then
        log_success "瓦斯管理系统服务运行正常"
        
        # 显示服务信息
        echo "服务状态:"
        systemctl status gas-management --no-pager -l
    else
        log_error "瓦斯管理系统服务未运行"
        
        echo "最近的错误日志:"
        journalctl -u gas-management --since "10 minutes ago" -n 10 --no-pager
    fi
    
    # 检查 Xvfb
    if pgrep -f "Xvfb :99" > /dev/null; then
        log_success "虚拟显示服务 (Xvfb) 运行正常"
    else
        log_warning "虚拟显示服务 (Xvfb) 未运行"
    fi
    
    echo ""
}

# 测试本地连接
test_local_connection() {
    log_info "测试本地连接..."
    
    # 测试 localhost
    if curl -s --max-time 10 http://localhost:3000 > /dev/null 2>&1; then
        log_success "本地访问 (localhost:3000) 正常"
    else
        log_error "本地访问 (localhost:3000) 失败"
    fi
    
    # 测试内网IP
    if [ -n "$PRIVATE_IP" ] && [ "$PRIVATE_IP" != "127.0.0.1" ]; then
        if curl -s --max-time 10 "http://$PRIVATE_IP:3000" > /dev/null 2>&1; then
            log_success "内网访问 ($PRIVATE_IP:3000) 正常"
        else
            log_error "内网访问 ($PRIVATE_IP:3000) 失败"
        fi
    fi
    
    echo ""
}

# 测试外网连接
test_external_connection() {
    log_info "测试外网连接..."
    
    if [ -n "$PUBLIC_IP" ] && [ "$PUBLIC_IP" != "unknown" ]; then
        log_info "尝试从外网访问 $PUBLIC_IP:3000..."
        
        # 注意：这个测试从服务器内部发起，可能不准确
        # 建议用户从外部网络测试
        log_warning "注意：从服务器内部测试外网访问可能不准确"
        log_info "请从其他网络环境测试: http://$PUBLIC_IP:3000"
        
        # 尝试基本的网络连通性测试
        if ping -c 3 8.8.8.8 > /dev/null 2>&1; then
            log_success "服务器网络连通性正常"
        else
            log_error "服务器网络连通性异常"
        fi
    else
        log_error "无法获取公网 IP，无法测试外网访问"
    fi
    
    echo ""
}

# 检查云服务商安全组
check_cloud_security() {
    log_info "云服务商安全组检查提醒..."
    
    echo "请确认以下云服务商安全组设置:"
    echo ""
    echo "📋 需要开放的端口:"
    echo "  • 22    (SSH)"
    echo "  • 3000  (瓦斯管理系统)"
    echo "  • 80    (HTTP，可选)"
    echo "  • 443   (HTTPS，可选)"
    echo "  • 11434 (AI API，可选)"
    echo ""
    echo "🔧 各云服务商配置方法:"
    echo "  • 阿里云: ECS 控制台 → 安全组 → 配置规则"
    echo "  • 腾讯云: CVM 控制台 → 安全组 → 修改规则"
    echo "  • AWS:    EC2 Dashboard → Security Groups → Edit inbound rules"
    echo "  • Azure:  Virtual Machines → Networking → Inbound port rules"
    echo ""
    echo "📖 详细说明请查看: EXTERNAL-ACCESS-GUIDE.md"
    echo ""
}

# 生成测试报告
generate_report() {
    log_info "生成测试报告..."
    
    REPORT_FILE="network-test-report-$(date +%Y%m%d_%H%M%S).txt"
    
    cat > "$REPORT_FILE" << EOF
瓦斯行管理系统 - 网络连通性测试报告
Jy技術團隊 2025
生成时间: $(date)
================================

网络信息:
- 公网 IP: $PUBLIC_IP
- 内网 IP: $PRIVATE_IP
- 网关: $GATEWAY

端口监听状态:
$(netstat -tulpn 2>/dev/null | grep ":3000\|:11434" || ss -tulpn 2>/dev/null | grep ":3000\|:11434" || echo "未找到监听端口")

防火墙状态:
$(if command -v ufw &> /dev/null; then ufw status; elif command -v firewall-cmd &> /dev/null; then firewall-cmd --list-all; else echo "未检测到防火墙"; fi)

服务状态:
$(systemctl status gas-management --no-pager 2>/dev/null || echo "服务状态检查失败")

访问地址:
- 外网访问: http://$PUBLIC_IP:3000
- 内网访问: http://$PRIVATE_IP:3000
- 本地访问: http://localhost:3000

建议检查项目:
1. 确认云服务商安全组已开放 3000 端口
2. 确认应用监听在 0.0.0.0:3000 而非 localhost:3000
3. 确认防火墙规则正确配置
4. 从外部网络测试访问
EOF
    
    log_success "测试报告已生成: $REPORT_FILE"
    echo ""
}

# 提供解决方案
provide_solutions() {
    log_info "常见问题解决方案..."
    
    echo "🔧 如果外网无法访问，请检查:"
    echo ""
    echo "1. 应用监听地址问题:"
    echo "   解决: 确保应用监听 0.0.0.0:3000 而非 localhost:3000"
    echo "   命令: 重新运行 ./configure-external-access.sh"
    echo ""
    echo "2. 防火墙阻止访问:"
    echo "   解决: 开放 3000 端口"
    echo "   Ubuntu/Debian: sudo ufw allow 3000"
    echo "   CentOS/RHEL: sudo firewall-cmd --permanent --add-port=3000/tcp && sudo firewall-cmd --reload"
    echo ""
    echo "3. 云服务商安全组未配置:"
    echo "   解决: 在云控制台开放 3000 端口"
    echo "   详见: EXTERNAL-ACCESS-GUIDE.md"
    echo ""
    echo "4. 服务未启动:"
    echo "   检查: sudo systemctl status gas-management"
    echo "   启动: sudo systemctl start gas-management"
    echo "   重启: sudo systemctl restart gas-management"
    echo ""
    echo "5. 端口被占用:"
    echo "   检查: sudo netstat -tulpn | grep :3000"
    echo "   解决: 停止占用端口的进程或更改应用端口"
    echo ""
}

# 主程序
main() {
    get_ip_info
    check_port_listening
    check_firewall
    check_service_status
    test_local_connection
    test_external_connection
    check_cloud_security
    generate_report
    provide_solutions
    
    echo "🎯 测试完成！请查看上述信息排查问题。"
    echo "📞 技术支持: Jy技術團隊 2025"
}

# 执行主程序
main "$@"
