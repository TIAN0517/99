#!/bin/bash

# 瓦斯行管理系统 - 一键外网访问部署脚本
# Jy技術團隊 2025
# 此脚本将自动配置所有外网访问所需的设置

echo "🚀 瓦斯行管理系统 - 一键外网访问部署"
echo "Jy技術團隊 2025"
echo "=============================================="

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

# 显示欢迎信息
show_welcome() {
    echo ""
    echo "🌟 欢迎使用瓦斯行管理系统一键外网部署工具"
    echo ""
    echo "此工具将为您自动配置："
    echo "  ✅ 服务器防火墙规则"
    echo "  ✅ 应用网络设置"
    echo "  ✅ 系统服务配置"
    echo "  ✅ 外网访问测试"
    echo "  ✅ SSL证书配置 (可选)"
    echo ""
    read -p "按 Enter 键继续，或按 Ctrl+C 退出..." 
    echo ""
}

# 检查系统要求
check_requirements() {
    log_info "检查系统要求..."
    
    # 检查是否为 root 用户
    if [ "$EUID" -ne 0 ]; then
        log_error "请使用 root 权限运行此脚本"
        echo "执行: sudo $0"
        exit 1
    fi
    
    # 检查操作系统
    if [ ! -f /etc/os-release ]; then
        log_error "不支持的操作系统"
        exit 1
    fi
    
    . /etc/os-release
    log_info "操作系统: $PRETTY_NAME"
    
    # 检查网络连接
    if ! ping -c 1 8.8.8.8 > /dev/null 2>&1; then
        log_warning "网络连接可能存在问题"
    else
        log_success "网络连接正常"
    fi
    
    # 检查必要工具
    REQUIRED_TOOLS=("curl" "wget" "systemctl")
    for tool in "${REQUIRED_TOOLS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            log_error "缺少必要工具: $tool"
            exit 1
        fi
    done
    
    log_success "系统要求检查通过"
}

# 选择部署模式
select_deployment_mode() {
    log_info "选择部署模式..."
    echo ""
    echo "请选择部署模式："
    echo "  1) 快速部署 (HTTP访问，适合测试环境)"
    echo "  2) 完整部署 (HTTP + HTTPS，适合生产环境)"
    echo "  3) 仅配置外网访问 (不安装SSL)"
    echo ""
    
    while true; do
        read -p "请输入选择 (1-3): " DEPLOYMENT_MODE
        case $DEPLOYMENT_MODE in
            1) 
                DEPLOY_TYPE="quick"
                ENABLE_SSL=false
                break
                ;;
            2)
                DEPLOY_TYPE="complete"
                ENABLE_SSL=true
                break
                ;;
            3)
                DEPLOY_TYPE="access_only"
                ENABLE_SSL=false
                break
                ;;
            *)
                log_warning "无效选择，请输入 1、2 或 3"
                ;;
        esac
    done
    
    log_info "已选择部署模式: $DEPLOY_TYPE"
}

# 步骤1：基础外网访问配置
configure_basic_access() {
    log_info "步骤 1/4: 配置基础外网访问..."
    
    if [ -f "./configure-external-access.sh" ]; then
        chmod +x ./configure-external-access.sh
        ./configure-external-access.sh
        
        if [ $? -eq 0 ]; then
            log_success "基础外网访问配置完成"
        else
            log_error "基础外网访问配置失败"
            exit 1
        fi
    else
        log_error "未找到配置脚本: configure-external-access.sh"
        exit 1
    fi
}

# 步骤2：网络连通性测试
test_connectivity() {
    log_info "步骤 2/4: 测试网络连通性..."
    
    if [ -f "./test-network-connectivity.sh" ]; then
        chmod +x ./test-network-connectivity.sh
        ./test-network-connectivity.sh
        
        log_info "网络连通性测试完成，请查看上述结果"
    else
        log_warning "未找到测试脚本，跳过网络测试"
    fi
    
    echo ""
    read -p "按 Enter 键继续..."
}

# 步骤3：SSL证书配置 (可选)
configure_ssl() {
    if [ "$ENABLE_SSL" = true ]; then
        log_info "步骤 3/4: 配置SSL证书..."
        
        echo ""
        echo "SSL证书配置需要："
        echo "  • 一个已注册的域名"
        echo "  • 域名DNS记录指向此服务器"
        echo "  • 有效的邮箱地址"
        echo ""
        
        read -p "您是否已准备好域名和DNS解析？(y/N): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if [ -f "./setup-ssl-certificate.sh" ]; then
                chmod +x ./setup-ssl-certificate.sh
                ./setup-ssl-certificate.sh
                
                if [ $? -eq 0 ]; then
                    log_success "SSL证书配置完成"
                    SSL_CONFIGURED=true
                else
                    log_warning "SSL证书配置失败，将继续使用HTTP访问"
                    SSL_CONFIGURED=false
                fi
            else
                log_warning "未找到SSL配置脚本，跳过SSL配置"
                SSL_CONFIGURED=false
            fi
        else
            log_info "跳过SSL配置，您可以稍后运行 ./setup-ssl-certificate.sh"
            SSL_CONFIGURED=false
        fi
    else
        log_info "步骤 3/4: 跳过SSL配置 (根据部署模式选择)"
        SSL_CONFIGURED=false
    fi
}

# 步骤4：最终验证和信息显示
final_verification() {
    log_info "步骤 4/4: 最终验证..."
    
    # 获取服务器IP信息
    PUBLIC_IP=$(curl -s --max-time 10 ifconfig.me 2>/dev/null || echo "unknown")
    PRIVATE_IP=$(hostname -I | awk '{print $1}')
    
    # 检查服务状态
    if systemctl is-active --quiet gas-management; then
        log_success "瓦斯管理系统服务运行正常"
        SERVICE_STATUS="运行中"
    else
        log_warning "瓦斯管理系统服务未运行"
        SERVICE_STATUS="未运行"
    fi
    
    # 检查端口监听
    if netstat -tulpn 2>/dev/null | grep ":3000" | grep -q "0.0.0.0" || ss -tulpn 2>/dev/null | grep ":3000" | grep -q "0.0.0.0"; then
        log_success "应用正在监听外网接口"
        PORT_STATUS="正常"
    else
        log_warning "应用可能未正确监听外网接口"
        PORT_STATUS="异常"
    fi
    
    # 生成部署报告
    generate_deployment_report
}

# 生成部署报告
generate_deployment_report() {
    REPORT_FILE="deployment-report-$(date +%Y%m%d_%H%M%S).txt"
    
    cat > "$REPORT_FILE" << EOF
瓦斯行管理系统 - 外网访问部署报告
Jy技術團隊 2025
生成时间: $(date)
=====================================

部署信息:
- 部署模式: $DEPLOY_TYPE
- SSL证书: $([ "$SSL_CONFIGURED" = true ] && echo "已配置" || echo "未配置")
- 服务状态: $SERVICE_STATUS
- 端口状态: $PORT_STATUS

服务器信息:
- 公网IP: $PUBLIC_IP
- 内网IP: $PRIVATE_IP
- 操作系统: $PRETTY_NAME

访问地址:
$(if [ "$SSL_CONFIGURED" = true ]; then
    echo "- HTTPS访问: https://your-domain.com"
fi)
- HTTP访问: http://$PUBLIC_IP:3000
- 内网访问: http://$PRIVATE_IP:3000
- 本地访问: http://localhost:3000

登录账号:
- 管理员: admin / password
- 经理:   manager / password
- 员工:   employee / password

管理命令:
- 查看服务状态: systemctl status gas-management
- 重启服务: systemctl restart gas-management
- 查看日志: journalctl -u gas-management -f

注意事项:
1. 请确保云服务商安全组已开放相应端口
2. 建议立即更改默认登录密码
3. 定期检查服务运行状态
4. 考虑配置定期数据备份
EOF
    
    log_success "部署报告已生成: $REPORT_FILE"
}

# 显示最终结果
show_final_result() {
    echo ""
    echo "🎉 外网访问部署完成！"
    echo "=============================================="
    echo ""
    
    # 根据配置显示访问地址
    log_success "访问地址:"
    if [ "$SSL_CONFIGURED" = true ]; then
        echo "  🔒 HTTPS 访问: https://your-domain.com"
    fi
    echo "  🌍 HTTP 访问:  http://$PUBLIC_IP:3000"
    echo "  🏠 内网访问:  http://$PRIVATE_IP:3000"
    echo "  💻 本地访问:  http://localhost:3000"
    
    echo ""
    log_success "登录账号:"
    echo "  👨‍💼 管理员: admin / password"
    echo "  👨‍💼 经理:   manager / password"
    echo "  👨‍💼 员工:   employee / password"
    
    echo ""
    log_info "下一步操作:"
    echo "  1. 🛡️ 确保云服务商安全组已开放端口 3000"
    echo "  2. 🔐 登录系统并更改默认密码"
    echo "  3. 📊 熟悉系统功能和界面"
    echo "  4. 💾 配置定期数据备份"
    
    echo ""
    log_warning "重要提醒:"
    echo "  • 请立即更改默认登录密码"
    echo "  • 定期检查系统安全更新"
    echo "  • 监控系统资源使用情况"
    echo "  • 保持软件版本最新"
    
    echo ""
    echo "📖 详细文档: 查看 EXTERNAL-ACCESS-GUIDE.md"
    echo "🔧 技术支持: Jy技術團隊 2025"
    echo ""
    
    if [ "$SERVICE_STATUS" = "运行中" ] && [ "$PORT_STATUS" = "正常" ]; then
        log_success "部署成功！系统已准备好外网访问。"
    else
        log_warning "部署完成，但可能需要额外配置。请查看上述状态信息。"
    fi
}

# 清理函数
cleanup() {
    log_info "清理临时文件..."
    # 这里可以添加清理逻辑
    log_success "清理完成"
}

# 错误处理
handle_error() {
    log_error "部署过程中发生错误"
    log_info "正在进行错误清理..."
    cleanup
    
    echo ""
    echo "🔧 故障排除建议："
    echo "  1. 检查网络连接"
    echo "  2. 确认系统权限"
    echo "  3. 查看错误日志"
    echo "  4. 联系技术支持"
    
    exit 1
}

# 设置错误处理
trap handle_error ERR

# 主程序
main() {
    show_welcome
    check_requirements
    echo ""
    
    select_deployment_mode
    echo ""
    
    configure_basic_access
    echo ""
    
    test_connectivity
    echo ""
    
    configure_ssl
    echo ""
    
    final_verification
    echo ""
    
    show_final_result
}

# 执行主程序
main "$@"
