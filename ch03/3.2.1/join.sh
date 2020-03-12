# 产生token，只需要在Master节点上操作。
kubeadm token create --print-join-command

# 加入到Kubernetes
kubeadm join 10.81.38.220:6443 --token jj7uh6.8f14gkb7fak7bpbu \
    --discovery-token-ca-cert-hash sha256:927757e1c4dc236ecb0e1c9a84e0f2aae91037f84c5863edc9cc2d01e4e617d9 


