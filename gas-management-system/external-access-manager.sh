#!/bin/bash

# 瓦斯行管理系统 - 外网连线主控制脚本
# Jy技術團隊 2025

echo "🌐 瓦斯行管理系统 - 外网连线管理中心"
echo "Jy技術團隊 2025"
echo "=========================================="

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

# 检查脚本文件
check_scripts() {
    SCRIPTS=(
        "configure-external-access.sh"
        "test-network-connectivity.sh"
        "setup-ssl-certificate.sh"
        "deploy-external-access.sh"
        "troubleshoot-external-access.sh"
    )
    
    MISSING_SCRIPTS=()
    
    for script in "${SCRIPTS[@]}"; do
        if [ ! -f "$script" ]; then
            MISSING_SCRIPTS+=("$script")
        else
            chmod +x "$script" 2>/dev/null
        fi
    done
    
    if [ ${#MISSING_SCRIPTS[@]} -gt 0 ]; then
        log_error "缺少以下脚本文件:"
        for script in "${MISSING_SCRIPTS[@]}"; do
            echo "  • $script"
        done
        echo ""
        echo "请确保所有脚本文件都在当前目录中。"
        exit 1
    fi
    
    log_success "所有脚本文件已准备就绪"
}

# 显示主菜单
show_main_menu() {
    echo ""
    echo "🚀 外网连线管理选项："
    echo ""
    echo "  1) 一键部署外网访问     - 自动配置所有外网访问设置"
    echo "  2) 基础外网访问配置     - 仅配置防火墙和网络设置" 
    echo "  3) 网络连通性测试       - 测试当前网络配置状态"
    echo "  4) SSL证书配置         - 配置HTTPS安全访问"
    echo "  5) 故障排除工具         - 诊断和修复访问问题"
    echo "  6) 查看系统状态         - 显示当前系统运行状态"
    echo "  7) 查看访问地址         - 显示所有可用访问地址"
    echo "  8) 查看帮助文档         - 显示详细配置说明"
    echo "  0) 退出"
    echo ""
    echo "📖 详细文档: EXTERNAL-ACCESS-GUIDE.md"
    echo ""
}

# 获取系统状态
get_system_status() {
    # 服务状态
    if systemctl is-active --quiet gas-management; then
        SERVICE_STATUS="${GREEN}运行中${NC}"
    else
        SERVICE_STATUS="${RED}未运行${NC}"
    fi
    
    # 端口监听状态
    if netstat -tulpn 2>/dev/null | grep ":3000" | grep -q "0.0.0.0" || ss -tulpn 2>/dev/null | grep ":3000" | grep -q "0.0.0.0"; then
        PORT_STATUS="${GREEN}正常${NC}"
    else
        PORT_STATUS="${RED}异常${NC}"
    fi
    
    # 防火墙状态
    if command -v ufw &> /dev/null && ufw status | grep -q "Status: active"; then
        if ufw status | grep -q "3000"; then
            FIREWALL_STATUS="${GREEN}已配置${NC}"
        else
            FIREWALL_STATUS="${YELLOW}未配置端口${NC}"
        fi
    elif command -v firewall-cmd &> /dev/null && systemctl is-active --quiet firewalld; then
        if firewall-cmd --list-ports | grep -q "3000"; then
            FIREWALL_STATUS="${GREEN}已配置${NC}"
        else
            FIREWALL_STATUS="${YELLOW}未配置端口${NC}"
        fi
    else
        FIREWALL_STATUS="${YELLOW}未知${NC}"
    fi
    
    # 获取IP地址
    PUBLIC_IP=$(curl -s --max-time 5 ifconfig.me 2>/dev/null || echo "获取失败")
    PRIVATE_IP=$(hostname -I | awk '{print $1}')
}

# 显示系统状态
show_system_status() {
    log_info "获取系统状态..."
    get_system_status
    
    echo ""
    echo "📊 系统状态概览"
    echo "================"
    echo ""
    echo -e "🔧 服务状态:     $SERVICE_STATUS"
    echo -e "🌐 端口监听:     $PORT_STATUS"
    echo -e "🛡️ 防火墙:      $FIREWALL_STATUS"
    echo ""
    echo "🌍 网络信息:"
    echo "  • 公网IP: $PUBLIC_IP"
    echo "  • 内网IP: $PRIVATE_IP"
    echo ""
    
    # 内存和磁盘使用情况
    MEMORY_USAGE=$(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')
    DISK_USAGE=$(df / | tail -1 | awk '{print $5}')
    
    echo "💾 资源使用:"
    echo "  • 内存使用: $MEMORY_USAGE"
    echo "  • 磁盘使用: $DISK_USAGE"
    echo ""
}

# 显示访问地址
show_access_urls() {
    get_system_status
    
    echo ""
    echo "🌐 访问地址"
    echo "==========="
    echo ""
    
    if systemctl is-active --quiet gas-management; then
        echo "✅ 系统正在运行，可通过以下地址访问:"
        echo ""
        echo "  🌍 外网访问: http://$PUBLIC_IP:3000"
        echo "  🏠 内网访问: http://$PRIVATE_IP:3000"
        echo "  💻 本地访问: http://localhost:3000"
        
        # 检查是否配置了SSL
        if [ -f "/etc/nginx/sites-available/gas-management" ] || [ -f "/etc/nginx/conf.d/gas-management.conf" ]; then
            echo "  🔒 HTTPS访问: https://your-domain.com (如已配置SSL)"
        fi
        
        echo ""
        echo "👤 登录账号:"
        echo "  • 管理员: admin / password"
        echo "  • 经理:   manager / password"  
        echo "  • 员工:   employee / password"
        echo ""
        echo "⚠️  请在首次登录后更改默认密码！"
        
    else
        echo "❌ 系统未运行，请先启动服务:"
        echo "   sudo systemctl start gas-management"
    fi
    echo ""
}

# 显示帮助信息
show_help() {
    echo ""
    echo "📖 外网连线配置帮助"
    echo "==================="
    echo ""
    echo "🔧 配置步骤:"
    echo "  1. 运行基础外网访问配置"
    echo "  2. 配置云服务商安全组开放端口 3000"
    echo "  3. 测试网络连通性"
    echo "  4. (可选) 配置SSL证书启用HTTPS"
    echo ""
    echo "🛡️ 必要端口:"
    echo "  • 22   - SSH访问"
    echo "  • 3000 - 瓦斯管理系统"
    echo "  • 80   - HTTP (配置SSL时需要)"
    echo "  • 443  - HTTPS (配置SSL时需要)"
    echo ""
    echo "☁️ 云服务商配置:"
    echo "  • 阿里云: ECS 控制台 → 安全组 → 配置规则"
    echo "  • 腾讯云: CVM 控制台 → 安全组 → 修改规则"
    echo "  • AWS:    EC2 Dashboard → Security Groups → Edit inbound rules"
    echo "  • Azure:  Virtual Machines → Networking → Inbound port rules"
    echo ""
    echo "🔍 故障排除:"
    echo "  • 检查服务状态: systemctl status gas-management"
    echo "  • 查看端口监听: netstat -tulpn | grep :3000"
    echo "  • 检查防火墙: ufw status 或 firewall-cmd --list-all"
    echo "  • 运行故障排除工具进行自动诊断"
    echo ""
    echo "📚 详细文档: EXTERNAL-ACCESS-GUIDE.md"
    echo ""
}

# 执行选择的操作
execute_option() {
    local option=$1
    
    case $option in
        1)
            log_info "启动一键部署外网访问..."
            echo ""
            if [ -f "deploy-external-access.sh" ]; then
                ./deploy-external-access.sh
            else
                log_error "部署脚本未找到"
            fi
            ;;
        2)
            log_info "启动基础外网访问配置..."
            echo ""
            if [ -f "configure-external-access.sh" ]; then
                ./configure-external-access.sh
            else
                log_error "配置脚本未找到"
            fi
            ;;
        3)
            log_info "启动网络连通性测试..."
            echo ""
            if [ -f "test-network-connectivity.sh" ]; then
                ./test-network-connectivity.sh
            else
                log_error "测试脚本未找到"
            fi
            ;;
        4)
            log_info "启动SSL证书配置..."
            echo ""
            if [ -f "setup-ssl-certificate.sh" ]; then
                ./setup-ssl-certificate.sh
            else
                log_error "SSL配置脚本未找到"
            fi
            ;;
        5)
            log_info "启动故障排除工具..."
            echo ""
            if [ -f "troubleshoot-external-access.sh" ]; then
                ./troubleshoot-external-access.sh
            else
                log_error "故障排除脚本未找到"
            fi
            ;;
        6)
            show_system_status
            ;;
        7)
            show_access_urls
            ;;
        8)
            show_help
            ;;
        0)
            log_info "退出外网连线管理中心"
            exit 0
            ;;
        *)
            log_error "无效选择，请输入 0-8"
            ;;
    esac
}

# 主循环
main_loop() {
    while true; do
        show_main_menu
        read -p "请选择操作 (0-8): " choice
        echo ""
        
        # 检查是否需要root权限
        if [[ "$choice" =~ ^[1-5]$ ]]; then
            if [ "$EUID" -ne 0 ]; then
                log_error "此操作需要 root 权限"
                echo "请使用: sudo $0"
                echo ""
                continue
            fi
        fi
        
        execute_option "$choice"
        
        if [[ "$choice" =~ ^[1-5]$ ]]; then
            echo ""
            read -p "按 Enter 键返回主菜单..."
        fi
        
        echo ""
    done
}

# 主程序
main() {
    # 检查脚本文件
    check_scripts
    
    # 显示欢迎信息
    echo ""
    log_success "欢迎使用瓦斯行管理系统外网连线管理中心"
    echo ""
    echo "此工具提供完整的外网访问配置和管理功能："
    echo "  🚀 一键部署外网访问"
    echo "  🔧 分步配置和测试"
    echo "  🔒 SSL证书配置"
    echo "  🔍 故障诊断和修复"
    echo ""
    
    # 快速状态检查
    if systemctl is-active --quiet gas-management 2>/dev/null; then
        log_success "检测到瓦斯管理系统正在运行"
    else
        log_warning "瓦斯管理系统未运行，可能需要配置"
    fi
    
    # 进入主循环
    main_loop
}

# 执行主程序
main "$@"
