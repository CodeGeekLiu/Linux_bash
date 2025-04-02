# Linux_bash
Linux utility script！
1、Linux host check script    is a script to quickly get and check the status of Linux host system! 
  Usage: bash script_name


2、Modify_ssh.sh    mainly modifies the ssh file to realize the following functions!
  "----------------------------------------------------"
  "new SSH port: $NEW_PORT"
  "Root Remote Login: Disabled"
  "Key Authentication: Enabled"
  "Password login: Disabled"
  "===================================================="
  "Important note:"
  "1. Please ensure that the following has been configured correctly:"
  "-Firewall opens new port $NEW_PORT"
  "-SELinux policy adjustment (if enabled)"
  "-SSH key has been added to the target user's ~/.ssh/authorized_keys file"
  
  "2. Configuration file backup: /etc/ssh/sshd_config.bak"
  
  "3. It is recommended to keep the current session open and open a new window to test the connection"
  
  Usage: bash script_name ssh_port
