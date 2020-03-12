# 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml

#
kubectl -n kube-system edit service kubernetes-dashboard

# 修改以下内容

spec:
  externalTrafficPolicy: Cluster
  ports:
  - nodePort: 30443
    port: 443
    protocol: TCP
    targetPort: 8443
  selector:
    k8s-app: kubernetes-dashboard
  sessionAffinity: None
  type: NodePort
