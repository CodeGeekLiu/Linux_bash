#!/bin/bash
# 使用说明: 脚本名 SSH端口 用户名 [公钥文件路径]
# 示例: bash modify_ssh.sh 65555 appuser /path/to/public_key.pub
set -e

# 检查root权限
if [ "$EUID" -ne 0 ]; then
    echo "请以root用户或使用sudo运行此脚本"
    exit 1
fi

# 检查参数
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "使用方法: $0 <新SSH端口> <用户名> [公钥文件路径]"
    echo "注意: 如果未提供公钥文件路径，需要手动配置公钥"
    exit 1
fi

NEW_PORT=$1
SSH_USER=$2
PUBKEY_FILE=${3:-}

# 验证端口有效性
if ! [[ $NEW_PORT =~ ^[0-9]+$ ]] || [ $NEW_PORT -lt 1 ] || [ $NEW_PORT -gt 65535 ]; then
    echo "错误：端口号无效，必须是1-65535之间的整数"
    exit 1
fi

# 检查用户是否存在
if ! id "$SSH_USER" &>/dev/null; then
    echo "创建用户: $SSH_USER"
    useradd -m -s /bin/bash "$SSH_USER"
    echo "用户 $SSH_USER 已创建，请手动设置密码（如果需要）"
fi

# 配置公钥
if [ -n "$PUBKEY_FILE" ]; then
    if [ ! -f "$PUBKEY_FILE" ]; then
        echo "错误：公钥文件 $PUBKEY_FILE 不存在"
        exit 1
    fi
    
    SSH_DIR="/home/$SSH_USER/.ssh"
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    
    # 添加公钥到authorized_keys
    cat "$PUBKEY_FILE" >> "$SSH_DIR/authorized_keys"
    chmod 600 "$SSH_DIR/authorized_keys"
    chown -R "$SSH_USER:$SSH_USER" "$SSH_DIR"
    echo "公钥已添加到 $SSH_USER 用户"
else
    echo "警告：未提供公钥文件，请手动配置公钥"
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
set_ssh_config AllowUsers "$SSH_USER"

# 配置测试
if ! sshd -t; then
    echo "SSH配置测试失败，已恢复备份文件"
    mv /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
    exit 1
fi

# 重启SSH服务
restart_ssh_service() {
    if command -v systemctl &> /dev/null; then
        systemctl restart sshd.service 2>/dev/null || \
        systemctl restart ssh.service
    else
        service sshd restart 2>/dev/null || \
        service ssh restart
    fi
}
restart_ssh_service

# 输出提示信息
echo "===================================================="
echo "SSH配置已成功更新！"
echo "----------------------------------------------------"
echo "新SSH端口：$NEW_PORT"
echo "允许登录用户：$SSH_USER"
echo "Root远程登录：已禁用"
echo "密钥认证：已启用"
echo "密码登录：已禁用"
echo "===================================================="
echo "重要提示："
echo "1. 防火墙需要开放端口 $NEW_PORT"
echo "2. 配置文件备份：/etc/ssh/sshd_config.bak"
echo "3. 保持当前会话并新开窗口测试连接"
echo "===================================================="
echo "                  密钥使用说明                      "
echo "===================================================="
echo "1. 私钥生成位置（在客户端生成）:"
echo "   - 默认位置: ~/.ssh/id_rsa"
echo "   - 生成命令: ssh-keygen -t rsa -b 4096"
echo ""
echo "2. 私钥导出方法:"
echo "   - 方法1: 直接复制 ~/.ssh/id_rsa 文件内容"
echo "   - 方法2: 使用命令导出:"
echo "        cat ~/.ssh/id_rsa"
echo ""
echo "3. 公钥配置位置:"
echo "   - 服务器位置: /home/$SSH_USER/.ssh/authorized_keys"
echo ""
echo "4. 连接测试命令:"
echo "   ssh -i /path/to/private_key $SSH_USER@host -p $NEW_PORT"
echo "===================================================="
