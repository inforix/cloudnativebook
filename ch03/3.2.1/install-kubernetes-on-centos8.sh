# Prepare on CentOS 8

Completed script:

```
# Set Hostname
hostnamectl set-hostname k8sdev.shmtu.edu.cn

# Disable SELinux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# Configure Firewall
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10251/tcp
firewall-cmd --permanent --add-port=10252/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --reload

modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

# 配置网络
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

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

# Install related componenets
dnf -y install ipvsadm kubelet kubeadm kubectl wget vim
systemctl enable kubelet

# Install docker ce version
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

dnf -y install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.13-3.1.el7.x86_64.rpm
dnf -y install docker-ce

systemctl enable docker
systemctl start docker

# Configure registry mirror
cat <<EOF > /etc/docker/daemon.json
{
	"registry-mirrors":[
		"https://repo.shmtu.edu.cn"
	]
}
EOF

systemctl restart docker

# Init master
# The file kubeadm.yaml should created before this command
kubeadm init --config kubeadm.yaml

# Install CNI plugin, I installed weave net here.
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever

# Enable bash completion
yum install -y bash-completion
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo "alias k=kubectl" >> ~/.bashrc
echo "complete -F __start_kubectl k" >> ~/.bashrc
```

We suggest reboot centos after this script.
