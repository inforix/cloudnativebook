# set hostname
hostnamectl set-hostname k8s-master.shmtu.edu.cn

# 禁用交换分区
swapoff -a 
sed -i 's/.*swap.*/#&/' /etc/fstab

# 禁用防火墙
systemctl stop firewalld
systemctl disable firewalld

# 禁用SELinux
setenforce  0 
sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config 

# 配置时间同步
yum -y install ntpdate
systemctl enable ntpdate.service
echo '*/30 * * * * /usr/sbin/ntpdate time7.aliyun.com >/dev/null 2>&1' > /tmp/crontab2.tmp
crontab /tmp/crontab2.tmp
systemctl start ntpdate.service

# 配置网络
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

modprobe br_netfilter
sysctl -p /etc/sysctl.d/99-kubernetes-cri.conf

# 配置阿里云仓库
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg 
       https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# 系统限制
echo "* soft nofile 65536" >> /etc/security/limits.conf
echo "* hard nofile 65536" >> /etc/security/limits.conf
echo "* soft nproc 65536"  >> /etc/security/limits.conf
echo "* hard nproc 65536"  >> /etc/security/limits.conf
echo "* soft  memlock  unlimited"  >> /etc/security/limits.conf
echo "* hard memlock  unlimited"  >> /etc/security/limits.conf

# 安装必需的Yum包
yum -y install epel-release
yum -y install yum-utils device-mapper-persistent-data lvm2 net-tools wget vim bind-util

# 安装IPVS
yum -y install ipvsadm

# 添加Docker仓库
yum-config-manager \
  --add-repo \
  https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo 

# 安装Docker
yum -y install docker-ce docker-ce-cli containerd

# 首先创建/etc/docker目录
mkdir /etc/docker

# 修改cgoupdriver为systemd
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ],
  "registry-mirrors": [
    "https://registry.cn-hangzhou.aliyuncs.com"
  ]
}
EOF

# 创建docker服务的配置目录
#mkdir -p /etc/systemd/system/docker.service.d
# 添加代理服务器和无代理信息
#cat > /etc/systemd/system/docker.service.d/proxy.conf <<EOF
#[Service]
#Environment="HTTP_PROXY=http://10.81.38.5:8443/" "HTTPS_PROXY=http://10.81.38.5:8443/" "NO_PROXY=localhost,127,0.0.1,.shmtu.edu.cn,10."
#EOF

# 重启Docker
systemctl daemon-reload
systemctl enable docker
systemctl restart docker

# 安装kubelet、kubeadm和kubectl包
yum -y install kubelet kubeadm kubectl
systemctl enable kubelet

# 启用Bash自动完成
yum install -y bash-completion
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo "alias k=kubectl" >> ~/.bashrc
echo "complete -F __start_kubectl k" >> ~/.bashrc
