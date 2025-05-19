# Start minikube in windows

1. Open Docker desktop engine or if not soqnloaded plese download docker desktop for windows

2. Start minikube with dokcer
```
minikube start --driver=docker

kubectl get pods -n kube-system
```

3. create argicd namespace
```
kubectl create namespace argocd
```

4. Open argocd docs() webpage, theee you have these steps:
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
```
kubectl get pods -n argocd
```
```
kubectl get secrets -n argocd
```

5. Take secrets (password to login argocd UI)
```
kubectl edit secret argocd-initial-admin-secret -n argocd
```
```
echo YXY3OGVBQ2JxdHdvOEszUg== | base64 --decode
```

```
minikube service argocd-server -n argocd
```

```
|-----------|---------------|-------------|---------------------------|
| NAMESPACE |     NAME      | TARGET PORT |            URL            |
|-----------|---------------|-------------|---------------------------|
| argocd    | argocd-server | http/80     | http://192.168.49.2:31881 |
|           |               | https/443   | http://192.168.49.2:30797 |
|-----------|---------------|-------------|---------------------------|
* Starting tunnel for service argocd-server.
|-----------|---------------|-------------|------------------------|
| NAMESPACE |     NAME      | TARGET PORT |          URL           |
|-----------|---------------|-------------|------------------------|
| argocd    | argocd-server |             | http://127.0.0.1:59915 |
|           |               |             | http://127.0.0.1:59916 |
|-----------|---------------|-------------|------------------------|

```

6. Take URL and Browse the Argocd UI
```
http://127.0.0.1:59915
```

