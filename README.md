# Instalación minikube

https://minikube.sigs.k8s.io/docs/start/

```powershell
minikube start --cni=calico
minikube addons enable ingress
minikube addons enable ingress-dns
minikube addons enable metrics-server
```