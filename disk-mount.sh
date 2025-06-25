#!/bin/bash

# 配置信息
USER="root"
PASSWORD="123456"  # 密码硬编码为123456
PREFIX="192.168.139."
DISK='/dev/sdb'
LOG="/tmp/disk_mount.log"
PORT=22  # SSH端口
TIMEOUT=2  # 连接超时(秒)

# 清空日志文件
> "$LOG"

# 生成IP列表
IPS=()
for i in {148..150}; do
    IPS+=("${PREFIX}$i")
done

# 检查端口连通性函数
check_port() {
    local ip=$1 port=$2
    timeout $TIMEOUT bash -c ">/dev/tcp/$ip/$port" &>/dev/null
    return $?
}

# 主循环
for IP in "${IPS[@]}"; do
    echo "处理 $IP..." | tee -a "$LOG"
    
    # 检查网络连通性
    if ! check_port "$IP" "$PORT"; then
        echo "$IP: 端口 $PORT 不通，跳过处理" | tee -a "$LOG"
        echo "-----------------------------------" | tee -a "$LOG"
        continue
    fi
    
    # 执行磁盘操作
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USER@$IP" << EOF
echo "$IP 连接成功"
pvcreate $DISK
mkdir -p /data
vgcreate data $DISK
lvcreate -n data -l +100%FREE data
mkfs.xfs -f /dev/mapper/data-data
mkdir -p /data
LINE='/dev/mapper/data-data /data xfs defaults 0 0'
grep -qxF "$LINE" /etc/fstab || echo "$LINE" >> /etc/fstab
mount -a || { echo "挂载失败，检查/etc/fstab配置"; exit 1; }
df -h /data
exit
EOF

    # 检查SSH命令退出状态
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        echo "$IP: 操作过程中发生错误" | tee -a "$LOG"
    else
        echo "$IP 操作完成" | tee -a "$LOG"
    fi
    sleep 2
    echo "-----------------------------------" | tee -a "$LOG"
done
