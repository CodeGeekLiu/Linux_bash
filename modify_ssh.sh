
====== 开始系统检查 ======

>>> 系统基本信息检查
=======================================================
主机名        : VM-20-5-opencloudos
操作系统版本  : OpenCloudOS 9.2
内核版本      : 6.6.47-12.oc9.x86_64
系统运行时间  : 09:30:13 up 3 days

>>> CPU检查
=======================================================
CPU型号       : AMD EPYC 7K62 48-Core Processor 3.0 CPU @ 2.0GHz
物理核心数    : 2
逻辑核心数    : 2
当前负载      : 0.00, 0.00, 0.00

>>> 内存检查
=======================================================
总内存      : 3.6Gi
已用内存    : 2.4Gi
可用内存    : 1.1Gi
交换分区    : 0B
已用交换    : 0B

>>> 硬盘检查
=======================================================
挂载点  总大小  已用  可用  使用率
/       70G     7.7G  63G   11%

>>> 网络接口检查
=======================================================
接口名称    : eth0
IP地址      : 10.0.20.5/22
MAC地址     : 52:54:00:fd:e4:45
连接速度    : Unknown!
连接状态    : UP
=======================================================

====== 检查完成 ======
[root@VM-20-5-opencloudos ~]# vim 11.sh
[root@VM-20-5-opencloudos ~]# cat 11.sh
#!/bin/bash
# 设置颜色变量
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 重置颜色

# 生成分隔线
separator() {
    echo -e "${BLUE}=======================================================${NC}"
}

# 获取操作系统信息
get_os_info() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$PRETTY_NAME"
    elif type lsb_release >/dev/null 2>&1; then
        lsb_release -ds
    else
        echo "Unknown"
    fi
}

# 系统基本信息检查
system_info() {
    echo -e "\n${GREEN}>>> 系统基本信息检查${NC}"
    separator
    echo "主机名        : $(hostname)"
    echo "操作系统版本  : $(get_os_info)"
    echo "内核版本      : $(uname -r)"
    echo "系统运行时间  : $(uptime | awk -F, '{print $1}' | cut -d' ' -f2-)"
}

# CPU检查
cpu_check() {
    echo -e "\n${GREEN}>>> CPU检查${NC}"
    separator
    echo "CPU型号       : $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
    echo "物理核心数    : $(lscpu | grep 'Core(s)' | head -1 | awk '{print $4}')"
    echo "逻辑核心数    : $(nproc)"
    echo "当前负载      : $(uptime | awk -F 'average:' '{print $2}' | xargs)"
}

# 内存检查
memory_check() {
    echo -e "\n${GREEN}>>> 内存检查${NC}"
    separator
    free -h | awk '
        /Mem/{
            print "总内存      : " $2
            print "已用内存    : " $3
            print "可用内存    : " $7
        }
        /Swap/{
            print "交换分区    : " $2
            print "已用交换    : " $3
        }'
}

# 硬盘检查
disk_check() {
    echo -e "\n${GREEN}>>> 硬盘检查${NC}"
    separator
    df -h | awk '
        BEGIN {
            print "挂载点\t\t总大小\t已用\t可用\t使用率"
        }
        /^\/dev/ {
            printf "%-15s %-6s %-6s %-6s %-4s\n", $6, $2, $3, $4, $5
        }' | column -t
}

# 网卡检查
network_check() {
    echo -e "\n${GREEN}>>> 网络接口检查${NC}"
    separator
    for interface in $(ip -o link show | awk -F': ' '{print $2}' | grep -v lo); do
        echo "接口名称    : $interface"
        echo "IP地址      : $(ip -o -4 addr show $interface 2>/dev/null | awk '{print $4}')"
        echo "MAC地址     : $(ip link show $interface | awk '/link\/ether/ {print $2}')"
        
        # 速度检测兼容性处理
        if command -v ethtool >/dev/null 2>&1; then
            speed=$(ethtool $interface 2>/dev/null | grep Speed | awk '{print $2}')
            echo "连接速度    : ${speed:-N/A}"
        else
            echo "连接速度    : 需要 ethtool 支持"
        fi
        
        echo "连接状态    : $(ip link show $interface | grep -o 'state [A-Z]*' | awk '{print $2}')"
        separator
    done
}

# 主函数
main() {
    clear
    echo -e "\n${YELLOW}====== 开始系统检查 ======${NC}"

    system_info
    cpu_check
    memory_check
    disk_check
    network_check

    echo -e "\n${YELLOW}====== 检查完成 ======${NC}"
}

# 执行主函数
main
[root@VM-20-5-opencloudos ~]# wq
-bash: wq: command not found
[root@VM-20-5-opencloudos ~]# vim 11.sh 
[root@VM-20-5-opencloudos ~]# reboot
[root@VM-20-5-opencloudos ~]# Connection to 81.71.17.50 closed by remote host.
Connection to 81.71.17.50 closed.
ldx@syn-172-254-222-147 ~ % yum install nginx
zsh: command not found: yum
ldx@syn-172-254-222-147 ~ % ssh -p 62222 app@81.71.17.50
ssh: connect to host 81.71.17.50 port 62222: Connection refused
ldx@syn-172-254-222-147 ~ % ssh -p 62222 app@81.71.17.50
Last login: Fri Mar 28 09:00:13 2025 from 121.35.244.73
[app@VM-20-5-opencloudos ~]$ su - root
Password: 
Last login: Fri Mar 28 09:00:33 CST 2025 on pts/0
[root@VM-20-5-opencloudos ~]# vim 88.sh
[root@VM-20-5-opencloudos ~]# bash 88.sh
使用方法: 88.sh <新SSH端口>
[root@VM-20-5-opencloudos ~]# bash 88.sh 62222
Failed to restart ssh.service: Unit ssh.service not found.
[root@VM-20-5-opencloudos ~]# systemctl restart sshd
[root@VM-20-5-opencloudos ~]# vim 88.sh
[root@VM-20-5-opencloudos ~]# bash 88.sh 
使用方法: 88.sh <新SSH端口>
[root@VM-20-5-opencloudos ~]# bash 88.sh 62222
====================================================
SSH配置已成功更新！
----------------------------------------------------
新SSH端口：62222
Root远程登录：已禁用
密钥认证：已启用
密码登录：已禁用
====================================================
重要提示：
1. 请确保已正确配置以下内容：
   - 防火墙开放新端口 62222
   - SELinux策略调整（如启用）
   - SSH密钥已添加到目标用户的 ~/.ssh/authorized_keys 文件
2. 配置文件备份：/etc/ssh/sshd_config.bak
3. 建议保持当前会话打开并新开窗口测试连接
====================================================
[root@VM-20-5-opencloudos ~]# vim 88.sh 
[root@VM-20-5-opencloudos ~]# systemctl status sshd.service  # 或 ssh.service
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
     Active: active (running) since Fri 2025-03-28 10:02:52 CST; 3min 31s ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 4382 (sshd)
      Tasks: 1 (limit: 4342)
     Memory: 1.4M (peak: 1.7M)
        CPU: 18ms
     CGroup: /system.slice/sshd.service
             └─4382 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Mar 28 10:02:52 VM-20-5-opencloudos systemd[1]: Starting sshd.service - OpenSSH server daemon...
Mar 28 10:02:52 VM-20-5-opencloudos (sshd)[4382]: sshd.service: Referenced but unset environment variable evaluates to an empty string: OPTIONS
Mar 28 10:02:52 VM-20-5-opencloudos sshd[4382]: Server listening on 0.0.0.0 port 62222.
Mar 28 10:02:52 VM-20-5-opencloudos sshd[4382]: Server listening on :: port 62222.
Mar 28 10:02:52 VM-20-5-opencloudos systemd[1]: Started sshd.service - OpenSSH server daemon.
[root@VM-20-5-opencloudos ~]# vim 88.sh 


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
echo "===================================================="                                                                                                                                 86,1          Bot
