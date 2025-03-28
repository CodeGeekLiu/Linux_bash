#!/bin/bash
# example Script_name ssh_port
# bash modify_ssh.sh 65555  
set -e

# 检查root权限
if [ "$EUID" -ne 0 ]; then
    echo "请以root用户或使用sudo运行此脚本"
    exit 1
fi

# 检查参数
if [ $# -ne 1 ]; then
    echo "使用方法: $0 <新SSH端口>"
    exit 1
fi

NEW_PORT=$1

# 验证端口有效性
if ! [[ $NEW_PORT =~ ^[0-9]+$ ]] || [ $NEW_PORT -lt 1 ] || [ $NEW_PORT -gt 65535 ]; then
    echo "错误：端口号无效，必须是1-65535之间的整数"
    exit 1
fi

# 备份配置文件
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# 配置修改函数
function set_ssh_config {
    local key="$1"
    local value="$2"
    local file="/etc/ssh/sshd_config"
    if grep -q -E "^#?$key" "$file"; then
        sed -i -E "s/^#?$key.*/$key $value/" "$file"
    else
        echo "$key $value" >> "$file"
    fi
}

# 应用配置修改
set_ssh_config Port "$NEW_PORT"
set_ssh_config PermitRootLogin "no"
set_ssh_config PubkeyAuthentication "yes"
set_ssh_config PasswordAuthentication "no"
set_ssh_config ChallengeResponseAuthentication "no"

# 配置测试
if ! sshd -t; then
    echo "SSH配置测试失败，已恢复备份文件"
    mv /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
    exit 1
fi


# 重启SSH服务（兼容不同发行版）
restart_ssh_service() {
    if command -v systemctl &> /dev/null; then
        # 尝试重启 sshd（CentOS/RHEL）
        systemctl restart sshd.service 2>/dev/null || \
        # 如果失败则尝试 ssh（Ubuntu/Debian）
        systemctl restart ssh.service
    else
        # SysV init 系统
        service sshd restart 2>/dev/null || \
        service ssh restart
    fi
}


# 输出提示信息
echo "===================================================="
echo "SSH配置已成功更新！"
echo "----------------------------------------------------"
echo "新SSH端口：$NEW_PORT"
echo "Root远程登录：已禁用"
echo "密钥认证：已启用"
echo "密码登录：已禁用"
echo "===================================================="
echo "重要提示："
echo "1. 请确保已正确配置以下内容："
echo "   - 防火墙开放新端口 $NEW_PORT"
echo "   - SELinux策略调整（如启用）"
echo "   - SSH密钥已添加到目标用户的 ~/.ssh/authorized_keys 文件"
echo "2. 配置文件备份：/etc/ssh/sshd_config.bak"
echo "3. 建议保持当前会话打开并新开窗口测试连接"
echo "===================================================="
