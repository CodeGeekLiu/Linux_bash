<!DOCTYPE html>
<html>
<head>
<style>
    body {font-family: Arial, sans-serif; line-height: 1.6; max-width: 800px; margin: 20px auto}
    .script-box {border: 1px solid #e1e4e8; border-radius: 6px; padding: 16px; margin: 20px 0}
    .warning {background: #fff3cd; border-left: 4px solid #ffc107; padding: 12px; margin: 15px 0}
    code {background: #f6f8fa; padding: 2px 5px; border-radius: 3px}
    pre {background: #f6f8fa; padding: 12px; border-radius: 6px; overflow-x: auto}
    h2 {color: #0366d6; border-bottom: 1px solid #eaecef}
    .output {color: #22863a}
</style>
</head>
<body>

<h1>🔧 Linux Utility Scripts</h1>

<div class="script-box">
    <h2>1. Linux Host Check Script</h2>
    <p>快速获取并检查 Linux 主机状态</p>
    
    <h3>🚀 功能特性</h3>
    <ul>
        <li>系统基础信息 (主机名/发行版/内核版本)</li>
        <li>资源使用情况 (CPU/内存/磁盘)</li>
        <li>服务状态监控 (SSH/防火墙/关键进程)</li>
        <li>网络连接状态检查</li>
    </ul>

    <h3>🖥️ 使用方式</h3>
    <pre><code>bash host_check.sh</code></pre>

    <h3>📊 示例输出</h3>
    <pre class="output">
[System Info]
Hostname:   myserver
OS:         CentOS Linux 7.9.2009
Kernel:     3.10.0-1160.el7.x86_64
Uptime:     15 days 2 hours

[CPU Usage]   15%
[Memory Usage] 2.3/3.8 GB (61%)</pre>
</div>

<div class="script-box">
    <h2>2. SSH Security Hardening Script</h2>
    <p>SSH 服务安全加固工具</p>

    <h3>🔒 配置变更</h3>
    <pre>
Port <span style="color:red">$NEW_PORT</span>
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no</pre>

    <div class="warning">
        <h3>⚠️ 重要注意事项</h3>
        <ul>
            <li>前置条件检查：
                <ul>
                    <li>防火墙需开放端口 <code>$NEW_PORT</code></li>
                    <li>SELinux 策略调整 (如启用)</li>
                    <li>SSH 公钥需已部署到 <code>~/.ssh/authorized_keys</code></li>
                </ul>
            </li>
            <li>配置文件备份位置：<code>/etc/ssh/sshd_config.bak</code></li>
            <li>建议保持当前会话测试新连接</li>
        </ul>
    </div>

    <h3>⚡ 使用方式</h3>
    <pre><code>bash modify_ssh.sh &lt;ssh_port&gt;</code></pre>
    <p>示例：</p>
    <pre><code># 设置 SSH 端口为 62222
bash modify_ssh.sh 62222</code></pre>

    <h3>🛠️ 故障恢复</h3>
    <pre><code>cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
systemctl restart sshd</code></pre>
</div>

</body>
</html>
