# 选择下面其中一种方式
# 普通用户

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# root用户
cat >> ~/.bash_profile << EOF
export KUBECONFIG=/etc/kubernetes/admin.conf
EOF
[root@k8scli ~]# export KUBECONFIG=/etc/kubernetes/admin.conf
