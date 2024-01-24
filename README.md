# MiniLab ArgoCD con KinD

## Crear cluster KinD con archivo de configuración

```bash
kind create cluster --name minilab --config plataforma/kind-minilab-config.yaml
```

## Instalar ingress-nginx

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

## Instalar ArgoCD

```bash
kubectl apply -f plataforma/argocd/cd-platform-ns.yaml
kubectl apply -f plataforma/argocd/install.yaml -n cd-platform
kubectl apply -f plataforma/argocd/argocd-cmd-params-cm.yaml -n cd-platform
kubectl apply -f plataforma/argocd/argocd-ingress.yaml -n cd-platform
kubectl apply -f plataforma/argocd/argocd-platform-bootstrap.yaml #Para crear el ArgoCD Project "plataforma-minilab" y poder sincronizar las aplicaciones de bootstrap.

```

Para sacar la contraseña inicial de usuario admin de argocd:

```bash
kubectl -n cd-platform get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Se accede a la UI de ArgoCD con la url http://localhost/argocd/


## minikube en WSL

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
```