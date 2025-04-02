# 🔧 Linux Utility Scripts

---

## 1. Linux_Host_Check_Script

### 🚀 功能特性
```text
▸ 系统基础信息 (主机名/发行版/内核版本)
▸ 资源使用情况 (CPU/内存/磁盘)
▸ 服务状态监控 (SSH/防火墙/关键进程)
▸ 网络连接状态检查
```

### 🖥️ 使用方式
```bash
bash host_check.sh
```

### 📊 示例输出
```plaintext
[System Info]
Hostname:   myserver
OS:         CentOS Linux 7.9.2009
Kernel:     3.10.0-1160.el7.x86_64
Uptime:     15 days 2 hours

[CPU Usage]   15%
[Memory Usage] 2.3/3.8 GB (61%)
```

---

## 2. SSH Security Hardening Script

### 🔒 配置变更
```ini
# 修改后配置示例
Port <YOUR_PORT>
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
```

### ⚠️ 重要注意事项
```diff
! 前置条件检查：
  - 防火墙开放新端口:
    # Firewalld
+   firewall-cmd --permanent --add-port=<YOUR_PORT>/tcp

    # Iptables
+   iptables -A INPUT -p tcp --dport <YOUR_PORT> -j ACCEPT

  - SELinux 策略调整 (如启用):
+   semanage port -a -t ssh_port_t -p tcp <YOUR_PORT>
    
  - 密钥文件需存在于:
    ~/.ssh/authorized_keys
```

### ⚡ 使用方式
```bash
# 设置 SSH 端口为 62222
bash modify_ssh.sh 62222
```

### 🛠️ 故障恢复
```bash
# 紧急回滚命令
cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
systemctl restart sshd
```

---

## 📦 快速部署
```bash
# 下载脚本
wget https://github.com/CodeGeekLiu/Linux_bash/blob/main/Linux_host_check_script
wget https://github.com/CodeGeekLiu/Linux_bash/blob/main/modify_ssh.sh

# 授权执行
chmod +x *.sh
```

## 📌 使用提示
```text
1. 推荐使用 root 用户执行脚本
2. 修改 SSH 端口前请测试端口可用性
3. 执行加固脚本后请勿关闭当前会话！
```
