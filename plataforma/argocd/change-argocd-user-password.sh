# This will prompt for the current password. The current password will be the password for the user logged in. In this case, is the admin user.
adminpassword=$(kubectl get secrets -n continuous-delivery argocd-initial-admin-secret -o json | jq -r ".data.password" | base64 -d)
userpassword=$(dd if=/dev/urandom bs=1 count=16 2>/dev/null | base64)
argocd login localhost:8080 --insecure --username admin --password $adminpassword
argocd account update-password --account $1 --current-password $adminpassword --new-password $userpassword

