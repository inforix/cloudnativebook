# 这种方法已经逐渐被淘汰了
kubeadm init   --kubernetes-version v1.14.0 \
               --pod-network-cidr 10.244.0.0/16 \
               --image-repository registry.aliyuncs.com/google_containers

# 2. 建议使用该方法
kubeadm init --config kubeconfig.yaml
