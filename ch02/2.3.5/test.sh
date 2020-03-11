# RUN PING COMMAND
kubectl run -it --rm busybox --image=busybox -- ping www.shmtu.edu.cn

# RUN CURL COMMAND
kubectl run -it --rm busybox --image=busybox -- curl https://www.shmtu.edu.cn
