# Minikube:
1. Take VM with at least t2.medium. I am taking RHEL EC2 

2. Update System Packages (it will take few minutes to complete)
```
sudo yum update -y
```
3. Install Docker. Docker client shoulld be installed in the EC2.
```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
```
4. Start Docker
```
sudo systemctl start docker
sudo systemctl enable docker
docker --version
```
5.  Kubctl. It should installed in EC2. kubectl is a CLI for MiniKube Control Plane. (Ignore if already installed)
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

Check: 
```
kubectl version --client
```

6. Minikube. Install minikube to get Cluster with Master and Node Componenets.
```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
```
Version:
```
minikube version
```

Note: Logout and Login again for better results. (restarts all processes)

7. AWS EC2 does not support nested virtualization, we will use the Docker driver
```
minikube start --driver=docker
```

```
minikube status
kubectl get nodes
```

Test:
```
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --type=NodePort --port=80
```

Service:
```
kubectl get svc nginx
minikube service nginx --url
```

