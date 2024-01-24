## 1. Instalación minikube en WSL

https://minikube.sigs.k8s.io/docs/start/

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

```powershell
minikube start --cni=calico --nodes=2 --cpus=4 --memory=6GB
minikube addons enable ingress
minikube addons enable storage-provisioner
minikube addons enable metrics-server

minikube service argocd-server -n argocd --url

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | %{[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($_))}


# MiniLab ArgoCD con KinD

## Crear cluster KinD con archivo de configuración
```
kind create cluster --name minilab --config .\kind-minilab-config.yaml
```

## Instalar ingress-nginx

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl create ns argocd
kubect apply -f ./argocd/install -n argocd

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
