setenforce  0 
sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config 

yum -y install ntpdate
systemctl enable ntpdate.service
echo '*/30 * * * * /usr/sbin/ntpdate time7.aliyun.com >/dev/null 2>&1' > /tmp/crontab2.tmp
crontab /tmp/crontab2.tmp
systemctl start ntpdate.service

echo "* soft nofile 65536" >> /etc/security/limits.conf
echo "* hard nofile 65536" >> /etc/security/limits.conf
echo "* soft nproc 65536"  >> /etc/security/limits.conf
echo "* hard nproc 65536"  >> /etc/security/limits.conf
echo "* soft  memlock  unlimited"  >> /etc/security/limits.conf
echo "* hard memlock  unlimited"  >> /etc/security/limits.conf

yum -y install epel-release
yum -y install yum-utils device-mapper-persistent-data lvm2 net-tools wget vim bind-utils

yum -y install docker
systemctl enable docker
systemctl start docker


mkdir -p /etc/systemd/system/docker.service.d

# 设置内网HTTP代理服务器
cat > /etc/systemd/system/docker.service.d/proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=http://10.81.38.5:8443/" "HTTPS_PROXY=http://10.81.38.5:8443/" "NO_PROXY=localhost,127,0.0.1,.shmtu.edu.cn,10."
EOF

systemctl restart docker


yum install -y bash-completion
source /usr/share/bash-completion/bash_completion


