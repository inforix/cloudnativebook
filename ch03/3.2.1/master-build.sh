
# 1.1 这种方法已经逐渐被淘汰了
kubeadm init   --kubernetes-version v1.14.0 \
               --pod-network-cidr 10.244.0.0/16 \
               --image-repository registry.aliyuncs.com/google_containers

# 1.2 建议使用该方法
kubeadm init --config kubeconfig.yaml

# Step 2 Configuration kubelet environment
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Step 3 Install CNI Plugin
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Step 4 Check master status, It is ready if the status equal "Ready"
kubectl get node

# Step 5 Join work nodes, in next script
