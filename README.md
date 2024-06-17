# MiniLab InternalDevelopmentPlatform con ArgoCD

# Crear cluster con Minikube en Powershell con Podman instalado
>Para instalar Minikube:
>https://minikube.sigs.k8s.io/docs/start/

## Crear cluster con 2 nodos:
Lo creamos poniéndole nombre *minikube-idp-labs* al profile:
```ps
minikube start --profile minikube-idp-labs --driver podman --cni auto --nodes 2 --cpus 2 --memory 6GB --image-repository auto --addons=[ingress, metrics-server, storage-provisioner] 
# minikube addons enable ingress
# minikube addons enable storage-provisioner
# minikube addons enable metrics-server
```

## Instalar ArgoCD

https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd

```ps
kubectl apply -f plataforma/argocd/argocd-platform-ns.yaml
# o
kubectl create ns argocd-platform
```

> ¡OJO! Si se quiere instalar ArgoCD en un namespace diferente al de por defecto "argocd" hay que modificarlo también en dos líneas que hacen referencia al namespace de los recursos del clusterrolebinding en el "install.yaml". Si no, ArgoCD no podrá desplegar aplicaciones en el propio cluster kubernetes.

Se puede aplicar los manifiestos de ArgoCD manualmente:
```ps
kubectl apply -f plataforma/argocd/install.yaml -n argocd-platform
kubectl apply -f plataforma/argocd/argocd-cmd-params-cm.yaml -n argocd-platform
kubectl apply -f plataforma/argocd/argocd-cmd-params-cm.yaml -n argocd-platform
kubectl apply -f plataforma/argocd/argocd-ingress.yaml -n argocd-platform
```
>Después de aplicar el primer manifiesto de install.yml se puede aplicar el manifiesto de tipo ArgoCD Application para desplegar el resto de manifiestos tanto de ArgoCD como las herramientas de la plataforma.

```bash
kubectl apply -f plataforma/argocd/argocd-platform-bootstrap-project.yaml
```
Cuando esté levantado ArgoCD aplicamos el ArgoCD Project "plataforma-minilab" y poder sincronizar las aplicaciones de bootstrap como el propio ArgoCD, Hashicorp Vault, External Secrets, Cert-Manager y kube-prometheus-stack.

### Extraer la contraseña inicial de usuario admin de argocd:
```powershell
kubectl -n argocd-platform get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | %{[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($_))}
```
En bash:
```bash
kubectl -n argocd-platform get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Acceder a la UI de ArgoCD:

Hay que hacer portforwarding al servicio argocd-server:

Con minikube:
```
minikube service argocd-server -n argocd-platform --url
minikube service argocd-server -n argocd-platform --url -p minikube-idp-labs
```
o con kubectl:
```
kubectl port-forward service/argocd-server 8080:8080 -n argocd-platform
```

>Con k9s se puede hacer portforwarding del servicio argocd-server y entramos al login UI con localhost:8080

### Cambiar contraseña Admin




## Acceder con Ingress
### Instalar ingress-nginx
>Hay dificultades de que funcione con minikube en windows y podman desde wsl2, pendiente de investigar una configuración de ingress-nginx para cargar bien los servicios en navegador windows, minikube tunnel no funciona como no sea con permisos de administrador para usar puertos inferiores a 1024.

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

Se accede a la UI de ArgoCD con la url http://localhost/argocd/






```
kubectl -n argocd-platform get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | %{[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($_))}
```








## Notas
### Instalar Docker Engine en Ubuntu
https://docs.docker.com/engine/install/ubuntu/
https://docs.docker.com/engine/install/linux-postinstall/


### Docker Rootless mode en WSL Ubuntu
https://docs.docker.com/engine/security/rootless/#how-it-works


## Usando KinD
### Crear cluster KinD con archivo de configuración

```bash
kind create cluster --name minilab --config plataforma/kind-minilab-config.yaml
```

